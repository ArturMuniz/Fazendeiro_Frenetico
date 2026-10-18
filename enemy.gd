extends CharacterBody2D
class_name Enemy

## Inimigo genérico: o comportamento (perseguir, pular, atirar...)
## é decidido pelo campo "behavior" do EnemyDB, configurado via
## configure(id, difficulty_multiplier) logo após o spawn.
##
## O difficulty_multiplier vem do spawner e cresce com o tempo de
## run — é o que evita que os inimigos "fiquem fracos" depois de um
## tempo, já que o jogador só fica mais forte (armas, fusão, passivos).
##
## Reaproveitado via Pool em vez de destruído a cada morte (ver die()).

const POOL_SCENE_PATH: String = "res://enemy.tscn"
const XP_ORB_SCENE: PackedScene = preload("res://xp_orb.tscn")
const ENEMY_PROJECTILE_SCENE: PackedScene = preload("res://enemy_projectile.tscn")
const DAMAGE_NUMBER_SCENE: PackedScene = preload("res://damage_number.tscn")

var enemy_id: String = ""
var behavior: String = "runner"
var speed: float = 60.0
var max_health: float = 10.0
var contact_damage: float = 5.0
var xp_value: int = 1

var health: float
var _player: Node2D
var _touching_player: bool = false
var _despawning: bool = false
var _return_pending: bool = false
var _landing_timer: Timer

@onready var sprite: Sprite2D = $Sprite2D
@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var damage_timer: Timer = $DamageTimer
@onready var frame_timer: Timer = $FrameTimer

var _frames: Array = []
var _frame_index: int = 0
var art_animator: SpriteAnimator
var _visual_origin: Vector2 = Vector2.ZERO

# Estado usado por "jumper" e pelo boss "boss_leaper"
var _jump_speed: float = 250.0
var _jump_duration: float = 0.3
var _jumping: bool = false
var _jump_direction: Vector2 = Vector2.ZERO
var _impact_radius: float = 60.0
var _impact_damage: float = 15.0

# Estado usado por "shooter" e pelo boss "boss_ranged"
var _preferred_range: float = 180.0
var _shoot_damage: float = 4.0

# Estado usado pelos 3 bosses (quando têm ataque à distância)
var _burst_count: int = 0
var _burst_damage: float = 8.0

# Compartilhado por "shooter" e pelos bosses com projétil
var _enemy_projectile_speed: float = 200.0


func _ready() -> void:
	art_animator = SpriteAnimator.new()
	add_child(art_animator)
	body_shape.shape = body_shape.shape.duplicate()
	hitbox_shape.shape = hitbox_shape.shape.duplicate()
	_landing_timer = Timer.new()
	_landing_timer.name = "LandingTimer"
	_landing_timer.one_shot = true
	add_child(_landing_timer)
	_landing_timer.timeout.connect(_on_jump_landed)
	damage_timer.timeout.connect(_on_damage_timer_timeout)


## Chamado pelo spawner logo após add_child, define o arquétipo.
## difficulty_multiplier escala HP e dano conforme o tempo de run.
## Também serve como "reset" quando o inimigo vem reaproveitado do
## Pool — por isso reconfigura estado transitório e alvo a cada utilização.
## O grupo é removido explicitamente na desativação.
func configure(id: String, difficulty_multiplier: float = 1.0, target: Node2D = null) -> void:
	_player = target if is_instance_valid(target) else get_tree().get_first_node_in_group("player")
	velocity = Vector2.ZERO
	_jump_direction = Vector2.ZERO
	_return_pending = false
	_frames.clear()
	_frame_index = 0
	sprite.flip_h = false
	sprite.position = _visual_origin
	_burst_count = 0
	_landing_timer.stop()
	frame_timer.stop()
	body_shape.set_deferred("disabled", false)
	hitbox_shape.set_deferred("disabled", false)
	visible = true
	set_physics_process(true)
	add_to_group("enemies")
	_touching_player = false
	_jumping = false
	_despawning = false
	damage_timer.stop()

	enemy_id = id
	var data: Dictionary = EnemyDB.ENEMIES[id]

	behavior = data["behavior"]
	speed = data["speed"]
	max_health = data["health"] * difficulty_multiplier
	health = max_health
	contact_damage = data["contact_damage"] * difficulty_multiplier
	xp_value = data["xp_value"]

	var visual_scale: float = data.get("scale", 0.5)
	art_animator.configure(id, sprite)

	(body_shape.shape as CircleShape2D).radius = 14.0 * visual_scale
	(hitbox_shape.shape as CircleShape2D).radius = 16.0 * visual_scale

	$JumpTimer.stop()
	$ShootTimer.stop()
	$BurstTimer.stop()

	match behavior:
		"jumper":
			_setup_jumper(data, difficulty_multiplier)
		"shooter":
			_setup_shooter(data, difficulty_multiplier)
		"boss_leaper":
			_setup_jumper(data, difficulty_multiplier)
			_setup_boss(data, difficulty_multiplier)
		"boss_ranged":
			_setup_shooter(data, difficulty_multiplier)
			_setup_boss(data, difficulty_multiplier)
		"boss_brute":
			_setup_boss(data, difficulty_multiplier)


