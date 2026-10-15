extends CanvasLayer
class_name HUD

## Interface de status: barra de vida do personagem, atualizada a
## cada frame (mais simples do que criar um sinal pra cada lugar
## que muda a vida — dano, cura, passivos, etc).

@export var player_path: NodePath

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthBar/HealthLabel
@onready var xp_bar: ProgressBar = $XPBar
@onready var xp_label: Label = $XPBar/XPLabel
@onready var phase_label: Label = $PhaseLabel
@onready var banner_label: Label = $BannerLabel

var _player: Player


func _ready() -> void:
	_player = get_node(player_path)


func _process(_delta: float) -> void:
	if _player == null:
		return
	health_bar.max_value = _player.max_health
	health_bar.value = _player.health
	health_label.text = "%d / %d" % [ceil(_player.health), int(_player.max_health)]

	xp_bar.max_value = _player.xp_to_next
	xp_bar.value = _player.xp
	xp_label.text = "Nível %d" % _player.level


## Atualiza o indicador de fase e mostra um aviso grande que some sozinho.
## total <= 0 (ex: Modo Livre) mostra só o nome.
func show_phase(label: String, number: int, total: int) -> void:
	phase_label.text = label if total <= 0 else "%s (%d/%d)" % [label, number, total]
	banner_label.text = label
	banner_label.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_interval(1.2)
	tween.tween_property(banner_label, "modulate:a", 0.0, 0.8)
