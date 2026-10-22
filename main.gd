extends Node2D
class_name Main

## Prepara a run do mapa escolhido no lobby (SaveManager.selected_map):
## chão, música, nome na tela e as fases do spawner. Se o mapa escolhido
## não existir ou ainda estiver bloqueado, cai na Horta.

const LANDSCAPE = preload("res://farm_landscape.gd")

@onready var ground_tilemap: TileMapLayer = $GroundTileMap
@onready var map_label: Label = $CanvasLayer/MapLabel
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var spawner: EnemySpawner = $EnemySpawner
@onready var hud: HUD = $HUD

var current_map_id: String = "horta"
var landscape: FarmLandscape
var checkpoint: RunCheckpoint


func _ready() -> void:
	var chosen: String = SaveManager.selected_map
	if MapDB.MAPS.has(chosen) and SaveManager.is_map_unlocked(chosen):
		current_map_id = chosen
	SaveManager.selected_map = current_map_id

	var data: Dictionary = MapDB.MAPS[current_map_id]
	map_label.text = "Mapa: %s" % data["name"]
	map_label.hide()
	pause_button.hide()
	ground_tilemap.hide()
	$Background.z_index = -20
	landscape = LANDSCAPE.new()
	landscape.name = "FarmLandscape"
	add_child(landscape)
	landscape.configure(current_map_id, $player)
	if OS.is_debug_build():
		print("HD RUN map=", current_map_id, " viewport=", get_viewport_rect().size, " renderer=", RenderingServer.get_current_rendering_method())

	AudioManager.play_music(data.get("music_id", "gameplay"))

	pause_button.pressed.connect(pause_menu.open)
	spawner.phase_changed.connect(hud.show_phase)
	spawner.encounter_announced.connect(hud.announce)
	spawner.setup_campaign(current_map_id)
	checkpoint = RunCheckpoint.new()
	checkpoint.name = "RunCheckpoint"
	add_child(checkpoint)
	checkpoint.setup($player, spawner)
