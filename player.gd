extends CharacterBody2D
class_name Player

## Controla o movimento do fazendeiro a partir do joystick virtual.
## Anexe este script ao CharacterBody2D "Player".

signal leveled_up

const MAX_WEAPONS: int = 3
const WEAPON_SCENES: Dictionary = {
	"ranged": preload("res://weapon.tscn"),
	"melee_aura": preload("res://melee_aura_weapon.tscn"),
	"melee_thrown": preload("res://thrown_weapon.tscn"),
	"melee_stab": preload("res://melee_stab_weapon.tscn"),
	"summon": preload("res://summon_weapon.tscn"),
	"trap": preload("res://trap_weapon.tscn"),
}

@export var speed: float = 120.0
@export var joystick_path: NodePath
@export var max_health: float = 100.0
@export var magnet_radius: float = 80.0
@export var xp_to_first_level: float = 10.0
@export var xp_growth: float = 1.25

@onready var sprite: Sprite2D = $Sprite2D
@onready var joystick: TouchJoystick = get_node(joystick_path)
@onready var anim_timer: Timer = $AnimTimer

const IDLE_TEXTURE: Texture2D = preload("res://art/fazendeiro_fiel/fazendeiro_idle_00.png")
const WALK_TEXTURES: Array = [
	preload("res://art/fazendeiro_fiel/fazendeiro_walk_00.png"),
	preload("res://art/fazendeiro_fiel/fazendeiro_walk_01.png"),
]
var _walk_frame: int = 0
var art_animator: SpriteAnimator
var _idle_elapsed: float = 0.0
var _idle_gesture_active: bool = false
var _idle_gesture_index: int = 0
var _idle_gesture_delay: float = 3.5
var _visual_running: bool = false
var _revive_grace: float = 0.0
var _reviving: bool = false
const IDLE_GESTURES: Dictionary = {
	"fazendeiro": ["idle_hat", "idle_swat"],
	"vovo": ["idle_plant"],
}

var health: float
var xp: float = 0.0
var level: int = 1
var xp_to_next: float = 10.0
var pending_level_ups: int = 0
var survival_time: float = 0.0
var kills: int = 0
var boss_defeated: bool = false
var _run_id: String
var _boss_gold_paid: int = 0
var _result_ui: RunEndUI
var _pending_victory: bool = false
var _pending_next_map: String = ""

var _starting_weapon: String = "foice"

## Bônus globais que afetam todas as armas (vêm de upgrades e passivos)
var damage_bonus: float = 0.0
var cooldown_multiplier: float = 1.0

## Cada entrada: {"id": String, "level": int, "node": Weapon}
var weapons: Array = []

const WEAPON_ORBIT_RADIUS: float = 42.0
const WEAPON_ORBIT_SPEED: float = 1.4
var _weapon_orbit_time: float = 0.0

const MAX_PASSIVES: int = 6

## Cada entrada: {"id": String, "level": int}
var passives: Array = []
var defense_percent: float = 0.0
var bonus_max_health: float = 0.0
var auto_collect_orbs: bool = false
var regeneration: float = 0.0
var xp_bonus: float = 0.0
var _auto_collect_timer: Timer


func _ready() -> void:
	_run_id = SaveManager.new_run_id()
	add_to_group("player")
	xp_to_next = xp_to_first_level
	_apply_meta_progression()
	health = max_health
	add_weapon(_starting_weapon)
	anim_timer.timeout.connect(_on_anim_timer_timeout)
	anim_timer.stop()
	art_animator = SpriteAnimator.new()
	add_child(art_animator)
	art_animator.configure(SaveManager.selected_character, sprite)


