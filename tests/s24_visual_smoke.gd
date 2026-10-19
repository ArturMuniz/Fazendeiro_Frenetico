extends SceneTree

var output := "res://docs/feedback_s24/telas/"

func _initialize() -> void: call_deferred("run")

func capture(name: String) -> void:
	# Hidden preview windows may lose OS focus. Refresh these deliberately frozen
	# fixtures explicitly so the HUD does not depend on a gameplay process tick.
	current_scene.hud._process(0)
	await create_timer(0.18).timeout
	for frame in range(5): await process_frame
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(output + name + ".png")
	if error != OK: push_error("Could not save " + name); quit(1)
	print("S24 CAPTURE ", name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute(output)
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	var save: Node = root.get_node("SaveManager")
	var pm: Node = root.get_node("PauseManager")
	save.save_path = "res://tests/.tmp/s24-visual-save.json"
	save.selected_character = "fazendeiro"
	save.maps_cleared = ["horta", "celeiro", "pomar"]
	save.farm_upgrades = {}
	save.reward_receipts = {}
	root.size = Vector2i(720, 1560)
	for id in ["horta", "celeiro", "pomar"]:
		save.selected_map = id
		pm.change_scene("res://main.tscn")
		await scene_changed
		await process_frame
		var p: Node = current_scene.get_node("player")
		p.set_physics_process(false)
		current_scene.spawner.set_process(false)
		current_scene.spawner.spawn_timer.stop()
		for weapon in p.weapons: weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
		var camera: Camera2D = p.get_node("Camera2D")
		camera.position_smoothing_enabled = false
		await capture(id + "_clareira")
		camera.zoom = Vector2.ONE * 0.45
		await capture(id + "_bordas")
		camera.zoom = Vector2.ONE
		p.position = Vector2(-700, -700)
		await capture(id + "_construcao")
		if id != "horta": continue
		p.position = Vector2.ZERO
		p.add_weapon("milho")
		p.add_weapon("forquilha")
		p.add_passive("queijo")
		p.add_passive("caderno")
		p.add_passive("amolador")
		for entry in p.weapons: entry.node.process_mode = Node.PROCESS_MODE_DISABLED
		var leader: Node = current_scene.spawner._spawn_enemy("lesma", true, Vector2(140, -150))
		leader.set_physics_process(false)
		leader.health = leader.max_health * 0.65
		await capture("lider_e_tres_armas")
		current_scene.pause_menu.open()
		await capture("pausa")
		current_scene.pause_menu._on_resume_pressed()
		p.grant_free_level_up()
		await capture("cartas")
		var cards: Node = current_scene.get_node("LevelUpUI")
		cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
	root.get_node("AudioManager").shutdown()
	quit()
