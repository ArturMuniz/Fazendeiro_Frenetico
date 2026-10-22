class_name ArenaMaps
extends RefCounted

## Approved map compositions. Combat rules remain in MapDB.
const WORLD_SIZE := Vector2(2048, 1536)
const DATA := {
	"horta": {"texture": "res://art/arenas/horta.png", "bounds": Rect2(-956, -574, 1908, 1092)},
	"celeiro": {"texture": "res://art/arenas/celeiro.png", "bounds": Rect2(-790, -390, 1580, 940)},
	"pomar": {"texture": "res://art/arenas/pomar.png", "bounds": Rect2(-585, -330, 1190, 790)},
}
