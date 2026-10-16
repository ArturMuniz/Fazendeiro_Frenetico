extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(name: String) -> void:
	for i in range(7):
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image.save_png("res://tests/.tmp/" + name + ".png") == OK)
	print("ART CAPTURE ", name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	var save: Node = root.get_node("SaveManager")
	var pm: Node = root.get_node("PauseManager")
	save.save_path = "res://tests/.tmp/art-visual-save.json"
	save.maps_cleared = ["horta", "celeiro", "pomar"]
	save.gold = 100
	save.farm_upgrades = {}
	save.reward_receipts = {}
	save.unlocked_characters = ["fazendeiro", "vovo", "netinho"]
	save.selected_character = "fazendeiro"
	save.selected_map = "horta"
	pm.change_scene("res://hub.tscn")
	await scene_changed
	current_scene._select_tab("Personagens")
	await capture("art_characters")
	for map in ["horta", "celeiro", "pomar"]:
		save.selected_map = map
		save.selected_character = {"horta":"fazendeiro", "celeiro":"vovo", "pomar":"netinho"}[map]
		pm.change_scene("res://main.tscn")
		await scene_changed
		await process_frame
		var player: Node = current_scene.get_node("player")
		player.health = player.max_health
		player.set_physics_process(false)
		current_scene.get_node("EnemySpawner").set_process(false)
		current_scene.get_node("EnemySpawner/SpawnTimer").stop()
		for weapon in player.weapons:
			weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
		var ids := ["pulgao", "lesma", "gafanhoto", "mosca", "boss_lagarta", "boss_rainha_moscas", "boss_gafanhoto_gigante"]
		var positions := [Vector2(-210,-30),Vector2(-70,-30),Vector2(70,-30),Vector2(210,-30),Vector2(-210,180),Vector2(0,210),Vector2(210,180)]
		for i in range(ids.size()):
			var enemy: Node = load("res://enemy.tscn").instantiate()
			current_scene.add_child(enemy)
			enemy.configure(ids[i], 1.0, player)
			enemy.position = positions[i]
			enemy.set_physics_process(false)
			enemy.get_node("JumpTimer").stop()
			enemy.get_node("ShootTimer").stop()
			enemy.get_node("BurstTimer").stop()
		await capture("art_" + map)
		if map == "horta":
			player.add_weapon("mamona")
			player.add_weapon("bezerro")
			player.add_weapon("motosserra")
			player.add_passive("sementes")
			current_scene.get_node("PauseMenu").open()
			await capture("art_inventory")
			current_scene.get_node("PauseMenu")._select_tab("Atributos")
			await capture("art_attributes")
			current_scene.get_node("PauseMenu")._on_resume_pressed()
		player._die()
		await create_timer(0.22).timeout
		await capture("art_death_" + map)
		await create_timer(0.6).timeout
		if map == "pomar":
			await capture("art_defeat")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	root.get_node("AudioManager").shutdown()
	quit()
