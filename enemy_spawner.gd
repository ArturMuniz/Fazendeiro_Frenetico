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


func _ready() -> void:
	add_to_group("spawner")
	_player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


## Chamado pelo main.gd depois de sortear/escolher o mapa.
func setup_campaign(map_id: String) -> void:
	_map_data = MapDB.MAPS[map_id]
	_phases = _map_data["phases"]
	_mode = Mode.CAMPAIGN
	_begin_phase(0)


func start_free_mode() -> void:
	if _mode == Mode.FREE:
		return
	_mode = Mode.FREE
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
	if _phase_elapsed >= _phase_duration(_phase_index):
		_end_phase()


func _phase_duration(index: int) -> float:
	return float(_phases[index]["duration"]) * phase_duration_scale


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


func _spawn_enemy(id: String) -> void:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(_player):
		return

	var angle: float = randf() * TAU
	var offset: Vector2 = Vector2(cos(angle), sin(angle)) * spawn_radius

	var enemy: Enemy = Pool.acquire(ENEMY_SCENE)
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = _player.global_position + offset
	enemy.configure(id, _current_difficulty_multiplier(), _player)
