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
var playback_speed: float = 1.0

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
	playback_speed = 1.0
	target.modulate = Color.WHITE
	target.scale = Vector2.ONE
	target.flip_h = false
	target.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var tree := Engine.get_main_loop() as SceneTree
	var save: Node = tree.root.get_node_or_null("SaveManager") if tree != null else null
	SkinCatalog.apply(target, id, save.get_equipped_skin(id) if save != null else "original")
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
	elapsed += delta * maxf(playback_speed, 0.01)
	while not finished and elapsed >= _frame_duration(data):
		elapsed -= _frame_duration(data)
		frame_index += 1
		if frame_index >= data.frames.size():
			if data.loop:
				frame_index = 0
			else:
				frame_index = data.frames.size() - 1
				finished = true
				_one_shot = false
				var ended_state := state
				completed.emit(ended_state)
				if not is_instance_valid(target):
					return
				if state != ended_state:
					return
		_apply_frame()

func _frame_duration(data: Dictionary) -> float:
	var durations: Array = data.get("durations_ms", [])
	if durations.size() == data.frames.size():
		return maxf(float(durations[frame_index]) / 1000.0, 0.001)
	return 1.0 / maxf(float(data.fps), 0.001)

func _apply_frame() -> void:
	var data: Dictionary = animations[state]
	target.texture = GameArt.texture(data.frames[frame_index])
	var offset: Array = data.get("offset", [0, 0])
	target.offset = Vector2(offset[0], offset[1])
