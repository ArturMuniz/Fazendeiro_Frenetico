extends Node

## Autoload "SaveManager" — guarda o progresso permanente do jogador
## num arquivo JSON em user:// (sobrevive entre sessões do jogo).
## Também guarda o personagem escolhido no Hub para a próxima run
## (isso não precisa ser salvo em disco, só passar entre as cenas).

const SAVE_PATH: String = "user://save_data.json"

var gold: int = 0
var unlocked_characters: Array = ["fazendeiro"]
var farm_upgrades: Dictionary = {}  # id -> nível comprado
var maps_cleared: Array = []  # ids dos mapas cujo boss já foi derrotado

## Escolhido no Hub, lido pelo player.gd ao iniciar a run.
var selected_character: String = "fazendeiro"

## Escolhido no lobby, lido pelo main.gd ao iniciar a run.
var selected_map: String = "horta"


func _ready() -> void:
	load_data()


func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return

	gold = parsed.get("gold", 0)
	unlocked_characters = parsed.get("unlocked_characters", ["fazendeiro"])
	farm_upgrades = parsed.get("farm_upgrades", {})
	maps_cleared = parsed.get("maps_cleared", [])


func save_data() -> void:
	var data: Dictionary = {
		"gold": gold,
		"unlocked_characters": unlocked_characters,
		"farm_upgrades": farm_upgrades,
		"maps_cleared": maps_cleared,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
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


func unlock_character(id: String) -> void:
	if not unlocked_characters.has(id):
		unlocked_characters.append(id)
		save_data()


func is_character_unlocked(id: String) -> bool:
	return unlocked_characters.has(id)


func get_farm_upgrade_level(id: String) -> int:
	return farm_upgrades.get(id, 0)


func set_farm_upgrade_level(id: String, level: int) -> void:
	farm_upgrades[id] = level
	save_data()


func is_map_cleared(id: String) -> bool:
	return maps_cleared.has(id)


## Um mapa está liberado se não exige outro, ou se o exigido já foi concluído.
func is_map_unlocked(id: String) -> bool:
	var required: String = MapDB.MAPS[id].get("unlock_requires", "")
	return required == "" or maps_cleared.has(required)


## Registra o mapa como concluído. Retorna true se foi a PRIMEIRA vez
## (usado pra dar o bônus de primeira conclusão).
func mark_map_cleared(id: String) -> bool:
	if maps_cleared.has(id):
		return false
	maps_cleared.append(id)
	save_data()
	return true
