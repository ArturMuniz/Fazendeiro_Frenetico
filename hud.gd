extends CanvasLayer
class_name HUD

@export var player_path: NodePath
var health_bar: ProgressBar
var health_label: Label
var xp_bar: ProgressBar
var xp_label: Label
# Kept for spawners and standalone preview scripts; map names live in PauseMenu.
var phase_label: Label
var banner_label: Label
var menu_button: Button
var _time: Label
var _boss: ProgressBar
var _boss_label: Label
var _player: Node
var _banner_tween: Tween
var _root: Control
var _top: PanelContainer
var _dock: PanelContainer
var _weapon_row: HBoxContainer
var _passive_grid: GridContainer
var _weapon_title: Label
var _passive_title: Label
var _loadout_key := ""
var _compact := false

func _ready() -> void:
	_player = get_node(player_path)
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.theme = RuralUI.theme()
	add_child(_root)
	_top = _panel("Vitals")
	_root.add_child(_top)
	var column := _column()
	_top.add_child(column)
	var row := _row()
	column.add_child(row)
	var vital := _column()
	vital.alignment = BoxContainer.ALIGNMENT_CENTER
	vital.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vital)
	health_bar = _bar(Color("b34b41"), 34)
	vital.add_child(health_bar)
	health_label = _bar_label(health_bar, 24)
	xp_bar = _bar(Color("3a959b"), 26, true)
	vital.add_child(xp_bar)
	xp_label = _bar_label(xp_bar, 20)
	_time = RuralUI.label("00:00", 24, RuralUI.CREAM)
	_time.custom_minimum_size.x = 98
	_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(_time)
	menu_button = RuralUI.button("≡", get_parent().get_node("PauseMenu").open)
	menu_button.name = "MenuButton"
	menu_button.tooltip_text = "Menu e equipamento · Pausar (Esc)"
	menu_button.custom_minimum_size = Vector2(96, 96)
	menu_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	menu_button.add_theme_font_size_override("font_size", 30)
	row.add_child(menu_button)
	phase_label = RuralUI.label("", 18, RuralUI.CREAM)
	phase_label.hide()
	column.add_child(phase_label)
	_boss = _bar(Color("ad5149"), 26)
	column.add_child(_boss)
	_boss_label = _bar_label(_boss, 18)
	_boss.hide()
	banner_label = RuralUI.label("", 30, RuralUI.CREAM)
	banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner_label.add_theme_color_override("font_outline_color", Color("1a271e"))
	banner_label.add_theme_constant_override("outline_size", 6)
	banner_label.modulate.a = 0
	_root.add_child(banner_label)
	_build_dock()
	_dock.minimum_size_changed.connect(func() -> void: _layout.call_deferred())
	_top.minimum_size_changed.connect(func() -> void: _layout.call_deferred())
	get_viewport().size_changed.connect(_layout)
	_layout()

func _panel(node_name: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = node_name
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := RuralUI.flat(Color(0.08, 0.14, 0.11, 0.90), Color("77633e"))
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _column() -> VBoxContainer:
	var node := VBoxContainer.new()
	node.add_theme_constant_override("separation", 4)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

func _row() -> HBoxContainer:
	var node := HBoxContainer.new()
	node.add_theme_constant_override("separation", 8)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

func _build_dock() -> void:
	_dock = _panel("EquipmentDock")
	_root.add_child(_dock)
	var row := _row()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 18)
	_dock.add_child(row)
	var weapons := _column()
	row.add_child(weapons)
	_weapon_title = RuralUI.label("ARMAS", 17, RuralUI.CREAM)
	weapons.add_child(_weapon_title)
	_weapon_row = _row()
	weapons.add_child(_weapon_row)
	var passives := _column()
	row.add_child(passives)
	_passive_title = RuralUI.label("BUFFS", 17, RuralUI.CREAM)
	passives.add_child(_passive_title)
	_passive_grid = GridContainer.new()
	_passive_grid.columns = 3
	_passive_grid.add_theme_constant_override("h_separation", 4)
	_passive_grid.add_theme_constant_override("v_separation", 4)
	_passive_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	passives.add_child(_passive_grid)

func _layout() -> void:
	var safe := TouchJoystick.safe_rect(get_viewport())
	var compact := safe.size.x < 480
	if compact != _compact:
		_compact = compact
		_loadout_key = ""
	_top.position = safe.position + Vector2(12, 12)
	_top.size = Vector2(safe.size.x - 24, _top.get_combined_minimum_size().y)
	_time.custom_minimum_size.x = 72 if compact else 98
	_time.add_theme_font_size_override("font_size", 18 if compact else 24)
	health_label.add_theme_font_size_override("font_size", 17 if compact else 24)
	xp_label.add_theme_font_size_override("font_size", 15 if compact else 20)
	banner_label.position = safe.position + Vector2(12, _top.size.y + 26)
	banner_label.size.x = safe.size.x - 24
	_refresh_loadout()
	_dock.size = Vector2(minf(520, safe.size.x - 24), _dock.get_combined_minimum_size().y)
	_dock.position = safe.position + Vector2((safe.size.x - _dock.size.x) / 2, safe.size.y - _dock.size.y - 12)

