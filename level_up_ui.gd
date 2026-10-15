extends CanvasLayer
class_name LevelUpUI

## Pausa o jogo ao subir de nível e oferece 3 upgrades aleatórios.
## Anexe este script ao CanvasLayer "LevelUpUI" na cena principal.
## Lembre de definir process_mode = Always nesse nó no editor,
## senão os botões não respondem com o jogo pausado.

@export var player_path: NodePath

@onready var card_container: HBoxContainer = $PanelContainer/VBoxContainer/CardContainer

var _player: Player

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
	hide()
	_player = get_node(player_path)
	_player.leveled_up.connect(_on_player_leveled_up)


func _on_player_leveled_up() -> void:
	if visible:
		return
	AudioManager.play_sfx("level_up")
	get_tree().paused = true
	_populate_cards()
	show()


func _populate_cards() -> void:
	for child in card_container.get_children():
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
		var button := Button.new()
		button.text = "%s\n%s" % [upgrade["name"], upgrade["desc"]]
		button.custom_minimum_size = Vector2(190, 110)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD
		button.pressed.connect(_on_upgrade_chosen.bind(upgrade))
		card_container.add_child(button)


func _on_upgrade_chosen(upgrade: Dictionary) -> void:
	AudioManager.play_sfx("button")
	_apply_upgrade(upgrade)
	_player.pending_level_ups -= 1

	if _player.pending_level_ups > 0:
		_populate_cards()
	else:
		hide()
		get_tree().paused = false


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
