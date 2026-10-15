extends Node2D
class_name DamageNumber

## Número de dano que sobe e some rapidamente em cima do inimigo que
## foi atingido. Reaproveitado via Pool (é o objeto mais criado no
## jogo, cada hit de cada arma gera um).

const SELF_SCENE: PackedScene = preload("res://damage_number.tscn")

@onready var label: Label = $Label

var _elapsed: float = 0.0
var _duration: float = 0.55
var _rise_distance: float = 26.0
var _start_pos: Vector2 = Vector2.ZERO
var _despawning: bool = false


## Chamado pelo que causou o dano (ex: Enemy.take_damage).
func show_value(amount: float, world_pos: Vector2) -> void:
	_start_pos = world_pos + Vector2(randf_range(-8.0, 8.0), -6.0)
	global_position = _start_pos
	label.text = str(int(round(amount)))
	label.modulate = Color(1, 1, 1, 1)
	_elapsed = 0.0
	_despawning = false
	visible = true
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	_elapsed += delta
	var t: float = _elapsed / _duration
	if t >= 1.0:
		_despawn()
		return
	global_position = _start_pos + Vector2(0, -_rise_distance * t)
	label.modulate.a = 1.0 - t


func _despawn() -> void:
	if _despawning:
		return
	_despawning = true
	set_physics_process(false)
	visible = false
	call_deferred("_return_to_pool")


func _return_to_pool() -> void:
	if get_parent() != null:
		get_parent().remove_child(self)
	Pool.release(SELF_SCENE, self)