## Aplica o personagem escolhido no Hub e os upgrades permanentes da
## fazenda antes da run começar.
func _apply_meta_progression() -> void:
	var char_data: Dictionary = CharacterDB.CHARACTERS.get(SaveManager.selected_character, {})
	max_health += char_data.get("health_mod", 0.0)
	speed *= (1.0 + char_data.get("speed_mod", 0.0))
	damage_bonus += char_data.get("damage_mod", 0.0)
	_starting_weapon = char_data.get("starting_weapon", "foice")

	for id in FarmUpgradeDB.UPGRADES:
		var level_bought: int = SaveManager.get_farm_upgrade_level(id)
		if level_bought <= 0:
			continue
		var data: Dictionary = FarmUpgradeDB.UPGRADES[id]
		var total: float = data["amount_per_level"] * level_bought
		match data["stat"]:
			"bonus_health_flat":
				max_health += total
			"bonus_damage_flat":
				damage_bonus += total
			"bonus_speed_percent":
				speed *= (1.0 + total)


func add_xp(amount: float) -> void:
	if _dead:
		return
	xp += amount * (1.0 + xp_bonus)
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next *= xp_growth
		pending_level_ups += 1
		leveled_up.emit()


const BOSS_VICTORY_UI_SCENE: PackedScene = preload("res://boss_victory_ui.tscn")
var _boss_victory_shown: bool = false


## Cura uma fração da vida máxima (usado na pausa entre fases).
func heal_percent(fraction: float) -> void:
	health = min(max_health, health + max_health * fraction)


## Carta grátis: reaproveita a tela de level-up sem gastar XP (usado na
## pausa entre fases).
func grant_free_level_up() -> void:
	if _dead:
		return
	pending_level_ups += 1
	leveled_up.emit()


func register_kill(is_boss: bool = false) -> void:
	if _dead:
		return
	kills += 1
	if is_boss:
		boss_defeated = true
		if not _boss_victory_shown:
			_boss_victory_shown = true
			_on_boss_defeated()


## Boss morreu: registra o mapa como concluído (salva na hora, mesmo que
## o jogador escolha continuar no modo livre) e mostra a escolha.
func _on_boss_defeated() -> void:
	_show_boss_victory_choice()


func _show_boss_victory_choice() -> void:
	var next_id: String = MapDB.get_next_map_id(SaveManager.selected_map)
	var next_name: String = MapDB.MAPS[next_id]["name"] if next_id != "" else ""

	var ui: BossVictoryUI = BOSS_VICTORY_UI_SCENE.instantiate()
	get_tree().current_scene.add_child(ui)
	ui.configure(next_name)
	ui.next_map_chosen.connect(_on_next_map_chosen.bind(next_id))
	ui.continue_chosen.connect(_on_continue_free_mode)
	ui.end_run_chosen.connect(_on_end_run_as_victory)
	ui.save_retry_requested.connect(_save_victory.bind(ui))
	_save_victory(ui)


func _save_victory(ui: BossVictoryUI) -> void:
	var result := SaveManager.claim_boss_reward(_run_id, SaveManager.selected_map)
	if not result["ok"]:
		ui.show_save_error()
		return
	_boss_gold_paid = result["amount"]
	var next_id: String = MapDB.get_next_map_id(SaveManager.selected_map)
	ui.configure(MapDB.MAPS[next_id]["name"] if next_id != "" else "", _boss_gold_paid)


func _on_continue_free_mode() -> void:
	var spawner: Node = get_tree().get_first_node_in_group("spawner")
	if spawner != null and spawner.has_method("start_free_mode"):
		spawner.start_free_mode()


## Vai direto pro próximo mapa: build zera (cena nova), moedas da vitória
## são creditadas antes de trocar.
func _on_next_map_chosen(next_id: String) -> void:
	if _dead:
		return
	_finish_run(true, next_id)


func _on_end_run_as_victory() -> void:
	if _dead:
		return
	AudioManager.play_sfx("level_up")
	_finish_run(true)


