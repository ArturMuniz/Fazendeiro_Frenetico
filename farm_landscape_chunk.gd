extends Node2D

## A parcel is a cached canvas drawing, never an obstacle. Actors always draw above it.
const GRASS = preload("res://art/polished/ground_horta.png")
const WOOD = preload("res://art/polished/ground_celeiro.png")
const DIRT = preload("res://art/tile_pomar.png")
const AREA := Rect2(-512, -512, 1024, 1024)
var map_id := ""
var coordinate := Vector2i.ZERO
var floor_commands: Array[Dictionary] = []
var props: Array[Dictionary] = []
var _rng := RandomNumberGenerator.new()

func build(id: String, cell: Vector2i) -> void:
	map_id = id
	coordinate = cell
	_rng.seed = (id + ":" + str(cell.x) + ":" + str(cell.y)).hash()
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	material = MapArt.chroma_material()
	floor_commands.clear()
	props.clear()
	match id:
		"horta": _garden()
		"celeiro": _barnyard()
		"pomar": _orchard()
	props.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.foot.y < b.foot.y)
	queue_redraw()

func _rect(rect: Rect2, color: Color, texture: Texture2D = null, tiled: bool = false) -> void:
	floor_commands.append({"kind":"rect", "rect":rect, "color":color, "texture":texture, "tile":tiled})

func _poly(points: PackedVector2Array, color: Color) -> void:
	floor_commands.append({"kind":"poly", "points":points, "color":color})

func _stroke(from: Vector2, to: Vector2, color: Color, width: float = 2) -> void:
	floor_commands.append({"kind":"line", "from":from, "to":to, "color":color, "width":width})

func _prop(id: String, foot: Vector2, width: float, tint := Color(0.82, 0.84, 0.75)) -> void:
	# Architecture belongs to unique edge landmarks, never repeating floor tiles.
	if id in ["garden_shed", "barn_building", "horta_cerca"]: return
	if id in ["apple_tree", "orange_tree", "hay_stack", "horta_espantalho"]:
		if absf((position + foot).x) < 400 and absf((position + foot).y) < 600: return
	# Keep the initial attack/readability area clear. This never tests physics.
	if (position + foot).length() < 150:
		return
	var texture := MapArt.sprite(id)
	var size := Vector2(width, width * texture.get_height() / texture.get_width())
	props.append({"id":id,"foot":foot,"rect":Rect2((foot - Vector2(size.x / 2, size.y)).round(),size.round()),"texture":texture,"color":tint})

func _base(color: Color, grain: float) -> void:
	_rect(AREA, color)
	_rect(AREA, Color(0.84,0.82,0.66,grain), GRASS, true)
	# Quiet colour islands break the repeated texture; no high-contrast false loot.
	for i in range(14):
		var origin := Vector2(_rng.randi_range(-480,360),_rng.randi_range(-480,360))
		var rect := Rect2(origin,Vector2(_rng.randi_range(70,140),_rng.randi_range(40,90)))
		_patch(rect, Color(color.r * 0.94,color.g * 0.97,color.b * 0.91,0.35))
	for i in range(100):
		var p := Vector2(_rng.randi_range(-508,504),_rng.randi_range(-508,504))
		_rect(Rect2(p,Vector2(2,4)), Color(0.23,0.30,0.15,0.18))
		_rect(Rect2(p + Vector2(3,-2),Vector2(2,5)), Color(0.75,0.77,0.43,0.13))

func _patch(rect: Rect2, color: Color) -> void:
	var p := rect.position
	var s := rect.size
	var cut := 8.0
	_poly(PackedVector2Array([p+Vector2(cut,0),p+Vector2(s.x-cut,0),p+Vector2(s.x-cut,4),p+Vector2(s.x,4),p+Vector2(s.x,s.y-cut),p+Vector2(s.x-6,s.y-cut),p+Vector2(s.x-6,s.y),p+Vector2(6,s.y),p+Vector2(6,s.y-4),p+Vector2(0,s.y-4),p+Vector2(0,cut),p+Vector2(cut,cut)]),color)

