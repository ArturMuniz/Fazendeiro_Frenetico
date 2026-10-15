extends Area2D
class_name Projectile

## Projétil genérico: viaja em linha reta e causa dano ao encostar num
## inimigo. Suporta perfuração (atravessa N inimigos), ricochete
## (pula pro próximo inimigo mais próximo) e dano em área, tudo
## configurado via setup(). Reaproveitado via Pool.

const SELF_SCENE: PackedScene = preload("res://projectile.tscn")

@export var lifetime: float = 2.0

var _direction: Vector2 = Vector2.RIGHT
var _speed: float = 250.0
var _damage: float = 5.0
var _pierce: int = 0   # -1 = infinito, 0 = para no 1º acerto, N = atravessa N inimigos
var _bounces: int = 0  # quantas vezes procura outro alvo após acertar
var _splash_radius: float = 0.0  # >0 causa dano em área a cada acerto (Canhão de Batata)
var _splash_damage: float = 0.0
var _hit_enemies: Array = []
var _use_id: int = 0  # evita que um timer de vida útil "fantasma" (de um uso anterior, antes de voltar pro pool) despache esse projétil por engano
var _despawning: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


## Chamado pela arma logo após instanciar/reaproveitar o projétil.
func setup(direction: Vector2, speed: float, damage: float, pierce: int = 0, bounces: int = 0, splash_radius: float = 0.0, splash_damage: float = 0.0) -> void:
	_direction = direction.normalized()
	_speed = speed
	_damage = damage
	_pierce = pierce
	_bounces = bounces
	_splash_radius = splash_radius
	_splash_damage = splash_damage
	_hit_enemies.clear()
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
	if not body.is_in_group("enemies") or not body.has_method("take_damage"):
		return
	if _hit_enemies.has(body):
		return

	body.take_damage(_damage)
	_hit_enemies.append(body)

	if _splash_radius > 0.0:
		_apply_splash(body)

	if _bounces > 0:
		_bounces -= 1
		var next_target: Node2D = _find_next_target()
		if next_target != null:
			_direction = (next_target.global_position - global_position).normalized()
			rotation = _direction.angle()
			return
		_despawn()
		return

	if _pierce != 0:
		if _pierce > 0:
			_pierce -= 1
		return

	_despawn()


## Dano de área em volta do impacto, exceto no alvo já atingido
## diretamente (que já recebeu o dano cheio acima).
func _apply_splash(primary: Node2D) -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy == primary:
			continue
		if not enemy.has_method("take_damage"):
			continue
		if enemy.global_position.distance_to(global_position) <= _splash_radius:
			enemy.take_damage(_splash_damage)


func _find_next_target() -> Node2D:
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist: float = INF
	for enemy in enemies:
		if _hit_enemies.has(enemy):
			continue
		var dist: float = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest


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
