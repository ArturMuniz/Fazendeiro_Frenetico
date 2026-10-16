extends Control
class_name TouchJoystick

## Joystick virtual simples baseado em toque.
## Anexe este script ao Control "VirtualJoystick" que contém
## os filhos "Base" e "Handle" (podem ser ColorRect como
## placeholder, ou TextureRect quando trocar pela arte final).

@export var joystick_radius: float = 60.0

@onready var base: Control = $Base
@onready var handle: Control = $Handle

var _touch_index: int = -1
var _output: Vector2 = Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	PauseManager.state_changed.connect(_on_pause_state_changed)
	base.modulate.a = 0
	handle.modulate.a = 0
	reset_input()


func _input(event: InputEvent) -> void:
	if get_tree().paused:
		reset_input()
		return
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 and base.get_global_rect().has_point(event.position):
			_touch_index = event.index
			_update_handle(event.position)
		elif not event.pressed and event.index == _touch_index:
			reset_input()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_handle(event.position)


func _update_handle(global_pos: Vector2) -> void:
	var center: Vector2 = base.get_global_rect().get_center()
	var delta: Vector2 = global_pos - center
	var clamped: Vector2 = delta.limit_length(joystick_radius)
	handle.position = base.position + (base.size - handle.size) / 2.0 + clamped
	_output = clamped / joystick_radius
	queue_redraw()


func _reset_handle() -> void:
	handle.position = base.position + (base.size - handle.size) / 2.0
	queue_redraw()


func _draw() -> void:
	if not is_instance_valid(base) or not is_instance_valid(handle):
		return
	var center := base.position + base.size / 2.0
	var ring := GameArt.ui("joystick_base")
	var knob := GameArt.ui("joystick_knob")
	draw_texture_rect(ring, Rect2(center - Vector2.ONE * joystick_radius, Vector2.ONE * joystick_radius * 2), false, Color(1, 1, 1, 0.8))
	draw_texture_rect(knob, Rect2(handle.position, handle.size), false)


func reset_input() -> void:
	_touch_index = -1
	_output = Vector2.ZERO
	_reset_handle()


func _on_pause_state_changed(_state: int) -> void:
	reset_input()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and is_node_ready():
		reset_input()


## Retorna um vetor de -1 a 1 em cada eixo, representando a direção do toque.
func get_vector() -> Vector2:
	return Vector2.ZERO if get_tree().paused else _output
