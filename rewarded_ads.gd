extends Node

## Only an earned-reward event authorizes a reward. Closing an ad never does.
signal availability_changed
signal reward_finished(request_id: int, earned: bool, message: String)
enum State { UNAVAILABLE, READY, LOADING, SHOWING, FINISHING }
var state: State = State.UNAVAILABLE
var provider: Node
var _serial: int = 0
var _active: int = 0
var _earned: bool = false
var _owner: WeakRef
var _owner_cleanup: Callable
var _watchdog: Timer
var is_demo: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_watchdog = Timer.new()
	_watchdog.one_shot = true
	_watchdog.ignore_time_scale = true
	add_child(_watchdog)
	_watchdog.timeout.connect(_on_timeout)
	is_demo = OS.is_debug_build() and "--demo-rewarded-ads" in OS.get_cmdline_user_args()
	if is_demo:
		set_provider(load("res://rewarded_demo_provider.gd").new())
	elif OS.has_feature("android") and Engine.has_singleton("PoingGodotAdMobRewardedAd"):
		set_provider(load("res://rewarded_admob_provider.gd").new())

func set_provider(next: Node) -> void:
	# Test/demo injection never grants a production Android reward by itself.
	if is_instance_valid(provider):
		provider.queue_free()
	provider = next
	add_child(provider)
	provider.available.connect(_on_available)
	provider.shown.connect(_on_shown)
	provider.earned.connect(_on_earned)
	provider.closed.connect(_on_closed)
	provider.failed.connect(_on_failed)
	provider.start()

func _on_available() -> void:
	if _active == 0:
		state = State.READY
	availability_changed.emit()

func is_available() -> bool:
	return state == State.READY and is_instance_valid(provider)

func status_text() -> String:
	if is_demo:
		return "Simulação de anúncio · apenas nesta versão de teste"
	return "Anúncio recompensado disponível" if is_available() else "Anúncio indisponível no momento"

func request_reward(owner: Node, placement: String) -> int:
	if not is_available() or not is_instance_valid(owner) or not owner.is_inside_tree():
		return 0
	if placement not in ["revive", "double_gold"]:
		return 0
	_serial += 1
	_active = _serial
	_owner = weakref(owner)
	_earned = false
	state = State.LOADING
	var token := _active
	_owner_cleanup = _cancel_owner.bind(token)
	owner.tree_exiting.connect(_owner_cleanup, CONNECT_ONE_SHOT)
	PauseManager.acquire(self, &"advertisement")
	AudioManager.suspend_for_ad(true)
	_watchdog.start(25.0)
	provider.call_deferred("show_rewarded", token)
	availability_changed.emit()
	return token

func _valid(token: int) -> bool:
	return token != 0 and token == _active and _owner != null and is_instance_valid(_owner.get_ref()) and _owner.get_ref().is_inside_tree()

func _on_shown(token: int) -> void:
	if _valid(token):
		state = State.SHOWING
		_watchdog.start(300.0)

func _on_earned(token: int) -> void:
	if _valid(token) and state in [State.SHOWING, State.FINISHING]:
		_earned = true

func _on_closed(token: int) -> void:
	if not _valid(token):
		return
	state = State.FINISHING
	# Drain deferred SDK callbacks before assessing the earned event.
	await get_tree().process_frame
	await get_tree().process_frame
	if _valid(token):
		_finish(token, _earned, "Recompensa confirmada." if _earned else "Anúncio encerrado sem recompensa.")

func _on_failed(token: int, message: String) -> void:
	if _valid(token):
		_finish(token, false, message)

func _on_timeout() -> void:
	if _active != 0:
		_finish(_active, false, "O anúncio não respondeu. Tente novamente mais tarde.")

func _cancel_owner(token: int) -> void:
	if token == _active:
		_finish(token, false, "Tela encerrada.", false)

func _finish(token: int, earned: bool, message: String, notify: bool = true) -> void:
	if token == 0 or token != _active:
		return
	var owner: Node = _owner.get_ref() if _owner != null else null
	if is_instance_valid(owner) and owner.tree_exiting.is_connected(_owner_cleanup):
		owner.tree_exiting.disconnect(_owner_cleanup)
	_active = 0
	_owner = null
	_earned = false
	_watchdog.stop()
	if is_instance_valid(provider):
		provider.cancel(token)
	state = State.READY if is_instance_valid(provider) else State.UNAVAILABLE
	AudioManager.suspend_for_ad(false)
	PauseManager.release(self)
	availability_changed.emit()
	if notify:
		reward_finished.emit(token, earned, message)
