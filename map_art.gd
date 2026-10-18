class_name MapArt
extends RefCounted

## Original sheets copied intact; atlas regions exclude neighbours and labels.
## Their magenta key is removed by map_chroma.gdshader only during rendering.
const REGIONS: Dictionary = {
	"carrot_bed": ["garden_sheet", Rect2(8, 720, 325, 240)],
	"cabbage_bed": ["garden_sheet", Rect2(340, 720, 350, 240)],
	"bush": ["garden_sheet", Rect2(695, 75, 315, 285)],
	"cabbage": ["cabbage_sheet", Rect2(315, 345, 395, 335)],
	"apple_tree": ["orchard_sheet", Rect2(12, 48, 340, 395)],
	"orange_tree": ["orchard_sheet", Rect2(360, 48, 330, 395)],
	"golden_bush": ["orchard_sheet", Rect2(700, 190, 315, 245)],
	"hay_stack": ["barn_sheet", Rect2(345, 35, 390, 365)],
	"grain_sack": ["barn_sheet", Rect2(400, 430, 260, 325)],
}
static var _textures: Dictionary = {}
static var _material: ShaderMaterial

static func chroma_material() -> ShaderMaterial:
	if not _material:
		_material = ShaderMaterial.new()
		_material.shader = preload("res://map_chroma.gdshader")
	return _material

static func sprite(id: String) -> Texture2D:
	if _textures.has(id):
		return _textures[id]
	if REGIONS.has(id):
		var spec: Array = REGIONS[id]
		var atlas := AtlasTexture.new()
		atlas.atlas = load("res://art/mapa_rural/%s.jpg" % spec[0])
		atlas.region = spec[1]
		atlas.filter_clip = true
		_textures[id] = atlas
	elif id in ["barn_building", "garden_shed"]:
		var atlas := AtlasTexture.new()
		atlas.atlas = load("res://art/mapa_rural/%s.png" % id)
		atlas.region = Rect2(59,50,1208,1117) if id == "barn_building" else Rect2(174,174,1008,1003)
		atlas.filter_clip = true
		_textures[id] = atlas
	elif GameArt.DATA.props.has(id):
		_textures[id] = GameArt.texture(GameArt.DATA.props[id])
	else:
		push_error("Unknown map art: " + id)
		return null
	return _textures[id]
