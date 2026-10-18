extends Node

## Autoload "SaveManager" — guarda o progresso permanente do jogador
## num arquivo JSON em user:// (sobrevive entre sessões do jogo).
## Também guarda o personagem escolhido no Hub para a próxima run
## (isso não precisa ser salvo em disco, só passar entre as cenas).

const SAVE_PATH: String = "user://save_data.json"
var save_path: String = SAVE_PATH
var reward_receipts: Dictionary = {}
const MAX_RECEIPTS: int = 128

var gold: int = 0
var unlocked_characters: Array = ["fazendeiro"]
var farm_upgrades: Dictionary = {}  # id -> nível comprado
var maps_cleared: Array = []  # ids dos mapas cujo boss já foi derrotado
var owned_skins: Dictionary = {}
var equipped_skins: Dictionary = {}

## Escolhido no Hub, lido pelo player.gd ao iniciar a run.
var selected_character: String = "fazendeiro"

## Escolhido no lobby, lido pelo main.gd ao iniciar a run.
var selected_map: String = "horta"


func _ready() -> void:
	load_data()


func load_data() -> void:
	if not FileAccess.file_exists(save_path):
		return

	var file := FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		return
	var text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return

	gold = parsed.get("gold", 0)
	unlocked_characters = parsed.get("unlocked_characters", ["fazendeiro"])
	farm_upgrades = parsed.get("farm_upgrades", {})
	maps_cleared = parsed.get("maps_cleared", [])
	reward_receipts = parsed.get("reward_receipts", {})
	owned_skins = parsed.get("owned_skins", {}) if parsed.get("owned_skins", {}) is Dictionary else {}
	equipped_skins = parsed.get("equipped_skins", {}) if parsed.get("equipped_skins", {}) is Dictionary else {}


func save_data() -> bool:
	var data: Dictionary = {
		"gold": gold,
		"unlocked_characters": unlocked_characters,
		"farm_upgrades": farm_upgrades,
		"maps_cleared": maps_cleared,
		"reward_receipts": reward_receipts,
		"owned_skins": owned_skins,
		"equipped_skins": equipped_skins,
	}
	# Escreve primeiro um arquivo completo; uma falha não trunca o save anterior.
	var temporary_path := save_path + ".tmp"
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		return false
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary_path), ProjectSettings.globalize_path(save_path)) == OK


func new_run_id() -> String:
	return Crypto.new().generate_random_bytes(16).hex_encode()


## Conclusão e bônus são persistidos juntos. Recibo torna tentativas idempotentes.
func claim_boss_reward(run_id: String, map_id: String) -> Dictionary:
	if reward_receipts.has(run_id) and reward_receipts[run_id].has("boss"):
		return {"ok": true, "amount": int(reward_receipts[run_id]["boss"])}
	var old_gold := gold
	var old_maps := maps_cleared.duplicate()
	var old_receipts := reward_receipts.duplicate(true)
	var first_clear := not maps_cleared.has(map_id)
	var amount := 50 + (100 if first_clear else 0)
	if first_clear:
		maps_cleared.append(map_id)
	gold += amount
	var receipt: Dictionary = reward_receipts.get(run_id, {})
	receipt["boss"] = amount
	reward_receipts[run_id] = receipt
	_trim_receipts()
	if not save_data():
		gold = old_gold
		maps_cleared = old_maps
		reward_receipts = old_receipts
		return {"ok": false, "amount": 0}
	return {"ok": true, "amount": amount}


func settle_run(run_id: String, amount: int) -> Dictionary:
	if reward_receipts.has(run_id) and reward_receipts[run_id].has("base"):
		return {"ok": true, "amount": int(reward_receipts[run_id]["base"])}
	var old_gold := gold
	var old_receipts := reward_receipts.duplicate(true)
	gold += amount
	var receipt: Dictionary = reward_receipts.get(run_id, {})
	receipt["base"] = amount
	reward_receipts[run_id] = receipt
	_trim_receipts()
	if not save_data():
		gold = old_gold
		reward_receipts = old_receipts
		return {"ok": false, "amount": 0}
	return {"ok": true, "amount": amount}


func _trim_receipts() -> void:
	while reward_receipts.size() > MAX_RECEIPTS:
		reward_receipts.erase(reward_receipts.keys()[0])


## A rewind never removes saved gold. Only a higher final total adds a delta.
func settle_run_progress(run_id: String, amount: int) -> Dictionary:
	var receipt: Dictionary = reward_receipts.get(run_id, {})
	var paid := int(receipt.get("base", 0))
	if receipt.has("double"):
		return {"ok": true, "amount": paid, "paid_now": 0}
	var total := maxi(paid, maxi(amount, 0))
	if receipt.has("base") and total == paid:
		return {"ok": true, "amount": paid, "paid_now": 0}
	var old_gold := gold
	var old_receipts := reward_receipts.duplicate(true)
	gold += total - paid
	receipt["base"] = total
	reward_receipts[run_id] = receipt
	_trim_receipts()
	if not save_data():
		gold = old_gold
		reward_receipts = old_receipts
		return {"ok": false, "amount": paid, "paid_now": 0}
	return {"ok": true, "amount": total, "paid_now": total - paid}


func double_run_reward(run_id: String) -> Dictionary:
	if not reward_receipts.has(run_id) or not reward_receipts[run_id].has("base"):
		return {"ok": false, "amount": 0}
	var receipt: Dictionary = reward_receipts[run_id]
	if receipt.has("double"):
		return {"ok": true, "amount": int(receipt.double), "paid_now": 0}
	var amount := int(receipt.base) + int(receipt.get("boss", 0))
	var old_receipts := reward_receipts.duplicate(true)
	var old_gold := gold
	receipt["double"] = amount
	gold += amount
	if not save_data():
		gold = old_gold
		reward_receipts = old_receipts
		return {"ok": false, "amount": 0}
	return {"ok": true, "amount": amount, "paid_now": amount}


func claim_run_revive(run_id: String) -> bool:
	var receipt: Dictionary = reward_receipts.get(run_id, {})
	if receipt.has("revive") or receipt.has("double"):
		return false
	var old_receipts := reward_receipts.duplicate(true)
	receipt["revive"] = true
	reward_receipts[run_id] = receipt
	if not save_data():
		reward_receipts = old_receipts
		return false
	return true


func owns_skin(character_id: String, skin_id: String) -> bool:
	return SkinCatalog.valid(character_id, skin_id) and (skin_id == "original" or owned_skins.get(character_id, []).has(skin_id))


func get_equipped_skin(character_id: String) -> String:
	var id: String = str(equipped_skins.get(character_id, "original"))
	return id if owns_skin(character_id, id) else "original"


func buy_skin(character_id: String, skin_id: String) -> bool:
	if not SkinCatalog.valid(character_id, skin_id) or not is_character_unlocked(character_id):
		return false
	if owns_skin(character_id, skin_id):
		return true
	var price: int = SkinCatalog.SKINS[skin_id].cost
	if gold < price:
		return false
	var old_gold := gold
	var old_owned := owned_skins.duplicate(true)
	var owned: Array = owned_skins.get(character_id, []).duplicate()
	owned.append(skin_id)
	owned_skins[character_id] = owned
	gold -= price
	if not save_data():
		gold = old_gold
		owned_skins = old_owned
		return false
	return true


func equip_skin(character_id: String, skin_id: String) -> bool:
	if not owns_skin(character_id, skin_id):
		return false
	var old_equipped := equipped_skins.duplicate()
	equipped_skins[character_id] = skin_id
	if not save_data():
		equipped_skins = old_equipped
		return false
	return true


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
