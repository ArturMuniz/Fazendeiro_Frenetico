extends SceneTree

var checks := 0
var failures := 0
var save: Node
var pm: Node
var pause_owner: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(60.0).timeout.connect(func() -> void:
		push_error("Map landscape suite timed out")
		quit(1))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print("PASS " if ok else "FAIL ", message)

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

func has_simulation(node: Node) -> bool:
	if node is CollisionObject2D or node is CollisionShape2D or node is NavigationRegion2D or node is Timer:
		return true
	for child in node.get_children():
		if has_simulation(child):
			return true
	return false

func covered(landscape: FarmLandscape, player: Node2D) -> bool:
	var half_view: Vector2 = root.get_visible_rect().size / player.get_node("Camera2D").zoom / 2.0
	for corner in [Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1),Vector2(1,1)]:
		if not landscape.chunks.has(landscape.chunk_at(player.global_position+half_view*corner)):
			return false
	return true

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save = root.get_node("SaveManager")
	pm = root.get_node("PauseManager")
	pause_owner = Node.new()
	root.add_child(pause_owner)
	save.save_path = "res://tests/.tmp/map-landscape-save.json"
	save.maps_cleared = ["horta", "celeiro", "pomar"]
	save.selected_character = "fazendeiro"
	save.farm_upgrades = {}
	save.reward_receipts = {}
	var campaign_before := hash(var_to_str(root.get_node("MapDB").MAPS))
	var signatures: Array[int] = []
	for id in ["horta", "celeiro", "pomar"]:
		save.selected_map = id
		pm.change_scene("res://main.tscn")
		await scene_changed
		await process_frame
		var player: Node = current_scene.get_node("player")
		var spawner: Node = current_scene.get_node("EnemySpawner")
		spawner.set_process(false)
		spawner.spawn_timer.stop()
		player.set_physics_process(false)
		for weapon in player.weapons:
			weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
		var speed: float = player.speed
		var health: float = player.max_health
		var radius: float = player.get_node("CollisionShape2D").shape.radius
		var landscape: FarmLandscape = current_scene.landscape
		check(current_scene.current_map_id == id and landscape.map_id == id,id+" escolhe a paisagem correta")
		check(not current_scene.get_node("GroundTileMap").visible,id+" remove o piso antigo da apresentação")
		check(not has_simulation(landscape.chunks[Vector2i.ZERO]),id+" parcelas decorativas não possuem física, navegação ou timers")
		check(landscape.landmarks.bounds.size() == 5,id+" construções e cercas únicas têm colisões próprias")
		check(landscape.z_index < player.z_index,id+" cenário fica atrás dos atores e ataques")
		check(landscape.chunks.size() == landscape.cache_limit(),id+" cache cobre somente a região necessária")
		check(covered(landscape,player),id+" viewport inicial tem chão em todos os cantos")
		var parcel: Node = landscape.chunks[Vector2i.ZERO]
		check(parcel.floor_commands[0].rect == Rect2(-512,-512,1024,1024),id+" parcela preenche a superfície inteira")
		var rural_groups: Dictionary = {}
		for prop in parcel.props: rural_groups[prop.id] = true
		check(rural_groups.size() >= 4,id+" mantém variedade rural na clareira, sem exigir densidade de obstáculos")
		var signature := hash(var_to_str(parcel.props)+var_to_str(parcel.floor_commands))
		signatures.append(signature)
		var clear_spawn := true
		for prop in parcel.props:
			clear_spawn = clear_spawn and prop.foot.length() >= 150
		check(clear_spawn,id+" área inicial livre de objetos altos")
		# Deterministic scenery must not consume the RNG used by gameplay.
		seed(461721)
		var expected_random := randi()
		seed(461721)
		var probe: Node = load("res://farm_landscape_chunk.gd").new()
		root.add_child(probe)
		probe.build(id,Vector2i(17,-23))
		check(randi() == expected_random,id+" geração não altera RNG global do combate")
		probe.queue_free()
		for destination in [Vector2(520,520),Vector2(-520,-520),Vector2(15400,-20100),Vector2(-22100,18000)]:
			player.position = destination
			landscape.refresh()
			check(covered(landscape,player),id+" mantém cobertura em "+str(destination))
			check(landscape.chunks.size() == landscape.cache_limit(),id+" cache não cresce com distância percorrida")
		player.position = Vector2.ZERO
		landscape.refresh()
		parcel = landscape.chunks[Vector2i.ZERO]
		check(hash(var_to_str(parcel.props)+var_to_str(parcel.floor_commands)) == signature,id+" retorno recompõe o mesmo cenário")
		var camera: Camera2D = player.get_node("Camera2D")
		camera.zoom = Vector2.ONE * 0.55
		landscape.refresh()
		check(covered(landscape,player) and landscape.chunks.size() == landscape.cache_limit(),id+" cobertura acompanha zoom e viewport")
		camera.zoom = Vector2.ONE
		landscape.refresh()
		var previous_center: Vector2i = landscape._last_center
		pm.acquire(pause_owner, &"map_test")
		player.position = Vector2(1100,0)
		await wait(0.12)
		check(landscape._last_center == previous_center,id+" pausa congela a atualização do cenário")
		pm.release(pause_owner)
		await process_frame
		await process_frame
		check(landscape._last_center == landscape.chunk_at(player.position),id+" streaming retoma após pausa")
		# Cross the decorated bed/building/tree area using the real physics loop.
		player.position = {"horta":Vector2(-266,258),"celeiro":Vector2(-294,-240),"pomar":Vector2(270,30)}[id]
		var start: Vector2 = player.position
		player.joystick._output = Vector2.RIGHT * 0.5
		player.set_physics_process(true)
		await wait(0.2)
		player.set_physics_process(false)
		check(player.position.x > start.x+3 and is_equal_approx(player.velocity.length(),speed*0.5),id+" cenário não bloqueia nem desacelera movimento")
		player.joystick.reset_input()
		check(player.speed == speed and player.max_health == health and player.get_node("CollisionShape2D").shape.radius == radius,id+" arte preserva atributos e hitbox")
		await process_frame
		check(landscape.get_child_count() == landscape.chunks.size() + 1,id+" parcelas antigas são removidas; marcos são únicos")
	check(signatures[0] != signatures[1] and signatures[1] != signatures[2] and signatures[0] != signatures[2],"três mapas possuem composições distintas")
	check(hash(var_to_str(root.get_node("MapDB").MAPS)) == campaign_before,"dados de campanha, chefes e balanceamento permanecem intactos")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	pause_owner.queue_free()
	root.get_node("AudioManager").shutdown()
	await wait(0.15)
	print("MAP RESULT checks=%d failures=%d" % [checks,failures])
	quit(0 if failures == 0 else 1)
