extends SceneTree

class FakeProvider extends Node:
	signal available
	signal shown(token: int)
	signal earned(token: int)
	signal closed(token: int)
	signal failed(token: int, message: String)
	var token: int = 0
	var requests: int = 0
	func start() -> void: available.emit()
	func show_rewarded(id: int) -> void:
		token = id
		requests += 1
		shown.emit(id)
	func cancel(_id: int) -> void: pass

var checks := 0
var failures := 0
var save: Node
var ads: Node
var fake: FakeProvider
var pm: Node
var actor: Node
var save_file := "res://tests/.tmp/monetization-save.json"

func _initialize() -> void:
	call_deferred("run")
	create_timer(55.0).timeout.connect(func() -> void:
		push_error("Monetization suite timed out")
		quit(1))

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", message)

func wait(seconds: float = 0.1) -> void:
	await create_timer(seconds).timeout

func new_run() -> Node:
	pm.change_scene("res://main.tscn")
	await scene_changed
	await process_frame
	var p: Node = current_scene.get_node("player")
	p.set_physics_process(false)
	current_scene.spawner.set_process(false)
	current_scene.spawner.spawn_timer.stop()
	for weapon in p.weapons: weapon.node.process_mode = Node.PROCESS_MODE_DISABLED
	return p

func death(p: Node) -> Node:
	p.health = 0
	p._die()
	await wait(0.95)
	return p._result_ui

