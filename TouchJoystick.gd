extends Control
class_name TouchJoystick

## Joystick virtual simples baseado em toque.
## Anexe este script ao Control "VirtualJoystick" que contém
## os filhos "Base" e "Handle" (podem ser ColorRect como
## placeholder, ou TextureRect quando trocar pela arte final).

@export var joystick_radius: float = 96.0
@export_range(0.0, 0.3) var dead_zone: float = 0.08

@onready var base: Control = $Base
@onready var handle: Control = $Handle

var _touch_index: int = -1
var _output: Vector2 = Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	PauseManager.state_changed.connect(_on_pause_state_changed)
	get_viewport().size_changed.connect(_layout)
	_layout()
	base.modulate.a = 0
	handle.modulate.a = 0
	reset_input()


func _input(event: InputEvent) -> void:
	if get_tree().paused:
		reset_input()
		return
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 and base.get_global_rect().grow(16).has_point(event.position):
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
	var strength := clamped.length() / joystick_radius
	_output = clamped.normalized() * maxf(0.0, (strength - dead_zone) / (1.0 - dead_zone))
	queue_redraw()


func _reset_handle() -> void:
	handle.position = base.position + (base.size - handle.size) / 2.0
	queue_redraw()


## The entire thumb travel, including the knob, fits inside the safe area.
## Logical viewport units are mapped from the physical Android safe rectangle.
static func geometry(view: Vector2, safe: Rect2) -> Dictionary:
	var radius := minf(96.0, minf(safe.size.x, safe.size.y) * 0.135)
	var knob_size := radius * 0.8
	var reach := radius + knob_size / 2.0
	var center := safe.position + Vector2(reach + radius * 0.5, safe.size.y - reach - radius * 0.8)
	return {"radius": radius, "knob": knob_size, "center": center, "view": view}

func _layout() -> void:
	var view := get_viewport_rect().size
	var safe := Rect2(Vector2.ZERO, view)
	if OS.has_feature("android") or OS.has_feature("ios"):
		var physical := DisplayServer.get_display_safe_area()
		var window_size := Vector2(DisplayServer.window_get_size())
		if window_size.x > 0 and window_size.y > 0 and physical.size.x > 0:
			safe = Rect2(Vector2(physical.position) / window_size * view, Vector2(physical.size) / window_size * view)
	var layout := geometry(view, safe)
	joystick_radius = layout.radius
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	size = Vector2.ONE * joystick_radius * 2
	position = layout.center - size / 2
	base.position = Vector2.ZERO
	base.size = size
	handle.size = Vector2.ONE * layout.knob
	reset_input()


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
