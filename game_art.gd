class_name GameArt
extends RefCounted

## Immutable visual catalog, shared textures; no combat data lives here.
const DATA: Dictionary = preload("res://polished_art_data.gd").DATA
const FARMER: Dictionary = preload("res://farmer_art_data.gd").DATA
const GRANDMA: Dictionary = preload("res://vovo_art_data.gd").DATA
const REFINED: Dictionary = preload("res://actor_polish_data.gd").DATA
const INTEGRATED: Dictionary = preload("res://integrated_actor_data.gd").DATA
static var _textures: Dictionary = {}

static func texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if not _textures.has(path):
		_textures[path] = load(path) as Texture2D
	return _textures[path]

static func ui(id: String) -> Texture2D:
	if id == "char_fazendeiro":
		return texture(actor("fazendeiro").idle.frames[0])
	if id == "char_vovo":
		return texture(actor("vovo").idle.frames[0])
	if id == "char_netinho":
		return texture(actor("netinho").idle.frames[0])
	return texture(DATA.ui.get(id, ""))

static func weapon(id: String, level: int) -> Texture2D:
	var key := "%s_%d" % [id, level]
	if DATA.weapons.has(key):
		return texture(DATA.weapons[key])
	var approved := "res://art/ui_rural/weapon_%s_%d.png" % [id, level]
	if ResourceLoader.exists(approved):
		return texture(approved)
	return null

static func equip(sprite: Sprite2D, id: String, level: int) -> void:
	var image := weapon(id, level)
	if image == null:
		# A generic world weapon can keep its identity across levels. UI still
		# reports the exact level and doesn't pretend an unavailable tier exists.
		image = weapon(id, 1)
	if image != null:
		sprite.texture = image
		sprite.modulate = Color.WHITE
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.scale = Vector2.ONE * minf(1.0, 40.0 / image.get_size().length())

static func actor(id: String) -> Dictionary:
	if INTEGRATED.has(id):
		return INTEGRATED[id]
	if id == "fazendeiro":
		return FARMER
	if id == "vovo":
		return GRANDMA
	if REFINED.has(id):
		return REFINED[id]
	return DATA.actors.get(id, {})
