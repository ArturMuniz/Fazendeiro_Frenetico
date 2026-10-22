class_name FarmLandscape
extends Node2D

## One bounded, approved arena per run. No procedural repetition or streaming.
var map_id := "horta"
var target: Node2D
var landmarks: Node2D
var obstacles := FarmObstacles.new()
var play_bounds := Rect2()
var boundary_rects: Array[Rect2] = []
var plate: Sprite2D

func configure(id: String, player: Node2D) -> void:
	map_id = id if ArenaMaps.DATA.has(id) else "horta"
	target = player
	z_index = -8
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var data: Dictionary = ArenaMaps.DATA[map_id]
	play_bounds = data.bounds
	plate = Sprite2D.new()
	plate.name = "ApprovedArena"
	plate.texture = load(data.texture) as Texture2D
	plate.scale = ArenaMaps.WORLD_SIZE / plate.texture.get_size()
	plate.modulate = Color(0.86, 0.86, 0.86)
	add_child(plate)
	landmarks = Node2D.new()
	landmarks.name = "Boundaries"
	add_child(landmarks)
	var start := play_bounds.position
	var end := play_bounds.end
	var thickness := 96.0
	boundary_rects.assign([
		Rect2(start - Vector2(thickness,thickness), Vector2(play_bounds.size.x+thickness*2,thickness)),
		Rect2(Vector2(start.x-thickness,end.y), Vector2(play_bounds.size.x+thickness*2,thickness)),
		Rect2(start-Vector2(thickness,0), Vector2(thickness,play_bounds.size.y)),
		Rect2(Vector2(end.x,start.y), Vector2(thickness,play_bounds.size.y)),
	])
	for index in range(boundary_rects.size()):
		var rect := boundary_rects[index]
		var body := StaticBody2D.new()
		body.name = ["North", "South", "West", "East"][index]
		body.collision_layer = 8
		body.collision_mask = 0
		body.position = rect.get_center()
		body.add_to_group("farm_obstacles")
		var collider := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		collider.shape = shape
		body.add_child(collider)
		landmarks.add_child(body)
	obstacles.build(boundary_rects, play_bounds)
	get_viewport().size_changed.connect(refresh)
	refresh()

func refresh() -> void:
	if not is_instance_valid(target): return
	var camera := target.get_node_or_null("Camera2D") as Camera2D
	if camera == null: return
	var view := get_viewport_rect().size
	# Very tall screens, tablets and window resizing must never reveal void.
	var zoom := maxf(1.35, maxf(view.x/ArenaMaps.WORLD_SIZE.x, view.y/ArenaMaps.WORLD_SIZE.y))
	camera.zoom = Vector2.ONE * zoom
	camera.limit_left = -1024
	camera.limit_right = 1024
	camera.limit_top = -768
	camera.limit_bottom = 768
	camera.position_smoothing_enabled = false
	camera.reset_smoothing()

func clamp_point(point: Vector2, clearance: float = 40) -> Vector2:
	var inner := play_bounds.grow(-clearance)
	return point.clamp(inner.position, inner.end - Vector2.ONE * 0.01)

func spawn_point(origin: Vector2, radius: float) -> Vector2:
	var minimum := minf(220, radius * 0.55)
	for attempt in range(24):
		var candidate := clamp_point(origin + Vector2.from_angle(randf()*TAU) * radius, 48)
		if candidate.distance_to(origin) >= minimum and obstacles.is_clear(candidate, 40):
			return candidate
	# Bounded fallback: no unbounded search beyond the farm or behind a wall.
	var inner := play_bounds.grow(-48)
	var choices: Array[Vector2] = [inner.position, inner.end, Vector2(inner.end.x,inner.position.y), Vector2(inner.position.x,inner.end.y)]
	choices.sort_custom(func(a: Vector2,b: Vector2) -> bool: return a.distance_squared_to(origin)>b.distance_squared_to(origin))
	return choices[0]
