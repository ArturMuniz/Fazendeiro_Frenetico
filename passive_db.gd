extends Node

## Autoload "PassiveDB" — tabela central dos itens passivos.
## "levels" guarda o GANHO INCREMENTAL de cada nível (não o total
## acumulado) — assim, ao fundir, basta somar o valor do novo nível
## em cima do que já existe, sem precisar "desfazer" nada.
##
## "stat" diz ao Player qual atributo esse item mexe:
##   "defense_percent"     -> reduz % do dano recebido
##   "bonus_max_health"    -> soma na vida máxima (e cura o tanto)
##   "attack_speed_percent"-> reduz % do cooldown de todas as armas
##   "move_speed_percent"  -> soma % na velocidade de movimento
##   "magnet_percent"      -> soma % no raio de coleta de XP
##
## "special_level3" (opcional): efeito extra só no nível 3.

const PASSIVES: Dictionary = {
	"espantalho": {
		"name": "Espantalho de Bolso",
		"stat": "defense_percent",
		"levels": [0.10, 0.10, 0.20],
		"desc_levels": ["+10% de defesa", "+10% de defesa (total 20%)", "+20% de defesa (total 40%)"],
	},
	"sementes": {
		"name": "Bolsa de Sementes Mágicas",
		"stat": "bonus_max_health",
		"levels": [20.0, 30.0, 50.0],
		"desc_levels": ["+20 de vida máxima", "+30 de vida máxima (total 50)", "+50 de vida máxima (total 100)"],
	},
	"termica": {
		"name": "Garrafa Térmica",
		"stat": "attack_speed_percent",
		"levels": [0.10, 0.10, 0.30],
		"desc_levels": ["Ataques 10% mais rápidos", "+10% (total 20%)", "+30% (total 50%)"],
	},
	"galochas": {
		"name": "Galochas",
		"stat": "move_speed_percent",
		"levels": [0.10, 0.10, 0.20],
		"desc_levels": ["+10% de velocidade", "+10% (total 20%)", "+20% (total 40%)"],
	},
	"ima": {
		"name": "Ímã de Geladeira",
		"stat": "magnet_percent",
		"levels": [0.20, 0.30, 0.0],
		"special_level3": "auto_collect",
		"desc_levels": ["+20% de raio de coleta", "+30% (total 50%)", "Coleta automática da tela a cada 15s"],
	},
}
