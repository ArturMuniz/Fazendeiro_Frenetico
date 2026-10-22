extends Node2D
class_name EnemySpawner

## Controla os inimigos da run. Dois modos:
##
## CAMPANHA: o mapa define 3 fases (cada uma com sua duração, ritmo de
## spawn e arquétipos permitidos) e depois a fase do boss, com o boss
## fixo do mapa. Entre as fases há uma pausa curta: o jogador ganha uma
## carta grátis e recupera um pouco de vida.
##
## MODO LIVRE: depois de derrotar o boss o jogador pode continuar. Aí o
## spawner vira o endless de antes: tudo liberado, spawn cada vez mais
## rápido e HP/dano escalando sem teto.
##
## Os dados de cada mapa vêm do MapDB.

signal phase_changed(label: String, phase_number: int, total_phases: int)
signal encounter_announced(label: String)

@export var spawn_radius: float = 400.0
@export var max_active_enemies: int = 100

## Pausa entre fases (segundos).
@export var breather_duration: float = 4.0
## Quanto de vida volta no fim de cada fase (fração da vida máxima).
@export var breather_heal_fraction: float = 0.25
## Para testar: 0.2 deixa cada fase com 20% da duração normal.
@export var phase_duration_scale: float = 1.0

## Degraus de dificuldade: cada fase concluída soma isso ao multiplicador,
## e dentro da fase ele sobe mais um pouco até o fim dela.
@export var difficulty_step_per_phase: float = 0.30
@export var difficulty_ramp_within_phase: float = 0.15

## Modo livre: a cada free_scale_period segundos HP/dano sobem
## free_scale_amount (sem teto), e o spawn acelera até free_interval_min.
@export var free_scale_period: float = 30.0
@export var free_scale_amount: float = 0.35
@export var free_interval_min: float = 0.6
@export var free_interval_ramp_time: float = 300.0

const ENEMY_SCENE: PackedScene = preload("res://enemy.tscn")
const FREE_MODE_ARCHETYPES: Array = ["pulgao", "lesma", "gafanhoto", "mosca"]

enum Mode { IDLE, CAMPAIGN, BOSS, FREE }

@onready var spawn_timer: Timer = $SpawnTimer

var _mode: Mode = Mode.IDLE
var _map_data: Dictionary = {}
var _phases: Array = []
var _phase_index: int = 0
var _phase_elapsed: float = 0.0
var _breather_left: float = 0.0
var _in_breather: bool = false
var _free_elapsed: float = 0.0
var _boss_interval: float = 2.0
var _current_archetypes: Array = ["pulgao"]
var _player: Node2D
var _leader_phases: Array = []
var _leader_warning_left: float = 0.0
var _leader_position := Vector2.ZERO
var _leader_id: String = ""
const LEADER_WARNING := 1.8


func _ready() -> void:
	add_to_group("spawner")
	_player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


## Chamado pelo main.gd depois de sortear/escolher o mapa.
func setup_campaign(map_id: String) -> void:
	_leader_phases.clear()
	_cancel_leader_warning()
	_map_data = MapDB.MAPS[map_id]
	_phases = _map_data["phases"]
	_mode = Mode.CAMPAIGN
	_begin_phase(0)


func start_free_mode() -> void:
	if _mode == Mode.FREE:
		return
	_mode = Mode.FREE
	_cancel_leader_warning()
	_free_elapsed = 0.0
	_in_breather = false
	_current_archetypes = FREE_MODE_ARCHETYPES
	spawn_timer.wait_time = _boss_interval
	spawn_timer.start()
	phase_changed.emit("Modo Livre", 0, 0)


func _process(delta: float) -> void:
	match _mode:
		Mode.CAMPAIGN:
			_process_campaign(delta)
		Mode.FREE:
			_free_elapsed += delta
			var t: float = clamp(_free_elapsed / max(free_interval_ramp_time, 1.0), 0.0, 1.0)
			spawn_timer.wait_time = lerp(_boss_interval, free_interval_min, t)


func _process_campaign(delta: float) -> void:
	if _in_breather:
		_breather_left -= delta
		if _breather_left <= 0.0:
			_in_breather = false
			_begin_phase(_phase_index + 1)
		return

	_phase_elapsed += delta
	_process_encounter(delta)
	if _phase_elapsed >= _phase_duration(_phase_index):
		_end_phase()


func _phase_duration(index: int) -> float:
	return float(_phases[index]["duration"]) * phase_duration_scale

func campaign_duration() -> float:
	var duration := _phases.size() * breather_duration
	for i in range(_phases.size()): duration += _phase_duration(i)
	return duration

