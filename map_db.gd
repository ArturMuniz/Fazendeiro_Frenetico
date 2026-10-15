extends Node

## Autoload "MapDB" — a campanha. Cada mapa é uma run completa:
## 3 fases + fase do boss (fixo por mapa). O build zera ao trocar de
## mapa; a campanha é só a ORDEM DE DESBLOQUEIO ("unlock_requires").
##
## Campos de cada mapa:
##   name, background_color, music_id (opcional)
##   order            -> posição na campanha (0 = primeiro)
##   unlock_requires  -> id do mapa que precisa estar concluído ("" = livre)
##   base_difficulty  -> multiplicador base de HP/dano dos inimigos
##   boss_id          -> boss fixo do mapa (ver EnemyDB)
##   phases           -> 3 fases: name, duration (s), spawn_interval (s),
##                       archetypes (ids do EnemyDB que podem aparecer)
##   boss_phase       -> spawn dos "adds" enquanto o boss está vivo

const MAPS: Dictionary = {
	"horta": {
		"name": "Horta",
		"background_color": Color(0.55, 0.75, 0.35),
		"order": 0,
		"unlock_requires": "",
		"base_difficulty": 1.0,
		"boss_id": "boss_lagarta",
		"phases": [
			{"name": "Fase 1", "duration": 100.0, "spawn_interval": 1.8, "archetypes": ["pulgao"]},
			{"name": "Fase 2", "duration": 110.0, "spawn_interval": 1.4, "archetypes": ["pulgao", "lesma"]},
			{"name": "Fase 3", "duration": 120.0, "spawn_interval": 1.1, "archetypes": ["pulgao", "lesma", "gafanhoto"]},
		],
		"boss_phase": {"name": "Boss", "spawn_interval": 2.4, "archetypes": ["pulgao", "gafanhoto"]},
	},
	"celeiro": {
		"name": "Celeiro",
		"background_color": Color(0.6, 0.45, 0.3),
		"music_id": "map_celeiro",
		"order": 1,
		"unlock_requires": "horta",
		"base_difficulty": 1.35,
		"boss_id": "boss_rainha_moscas",
		"phases": [
			{"name": "Fase 1", "duration": 100.0, "spawn_interval": 1.5, "archetypes": ["pulgao", "gafanhoto"]},
			{"name": "Fase 2", "duration": 110.0, "spawn_interval": 1.2, "archetypes": ["lesma", "gafanhoto", "mosca"]},
			{"name": "Fase 3", "duration": 120.0, "spawn_interval": 0.95, "archetypes": ["pulgao", "lesma", "gafanhoto", "mosca"]},
		],
		"boss_phase": {"name": "Boss", "spawn_interval": 2.0, "archetypes": ["pulgao", "mosca"]},
	},
	"pomar": {
		"name": "Pomar ao Entardecer",
		"background_color": Color(0.85, 0.55, 0.35),
		"order": 2,
		"unlock_requires": "celeiro",
		"base_difficulty": 1.7,
		"boss_id": "boss_gafanhoto_gigante",
		"phases": [
			{"name": "Fase 1", "duration": 100.0, "spawn_interval": 1.3, "archetypes": ["pulgao", "lesma", "gafanhoto"]},
			{"name": "Fase 2", "duration": 110.0, "spawn_interval": 1.05, "archetypes": ["lesma", "gafanhoto", "mosca"]},
			{"name": "Fase 3", "duration": 120.0, "spawn_interval": 0.8, "archetypes": ["pulgao", "lesma", "gafanhoto", "mosca"]},
		],
		"boss_phase": {"name": "Boss", "spawn_interval": 1.7, "archetypes": ["gafanhoto", "mosca"]},
	},
}


## Ids dos mapas na ordem da campanha.
func get_ordered_ids() -> Array:
	var ids: Array = MAPS.keys()
	ids.sort_custom(func(a: String, b: String) -> bool: return MAPS[a]["order"] < MAPS[b]["order"])
	return ids


## Id do mapa que é liberado ao concluir `id` ("" se for o último).
func get_next_map_id(id: String) -> String:
	for other in MAPS:
		if MAPS[other].get("unlock_requires", "") == id:
			return other
	return ""
