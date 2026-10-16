extends SceneTree

## Regressão funcional da UI com valores reais; nunca escreve no save pessoal.
var checks: int = 0
var failures: int = 0
var pm: Node
var save: Node
var player: Node
var data: Script

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
	print("PASS " if condition else "FAIL ", message)

func settle_layout() -> void:
	for i in range(5):
		await process_frame

func start_run() -> void:
	pm.change_scene("res://main.tscn")
	await scene_changed
	await settle_layout()
	player = current_scene.get_node("player")
	current_scene.get_node("EnemySpawner").set_process(false)
	current_scene.get_node("EnemySpawner/SpawnTimer").stop()
	player.set_physics_process(false)
	player.health = 100

func run() -> void:
	var watchdog := create_timer(45)
	watchdog.timeout.connect(func() -> void: push_error("Timeout na suíte de UI"); quit(2))
	pm = root.get_node("PauseManager")
	save = root.get_node("SaveManager")
	data = load("res://ui_data.gd")
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save.save_path = "res://tests/.tmp/ui-save.json"
	save.gold = 500
	save.maps_cleared = []
	save.reward_receipts = {}
	save.farm_upgrades = {}
	save.unlocked_characters = ["fazendeiro"]
	save.selected_character = "fazendeiro"
	save.selected_map = "horta"
	await test_hub()
	await test_weapon_numbers()
	await test_passives()
	await test_card_flow()
	await test_layouts()
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await settle_layout()
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await create_timer(0.15).timeout
	print("UI RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)

func test_hub() -> void:
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await settle_layout()
	var hub: Node = current_scene
	for dimensions in [Vector2i(360, 640), Vector2i(720, 1280), Vector2i(1080, 2400), Vector2i(1280, 720)]:
		root.size = dimensions
		await settle_layout()
		check(hub.gold_label.size.x > 120 and hub.gold_label.get_line_count() <= 2, "saldo com ícone permanece legível %s" % dimensions)
	root.size = Vector2i(720, 1280)
	await settle_layout()
	hub._on_select_map("celeiro")
	check(save.selected_map == "horta" and hub._notice.contains("Bloqueado"), "mapa bloqueado não pode ser selecionado")
	hub._select_tab("Personagens")
	var original_gold: int = save.gold
	var valid_path: String = save.save_path
	save.save_path = "res://tests/.tmp/missing-ui/save.json"
	hub._on_unlock_character("vovo")
	check(save.gold == original_gold and not save.is_character_unlocked("vovo"), "compra sem save não cobra nem desbloqueia")
	save.save_path = valid_path
	hub._on_unlock_character("vovo")
	hub._on_unlock_character("vovo")
	check(save.gold == original_gold - 50 and save.selected_character == "vovo", "desbloqueio confirmado e duplicata ignorada")
	save.load_data()
	check(save.is_character_unlocked("vovo") and save.gold == original_gold - 50, "personagem e débito persistidos juntos")
	hub._select_tab("Fazenda")
	save.save_path = "res://tests/.tmp/missing-ui/save.json"
	hub._on_buy_upgrade("vida_extra")
	check(save.get_farm_upgrade_level("vida_extra") == 0 and save.gold == original_gold - 50, "upgrade reverte na falha de gravação")
	save.save_path = valid_path
	hub._on_buy_upgrade("vida_extra")
	check(save.get_farm_upgrade_level("vida_extra") == 1 and save.gold == original_gold - 80, "upgrade usa preço atual e salva")
	save.farm_upgrades = {}
	save.selected_character = "fazendeiro"

func test_weapon_numbers() -> void:
	for id in root.get_node("WeaponDB").WEAPONS:
		await start_run()
		player.damage_bonus = 3.5
		player.cooldown_multiplier = 0.57
		if id != "foice":
			player.add_weapon(id)
		for tier in range(1, 4):
			if tier > 1:
				player.add_weapon(id)
			var weapon: Node
			for entry in player.weapons:
				if entry.id == id:
					weapon = entry.node
			weapon.configure(id, tier)
			var stats: Dictionary = root.get_node("WeaponDB").WEAPONS[id].levels[tier - 1]
			var display: Dictionary = data.weapon_values(player, id, tier)
			var actual_damage: float = weapon._companion.damage if id == "bezerro" else (weapon._stats.damage if id == "cerca" else weapon.damage)
			check(display["Dano por acerto"] == data.number(actual_damage + player.damage_bonus), "%s nível %d: dano exibido confere com a entidade" % [id, tier])
			var actual_interval: float
			var label: String
			match id:
				"motosserra":
					actual_interval = weapon.tick_timer.wait_time
					label = "Intervalo entre danos"
				"bezerro":
					actual_interval = weapon._companion.attack_timer.wait_time
					label = "Intervalo entre ataques"
				"cerca":
					actual_interval = weapon.spawn_timer.wait_time
					label = "Intervalo de colocação"
				_:
					actual_interval = weapon.attack_timer.wait_time
					label = "Intervalo entre ataques"
			check(display[label] == data.number(actual_interval) + " s", "%s nível %d: intervalo confere com o timer" % [id, tier])
			if stats.has("splash_damage"):
				check(display["Dano da explosão"] == data.number(stats.splash_damage), "explosão não recebe bônus flat que o código não aplica")
			if tier == 3:
				check(player.is_weapon_unavailable(id), "%s máximo não entra nas cartas" % id)
	await start_run()
	player.cooldown_multiplier = 0.1
	check(data.weapon_values(player, "forquilha", 1)["Intervalo entre ataques"] == "0,15 s", "preview respeita piso de intervalo")

func test_passives() -> void:
	for id in root.get_node("PassiveDB").PASSIVES:
		await start_run()
		for tier in range(1, 4):
			var preview: Dictionary = data.preview(player, {"id": "passive_" + id, "passive_id": id})
			check(preview.kind.contains("Nível 1" if tier == 1 else "%d → %d" % [tier - 1, tier]), "%s nível %d: progressão correta" % [id, tier])
			player.add_passive(id)
			var detail: String = "\n".join(preview.lines)
			var actual: String
			match id:
				"espantalho": actual = data.number(player.defense_percent * 100) + "%"
				"sementes": actual = data.number(player.max_health)
				"termica": actual = "×" + data.number(clampf(player.cooldown_multiplier, 0.25, 1.0))
				"galochas": actual = data.number(player.speed) + " px/s"
				"ima": actual = data.number(player.magnet_radius) + " px"
			check(detail.contains("→ " + actual), "%s nível %d: previsão confere após aplicar" % [id, tier])
		check(player.is_passive_unavailable(id), "%s máximo indisponível" % id)
	check(player.auto_collect_orbs, "í­mã nível 3 anuncia e ativa coleta automática")

func test_card_flow() -> void:
	await start_run()
	player.grant_free_level_up()
	player.grant_free_level_up()
	await settle_layout()
	var cards: Node = current_scene.get_node("LevelUpUI")
	var generation: int = cards._card_generation
	var stale: Button = cards._choices[0]
	stale.pressed.emit()
	check(player.pending_level_ups == 2 and paused and not cards._confirm.disabled, "selecionar carta não gasta melhoria")
	cards._confirm.pressed.emit()
	check(player.pending_level_ups == 1 and cards._confirm.disabled, "confirmação consome uma escolha e limpa seleção")
	stale.pressed.emit()
	cards._confirm.pressed.emit()
	check(player.pending_level_ups == 1 and cards._selected.is_empty(), "callback antigo e confirmação repetida não gastam próxima carta")
	check(cards._card_generation != generation, "geração da escolha foi renovada")
	cards._choices[0].pressed.emit()
	cards._confirm.pressed.emit()
	check(not paused, "última confirmação retoma o combate")
	var menu: Node = current_scene.get_node("PauseMenu")
	menu.open()
	menu.retry_button.pressed.emit()
	check(paused and menu._confirming == "retry", "reiniciar pede confirmação dentro da pausa")
	menu._populate_inventory()
	check(paused and menu._confirming == "", "cancelar saída mantém pausa")
	menu._on_resume_pressed()

func test_layouts() -> void:
	for size in [Vector2i(360, 640), Vector2i(720, 1280), Vector2i(1080, 2400), Vector2i(1280, 720)]:
		root.size = size
		await settle_layout()
		var menu: Node = current_scene.get_node("PauseMenu")
		menu.open()
		await settle_layout()
		var rect: Rect2 = root.get_visible_rect()
		if not rect.encloses(menu.hub_button.get_global_rect()):
			print("LAYOUT viewport=", rect, " panel=", menu._view.root.get_node("Window").get_global_rect(), " hub=", menu.hub_button.get_global_rect())
		check(rect.encloses(menu.resume_button.get_global_rect()) and rect.encloses(menu.hub_button.get_global_rect()), "ações de pausa dentro da tela %s" % size)
		menu._on_resume_pressed()
		player.grant_free_level_up()
		await settle_layout()
		var cards: Node = current_scene.get_node("LevelUpUI")
		check(rect.encloses(cards._confirm.get_global_rect()) and cards._view.scroll.size.y > 100, "confirmação fixa e conteúdo rolável %s" % size)
		cards._on_upgrade_chosen({"id": "damage"}, cards._card_generation)
	root.size = Vector2i(720, 1280)