func _process_encounter(delta: float) -> void:
	if not _leader_id.is_empty():
		_leader_warning_left = maxf(0.0, _leader_warning_left - delta)
		queue_redraw()
		if _leader_warning_left > 0 or get_tree().get_nodes_in_group("enemies").size() >= max_active_enemies: return
		var leader := _spawn_enemy(_leader_id, true, _leader_position)
		if leader == null: return
		_cancel_leader_warning()
		# A small escort, spread around its leader, still respects the total cap.
		for i in range(4):
			if get_tree().get_nodes_in_group("enemies").size() >= max_active_enemies: break
			_spawn_enemy(_current_archetypes[i % _current_archetypes.size()], false, leader.global_position + Vector2.from_angle(i * TAU / 4) * 70)
		return
	if _leader_phases.has(_phase_index) or _phase_elapsed < _phase_duration(_phase_index) * 0.6: return
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.is_leader: return
	_leader_phases.append(_phase_index)
	_leader_id = str(_current_archetypes[-1])
	_leader_position = _spawn_point()
	_leader_warning_left = LEADER_WARNING
	encounter_announced.emit("Líder de horda chegando!\nDerrote-o para ganhar uma melhoria.")
	AudioManager.play_sfx("boss_spawn")
	queue_redraw()

func _cancel_leader_warning() -> void:
	_leader_id = ""
	_leader_warning_left = 0
	queue_redraw()

func _draw() -> void:
	if _leader_id.is_empty(): return
	var point := to_local(_leader_position)
	var fraction := 1.0 - _leader_warning_left / LEADER_WARNING
	draw_circle(point, 38, Color(0.8, 0.24, 0.12, 0.18))
	draw_arc(point, 38, -PI / 2, -PI / 2 + TAU * maxf(fraction, 0.01), 40, Color("f3bc64"), 4)
	draw_line(point + Vector2(-12, 0), point + Vector2(12, 0), Color("f3bc64"), 3)
	draw_line(point + Vector2(0, -12), point + Vector2(0, 12), Color("f3bc64"), 3)


func _begin_phase(index: int) -> void:
	if index >= _phases.size():
		_begin_boss_phase()
		return

	_phase_index = index
	_phase_elapsed = 0.0
	var phase: Dictionary = _phases[index]
	_current_archetypes = phase["archetypes"]
	spawn_timer.wait_time = phase["spawn_interval"]
	spawn_timer.start()
	phase_changed.emit(phase["name"], index + 1, _phases.size() + 1)


## Fim de uma fase: para de spawnar, cura um pouco e dá uma carta grátis.
func _end_phase() -> void:
	_cancel_leader_warning()
	spawn_timer.stop()
	_in_breather = true
	_breather_left = breather_duration
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")
	if _player != null:
		if _player.has_method("heal_percent"):
			_player.heal_percent(breather_heal_fraction)
		if _player.has_method("grant_free_level_up"):
			_player.grant_free_level_up()


func _begin_boss_phase() -> void:
	_cancel_leader_warning()
	_mode = Mode.BOSS
	var boss_phase: Dictionary = _map_data["boss_phase"]
	_current_archetypes = boss_phase["archetypes"]
	_boss_interval = boss_phase["spawn_interval"]
	spawn_timer.wait_time = _boss_interval
	spawn_timer.start()
	phase_changed.emit(boss_phase["name"], _phases.size() + 1, _phases.size() + 1)
	AudioManager.play_sfx("boss_spawn")
	_spawn_enemy(_map_data["boss_id"])


func _current_difficulty_multiplier() -> float:
	var base: float = _map_data.get("base_difficulty", 1.0)
	var step: float = 0.0
	match _mode:
		Mode.CAMPAIGN:
			var duration: float = max(_phase_duration(_phase_index), 1.0)
			var progress: float = clamp(_phase_elapsed / duration, 0.0, 1.0)
			step = _phase_index * difficulty_step_per_phase + progress * difficulty_ramp_within_phase
		Mode.BOSS:
			step = _phases.size() * difficulty_step_per_phase
		Mode.FREE:
			step = _phases.size() * difficulty_step_per_phase + (_free_elapsed / free_scale_period) * free_scale_amount
	return base * (1.0 + step)


func _on_spawn_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("enemies").size() >= max_active_enemies:
		return
	_spawn_enemy(_current_archetypes[randi() % _current_archetypes.size()])


func _spawn_point() -> Vector2:
	var landscape := get_tree().current_scene.get_node_or_null("FarmLandscape") as FarmLandscape
	if landscape != null:
		return landscape.spawn_point(_player.global_position, spawn_radius)
	for attempt in range(16):
		var point := _player.global_position + Vector2.from_angle(randf() * TAU) * spawn_radius
		if landscape == null or landscape.obstacles.is_clear(point, 40): return point
	var fallback := _player.global_position + Vector2.RIGHT * spawn_radius
	if landscape != null:
		while not landscape.obstacles.is_clear(fallback, 40): fallback.x += 512
	return fallback

func _spawn_enemy(id: String, leader: bool = false, point: Vector2 = Vector2.INF) -> Enemy:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(_player):
		return null

	var destination := _spawn_point() if point == Vector2.INF else point
	var landscape := get_tree().current_scene.get_node_or_null("FarmLandscape") as FarmLandscape
	if landscape != null and not landscape.obstacles.is_clear(destination, 40): destination = _spawn_point()

	var enemy: Enemy = Pool.acquire(ENEMY_SCENE)
	var scene := get_tree().current_scene as Node2D
	# Set the transform before entering physics; pooled bodies must not briefly
	# appear at their previous position or on top of the player at the origin.
	enemy.position = scene.to_local(destination)
	scene.add_child(enemy)
	enemy.configure(id, _current_difficulty_multiplier(), _player, leader)
	return enemy
