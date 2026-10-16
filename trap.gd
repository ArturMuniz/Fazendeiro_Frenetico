extends Area2D
class_name Trap

## Armadilha estacionária (ex: Cerca Elétrica): fica parada no chão
## causando dano periódico a inimigos que passarem por cima, até
## acabar sua duração.

@onready var tick_timer: Timer = $TickTimer
@onready var lifetime_timer: Timer = $LifetimeTimer

var damage: float = 2.0


func _ready() -> void:
	var sprite := $Sprite2D as Sprite2D
	sprite.texture = GameArt.ui("trap_base")
	sprite.scale = Vector2.ONE
	sprite.modulate = Color.WHITE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tick_timer.timeout.connect(_on_tick)
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(queue_free)


func configure(dmg: float, tick_interval: float, duration: float) -> void:
	damage = dmg
	tick_timer.wait_time = tick_interval
	tick_timer.start()
	lifetime_timer.wait_time = duration
	lifetime_timer.start()


func _on_tick() -> void:
	var hit_something: bool = false
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(damage)
			hit_something = true
	if hit_something:
		VisualFX.spawn(get_tree().current_scene, "electric", global_position)
		AudioManager.play_sfx("attack_ranged", 0.05)
