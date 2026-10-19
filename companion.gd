extends CharacterBody2D
class_name Companion

## Companheiro invocado (ex: Bezerro Guarda-Costas): persegue o
## inimigo mais próximo e ataca por contato. Quando não há inimigos
## por perto, segue o jogador.

@export var speed: float = 90.0
@export var attack_range: float = 36.0

var damage: float = 3.0
var attack_cooldown: float = 1.0

var _player: Player
var _can_attack: bool = true
var art_animator: SpriteAnimator
var _landscape: FarmLandscape
var _route_left: float = 0.0
var _waypoint := Vector2.ZERO
var _route_goal := Vector2.INF

@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	collision_mask = 9
	_landscape = get_tree().current_scene.get_node_or_null("FarmLandscape") as FarmLandscape
	art_animator = SpriteAnimator.new()
	add_child(art_animator)
	attack_timer.timeout.connect(func() -> void: _can_attack = true)


func configure(stats: Dictionary, player: Player, level: int = 1) -> void:
	_player = player
	damage = stats["damage"]
	attack_cooldown = stats["cooldown"]
	attack_timer.wait_time = attack_cooldown
	art_animator.configure("bezerro_%d" % level, sprite)


func _physics_process(_delta: float) -> void:
	_route_left -= _delta
	if not is_instance_valid(_landscape): _landscape = get_tree().current_scene.get_node_or_null("FarmLandscape") as FarmLandscape
	art_animator.play("walk" if velocity.length() > 1 else "idle")
	var target: Node2D = _find_nearest_enemy()

	if target == null:
		_follow_player()
		return

	var to_target: Vector2 = target.global_position - global_position
	_update_facing(to_target)
	if to_target.length() > attack_range:
		velocity = _toward(target.global_position) * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		if _can_attack:
			_attack(target)


func _update_facing(direction: Vector2) -> void:
	if direction.x > 0.05:
		sprite.flip_h = false
	elif direction.x < -0.05:
		sprite.flip_h = true


func _follow_player() -> void:
	if _player == null:
		return
	var to_player: Vector2 = _player.global_position - global_position
	_update_facing(to_player)
	if to_player.length() > 60.0:
		velocity = _toward(_player.global_position) * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _toward(destination: Vector2) -> Vector2:
	if not is_instance_valid(_landscape): return (destination - global_position).normalized()
	if _route_left <= 0 or _route_goal.distance_to(destination) > 60 or global_position.distance_to(_waypoint) < 12:
		_waypoint = _landscape.obstacles.next_waypoint(global_position, destination)
		_route_goal = destination
		_route_left = 0.35
	return (_waypoint - global_position).normalized()


func _find_nearest_enemy() -> Node2D:
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist: float = INF
	for enemy in enemies:
		var dist: float = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest


func _attack(target: Node2D) -> void:
	art_animator.once("attack")
	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus
	if target.has_method("take_damage"):
		AudioManager.play_sfx("attack_melee", 0.05)
		target.take_damage(effective_damage)
	_can_attack = false
	attack_timer.start()