func complete_ad(ui: Node, placement: String) -> void:
	ui._request_reward(placement)
	await process_frame
	fake.earned.emit(fake.token)
	fake.closed.emit(fake.token)
	await wait(0.25)

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://tests/.tmp")
	save = root.get_node("SaveManager")
	ads = root.get_node("RewardedAds")
	pm = root.get_node("PauseManager")
	save.save_path = save_file
	save.gold = 1000
	save.reward_receipts = {}
	save.maps_cleared = []
	save.farm_upgrades = {}
	save.owned_skins = {}
	save.equipped_skins = {}
	save.unlocked_characters = ["fazendeiro", "vovo", "netinho"]
	save.selected_character = "fazendeiro"
	save.selected_map = "horta"
	check(load("res://rewarded_admob_provider.gd") != null, "adaptador real AdMob compila com o SDK instalado")
	fake = FakeProvider.new()
	ads.set_provider(fake)
	await process_frame
	check(ads.is_available(), "provedor de teste sinaliza disponibilidade")
	await test_skins()
	await test_checkpoint()
	await test_early_death_and_save_retry()
	await test_owner_exit_and_timeout()
	await test_failure_focus_and_callback_order()
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await process_frame
	root.get_node("Pool").clear_idle()
	root.get_node("AudioManager").shutdown()
	await wait()
	print("MONETIZATION RESULT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)

func test_skins() -> void:
	check(save.get_equipped_skin("fazendeiro") == "original", "save anterior tem roupa original por padrão")
	check(not save.equip_skin("fazendeiro", "vinho"), "roupa não adquirida não pode ser equipada")
	check(save.buy_skin("fazendeiro", "colheita") and save.gold == 750, "compra desconta apenas ouro do jogo")
	check(save.buy_skin("fazendeiro", "colheita") and save.gold == 750, "compra repetida não cobra duas vezes")
	check(save.equip_skin("fazendeiro", "colheita"), "roupa comprada pode ser equipada")
	check(not save.owns_skin("vovo", "colheita"), "roupa é vinculada ao personagem correto")
	save.load_data()
	check(save.get_equipped_skin("fazendeiro") == "colheita" and save.gold == 750, "compra e seleção sobrevivem ao reload")
	save.save_path = "res://tests/.tmp/missing-monetization-directory/save.json"
	check(not save.buy_skin("vovo", "vinho") and save.gold == 750 and not save.owns_skin("vovo", "vinho"), "falha de save reverte compra e saldo")
	check(not save.equip_skin("fazendeiro", "original") and save.get_equipped_skin("fazendeiro") == "colheita", "falha de save reverte seleção")
	save.save_path = save_file
	actor = await new_run()
	check(actor.sprite.material is ShaderMaterial and actor.speed == 120.0 and actor.max_health == 100.0, "roupa usa material próprio sem bônus de atributos")
	check(save.equip_skin("fazendeiro", "original"), "retorno à roupa original salvo")
	SkinCatalog.apply(actor.sprite, "fazendeiro")
	check(actor.sprite.material == null, "roupa original restaura as cores nativas")

func test_checkpoint() -> void:
	actor = await new_run()
	var checkpoint: Node = current_scene.checkpoint
	var spawner: Node = current_scene.spawner
	check(is_equal_approx(checkpoint.midpoint, 169.0), "metade inclui fases e intervalos: 169 segundos")
	actor.level = 7
	actor.xp = 3.0
	actor.max_health = 160.0
	actor.health = 97.0
	actor.damage_bonus = 12.0
	actor.speed = 138.0
	actor.add_weapon("milho")
	actor.add_weapon("milho")
	actor.add_passive("sementes")
	actor._enable_auto_collect()
	actor._auto_collect_timer.start(5.0)
	actor.global_position = Vector2(800, -300)
	actor.survival_time = checkpoint.midpoint
	spawner._phase_index = 1
	spawner._phase_elapsed = 65.0
	var enemy: Node = root.get_node("Pool").acquire(load("res://enemy.tscn"))
	current_scene.add_child(enemy)
	enemy.configure("lesma", 1.25, actor)
	enemy.position = Vector2(1200, -300)
	enemy.health = 17.0
	enemy.set_physics_process(false)
	checkpoint._process(0.0)
	check(checkpoint.reached_midpoint and checkpoint.snapshot.weapons.size() == 2, "checkpoint registra build no meio da campanha")
	var expected: Dictionary = checkpoint.snapshot.duplicate(true)
	actor.level = 19
	actor.damage_bonus = 88.0
	actor.survival_time = 290.0
	actor.add_weapon("forquilha")
	var ui: Node = await death(actor)
	check(paused and ui.revive_button.visible, "derrota oferece retorno sem liberar gameplay")
	ui._request_reward("revive")
	await process_frame
	check(paused and ads.state == ads.State.SHOWING and ui.revive_button.disabled, "anúncio segura pausa e bloqueia cliques repetidos")
	var requests := fake.requests
	ui._request_reward("revive")
	check(fake.requests == requests, "clique duplicado não abre segundo anúncio")
	fake.closed.emit(fake.token)
	await wait()
	check(actor.is_dead() and actor.can_revive(), "fechar sem recompensa não revive nem consome tentativa")
	var balance: int = save.gold
	await complete_ad(ui, "revive")
	actor.set_physics_process(false)
	check(not actor.is_dead() and not paused, "recompensa confirmada retorna ao jogo")
	check(actor.level == 7 and actor.xp == 3.0 and actor.damage_bonus == 12.0, "checkpoint restaura nível, XP e atributos")
	check(actor.weapons.size() == 2 and actor.weapons[1].level == 2 and actor.passives.size() == 1, "checkpoint restaura armas, níveis e passivos")
	check(actor.max_health == expected.player.max_health and actor.health == expected.player.health, "checkpoint não reaplica meta nem passivos em duplicidade")
	check(actor.auto_collect_orbs and actor._auto_collect_timer.time_left > 4.5 and is_equal_approx(actor._auto_collect_timer.wait_time,15.0), "checkpoint preserva tempo restante e intervalo da coleta automática")
	check(actor.global_position == Vector2(800, -300) and abs(actor.survival_time-169)<0.5, "checkpoint restaura posição e relógio")
	check(spawner._phase_index == 1 and is_equal_approx(spawner._phase_elapsed,65.0), "checkpoint restaura fase e progresso interno")
	check(get_nodes_in_group("enemies").size() == 1 and is_equal_approx(get_nodes_in_group("enemies")[0].health,17.0), "checkpoint restaura inimigos e vida sem duplicá-los")
	check(save.gold == balance and not actor.can_revive(), "retorno não repete pagamento e tem limite de uma vez")
	var health: float = actor.health
	actor.take_damage(999)
	check(actor.health == health, "retorno concede janela breve contra morte instantânea")
	fake.earned.emit(fake.token)
	fake.closed.emit(fake.token)
	await wait()
	check(save.gold == balance, "callback antigo não concede prêmio novamente")
	ui = await death(actor)
	check(not ui.revive_button.visible, "segunda morte não oferece outro retorno")
	var receipt: Dictionary = save.reward_receipts[actor._run_id]
	var expected_bonus: int = int(receipt.base) + int(receipt.get("boss",0))
	balance = save.gold
	await complete_ad(ui, "double_gold")
	check(save.gold == balance+expected_bonus, "anúncio dobra total da run sem repetir a parcela já paga")
	check(not ui.double_button.visible and not ui.revive_button.visible, "moedas dobradas encerram ofertas consumidas")
	save.double_run_reward(actor._run_id)
	check(save.gold == balance+expected_bonus, "recibo bloqueia duplicação de moedas")

func test_early_death_and_save_retry() -> void:
	actor = await new_run()
	actor.survival_time = 20.0
	actor.level = 4
	actor.add_weapon("mamona")
	var ui: Node = await death(actor)
	await complete_ad(ui, "revive")
	actor.set_physics_process(false)
	check(actor.level==4 and actor.weapons.size()==2 and abs(actor.survival_time-20)<0.5, "morte antes da metade volta ao próprio momento e inventário")
	check(actor.health==actor.max_health, "retorno antes da metade restaura vida")
	ui = await death(actor)
	ui._request_reward("double_gold")
	await process_frame
	var balance: int = save.gold
	var requests := fake.requests
	save.save_path = "res://tests/.tmp/missing-monetization-directory/save.json"
	fake.earned.emit(fake.token)
	fake.closed.emit(fake.token)
	await wait()
	check(save.gold==balance and ui._reward_save_pending, "falha ao salvar anúncio não altera saldo e preserva autorização")
	check(ui.hub_button.disabled and ui.retry_button.disabled, "recompensa pendente oferece recuperação sem perder pagamento")
	save.save_path=save_file
	ui._request_reward("double_gold")
	await wait()
	check(save.gold>balance and not ui._reward_save_pending and fake.requests==requests, "retry salva recompensa sem exigir outro anúncio")
	check(save.settle_run_progress(actor._run_id,999).paid_now==0, "run com moedas dobradas não pode ser reaberta para pagamento")
	save.settle_run_progress("delta-test",50)
	check(save.settle_run_progress("delta-test",40).paid_now==0 and save.settle_run_progress("delta-test",80).paid_now==30, "liquidação retomada paga apenas o delta acima do valor já salvo")

func test_owner_exit_and_timeout() -> void:
	actor = await new_run()
	var ui: Node = await death(actor)
	ui._request_reward("revive")
	await process_frame
	var token := fake.token
	var balance: int = save.gold
	pm.change_scene("res://hub.tscn")
	await scene_changed
	await wait()
	fake.earned.emit(token)
	fake.closed.emit(token)
	await wait()
	check(not paused and ads.is_available() and save.gold==balance, "troca de cena cancela solicitação e ignora callback tardio")
	actor = await new_run()
	ui = await death(actor)
	ui._request_reward("revive")
	await process_frame
	ads._watchdog.start(0.02)
	await wait()
	check(actor.is_dead() and paused and ads.is_available() and actor.can_revive(), "timeout não concede recompensa nem libera a pausa de resultados")

func test_failure_focus_and_callback_order() -> void:
	actor = await new_run()
	actor.survival_time = 40
	var ui: Node = await death(actor)
	ui._request_reward("revive")
	await process_frame
	check(root.get_node("AudioManager")._ad_suspended, "anúncio suspende áudio do jogo")
	fake.failed.emit(fake.token,"Sem preenchimento")
	await wait()
	check(actor.is_dead() and actor.can_revive() and not root.get_node("AudioManager")._ad_suspended and pm.is_active(ui), "falha do provedor restaura áudio e mantém resultado pausado")
	ui._request_reward("revive")
	await process_frame
	pm.acquire(pm, &"focus")
	fake.closed.emit(fake.token)
	# Some SDKs defer their earned callback until immediately after dismissal.
	fake.call_deferred("emit_signal", "earned", fake.token)
	await wait(0.25)
	check(not actor.is_dead() and paused and pm.is_active(pm), "recompensa após fechamento aceita retorno sem liberar pausa de foco")
	pm.release(pm)
	actor.set_physics_process(false)
	check(not paused, "retorno só libera gameplay quando foco também foi restaurado")
	save.load_data()
	check(save.reward_receipts[actor._run_id].has("revive"), "consumo do retorno persiste após recarregar save")
	save.settle_run_progress("boss-double-test",60)
	save.reward_receipts["boss-double-test"]["boss"]=150
	var balance: int=save.gold
	check(save.double_run_reward("boss-double-test").amount==210 and save.gold==balance+210, "dobro inclui bônus do chefe já computado na run")
