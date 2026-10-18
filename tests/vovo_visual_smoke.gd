extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(name: String) -> void:
	for i in range(5):
		await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png("res://tests/.tmp/" + name + ".png") == OK)
	print("VOVO CAPTURE ", name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	var save: Node = root.get_node("SaveManager")
	save.save_path = "res://tests/.tmp/vovo-visual-save.json"
	save.selected_character = "vovo"
	save.selected_map = "horta"
	save.farm_upgrades = {}
	root.get_node("PauseManager").change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var player: Node = current_scene.get_node("player")
	player.set_physics_process(false)
	current_scene.get_node("EnemySpawner").set_process(false)
	current_scene.get_node("EnemySpawner/SpawnTimer").stop()
	for weapon in player.weapons:
		weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
	await capture("vovo_gameplay_idle")
	player.art_animator.play("run", true)
	await create_timer(0.22).timeout
	await capture("vovo_gameplay_run")
	player.art_animator.once("idle_plant")
	await create_timer(1.35).timeout
	await capture("vovo_gameplay_plant")
	player._die()
	await create_timer(0.63).timeout
	await capture("vovo_gameplay_death")
	await create_timer(0.35).timeout
	await capture("vovo_gameplay_results")
	root.get_node("AudioManager").shutdown()
	quit()
