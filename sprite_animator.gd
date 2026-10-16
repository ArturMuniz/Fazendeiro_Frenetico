class_name SpriteAnimator
extends Node

## Runs in the owner's process mode, so gameplay animation obeys modal pause.
## Sprite canvas/offset never affects collision. configure() resets pooled state.
signal completed(state: String)
var target: Sprite2D
var animations: Dictionary = {}
var state: String = ""
var frame_index: int = 0
var elapsed: float = 0.0
var finished: bool = false
var _one_shot: bool = false
var _flash: float = 0.0
var entity_id: String = ""

func configure(id: String, sprite: Sprite2D, custom: Dictionary = {}) -> void:
	entity_id = id
	target = sprite
	animations = custom if not custom.is_empty() else GameArt.actor(id)
	state = ""
	frame_index = 0
	elapsed = 0
	finished = false
	_one_shot = false
	_flash = 0
	target.modulate = Color.WHITE
	target.scale = Vector2.ONE
	target.flip_h = false
	target.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	play("idle" if animations.has("idle") else str(animations.keys()[0]))

func play(next: String, force: bool = false) -> void:
	if not animations.has(next) or (not force and (_one_shot or state == next)):
		return
	state = next
	frame_index = 0
	elapsed = 0
	finished = false
	_one_shot = false
	_apply_frame()

func once(next: String) -> void:
	if not animations.has(next):
		return
	play(next, true)
	_one_shot = true

func flash() -> void:
	_flash = 0.09

func _process(delta: float) -> void:
	if not is_instance_valid(target) or not animations.has(state):
		return
	_flash = maxf(0, _flash - delta)
	target.modulate = Color(1.35, 0.85, 0.65) if _flash > 0 else Color.WHITE
	if finished:
		return
	var data: Dictionary = animations[state]
	var frame_time: float = 1.0 / float(data.fps)
	elapsed += delta
	while elapsed >= frame_time and not finished:
		elapsed -= frame_time
		frame_index += 1
		if frame_index >= data.frames.size():
			if data.loop:
				frame_index = 0
			else:
				frame_index = data.frames.size() - 1
				finished = true
				_one_shot = false
				completed.emit(state)
				if not is_instance_valid(target):
					return
		_apply_frame()

func _apply_frame() -> void:
	var data: Dictionary = animations[state]
	target.texture = GameArt.texture(data.frames[frame_index])
	var offset: Array = data.get("offset", [0, 0])
	target.offset = Vector2(offset[0], offset[1])
