extends SceneTree

## Execute: Godot --headless --path . --script res://tests/stability_suite.gd
## Saves de teste ficam em tests/.tmp; o save real nunca é escrito.
var failures: int = 0
var checks: int = 0
var pm: Node
var pool: Node
var save: Node
var scene: Node
var player: Node


func _initialize() -> void:
	call_deferred("run")


func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
	print("PASS " if condition else "FAIL ", description)


func delay(seconds: float) -> void:
	await create_timer(seconds).timeout


func new_run() -> void:
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	scene = current_scene
	player = scene.get_node("player")
	scene.get_node("EnemySpawner").set_process(false)
	scene.get_node("EnemySpawner/SpawnTimer").stop()
	player.health = 100000.0
	for weapon in player.weapons:
		weapon["node"].process_mode = Node.PROCESS_MODE_DISABLED


func spawn_enemy(id: String) -> Node:
	var enemy: Node = pool.acquire(load("res://enemy.tscn"))
	scene.add_child(enemy)
	enemy.position = Vector2(3000, 3000)
	enemy.configure(id, 1.0, player)
	return enemy


func find_victory() -> Node:
	for child in scene.get_children():
		if child.get_script() != null and child.get_script().resource_path == "res://boss_victory_ui.gd":
			return child
	return null


func run() -> void:
	pm = root.get_node("PauseManager")
	pool = root.get_node("Pool")
	save = root.get_node("SaveManager")
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save.save_path = "res://tests/.tmp/save.json"
	save.gold = 0
	save.maps_cleared = []
	save.reward_receipts = {}
	save.farm_upgrades = {}
	save.selected_map = "horta"
	await new_run()
	await test_joystick()
	await test_modals()
	await test_enemies_and_timers()
	await test_runs()
	await test_rewards()
	await test_campaign()
	await test_navigation()
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await process_frame
	pool.clear_idle()
	await process_frame
	root.get_node("AudioManager").shutdown()
	await delay(0.15)
	print("RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)


func test_joystick() -> void:
	var joystick: Node = scene.get_node("CanvasLayer/VirtualJoystick")
	var base: Control = joystick.get_node("Base")
	var handle: Control = joystick.get_node("Handle")
	var rect := base.get_global_rect()
	check(root.get_visible_rect().encloses(rect), "joystick inteiramente dentro da viewport")
	check(rect.get_center().is_equal_approx(handle.get_global_rect().get_center()), "indicador centralizado")
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.pressed = true
	touch.position = rect.get_center() + Vector2(joystick.joystick_radius * 0.6, 0)
	root.push_input(touch, true)
	await process_frame
	check(joystick.get_vector().x > 0.4, "toque real produz movimento")
	var old_position: Vector2 = player.position
	await delay(0.08)
	check(player.position.x > old_position.x, "jogador se desloca com joystick")
	var menu: Node = scene.get_node("PauseMenu")
	menu.open()
	check(joystick.get_vector() == Vector2.ZERO, "pausa limpa vetor de movimento")
	touch.pressed = false
	root.push_input(touch, true)
	await process_frame
	menu._on_resume_pressed()
	check(joystick.get_vector() == Vector2.ZERO and joystick._touch_index == -1, "soltar durante pausa não prende o controle")
	joystick._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(joystick.get_vector() == Vector2.ZERO, "perda de foco limpa entrada")
	for viewport_size in [Vector2i(360, 640), Vector2i(1080, 2400), Vector2i(1280, 720)]:
		root.size = viewport_size
		await process_frame
		check(root.get_visible_rect().encloses(base.get_global_rect()), "joystick dentro da tela %s" % viewport_size)
	root.size = Vector2i(720, 1280)
	await process_frame


func test_modals() -> void:
	var first := CanvasLayer.new()
	var second := CanvasLayer.new()
	scene.add_child(first)
	scene.add_child(second)
	pm.acquire(first, &"pause")
	pm.acquire(first, &"pause")
	pm.acquire(second, &"level_up")
	check(paused and second.visible and not first.visible, "prioridade modal e aquisição idempotente")
	pm.release(second)
	check(paused and first.visible, "fechar uma tela preserva outra pausa")
	first.queue_free()
	second.queue_free()
	await process_frame
	await process_frame
	check(not paused, "saída da árvore libera bloqueio")
	player.grant_free_level_up()
	player.grant_free_level_up()
	var cards: Node = scene.get_node("LevelUpUI")
	var menu: Node = scene.get_node("PauseMenu")
	menu.open()
	menu._on_resume_pressed()
	check(paused and cards.visible and not menu.visible, "pausa manual não atravessa cartas")
	var generation: int = cards._card_generation
	cards._on_upgrade_chosen({"id": "damage"}, generation)
	cards._on_upgrade_chosen({"id": "damage"}, generation)
	check(player.pending_level_ups == 1 and paused, "clique duplicado não consome segunda carta")
	cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
	check(not paused and player.pending_level_ups == 0, "última carta retoma gameplay")
	pm._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(paused, "perda de foco pausa gameplay")
	pm._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	check(not paused, "retorno de foco libera apenas seu bloqueio")


func test_enemies_and_timers() -> void:
	var small := spawn_enemy("pulgao")
	var radius: float = small.get_node("CollisionShape2D").shape.radius
	var boss := spawn_enemy("boss_lagarta")
	check(is_equal_approx(small.get_node("CollisionShape2D").shape.radius, radius), "chefe não altera raio do pulgão")
	check(small.get_node("Hitbox/CollisionShape2D").shape != boss.get_node("Hitbox/CollisionShape2D").shape, "hitboxes independentes")
	small._despawn()
	small._despawn()
	check(not small.is_in_group("enemies"), "inimigo morto sai imediatamente dos alvos")
	var health: float = player.health
	small._on_hitbox_body_entered(player)
	check(player.health == health, "inimigo desativado não causa dano")
	await process_frame
	await process_frame
	check(small._player == null, "pool limpa referência do jogador")
	var reused := spawn_enemy("boss_gafanhoto_gigante")
	check(reused == small and reused._player == player, "pool reutiliza com alvo atual")
	reused._on_jump_timer_timeout()
	reused._landing_timer.start(0.15)
	var projectile: Node = load("res://projectile.tscn").instantiate()
	var enemy_projectile: Node = load("res://enemy_projectile.tscn").instantiate()
	for shot in [projectile, enemy_projectile]:
		scene.add_child(shot)
		shot.position = Vector2(7000, 7000)
		shot.lifetime = 0.15
		shot.setup(Vector2.RIGHT, 250.0, 1.0)
	var foice: Node = load("res://thrown_foice.tscn").instantiate()
	scene.add_child(foice)
	foice.position = Vector2(7000, 6000)
	foice.setup(foice.position, 1.0, 36.0, 0.15, null)
	foice._traveling = false
	foice._start_spin()
	var lock := Node.new()
	scene.add_child(lock)
	pm.acquire(lock, &"pause")
	var remaining: float = projectile._lifetime_timer.time_left
	await delay(0.25)
	check(not projectile._despawning and not enemy_projectile._despawning, "projéteis de ambos os lados congelam durante pausa")
	check(is_equal_approx(projectile._lifetime_timer.time_left, remaining), "tempo restante preservado")
	check(is_instance_valid(foice) and reused._jumping, "foice e salto congelam durante pausa")
	pm.release(lock)
	lock.queue_free()
	await delay(0.22)
	check(projectile._despawning and enemy_projectile._despawning, "projéteis expiram após retomar")
	check(not is_instance_valid(foice) and not reused._jumping, "foice e salto terminam após retomar")
	reused._on_jump_timer_timeout()
	reused._despawn()
	await process_frame
	await process_frame
	reused = spawn_enemy("pulgao")
	await delay(0.45)
	check(not reused._jumping and reused._landing_timer.is_stopped(), "salto antigo cancelado na reutilização")


func test_runs() -> void:
	for i in range(10):
		var enemy := spawn_enemy("mosca" if i % 2 == 0 else "gafanhoto")
		enemy._despawn()
		await process_frame
		await process_frame
		var previous_player: WeakRef = weakref(player)
		scene.get_node("PauseMenu").open()
		scene.get_node("PauseMenu")._on_retry_pressed()
		await scene_changed
		await process_frame
		scene = current_scene
		player = scene.get_node("player")
		scene.get_node("EnemySpawner").set_process(false)
		scene.get_node("EnemySpawner/SpawnTimer").stop()
		player.health = 100000.0
		var next_enemy := spawn_enemy("pulgao")
		check(previous_player.get_ref() == null and next_enemy._player == player and not paused, "run consecutiva %d: alvo novo e pausa limpa" % (i + 1))


func test_rewards() -> void:
	await new_run()
	player.survival_time = 350.0
	player.level = 12
	player.set_physics_process(false)
	var initial_gold: int = save.gold
	player.grant_free_level_up()
	player.register_kill(true)
	var victory := find_victory()
	check(victory.visible and not scene.get_node("LevelUpUI").visible, "vitória tem prioridade sobre carta pendente")
	check(save.gold == initial_gold + 150 and save.is_map_cleared("horta"), "primeira vitória paga 150 imediatamente")
	save.load_data()
	check(save.gold == initial_gold + 150 and save.is_map_cleared("horta"), "prêmio e conclusão persistidos juntos")
	player.register_kill(true)
	save.claim_boss_reward(player._run_id, "horta")
	check(save.gold == initial_gold + 150, "vitória duplicada não paga novamente")
	victory._on_continue_pressed()
	check(paused and scene.get_node("LevelUpUI").visible, "endless restaura carta pendente")
	var cards: Node = scene.get_node("LevelUpUI")
	cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
	player._die()
	check(save.gold == initial_gold + 276, "endless e morte preservam vitória, bônus antigo de 20 e base")
	player._settle_and_show_results()
	check(save.gold == initial_gold + 276, "liquidação repetida idempotente")
	await new_run()
	player.register_kill(true)
	check(save.gold == initial_gold + 326, "vitória repetida paga apenas 50")
	find_victory()._on_end_pressed()
	check(player.is_dead() and player._result_ui.visible, "encerrar vitória abre resultado")
	await new_run()
	var old_maps: Array = save.maps_cleared.duplicate()
	var old_gold: int = save.gold
	var valid_path: String = save.save_path
	save.save_path = "res://tests/.tmp/nonexistent/save.json"
	var failure: Dictionary = save.claim_boss_reward("failed-write", "celeiro")
	check(not failure["ok"] and save.gold == old_gold and save.maps_cleared == old_maps, "falha de save reverte moeda e desbloqueio")
	player.register_kill(true)
	check(find_victory()._save_error and paused, "erro de save mantém vitória pausada com retry")
	save.save_path = valid_path
	find_victory()._on_end_pressed()
	check(not find_victory()._save_error and save.gold == old_gold + 50, "retry persiste prêmio uma vez")
	find_victory()._on_continue_pressed()
	save.save_path = "res://tests/.tmp/nonexistent/save.json"
	player._die()
	check(player._result_ui._save_failed and paused, "falha de liquidação oferece retry sem sair")
	save.save_path = valid_path
	player._result_ui._on_retry_pressed()
	check(not player._result_ui._save_failed, "retry da liquidação recupera resultado")


func test_campaign() -> void:
	for map_id in ["horta", "celeiro", "pomar"]:
		save.selected_map = map_id
		await new_run()
		var spawner: Node = scene.get_node("EnemySpawner")
		for phase in range(3):
			spawner._end_phase()
			check(paused and player.pending_level_ups == 1, "%s fase %d concede carta pausada" % [map_id, phase + 1])
			var cards: Node = scene.get_node("LevelUpUI")
			cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
			spawner._process_campaign(4.1)
		var boss: Node
		for enemy in get_nodes_in_group("enemies"):
			if enemy.enemy_id.begins_with("boss_"):
				boss = enemy
		check(boss != null, "%s cria chefe após três fases" % map_id)
		boss.take_damage(1000000)
		await process_frame
		check(find_victory() != null and save.is_map_cleared(map_id), "%s vitória real do chefe desbloqueia progresso" % map_id)
		find_victory()._on_end_pressed()
		check(paused and player._result_ui.visible, "%s encerra com resultado pausado" % map_id)


func test_navigation() -> void:
	save.selected_map = "horta"
	await new_run()
	player.set_physics_process(false)
	player.survival_time = 100.0
	player.level = 2
	var old_gold: int = save.gold
	player.register_kill(true)
	find_victory()._on_next_pressed()
	await scene_changed
	await process_frame
	scene = current_scene
	player = scene.get_node("player")
	check(save.selected_map == "celeiro" and not paused, "próximo mapa inicia sem bloqueio residual")
	check(save.gold == old_gold + 76 and player.level == 1, "avanço paga base uma vez e reinicia build")
	scene.get_node("PauseMenu").open()
	scene.get_node("PauseMenu")._on_hub_pressed()
	await scene_changed
	await process_frame
	check(current_scene.scene_file_path == "res://hub.tscn" and not paused, "retorno ao hub limpa pausa")
	current_scene._on_start_pressed()
	await scene_changed
	await process_frame
	scene = current_scene
	player = scene.get_node("player")
	check(not paused and player != null, "hub inicia nova partida")
	player._die()
	check(player._result_ui.visible and paused, "derrota abre resultado")
	player._result_ui._on_retry_pressed()
	await scene_changed
	await process_frame
	scene = current_scene
	player = scene.get_node("player")
	check(not paused and not player.is_dead(), "retry da derrota reinicia partida")
