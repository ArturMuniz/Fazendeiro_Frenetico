extends SceneTree

var checks := 0
var failures := 0
var pm: Node
var save: Node
var owner: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(45.0).timeout.connect(func() -> void:
		push_error("Farmer animation suite timed out")
		quit(1))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print("PASS " if ok else "FAIL ", message)

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

func new_run(id: String = "fazendeiro") -> Node:
	save.selected_character = id
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
	return player

func run() -> void:
	pm = root.get_node("PauseManager")
	save = root.get_node("SaveManager")
	owner = Node.new()
	root.add_child(owner)
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save.save_path = "res://tests/.tmp/farmer-animation-save.json"
	save.selected_map = "horta"
	save.farm_upgrades = {}
	save.maps_cleared = []
	save.reward_receipts = {}
	var catalog := GameArt.actor("fazendeiro")
	var count := 0
	for state in ["idle", "walk", "run", "idle_hat", "idle_swat", "death"]:
		var data: Dictionary = catalog[state]
		count += data.frames.size()
		check(data.frames.size() == data.durations_ms.size(), state + " tem duração para cada quadro")
		check(data.loop == (state in ["idle", "walk", "run"]), state + " usa o loop correto")
	check(count == 38, "trinta e oito quadros fiéis às referências no catálogo integrado")

	# Deterministic animation-clock checks, independent of machine FPS.
	var figure := Sprite2D.new()
	root.add_child(figure)
	var clock := SpriteAnimator.new()
	root.add_child(clock)
	clock.set_process(false)
	clock.configure("fazendeiro", figure)
	clock._process(0.219)
	check(clock.frame_index == 0, "primeiro quadro de repouso segura 220 ms")
	clock._process(0.002)
	check(clock.frame_index == 1, "duração por quadro respeitada")
	clock.play("walk", true)
	clock.playback_speed = 2.0
	clock._process(float(catalog.walk.durations_ms[0]) / 2000.0 + 0.001)
	check(clock.frame_index == 1, "cadência acompanha playback_speed")
	clock.configure("fazendeiro", figure)
	check(clock.playback_speed == 1.0 and clock.frame_index == 0, "configure limpa cadência e quadro")
	var completions := [0]
	clock.completed.connect(func(_state: String) -> void: completions[0] += 1)
	clock.once("death")
	clock._process(0.839)
	check(not clock.finished, "morte preserva duração até o último instante")
	clock._process(0.002)
	check(clock.finished and clock.frame_index == catalog.death.frames.size() - 1 and completions[0] == 1, "morte termina uma única vez em 840 ms")
	clock._process(2.0)
	check(clock.frame_index == catalog.death.frames.size() - 1 and completions[0] == 1, "morte segura último quadro sem repetir sinal")
	clock.configure("bezerro_1", figure)
	clock._process(1.0 / float(GameArt.actor("bezerro_1").idle.fps) + 0.001)
	check(clock.frame_index == 1, "animações antigas continuam usando FPS")
	clock.queue_free()
	figure.queue_free()

	var player := await new_run()
	var initial_speed: float = player.speed
	var initial_radius: float = player.get_node("CollisionShape2D").shape.radius
	player.joystick._output = Vector2(0.5, 0)
	var start: Vector2 = player.position
	player.set_physics_process(true)
	await wait(0.15)
	check(player.position.x > start.x and player.art_animator.state == "walk", "meio joystick move e anima caminhada real")
	check(is_equal_approx(player.velocity.length(), initial_speed * 0.5), "caminhada não altera velocidade analógica")
	player.joystick._output = Vector2.RIGHT
	await wait(0.12)
	check(player.art_animator.state == "run", "joystick cheio seleciona corrida")
	check(is_equal_approx(player.velocity.length(), initial_speed), "corrida mantém velocidade máxima existente")
	player.set_physics_process(false)
	player.velocity = Vector2.RIGHT * initial_speed * 0.72
	player._update_visual_animation(Vector2.RIGHT * 0.72, 0.01)
	check(player.art_animator.state == "run", "histerese evita oscilar na fronteira da corrida")
	player.velocity = Vector2.RIGHT * initial_speed * 0.6
	player._update_visual_animation(Vector2.RIGHT * 0.6, 0.01)
	check(player.art_animator.state == "walk", "reduzir joystick volta à caminhada")
	player.velocity = Vector2.ZERO
	player.joystick.reset_input()
	player._update_visual_animation(Vector2.ZERO, 0.01)
	check(player.art_animator.state == "idle", "soltar joystick retorna ao repouso")
	player._update_visual_animation(Vector2.ZERO, 3.6)
	check(player.art_animator.state == "idle_hat", "repouso prolongado inicia gesto do chapéu")
	var frame: int = player.art_animator.frame_index
	var elapsed: float = player.art_animator.elapsed
	pm.acquire(owner, &"pause")
	await wait(0.2)
	check(player.art_animator.frame_index == frame and is_equal_approx(player.art_animator.elapsed, elapsed), "gesto congela na pausa")
	pm.release(owner)
	await wait(0.17)
	check(player.art_animator.frame_index != frame, "gesto retoma depois da pausa")
	player.velocity = Vector2.RIGHT * initial_speed
	player._update_visual_animation(Vector2.RIGHT, 0.01)
	check(player.art_animator.state == "run" and not player.art_animator._one_shot, "movimento cancela gesto imediatamente")
	player.velocity = Vector2.ZERO
	player._update_visual_animation(Vector2.ZERO, 3.6)
	check(player.art_animator.state == "idle_swat", "gestos alternam para espantar a mosquinha")
	var old_health: float = player.health
	player.take_damage(1.0)
	check(player.art_animator.state == "idle" and not player._idle_gesture_active and player.health < old_health, "dano interrompe gesto sem imunidade")
	player._update_visual_animation(Vector2.ZERO, 3.6)
	await wait(1.25)
	player._update_visual_animation(Vector2.ZERO, 0.01)
	check(player.art_animator.state == "idle" and not player._idle_gesture_active, "gesto concluído retorna ao repouso")
	check(is_equal_approx(player.speed, initial_speed) and is_equal_approx(player.get_node("CollisionShape2D").shape.radius, initial_radius), "arte preserva velocidade e colisão")
	player._die()
	check(paused and player.art_animator.state == "death" and not player._result_ui._view.root.visible, "morte bloqueia gameplay e antecede resultados")
	await wait(0.9)
	check(player.art_animator.finished and player._result_ui._view.root.visible, "morte revela resultados no fim")
	check(player.art_animator.target.texture == GameArt.texture(catalog.death.frames[-1]), "última pose aparece no mundo")
	check(paused and not player.is_physics_processing(), "apresentação não reativa combate")
	for run_index in range(3):
		player = await new_run()
		check(not paused and player.art_animator.state == "idle" and not player._idle_gesture_active and player._idle_gesture_index == 0, "nova partida %d limpa os estados" % run_index)
	for id in ["netinho"]:
		player = await new_run(id)
		player.velocity = Vector2.RIGHT * player.speed
		player._update_visual_animation(Vector2.RIGHT, 0.1)
		check(player.art_animator.state == "run" and player.art_animator.entity_id == id, id + " usa a própria corrida ao mover com joystick cheio")
		player.velocity = Vector2.ZERO
		player._update_visual_animation(Vector2.ZERO, 6.0)
		check(player.art_animator.state == "idle" and not player._idle_gesture_active, id + " não recebe gestos inexistentes")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	owner.queue_free()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await wait(0.15)
	print("FARMER RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