func _paths(color: Color, width := 152.0) -> void:
	# Continuous global samples line up exactly at chunk boundaries.
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for y in range(-512,513,16):
		var world_y := position.y + y
		var bend := snappedf(sin(world_y / 620.0) * 26.0, 4.0)
		left.append(Vector2(bend-width/2+snappedf(sin(world_y/47)*5,2),y))
		right.append(Vector2(bend+width/2+snappedf(sin(world_y/61)*6,2),y))
	right.reverse()
	left.append_array(right)
	_road(left,color)
	var top := PackedVector2Array()
	var bottom := PackedVector2Array()
	for x in range(-512,513,16):
		var bend := snappedf(sin((position.x+x)/720.0)*16,4)
		top.append(Vector2(x,bend-52+snappedf(sin((position.x+x)/51)*5,2)))
		bottom.append(Vector2(x,bend+52+snappedf(sin((position.x+x)/79)*6,2)))
	bottom.reverse()
	top.append_array(bottom)
	_road(top,color)
	for i in range(38):
		var y := _rng.randi_range(-502,502)
		var x := _rng.randi_range(-55,55) + snappedf(sin((position.y+y)/620.0)*26,4)
		_rect(Rect2(x,y,3,2),Color(0.45,0.34,0.22,0.16))

func _road(points: PackedVector2Array, color: Color) -> void:
	_poly(points,color)
	var uvs := PackedVector2Array()
	for p in points:
		uvs.append((p+position)/128.0)
	floor_commands.append({"kind":"texture_poly","points":points,"uvs":uvs,"texture":DIRT,"color":Color(1,0.95,0.82,0.35)})

func _garden() -> void:
	_base(Color("718152"),0.48)
	_paths(Color("aa8c60"))
	for row in [-1,1]:
		for col in [-1,1]:
			var center := Vector2(col*266+_rng.randi_range(-14,14),row*258+_rng.randi_range(-22,22))
			if row == -1 and col == 1 and (coordinate == Vector2i.ZERO or posmod(coordinate.x*7+coordinate.y*3,5) == 0):
				_patch(Rect2(center-Vector2(112,60),Vector2(230,164)),Color(0.55,0.45,0.29,0.48))
				_prop("garden_shed",center+Vector2(0,40),184,Color(0.86,0.85,0.75))
				_prop("celeiro_barril",center+Vector2(95,75),35)
				_prop("cabbage_bed",center+Vector2(-65,96),60)
				continue
			_bed(center, (col+row+coordinate.x+coordinate.y) % 3 == 0)
	for side in [-1,1]:
		_prop("horta_espantalho",Vector2(side*402,92),64)
		_prop("bush",Vector2(side*426,-405),76,Color(0.79,0.83,0.66))
		_prop("bush",Vector2(side*455,400),58)
		if side == 1:
			for x in [-342,-246,246,342]:
				_prop("horta_cerca",Vector2(x,435),92,Color(0.83,0.77,0.62))
	_prop("celeiro_barril",Vector2(-425,-40),40)
	_prop("celeiro_caixa",Vector2(430,235),42)

func _bed(center: Vector2, cabbages: bool) -> void:
	var rect := Rect2(center-Vector2(110,78),Vector2(220,156))
	_patch(rect.grow(3),Color("5a5035"))
	_patch(rect,Color("816344"))
	for i in range(4):
		var y := rect.position.y+18+i*36
		_rect(Rect2(rect.position.x+12,y,196,6),Color("725237"))
		_rect(Rect2(rect.position.x+12,y+7,196,2),Color(0.7,0.53,0.33,0.35))
	if cabbages:
		for y in range(3):
			for x in range(5):
				_prop("cabbage",center+Vector2(-78+x*39,-40+y*43),28,Color(0.80,0.84,0.64))
	else:
		for y in range(2):
			for x in range(2):
				_prop("carrot_bed",center+Vector2(-50+x*100,-22+y*65),94,Color(0.91,0.88,0.75))

