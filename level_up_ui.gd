extends CanvasLayer
class_name LevelUpUI

## Pausa o jogo ao subir de nível e oferece 3 upgrades aleatórios.
## Anexe este script ao CanvasLayer "LevelUpUI" na cena principal.
## Lembre de definir process_mode = Always nesse nó no editor,
## senão os botões não respondem com o jogo pausado.

@export var player_path: NodePath

var card_container: VBoxContainer
var _view: Dictionary
var _confirm: Button
var _selected: Dictionary = {}
var _choices: Array = []
var _details: Label
var _build: VBoxContainer

var _player: Player
var _card_generation: int = 0
var _opened: bool = false

## Upgrades genéricos (afetam todas as armas / o personagem)
var _stat_upgrades: Array = [
	{"id": "damage", "name": "Adubo Turbinado", "desc": "+3 de dano em todas as armas"},
	{"id": "cooldown", "name": "Café Mais Forte", "desc": "Todas as armas 10% mais rápidas"},
	{"id": "speed", "name": "Botas Novas", "desc": "+15% de velocidade"},
	{"id": "health", "name": "Marmita Caipira", "desc": "+20 de vida máxima e cura total"},
]

## Armas: viram cópia nova se o jogador não tiver, ou fundem se já tiver
var _weapon_upgrades: Array = [
	{"id": "weapon_foice", "weapon_id": "foice", "name": "Foice Giratória", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_milho", "weapon_id": "milho", "name": "Milho-Metralhadora", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_forquilha", "weapon_id": "forquilha", "name": "Forquilha", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_batata", "weapon_id": "batata", "name": "Canhão de Batata", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_mamona", "weapon_id": "mamona", "name": "Estilingue de Mamona", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_motosserra", "weapon_id": "motosserra", "name": "Motosserra Enferrujada", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_bezerro", "weapon_id": "bezerro", "name": "Bezerro Guarda-Costas", "desc": "Nova arma / evolui se já tiver"},
	{"id": "weapon_cerca", "weapon_id": "cerca", "name": "Cerca Elétrica", "desc": "Nova arma / evolui se já tiver"},
]

