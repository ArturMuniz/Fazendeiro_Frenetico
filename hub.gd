extends Control
class_name Hub

var gold_label: Label
var start_button: Button
var _view: Dictionary
var _tab: String = "Mapas"
var _summary: Label
var _notice: String = ""

func _ready() -> void:
	AudioManager.play_music("hub")
	if not MapDB.MAPS.has(SaveManager.selected_map) or not SaveManager.is_map_unlocked(SaveManager.selected_map):
		SaveManager.selected_map = "horta"
	_view = RuralUI.shell(self, "Sua próxima colheita", "Escolha um destino. Sobreviva às pragas.", false)
	var tabs := HBoxContainer.new()
	_view.footer.add_child(tabs)
	for tab in ["Mapas", "Personagens", "Roupas", "Fazenda"]:
		var button := RuralUI.button(tab, _select_tab.bind(tab))
		if tab == "Personagens": button.text = "Heróis"
		button.add_theme_font_size_override("font_size", 22)
		tabs.add_child(button)
	gold_label = RuralUI.label("", 24, RuralUI.GREEN)
	gold_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gold_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var gold_row := HBoxContainer.new()
	_view.footer.add_child(gold_row)
	gold_row.add_child(RuralUI.picture("currency_gold", Vector2(36, 36)))
	gold_row.add_child(gold_label)
	_summary = RuralUI.label("", 22)
	_view.footer.add_child(_summary)
	start_button = RuralUI.button("Jogar", _on_start_pressed)
	start_button.custom_minimum_size.y = 88
	_view.footer.add_child(start_button)
	_refresh()
	RuralUI.present(_view.root)

func _select_tab(tab: String) -> void:
	_tab = tab
	_notice = ""
	_refresh()

func _refresh() -> void:
	RuralUI.clear(_view.body)
	_view.title.text = "Sua próxima colheita" if _tab == "Mapas" else _tab
	_view.subtitle.text = {"Mapas": "Escolha um destino. Sobreviva às pragas.", "Personagens": "Escolha quem vai defender a fazenda.", "Roupas": "Seu estilo, sem alterar os atributos. Compre com ouro do jogo.", "Fazenda": "Melhorias permanentes para as próximas partidas."}[_tab]
	gold_label.text = "OURO SALVO  %d" % SaveManager.gold
	_summary.text = "%s · %s\nCada mapa inicia uma nova build.%s" % [MapDB.MAPS[SaveManager.selected_map].name, CharacterDB.CHARACTERS[SaveManager.selected_character].name, "\n" + _notice if _notice != "" else ""]
	start_button.text = "Jogar — %s" % MapDB.MAPS[SaveManager.selected_map].name
	match _tab:
		"Mapas": _populate_maps()
		"Personagens": _populate_characters()
		"Fazenda": _populate_upgrades()
		"Roupas": _populate_skins()

