extends Node2D
class_name MeleeAuraWeapon

## Motosserra Enferrujada: dano em área ao redor do personagem,
## em ticks periódicos, sem precisar de projétil.

@onready var hitbox: Area2D = $Hitbox
@onready var shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var tick_timer: Timer = $TickTimer
@onready var icon: Sprite2D = $Icon

var weapon_id: String = ""
var level: int = 1
var damage: float = 0.0

var _player: Player


func _ready() -> void:
	_player = get_parent() as Player
	tick_timer.timeout.connect(_on_tick)


func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	var weapon_data: Dictionary = WeaponDB.WEAPONS[id]
	var stats: Dictionary = weapon_data["levels"][lvl - 1]
	damage = stats["damage"]
	tick_timer.wait_time = stats["tick_interval"]
	(shape.shape as CircleShape2D).radius = stats["radius"]

	var icon_path: String = weapon_data.get("icon_texture", "")
	if icon_path != "":
		icon.texture = load(icon_path)

	tick_timer.start()


func _on_tick() -> void:
	var effective_damage: float = damage
	if _player != null:
		effective_damage += _player.damage_bonus
	var hit_something: bool = false
	for body in hitbox.get_overlapping_bodies():
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(effective_damage)
			hit_something = true
	if hit_something:
		AudioManager.play_sfx("attack_melee", 0.05)