## Adiciona uma arma nova ao inventário, ou funde com uma cópia já
## existente do mesmo id (regra descrita no GDD: 2 iguais = 1 nível acima).
func add_weapon(id: String) -> void:
	for entry in weapons:
		if entry["id"] == id:
			_merge_weapon(entry)
			return

	if weapons.size() >= MAX_WEAPONS:
		return

	var kind: String = WeaponDB.WEAPONS[id].get("kind", "ranged")
	var scene: PackedScene = WEAPON_SCENES.get(kind, WEAPON_SCENES["ranged"])

	var node = scene.instantiate()
	add_child(node)
	node.configure(id, 1)
	weapons.append({"id": id, "level": 1, "node": node})


func _merge_weapon(entry: Dictionary) -> void:
	if entry["level"] >= 3:
		return
	entry["level"] += 1
	entry["node"].configure(entry["id"], entry["level"])
	AudioManager.play_sfx("fusion")


## Verdadeiro se essa arma já está no nível máximo (3) — usado pela
## tela de level-up para não oferecer fusões impossíveis.
func has_maxed_weapon(id: String) -> bool:
	for entry in weapons:
		if entry["id"] == id:
			return entry["level"] >= 3
	return false


## Verdadeiro se o inventário está cheio E o jogador ainda não tem essa arma
## (nesse caso não faz sentido oferecer a arma como opção nova).
func is_weapon_unavailable(id: String) -> bool:
	var already_has: bool = false
	for entry in weapons:
		if entry["id"] == id:
			already_has = true
			break
	if already_has:
		return has_maxed_weapon(id)
	return weapons.size() >= MAX_WEAPONS


## Adiciona um item passivo novo, ou funde com uma cópia já existente
## (mesma regra das armas: 2 iguais = 1 nível acima).
func add_passive(id: String) -> void:
	for entry in passives:
		if entry["id"] == id:
			_merge_passive(entry)
			return

	if passives.size() >= MAX_PASSIVES:
		return

	passives.append({"id": id, "level": 1})
	_apply_passive_tier(id, 1)


func _merge_passive(entry: Dictionary) -> void:
	if entry["level"] >= 3:
		return
	entry["level"] += 1
	_apply_passive_tier(entry["id"], entry["level"])
	AudioManager.play_sfx("fusion")


## Aplica só o GANHO desse nível (o dicionário guarda incrementos,
## não totais acumulados) — por isso fundir nunca precisa "desfazer" nada.
func _apply_passive_tier(id: String, tier: int) -> void:
	var data: Dictionary = PassiveDB.PASSIVES[id]
	var stat: String = data["stat"]
	var increment: float = data["levels"][tier - 1]

	match stat:
		"defense_percent":
			defense_percent = minf(0.75, defense_percent + increment)
		"bonus_max_health":
			bonus_max_health += increment
			max_health += increment
			health += increment
		"attack_speed_percent":
			cooldown_multiplier *= (1.0 - increment)
			for entry in weapons:
				entry["node"].configure(entry["id"], entry["level"])
		"move_speed_percent":
			speed *= (1.0 + increment)
		"magnet_percent":
			magnet_radius *= (1.0 + increment)
		"regeneration":
			regeneration += increment
		"xp_bonus":
			xp_bonus += increment
		"damage_bonus":
			damage_bonus += increment

	if data.get("special_level3") == "auto_collect" and tier == 3:
		_enable_auto_collect()


func has_maxed_passive(id: String) -> bool:
	for entry in passives:
		if entry["id"] == id:
			return entry["level"] >= 3
	return false


func is_passive_unavailable(id: String) -> bool:
	var already_has: bool = false
	for entry in passives:
		if entry["id"] == id:
			already_has = true
			break
	if already_has:
		return has_maxed_passive(id)
	return passives.size() >= MAX_PASSIVES


func _enable_auto_collect() -> void:
	auto_collect_orbs = true
	if _auto_collect_timer == null:
		_auto_collect_timer = Timer.new()
		_auto_collect_timer.name = "AutoCollectTimer"
		_auto_collect_timer.wait_time = 15.0
		_auto_collect_timer.timeout.connect(_on_auto_collect_timeout)
		add_child(_auto_collect_timer)
	_auto_collect_timer.start()


