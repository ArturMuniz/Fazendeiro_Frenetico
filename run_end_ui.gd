extends CanvasLayer
class_name RunEndUI
signal save_retry_requested
var _save_failed: bool = false
var _view: Dictionary
var _inventory: VBoxContainer
var _death_preview: SpriteAnimator
var _result_emblem: TextureRect

## Tela de fim de run: mostra um resumo da run (tempo, nível, abates,
## se derrotou o boss, moedas ganhas) e deixa jogar de novo direto
## ou voltar pro Hub.

var title_label: Label
var stats_label: Label
var retry_button: Button
var hub_button: Button
var revive_button: Button
var double_button: Button
var ad_status: Label
var _stats: Dictionary = {}
var _ad_request: int = 0
var _ad_placement: String = ""
var _authorized_reward: String = ""
var _reward_save_pending: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PanelContainer.hide()
	_view = RuralUI.shell(self, "Fim da partida", "Cada tentativa fortalece sua fazenda.")
	title_label = _view.title
	stats_label = RuralUI.label("", 28)
	var preview := Control.new()
	preview.custom_minimum_size.y = 144
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_view.body.add_child(preview)
	var figure := Sprite2D.new()
	figure.position = Vector2(60, 96)
	preview.add_child(figure)
	_death_preview = SpriteAnimator.new()
	preview.add_child(_death_preview)
	_death_preview.configure(SaveManager.selected_character, figure)
	figure.scale = Vector2.ONE * 1.5
	_result_emblem = RuralUI.picture("defeat_emblem", Vector2(80, 80))
	_result_emblem.position = Vector2(140, 24)
	preview.add_child(_result_emblem)
	var offers := RuralUI.card(_view.body)
	offers.add_child(RuralUI.label("UMA NOVA CHANCE", 22, RuralUI.GREEN))
	revive_button = RuralUI.button("Assistir anúncio para retornar", _request_reward.bind("revive"))
	revive_button.name = "RewardedRevive"
	offers.add_child(revive_button)
	double_button = RuralUI.button("Assistir anúncio · dobrar moedas", _request_reward.bind("double_gold"))
	double_button.name = "RewardedDoubleGold"
	offers.add_child(double_button)
	ad_status = RuralUI.label("", 20)
	offers.add_child(ad_status)
	_view.body.add_child(stats_label)
	_inventory = VBoxContainer.new()
	_view.body.add_child(_inventory)
	retry_button = RuralUI.button("Jogar novamente", _on_retry_pressed)
	hub_button = RuralUI.button("Voltar ao Hub", _on_hub_pressed)
	_view.footer.add_child(retry_button)
	_view.footer.add_child(hub_button)
	RewardedAds.reward_finished.connect(_on_ad_finished)
	RewardedAds.availability_changed.connect(_refresh_ad_buttons)


func show_results(stats: Dictionary) -> void:
	_stats = stats.duplicate(true)
	_result_emblem.texture = GameArt.ui("victory_emblem" if stats.get("victory", false) else "defeat_emblem")
	if not stats.get("victory", false) and _death_preview.state != "death":
		# UI-owned showcase plays while results pause gameplay. Rewards still
		# settle immediately; animation cannot trigger or postpone the payment.
		_death_preview.once("death")
	_save_failed = stats.get("save_failed", false)
	retry_button.text = "Tentar salvar novamente" if _save_failed else "Jogar novamente"
	hub_button.disabled = _save_failed
	title_label.text = "Vitória!" if stats.get("victory", false) else "Fim da partida"
	var boss_text: String = "Sim" if stats.get("boss_defeated", false) else "Não"
	stats_label.text = "Tempo sobrevivido: %s\nNível alcançado: %d\nInimigos derrotados: %d\nBoss derrotado: %s\n\nMoedas ganhas: %d" % [
		_format_time(stats.get("survival_time", 0.0)),
		stats.get("level", 1),
		stats.get("kills", 0),
		boss_text,
		stats.get("gold_earned", 0),
	]
	stats_label.text += "\nBônus já recebido: %d" % stats.get("gold_already_paid", 0)
	if _save_failed:
		stats_label.text = stats_label.text.replace("Moedas ganhas:", "Moedas já confirmadas:")
		stats_label.text += "\nPagamento do encerramento pendente.\nNão foi possível salvar. Tente novamente."
	else:
		stats_label.text += "\nCreditado agora: %d" % stats.get("gold_paid_now", stats.get("gold_earned", 0))
	stats_label.text += "\nSaldo permanente: %d" % SaveManager.gold
	var receipt: Dictionary = SaveManager.reward_receipts.get(str(stats.get("run_id", "")), {})
	if receipt.has("double"):
		stats_label.text += "\nAdicional do anúncio: %d\nTotal desta run: %d" % [int(receipt.double), int(stats.get("gold_earned", 0)) + int(receipt.double)]
	if stats.get("death_bonus", 0) > 0:
		stats_label.text += "\nInclui bônus de derrota após chefe: %d" % stats.death_bonus
	RuralUI.clear(_inventory)
	var player: Node = get_tree().get_first_node_in_group("player")
	if player != null:
		RuralUI.inventory(_inventory, player)
	PauseManager.acquire(self, &"results")
	_refresh_ad_buttons()


