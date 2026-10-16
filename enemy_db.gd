extends Node

## Autoload "EnemyDB" — tabela central dos arquétipos de inimigo.
## "behavior" diz ao enemy.gd qual comportamento usar:
##   "runner"      -> persegue direto o jogador (padrão)
##   "tank"        -> persegue direto, mas lento e com muito HP
##   "jumper"      -> avança em pulos curtos, parando entre eles
##   "shooter"     -> mantém distância e atira no jogador
##   "boss_brute"  -> boss que só persegue e bate forte por contato
##   "boss_ranged" -> boss que mantém distância e solta rajadas
##   "boss_leaper" -> boss que pula e causa dano de área ao pousar

const ENEMIES: Dictionary = {
	"pulgao": {
		"name": "Pulgão Corredor",
		"behavior": "runner",
		"speed": 110.0,
		"health": 6.0,
		"contact_damage": 4.0,
		"xp_value": 1,
		"scale": 0.4,
		"color": Color(0.6, 1.0, 0.4),
	},
	"lesma": {
		"name": "Lesma Tanque",
		"behavior": "tank",
		"speed": 35.0,
		"health": 30.0,
		"contact_damage": 8.0,
		"xp_value": 3,
		"scale": 0.75,
		"color": Color(0.55, 0.35, 0.75),
		"sprite_frames": ["res://art/polished/lesma_idle_00.png", "res://art/polished/lesma_idle_01.png"],
	},
	"gafanhoto": {
		"name": "Gafanhoto Saltador",
		"behavior": "jumper",
		"speed": 70.0,
		"health": 10.0,
		"contact_damage": 6.0,
		"xp_value": 2,
		"scale": 0.5,
		"color": Color(0.9, 0.8, 0.2),
		"jump_interval": 1.4,
		"jump_speed": 260.0,
		"jump_duration": 0.35,
		"sprite_frames": ["res://art/polished/gafanhoto_idle_00.png", "res://art/polished/gafanhoto_idle_01.png"],
	},
	"mosca": {
		"name": "Mosca Atiradora",
		"behavior": "shooter",
		"speed": 60.0,
		"health": 8.0,
		"contact_damage": 3.0,
		"xp_value": 2,
		"scale": 0.4,
		"color": Color(0.3, 0.5, 1.0),
		"preferred_range": 180.0,
		"shoot_interval": 1.8,
		"shoot_damage": 4.0,
		"projectile_speed": 200.0,
	},
	"boss_lagarta": {
		"name": "Lagarta Titã",
		"behavior": "boss_brute",
		"speed": 50.0,
		"health": 260.0,
		"contact_damage": 16.0,
		"xp_value": 35,
		"scale": 1.7,
		"color": Color(0.4, 0.8, 0.3),
		"sprite_frames": ["res://art/polished/boss_lagarta_idle_00.png"],
	},
	"boss_rainha_moscas": {
		"name": "Rainha das Moscas",
		"behavior": "boss_ranged",
		"speed": 70.0,
		"health": 150.0,
		"contact_damage": 8.0,
		"xp_value": 35,
		"scale": 1.4,
		"color": Color(0.4, 0.3, 0.9),
		"preferred_range": 220.0,
		"burst_interval": 1.8,
		"burst_count": 10,
		"burst_damage": 7.0,
		"projectile_speed": 220.0,
	},
	"boss_gafanhoto_gigante": {
		"name": "Gafanhoto Gigante",
		"behavior": "boss_leaper",
		"speed": 60.0,
		"health": 190.0,
		"contact_damage": 10.0,
		"xp_value": 35,
		"scale": 1.5,
		"color": Color(0.9, 0.7, 0.1),
		"jump_interval": 2.2,
		"jump_speed": 320.0,
		"jump_duration": 0.4,
		"impact_radius": 90.0,
		"impact_damage": 20.0,
	},
}
