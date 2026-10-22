extends SceneTree

var checks := 0
var failures := 0
var player: Node
var hud: Node
var joystick: Node
var pm: Node

func _initialize() -> void:
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(720,1280)
	call_deferred("run")
	create_timer(35).timeout.connect(func() -> void: push_error("Mobile HUD timeout"); quit(2))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", message)

func settle() -> void:
	for i in range(6): await process_frame

func touch(point: Vector2, down: bool, index: int = 7) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = point
	event.pressed = down
	root.push_input(event, true)

func drag(point: Vector2, index: int = 7) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = point
	root.push_input(event, true)

func run() -> void:
	pm = root.get_node("PauseManager")
	var save: Node = root.get_node("SaveManager")
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save.save_path = "res://tests/.tmp/mobile-hud.json"
	save.selected_map = "horta"
	save.selected_character = "fazendeiro"
	save.farm_upgrades = {}
	pm.change_scene("res://main.tscn")
	await scene_changed
	await settle()
	player = current_scene.get_node("player")
	hud = current_scene.get_node("HUD")
	joystick = player.joystick
	current_scene.get_node("EnemySpawner").set_process(false)
	current_scene.get_node("EnemySpawner/SpawnTimer").stop()
	player.set_physics_process(false)
	var view := root.get_visible_rect().size
	for point in [Vector2(view.x*0.25, view.y*0.4), Vector2(view.x*0.8, view.y*0.55), Vector2(3,view.y*0.5)]:
		touch(point, true)
		check(joystick._touch_index == 7 and joystick.get_vector().is_zero_approx(), "toque livre nasce neutro em %s" % point)
		drag(point+Vector2(0, -joystick.joystick_radius))
		check(joystick.get_vector().is_equal_approx(Vector2.UP), "arrastar produz direção correta")
		touch(point, false, 8)
		check(joystick._touch_index == 7, "segundo dedo não solta o controle")
		touch(point, false)
		check(joystick.get_vector().is_zero_approx() and joystick._touch_index == -1, "soltar limpa entrada")
	var speed: float = player.speed
	player.add_weapon("milho")
	player.add_weapon("forquilha")
	player.add_weapon("foice")
	player.add_weapon("foice")
	for id in root.get_node("PassiveDB").PASSIVES:
		if player.passives.size() < 6: player.add_passive(id)
	await settle()
	check(hud._weapon_row.get_child_count() == 3 and hud._passive_grid.get_child_count() == 6, "HUD mostra três armas e seis espaços de buffs")
	check(hud._weapon_row.get_child(0).get_meta("level") == 3, "evolução atualiza nível da arma no HUD")
	check(hud._weapon_row.get_child(0).tooltip_text.contains("3/3"), "nível máximo vem do catálogo real")
	var icons: Array[Node] = hud._weapon_row.find_children("*", "TextureRect", true, false)
	check(icons.size() == 3 and icons.all(func(icon: TextureRect) -> bool: return icon.texture != null), "armas evoluídas mantêm ícone mesmo sem arte exclusiva do nível")
	check(is_equal_approx(player.speed, speed), "mudança visual não modifica velocidade")
	player.xp = 2
	await settle()
	check(hud.xp_label.text.contains("2/") and hud.xp_label.text.contains("XP"), "HUD mostra XP verdadeiro do personagem")
	for dimensions in [Vector2i(360,640), Vector2i(720,1560), Vector2i(1280,720)]:
		root.size = dimensions
		await settle()
		var bounds := root.get_visible_rect()
		check(bounds.size == Vector2(dimensions), "viewport corresponde à dimensão testada")
		check(bounds.encloses(hud._top.get_global_rect()) and bounds.encloses(hud._dock.get_global_rect()), "HUD sem cortes em %s" % dimensions)
		check(not hud._top.get_global_rect().intersects(hud._dock.get_global_rect()), "HUD superior e inventário não se sobrepõem")
		check(not hud.phase_label.visible, "nome do mapa não ocupa HUD permanente")
	root.size = Vector2i(720,1280)
	await settle()
	var button: Button = hud.menu_button
	touch(Vector2(120,500), true)
	drag(button.get_global_rect().get_center())
	touch(button.get_global_rect().get_center(), false)
	check(joystick._touch_index == -1 and joystick.get_vector().is_zero_approx() and not paused, "soltar movimento sobre menu não prende entrada nem abre pausa")
	touch(button.get_global_rect().get_center(), true)
	check(joystick._touch_index == -1, "menu não captura dedo como movimento")
	touch(button.get_global_rect().get_center(), false)
	var menu: Node = current_scene.get_node("PauseMenu")
	# push_input does not synthesize touch-to-mouse emulation. Exercise the
	# GUI's real pointer path as well, rather than emitting pressed manually.
	if not paused:
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.position = button.get_global_rect().get_center()
		click.pressed = true
		root.push_input(click, true)
		click = click.duplicate()
		click.pressed = false
		root.push_input(click, true)
	check(paused and menu.visible, "menu compacto abre pausa real")
	touch(Vector2(100,500), true)
	check(joystick.get_vector().is_zero_approx() and joystick._touch_index == -1, "tocar menu pausado não movimenta")
	menu._on_resume_pressed()
	check(not paused and joystick.get_vector().is_zero_approx(), "retomar não prende movimento")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await settle()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.1).timeout
	print("MOBILE HUD RESULT checks=%d failures=%d" % [checks,failures])
	quit(1 if failures else 0)
