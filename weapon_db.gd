extends Node

## Autoload "WeaponDB" — tabela central com nome, tipo e stats de
## cada arma nos seus 3 níveis. Adicione novas armas aqui; nenhum
## outro script precisa mudar para isso funcionar.
##
## "kind" diz ao Player qual cena de arma instanciar:
##   "ranged"      -> weapon.gd (projétil; pierce/bounces/splash opcionais)
##   "melee_thrown" -> thrown_weapon.gd (arremessa até o inimigo, gira no local)
##   "melee_aura"  -> melee_aura_weapon.gd (dano contínuo por segundo ao redor)
##   "melee_stab"  -> melee_stab_weapon.gd (estocada de alvo único, alcance curto)
##   "summon"      -> summon_weapon.gd (invoca um companheiro)
##   "trap"        -> trap_weapon.gd (larga armadilhas estacionárias)
##
## Alcances corpo a corpo (swing/aura/stab) ficam sempre bem acima da
## distância de contato real (personagem raio 16 + inimigo raio 6-12
## ≈ 22-28px), garantindo uma margem de segurança de uns 20-40px.

const WEAPONS: Dictionary = {
	"foice": {
		"kind": "melee_thrown",
		"name": "Foice Giratória",
		"icon_texture": "res://art/polished/weapon_foice_1.png",
		"levels": [
			{"damage": 6.0, "cooldown": 1.0, "range": 140.0, "radius": 36.0, "spin_duration": 0.5, "desc": "Arremessa a foice até o inimigo mais próximo; ela gira no local"},
			{"damage": 10.0, "cooldown": 0.85, "range": 155.0, "radius": 42.0, "spin_duration": 0.65, "desc": "Gira por mais tempo e com mais força"},
			{"damage": 16.0, "cooldown": 0.7, "range": 170.0, "radius": 50.0, "spin_duration": 0.8, "desc": "Furacão Caipira: giro amplo e daninho"},
		],
	},
	"milho": {
		"kind": "ranged",
		"name": "Milho-Metralhadora",
		"projectile_texture": "res://art/polished/projectile_milho.png",
		"icon_texture": "res://art/polished/weapon_milho_1.png",
		"levels": [
			{"damage": 3.0, "cooldown": 0.6, "desc": "Tiro rápido no inimigo mais próximo"},
			{"damage": 4.0, "cooldown": 0.45, "desc": "Rajada mais frequente"},
			{"damage": 6.0, "cooldown": 0.3, "desc": "Pipoca Explosiva: rajada intensa"},
		],
	},
	"forquilha": {
		"kind": "melee_stab",
		"name": "Forquilha (Tridente de Feno)",
		"icon_texture": "res://art/polished/weapon_forquilha_1.png",
		"levels": [
			{"damage": 9.0, "cooldown": 0.6, "range": 60.0, "desc": "Estocada rápida no inimigo mais próximo"},
			{"damage": 14.0, "cooldown": 0.5, "range": 66.0, "desc": "Estocadas mais fortes e frequentes"},
			{"damage": 22.0, "cooldown": 0.4, "range": 74.0, "desc": "Forquilha do Diabo: estocadas quase contínuas"},
		],
	},
	"batata": {
		"kind": "ranged",
		"name": "Canhão de Batata",
		"projectile_texture": "res://art/polished/projectile_batata.png",
		"icon_texture": "res://art/polished/weapon_batata_1.png",
		"levels": [
			{"damage": 14.0, "cooldown": 1.6, "pierce": 0, "splash_radius": 70.0, "splash_damage": 8.0, "desc": "Tiro lento e forte, explode numa área que pega pelo menos 2 inimigos"},
			{"damage": 18.0, "cooldown": 1.5, "pierce": 3, "splash_radius": 105.0, "splash_damage": 12.0, "desc": "Atravessa até 3 inimigos e explode numa área bem maior"},
			{"damage": 24.0, "cooldown": 1.4, "pierce": -1, "splash_radius": 165.0, "splash_damage": 18.0, "desc": "Batata-Bomba Nuclear: atravessa infinitos e explode numa área enorme"},
		],
	},
	"mamona": {
		"kind": "ranged",
		"name": "Estilingue de Mamona",
		"projectile_texture": "res://art/polished/projectile_mamona.png",
		"icon_texture": "res://art/polished/weapon_mamona_1.png",
		"levels": [
			{"damage": 4.0, "cooldown": 0.9, "bounces": 1, "desc": "Ricocheteia 1 vez"},
			{"damage": 5.0, "cooldown": 0.8, "bounces": 3, "desc": "Ricocheteia 3 vezes"},
			{"damage": 7.0, "cooldown": 0.7, "bounces": 10, "desc": "Mamona Múltipla: ricocheteia 10 vezes"},
		],
	},
	"motosserra": {
		"kind": "melee_aura",
		"name": "Motosserra Enferrujada",
		"icon_texture": "res://art/polished/weapon_motosserra_1.png",
		"levels": [
			{"damage": 4.0, "tick_interval": 0.4, "radius": 46.0, "desc": "Dano contínuo por segundo ao redor"},
			{"damage": 6.0, "tick_interval": 0.35, "radius": 56.0, "desc": "Alcance maior"},
			{"damage": 10.0, "tick_interval": 0.3, "radius": 68.0, "desc": "Motosserra de Ouro: machuca sem parar"},
		],
	},
	"bezerro": {
		"kind": "summon",
		"name": "Bezerro Guarda-Costas",
		"levels": [
			{"damage": 4.0, "cooldown": 1.2, "desc": "Bezerro ataca o inimigo mais próximo"},
			{"damage": 6.0, "cooldown": 1.0, "desc": "Novilha mais rápida e forte"},
			{"damage": 10.0, "cooldown": 0.8, "desc": "Vaca Voadora: ataques pesados"},
		],
	},
	"cerca": {
		"kind": "trap",
		"name": "Cerca Elétrica",
		"levels": [
			{"damage": 3.0, "tick_interval": 0.5, "duration": 3.0, "cooldown": 3.0, "desc": "Poste solta choque periódico"},
			{"damage": 4.0, "tick_interval": 0.45, "duration": 3.5, "cooldown": 2.5, "desc": "Fio elétrico entre 2 postes"},
			{"damage": 6.0, "tick_interval": 0.4, "duration": 4.0, "cooldown": 2.0, "desc": "Rede de Alta Tensão"},
		],
	},
}
