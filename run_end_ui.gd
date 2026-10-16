extends CanvasLayer
class_name RunEndUI
signal save_retry_requested
var _save_failed: bool = false
var _view: Dictionary
var _inventory: VBoxContainer
var _death_preview: SpriteAnimator
var _result_emblem: TextureRect

## Tela de fim de run: mostra um resumo da run (tempo, nível, abates,
## se derrotou o boss, moedas ganhas) e deixa jogar de novo direto
## ou voltar pro Hub.

var title_label: Label
var stats_label: Label
var retry_button: Button
var hub_button: Button


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PanelContainer.hide()
	_view = RuralUI.shell(self, "Fim da partida", "Cada tentativa fortalece sua fazenda.")
	title_label = _view.title
	stats_label = RuralUI.label("", 28)
	var preview := Control.new()
	preview.custom_minimum_size.y = 144
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_view.body.add_child(preview)
	var figure := Sprite2D.new()
	figure.position = Vector2(60, 96)
	preview.add_child(figure)
	_death_preview = SpriteAnimator.new()
	preview.add_child(_death_preview)
	_death_preview.configure(SaveManager.selected_character, figure)
	figure.scale = Vector2.ONE * 1.5
	_result_emblem = RuralUI.picture("defeat_emblem", Vector2(80, 80))
	_result_emblem.position = Vector2(140, 24)
	preview.add_child(_result_emblem)
	_view.body.add_child(stats_label)
	_inventory = VBoxContainer.new()
	_view.body.add_child(_inventory)
	retry_button = RuralUI.button("Jogar novamente", _on_retry_pressed)
	hub_button = RuralUI.button("Voltar ao Hub", _on_hub_pressed)
	_view.footer.add_child(retry_button)
	_view.footer.add_child(hub_button)


func show_results(stats: Dictionary) -> void:
	_result_emblem.texture = GameArt.ui("victory_emblem" if stats.get("victory", false) else "defeat_emblem")
	if not stats.get("victory", false) and _death_preview.state != "death":
		# UI-owned showcase plays while results pause gameplay. Rewards still
		# settle immediately; animation cannot trigger or postpone the payment.
		_death_preview.once("death")
	_save_failed = stats.get("save_failed", false)
	retry_button.text = "Tentar salvar novamente" if _save_failed else "Jogar novamente"
	hub_button.disabled = _save_failed
	title_label.text = "Vitória!" if stats.get("victory", false) else "Fim da partida"
	var boss_text: String = "Sim" if stats.get("boss_defeated", false) else "Não"
	stats_label.text = "Tempo sobrevivido: %s\nNível alcançado: %d\nInimigos derrotados: %d\nBoss derrotado: %s\n\nMoedas ganhas: %d" % [
		_format_time(stats.get("survival_time", 0.0)),
		stats.get("level", 1),
		stats.get("kills", 0),
		boss_text,
		stats.get("gold_earned", 0),
	]
	stats_label.text += "\nBônus já recebido: %d" % stats.get("gold_already_paid", 0)
	if _save_failed:
		stats_label.text = stats_label.text.replace("Moedas ganhas:", "Moedas já confirmadas:")
		stats_label.text += "\nPagamento do encerramento pendente.\nNão foi possível salvar. Tente novamente."
	else:
		stats_label.text += "\nCreditado agora: %d" % stats.get("gold_paid_now", stats.get("gold_earned", 0))
	stats_label.text += "\nSaldo permanente: %d" % SaveManager.gold
	if stats.get("death_bonus", 0) > 0:
		stats_label.text += "\nInclui bônus de derrota após chefe: %d" % stats.death_bonus
	RuralUI.clear(_inventory)
	var player: Node = get_tree().get_first_node_in_group("player")
	if player != null:
		RuralUI.inventory(_inventory, player)
	PauseManager.acquire(self, &"results")


func _format_time(seconds: float) -> String:
	var total: int = int(seconds)
	var minutes: int = total / 60
	var secs: int = total % 60
	return "%d:%02d" % [minutes, secs]

func reveal_after_death(animator: SpriteAnimator) -> void:
	if animator.finished:
		return
	_view.root.hide()
	# A bound method is disconnected automatically if the scene is replaced.
	animator.completed.connect(_on_death_complete, CONNECT_ONE_SHOT)

func _on_death_complete(_state: String) -> void:
	_view.root.show()


func _on_retry_pressed() -> void:
	if not PauseManager.is_active(self):
		return
	if _save_failed:
		save_retry_requested.emit()
		return
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://main.tscn")


func _on_hub_pressed() -> void:
	if _save_failed:
		return
	AudioManager.play_sfx("button")
	if PauseManager.is_active(self):
		PauseManager.change_scene("res://hub.tscn")
