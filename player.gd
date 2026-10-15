extends CharacterBody2D
class_name Player

## Controla o movimento do fazendeiro a partir do joystick virtual.
## Anexe este script ao CharacterBody2D "Player".

signal leveled_up

const MAX_WEAPONS: int = 6
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

const IDLE_TEXTURE: Texture2D = preload("res://art/player_idle_0.png")
const WALK_TEXTURES: Array = [
	preload("res://art/player_walk_0.png"),
	preload("res://art/player_walk_1.png"),
]
var _walk_frame: int = 0

var health: float
var xp: float = 0.0
var level: int = 1
var xp_to_next: float = 10.0
var pending_level_ups: int = 0
var survival_time: float = 0.0
var kills: int = 0
var boss_defeated: bool = false

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
var _auto_collect_timer: Timer


func _ready() -> void:
	add_to_group("player")
	xp_to_next = xp_to_first_level
	_apply_meta_progression()
	health = max_health
	add_weapon(_starting_weapon)
	anim_timer.timeout.connect(_on_anim_timer_timeout)


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
	xp += amount
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
	pending_level_ups += 1
	leveled_up.emit()


var _first_clear: bool = false


func register_kill(is_boss: bool = false) -> void:
	kills += 1
	if is_boss:
		boss_defeated = true
		if not _boss_victory_shown:
			_boss_victory_shown = true
			_on_boss_defeated()


## Boss morreu: registra o mapa como concluído (salva na hora, mesmo que
## o jogador escolha continuar no modo livre) e mostra a escolha.
func _on_boss_defeated() -> void:
	_first_clear = SaveManager.mark_map_cleared(SaveManager.selected_map)
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


func _victory_gold() -> int:
	var gold: int = int(survival_time / 5.0) + level * 3 + 50
	if _first_clear:
		gold += 100  # bônus de primeira conclusão do mapa
	return gold


func _on_continue_free_mode() -> void:
	var spawner: Node = get_tree().get_first_node_in_group("spawner")
	if spawner != null and spawner.has_method("start_free_mode"):
		spawner.start_free_mode()


## Vai direto pro próximo mapa: build zera (cena nova), moedas da vitória
## são creditadas antes de trocar.
func _on_next_map_chosen(next_id: String) -> void:
	if _dead:
		return
	_dead = true
	set_physics_process(false)
	SaveManager.add_gold(_victory_gold())
	SaveManager.selected_map = next_id
	get_tree().change_scene_to_file("res://main.tscn")


func _on_end_run_as_victory() -> void:
	if _dead:
		return
	_dead = true
	set_physics_process(false)
	AudioManager.stop_music()
	AudioManager.play_sfx("level_up")

	var gold_earned: int = _victory_gold()
	SaveManager.add_gold(gold_earned)

	var run_end_ui: RunEndUI = RUN_END_UI_SCENE.instantiate()
	get_tree().current_scene.add_child(run_end_ui)
	run_end_ui.show_results({
		"victory": true,
		"survival_time": survival_time,
		"level": level,
		"kills": kills,
		"boss_defeated": true,
		"gold_earned": gold_earned,
	})


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
			defense_percent += increment
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
		_auto_collect_timer.wait_time = 15.0
		_auto_collect_timer.timeout.connect(_on_auto_collect_timeout)
		add_child(_auto_collect_timer)
	_auto_collect_timer.start()


func _on_auto_collect_timeout() -> void:
	for orb in get_tree().get_nodes_in_group("xp_orbs"):
		if orb.has_method("collect_instantly"):
			orb.collect_instantly()


func _physics_process(delta: float) -> void:
	survival_time += delta
	var move_vector: Vector2 = joystick.get_vector()

	velocity = move_vector * speed
	move_and_slide()

	_update_facing(move_vector)
	_update_weapon_orbit(delta)


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
	if velocity.length() > 5.0:
		_walk_frame = (_walk_frame + 1) % WALK_TEXTURES.size()
		sprite.texture = WALK_TEXTURES[_walk_frame]
	else:
		sprite.texture = IDLE_TEXTURE


var _dead: bool = false


func take_damage(amount: float) -> void:
	if _dead:
		return
	var reduced_amount: float = amount * (1.0 - defense_percent)
	health -= reduced_amount
	AudioManager.play_sfx("player_hurt")
	if health <= 0.0:
		_die()


const RUN_END_UI_SCENE: PackedScene = preload("res://run_end_ui.tscn")


func _die() -> void:
	if _dead:
		return
	_dead = true
	set_physics_process(false)
	AudioManager.stop_music()
	AudioManager.play_sfx("game_over")

	var gold_earned: int = int(survival_time / 5.0) + level * 3 + (20 if boss_defeated else 0)
	SaveManager.add_gold(gold_earned)

	var run_end_ui: RunEndUI = RUN_END_UI_SCENE.instantiate()
	get_tree().current_scene.add_child(run_end_ui)
	run_end_ui.show_results({
		"survival_time": survival_time,
		"level": level,
		"kills": kills,
		"boss_defeated": boss_defeated,
		"gold_earned": gold_earned,
	})
