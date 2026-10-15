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
	_reset_handle()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 and base.get_global_rect().has_point(event.position):
			_touch_index = event.index
			_update_handle(event.position)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_output = Vector2.ZERO
			_reset_handle()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_handle(event.position)


func _update_handle(global_pos: Vector2) -> void:
	var center: Vector2 = base.get_global_rect().get_center()
	var delta: Vector2 = global_pos - center
	var clamped: Vector2 = delta.limit_length(joystick_radius)
	handle.position = (base.size / 2.0) - (handle.size / 2.0) + clamped
	_output = clamped / joystick_radius


func _reset_handle() -> void:
	handle.position = (base.size / 2.0) - (handle.size / 2.0)


## Retorna um vetor de -1 a 1 em cada eixo, representando a direção do toque.
func get_vector() -> Vector2:
	return _output
