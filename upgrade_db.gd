extends Node

## Autoload "UpgradeDB" — árvore de upgrades permanentes da fazenda,
## comprados com moeda persistente no hub. Cada nível soma o
## "value_per_level" ao estat correspondente, aplicado uma vez no
## início de cada run (em player.gd).

const UPGRADES: Dictionary = {
	"celeiro_forte": {
		"name": "Celeiro Reforçado",
		"desc": "+10 de vida máxima inicial por nível",
		"max_level": 5,
		"base_cost": 20,
		"cost_growth": 1.4,
		"value_per_level": 10.0,
	},
	"botas_gastas": {
		"name": "Botas Já Gastas",
		"desc": "+3% de velocidade inicial por nível",
		"max_level": 5,
		"base_cost": 20,
		"cost_growth": 1.4,
		"value_per_level": 0.03,
	},
	"adubo_precoce": {
		"name": "Adubo Precoce",
		"desc": "+1 de dano inicial em todas as armas por nível",
		"max_level": 5,
		"base_cost": 25,
		"cost_growth": 1.4,
		"value_per_level": 1.0,
	},
	"colheita_farta": {
		"name": "Colheita Farta",
		"desc": "+10% de XP ganho por nível",
		"max_level": 5,
		"base_cost": 25,
		"cost_growth": 1.4,
		"value_per_level": 0.10,
	},
}


## Custo pra comprar o PRÓXIMO nível, partindo do nível atual.
func get_cost(id: String, current_level: int) -> int:
	var data: Dictionary = UPGRADES[id]
	return int(round(data["base_cost"] * pow(data["cost_growth"], current_level)))
