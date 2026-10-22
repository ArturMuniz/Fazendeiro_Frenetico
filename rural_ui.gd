class_name RuralUI
extends RefCounted

## Componentes compartilhados: arte aprovada, texto dinâmico e áreas de toque.
const INK := Color("30291f")
const CREAM := Color("f4e7c9")
const GREEN := Color("345743")
static var _theme: Theme
static var _actor_bounds: Dictionary = {}

static func texture(id: String) -> Texture2D:
	if GameArt.DATA.ui.has(id):
		return GameArt.ui(id)
	if id.begins_with("weapon_") and GameArt.DATA.weapons.has(id.trim_prefix("weapon_")):
		return GameArt.texture(GameArt.DATA.weapons[id.trim_prefix("weapon_")])
	var path := "res://art/ui_rural/%s.png" % id
	return load(path) as Texture2D if ResourceLoader.exists(path) else null

static func flat(color: Color, border: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style

static func textured(id: String, edge: float) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = texture(id)
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, edge)
		style.set_content_margin(side, 40 if id == "panel" else 18)
	return style

static func theme() -> Theme:
	if _theme != null:
		return _theme
	_theme = Theme.new()
	_theme.default_font_size = 26
	_theme.set_color("font_color", "Label", INK)
	_theme.set_constant("separation", "VBoxContainer", 12)
	_theme.set_constant("separation", "HBoxContainer", 12)
	_theme.set_stylebox("panel", "PanelContainer", textured("panel", 32))
	_theme.set_stylebox("normal", "Button", textured("button", 24))
	_theme.set_stylebox("pressed", "Button", textured("button_pressed", 24))
	_theme.set_stylebox("hover", "Button", textured("button_pressed", 24))
	_theme.set_stylebox("disabled", "Button", textured("button_disabled", 24))
	var focus := flat(Color.TRANSPARENT, Color("edd68b"))
	focus.set_border_width_all(3)
	_theme.set_stylebox("focus", "Button", focus)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		_theme.set_color(state, "Button", CREAM)
	_theme.set_color("font_disabled_color", "Button", Color("d5cfbf"))
	_theme.set_font_size("font_size", "Button", 26)
	return _theme

static func label(text: String, font_size: int = 26, color: Color = INK) -> Label:
	var node := Label.new()
	node.text = text
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", color)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

static func button(text: String, callback: Callable = Callable()) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size.y = 72
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if callback.is_valid():
		node.pressed.connect(callback)
	return node

static func picture(id: String, dimensions: Vector2 = Vector2(80, 80)) -> TextureRect:
	var node := TextureRect.new()
	node.texture = texture(id)
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	node.custom_minimum_size = dimensions
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

static func clear(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

static func card(parent: Node) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", flat(Color("ecddba"), Color("c4ae7e")))
	parent.add_child(panel)
	var column := VBoxContainer.new()
	panel.add_child(column)
	return column

static func actor_preview(parent: Node, id: String, skin_id: String = "", dimensions: Vector2 = Vector2(124, 140)) -> Control:
	var preview := Control.new()
	preview.name = "Animated_" + id
	preview.custom_minimum_size = dimensions
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.clip_contents = true
	parent.add_child(preview)
	var figure := Sprite2D.new()
	preview.add_child(figure)
	var animator := SpriteAnimator.new()
	preview.add_child(animator)
	animator.configure(id, figure)
	SkinCatalog.apply(figure, id, SaveManager.get_equipped_skin(id) if skin_id == "" else skin_id)
	if not _actor_bounds.has(id):
		var bounds := Rect2()
		for path in GameArt.actor(id).idle.frames:
			var texture := GameArt.texture(path)
			var used := Rect2(texture.get_image().get_used_rect())
			used.position -= texture.get_size() / 2.0
			used.position += figure.offset
			bounds = used if bounds.size == Vector2.ZERO else bounds.merge(used)
		_actor_bounds[id] = bounds
	var arrange := func() -> void:
		var bounds: Rect2 = _actor_bounds[id]
		var zoom := minf(1.65, minf((preview.size.x - 12) / bounds.size.x, (preview.size.y - 12) / bounds.size.y))
		figure.scale = Vector2.ONE * zoom
		figure.position = Vector2(preview.size.x / 2.0, preview.size.y - 6) - Vector2(bounds.get_center().x, bounds.end.y) * zoom
	preview.resized.connect(arrange)
	arrange.call()
	return preview

static func present(root: Control) -> void:
	root.modulate.a = 0.0
	root.create_tween().tween_property(root, "modulate:a", 1.0, 0.16)

static func shell(owner: Node, title: String, subtitle: String, modal: bool = true) -> Dictionary:
	var root := Control.new()
	root.name = "RuralInterface"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.theme = theme()
	owner.add_child(root)
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.055, 0.085, 0.065, 0.88 if modal else 1.0)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(backdrop)
	var panel := PanelContainer.new()
	panel.name = "Window"
	root.add_child(panel)
	var layout := func() -> void:
		if not is_instance_valid(root) or not root.is_inside_tree() or not is_instance_valid(panel):
			return
		var viewport := root.get_viewport_rect().size
		var safe := TouchJoystick.safe_rect(root.get_viewport())
		var width := minf(760.0, safe.size.x - 32.0)
		panel.position = safe.position + Vector2((safe.size.x - width) / 2.0, 16)
		panel.size = Vector2(width, safe.size.y - 32)
	root.resized.connect(layout)
	# Textos recém-criados podem ter altura provisória antes da largura final.
	# Reaplica o limite da janela após a negociação dos Containers.
	panel.minimum_size_changed.connect(func() -> void: layout.call_deferred())
	layout.call()
	var column := VBoxContainer.new()
	panel.add_child(column)
	var brand := HBoxContainer.new()
	column.add_child(brand)
	brand.add_child(picture("emblem", Vector2(44, 44)))
	var brand_title := label("O FAZENDEIRO FRENÉTICO", 18, GREEN)
	brand_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand.add_child(brand_title)
	var heading := label(title, 38)
	column.add_child(heading)
	var divider := HSeparator.new()
	divider.modulate = Color("b79c65")
	column.add_child(divider)
	var sub := label(subtitle, 22)
	column.add_child(sub)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(body)
	var footer := VBoxContainer.new()
	column.add_child(footer)
	return {"root": root, "body": body, "footer": footer, "title": heading, "subtitle": sub, "scroll": scroll}