func _slot(entry: Dictionary, passive: bool) -> Control:
	var side := (30 if _compact else 40) if passive else (54 if _compact else 90)
	var slot := PanelContainer.new()
	slot.custom_minimum_size = Vector2(side, side if passive else 84)
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.set_meta("item_id", entry.get("id", ""))
	slot.set_meta("level", entry.get("level", 0))
	var style := RuralUI.flat(Color("293c2d"), Color("796b48") if not entry.is_empty() else Color("45543f"))
	style.set_corner_radius_all(18 if passive else 24)
	style.content_margin_left = 3
	style.content_margin_right = 3
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	slot.add_theme_stylebox_override("panel", style)
	var box := _column()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 0)
	slot.add_child(box)
	if entry.is_empty():
		var empty := RuralUI.label("·" if passive else "—", 20, Color("89937b"))
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(empty)
		if not passive:
			var caption := RuralUI.label("Vazio", 13, Color("89937b"))
			caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			box.add_child(caption)
		return slot
	var id: String = entry.id
	var level: int = entry.level
	var data: Dictionary = PassiveDB.PASSIVES[id] if passive else WeaponDB.WEAPONS[id]
	slot.tooltip_text = "%s · Nível %d/%d" % [data.name, level, data.levels.size()]
	var icon := TextureRect.new()
	icon.texture = RuralUI.texture(RuralUI.item_icon(id, level, true)) if passive else GameArt.weapon(id, level)
	if not passive and icon.texture == null:
		icon.texture = GameArt.weapon(id, 1)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2.ONE * ((20 if _compact else 26) if passive else 44)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(icon)
	var text := RuralUI.label(str(level) if passive else ("MÁX %d/%d" if level == data.levels.size() else "Nv.%d/%d") % [level, data.levels.size()], 14 if passive else (13 if _compact else 22), RuralUI.CREAM)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(text)
	return slot

func _refresh_loadout() -> void:
	if not is_instance_valid(_player): return
	var key := str(_player.weapons.map(func(e: Dictionary) -> String: return "%s:%d" % [e.id, e.level])) + str(_player.passives) + str(_compact)
	if key == _loadout_key: return
	_loadout_key = key
	RuralUI.clear(_weapon_row)
	RuralUI.clear(_passive_grid)
	for i in range(Player.MAX_WEAPONS):
		_weapon_row.add_child(_slot(_player.weapons[i] if i < _player.weapons.size() else {}, false))
	for i in range(Player.MAX_PASSIVES):
		_passive_grid.add_child(_slot(_player.passives[i] if i < _player.passives.size() else {}, true))
	_weapon_title.text = "ARMAS %d/%d" % [_player.weapons.size(), Player.MAX_WEAPONS]
	_passive_title.text = "BUFFS %d/%d" % [_player.passives.size(), Player.MAX_PASSIVES]

func _bar(color: Color, height: float, experience: bool = false) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.custom_minimum_size.y = height
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_theme_stylebox_override("background", RuralUI.flat(Color("25382d")))
	var fill := RuralUI.flat(color)
	fill.content_margin_top = 0
	fill.content_margin_bottom = 0
	bar.add_theme_stylebox_override("fill", fill)
	var frame := NinePatchRect.new()
	frame.texture = GameArt.ui("xp_frame" if experience else "health_frame")
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.patch_margin_left = 10
	frame.patch_margin_right = 10
	frame.patch_margin_top = 5
	frame.patch_margin_bottom = 5
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(frame)
	return bar

func _bar_label(bar: ProgressBar, font_size: int) -> Label:
	var text := RuralUI.label("", font_size, Color.WHITE)
	bar.add_child(text)
	text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.add_theme_color_override("font_outline_color", Color("18251d"))
	text.add_theme_constant_override("outline_size", 3)
	return text

func _process(_delta: float) -> void:
	if not is_instance_valid(_player): return
	health_bar.max_value = _player.max_health
	health_bar.value = _player.health
	health_label.text = "%d / %d" % [ceili(_player.health), int(_player.max_health)]
	xp_bar.max_value = _player.xp_to_next
	xp_bar.value = _player.xp
	xp_label.text = "Nv.%d · %d/%d XP" % [_player.level, int(_player.xp), int(_player.xp_to_next)]
	_time.text = "%02d:%02d\n%d abates" % [int(_player.survival_time) / 60, int(_player.survival_time) % 60, _player.kills]
	_refresh_loadout()
	var featured: Enemy
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health <= 0: continue
		if enemy.enemy_id.begins_with("boss_"):
			featured = enemy
			break
		if enemy.is_leader: featured = enemy
	var changed := _boss.visible != (featured != null)
	_boss.visible = featured != null
	if featured != null:
		_boss.max_value = featured.max_health
		_boss.value = featured.health
		_boss_label.text = "%s · %d/%d" % [featured.leader_title if featured.is_leader else EnemyDB.ENEMIES[featured.enemy_id].get("name", "Chefe"), ceili(featured.health), ceili(featured.max_health)]
	if changed: _layout.call_deferred()

func show_phase(label: String, number: int, total: int) -> void:
	phase_label.text = label if total <= 0 else "%s (%d/%d)" % [label, number, total]
	announce(phase_label.text)

func announce(label: String) -> void:
	banner_label.text = label
	banner_label.modulate.a = 1
	if _banner_tween != null: _banner_tween.kill()
	_banner_tween = create_tween()
	_banner_tween.tween_interval(1.2)
	_banner_tween.tween_property(banner_label, "modulate:a", 0.0, 0.8)
