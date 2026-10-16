extends Area2D
class_name XPOrb

## Orbe de XP solto por inimigos ao morrer. Fica parado até o jogador
## entrar no raio de coleta (ímã), depois voa até ele.

@export var xp_value: int = 1
@export var pickup_speed: float = 300.0

var _player: Node2D
var _following: bool = false
var _collected: bool = false


func _ready() -> void:
	var sprite := $Sprite2D as Sprite2D
	sprite.texture = GameArt.ui("pickup_xp")
	sprite.modulate = Color.WHITE
	sprite.scale = Vector2.ONE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_to_group("xp_orbs")
	_player = get_tree().get_first_node_in_group("player")
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")
		return

	var radius: float = 80.0
	if "magnet_radius" in _player:
		radius = _player.magnet_radius

	if not _following:
		var dist: float = global_position.distance_to(_player.global_position)
		if dist <= radius:
			_following = true

	if _following:
		var direction: Vector2 = (_player.global_position - global_position).normalized()
		global_position += direction * pickup_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if _collected:
		return
	if body.is_in_group("player") and body.has_method("add_xp"):
		_collected = true
		AudioManager.play_sfx("pickup")
		body.add_xp(xp_value)
		queue_free()


## Usado pelo efeito de nível 3 do Ímã de Geladeira: coleta o orbe
## imediatamente, não importa a distância do jogador.
func collect_instantly() -> void:
	if _collected:
		return
	_collected = true
	AudioManager.play_sfx("pickup", 0.15)
	if _player != null and _player.has_method("add_xp"):
		_player.add_xp(xp_value)
	queue_free()
