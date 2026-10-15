extends Node

## Autoload "FarmUpgradeDB" — upgrades permanentes comprados com a
## moeda persistente, aplicados automaticamente no início de toda
## run (independente do personagem escolhido).

const UPGRADES: Dictionary = {
	"vida_extra": {
		"name": "Celeiro Reforçado",
		"stat": "bonus_health_flat",
		"amount_per_level": 10.0,
		"max_level": 3,
		"cost_per_level": [30, 60, 100],
		"desc_per_level": ["+10 de vida inicial", "+10 (total 20)", "+10 (total 30)"],
	},
	"dano_extra": {
		"name": "Adubo Premium",
		"stat": "bonus_damage_flat",
		"amount_per_level": 2.0,
		"max_level": 3,
		"cost_per_level": [40, 80, 120],
		"desc_per_level": ["+2 de dano em todas as armas", "+2 (total 4)", "+2 (total 6)"],
	},
	"velocidade_extra": {
		"name": "Botas do Vovô",
		"stat": "bonus_speed_percent",
		"amount_per_level": 0.05,
		"max_level": 3,
		"cost_per_level": [35, 70, 110],
		"desc_per_level": ["+5% de velocidade inicial", "+5% (total 10%)", "+5% (total 15%)"],
	},
}