static func item_icon(id: String, level: int, passive: bool = false) -> String:
	if passive and PassiveDB.PASSIVES.get(id, {}).has("icon"):
		return PassiveDB.PASSIVES[id].icon
	var key := "passive_%s" % id if passive else "weapon_%s_%d" % [id, level]
	if not passive and GameArt.DATA.weapons.has("%s_%d" % [id, level]):
		return key
	return key if ResourceLoader.exists("res://art/ui_rural/%s.png" % key) else ""

static func inventory(parent: Node, player: Node) -> void:
	for category in ["weapons", "passives"]:
		var entries: Array = player.get(category)
		var capacity: int = Player.MAX_WEAPONS if category == "weapons" else Player.MAX_PASSIVES
		parent.add_child(label(("ARMAS" if category == "weapons" else "PASSIVOS") + "  %d / %d" % [entries.size(), capacity], 22, GREEN))
		if entries.is_empty():
			parent.add_child(label("Nenhum item equipado", 22))
		for entry in entries:
			var is_passive: bool = category == "passives"
			var data: Dictionary = PassiveDB.PASSIVES[entry.id] if is_passive else WeaponDB.WEAPONS[entry.id]
			var column := card(parent)
			var row := HBoxContainer.new()
			column.add_child(row)
			var icon := item_icon(entry.id, entry.level, is_passive)
			if icon != "":
				row.add_child(picture(icon, Vector2(56, 56)))
			var text := label("%s · Nível %d\n%s" % [data.name, entry.level, UIData.item_details(player, entry.id, entry.level, is_passive)], 21)
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(text)

static func attributes(parent: Node, player: Node) -> void:
	parent.add_child(label("ATRIBUTOS ATUAIS", 22, GREEN))
	var entries := [
		["stat_health", "Vida: %s / %s" % [UIData.number(player.health), UIData.number(player.max_health)]],
		["stat_speed", "Velocidade: %s px/s" % UIData.number(player.speed)],
		["stat_damage", "Dano adicional: +%s" % UIData.number(player.damage_bonus)],
		["stat_interval", "Intervalo das armas compatíveis: ×%s" % UIData.number(clampf(player.cooldown_multiplier, 0.25, 1.0))],
		["stat_defense", "Defesa: %s%%" % UIData.number(player.defense_percent * 100)],
		["stat_collection", "Coleta de XP: %s px" % UIData.number(player.magnet_radius)],
		["stat_health", "Regeneração: %s vida/s" % UIData.number(player.regeneration)],
		["stat_collection", "XP adicional: +%s%%" % UIData.number(player.xp_bonus * 100)]
	]
	for entry in entries:
		var row := HBoxContainer.new()
		parent.add_child(row)
		row.add_child(picture(entry[0], Vector2(40, 40)))
		var text := label(entry[1], 24)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
	parent.add_child(label("O modificador de intervalo afeta foice, forquilha e armas de projétil. Aura, companheiro e armadilha mantêm seus próprios intervalos.", 20))
