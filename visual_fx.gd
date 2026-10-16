class_name VisualFX
extends Node2D

## Short-lived, collision-free visual. Deaths never retain a pooled enemy.
static func spawn(parent: Node, kind: String, where: Vector2, flip: bool = false, actor_id: String = "") -> VisualFX:
	if not is_instance_valid(parent) or parent.get_tree() == null:
		return null
	if parent.get_tree().get_nodes_in_group("visual_fx").size() >= 40:
		return null
	var data: Dictionary
	if actor_id != "" and GameArt.actor(actor_id).has("death"):
		data = GameArt.actor(actor_id).death
	else:
		data = GameArt.DATA.effects.get(kind, {})
	if data.is_empty():
		return null
	var fx := VisualFX.new()
	var sprite := Sprite2D.new()
	fx.add_child(sprite)
	var animator := SpriteAnimator.new()
	fx.add_child(animator)
	animator.configure("fx", sprite, {"effect": data})
	sprite.flip_h = flip
	fx.position = where
	fx.z_index = 3
	fx.add_to_group("visual_fx")
	animator.completed.connect(func(_state: String) -> void: fx.queue_free())
	# Pure drawing nodes are safe during physics callbacks. Immediate insertion
	# also counts this effect toward the cap and cannot orphan a deferred add.
	parent.add_child(fx)
	return fx
