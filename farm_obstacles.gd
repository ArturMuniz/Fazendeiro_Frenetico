class_name FarmObstacles
extends RefCounted

## A small visibility graph for the fixed peripheral landmarks. The floor streams
## independently; its decorative parcels never create duplicate physics bodies.
const CLEARANCE := 36.0
var rectangles: Array[Rect2] = []
var _graph := AStar2D.new()
var _corners: Array[Vector2] = []

func build(bounds: Array[Rect2]) -> void:
	rectangles = bounds.duplicate()
	_corners.clear()
	_graph.clear()
	for rect in rectangles:
		var expanded := rect.grow(CLEARANCE + 2)
		for point in [expanded.position, Vector2(expanded.end.x, expanded.position.y), expanded.end, Vector2(expanded.position.x, expanded.end.y)]:
			if is_clear(point, CLEARANCE): _corners.append(point)
	for i in range(_corners.size()): _graph.add_point(i + 2, _corners[i])
	for i in range(_corners.size()):
		for j in range(i + 1, _corners.size()):
			if not blocked(_corners[i], _corners[j], CLEARANCE): _graph.connect_points(i + 2, j + 2)

func is_clear(point: Vector2, radius: float = 24.0) -> bool:
	for rect in rectangles:
		if rect.grow(radius).has_point(point): return false
	return true

func blocked(from: Vector2, to: Vector2, clearance: float = CLEARANCE) -> bool:
	for bounds in rectangles:
		var rect := bounds.grow(clearance)
		if rect.has_point(from) or rect.has_point(to): return true
		var corners := [rect.position, Vector2(rect.end.x, rect.position.y), rect.end, Vector2(rect.position.x, rect.end.y)]
		for i in range(4):
			if Geometry2D.segment_intersects_segment(from, to, corners[i], corners[(i + 1) % 4]) != null: return true
	return false

func next_waypoint(from: Vector2, to: Vector2) -> Vector2:
	if not blocked(from, to): return to
	# Physical contacts can put a body just inside the routing margin. Project
	# its endpoint out of that margin so the graph still has a reachable start.
	var start := _outside(from)
	var goal := _outside(to)
	_graph.add_point(0, start)
	_graph.add_point(1, goal)
	if not blocked(start, goal): _graph.connect_points(0, 1)
	for i in range(_corners.size()):
		if not blocked(start, _corners[i]): _graph.connect_points(0, i + 2)
		if not blocked(goal, _corners[i]): _graph.connect_points(1, i + 2)
	var path := _graph.get_point_path(0, 1)
	_graph.remove_point(0)
	_graph.remove_point(1)
	if from.distance_to(start) > 4.0: return start
	for point in path:
		if from.distance_to(point) > 2.0: return point
	return goal

func _outside(point: Vector2) -> Vector2:
	for bounds in rectangles:
		var rect := bounds.grow(CLEARANCE + 1)
		if not rect.has_point(point): continue
		var options := [Vector2(rect.position.x - 1, point.y), Vector2(rect.end.x + 1, point.y), Vector2(point.x, rect.position.y - 1), Vector2(point.x, rect.end.y + 1)]
		options.sort_custom(func(a: Vector2, b: Vector2) -> bool: return point.distance_squared_to(a) < point.distance_squared_to(b))
		point = options[0]
	return point
