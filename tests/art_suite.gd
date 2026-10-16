extends SceneTree

var checks: int = 0
var failures: int = 0
var pm: Node
var save: Node
var pause_owner: Node

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print("PASS " if ok else "FAIL ", message)

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

func new_run() -> Node:
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var spawner: Node = current_scene.get_node("EnemySpawner")
	spawner.set_process(false)
	spawner.spawn_timer.stop()
	var player: Node = current_scene.get_node("player")
	player.health = 999999
	player.set_physics_process(false)
	for weapon in player.weapons:
		weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
	return player

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save = root.get_node("SaveManager")
	pm = root.get_node("PauseManager")
	pause_owner = Node.new()
	root.add_child(pause_owner)
	save.save_path = "res://tests/.tmp/art-save.json"
	save.selected_map = "horta"
	save.maps_cleared = []
	save.farm_upgrades = {}
	save.reward_receipts = {}
	save.unlocked_characters = ["fazendeiro", "vovo", "netinho"]
	for id in ["fazendeiro", "vovo", "netinho"]:
		save.selected_character = id
		var player: Node = await new_run()
		var animator: SpriteAnimator = player.art_animator
		check(animator.entity_id == id, id + " usa a própria família visual")
		animator.play("walk", true)
		await wait(0.17)
		check(animator.frame_index > 0, id + " caminhada avança")
		var old_frame := animator.frame_index
		var old_elapsed := animator.elapsed
		pm.acquire(pause_owner, &"pause")
		await wait(0.22)
		check(animator.frame_index == old_frame and is_equal_approx(animator.elapsed, old_elapsed), id + " animação congela na pausa real")
		pm.release(pause_owner)
		await wait(0.14)
		check(animator.frame_index != old_frame or not is_equal_approx(animator.elapsed, old_elapsed), id + " retoma a animação")
		player._die()
		check(paused and not player._result_ui._view.root.visible, id + " morte aparece no mundo antes do painel final")
		await wait(0.9)
		check(player.art_animator.finished and player._result_ui._view.root.visible, id + " morte revela resultado sem reativar gameplay")
		check(player._result_ui._death_preview.state == "death" and player._result_ui._death_preview.finished, id + " morte termina no resultado com gameplay pausado")
		check(player._result_ui._death_preview.target.texture == GameArt.texture(GameArt.actor(id).death.frames[-1]), id + " morte preserva o último quadro")

	save.selected_character = "fazendeiro"
	var player: Node = await new_run()
	var pool: Node = root.get_node("Pool")
	var scene := load("res://enemy.tscn") as PackedScene
	for id in root.get_node("EnemyDB").ENEMIES:
		var enemy: Node = pool.acquire(scene)
		current_scene.add_child(enemy)
		enemy.position = Vector2(600, 600)
		enemy.configure(id, 1.0, player)
		enemy.set_physics_process(false)
		check(enemy.art_animator.entity_id == id and enemy.sprite.texture != null, id + " tem sprite próprio")
		check(enemy.sprite.scale == Vector2.ONE and enemy.sprite.modulate == Color.WHITE, id + " reset de escala e cor")
		var radius: float = enemy.body_shape.shape.radius
		enemy.art_animator.flash()
		enemy.sprite.flip_h = true
		enemy._despawn()
		await process_frame
		await process_frame
		var reused: Node = pool.acquire(scene)
		current_scene.add_child(reused)
		reused.configure(id, 1.0, player)
		reused.set_physics_process(false)
		check(reused == enemy and reused.art_animator.frame_index == 0 and not reused.sprite.flip_h and reused.art_animator._flash == 0, id + " pool limpa animação e orientação")
		check(is_equal_approx(reused.body_shape.shape.radius, radius), id + " arte não altera colisão")
		var count := get_nodes_in_group("xp_orbs").size()
		reused.die()
		reused.die()
		check(not reused.is_in_group("enemies"), id + " sai dos alvos antes de animar morte")
		await process_frame
		await process_frame
		check(get_nodes_in_group("xp_orbs").size() == count + 1, id + " morte visual não duplica XP")

	for level in [1, 2, 3]:
		var companion: Node = load("res://companion.tscn").instantiate()
		current_scene.add_child(companion)
		companion.configure(root.get_node("WeaponDB").WEAPONS.bezerro.levels[level-1], player, level)
		check(companion.art_animator.entity_id == "bezerro_%d" % level, "companheiro nível %d tem a família correta" % level)
		companion.queue_free()

	# Verify the decoded, imported frames, rather than only filenames/manifests.
	var borders_ok := true
	var sizes_ok := true
	var frames_checked := 0
	for entity in GameArt.DATA.actors:
		for state in GameArt.actor(entity):
			var expected_size := Vector2i.ZERO
			for path in GameArt.actor(entity)[state].frames:
				var image := GameArt.texture(path).get_image()
				if expected_size == Vector2i.ZERO:
					expected_size = image.get_size()
				sizes_ok = sizes_ok and image.get_size() == expected_size
				for x in range(image.get_width()):
					borders_ok = borders_ok and image.get_pixel(x, 0).a == 0 and image.get_pixel(x, image.get_height()-1).a == 0
				for y in range(image.get_height()):
					borders_ok = borders_ok and image.get_pixel(0, y).a == 0 and image.get_pixel(image.get_width()-1, y).a == 0
				frames_checked += 1
	check(borders_ok, "%d quadros importados com margens transparentes" % frames_checked)
	check(sizes_ok, "canvas estável em todas as sequências")
	await new_run()
	check(not paused, "cenário de efeitos começa sem modal de vitória residual")
	await wait(1)
	for i in range(55):
		VisualFX.spawn(current_scene, "impact", Vector2.ZERO)
	check(get_nodes_in_group("visual_fx").size() == 40, "limite de quarenta efeitos inclui spawns no mesmo frame")
	pm.acquire(pause_owner, &"pause")
	await wait(0.4)
	check(get_nodes_in_group("visual_fx").size() == 40, "efeitos congelam junto do gameplay")
	pm.release(pause_owner)
	await wait(0.6)
	check(get_nodes_in_group("visual_fx").is_empty(), "efeitos terminam e liberam memória ao retomar")
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await process_frame
	check(not paused, "retorno ao Hub limpa estados visuais e pausa")
	root.get_node("AudioManager").shutdown()
	await wait(0.15)
	print("ART RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
