extends Node2D
class_name MeleeStabWeapon

## Forquilha: estocada de alvo único no inimigo mais próximo, com
## alcance limitado — mais dano que as armas de longe, mas só acerta
## se o inimigo estiver dentro do alcance definido (sem projétil
## viajando pelo mapa).

@onready var attack_timer: Timer = $AttackTimer
@onready var icon: Sprite2D = $Icon

var weapon_id: String = ""
var level: int = 1
var damage: float = 0.0
var attack_range: float = 60.0

var _player: Player


func _ready() -> void:
	_player = get_parent() as Player
	attack_timer.timeout.connect(_on_attack_timer_timeout)


func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	var weapon_data: Dictionary = WeaponDB.WEAPONS[id]
	var stats: Dictionary = weapon_data["levels"][lvl - 1]
	damage = stats["damage"]
	attack_range = stats.get("range", 60.0)

	var icon_path: String = weapon_data.get("icon_texture", "")
	if icon_path != "":
		icon.texture = load(icon_path)
	GameArt.equip(icon, id, lvl)

	var multiplier: float = 1.0
	if _player != null:
		multiplier = clamp(_player.cooldown_multiplier, 0.25, 1.0)
	attack_timer.wait_time = stats["cooldown"] * multiplier
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	var target: Node2D = _find_nearest_enemy()
	if target == null:
		return

	if global_position.distance_to(target.global_position) > attack_range:
		return

	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus

	if target.has_method("take_damage"):
		AudioManager.play_sfx("attack_melee")
		VisualFX.spawn(get_tree().current_scene, "impact", target.global_position)
		target.take_damage(effective_damage)


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