func _refresh_ad_buttons() -> void:
	if revive_button == null: return
	var player: Node = get_tree().get_first_node_in_group("player")
	var receipt: Dictionary = SaveManager.reward_receipts.get(str(_stats.get("run_id", "")), {})
	var busy := _ad_request != 0
	var available: bool = RewardedAds.is_available() or not _authorized_reward.is_empty()
	revive_button.visible = player != null and player.can_revive()
	revive_button.text = "Tentar salvar retorno" if _authorized_reward == "revive" else "Assistir anúncio · retornar\n%s" % _stats.get("checkpoint_label", "")
	double_button.visible = not receipt.has("double") and int(_stats.get("gold_earned", 0)) > 0
	double_button.text = "Tentar salvar moedas do anúncio" if _authorized_reward == "double_gold" else "Assistir anúncio · dobrar moedas da run"
	revive_button.disabled = busy or _save_failed or not available or (_reward_save_pending and _authorized_reward != "revive")
	double_button.disabled = busy or _save_failed or not available or (_reward_save_pending and _authorized_reward != "double_gold")
	retry_button.disabled = busy or _reward_save_pending
	hub_button.disabled = busy or _save_failed or _reward_save_pending
	if not _reward_save_pending:
		ad_status.text = "Preparando anúncio…" if busy else RewardedAds.status_text()
		ad_status.text += "\nRetorno: uma vez por partida. Dobrar moedas encerra a opção de retorno."


func _request_reward(placement: String) -> void:
	if not PauseManager.is_active(self) or _ad_request != 0 or _save_failed: return
	if not _authorized_reward.is_empty():
		if _authorized_reward == placement: _apply_authorized_reward()
		return
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or (placement == "revive" and not player.can_revive()): return
	var receipt: Dictionary = SaveManager.reward_receipts.get(player._run_id, {})
	if placement == "double_gold" and receipt.has("double"): return
	_ad_placement = placement
	_ad_request = RewardedAds.request_reward(self, placement)
	_refresh_ad_buttons()


func _on_ad_finished(token: int, earned: bool, message: String) -> void:
	if token != _ad_request or _ad_request == 0: return
	_ad_request = 0
	if earned:
		_authorized_reward = _ad_placement
		_apply_authorized_reward()
	else:
		_refresh_ad_buttons()
		ad_status.text = message + "\nVocê pode continuar sem assistir a anúncios."


func _apply_authorized_reward() -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or str(_stats.get("run_id", "")) != player._run_id: return
	_reward_save_pending = true
	_refresh_ad_buttons()
	if _authorized_reward == "revive":
		var success: bool = await player.revive_checkpoint()
		if success: return
	elif _authorized_reward == "double_gold":
		var result: Dictionary = SaveManager.double_run_reward(player._run_id)
		if result.ok:
			_authorized_reward = ""
			_reward_save_pending = false
			show_results(_stats)
			ad_status.text = "Moedas dobradas e salvas. Obrigado por apoiar a fazenda!"
			return
	ad_status.text = "Recompensa confirmada, mas não foi possível salvar.\nTente salvar novamente; não será necessário outro anúncio."
	_refresh_ad_buttons()


func _format_time(seconds: float) -> String:
	var total: int = int(seconds)
	var minutes: int = total / 60
	var secs: int = total % 60
	return "%d:%02d" % [minutes, secs]

func reveal_after_death(animator: SpriteAnimator) -> void:
	if animator.finished:
		return
	_view.root.hide()
	# A bound method is disconnected automatically if the scene is replaced.
	animator.completed.connect(_on_death_complete, CONNECT_ONE_SHOT)

func _on_death_complete(_state: String) -> void:
	_view.root.show()


func _on_retry_pressed() -> void:
	if _ad_request != 0 or _reward_save_pending: return
	if not PauseManager.is_active(self):
		return
	if _save_failed:
		save_retry_requested.emit()
		return
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://main.tscn")


func _on_hub_pressed() -> void:
	if _save_failed or _ad_request != 0 or _reward_save_pending:
		return
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://hub.tscn")
