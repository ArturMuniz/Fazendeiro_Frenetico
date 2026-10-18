extends Node

## Único escritor de SceneTree.paused. Cada modal possui seu bloqueio.
signal state_changed(state: int)
enum State { RUNNING, MODAL, TRANSITION }
const PRIORITY := {&"pause": 40, &"level_up": 60, &"victory": 80, &"results": 100, &"advertisement": 150, &"focus": 200}

var state: int = State.RUNNING
var _owners: Dictionary = {}
var _transitioning: bool = false
var _active_id: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func acquire(owner: Node, reason: StringName) -> void:
	if not is_instance_valid(owner) or not owner.is_inside_tree():
		return
	var id := owner.get_instance_id()
	_owners[id] = {"owner": weakref(owner), "priority": PRIORITY.get(reason, 0)}
	var cleanup := _release_id.bind(id)
	if not owner.tree_exiting.is_connected(cleanup):
		owner.tree_exiting.connect(cleanup, CONNECT_ONE_SHOT)
	_sync()


func release(owner: Node) -> void:
	if is_instance_valid(owner):
		_release_id(owner.get_instance_id())


func _release_id(id: int) -> void:
	_owners.erase(id)
	_sync()


func is_active(owner: Node) -> bool:
	return not _transitioning and is_instance_valid(owner) and owner.get_instance_id() == _active_id


func can_open_pause_menu() -> bool:
	return state == State.RUNNING


func _sync() -> void:
	_active_id = 0
	var highest: int = -1
	for id in _owners.keys():
		var owner: Node = _owners[id]["owner"].get_ref()
		if not is_instance_valid(owner) or not owner.is_inside_tree():
			_owners.erase(id)
			continue
		if int(_owners[id]["priority"]) > highest:
			highest = _owners[id]["priority"]
			_active_id = id
	var next_state: int = State.TRANSITION if _transitioning else (State.MODAL if not _owners.is_empty() else State.RUNNING)
	get_tree().paused = next_state != State.RUNNING
	for id in _owners:
		var owner: Node = _owners[id]["owner"].get_ref()
		if owner is CanvasLayer:
			owner.visible = not _transitioning and id == _active_id
	if state != next_state:
		state = next_state
		state_changed.emit(state)


func change_scene(path: String) -> void:
	if _transitioning:
		return
	_transitioning = true
	_sync()
	call_deferred("_perform_scene_change", path)


func _perform_scene_change(path: String) -> void:
	var error := get_tree().change_scene_to_file(path)
	if error != OK:
		_transitioning = false
		_sync()
		push_error("Falha ao abrir %s: %s" % [path, error_string(error)])
		return
	await get_tree().scene_changed
	_transitioning = false
	_sync()


func _notification(what: int) -> void:
	if not is_inside_tree():
		return
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if get_tree().get_first_node_in_group("player") != null:
			acquire(self, &"focus")
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		release(self)