func _populate_maps() -> void:
	var banner := RuralUI.card(_view.body)
	var header := HBoxContainer.new()
	banner.add_child(header)
	RuralUI.actor_preview(header, SaveManager.selected_character)
	var hero: Dictionary = CharacterDB.CHARACTERS[SaveManager.selected_character]
	var invitation := RuralUI.label("%s\n%s\nPronto para defender a colheita." % [hero.name, SkinCatalog.SKINS[SaveManager.get_equipped_skin(SaveManager.selected_character)].name], 24)
	invitation.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(invitation)
	var map := Control.new()
	map.name = "CampaignMap"
	map.custom_minimum_size.y = 500
	_view.body.add_child(map)
	var art := RuralUI.picture("campaign", Vector2.ZERO)
	map.add_child(art)
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var locations := {"horta": Vector2(0.68, 0.69), "celeiro": Vector2(0.35, 0.44), "pomar": Vector2(0.67, 0.21)}
	for id in MapDB.get_ordered_ids():
		var unlocked: bool = SaveManager.is_map_unlocked(id)
		var state := "cleared" if SaveManager.is_map_cleared(id) else ("available" if unlocked else "locked")
		var node := Button.new()
		node.name = "Map_" + id
		node.icon = RuralUI.texture("map_" + state)
		node.expand_icon = true
		node.add_theme_constant_override("icon_max_width", 72)
		node.size = Vector2(88, 88)
		node.add_theme_stylebox_override("normal", RuralUI.flat(Color(0.1, 0.15, 0.1, 0.8), Color("dfc58b") if SaveManager.selected_map == id else Color.TRANSPARENT))
		node.pressed.connect(_on_select_map.bind(id))
		map.add_child(node)
		var caption := RuralUI.label({"horta": "Horta", "celeiro": "Celeiro", "pomar": "Pomar"}[id], 18, Color.WHITE)
		caption.autowrap_mode = TextServer.AUTOWRAP_OFF
		caption.add_theme_color_override("font_shadow_color", Color.BLACK)
		caption.add_theme_constant_override("shadow_offset_x", 2)
		caption.add_theme_constant_override("shadow_offset_y", 2)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.size = Vector2(220, 26)
		map.add_child(caption)
		var reposition := func() -> void:
			var draw_size := Vector2(768, 1376) * minf(map.size.x / 768.0, map.size.y / 1376.0)
			var center: Vector2 = (map.size - draw_size) / 2.0 + locations[id] * draw_size
			node.position = center - Vector2(44, 44)
			caption.position = center + Vector2(-110, 44)
		map.resized.connect(reposition)
		reposition.call()
	var current: Dictionary = MapDB.MAPS[SaveManager.selected_map]
	var preview := TextureRect.new()
	preview.name = "SelectedArenaPreview"
	preview.texture = load(ArenaMaps.DATA[SaveManager.selected_map].texture) as Texture2D
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size.y = 240
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_view.body.add_child(preview)
	var status := "Concluído" if SaveManager.is_map_cleared(SaveManager.selected_map) else "Disponível"
	_view.body.add_child(RuralUI.label("%s · %s\n3 fases e um chefe. Após a vitória, avance ou continue no modo livre." % [current.name, status], 24))

func _on_select_map(id: String) -> void:
	AudioManager.play_sfx("button")
	if not SaveManager.is_map_unlocked(id):
		_notice = "Bloqueado: conclua %s." % MapDB.MAPS[MapDB.MAPS[id].unlock_requires].name
	else:
		SaveManager.selected_map = id
		_notice = ""
	_refresh()

func _populate_characters() -> void:
	for id in CharacterDB.CHARACTERS:
		var data: Dictionary = CharacterDB.CHARACTERS[id]
		var entry := RuralUI.card(_view.body)
		var row := HBoxContainer.new()
		entry.add_child(row)
		RuralUI.actor_preview(row, id)
		var text := RuralUI.label("%s\n%s\nArma inicial: %s" % [data.name, data.desc, WeaponDB.WEAPONS[data.starting_weapon].name], 24)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
		var unlocked: bool = SaveManager.is_character_unlocked(id)
		var selected: bool = SaveManager.selected_character == id
		var button := RuralUI.button("Selecionado" if selected else ("Selecionar" if unlocked else "Desbloquear · %d ouro" % data.unlock_cost), _on_select_character.bind(id) if unlocked else _on_unlock_character.bind(id))
		button.disabled = selected or (not unlocked and SaveManager.gold < int(data.unlock_cost))
		entry.add_child(button)

func _on_select_character(id: String) -> void:
	if not SaveManager.is_character_unlocked(id):
		return
	AudioManager.play_sfx("button")
	SaveManager.selected_character = id
	_refresh()

func _on_unlock_character(id: String) -> void:
	var cost: int = CharacterDB.CHARACTERS[id].unlock_cost
	if SaveManager.is_character_unlocked(id) or SaveManager.gold < cost:
		return
	SaveManager.gold -= cost
	SaveManager.unlocked_characters.append(id)
	if SaveManager.save_data():
		SaveManager.selected_character = id
		AudioManager.play_sfx("purchase")
	else:
		SaveManager.gold += cost
		SaveManager.unlocked_characters.erase(id)
		_notice = "Não foi possível salvar a compra. Tente novamente."
	_refresh()

