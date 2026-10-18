extends SceneTree
var checks:=0
var failures:=0
func _initialize() -> void: call_deferred("run")
func check(ok: bool,text: String) -> void:
	checks+=1
	if not ok: failures+=1
	print("PASS " if ok else "FAIL ",text)
func run() -> void:
	var save: Node=root.get_node("SaveManager")
	var pm: Node=root.get_node("PauseManager")
	save.save_path="res://tests/.tmp/actor-polish-save.json"
	save.selected_character="netinho"
	save.selected_map="horta"
	save.farm_upgrades={}
	for id in GameArt.REFINED:
		var correct:=true
		for data in GameArt.actor(id).values():
			correct=correct and data.frames.size()==data.durations_ms.size() and data.offset.size()==2
			for path in data.frames:
				var im:=GameArt.texture(path).get_image()
				var b:=im.get_used_rect()
				correct=correct and b.position.x>0 and b.position.y>0 and b.end.x<im.get_width() and b.end.y<im.get_height()
		check(correct,id+" tem duração por quadro, offset válido e margens livres")
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var p: Node=current_scene.get_node("player")
	p.set_physics_process(false)
	current_scene.spawner.set_process(false)
	current_scene.spawner.spawn_timer.stop()
	for weapon in p.weapons: weapon.node.process_mode=Node.PROCESS_MODE_DISABLED
	await create_timer(0.2).timeout
	var owner:=Node.new()
	root.add_child(owner)
	for id in ["gafanhoto","boss_gafanhoto_gigante"]:
		var enemy: Node=root.get_node("Pool").acquire(load("res://enemy.tscn"))
		current_scene.add_child(enemy)
		enemy.configure(id,1,p)
		enemy.position=p.position+Vector2(900,0)
		await create_timer(0.05).timeout
		var radius: float=enemy.body_shape.shape.radius
		enemy._on_jump_timer_timeout()
		for tick in range(5): await physics_frame
		if not enemy._jumping or enemy.sprite.position.y>=0:
			print("ARC DIAGNOSTIC ",id," jumping=",enemy._jumping," left=",enemy._landing_timer.time_left," sprite=",enemy.sprite.position," paused=",paused," processing=",enemy.is_physics_processing()," target=",is_instance_valid(enemy._player)," despawn=",enemy._despawning)
		check(enemy._jumping and enemy.sprite.position.y<0,id+" desenha arco sem mover a origem da colisão")
		check(enemy.body_shape.position==Vector2.ZERO and enemy.body_shape.shape.radius==radius,id+" mantém collider e balanceamento durante salto")
		pm.acquire(owner,&"pause")
		var left: float=enemy._landing_timer.time_left
		var frame: int=enemy.art_animator.frame_index
		var visual: Vector2=enemy.sprite.position
		await create_timer(0.12).timeout
		check(is_equal_approx(enemy._landing_timer.time_left,left) and enemy.art_animator.frame_index==frame and enemy.sprite.position==visual,id+" congela pouso e arco junto com a pausa")
		pm.release(owner)
		await create_timer(0.5).timeout
		check(not enemy._jumping and enemy.sprite.position==Vector2.ZERO,id+" pousa no instante original e restaura posição visual")
		enemy.sprite.position.y=-20
		enemy.configure(id,1,p)
		check(enemy.sprite.position==Vector2.ZERO and not enemy._jumping,id+" limpa deslocamento ao reutilizar inimigo")
		enemy._despawn()
		await process_frame
		await process_frame
	pm.change_scene("res://hub.tscn")
	await scene_changed
	owner.queue_free()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.25).timeout
	print("ACTOR POLISH RESULT checks=%d failures=%d" % [checks,failures])
	quit(1 if failures else 0)
