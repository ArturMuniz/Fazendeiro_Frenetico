extends SceneTree

## Capturas reais do renderer. Rodar sem --headless e com --audio-driver Dummy.
func _initialize() -> void:
	call_deferred("run")


func capture(name: String) -> void:
	for i in range(6):
		await process_frame
	await RenderingServer.frame_post_draw
	var image: Image = root.get_texture().get_image()
	var error := image.save_png("res://tests/.tmp/" + name + ".png")
	assert(error == OK)
	print("CAPTURE ", name, " ", image.get_size())


func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	var save: Node = root.get_node("SaveManager")
	save.save_path = "res://tests/.tmp/visual-save.json"
	save.gold = 0
	save.maps_cleared = []
	save.reward_receipts = {}
	save.farm_upgrades = {}
	save.unlocked_characters = ["fazendeiro"]
	save.selected_map = "horta"
	save.selected_character = "fazendeiro"
	var pm: Node = root.get_node("PauseManager")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await capture("ui_lobby")
	current_scene._select_tab("Personagens")
	await capture("ui_characters")
	current_scene._select_tab("Fazenda")
	await capture("ui_farm")
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var scene: Node = current_scene
	var player: Node = scene.get_node("player")
	scene.get_node("EnemySpawner").set_process(false)
	scene.get_node("EnemySpawner/SpawnTimer").stop()
	await capture("gameplay")
	scene.get_node("PauseMenu").open()
	await capture("pause")
	scene.get_node("PauseMenu")._select_tab("Atributos")
	await capture("ui_attributes")
	scene.get_node("PauseMenu")._on_resume_pressed()
	var boss: Node = load("res://enemy.tscn").instantiate()
	scene.add_child(boss)
	boss.position = player.position + Vector2(100, 180)
	boss.configure("boss_lagarta", 1.0, player)
	boss.set_physics_process(false)
	await capture("ui_boss_hud")
	boss._despawn()
	player.grant_free_level_up()
	await capture("cards")
	var cards: Node = scene.get_node("LevelUpUI")
	cards._choices[0].pressed.emit()
	await capture("ui_card_selected")
	player.register_kill(true)
	var victory: Node
	for child in scene.get_children():
		if child.get_script() != null and child.get_script().resource_path == "res://boss_victory_ui.gd":
			victory = child
	await capture("victory")
	victory.show_save_error()
	await capture("ui_victory_save_error")
	player._save_victory(victory)
	victory._on_end_pressed()
	await capture("results")
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	player = current_scene.get_node("player")
	current_scene.get_node("EnemySpawner").set_process(false)
	current_scene.get_node("EnemySpawner/SpawnTimer").stop()
	for id in ["milho", "mamona", "motosserra", "bezerro", "batata"]:
		player.add_weapon(id)
		player.add_weapon(id)
	for id in ["espantalho", "sementes", "termica", "galochas", "ima"]:
		player.add_passive(id)
	current_scene.get_node("PauseMenu").open()
	await capture("ui_full_inventory")
	current_scene.get_node("PauseMenu")._on_resume_pressed()
	save.save_path = "res://tests/.tmp/nonexistent-visual/save.json"
	player._die()
	await create_timer(0.85).timeout
	await capture("ui_defeat_save_error")
	save.save_path = "res://tests/.tmp/visual-save.json"
	player._result_ui._on_retry_pressed()
	await capture("ui_defeat")
	root.get_node("AudioManager").shutdown()
	await create_timer(0.15).timeout
	quit()