func _on_auto_collect_timeout() -> void:
	for orb in get_tree().get_nodes_in_group("xp_orbs"):
		if orb.has_method("collect_instantly"):
			orb.collect_instantly()


func _physics_process(delta: float) -> void:
	_revive_grace = maxf(0.0, _revive_grace - delta)
	survival_time += delta
	if not _dead:
		health = minf(max_health, health + regeneration * delta)
	var move_vector: Vector2 = joystick.get_vector()

	velocity = move_vector * speed
	move_and_slide()

	_update_facing(move_vector)
	_update_visual_animation(move_vector, delta)
	_update_weapon_orbit(delta)


func _update_visual_animation(move_vector: Vector2, delta: float) -> void:
	if _dead:
		return
	if velocity.length() > 5.0:
		_idle_elapsed = 0.0
		var interrupt_gesture := _idle_gesture_active
		_idle_gesture_active = false
		var strength := move_vector.length()
		if strength >= 0.8:
			_visual_running = true
		elif strength <= 0.62:
			_visual_running = false
		var next := "run" if _visual_running and art_animator.animations.has("run") else "walk"
		art_animator.play(next, interrupt_gesture)
		if art_animator.animations.has("run"):
			art_animator.playback_speed = clampf(velocity.length() / (120.0 if next == "run" else 65.0), 0.5, 1.8)
		return
	_visual_running = false
	art_animator.playback_speed = 1.0
	if _idle_gesture_active:
		if not art_animator.finished:
			return
		_idle_gesture_active = false
		_idle_elapsed = 0.0
		_idle_gesture_delay = 5.0
	art_animator.play("idle")
	_idle_elapsed += delta
	var gestures: Array = IDLE_GESTURES.get(art_animator.entity_id, [])
	if not gestures.is_empty() and _idle_elapsed >= _idle_gesture_delay:
		var gesture: String = gestures[_idle_gesture_index % gestures.size()]
		if art_animator.animations.has(gesture):
			art_animator.once(gesture)
			_idle_gesture_active = true
			_idle_gesture_index += 1
		_idle_elapsed = 0.0


func _interrupt_idle_gesture() -> void:
	_idle_elapsed = 0.0
	if _idle_gesture_active:
		_idle_gesture_active = false
		art_animator.play("idle", true)
		art_animator.playback_speed = 1.0


func _update_facing(move_vector: Vector2) -> void:
	# Usa flip horizontal em vez de sprites para cada direção -
	# mais barato de processar e de produzir arte.
	if move_vector.x > 0.05:
		sprite.flip_h = false
	elif move_vector.x < -0.05:
		sprite.flip_h = true


## Distribui os ícones das armas equipadas girando ao redor do
## personagem, estilo Brotato — puramente visual, não afeta alcance
## nem colisão de nenhuma arma.
func _update_weapon_orbit(delta: float) -> void:
	var count: int = weapons.size()
	if count == 0:
		return

	_weapon_orbit_time += delta * WEAPON_ORBIT_SPEED
	for i in range(count):
		var node = weapons[i]["node"]
		if node.icon == null:
			continue
		var angle: float = _weapon_orbit_time + (TAU / count) * i
		node.icon.position = Vector2(cos(angle), sin(angle)) * WEAPON_ORBIT_RADIUS


func _on_anim_timer_timeout() -> void:
	if art_animator != null:
		return
	if velocity.length() > 5.0:
		_walk_frame = (_walk_frame + 1) % WALK_TEXTURES.size()
		sprite.texture = WALK_TEXTURES[_walk_frame]
	else:
		sprite.texture = IDLE_TEXTURE


var _dead: bool = false


func take_damage(amount: float) -> void:
	if _dead or _revive_grace > 0.0 or get_tree().paused:
		return
	_interrupt_idle_gesture()
	var reduced_amount: float = amount * (1.0 - defense_percent)
	health -= reduced_amount
	art_animator.flash()
	AudioManager.play_sfx("player_hurt")
	if health <= 0.0:
		_die()


