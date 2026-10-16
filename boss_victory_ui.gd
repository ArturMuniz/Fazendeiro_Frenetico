extends CanvasLayer
class_name BossVictoryUI

## Aparece uma vez por run, quando o boss é derrotado. Pausa o jogo e
## oferece: ir pro próximo mapa (se houver), continuar em modo livre
## (infinito) ou encerrar a run como vitória e voltar pro Hub.

signal next_map_chosen
signal continue_chosen
signal end_run_chosen
signal save_retry_requested
var _choice_committed: bool = false
var _save_error: bool = false
var _view: Dictionary

var info_label: Label
var next_button: Button
var continue_button: Button
var end_button: Button


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PanelContainer.hide()
	_view = RuralUI.shell(self, "Chefe derrotado!", "A colheita está a salvo. Escolha seu próximo passo.")
	_view.body.add_child(RuralUI.picture("victory_emblem", Vector2(160, 160)))
	info_label = RuralUI.label("", 28)
	_view.body.add_child(info_label)
	next_button = RuralUI.button("Próximo mapa", _on_next_pressed)
	continue_button = RuralUI.button("Continuar no modo livre", _on_continue_pressed)
	end_button = RuralUI.button("Encerrar e ver resultado", _on_end_pressed)
	for button in [next_button, continue_button, end_button]:
		button.custom_minimum_size.y = 88
		_view.footer.add_child(button)
	next_button.visible = false
	PauseManager.acquire(self, &"victory")


## Chamado logo após add_child. next_map_name vazio = não há próximo mapa.
func configure(next_map_name: String, reward: int = 0) -> void:
	_save_error = false
	_choice_committed = false
	continue_button.show()
	end_button.text = "Encerrar e ver resultado"
	next_button.visible = next_map_name != ""
	if next_map_name != "":
		next_button.visible = true
		next_button.text = "Próximo mapa: %s" % next_map_name
		info_label.text = "O próximo mapa foi liberado. Siga a campanha, continue no modo livre ou encerre a run com essa vitória."
	else:
		info_label.text = "Você zerou a campanha! Continue no modo livre ou encerre a run com essa vitória."

	info_label.text += "\n\nBônus de vitória salvo: %d ouro\n%s\n\nPróximo mapa: a build recomeça.\nModo livre: mantenha sua build; a dificuldade continua aumentando." % [reward, "Inclui +100 pela primeira conclusão." if reward == 150 else "Saldo permanente: %d" % SaveManager.gold]


func _on_next_pressed() -> void:
	_finish(next_map_chosen)


func _on_continue_pressed() -> void:
	_finish(continue_chosen)


func _on_end_pressed() -> void:
	if not PauseManager.is_active(self):
		return
	if _save_error:
		save_retry_requested.emit()
		return
	_finish(end_run_chosen)


func show_save_error() -> void:
	_save_error = true
	next_button.hide()
	continue_button.hide()
	info_label.text = "Não foi possível salvar sua vitória. Seu prêmio será confirmado antes de continuar."
	end_button.text = "Tentar salvar novamente"


func _finish(chosen: Signal) -> void:
	if _choice_committed or not PauseManager.is_active(self):
		return
	_choice_committed = true
	AudioManager.play_sfx("button")
	chosen.emit()
	hide()
	PauseManager.release(self)
	queue_free()
