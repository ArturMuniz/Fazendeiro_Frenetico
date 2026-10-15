extends Area2D
class_name EnemyProjectile

## Projétil disparado por inimigos (Mosca Atiradora, Boss) contra o
## jogador. Espelha o projectile.gd do jogador, só muda o alvo.
## Reaproveitado via Pool.

const SELF_SCENE: PackedScene = preload("res://enemy_projectile.tscn")

@export var lifetime: float = 3.0

var _direction: Vector2 = Vector2.RIGHT
var _speed: float = 200.0
var _damage: float = 4.0
var _use_id: int = 0
var _despawning: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func setup(direction: Vector2, speed: float, damage: float) -> void:
	_direction = direction.normalized()
	_speed = speed
	_damage = damage
	rotation = _direction.angle()
	visible = true
	monitoring = true
	set_physics_process(true)
	_despawning = false

	_use_id += 1
	var my_id: int = _use_id
	get_tree().create_timer(lifetime).timeout.connect(func() -> void: _on_lifetime_expired(my_id))


func _on_lifetime_expired(id: int) -> void:
	if id == _use_id:
		_despawn()


func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(_damage)
		_despawn()


func _despawn() -> void:
	if _despawning:
		return
	_despawning = true
	set_physics_process(false)
	set_deferred("monitoring", false)
	visible = false
	call_deferred("_return_to_pool")


func _return_to_pool() -> void:
	if get_parent() != null:
		get_parent().remove_child(self)
	Pool.release(SELF_SCENE, self)
