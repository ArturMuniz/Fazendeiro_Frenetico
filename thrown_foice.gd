extends Area2D
class_name ThrownFoice

## A foice em si depois de arremessada: viaja até a posição alvo e,
## ao chegar, fica girando no local por um tempo, causando dano em
## pulsos a quem estiver no raio.

@export var travel_speed: float = 500.0
@export var tick_interval: float = 0.15
@export var spin_rotation_speed: float = 22.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

var _damage: float = 0.0
var _target_pos: Vector2 = Vector2.ZERO
var _traveling: bool = true
var _spin_duration: float = 0.6
var _tick_timer: Timer


func _ready() -> void:
	shape.shape = shape.shape.duplicate()


func setup(target_pos: Vector2, damage: float, radius: float, spin_duration: float, icon_texture: Texture2D) -> void:
	_target_pos = target_pos
	_damage = damage
	_spin_duration = spin_duration
	(shape.shape as CircleShape2D).radius = radius
	if icon_texture != null:
		sprite.texture = icon_texture
		sprite.modulate = Color(1, 1, 1)
		sprite.scale = Vector2.ONE * minf(1.0, 44.0 / icon_texture.get_size().length())
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _physics_process(delta: float) -> void:
	if _traveling:
		var to_target: Vector2 = _target_pos - global_position
		var step: float = travel_speed * delta
		if to_target.length() <= step:
			global_position = _target_pos
			_traveling = false
			_start_spin()
		else:
			global_position += to_target.normalized() * step
			rotation = to_target.angle()
	else:
		rotation += spin_rotation_speed * delta


func _start_spin() -> void:
	_tick_timer = Timer.new()
	_tick_timer.wait_time = tick_interval
	add_child(_tick_timer)
	_tick_timer.timeout.connect(_on_tick)
	_tick_timer.start()
	_on_tick()
	var lifetime_timer := Timer.new()
	lifetime_timer.one_shot = true
	add_child(lifetime_timer)
	lifetime_timer.timeout.connect(queue_free)
	lifetime_timer.start(_spin_duration)


func _on_tick() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(_damage)
