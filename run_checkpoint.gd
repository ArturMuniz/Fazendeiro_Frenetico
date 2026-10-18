class_name RunCheckpoint
extends Node

## One midpoint checkpoint in memory. Persistent currency is a separate ledger.
const PLAYER_FIELDS := ["health", "max_health", "speed", "magnet_radius", "xp", "level", "xp_to_next", "survival_time", "kills", "boss_defeated", "damage_bonus", "cooldown_multiplier", "defense_percent", "bonus_max_health", "auto_collect_orbs", "_boss_victory_shown"]
const SPAWNER_FIELDS := ["_mode", "_phase_index", "_phase_elapsed", "_breather_left", "_in_breather", "_free_elapsed", "_boss_interval", "_current_archetypes"]
var player: Node
var spawner: Node
var midpoint: float = 0.0
var snapshot: Dictionary = {}
var reached_midpoint: bool = false
var restoring: bool = false

func setup(actor: Node, enemy_spawner: Node) -> void:
	player = actor
	spawner = enemy_spawner
	var duration := 0.0
	for phase in spawner._phases:
		duration += float(phase.duration) * spawner.phase_duration_scale
	duration += max(0, spawner._phases.size() - 1) * spawner.breather_duration
	midpoint = duration / 2.0

func _process(_delta: float) -> void:
	if restoring or reached_midpoint or not is_instance_valid(player) or player.is_dead():
		return
	if player.survival_time >= midpoint:
		snapshot = capture()
		reached_midpoint = true

func prepare_death() -> void:
	if not reached_midpoint:
		snapshot = capture()
		# There is no living health value at an early death; restore full life.
		snapshot.player.health = player.max_health

func description() -> String:
	return "Retornar à metade · nível, itens e progresso do checkpoint" if reached_midpoint else "Retornar ao momento da morte · vida restaurada"

func capture() -> Dictionary:
	var data := {"player": {}, "spawner": {}, "position": player.global_position, "weapons": [], "passives": player.passives.duplicate(true), "enemies": [], "orbs": []}
	data["auto_collect_left"] = player._auto_collect_timer.time_left if is_instance_valid(player._auto_collect_timer) else 0.0
	for field in PLAYER_FIELDS:
		data.player[field] = player.get(field)
	for entry in player.weapons:
		data.weapons.append({"id": entry.id, "level": entry.level, "timers": timers_of(entry.node)})
	for field in SPAWNER_FIELDS:
		var value: Variant = spawner.get(field)
		data.spawner[field] = value.duplicate(true) if value is Array or value is Dictionary else value
	data.spawner["timers"] = timers_of(spawner)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy._despawning or enemy.is_queued_for_deletion(): continue
		data.enemies.append({"id": enemy.enemy_id, "position": enemy.global_position, "health": enemy.health,
			"difficulty": enemy.max_health / float(EnemyDB.ENEMIES[enemy.enemy_id].health), "timers": timers_of(enemy),
			"jumping": enemy._jumping, "direction": enemy._jump_direction})
	for orb in get_tree().get_nodes_in_group("xp_orbs"):
		if not orb._collected and not orb.is_queued_for_deletion():
			data.orbs.append({"position": orb.global_position, "xp": orb.xp_value})
	return data

static func timers_of(node: Node) -> Dictionary:
	var data := {}
	for child in node.find_children("*", "Timer", true, false):
		data[str(node.get_path_to(child))] = {"running": not child.is_stopped(), "left": child.time_left, "wait": child.wait_time}
	return data

static func restore_timers(node: Node, values: Dictionary) -> void:
	for path in values:
		var timer := node.get_node_or_null(NodePath(path)) as Timer
		if timer == null: continue
		timer.stop()
		timer.wait_time = float(values[path].wait)
		if values[path].running:
			timer.start(maxf(float(values[path].left), 0.001))
			timer.wait_time = float(values[path].wait)

func restore() -> bool:
	if restoring or snapshot.is_empty(): return false
	restoring = true
	var scene: Node = get_tree().current_scene
	# Combat transients belong to the discarded timeline, never to the checkpoint.
	for child in scene.get_children():
		if child is Enemy:
			child._despawn()
		elif child is XPOrb or child is Projectile or child is EnemyProjectile or child is Trap or child is Companion or child is DamageNumber or child is VisualFX or child is ThrownFoice:
			child.queue_free()
	for entry in player.weapons:
		entry.node.queue_free()
	player.weapons.clear()
	await get_tree().process_frame
	await get_tree().process_frame
	# A death can already have queued an orb via call_deferred before rewind.
	for orb in get_tree().get_nodes_in_group("xp_orbs"):
		orb.queue_free()
	for field in PLAYER_FIELDS:
		player.set(field, snapshot.player[field])
	player.global_position = snapshot.position
	player.health = clampf(player.health, 1.0, player.max_health)
	player.passives = snapshot.passives.duplicate(true)
	player.pending_level_ups = 0
	for entry in snapshot.weapons:
		player.add_weapon(entry.id)
		var equipped: Dictionary = player.weapons[-1]
		equipped.level = int(entry.level)
		equipped.node.configure(entry.id, int(entry.level))
		restore_timers(equipped.node, entry.timers)
	if player.auto_collect_orbs:
		player._enable_auto_collect()
		player._auto_collect_timer.start(maxf(float(snapshot.get("auto_collect_left", 15.0)), 0.001))
		player._auto_collect_timer.wait_time = 15.0
	elif is_instance_valid(player._auto_collect_timer):
		player._auto_collect_timer.stop()
	for field in SPAWNER_FIELDS:
		var value: Variant = snapshot.spawner[field]
		spawner.set(field, value.duplicate(true) if value is Array else value)
	restore_timers(spawner, snapshot.spawner.timers)
	for entry in snapshot.enemies:
		var enemy: Enemy = Pool.acquire(load("res://enemy.tscn"))
		scene.add_child(enemy)
		enemy.configure(entry.id, entry.difficulty, player)
		enemy.global_position = entry.position
		enemy.health = entry.health
		enemy._jumping = entry.jumping
		enemy._jump_direction = entry.direction
		restore_timers(enemy, entry.timers)
	for entry in snapshot.orbs:
		var orb := load("res://xp_orb.tscn").instantiate() as XPOrb
		orb.position = entry.position
		orb.xp_value = int(entry.xp)
		scene.add_child(orb)
	var phase: Dictionary = spawner._phases[spawner._phase_index]
	spawner.phase_changed.emit(phase.name, spawner._phase_index + 1, spawner._phases.size() + 1)
	if is_instance_valid(scene.landscape): scene.landscape.refresh()
	restoring = false
	return true
