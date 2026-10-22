extends SceneTree

var checks := 0
var failures := 0
var pm: Node
var save: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(65).timeout.connect(func() -> void: push_error("Finite arena suite timeout"); quit(2))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", message)

func settle() -> void:
	for i in range(5): await process_frame

func run() -> void:
	pm = root.get_node("PauseManager")
	save = root.get_node("SaveManager")
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save.save_path = "res://tests/.tmp/finite-map-save.json"
	save.selected_character = "fazendeiro"
	save.maps_cleared = ["horta","celeiro","pomar"]
	save.farm_upgrades = {}
	save.reward_receipts = {}
	for id in ["horta","celeiro","pomar"]:
		save.selected_map = id
		pm.change_scene("res://main.tscn")
		await scene_changed
		await settle()
		var landscape: FarmLandscape = current_scene.landscape
		var player: Node = current_scene.get_node("player")
		player.set_physics_process(false)
		current_scene.spawner.set_process(false)
		current_scene.spawner.spawn_timer.stop()
		for weapon in player.weapons: weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
		check(landscape.map_id == id and landscape.plate.texture.resource_path == ArenaMaps.DATA[id].texture, id+" carrega a composição aprovada")
		check(landscape.get_child_count() == 2 and landscape.landmarks.get_child_count() == 4, id+" cenário estático, quatro limites únicos e sem streaming")
		check(landscape.obstacles.is_clear(Vector2.ZERO,80), id+" centro livre para jogador e chefe")
		check(not landscape.obstacles.is_clear(Vector2(30000,30000)), id+" impede destinos além da arena")
		var probe := CharacterBody2D.new()
		probe.collision_layer = 0
		probe.collision_mask = 8
		var collider := CollisionShape2D.new()
		var shape := CircleShape2D.new()
		shape.radius = 16
		collider.shape = shape
		probe.add_child(collider)
		current_scene.add_child(probe)
		var arena := landscape.play_bounds
		for pair in [[Vector2(arena.end.x-30,0),Vector2(200,0)], [Vector2(arena.position.x+30,0),Vector2(-200,0)], [Vector2(0,arena.position.y+30),Vector2(0,-200)], [Vector2(0,arena.end.y-30),Vector2(0,200)]]:
			probe.position = pair[0]
			await physics_frame
			var hit := probe.move_and_collide(pair[1])
			check(hit != null and arena.has_point(probe.position), id+" borda bloqueia corpo real")
		probe.queue_free()
		for origin in [Vector2.ZERO, arena.position+Vector2.ONE*18, arena.end-Vector2.ONE*18]:
			var valid := true
			for i in range(100):
				var spawn := landscape.spawn_point(origin,400)
				valid = valid and landscape.obstacles.is_clear(spawn,40) and spawn.distance_to(origin)>=220
			check(valid,id+" 100 spawns acessíveis e afastados do jogador")
		for dimensions in [Vector2i(360,640),Vector2i(720,1280),Vector2i(1080,2400),Vector2i(1440,3120),Vector2i(1600,2560),Vector2i(1280,720)]:
			root.size = dimensions
			await settle()
			var view := root.get_visible_rect().size
			check(view.x >= 720 and view.y >= 1280, id+" mantém renderização interna HD em "+str(dimensions))
			var camera: Camera2D = player.get_node("Camera2D")
			check((view/camera.zoom).x <= ArenaMaps.WORLD_SIZE.x+1 and (view/camera.zoom).y <= ArenaMaps.WORLD_SIZE.y+1,id+" câmera não revela espaço fora da arte")
			var hud: Node = current_scene.hud
			check(root.get_visible_rect().encloses(hud._top.get_global_rect()) and root.get_visible_rect().encloses(hud._dock.get_global_rect()),id+" HUD cabe na proporção testada")
		var count := landscape.get_child_count()
		landscape.refresh()
		check(landscape.get_child_count()==count,id+" redimensionar não duplica cenário ou colisões")
	root.size = Vector2i(720,1280)
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await settle()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.1).timeout
	print("MAP RESULT checks=%d failures=%d" % [checks,failures])
	quit(1 if failures else 0)
