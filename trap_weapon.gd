extends Node2D
class_name TrapWeapon

## Cerca Elétrica: solta armadilhas estacionárias na posição atual
## do jogador em intervalos fixos.

const TRAP_SCENE: PackedScene = preload("res://trap.tscn")

@onready var spawn_timer: Timer = $SpawnTimer
@onready var icon: Sprite2D = get_node_or_null("Icon")

var weapon_id: String = ""
var level: int = 1
var _stats: Dictionary
var _player: Player


func _ready() -> void:
	_player = get_parent() as Player
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	_stats = WeaponDB.WEAPONS[id]["levels"][lvl - 1]
	spawn_timer.wait_time = _stats["cooldown"]
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var trap: Trap = TRAP_SCENE.instantiate()
	trap.global_position = global_position

	var effective_damage: float = _stats["damage"]
	if _player != null:
		effective_damage += _player.damage_bonus

	get_tree().current_scene.add_child(trap)
	trap.configure(effective_damage, _stats["tick_interval"], _stats["duration"])
