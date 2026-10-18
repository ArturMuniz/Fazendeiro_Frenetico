extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(name: String) -> void:
	for i in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png("res://tests/.tmp/" + name + ".png") == OK)
	print("MAP CAPTURE ", name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	var baseline := "--baseline" in OS.get_cmdline_user_args()
	var save: Node = root.get_node("SaveManager")
	var pm: Node = root.get_node("PauseManager")
	save.save_path = "res://tests/.tmp/map-visual-save.json"
	save.maps_cleared = ["horta", "celeiro", "pomar"]
	save.farm_upgrades = {}
	save.reward_receipts = {}
	save.selected_character = "fazendeiro"
	for id in ["horta", "celeiro", "pomar"]:
		save.selected_map = id
		pm.change_scene("res://main.tscn")
		await scene_changed
		await process_frame
		var player: Node = current_scene.get_node("player")
		player.set_physics_process(false)
		current_scene.get_node("EnemySpawner").set_process(false)
		current_scene.get_node("EnemySpawner/SpawnTimer").stop()
		for weapon in player.weapons:
			weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
		var camera: Camera2D = player.get_node("Camera2D")
		camera.position_smoothing_enabled = false
		await capture(("map_before_" if baseline else "map_after_") + id)
		if baseline:
			continue
		camera.zoom = Vector2.ONE * 0.6
		await capture("map_overview_" + id)
		camera.zoom = Vector2.ONE
		player.position = Vector2(3360, -2780)
		await capture("map_distant_" + id)
		player.position = Vector2.ZERO
		var species: String = {"horta":"pulgao", "celeiro":"mosca", "pomar":"gafanhoto"}[id]
		for i in range(24):
			var enemy: Node = load("res://enemy.tscn").instantiate()
			current_scene.add_child(enemy)
			enemy.configure(species, 1.0, player)
			enemy.position = Vector2(-280 + (i % 6) * 110, -180 + (i / 6) * 130)
			enemy.set_physics_process(false)
			for timer in ["JumpTimer", "ShootTimer", "BurstTimer"]:
				enemy.get_node(timer).stop()
		await capture("map_combat_" + id)
		print("MAP DRAW CALLS ", id, " ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	root.get_node("AudioManager").shutdown()
	quit()
