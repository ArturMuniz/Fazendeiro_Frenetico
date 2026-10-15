extends Node

## Autoload "CharacterDB" — os personagens jogáveis. Cada um tem um
## trade-off (bônus + penalidade) e uma arma inicial diferente, pra
## incentivar builds diferentes desde o começo da run.

const CHARACTERS: Dictionary = {
	"fazendeiro": {
		"name": "Fazendeiro Clássico",
		"desc": "Equilibrado, sem bônus nem penalidades.",
		"unlock_cost": 0,
		"health_mod": 0.0,
		"speed_mod": 0.0,
		"damage_mod": 0.0,
		"starting_weapon": "foice",
	},
	"vovo": {
		"name": "Vovó Resistente",
		"desc": "+30 de vida máxima, mas 15% mais lenta.",
		"unlock_cost": 50,
		"health_mod": 30.0,
		"speed_mod": -0.15,
		"damage_mod": 0.0,
		"starting_weapon": "motosserra",
	},
	"netinho": {
		"name": "Netinho Ágil",
		"desc": "+20% de velocidade, mas 15 de vida a menos.",
		"unlock_cost": 80,
		"health_mod": -15.0,
		"speed_mod": 0.20,
		"damage_mod": 0.0,
		"starting_weapon": "milho",
	},
}