const RUN_END_UI_SCENE: PackedScene = preload("res://run_end_ui.tscn")


func _die() -> void:
	if _dead:
		return
	var checkpoint: Node = get_tree().current_scene.get_node_or_null("RunCheckpoint")
	if checkpoint != null:
		checkpoint.prepare_death()
	AudioManager.play_sfx("game_over")
	art_animator.playback_speed = 1.0
	art_animator.once("death")
	# Death is a short presentation state; simulation and reward settlement
	# stop immediately, while this one animator finishes before revealing UI.
	art_animator.process_mode = Node.PROCESS_MODE_ALWAYS
	art_animator.completed.connect(_on_death_visual_completed, CONNECT_ONE_SHOT)
	_finish_run(false)
	_result_ui.reveal_after_death(art_animator)

func _on_death_visual_completed(_state: String) -> void:
	art_animator.process_mode = Node.PROCESS_MODE_INHERIT


func is_dead() -> bool:
	return _dead


func _finish_run(victory: bool, next_map: String = "") -> void:
	_dead = true
	pending_level_ups = 0
	set_physics_process(false)
	joystick.reset_input()
	AudioManager.stop_music()
	_pending_victory = victory
	_pending_next_map = next_map
	_settle_and_show_results()


func _settle_and_show_results() -> void:
	# Preserva o bônus preexistente de derrota após chefe, além da vitória já salva.
	var death_bonus := 20 if boss_defeated and not _pending_victory else 0
	var result := SaveManager.settle_run_progress(_run_id, int(survival_time / 5.0) + level * 3 + death_bonus)
	if result["ok"] and _pending_next_map != "":
		SaveManager.selected_map = _pending_next_map
		PauseManager.change_scene("res://main.tscn")
		return
	if not is_instance_valid(_result_ui):
		_result_ui = RUN_END_UI_SCENE.instantiate()
		get_tree().current_scene.add_child(_result_ui)
		_result_ui.save_retry_requested.connect(_settle_and_show_results)
	_result_ui.show_results({
		"victory": _pending_victory,
		"run_id": _run_id,
		"can_revive": can_revive(),
		"checkpoint_label": get_tree().current_scene.checkpoint.description(),
		"survival_time": survival_time,
		"level": level,
		"kills": kills,
		"boss_defeated": boss_defeated,
		"gold_earned": _boss_gold_paid + int(result["amount"]),
		"gold_already_paid": _boss_gold_paid,
		"death_bonus": death_bonus,
		"gold_paid_now": result["paid_now"],
		"save_failed": not result["ok"],
	})


func can_revive() -> bool:
	var receipt: Dictionary = SaveManager.reward_receipts.get(_run_id, {})
	return _dead and not _pending_victory and not _reviving and not receipt.has("revive") and not receipt.has("double")


func revive_checkpoint() -> bool:
	if not can_revive(): return false
	var checkpoint: Node = get_tree().current_scene.get_node_or_null("RunCheckpoint")
	if checkpoint == null or checkpoint.snapshot.is_empty(): return false
	if not SaveManager.claim_run_revive(_run_id): return false
	_reviving = true
	var restored: bool = await checkpoint.restore()
	if not restored:
		_reviving = false
		return false
	_dead = false
	_reviving = false
	_pending_victory = false
	_pending_next_map = ""
	_boss_gold_paid = int(SaveManager.reward_receipts.get(_run_id, {}).get("boss", 0))
	velocity = Vector2.ZERO
	joystick.reset_input()
	_idle_elapsed = 0.0
	_idle_gesture_active = false
	_visual_running = false
	_revive_grace = 2.0
	art_animator.process_mode = Node.PROCESS_MODE_INHERIT
	art_animator.playback_speed = 1.0
	art_animator.play("idle", true)
	set_physics_process(true)
	var result := _result_ui
	_result_ui = null
	if is_instance_valid(result):
		result.queue_free()
	AudioManager.play_music(MapDB.MAPS[SaveManager.selected_map].get("music_id", "gameplay"))
	return true
