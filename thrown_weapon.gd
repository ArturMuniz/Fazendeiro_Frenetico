extends Node2D
class_name ThrownWeapon

## Foice Giratória: arremessa a foice até a posição do inimigo mais
## próximo (dentro do alcance) — ela viaja até lá e fica girando no
## local por um instante, em vez de bater só ao redor do personagem.

const THROWN_SCENE: PackedScene = preload("res://thrown_foice.tscn")

@onready var attack_timer: Timer = $AttackTimer
@onready var icon: Sprite2D = get_node_or_null("Icon")

var weapon_id: String = ""
var level: int = 1
var damage: float = 0.0
var max_range: float = 150.0
var spin_radius: float = 36.0
var spin_duration: float = 0.6

var _player: Player
var _icon_texture: Texture2D


func _ready() -> void:
	_player = get_parent() as Player
	attack_timer.timeout.connect(_on_attack_timer_timeout)


func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	var weapon_data: Dictionary = WeaponDB.WEAPONS[id]
	var stats: Dictionary = weapon_data["levels"][lvl - 1]
	damage = stats["damage"]
	max_range = stats.get("range", 150.0)
	spin_radius = stats.get("radius", 36.0)
	spin_duration = stats.get("spin_duration", 0.6)

	var icon_path: String = weapon_data.get("icon_texture", "")
	if icon_path != "":
		_icon_texture = load(icon_path)
		if icon != null:
			icon.texture = _icon_texture
	if icon != null:
		GameArt.equip(icon, id, lvl)
		_icon_texture = icon.texture

	var multiplier: float = 1.0
	if _player != null:
		multiplier = clamp(_player.cooldown_multiplier, 0.25, 1.0)
	attack_timer.wait_time = stats["cooldown"] * multiplier
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	var target: Node2D = _find_nearest_enemy()
	if target == null:
		return
	if global_position.distance_to(target.global_position) > max_range:
		return

	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus

	var thrown: ThrownFoice = THROWN_SCENE.instantiate()
	thrown.global_position = global_position
	get_tree().current_scene.add_child(thrown)
	AudioManager.play_sfx("attack_melee")
	thrown.setup(target.global_position, effective_damage, spin_radius, spin_duration, _icon_texture)


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
