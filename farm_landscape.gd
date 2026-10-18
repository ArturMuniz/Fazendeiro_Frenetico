class_name FarmLandscape
extends Node2D

## Presentation only: no physics, navigation, spawn rules or global RNG calls.
## Static draw lists live in bounded chunks; scrolling never reaches bare scenery.
const CHUNK_SIZE := 1024
const CHUNK_SCRIPT = preload("res://farm_landscape_chunk.gd")
var map_id := "horta"
var target: Node2D
var chunks: Dictionary = {}
var _last_center := Vector2i(2147483647, 2147483647)
var _last_radius := Vector2i.ZERO

func configure(id: String, player: Node2D) -> void:
	map_id = id
	target = player
	z_index = -8
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	refresh()

func _process(_delta: float) -> void:
	if is_instance_valid(target):
		refresh()

func chunk_at(point: Vector2) -> Vector2i:
	return Vector2i(floori((point.x + CHUNK_SIZE * 0.5) / CHUNK_SIZE), floori((point.y + CHUNK_SIZE * 0.5) / CHUNK_SIZE))

func refresh() -> void:
	if not is_instance_valid(target):
		return
	var camera := target.get_node_or_null("Camera2D") as Camera2D
	var zoom: Vector2 = camera.zoom if camera else Vector2.ONE
	var half_view := get_viewport_rect().size / zoom / 2.0
	var radius := Vector2i(ceili((half_view.x + CHUNK_SIZE * 0.5) / CHUNK_SIZE), ceili((half_view.y + CHUNK_SIZE * 0.5) / CHUNK_SIZE))
	var center := chunk_at(target.global_position)
	if center == _last_center and radius == _last_radius:
		return
	_last_center = center
	_last_radius = radius
	var needed: Dictionary = {}
	for y in range(center.y - radius.y, center.y + radius.y + 1):
		for x in range(center.x - radius.x, center.x + radius.x + 1):
			var key := Vector2i(x, y)
			needed[key] = true
			if not chunks.has(key):
				var chunk: Node2D = CHUNK_SCRIPT.new()
				chunk.name = "Parcel_%s_%s" % [x, y]
				chunk.position = Vector2(key) * CHUNK_SIZE
				add_child(chunk)
				chunk.build(map_id, key)
				chunks[key] = chunk
	for key in chunks.keys():
		if not needed.has(key):
			var chunk: Node = chunks[key]
			remove_child(chunk)
			chunk.queue_free()
			chunks.erase(key)

func cache_limit() -> int:
	return (2 * _last_radius.x + 1) * (2 * _last_radius.y + 1)
