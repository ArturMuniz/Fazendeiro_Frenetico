extends SceneTree

var checks := 0
var failures := 0
var pm: Node
var save: Node
var actor: Node
var spawner: Node
var data: Script
var owner: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(80).timeout.connect(func() -> void: push_error("S24 suite timeout"); quit(1))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", message)

func new_run(map_id: String = "horta") -> void:
	save.selected_map = map_id
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	actor = current_scene.get_node("player")
	spawner = current_scene.spawner
	spawner.set_process(false)
	spawner.spawn_timer.stop()
	actor.set_physics_process(false)
	for entry in actor.weapons: entry.node.process_mode = Node.PROCESS_MODE_DISABLED

func run() -> void:
	data = load("res://ui_data.gd")
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	pm = root.get_node("PauseManager")
	save = root.get_node("SaveManager")
	save.save_path = "res://tests/.tmp/s24-feedback-save.json"
	save.selected_character = "fazendeiro"
	save.farm_upgrades = {}
	save.reward_receipts = {}
	save.maps_cleared = ["horta", "celeiro", "pomar"]
	owner = Node.new()
	root.add_child(owner)
	await new_run()
	await controls()
	await inventory_and_stats()
	await encounters()
	await checkpoint()
	await scenery()
	pm.change_scene("res://hub.tscn")
	await scene_changed
	owner.queue_free()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.1).timeout
	print("S24 RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)

func controls() -> void:
	for view in [Vector2(720, 1560), Vector2(360, 780), Vector2(1280, 720)]:
		var safe := Rect2(0, 24, view.x, view.y - 60)
		var geometry: Dictionary = load("res://TouchJoystick.gd").geometry(view, safe)
		var reach: float = geometry.radius + geometry.knob / 2
		check(safe.encloses(Rect2(geometry.center - Vector2.ONE * reach, Vector2.ONE * reach * 2)), "curso completo do polegar cabe na área segura %s" % view)
	var joystick: Node = actor.joystick
	check(joystick.joystick_radius >= 90, "joystick de referência aumentou de 60 para 96 unidades")
	for i in range(8):
		var direction := Vector2.from_angle(i * TAU / 8)
		joystick._update_handle(joystick.base.get_global_rect().get_center() + direction * joystick.joystick_radius)
		check(joystick.get_vector().is_equal_approx(direction), "joystick alcança intensidade total na direção %d" % i)
	joystick.reset_input()
	var touch := InputEventScreenTouch.new()
	touch.index = 4
	touch.pressed = true
	touch.position = joystick.base.get_global_rect().get_center() + Vector2.RIGHT * joystick.joystick_radius * 0.7
	root.push_input(touch, true)
	var other := InputEventScreenTouch.new()
	other.index = 5
	other.pressed = false
	root.push_input(other, true)
	check(joystick._touch_index == 4 and joystick.get_vector().x > 0.5, "outro dedo não libera nem rouba o joystick")
	touch.pressed = false
	root.push_input(touch, true)
	check(joystick.get_vector() == Vector2.ZERO, "dedo proprietário libera o controle")

func inventory_and_stats() -> void:
	actor.add_weapon("milho")
	actor.add_weapon("forquilha")
	actor.add_weapon("batata")
	check(actor.weapons.size() == 3 and data.level_of(actor.weapons, "batata") == 0, "quarta arma é rejeitada pela regra de inventário")
	actor.add_weapon("milho")
	check(data.level_of(actor.weapons, "milho") == 2, "inventário cheio permite evoluir uma arma equipada")
	var cards: Node = current_scene.get_node("LevelUpUI")
	var valid := true
	var varied := true
	for trial in range(200):
		var choices: Array = cards.roll_choices()
		var ids: Array = []
		var categories: Array = []
		for choice in choices:
			valid = valid and not ids.has(choice.id)
			ids.append(choice.id)
			if choice.has("weapon_id"):
				valid = valid and data.level_of(actor.weapons, choice.weapon_id) > 0 and not actor.is_weapon_unavailable(choice.weapon_id)
				categories.append("weapon")
			elif choice.has("passive_id"): categories.append("passive")
			else: categories.append("stat")
		varied = varied and choices.size() == 3 and categories.has("weapon") and categories.has("passive") and categories.has("stat")
	check(valid, "200 sorteios não oferecem quarta arma, duplicata ou evolução inválida")
	check(varied, "200 sorteios oferecem arma, item e atributo quando disponíveis")
	for entry in actor.weapons:
		while entry.level < 3: actor.add_weapon(entry.id)
	check(not cards.available_upgrades().any(func(u: Dictionary) -> bool: return u.has("weapon_id")), "três armas no máximo retiram armas da oferta")
	check(cards.roll_choices().size() == 3, "build completa continua oferecendo três melhorias úteis")
	actor.cooldown_multiplier = 0.20
	actor.defense_percent = 0.75
	check(not cards.available_upgrades().any(func(u: Dictionary) -> bool: return u.id in ["cooldown", "defense", "passive_termica", "passive_espantalho"]), "ofertas no piso de intervalo e teto de defesa são filtradas")
	for id in ["queijo", "caderno", "amolador"]:
		for tier in range(3): actor.add_passive(id)
	check(is_equal_approx(actor.regeneration, 1.5) and is_equal_approx(actor.xp_bonus, 0.35) and is_equal_approx(actor.damage_bonus, 6), "três itens novos aplicam os totais de nível 3")
	actor.health = 50
	actor._physics_process(0.5)
	check(is_equal_approx(actor.health, 50.75), "regeneração recupera vida proporcional ao tempo de gameplay")
	actor.xp_to_next = 1000
	actor.xp = 0
	actor.add_xp(10)
	check(is_equal_approx(actor.xp, 13.5), "bônus de XP altera a coleta efetiva")
	actor.set_physics_process(true)
	pm.acquire(owner, &"pause")
	var health: float = actor.health
	await create_timer(0.12).timeout
	check(is_equal_approx(actor.health, health), "regeneração congela durante pausa")
	pm.release(owner)
	actor.set_physics_process(false)
	actor.health = actor.max_health - 0.1
	actor._physics_process(1)
	check(actor.health == actor.max_health, "regeneração respeita a vida máxima")

func encounters() -> void:
	await new_run()
	spawner._process_campaign(60)
	check(spawner._leader_id == "pulgao" and is_equal_approx(spawner._leader_warning_left, 1.8), "60% da fase anuncia líder com 1,8 s de antecedência")
	check(get_nodes_in_group("enemies").is_empty(), "aviso não cria contato ou dano antes do líder")
	pm.acquire(owner, &"pause")
	await create_timer(0.12).timeout
	check(is_equal_approx(spawner._leader_warning_left, 1.8), "pausa congela a contagem do encontro")
	pm.release(owner)
	spawner._process_encounter(1.8)
	var leaders := get_nodes_in_group("enemies").filter(func(e: Node) -> bool: return e.is_leader)
	check(leaders.size() == 1 and get_nodes_in_group("enemies").size() == 5, "um líder chega com quatro integrantes da escolta")
	var leader: Node = leaders[0]
	check(leader.max_health > 50 and leader.sprite.scale == Vector2.ONE * 1.25, "líder tem vida e sinalização visual próprias")
	check(leader.body_shape.shape != get_nodes_in_group("enemies")[1].body_shape.shape, "líder mantém colisão individual")
	current_scene.hud._process(0)
	check(current_scene.hud._boss.visible and current_scene.hud._boss_label.text.begins_with("Líder"), "HUD mostra nome e vida do líder")
	for enemy in get_nodes_in_group("enemies"):
		if enemy != leader: enemy._despawn()
	await process_frame
	await process_frame
	var balance: int = save.gold
	leader.take_damage(100000)
	leader.die()
	await process_frame
	await process_frame
	check(actor.kills == 1 and not actor.boss_defeated and save.gold == balance, "morte do líder não dá vitória nem duplica abate")
	check(actor.pending_level_ups == 1 and paused, "líder concede exatamente uma melhoria")
	var cards: Node = current_scene.get_node("LevelUpUI")
	cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
	spawner._process_encounter(0)
	check(spawner._leader_id.is_empty() and spawner._leader_phases == [0], "encontro não repete na mesma fase")
	var reused: Node = spawner._spawn_enemy("pulgao")
	check(reused == leader and not reused.is_leader and reused.max_health < 10 and reused.sprite.scale == Vector2.ONE, "pool remove vida extra, marcação e escala do antigo líder")
	reused._despawn()
	await process_frame
	await process_frame
	spawner._begin_phase(1)
	spawner.spawn_timer.stop()
	spawner._phase_elapsed = 66
	spawner._process_encounter(0)
	check(spawner._leader_id == "lesma", "segunda fase oferece outro arquétipo de líder")
	spawner._process_encounter(2)
	check(get_nodes_in_group("enemies").any(func(e: Node) -> bool: return e.is_leader and e.enemy_id == "lesma"), "segundo líder chega sem depender de matar o chefe final")
	for enemy in get_nodes_in_group("enemies"): enemy._despawn()
	await process_frame
	await process_frame
	spawner.max_active_enemies = 1
	spawner._begin_phase(2)
	spawner.spawn_timer.stop()
	spawner._phase_elapsed = 72
	spawner._process_encounter(0)
	var blocker: Node = spawner._spawn_enemy("pulgao")
	spawner._process_encounter(2)
	check(get_nodes_in_group("enemies").size() == 1 and not spawner._leader_id.is_empty(), "encontro espera vaga no limite de inimigos")
	blocker._despawn()
	await process_frame
	await process_frame
	spawner._process_encounter(0)
	check(get_nodes_in_group("enemies").size() == 1 and get_nodes_in_group("enemies")[0].is_leader, "líder respeita limite sem adicionar escolta excedente")

func checkpoint() -> void:
	await new_run()
	actor.add_passive("queijo")
	actor.add_passive("caderno")
	var leader: Node = spawner._spawn_enemy("lesma", true, Vector2(600, 0))
	leader.set_physics_process(false)
	leader.health = 37
	spawner._leader_phases = [0]
	var checkpoint: Node = current_scene.checkpoint
	checkpoint.snapshot = checkpoint.capture()
	var maximum: float = leader.max_health
	actor.regeneration = 99
	actor.xp_bonus = 99
	spawner._leader_phases.clear()
	pm.acquire(owner, &"pause")
	var restored: bool = await checkpoint.restore()
	var enemies := get_nodes_in_group("enemies")
	check(restored and enemies.size() == 1 and enemies[0].is_leader and is_equal_approx(enemies[0].max_health, maximum) and enemies[0].health == 37, "checkpoint restaura líder sem multiplicar vida novamente")
	check(is_equal_approx(actor.regeneration, 0.4) and is_equal_approx(actor.xp_bonus, 0.1), "checkpoint restaura atributos novos sem reaplicar itens")
	check(spawner._leader_phases == [0] and checkpoint.midpoint == spawner.campaign_duration() / 2, "checkpoint preserva encontros consumidos e usa duração compartilhada")
	pm.release(owner)

func scenery() -> void:
	for id in ["horta", "celeiro", "pomar"]:
		await new_run(id)
		var landscape: Node = current_scene.landscape
		var landmarks: Node = landscape.landmarks
		var buildings: Array = landmarks.props.filter(func(p: Dictionary) -> bool: return p.id in ["barn_building", "garden_shed"])
		check(buildings.size() == 1, id + " tem somente uma construção principal")
		var central := Rect2(-400, -600, 800, 1200)
		check(not landmarks.bounds.any(func(rect: Rect2) -> bool: return rect.intersects(central)), id + " mantém toda colisão arquitetônica fora da clareira central")
		var repeated := false
		for chunk in landscape.chunks.values():
			for prop in chunk.props:
				repeated = repeated or prop.id in ["barn_building", "garden_shed", "horta_cerca"]
		check(not repeated, id + " não repete casas ou cercas no streaming")
		var obstacle: Rect2 = landmarks.bounds[0]
		var from := Vector2(obstacle.position.x - 65, obstacle.get_center().y)
		var to := Vector2(obstacle.end.x + 65, obstacle.get_center().y)
		var point := from
		var routed := true
		for step in range(250):
			var next: Vector2 = landscape.obstacles.next_waypoint(point, to)
			var movement := point.move_toward(next, 10)
			routed = routed and not landscape.obstacles.blocked(point, movement, 14)
			point = movement
			if point.distance_to(to) < 5: break
		check(routed and point.distance_to(to) < 5, id + " rota contorna prédio sem atravessar paredes")
		actor.position = from
		actor.joystick._output = Vector2.RIGHT
		actor.set_physics_process(true)
		await create_timer(0.7).timeout
		actor.set_physics_process(false)
		actor.joystick.reset_input()
		check(actor.position.x <= obstacle.position.x - 15, id + " colisão real impede jogador de atravessar parede")
		actor.position = obstacle.get_center()
		var clear_spawns := true
		for trial in range(100): clear_spawns = clear_spawns and landscape.obstacles.is_clear(spawner._spawn_point(), 40)
		check(clear_spawns, id + " 100 posições de surgimento ficam fora das construções")
		actor.position = to
		var enemy: Node = spawner._spawn_enemy("pulgao", false, from)
		var arrived := false
		for step in range(700):
			await physics_frame
			if enemy.global_position.distance_to(to) < 55:
				arrived = true
				break
		check(arrived, id + " inimigo percorre desvio usando movimento e colisões reais")
		enemy._despawn()
		await process_frame
		await process_frame
		var projectile: Node = load("res://projectile.tscn").instantiate()
		current_scene.add_child(projectile)
		projectile.setup(Vector2.RIGHT, 200, 5)
		projectile._on_body_entered(landmarks.get_child(0))
		check(projectile._despawning, id + " paredes interceptam projéteis")
