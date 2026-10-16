extends Node

## Autoload "AudioManager" — toca efeitos sonoros e música de fundo.
## Usa um pool de AudioStreamPlayer com sistema de PRIORIDADE: quando
## os 8 canais estão ocupados, um som novo só rouba o canal do som de
## MENOR prioridade tocando no momento (e só se for igual ou mais
## importante que ele) — assim um clique de botão nunca corta o jingle
## de level-up, mas um "boss_death" sempre consegue tocar.
##
## Uso:
##   AudioManager.play_sfx("hit")
##   AudioManager.play_music("gameplay")

const SFX_PATHS: Dictionary = {
	"attack_melee": "res://audio/sfx_attack_melee.wav",
	"attack_ranged": "res://audio/sfx_attack_ranged.wav",
	"hit": "res://audio/sfx_hit.wav",
	"enemy_death": "res://audio/sfx_enemy_death.wav",
	"boss_death": "res://audio/sfx_boss_death.wav",
	"boss_spawn": "res://audio/sfx_boss_spawn.wav",
	"level_up": "res://audio/sfx_level_up.wav",
	"fusion": "res://audio/sfx_fusion.wav",
	"pickup": "res://audio/sfx_pickup.wav",
	"player_hurt": "res://audio/sfx_player_hurt.wav",
	"button": "res://audio/sfx_button.wav",
	"purchase": "res://audio/sfx_purchase.wav",
	"game_over": "res://audio/sfx_game_over.wav",
}

## 3 = crítica (raro, não pode ser cortado), 2 = alta, 1 = média, 0 = baixa.
const SFX_PRIORITY: Dictionary = {
	"boss_death": 3,
	"level_up": 3,
	"boss_spawn": 3,
	"game_over": 3,
	"hit": 2,
	"pickup": 2,
	"player_hurt": 2,
	"fusion": 2,
	"attack_melee": 1,
	"attack_ranged": 1,
	"enemy_death": 1,
	"purchase": 1,
	"button": 0,
}

const MUSIC_PATHS: Dictionary = {
	"hub": "res://audio/music_hub.wav",
	"gameplay": "res://audio/music_gameplay.ogg",
	"map_celeiro": "res://audio/music_map_celeiro.ogg",
}

const SFX_POOL_SIZE: int = 8

var sfx_volume_db: float = -3.0
var music_volume_db: float = -11.0

var _sfx_streams: Dictionary = {}
var _music_streams: Dictionary = {}
var _sfx_players: Array = []
var _sfx_player_priority: Array = []
var _music_player: AudioStreamPlayer
var _current_music_id: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	for id in SFX_PATHS:
		_sfx_streams[id] = load(SFX_PATHS[id])

	for id in MUSIC_PATHS:
		var stream: AudioStream = load(MUSIC_PATHS[id])
		if stream is AudioStreamWAV:
			stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		elif stream is AudioStreamOggVorbis:
			stream.loop = true
		_music_streams[id] = stream

	for i in range(SFX_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(player)
		_sfx_players.append(player)
		_sfx_player_priority.append(-1)

	_music_player = AudioStreamPlayer.new()
	_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_music_player)


## Toca um efeito sonoro pelo id (ver SFX_PATHS). Varia um pouco o
## pitch a cada toque pra não soar robótico quando repete muito rápido
## (essencial pra hit/pickup, que tocam dezenas de vezes por sessão).
func play_sfx(id: String, pitch_variation: float = 0.08) -> void:
	if not _sfx_streams.has(id):
		return

	var priority: int = SFX_PRIORITY.get(id, 1)
	var target_index: int = _find_player_slot(priority)
	if target_index == -1:
		return  # todos os canais ocupados com sons mais importantes: ignora

	var player: AudioStreamPlayer = _sfx_players[target_index]
	_sfx_player_priority[target_index] = priority
	player.stream = _sfx_streams[id]
	player.volume_db = sfx_volume_db
	player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	player.play()


## Acha um canal livre; se não houver nenhum, rouba o de menor
## prioridade tocando no momento — mas só se o som novo for igual ou
## mais importante que ele. Retorna -1 se não houver canal disponível.
func _find_player_slot(new_priority: int) -> int:
	for i in range(_sfx_players.size()):
		if not _sfx_players[i].playing:
			return i

	var lowest_priority: int = 999
	var lowest_index: int = -1
	for i in range(_sfx_players.size()):
		if _sfx_player_priority[i] < lowest_priority:
			lowest_priority = _sfx_player_priority[i]
			lowest_index = i

	if new_priority >= lowest_priority:
		return lowest_index
	return -1


func play_music(id: String) -> void:
	if not _music_streams.has(id):
		return
	if _current_music_id == id and _music_player.playing:
		return
	_current_music_id = id
	_music_player.stream = _music_streams[id]
	_music_player.volume_db = music_volume_db
	_music_player.play()


func stop_music() -> void:
	_current_music_id = ""
	_music_player.stop()


func set_sfx_volume_db(db: float) -> void:
	sfx_volume_db = db


func set_music_volume_db(db: float) -> void:
	music_volume_db = db
	_music_player.volume_db = db


## Libera playbacks antes do encerramento, inclusive ao rodar testes headless.
func shutdown() -> void:
	stop_music()
	if is_instance_valid(_music_player):
		_music_player.stream = null
	for player in _sfx_players:
		if is_instance_valid(player):
			player.stop()
			player.stream = null
	_sfx_streams.clear()
	_music_streams.clear()


func _exit_tree() -> void:
	shutdown()
