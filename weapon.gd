extends Node2D
class_name Weapon

## Arma de ataque automático genérica: mira e atira no inimigo mais
## próximo. Os stats (dano, cooldown) vêm do WeaponDB conforme o
## weapon_id e o nível atuais — não são fixos no script.

@export var projectile_scene: PackedScene = preload("res://projectile.tscn")
@export var projectile_speed: float = 250.0

var weapon_id: String = ""
var level: int = 1
var damage: float = 0.0
var attack_cooldown: float = 1.0
var pierce: int = 0
var bounces: int = 0
var splash_radius: float = 0.0
var splash_damage: float = 0.0
var _projectile_texture_path: String = ""

@onready var attack_timer: Timer = $AttackTimer
@onready var icon: Sprite2D = get_node_or_null("Icon")

var _player: Player


func _ready() -> void:
	_player = get_parent() as Player
	attack_timer.timeout.connect(_on_attack_timer_timeout)


## Chamado pelo Player ao adquirir ou evoluir essa arma.
func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	var weapon_data: Dictionary = WeaponDB.WEAPONS[id]
	var stats: Dictionary = weapon_data["levels"][lvl - 1]
	damage = stats["damage"]
	attack_cooldown = stats["cooldown"]
	pierce = stats.get("pierce", 0)
	bounces = stats.get("bounces", 0)
	splash_radius = stats.get("splash_radius", 0.0)
	splash_damage = stats.get("splash_damage", 0.0)
	_projectile_texture_path = weapon_data.get("projectile_texture", "")

	var icon_path: String = weapon_data.get("icon_texture", "")
	if icon_path != "" and icon != null:
		icon.texture = load(icon_path)
	if icon != null:
		GameArt.equip(icon, id, lvl)

	var multiplier: float = 1.0
	if _player != null:
		# Teto de 25%: mesmo empilhando "Café Mais Forte" e "Garrafa
		# Térmica" à vontade, o cooldown nunca fica menor que 1/4 do
		# original — evita que o dano por segundo exploda de vez.
		multiplier = clamp(_player.cooldown_multiplier, 0.25, 1.0)
	attack_timer.wait_time = attack_cooldown * multiplier
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	var target: Node2D = _find_nearest_enemy()
	if target != null:
		_fire_at(target)


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


func _fire_at(target: Node2D) -> void:
	if projectile_scene == null:
		return

	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus

	var projectile: Projectile = Pool.acquire(projectile_scene)
	get_tree().current_scene.add_child(projectile)
	AudioManager.play_sfx("attack_ranged")
	var direction: Vector2 = (target.global_position - global_position).normalized()
	projectile.global_position = global_position
	projectile.setup(direction, projectile_speed, effective_damage, pierce, bounces, splash_radius, splash_damage)
	if _projectile_texture_path != "":
		var sprite_node: Sprite2D = projectile.get_node("Sprite2D")
		sprite_node.texture = GameArt.ui("projectile_" + weapon_id)
		sprite_node.modulate = Color(1, 1, 1)
		sprite_node.scale = Vector2(1, 1)
		sprite_node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