func _populate_upgrades() -> void:
	for id in FarmUpgradeDB.UPGRADES:
		var data: Dictionary = FarmUpgradeDB.UPGRADES[id]
		var level: int = SaveManager.get_farm_upgrade_level(id)
		var maxed: bool = level >= int(data.max_level)
		var entry := RuralUI.card(_view.body)
		var row := HBoxContainer.new()
		entry.add_child(row)
		row.add_child(RuralUI.picture("farm_" + id))
		var text := RuralUI.label("%s\n%s" % [data.name, "Nível máximo · 3" if maxed else "Nível %d → %d\n%s" % [level, level + 1, data.desc_per_level[level]]], 24)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
		var button := RuralUI.button("Nível máximo" if maxed else "Comprar · %d ouro" % data.cost_per_level[level], _on_buy_upgrade.bind(id))
		button.disabled = maxed or (not maxed and SaveManager.gold < int(data.cost_per_level[level]))
		entry.add_child(button)

func _on_buy_upgrade(id: String) -> void:
	var data: Dictionary = FarmUpgradeDB.UPGRADES[id]
	var level: int = SaveManager.get_farm_upgrade_level(id)
	if level >= int(data.max_level) or SaveManager.gold < int(data.cost_per_level[level]):
		return
	var old_upgrades: Dictionary = SaveManager.farm_upgrades.duplicate()
	var cost: int = data.cost_per_level[level]
	SaveManager.gold -= cost
	SaveManager.farm_upgrades[id] = level + 1
	if SaveManager.save_data():
		AudioManager.play_sfx("purchase")
	else:
		SaveManager.gold += cost
		SaveManager.farm_upgrades = old_upgrades
		_notice = "Não foi possível salvar a compra. Tente novamente."
	_refresh()

func _populate_skins() -> void:
	var character := SaveManager.selected_character
	_view.body.add_child(RuralUI.label("VESTIÁRIO · %s" % CharacterDB.CHARACTERS[character].name, 25, RuralUI.GREEN))
	_view.body.add_child(RuralUI.label("Escolha outro personagem na aba Personagens para ver as roupas dele. As primeiras roupas variam a paleta do traje original.", 21))
	for id in SkinCatalog.SKINS:
		var data: Dictionary = SkinCatalog.SKINS[id]
		var entry := RuralUI.card(_view.body)
		var row := HBoxContainer.new()
		entry.add_child(row)
		RuralUI.actor_preview(row, character, id)
		var owned: bool = SaveManager.owns_skin(character, id)
		var selected: bool = SaveManager.get_equipped_skin(character) == id
		var text := RuralUI.label("%s\n%s\nApenas visual · acompanha todas as animações" % [data.name, "Na sua coleção" if owned else "%d ouro" % int(data.cost)], 23)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
		var action := RuralUI.button("Equipada" if selected else ("Vestir" if owned else "Comprar · %d ouro" % int(data.cost)), _on_skin_action.bind(character, id))
		action.disabled = selected or (not owned and SaveManager.gold < int(data.cost))
		entry.add_child(action)
	if is_instance_valid(RewardedAds.provider) and RewardedAds.provider.has_method("show_privacy_options"):
		_view.body.add_child(RuralUI.button("Preferências de privacidade dos anúncios", RewardedAds.provider.show_privacy_options))

func _on_skin_action(character: String, skin_id: String) -> void:
	var owned: bool = SaveManager.owns_skin(character, skin_id)
	if not owned and not SaveManager.buy_skin(character, skin_id):
		_notice = "Compra não concluída. Confira seu ouro ou tente salvar novamente."
	elif not SaveManager.equip_skin(character, skin_id):
		_notice = "Roupa adquirida. Não foi possível salvar a seleção; tente vestir novamente."
	else:
		_notice = "%s equipada." % SkinCatalog.SKINS[skin_id].name
		AudioManager.play_sfx("button" if owned else "purchase")
	_refresh()

func _on_start_pressed() -> void:
	AudioManager.play_sfx("button")
	PauseManager.change_scene("res://main.tscn")
