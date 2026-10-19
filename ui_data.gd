class_name UIData
extends RefCounted

## Apresenta valores efetivos sem alterar a simulação ou supor DPS.
static func number(value: float) -> String:
	var text := "%.4f" % value
	while text.ends_with("0"):
		text = text.trim_suffix("0")
	return text.trim_suffix(".").replace(".", ",")

static func level_of(entries: Array, id: String) -> int:
	for entry in entries:
		if entry.id == id:
			return entry.level
	return 0

static func weapon_values(player: Node, id: String, level: int) -> Dictionary:
	var data: Dictionary = WeaponDB.WEAPONS[id]
	var stats: Dictionary = data.levels[level - 1]
	var result: Dictionary = {"Dano por acerto": number(stats.damage + player.damage_bonus)}
	if stats.has("cooldown"):
		var multiplier: float = clampf(player.cooldown_multiplier, 0.25, 1.0) if data.kind in ["ranged", "melee_stab", "melee_thrown"] else 1.0
		result["Intervalo de colocação" if data.kind == "trap" else "Intervalo entre ataques"] = number(stats.cooldown * multiplier) + " s"
	for key in ["tick_interval", "range", "radius", "spin_duration", "duration", "splash_radius", "splash_damage", "bounces", "pierce"]:
		if not stats.has(key):
			continue
		var names := {"tick_interval": "Intervalo entre danos", "range": "Alcance", "radius": "Raio", "spin_duration": "Duração do giro", "duration": "Duração", "splash_radius": "Raio da explosão", "splash_damage": "Dano da explosão", "bounces": "Ricochetes", "pierce": "Perfurações"}
		var unit := " s" if key in ["tick_interval", "spin_duration", "duration"] else (" px" if key in ["range", "radius", "splash_radius"] else "")
		result[names[key]] = "Ilimitadas" if key == "pierce" and stats[key] == -1 else number(stats[key]) + unit
	return result

static func passive_total(id: String, level: int) -> String:
	var data: Dictionary = PassiveDB.PASSIVES[id]
	var value: float = 0.0
	var multiplier: float = 1.0
	for i in range(level):
		var increment: float = data.levels[i]
		value += increment
		if data.stat == "attack_speed_percent":
			multiplier *= 1.0 - increment
		else:
			multiplier *= 1.0 + increment
	match data.stat:
		"defense_percent": return "Defesa do item: %s%%" % number(value * 100)
		"bonus_max_health": return "Vida máxima do item: +%s" % number(value)
		"attack_speed_percent": return "Intervalo pelo item: ×%s" % number(multiplier)
		"move_speed_percent": return "Velocidade pelo item: ×%s" % number(multiplier)
		"magnet_percent": return "Raio pelo item: ×%s%s" % [number(multiplier), " · Coleta automática: 15 s" if level == 3 else ""]
		"regeneration": return "Regeneração do item: +%s vida/s" % number(value)
		"xp_bonus": return "XP do item: +%s%%" % number(value * 100)
		"damage_bonus": return "Dano do item: +%s por acerto" % number(value)
	return ""

static func item_details(player: Node, id: String, level: int, passive: bool) -> String:
	if passive:
		return passive_total(id, level)
	var values := weapon_values(player, id, level)
	var lines: PackedStringArray = []
	for key in values:
		lines.append("%s: %s" % [key, values[key]])
	return " · ".join(lines)

static func preview(player: Node, upgrade: Dictionary) -> Dictionary:
	var title: String = upgrade.get("name", "Melhoria")
	var lines: PackedStringArray = []
	var icon := ""
	var kind := "ATRIBUTO"
	if upgrade.has("weapon_id"):
		var id: String = upgrade.weapon_id
		var old := level_of(player.weapons, id)
		var next := mini(old + 1, 3)
		title = WeaponDB.WEAPONS[id].name
		kind = "ARMA · " + ("Nova → Nível 1" if old == 0 else "Nível %d → %d" % [old, next])
		var before: Dictionary = weapon_values(player, id, old) if old > 0 else {}
		var after := weapon_values(player, id, next)
		for key in after:
			lines.append("%s: %s%s" % [key, str(before[key]) + " → " if before.has(key) else "", after[key]])
		icon = RuralUI.item_icon(id, next)
	elif upgrade.has("passive_id"):
		var id: String = upgrade.passive_id
		var old := level_of(player.passives, id)
		var next := mini(old + 1, 3)
		var data: Dictionary = PassiveDB.PASSIVES[id]
		var inc: float = data.levels[next - 1]
		title = data.name
		kind = "PASSIVO · " + ("Novo → Nível 1" if old == 0 else "Nível %d → %d" % [old, next])
		match data.stat:
			"defense_percent": lines.append("Defesa: %s%% → %s%%" % [number(player.defense_percent * 100), number(minf(0.75, player.defense_percent + inc) * 100)])
			"bonus_max_health": lines.append("Vida máxima: %s → %s\nCura: +%s" % [number(player.max_health), number(player.max_health + inc), number(inc)])
			"attack_speed_percent": lines.append("Intervalo das armas compatíveis: ×%s → ×%s" % [number(clampf(player.cooldown_multiplier, 0.25, 1)), number(clampf(player.cooldown_multiplier * (1.0 - inc), 0.25, 1))])
			"move_speed_percent": lines.append("Velocidade: %s → %s px/s" % [number(player.speed), number(player.speed * (1.0 + inc))])
			"magnet_percent": lines.append("Coleta: %s → %s px%s" % [number(player.magnet_radius), number(player.magnet_radius * (1.0 + inc)), "\nColeta automática da tela a cada 15 s" if next == 3 else ""])
			"regeneration": lines.append("Regeneração: %s → %s vida/s" % [number(player.regeneration), number(player.regeneration + inc)])
			"xp_bonus": lines.append("XP adicional: %s%% → %s%%" % [number(player.xp_bonus * 100), number((player.xp_bonus + inc) * 100)])
			"damage_bonus": lines.append("Dano adicional: +%s → +%s" % [number(player.damage_bonus), number(player.damage_bonus + inc)])
		lines.append(passive_total(id, next))
		icon = RuralUI.item_icon(id, next, true)
	else:
		match upgrade.id:
			"damage": lines.append("Dano adicional: +%s → +%s" % [number(player.damage_bonus), number(player.damage_bonus + 3)])
			"cooldown": lines.append("Intervalo das armas compatíveis: ×%s → ×%s\nFoice, forquilha e projéteis; piso de ×0,25." % [number(clampf(player.cooldown_multiplier, 0.25, 1)), number(clampf(player.cooldown_multiplier * 0.9, 0.25, 1))])
			"speed": lines.append("Velocidade: %s → %s px/s" % [number(player.speed), number(player.speed * 1.15)])
			"health": lines.append("Vida máxima: %s → %s\nRestaura toda a vida." % [number(player.max_health), number(player.max_health + 20)])
			"regeneration": lines.append("Regeneração: %s → %s vida/s" % [number(player.regeneration), number(player.regeneration + 0.25)])
			"xp": lines.append("XP adicional: %s%% → %s%%" % [number(player.xp_bonus * 100), number((player.xp_bonus + 0.05) * 100)])
			"defense": lines.append("Defesa: %s%% → %s%%\nLimite: 75%% de redução." % [number(player.defense_percent * 100), number(minf(0.75, player.defense_percent + 0.05) * 100)])
			"magnet": lines.append("Coleta: %s → %s px" % [number(player.magnet_radius), number(player.magnet_radius + 20)])
	return {"title": title, "kind": kind, "lines": lines, "icon": icon}
