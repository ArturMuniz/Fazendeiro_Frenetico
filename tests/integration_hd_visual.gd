extends SceneTree

## Render actual production scenes. Does not replace landscape, art or controls.
var output := "res://tests/.tmp/hd-visual/"
var report: Array = []
var pm: Node

func _initialize() -> void:
	root.size = Vector2i(360,780)
	call_deferred("run")
	create_timer(70).timeout.connect(func() -> void: push_error("HD visual timeout"); quit(2))

func settle(frames: int = 12) -> void:
	for i in range(frames):
		pm.release(pm) # Only unattended-window focus; never a menu's lock.
		await process_frame

func capture(name: String) -> void:
	await settle()
	await RenderingServer.frame_post_draw
	var picture := root.get_texture().get_image()
	assert(picture.get_width()>=720 and picture.get_height()>=1280)
	assert(picture.save_png(output+name+".png")==OK)
	report.append({"name":name,"size":[picture.get_width(),picture.get_height()]})
	print("HD CAPTURE ",name," ",picture.get_size())

func run() -> void:
	DirAccess.make_dir_recursive_absolute(output)
	var save: Node = root.get_node("SaveManager")
	pm = root.get_node("PauseManager")
	save.save_path = "res://tests/.tmp/hd-visual-save.json"
	save.maps_cleared = ["horta","celeiro","pomar"]
	save.unlocked_characters = ["fazendeiro","vovo","netinho"]
	save.farm_upgrades = {}
	save.reward_receipts = {}
	save.equipped_skins = {}
	root.get_node("AudioManager").shutdown()
	for id in ["horta","celeiro","pomar"]:
		save.selected_map = id
		save.selected_character = {"horta":"fazendeiro","celeiro":"vovo","pomar":"netinho"}[id]
		pm.change_scene("res://main.tscn")
		await scene_changed
		await settle()
		var p: Node = current_scene.get_node("player")
		current_scene.spawner.set_process(false)
		current_scene.spawner.spawn_timer.stop()
		current_scene.checkpoint.process_mode = Node.PROCESS_MODE_DISABLED
		p.xp_to_next = 10000 # Capture fixture only; production progression unchanged.
		p.add_weapon("milho")
		p.add_weapon("forquilha")
		p.add_passive("queijo")
		p.add_passive("caderno")
		current_scene.hud.banner_label.modulate.a = 0
		for index in range(8):
			var point: Vector2 = current_scene.landscape.clamp_point(Vector2.from_angle(index*TAU/8)*280,45)
			current_scene.spawner._spawn_enemy(["pulgao","mosca","gafanhoto","lesma"][index%4],false,point)
		await settle(25)
		await capture(id+"_combate")
		p.position = current_scene.landscape.play_bounds.end-Vector2(190,80)
		await capture(id+"_borda")
		p.position = Vector2.ZERO
		current_scene.pause_menu.open()
		await capture(id+"_pausa")
		current_scene.pause_menu._on_resume_pressed()
		for enemy in get_nodes_in_group("enemies"): enemy._despawn()
		await settle()
		if id == "pomar":
			p._die()
			await create_timer(1.0).timeout
			await capture("netinho_resultado")
	root.size = Vector2i(600,800)
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await capture("hub_tablet")
	current_scene._select_tab("Personagens")
	await capture("personagens_tablet")
	var file := FileAccess.open(output+"render_report.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.1).timeout
	print("HD VISUAL COMPLETE captures=",report.size())
	quit()
