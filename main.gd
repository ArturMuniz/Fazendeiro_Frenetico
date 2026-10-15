extends Node2D
class_name Main

## Prepara a run do mapa escolhido no lobby (SaveManager.selected_map):
## chão, música, nome na tela e as fases do spawner. Se o mapa escolhido
## não existir ou ainda estiver bloqueado, cai na Horta.

const MAP_SOURCE_ID: Dictionary = {"horta": 0, "celeiro": 1, "pomar": 2}
const TILE_RANGE: int = 60  # cobre ~15000px de raio a partir do centro

@onready var ground_tilemap: TileMapLayer = $GroundTileMap
@onready var map_label: Label = $CanvasLayer/MapLabel
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var spawner: EnemySpawner = $EnemySpawner
@onready var hud: HUD = $HUD

var current_map_id: String = "horta"


func _ready() -> void:
	var chosen: String = SaveManager.selected_map
	if MapDB.MAPS.has(chosen) and SaveManager.is_map_unlocked(chosen):
		current_map_id = chosen
	SaveManager.selected_map = current_map_id

	var data: Dictionary = MapDB.MAPS[current_map_id]
	map_label.text = "Mapa: %s" % data["name"]
	_fill_ground(MAP_SOURCE_ID.get(current_map_id, 0))

	AudioManager.play_music(data.get("music_id", "gameplay"))

	pause_button.pressed.connect(pause_menu.open)
	spawner.phase_changed.connect(hud.show_phase)
	spawner.setup_campaign(current_map_id)


func _fill_ground(source_id: int) -> void:
	for x in range(-TILE_RANGE, TILE_RANGE + 1):
		for y in range(-TILE_RANGE, TILE_RANGE + 1):
			ground_tilemap.set_cell(Vector2i(x, y), source_id, Vector2i(0, 0))