func _barnyard() -> void:
	_base(Color("8a7954"),0.16)
	_paths(Color("a38a60"),176)
	for y in range(-512,512,40):
		for x in [-36,36]:
			_rect(Rect2(x,y,3,24),Color(0.37,0.30,0.19,0.15))
	for y in [-258,258]:
		for x in [-294,294]:
			var origin := Vector2(x+_rng.randi_range(-12,12),y+_rng.randi_range(-16,16))
			_patch(Rect2(origin-Vector2(112,86),Vector2(224,172)),Color("736343"))
			_rect(Rect2(origin-Vector2(104,76),Vector2(208,148)),Color(0.95,0.81,0.60,0.72),WOOD,true)
			_straw(Rect2(origin-Vector2(98,68),Vector2(192,130)),34)
			if y < 0 and x < 0 and (coordinate == Vector2i.ZERO or posmod(coordinate.x*3+coordinate.y*7,4) == 0):
				_prop("barn_building",origin+Vector2(0,64),276,Color(0.86,0.84,0.74))
				_prop("grain_sack",origin+Vector2(-90,78),38)
			else:
				var kind: int = posmod(coordinate.x+coordinate.y+(1 if x < 0 else 0)+(2 if y > 0 else 0),3)
				if kind == 0:
					_prop("hay_stack",origin+Vector2(-36,15),110,Color(0.86,0.80,0.64))
					_prop("celeiro_feno",origin+Vector2(53,48),64,Color(0.90,0.83,0.65))
					_prop("grain_sack",origin+Vector2(75,-50),42)
					_prop("celeiro_barril",origin+Vector2(-74,65),42)
					_prop("celeiro_caixa",origin+Vector2(-38,76),46)
				elif kind == 1:
					_prop("celeiro_caixa",origin+Vector2(-58,4),58)
					_prop("celeiro_caixa",origin+Vector2(-14,-24),52)
					_prop("celeiro_caixa",origin+Vector2(34,20),44)
					_prop("celeiro_barril",origin+Vector2(-51,67),44)
					_prop("celeiro_barril",origin+Vector2(66,55),40)
					_prop("celeiro_roda",origin+Vector2(72,-25),54)
				else:
					_prop("hay_stack",origin+Vector2(40,-5),102,Color(0.85,0.80,0.66))
					for p in [Vector2(-68,-40),Vector2(-29,-36),Vector2(-64,19),Vector2(-24,55)]:
						_prop("grain_sack",origin+p,39,Color(0.88,0.84,0.70))
					_prop("celeiro_feno",origin+Vector2(56,64),52)
	for x in [-1,1]:
		_prop("celeiro_roda",Vector2(x*440,0),60)
		_prop("grain_sack",Vector2(x*408,78),38)
		_prop("horta_cerca",Vector2(x*340,445),126,Color(0.74,0.67,0.52))
	_straw(Rect2(-105,-490,210,980),55)

func _straw(rect: Rect2, amount: int) -> void:
	for i in range(amount):
		var p := rect.position + Vector2(_rng.randf()*rect.size.x,_rng.randf()*rect.size.y)
		_stroke(p,p+Vector2(4+_rng.randi_range(0,3),-2),Color(0.82,0.65,0.31,0.35),1)

func _orchard() -> void:
	_base(Color("7b8157"),0.32)
	_paths(Color("ac9065"),166)
	for side in [-1,1]:
		for row in [-1,0,1]:
			var p := Vector2(side*270+_rng.randi_range(-12,12),row*308+50)
			_patch(Rect2(p-Vector2(90,30),Vector2(180,62)),Color(0.35,0.33,0.19,0.22))
			_prop("pomar_folhas",p+Vector2(32,18),76,Color(0.82,0.72,0.48,0.60))
			var id := "orange_tree" if (coordinate.x+coordinate.y+row+side) % 3 == 0 else "apple_tree"
			_prop(id,p,154,Color(0.79,0.80,0.65,0.92))
			_prop("pomar_cesto",p+Vector2(78,45),38,Color(0.78,0.73,0.56))
			if row == -1 and side == 1:
				_prop("pomar_escada",p+Vector2(-77,12),36)
		_prop("golden_bush",Vector2(-437,110),72,Color(0.82,0.77,0.61))
	_prop("bush",Vector2(442,-65),72,Color(0.80,0.80,0.63))
	for x in [-352,-244,244,352]:
		_prop("horta_cerca",Vector2(x,440),96,Color(0.85,0.76,0.59))
	for i in range(18):
		var p := Vector2(_rng.randi_range(-440,440),_rng.randi_range(-440,440))
		if absf(p.x) > 140 and absf(p.y) > 100:
			_prop("pomar_folhas",p,20+_rng.randi_range(0,12),Color(0.74,0.68,0.46,0.50))

func _draw() -> void:
	for command in floor_commands:
		match command.kind:
			"rect":
				if command.texture:
					draw_texture_rect(command.texture,command.rect,command.tile,command.color)
				else:
					draw_rect(command.rect,command.color)
			"poly": draw_colored_polygon(command.points,command.color)
			"texture_poly": draw_polygon(command.points,PackedColorArray([command.color]),command.uvs,command.texture)
			"line": draw_line(command.from,command.to,command.color,command.width,false)
	for prop in props:
		draw_texture_rect(prop.texture,prop.rect,false,prop.color)
