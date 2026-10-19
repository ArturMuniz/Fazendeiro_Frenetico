extends Area2D
class_name EnemyProjectile

## Projétil disparado por inimigos (Mosca Atiradora, Boss) contra o
## jogador. Espelha o projectile.gd do jogador, só muda o alvo.
## Reaproveitado via Pool.

const POOL_SCENE_PATH: String = "res://enemy_projectile.tscn"

@export var lifetime: float = 3.0

var _direction: Vector2 = Vector2.RIGHT
var _speed: float = 200.0
var _damage: float = 4.0
var _despawning: bool = false
var _lifetime_timer: Timer


func _ready() -> void:
	collision_mask = 9
	body_entered.connect(_on_body_entered)
	_lifetime_timer = Timer.new()
	_lifetime_timer.one_shot = true
	add_child(_lifetime_timer)
	_lifetime_timer.timeout.connect(_despawn)


func setup(direction: Vector2, speed: float, damage: float) -> void:
	_direction = direction.normalized()
	_speed = speed
	_damage = damage
	rotation = _direction.angle()
	visible = true
	monitoring = true
	set_physics_process(true)
	_despawning = false
	var sprite := $Sprite2D as Sprite2D
	sprite.texture = GameArt.ui("projectile_enemy")
	sprite.modulate = Color.WHITE
	sprite.scale = Vector2.ONE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	_lifetime_timer.start(lifetime)


func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta


func _on_body_entered(body: Node2D) -> void:
	if _despawning or get_tree().paused:
		return
	if body.is_in_group("farm_obstacles"):
		_despawn()
		return
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(_damage)
		_despawn()


func _despawn() -> void:
	if _despawning:
		return
	_despawning = true
	_lifetime_timer.stop()
	set_physics_process(false)
	set_deferred("monitoring", false)
	visible = false
	call_deferred("_return_to_pool")


func _return_to_pool() -> void:
	if get_parent() != null:
		get_parent().remove_child(self)
	Pool.release(load(POOL_SCENE_PATH), self)
