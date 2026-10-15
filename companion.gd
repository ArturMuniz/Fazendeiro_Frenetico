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

@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	attack_timer.timeout.connect(func() -> void: _can_attack = true)


func configure(stats: Dictionary, player: Player) -> void:
	_player = player
	damage = stats["damage"]
	attack_cooldown = stats["cooldown"]
	attack_timer.wait_time = attack_cooldown


func _physics_process(_delta: float) -> void:
	var target: Node2D = _find_nearest_enemy()

	if target == null:
		_follow_player()
		return

	var to_target: Vector2 = target.global_position - global_position
	_update_facing(to_target)
	if to_target.length() > attack_range:
		velocity = to_target.normalized() * speed
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
		velocity = to_player.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


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
	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus
	if target.has_method("take_damage"):
		AudioManager.play_sfx("attack_melee", 0.05)
		target.take_damage(effective_damage)
	_can_attack = false
	attack_timer.start()
