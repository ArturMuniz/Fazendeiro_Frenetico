extends CanvasLayer
class_name PauseMenu

## Menu de pausa: aberto pelo botão de pausa do HUD ou pela tecla
## Esc/botão voltar do Android (ação "ui_cancel").

var resume_button: Button
var retry_button: Button
var hub_button: Button
var _view: Dictionary
var _confirming: String = ""
var _tab: String = "Equipamento"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	$PanelContainer.hide()
	_view = RuralUI.shell(self, "Pausado", "Sua build, suas escolhas. O campo pode esperar.")
	resume_button = RuralUI.button("Continuar", _on_resume_pressed)
	retry_button = RuralUI.button("Reiniciar partida", _request_exit.bind("retry"))
	hub_button = RuralUI.button("Voltar ao Hub", _request_exit.bind("hub"))
	_view.footer.add_child(resume_button)
	var row := HBoxContainer.new()
	_view.footer.add_child(row)
	row.add_child(retry_button)
	row.add_child(hub_button)

func _populate_inventory() -> void:
	_confirming = ""
	RuralUI.clear(_view.body)
	var player: Node = get_tree().get_first_node_in_group("player")
	if player != null:
		_view.subtitle.text = "%s · Nível %d · Ouro salvo: %d" % [MapDB.MAPS[SaveManager.selected_map].name, player.level, SaveManager.gold]
		var summary := RuralUI.card(_view.body)
		var row := HBoxContainer.new()
		summary.add_child(row)
		RuralUI.actor_preview(row, SaveManager.selected_character, "", Vector2(116, 128))
		var text := RuralUI.label("%s\nVida %d / %d · %d abates\n%s" % [CharacterDB.CHARACTERS[SaveManager.selected_character].name, ceili(player.health), int(player.max_health), player.kills, SkinCatalog.SKINS[SaveManager.get_equipped_skin(SaveManager.selected_character)].name], 23)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
		var tabs := HBoxContainer.new()
		_view.body.add_child(tabs)
		for tab in ["Equipamento", "Atributos"]:
			var button := RuralUI.button(tab, _select_tab.bind(tab))
			button.disabled = tab == _tab
			tabs.add_child(button)
		if _tab == "Equipamento":
			RuralUI.inventory(_view.body, player)
		else:
			RuralUI.attributes(_view.body, player)

func _select_tab(tab: String) -> void:
	_tab = tab
	_populate_inventory()

func _request_exit(destination: String) -> void:
	if not PauseManager.is_active(self):
		return
	_confirming = destination
	RuralUI.clear(_view.body)
	_view.body.add_child(RuralUI.label("Encerrar esta tentativa?", 32))
	_view.body.add_child(RuralUI.label("A build atual será perdida. Bônus de vitória já salvos permanecem no seu saldo; a parcela ainda não liquidada desta run não será recebida.", 26))
	_view.body.add_child(RuralUI.button("Cancelar", _populate_inventory))
	_view.body.add_child(RuralUI.button("Reiniciar agora" if destination == "retry" else "Encerrar e voltar ao Hub", _confirm_exit))

func _confirm_exit() -> void:
	if _confirming == "retry":
		_on_retry_pressed()
	elif _confirming == "hub":
		_on_hub_pressed()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			open()
		get_viewport().set_input_as_handled()


func open() -> void:
	if visible or not PauseManager.can_open_pause_menu():
		return
	AudioManager.play_sfx("button")
	_populate_inventory()
	PauseManager.acquire(self, &"pause")
	RuralUI.present(_view.root)


func _on_resume_pressed() -> void:
	if not PauseManager.is_active(self):
		return
	AudioManager.play_sfx("button")
	hide()
	PauseManager.release(self)


func _on_retry_pressed() -> void:
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://main.tscn")


func _on_hub_pressed() -> void:
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://hub.tscn")
