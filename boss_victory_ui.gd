extends CanvasLayer
class_name BossVictoryUI

## Aparece uma vez por run, quando o boss é derrotado. Pausa o jogo e
## oferece: ir pro próximo mapa (se houver), continuar em modo livre
## (infinito) ou encerrar a run como vitória e voltar pro Hub.

signal next_map_chosen
signal continue_chosen
signal end_run_chosen

@onready var info_label: Label = $PanelContainer/VBoxContainer/InfoLabel
@onready var next_button: Button = $PanelContainer/VBoxContainer/ButtonColumn/NextButton
@onready var continue_button: Button = $PanelContainer/VBoxContainer/ButtonColumn/ContinueButton
@onready var end_button: Button = $PanelContainer/VBoxContainer/ButtonColumn/EndButton


func _ready() -> void:
	next_button.pressed.connect(_on_next_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	end_button.pressed.connect(_on_end_pressed)
	next_button.visible = false
	get_tree().paused = true
	show()


## Chamado logo após add_child. next_map_name vazio = não há próximo mapa.
func configure(next_map_name: String) -> void:
	if next_map_name != "":
		next_button.visible = true
		next_button.text = "Próximo mapa: %s" % next_map_name
		info_label.text = "O próximo mapa foi liberado. Siga a campanha, continue no modo livre ou encerre a run com essa vitória."
	else:
		info_label.text = "Você zerou a campanha! Continue no modo livre ou encerre a run com essa vitória."


func _on_next_pressed() -> void:
	_finish(next_map_chosen)


func _on_continue_pressed() -> void:
	_finish(continue_chosen)


func _on_end_pressed() -> void:
	_finish(end_run_chosen)


func _finish(chosen: Signal) -> void:
	AudioManager.play_sfx("button")
	get_tree().paused = false
	chosen.emit()
	queue_free()
