extends CanvasLayer
class_name HUD

@export var player_path: NodePath
var health_bar: ProgressBar
var health_label: Label
var xp_bar: ProgressBar
var xp_label: Label
var phase_label: Label
var banner_label: Label
var _time: Label
var _boss: ProgressBar
var _boss_label: Label
var _player: Node
var _banner_tween: Tween

func _ready() -> void:
	_player = get_node(player_path)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = RuralUI.theme()
	add_child(root)
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	panel.offset_left = 16
	panel.offset_right = -16
	panel.offset_top = 16
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", RuralUI.flat(Color(0.08, 0.14, 0.11, 0.94)))
	root.add_child(panel)
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(column)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	var vital := VBoxContainer.new()
	vital.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vital.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(vital)
	health_bar = _bar(Color("b34b41"), 36)
	vital.add_child(health_bar)
	health_label = _bar_label(health_bar)
	xp_bar = _bar(Color("3a959b"), 28)
	vital.add_child(xp_bar)
	xp_label = _bar_label(xp_bar)
	_time = RuralUI.label("00:00", 26, RuralUI.CREAM)
	_time.custom_minimum_size.x = 120
	_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(_time)
	var pause := RuralUI.button("Pausa", get_parent().get_node("PauseMenu").open)
	pause.custom_minimum_size = Vector2(132, 88)
	pause.autowrap_mode = TextServer.AUTOWRAP_OFF
	pause.size_flags_horizontal = Control.SIZE_SHRINK_END
	row.add_child(pause)
	phase_label = RuralUI.label("", 22, RuralUI.CREAM)
	column.add_child(phase_label)
	_boss = _bar(Color("ad5149"), 32)
	column.add_child(_boss)
	_boss_label = _bar_label(_boss)
	_boss.hide()
	banner_label = RuralUI.label("", 34, RuralUI.CREAM)
	root.add_child(banner_label)
	banner_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	banner_label.offset_top = 224
	banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner_label.add_theme_color_override("font_outline_color", Color("1a271e"))
	banner_label.add_theme_constant_override("outline_size", 8)
	banner_label.modulate.a = 0

func _bar(color: Color, height: float) -> ProgressBar:
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
	frame.texture = GameArt.ui("xp_frame" if height == 28 else "health_frame")
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.patch_margin_left = 10
	frame.patch_margin_right = 10
	frame.patch_margin_top = 5
	frame.patch_margin_bottom = 5
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(frame)
	return bar

func _bar_label(bar: ProgressBar) -> Label:
	var text := RuralUI.label("", 22, Color.WHITE)
	bar.add_child(text)
	text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.add_theme_color_override("font_outline_color", Color("18251d"))
	text.add_theme_constant_override("outline_size", 4)
	return text

func _process(_delta: float) -> void:
	if not is_instance_valid(_player):
		return
	health_bar.max_value = _player.max_health
	health_bar.value = _player.health
	health_label.text = "Vida %d / %d" % [ceili(_player.health), int(_player.max_health)]
	xp_bar.max_value = _player.xp_to_next
	xp_bar.value = _player.xp
	xp_label.text = "Nível %d" % _player.level
	_time.text = "%02d:%02d\n%d abates" % [int(_player.survival_time) / 60, int(_player.survival_time) % 60, _player.kills]
	_boss.hide()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.enemy_id.begins_with("boss_") and enemy.health > 0:
			_boss.show()
			_boss.max_value = enemy.max_health
			_boss.value = enemy.health
			_boss_label.text = "%s · %d / %d" % [EnemyDB.ENEMIES[enemy.enemy_id].get("name", "Chefe"), ceili(enemy.health), ceili(enemy.max_health)]
			break

func show_phase(label: String, number: int, total: int) -> void:
	phase_label.text = "%s · %s" % [MapDB.MAPS[SaveManager.selected_map].name, label if total <= 0 else "%s (%d/%d)" % [label, number, total]]
	banner_label.text = label
	banner_label.modulate.a = 1
	if _banner_tween != null:
		_banner_tween.kill()
	_banner_tween = create_tween()
	_banner_tween.tween_interval(1.2)
	_banner_tween.tween_property(banner_label, "modulate:a", 0.0, 0.8)