## Passivos: viram cópia nova se o jogador não tiver, ou fundem se já tiver
var _passive_upgrades: Array = [
	{"id": "passive_espantalho", "passive_id": "espantalho", "name": "Espantalho de Bolso", "desc": "Reduz % do dano recebido"},
	{"id": "passive_sementes", "passive_id": "sementes", "name": "Sementes Mágicas", "desc": "+vida máxima, cura na hora"},
	{"id": "passive_termica", "passive_id": "termica", "name": "Garrafa Térmica", "desc": "Todas as armas mais rápidas"},
	{"id": "passive_galochas", "passive_id": "galochas", "name": "Galochas", "desc": "+velocidade de movimento"},
	{"id": "passive_ima", "passive_id": "ima", "name": "Ímã de Geladeira", "desc": "+raio de coleta de XP"},
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	$PanelContainer.hide()
	_view = RuralUI.shell(self, "Escolha uma melhoria", "Selecione uma carta e confirme sua escolha.")
	card_container = _view.body
	_confirm = RuralUI.button("Selecione uma melhoria", _confirm_selection)
	_confirm.disabled = true
	_view.footer.add_child(_confirm)
	_player = get_node(player_path)
	_player.leveled_up.connect(_on_player_leveled_up)


func _on_player_leveled_up() -> void:
	if _opened or _player.is_dead():
		return
	_opened = true
	AudioManager.play_sfx("level_up")
	_populate_cards()
	PauseManager.acquire(self, &"level_up")


func _populate_cards() -> void:
	_card_generation += 1
	_selected = {}
	_choices.clear()
	_confirm.disabled = true
	_confirm.text = "Selecione uma melhoria"
	_view.subtitle.text = "%d escolha(s) pendente(s) · Valores efetivos da sua build" % _player.pending_level_ups
	for child in card_container.get_children():
		card_container.remove_child(child)
		child.queue_free()

	var pool: Array = _stat_upgrades.duplicate()
	for weapon_upgrade in _weapon_upgrades:
		if not _player.is_weapon_unavailable(weapon_upgrade["weapon_id"]):
			pool.append(weapon_upgrade)
	for passive_upgrade in _passive_upgrades:
		if not _player.is_passive_unavailable(passive_upgrade["passive_id"]):
			pool.append(passive_upgrade)

	pool.shuffle()
	var choice_count: int = min(3, pool.size())

	for i in range(choice_count):
		var upgrade: Dictionary = pool[i]
		var info := UIData.preview(_player, upgrade)
		var button := RuralUI.button("%s\n%s\n%s" % [info.title, info.kind, "\n".join(info.lines.slice(0, 3))])
		button.custom_minimum_size.y = 168
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_stylebox_override("normal", RuralUI.flat(Color("eadbb8"), Color("b29b70")))
		button.add_theme_stylebox_override("hover", RuralUI.flat(Color("f5e9cb"), Color("54724a")))
		button.add_theme_stylebox_override("pressed", RuralUI.flat(Color("d6dfb8"), RuralUI.GREEN))
		button.add_theme_color_override("font_color", RuralUI.INK)
		button.add_theme_color_override("font_hover_color", RuralUI.INK)
		button.add_theme_color_override("font_pressed_color", RuralUI.INK)
		button.add_theme_color_override("font_focus_color", RuralUI.INK)
		button.add_theme_font_size_override("font_size", 24)
		if info.icon != "":
			button.icon = RuralUI.texture(info.icon)
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 64)
		button.pressed.connect(_select_upgrade.bind(upgrade, _card_generation, button))
		card_container.add_child(button)
		_choices.append(button)
	_details = RuralUI.label("Toque em uma carta para ver todos os efeitos.", 22)
	card_container.add_child(_details)
	var toggle := RuralUI.button("Ver equipamento e atributos", _toggle_build)
	card_container.add_child(toggle)
	_build = VBoxContainer.new()
	card_container.add_child(_build)
	RuralUI.inventory(_build, _player)
	RuralUI.attributes(_build, _player)
	_build.hide()

func _toggle_build() -> void:
	_build.visible = not _build.visible

func _select_upgrade(upgrade: Dictionary, generation: int, button: Button) -> void:
	if generation != _card_generation or not PauseManager.is_active(self):
		return
	_selected = upgrade
	var info := UIData.preview(_player, upgrade)
	_details.text = "%s\n%s" % [info.title, "\n".join(info.lines)]
	for choice in _choices:
		choice.add_theme_stylebox_override("normal", RuralUI.flat(Color("d6dfb8") if choice == button else Color("eadbb8"), RuralUI.GREEN if choice == button else Color("b29b70")))
	_confirm.text = "Confirmar melhoria"
	_confirm.disabled = false

func _confirm_selection() -> void:
	if not _selected.is_empty():
		_on_upgrade_chosen(_selected, _card_generation)


func _on_upgrade_chosen(upgrade: Dictionary, generation: int) -> void:
	if generation != _card_generation or not PauseManager.is_active(self) or _player.is_dead():
		return
	_card_generation += 1
	AudioManager.play_sfx("button")
	_apply_upgrade(upgrade)
	_player.pending_level_ups -= 1

	if _player.pending_level_ups > 0:
		_populate_cards()
	else:
		_opened = false
		hide()
		PauseManager.release(self)


func _apply_upgrade(upgrade: Dictionary) -> void:
	var id: String = upgrade["id"]

	if id.begins_with("weapon_"):
		_player.add_weapon(upgrade["weapon_id"])
		return

	if id.begins_with("passive_"):
		_player.add_passive(upgrade["passive_id"])
		return

	match id:
		"damage":
			_player.damage_bonus += 3.0
		"cooldown":
			_player.cooldown_multiplier *= 0.9
			for entry in _player.weapons:
				entry["node"].configure(entry["id"], entry["level"])
		"speed":
			_player.speed *= 1.15
		"health":
			_player.max_health += 20.0
			_player.health = _player.max_health
