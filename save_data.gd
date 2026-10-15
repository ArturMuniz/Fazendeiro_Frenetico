extends Node

## Autoload "SaveData" — guarda tudo que precisa sobreviver entre
## sessões do jogo (não só entre runs): moedas, personagens
## desbloqueados e níveis dos upgrades permanentes da fazenda.
## Salvo em disco como JSON simples em user://.

const SAVE_PATH: String = "user://save_data.json"

var gold: int = 0
var unlocked_characters: Array = ["fazendeiro"]
var selected_character: String = "fazendeiro"
var upgrade_levels: Dictionary = {}


func _ready() -> void:
	load_data()


func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return

	gold = parsed.get("gold", 0)
	unlocked_characters = parsed.get("unlocked_characters", ["fazendeiro"])
	selected_character = parsed.get("selected_character", "fazendeiro")
	upgrade_levels = parsed.get("upgrade_levels", {})


func save_data() -> void:
	var data: Dictionary = {
		"gold": gold,
		"unlocked_characters": unlocked_characters,
		"selected_character": selected_character,
		"upgrade_levels": upgrade_levels,
	}
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func add_gold(amount: int) -> void:
	gold += amount
	save_data()


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	save_data()
	return true


func get_upgrade_level(id: String) -> int:
	return upgrade_levels.get(id, 0)


func set_upgrade_level(id: String, level: int) -> void:
	upgrade_levels[id] = level
	save_data()


func unlock_character(id: String) -> void:
	if not unlocked_characters.has(id):
		unlocked_characters.append(id)
		save_data()


func select_character(id: String) -> void:
	selected_character = id
	save_data()
