extends SceneTree

var checks := 0
var failures := 0
var pm: Node
var save: Node
var owner: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(45.0).timeout.connect(func() -> void:
		push_error("Vovó animation suite timed out")
		quit(1))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print("PASS " if ok else "FAIL ", message)

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

func new_run(id: String = "vovo") -> Node:
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
	save.save_path = "res://tests/.tmp/vovo-animation-save.json"
	save.selected_map = "horta"
	save.farm_upgrades = {}
	save.maps_cleared = []
	save.reward_receipts = {}
	save.unlocked_characters = ["fazendeiro", "vovo", "netinho"]
	var catalog := GameArt.actor("vovo")
	var count := 0
	for state in ["idle", "walk", "run", "idle_plant", "death"]:
		var data: Dictionary = catalog[state]
		count += data.frames.size()
		check(data.frames.size() == data.durations_ms.size(), state + " tem tempos por quadro")
		check(data.loop == (state in ["idle", "walk", "run"]), state + " tem loop correto")
	check(count == 32, "catálogo contém 32 quadros da Vovó")
	check(GameArt.ui("char_vovo") == GameArt.texture(catalog.idle.frames[0]), "seleção usa a arte nova")
	var figure := Sprite2D.new()
	root.add_child(figure)
	var clock := SpriteAnimator.new()
	root.add_child(clock)
	clock.set_process(false)
	clock.configure("vovo", figure)
	clock.once("death")
	var completed_count := [0]
	clock.completed.connect(func(_state: String) -> void: completed_count[0] += 1)
	clock._process(0.839)
	check(not clock.finished, "morte permanece ativa antes de 840 ms")
	clock._process(0.002)
	check(clock.finished and clock.frame_index == 5 and completed_count[0] == 1, "morte finaliza uma vez na pose com alma")
	clock._process(3.0)
	check(clock.frame_index == 5 and completed_count[0] == 1, "morte segura o último quadro")
	clock.queue_free()
	figure.queue_free()
	var player := await new_run()
	var speed: float = player.speed
	var radius: float = player.get_node("CollisionShape2D").shape.radius
	check(player.art_animator.entity_id == "vovo", "partida configura a família da Vovó")
	player.joystick._output = Vector2(0.5, 0)
	var start: Vector2 = player.position
	player.set_physics_process(true)
	await wait(0.15)
	check(player.position.x > start.x and player.art_animator.state == "walk", "joystick parcial move com caminhada")
	check(is_equal_approx(player.velocity.length(), speed * 0.5), "movimento analógico preservado")
	player.joystick._output = Vector2.RIGHT
	await wait(0.15)
	check(player.art_animator.state == "run", "joystick cheio seleciona corrida")
	check(is_equal_approx(player.velocity.length(), speed), "corrida não concede velocidade extra")
	player.set_physics_process(false)
	player.velocity = Vector2.RIGHT * speed * 0.72
	player._update_visual_animation(Vector2.RIGHT * 0.72, 0.01)
	check(player.art_animator.state == "run", "histerese mantém corrida na fronteira")
	player.velocity = Vector2.RIGHT * speed * 0.6
	player._update_visual_animation(Vector2.RIGHT * 0.6, 0.01)
	check(player.art_animator.state == "walk", "redução do joystick volta a andar")
	player.velocity = Vector2.ZERO
	player.joystick.reset_input()
	player._update_visual_animation(Vector2.ZERO, 0.01)
	check(player.art_animator.state == "idle", "soltar controle entra em descanso")
	player._update_visual_animation(Vector2.ZERO, 3.6)
	check(player.art_animator.state == "idle_plant", "inatividade inicia plantio visual")
	var frame: int = player.art_animator.frame_index
	var elapsed: float = player.art_animator.elapsed
	pm.acquire(owner, &"pause")
	await wait(0.25)
	check(player.art_animator.frame_index == frame and is_equal_approx(player.art_animator.elapsed, elapsed), "pausa congela o plantio")
	pm.release(owner)
	await wait(0.25)
	check(player.art_animator.frame_index > frame, "plantio retoma após pausa")
	player.velocity = Vector2.RIGHT * speed
	player._update_visual_animation(Vector2.RIGHT, 0.01)
	check(player.art_animator.state == "run" and not player._idle_gesture_active, "movimento interrompe plantio")
	player.velocity = Vector2.ZERO
	player._update_visual_animation(Vector2.ZERO, 3.6)
	var hp: float = player.health
	player.take_damage(1.0)
	check(player.art_animator.state == "idle" and player.health < hp, "dano cancela plantio sem imunidade")
	player._update_visual_animation(Vector2.ZERO, 3.6)
	await wait(1.9)
	player._update_visual_animation(Vector2.ZERO, 0.01)
	check(player.art_animator.state == "idle" and not player._idle_gesture_active, "plantio retorna ao descanso")
	check(player.speed == speed and player.get_node("CollisionShape2D").shape.radius == radius, "arte mantém atributos e colisão")
	player._die()
	check(paused and not player._result_ui._view.root.visible, "morte bloqueia combate antes do resultado")
	await wait(0.9)
	check(player.art_animator.finished and player._result_ui._view.root.visible, "resultado aparece após a morte")
	check(player.art_animator.target.texture == GameArt.texture(catalog.death.frames[-1]), "alma fica na pose final do mundo")
	for i in range(3):
		player = await new_run()
		check(not paused and player.art_animator.state == "idle" and not player._idle_gesture_active and player._idle_gesture_index == 0, "nova partida %d limpa estados" % i)
	player = await new_run("netinho")
	player._update_visual_animation(Vector2.ZERO, 8.0)
	check(player.art_animator.state == "idle" and not player._idle_gesture_active, "Netinho não recebe gesto da Vovó")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	owner.queue_free()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await wait(0.15)
	print("VOVO RESULT checks=%d failures=%d" % [checks, failures])
	quit(0 if failures == 0 else 1)