func _physics_process(_delta: float) -> void:
	if _despawning or not is_instance_valid(_player):
		velocity = Vector2.ZERO
		return

	match behavior:
		"jumper", "boss_leaper":
			_process_jumper()
		"shooter", "boss_ranged":
			_process_shooter()
		_:
			_move_toward_player()
	var next := "walk" if velocity.length() > 1 else "idle"
	if _jumping:
		next = "jump"
	elif behavior in ["jumper", "boss_leaper"] and $JumpTimer.time_left > 0 and $JumpTimer.time_left < 0.2:
		next = "anticipate"
	art_animator.play(next)
	# Arc is visual only: physics, contact damage and the landing instant stay intact.
	var progress := clampf(1.0 - _landing_timer.time_left / _jump_duration, 0.0, 1.0) if _jumping else 0.0
	sprite.position = _visual_origin + Vector2(0, -sin(progress * PI) * (22.0 if behavior == "boss_leaper" else 9.0))


func _move_toward_player() -> void:
	var direction: Vector2 = (_player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	_update_facing(direction)


## Vira o sprite pra encarar a direção pra onde o inimigo está indo
## (ou o jogador, no caso do atirador) — mesmo truque de flip
## horizontal usado no personagem.
func _update_facing(direction: Vector2) -> void:
	if direction.x > 0.05:
		sprite.flip_h = false
	elif direction.x < -0.05:
		sprite.flip_h = true


# --- Gafanhoto Saltador / Gafanhoto Gigante (boss): pulos curtos ---

func _setup_jumper(data: Dictionary, multiplier: float = 1.0) -> void:
	_jump_speed = data.get("jump_speed", 250.0)
	_jump_duration = data.get("jump_duration", 0.3)
	_impact_radius = data.get("impact_radius", 60.0)
	_impact_damage = data.get("impact_damage", data.get("contact_damage", 10.0)) * multiplier
	var jump_timer: Timer = $JumpTimer
	jump_timer.wait_time = data.get("jump_interval", 1.5)
	if not jump_timer.timeout.is_connected(_on_jump_timer_timeout):
		jump_timer.timeout.connect(_on_jump_timer_timeout)
	jump_timer.start()


func _on_jump_timer_timeout() -> void:
	if _despawning or not is_instance_valid(_player) or get_tree().paused:
		return
	_jumping = true
	art_animator.play("jump", true)
	_jump_direction = (_player.global_position - global_position).normalized()
	_update_facing(_jump_direction)
	_landing_timer.start(_jump_duration)


func _on_jump_landed() -> void:
	if _despawning or not is_instance_valid(_player):
		return
	_jumping = false
	sprite.position = _visual_origin
	art_animator.once("land")
	# Só o boss "Gafanhoto Gigante" causa dano de área ao pousar.
	if behavior == "boss_leaper":
		var dist: float = global_position.distance_to(_player.global_position)
		if dist <= _impact_radius:
			_deal_contact_damage(_player, _impact_damage)


func _process_jumper() -> void:
	if _jumping:
		velocity = _jump_direction * _jump_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


# --- Mosca Atiradora / Rainha das Moscas (boss): mantém distância ---

func _setup_shooter(data: Dictionary, multiplier: float = 1.0) -> void:
	_preferred_range = data.get("preferred_range", 180.0)
	_shoot_damage = data.get("shoot_damage", 4.0) * multiplier
	_enemy_projectile_speed = data.get("projectile_speed", 200.0)
	var shoot_timer: Timer = $ShootTimer
	shoot_timer.wait_time = data.get("shoot_interval", 2.0)
	if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.start()


func _process_shooter() -> void:
	var to_player: Vector2 = _player.global_position - global_position
	var dist: float = to_player.length()

	_update_facing(to_player)

	if dist > _preferred_range + 20.0:
		velocity = to_player.normalized() * speed
	elif dist < _preferred_range - 20.0:
		velocity = -to_player.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	if _despawning or not is_instance_valid(_player) or get_tree().paused:
		return
	art_animator.once("attack")
	var projectile: EnemyProjectile = Pool.acquire(ENEMY_PROJECTILE_SCENE)
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = (_player.global_position - global_position).normalized()
	projectile.global_position = global_position
	projectile.setup(direction, _enemy_projectile_speed, _shoot_damage)


# --- Ataque à distância em rajada, usado pelos bosses ranged/leaper ---
# (o boss_brute chama isso também, mas com burst_count=0 -> não atira)

func _setup_boss(data: Dictionary, multiplier: float = 1.0) -> void:
	_burst_count = data.get("burst_count", 0)
	_burst_damage = data.get("burst_damage", 8.0) * multiplier
	_enemy_projectile_speed = data.get("projectile_speed", 180.0)

	if _burst_count <= 0:
		return

	var burst_timer: Timer = $BurstTimer
	burst_timer.wait_time = data.get("burst_interval", 3.0)
	if not burst_timer.timeout.is_connected(_on_burst_timer_timeout):
		burst_timer.timeout.connect(_on_burst_timer_timeout)
	burst_timer.start()


func _on_burst_timer_timeout() -> void:
	if _despawning or not is_instance_valid(_player) or get_tree().paused:
		return
	art_animator.once("attack")
	for i in range(_burst_count):
		var angle: float = (TAU / _burst_count) * i
		var direction: Vector2 = Vector2(cos(angle), sin(angle))
		var projectile: EnemyProjectile = Pool.acquire(ENEMY_PROJECTILE_SCENE)
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.setup(direction, _enemy_projectile_speed, _burst_damage)


# --- Dano, morte e contato (igual para todos os arquétipos) ---

func take_damage(amount: float) -> void:
	if _despawning:
		return
	health -= amount
	art_animator.flash()
	_spawn_damage_number(amount)
	AudioManager.play_sfx("hit")
	if health <= 0.0:
		die()


func _spawn_damage_number(amount: float) -> void:
	var number: DamageNumber = Pool.acquire(DAMAGE_NUMBER_SCENE)
	get_tree().current_scene.call_deferred("add_child", number)
	number.call_deferred("show_value", amount, global_position)


func die() -> void:
	if _despawning:
		return
	_despawning = true
	VisualFX.spawn(get_tree().current_scene, "death", global_position, sprite.flip_h, enemy_id)

	var is_boss: bool = enemy_id.begins_with("boss_")
	AudioManager.play_sfx("boss_death" if is_boss else "enemy_death")

	if is_instance_valid(_player) and _player.has_method("register_kill"):
		_player.register_kill(is_boss)

	var orb: XPOrb = XP_ORB_SCENE.instantiate()
	orb.global_position = global_position
	orb.xp_value = xp_value
	get_tree().current_scene.call_deferred("add_child", orb)

	_despawn()


## Tira o inimigo de cena e devolve pro Pool, em vez de destruir.
## Deferido porque die() quase sempre é chamado durante o processamento
## de física (colisão de projétil), e mexer na árvore nesse momento
## dá o erro "flushing queries" do motor de física.
func _despawn() -> void:
	if _return_pending:
		return
	_return_pending = true
	_despawning = true
	remove_from_group("enemies")
	_touching_player = false
	_jumping = false
	velocity = Vector2.ZERO
	_landing_timer.stop()
	body_shape.set_deferred("disabled", true)
	hitbox_shape.set_deferred("disabled", true)
	visible = false
	set_physics_process(false)
	damage_timer.stop()
	$JumpTimer.stop()
	$ShootTimer.stop()
	$BurstTimer.stop()
	frame_timer.stop()
	call_deferred("_return_to_pool")


func _return_to_pool() -> void:
	_player = null
	if get_parent() != null:
		get_parent().remove_child(self)
	Pool.release(load(POOL_SCENE_PATH), self)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if _despawning or get_tree().paused:
		return
	if body.is_in_group("player"):
		_touching_player = true
		_deal_contact_damage(body)
		damage_timer.start()


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_touching_player = false
		damage_timer.stop()


func _on_damage_timer_timeout() -> void:
	if not _despawning and _touching_player and is_instance_valid(_player):
		_deal_contact_damage(_player)


## amount < 0 usa o contact_damage padrão; usado com valor explícito
## pelo impacto de pouso do Gafanhoto Gigante.
func _deal_contact_damage(body: Node2D, amount: float = -1.0) -> void:
	if _despawning or get_tree().paused or not is_instance_valid(body):
		return
	var dmg: float = amount if amount >= 0.0 else contact_damage
	if body.has_method("take_damage"):
		body.take_damage(dmg)


func _on_frame_timer_timeout() -> void:
	if _frames.size() <= 1:
		return
	_frame_index = (_frame_index + 1) % _frames.size()
	sprite.texture = _frames[_frame_index]
