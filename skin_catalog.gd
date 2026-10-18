class_name SkinCatalog
extends RefCounted

## Cosmetic palette variants preserve every original frame and silhouette.
const SHADER: Shader = preload("res://clothing_palette.gdshader")
const SKINS := {
	"original": {"name": "Roupa original", "cost": 0, "hue": 0.0},
	"colheita": {"name": "Roupa da Colheita", "cost": 250, "hue": 0.075},
	"vinho": {"name": "Roupa Vinho da Serra", "cost": 400, "hue": 0.96},
}

static func valid(character_id: String, skin_id: String) -> bool:
	return character_id in ["fazendeiro", "vovo", "netinho"] and SKINS.has(skin_id)

static func apply(sprite: CanvasItem, character_id: String, skin_id: String = "original") -> void:
	if character_id not in ["fazendeiro", "vovo", "netinho"]:
		return
	sprite.material = null
	if skin_id == "original" or not valid(character_id, skin_id):
		return
	var material := ShaderMaterial.new()
	material.shader = SHADER
	material.set_shader_parameter("source_hue", 0.60 if character_id == "fazendeiro" else 0.32)
	material.set_shader_parameter("target_hue", float(SKINS[skin_id].hue))
	sprite.material = material
