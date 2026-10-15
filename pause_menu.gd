extends CanvasLayer
class_name PauseMenu

## Menu de pausa: aberto pelo botão de pausa do HUD ou pela tecla
## Esc/botão voltar do Android (ação "ui_cancel").

@onready var resume_button: Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var retry_button: Button = $PanelContainer/VBoxContainer/RetryButton
@onready var hub_button: Button = $PanelContainer/VBoxContainer/HubButton


func _ready() -> void:
	hide()
	resume_button.pressed.connect(_on_resume_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	hub_button.pressed.connect(_on_hub_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			open()
		get_viewport().set_input_as_handled()


func open() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = true
	show()


func _on_resume_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	hide()


func _on_retry_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_hub_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://hub.tscn")
