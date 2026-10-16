extends Node2D
class_name SummonWeapon

## Bezerro Guarda-Costas: invoca um único companheiro que luta
## sozinho. Evoluir a arma apenas melhora os stats do companheiro
## já existente, sem invocar um segundo.

const COMPANION_SCENE: PackedScene = preload("res://companion.tscn")

@onready var icon: Sprite2D = get_node_or_null("Icon")

var weapon_id: String = ""
var level: int = 1

var _companion: Companion
var _player: Player


func _ready() -> void:
	_player = get_parent() as Player


func configure(id: String, lvl: int) -> void:
	weapon_id = id
	level = lvl
	var stats: Dictionary = WeaponDB.WEAPONS[id]["levels"][lvl - 1]

	if _companion == null:
		_companion = COMPANION_SCENE.instantiate()
		get_tree().current_scene.add_child(_companion)
		_companion.global_position = global_position

	_companion.configure(stats, _player, lvl)
