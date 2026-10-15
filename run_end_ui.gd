extends CanvasLayer
class_name RunEndUI

## Tela de fim de run: mostra um resumo da run (tempo, nível, abates,
## se derrotou o boss, moedas ganhas) e deixa jogar de novo direto
## ou voltar pro Hub.

@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel
@onready var stats_label: Label = $PanelContainer/VBoxContainer/StatsLabel
@onready var retry_button: Button = $PanelContainer/VBoxContainer/ButtonRow/RetryButton
@onready var hub_button: Button = $PanelContainer/VBoxContainer/ButtonRow/HubButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	hub_button.pressed.connect(_on_hub_pressed)


func show_results(stats: Dictionary) -> void:
	title_label.text = "Vitória!" if stats.get("victory", false) else "Fim de run!"
	var boss_text: String = "Sim" if stats.get("boss_defeated", false) else "Não"
	stats_label.text = "Tempo sobrevivido: %s\nNível alcançado: %d\nInimigos derrotados: %d\nBoss derrotado: %s\n\nMoedas ganhas: %d" % [
		_format_time(stats.get("survival_time", 0.0)),
		stats.get("level", 1),
		stats.get("kills", 0),
		boss_text,
		stats.get("gold_earned", 0),
	]
	get_tree().paused = true
	show()


func _format_time(seconds: float) -> String:
	var total: int = int(seconds)
	var minutes: int = total / 60
	var secs: int = total % 60
	return "%d:%02d" % [minutes, secs]


func _on_retry_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_hub_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://hub.tscn")
