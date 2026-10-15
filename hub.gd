extends Control
class_name Hub

## Tela entre runs: mostra a moeda persistente, deixa escolher/
## desbloquear personagem e comprar upgrades permanentes da fazenda.
## Os botões são criados por código (igual fizemos na tela de
## level-up) pra não precisar editar a cena toda vez que um
## personagem ou upgrade novo for adicionado nas tabelas.

@onready var gold_label: Label = $VBoxContainer/GoldLabel
@onready var map_container: VBoxContainer = $VBoxContainer/MapContainer
@onready var character_container: VBoxContainer = $VBoxContainer/CharacterContainer
@onready var upgrade_container: VBoxContainer = $VBoxContainer/UpgradeContainer
@onready var start_button: Button = $VBoxContainer/StartButton


func _ready() -> void:
	AudioManager.play_music("hub")
	start_button.pressed.connect(_on_start_pressed)
	# garante que o mapa selecionado existe e está liberado
	if not MapDB.MAPS.has(SaveManager.selected_map) or not SaveManager.is_map_unlocked(SaveManager.selected_map):
		SaveManager.selected_map = "horta"
	_refresh()


func _refresh() -> void:
	gold_label.text = "Moedas: %d" % SaveManager.gold
	start_button.text = "Iniciar — %s" % MapDB.MAPS[SaveManager.selected_map]["name"]
	_populate_maps()
	_populate_characters()
	_populate_upgrades()


func _populate_maps() -> void:
	for child in map_container.get_children():
		child.queue_free()

	for id in MapDB.get_ordered_ids():
		var data: Dictionary = MapDB.MAPS[id]
		var unlocked: bool = SaveManager.is_map_unlocked(id)
		var cleared: bool = SaveManager.is_map_cleared(id)

		var row := HBoxContainer.new()

		var label := Label.new()
		var status: String
		if not unlocked:
			var required: String = data.get("unlock_requires", "")
			status = "Bloqueado — conclua %s" % MapDB.MAPS[required]["name"]
		elif cleared:
			status = "Concluído"
		else:
			status = "Disponível"
		var marker: String = " (selecionado)" if SaveManager.selected_map == id else ""
		label.text = "%s%s\n%s" % [data["name"], marker, status]
		label.custom_minimum_size = Vector2(300, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(label)

		var button := Button.new()
		button.text = "Selecionar" if unlocked else "Bloqueado"
		button.disabled = (not unlocked) or SaveManager.selected_map == id
		if unlocked:
			button.pressed.connect(_on_select_map.bind(id))
		row.add_child(button)

		map_container.add_child(row)


func _on_select_map(id: String) -> void:
	AudioManager.play_sfx("button")
	SaveManager.selected_map = id
	_refresh()


func _populate_characters() -> void:
	for child in character_container.get_children():
		child.queue_free()

	for id in CharacterDB.CHARACTERS:
		var data: Dictionary = CharacterDB.CHARACTERS[id]
		var unlocked: bool = SaveManager.is_character_unlocked(id)

		var row := HBoxContainer.new()

		var label := Label.new()
		var marker: String = " (selecionado)" if SaveManager.selected_character == id else ""
		label.text = "%s%s\n%s" % [data["name"], marker, data["desc"]]
		label.custom_minimum_size = Vector2(300, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(label)

		var button := Button.new()
		if unlocked:
			button.text = "Selecionar"
			button.disabled = SaveManager.selected_character == id
			button.pressed.connect(_on_select_character.bind(id))
		else:
			button.text = "Desbloquear (%d)" % data["unlock_cost"]
			button.disabled = SaveManager.gold < data["unlock_cost"]
			button.pressed.connect(_on_unlock_character.bind(id))
		row.add_child(button)

		character_container.add_child(row)


func _on_select_character(id: String) -> void:
	AudioManager.play_sfx("button")
	SaveManager.selected_character = id
	_refresh()


func _on_unlock_character(id: String) -> void:
	var data: Dictionary = CharacterDB.CHARACTERS[id]
	if SaveManager.spend_gold(data["unlock_cost"]):
		AudioManager.play_sfx("purchase")
		SaveManager.unlock_character(id)
		SaveManager.selected_character = id
	else:
		AudioManager.play_sfx("button")
	_refresh()


func _populate_upgrades() -> void:
	for child in upgrade_container.get_children():
		child.queue_free()

	for id in FarmUpgradeDB.UPGRADES:
		var data: Dictionary = FarmUpgradeDB.UPGRADES[id]
		var level: int = SaveManager.get_farm_upgrade_level(id)
		var maxed: bool = level >= data["max_level"]

		var row := HBoxContainer.new()

		var label := Label.new()
		if maxed:
			label.text = "%s (nível máximo)" % data["name"]
		else:
			label.text = "%s — nível %d/%d\n%s" % [data["name"], level, data["max_level"], data["desc_per_level"][level]]
		label.custom_minimum_size = Vector2(300, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(label)

		var button := Button.new()
		if maxed:
			button.text = "Máximo"
			button.disabled = true
		else:
			var cost: int = data["cost_per_level"][level]
			button.text = "Comprar (%d)" % cost
			button.disabled = SaveManager.gold < cost
			button.pressed.connect(_on_buy_upgrade.bind(id))
		row.add_child(button)

		upgrade_container.add_child(row)


func _on_buy_upgrade(id: String) -> void:
	var data: Dictionary = FarmUpgradeDB.UPGRADES[id]
	var level: int = SaveManager.get_farm_upgrade_level(id)
	if level >= data["max_level"]:
		return
	var cost: int = data["cost_per_level"][level]
	if SaveManager.spend_gold(cost):
		AudioManager.play_sfx("purchase")
		SaveManager.set_farm_upgrade_level(id, level + 1)
	else:
		AudioManager.play_sfx("button")
	_refresh()


func _on_start_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().change_scene_to_file("res://main.tscn")
