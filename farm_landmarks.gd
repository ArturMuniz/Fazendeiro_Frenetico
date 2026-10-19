extends Node2D

## Unique scenery around the central combat clearing, never copied per chunk.
var props: Array[Dictionary] = []
var bounds: Array[Rect2] = []

func build(map_id: String) -> void:
	material = MapArt.chroma_material()
	var building := "barn_building" if map_id == "celeiro" else "garden_shed"
	_add(building, Vector2(-820, -650), 300 if map_id == "celeiro" else 230, true)
	for side in [-1, 1]:
		for x in [-290, 290]:
			_add("horta_cerca", Vector2(x, side * 950), 160, true)
		_add("horta_espantalho" if map_id == "horta" else "grain_sack", Vector2(side * 900, 430), 66, false)
	queue_redraw()

func _add(id: String, foot: Vector2, width: float, solid: bool) -> void:
	var texture := MapArt.sprite(id)
	var size := Vector2(width, width * texture.get_height() / texture.get_width())
	var rect := Rect2(foot - Vector2(size.x / 2, size.y), size)
	props.append({"id": id, "rect": rect, "texture": texture})
	if not solid: return
	# Fence rails and building walls have their own footprints; roofs overhang.
	var footprint := Rect2(rect.position + size * Vector2(0.12, 0.28), size * Vector2(0.76, 0.68))
	if id == "horta_cerca": footprint = Rect2(foot - Vector2(width * 0.48, 18), Vector2(width * 0.96, 18))
	bounds.append(footprint)
	var body := StaticBody2D.new()
	body.collision_layer = 8
	body.collision_mask = 0
	body.add_to_group("farm_obstacles")
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = footprint.size
	shape.shape = box
	shape.position = footprint.get_center()
	body.add_child(shape)
	add_child(body)

func _draw() -> void:
	for prop in props: draw_texture_rect(prop.texture, prop.rect, false, Color(0.86, 0.84, 0.74))
