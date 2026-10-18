extends SceneTree

var output := "res://docs/polimento_atores/telas/"
func _initialize() -> void: call_deferred("run")

func capture(name: String) -> void:
	await create_timer(0.2).timeout
	for i in range(6): await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(output+name+".png")==OK)
	print("POLISH CAPTURE ",name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute(output)
	var save: Node=root.get_node("SaveManager")
	var pm: Node=root.get_node("PauseManager")
	save.save_path="res://tests/.tmp/polish-visual-save.json"
	save.gold=2500
	save.unlocked_characters=["fazendeiro","vovo","netinho"]
	save.maps_cleared=["horta","celeiro","pomar"]
	save.reward_receipts={}
	save.owned_skins={}
	save.equipped_skins={}
	save.selected_character="netinho"
	save.selected_map="horta"
	root.size=Vector2i(720,1280)
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await capture("lobby")
	current_scene._select_tab("Personagens")
	await capture("personagens")
	for id in ["fazendeiro","vovo","netinho"]:
		save.selected_character=id
		current_scene._select_tab("Roupas")
		await capture("roupas_"+id)
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var p: Node=current_scene.get_node("player")
	p.set_physics_process(false)
	current_scene.spawner.set_process(false)
	current_scene.spawner.spawn_timer.stop()
	for weapon in p.weapons: weapon.node.process_mode=Node.PROCESS_MODE_DISABLED
	var ids: Array=root.get_node("EnemyDB").ENEMIES.keys()
	for i in range(ids.size()):
		var enemy: Node=root.get_node("Pool").acquire(load("res://enemy.tscn"))
		current_scene.add_child(enemy)
		enemy.configure(ids[i],1,p)
		enemy.position=p.position+Vector2((i%3-1)*140,(i/3-1)*155)
		enemy.set_physics_process(false)
		enemy.get_node("ShootTimer").stop()
		enemy.get_node("BurstTimer").stop()
		enemy.get_node("JumpTimer").stop()
	await capture("mobs_gameplay")
	current_scene.pause_menu.open()
	await capture("pausa")
	current_scene.pause_menu._on_resume_pressed()
	p.survival_time=260
	p.level=12
	p.kills=187
	current_scene.checkpoint.snapshot=current_scene.checkpoint.capture()
	current_scene.checkpoint.reached_midpoint=true
	p._die()
	await create_timer(1.0).timeout
	await capture("resultado")
	var ads: Node=root.get_node("RewardedAds")
	if ads.is_demo:
		p._result_ui._request_reward("revive")
		await capture("anuncio_simulado")
		ads.provider._close(ads._active)
		await create_timer(0.2).timeout
	root.get_node("AudioManager").shutdown()
	quit()
