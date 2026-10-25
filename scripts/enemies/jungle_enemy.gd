extends CharacterBody2D
## Generated Sporeling ranged caster and Brambleguard heavy melee enemy.
## Attacks lock facing during anticipation, hit once, and allow recovery.
signal defeated
const Generated = preload("res://scripts/companions/generated_animation.gd")
@export_enum("sporeling", "brambleguard") var variant: String = "sporeling"
@export var patrol_min: float = 0.0
@export var patrol_max: float = 0.0
@export var active: bool = true
var player: Node2D
var health: int = 3
var attack_damage: int = 18
var direction: float = -1.0
var state := "idle"
var state_time := 0.0
var attack_landed := false
var flash := 0.0
var sprite: AnimatedSprite2D
var spawn_position: Vector2
var projectiles: Array[Dictionary] = []
var size := 0.22
var pack: String
var projectile_epoch := 0

func _ready() -> void:
	spawn_position = global_position
	if patrol_min == 0 and patrol_max == 0:
		patrol_min = global_position.x - 180
		patrol_max = global_position.x + 180
	size = 0.30 if variant == "brambleguard" else 0.22
	attack_damage = 35 if variant == "brambleguard" else 18
	pack = "res://assets/runtime/chapter01/enemies/%s/manifest.json" % variant
	collision_layer = 4
	collision_mask = 1
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(50, 92) if variant == "brambleguard" else Vector2(40, 65)
	shape.shape = rect
	shape.position.y = -rect.size.y / 2
	add_child(shape)
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Generated.frames_from_manifest(pack)
	sprite.centered = false
	sprite.offset = Vector2(-256, -480)
	sprite.scale = Vector2.ONE * size
	add_child(sprite)
	reset_encounter()

func reset_encounter() -> void:
	global_position = spawn_position
	collision_layer = 4
	health = 5 if variant == "brambleguard" else 3
	state = "idle"
	state_time = 0
	flash = 0
	velocity = Vector2.ZERO
	_clear_projectiles()
	visible = true
	if not is_in_group("enemies"): add_to_group("enemies")
	if sprite:
		sprite.play("idle")
		_update_animation()
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not active:
		_clear_projectiles()
		queue_redraw()
		return
	if state == "defeated": return
	if not is_instance_valid(player): player = get_tree().get_first_node_in_group("player")
	var engaged: bool = is_instance_valid(player) and player.active
	# Narrative/pause inactivity must not leave invisible travelling hazards.
	if not engaged:
		_clear_projectiles()
		state = "idle"
		velocity.x = 0
	else:
		_update_projectiles(delta)
		if not active or not is_instance_valid(player) or not player.active:
			return
	state_time = maxf(0, state_time - delta)
	flash = maxf(0, flash - delta)
	if engaged:
		var offset: Vector2 = player.global_position - global_position
		match state:
			"idle":
				velocity.x = 0
				if absf(offset.x) < 520 and absf(offset.y) < 140: state = "approach"
			"approach":
				direction = -1.0 if offset.x < 0 else 1.0
				var reach := 350.0 if variant == "sporeling" else 125.0
				velocity.x = direction * (35 if variant == "sporeling" else 48)
				if absf(offset.x) <= reach and absf(offset.y) < 80 and player.invincible <= 0:
					state = "telegraph"
					state_time = 1.0 if variant == "sporeling" else 1.15
					velocity.x = 0
			"telegraph":
				velocity.x = 0
				if state_time <= 0: _release_attack()
			"attack":
				velocity.x = direction * 120 if variant == "brambleguard" else 0
				if variant == "brambleguard" and not attack_landed and absf(offset.x) < 125 and absf(offset.y) < 65 and offset.x * direction > -12:
					player.take_damage(attack_damage, direction)
					attack_landed = true
				if state_time <= 0:
					state = "recovery"
					state_time = 1.2 if variant == "brambleguard" else 1.5
			"recovery", "hurt":
				velocity.x = move_toward(velocity.x, 0, delta * 900)
				if state_time <= 0: state = "approach"
	if global_position.x <= patrol_min and velocity.x < 0: velocity.x = 0
	if global_position.x >= patrol_max and velocity.x > 0: velocity.x = 0
	velocity.y += 1600 * delta
	move_and_slide()
	_update_animation()
	queue_redraw()

func _release_attack() -> void:
	state = "attack"
	state_time = 0.32
	attack_landed = false
	get_tree().call_group("prologue_presentation", "cue", "enemy_attack", global_position)
	if variant == "sporeling":
		projectiles.append({"position": global_position + Vector2(direction * 32, -42), "velocity": Vector2(direction * 230, 0), "life": 2.6})

func _clear_projectiles() -> void:
	projectile_epoch += 1
	projectiles.clear()

func _update_projectiles(delta: float) -> void:
	# A hit may synchronously reset the room. Detached shots must never survive it.
	var batch: Array[Dictionary] = projectiles
	projectiles = []
	var epoch := projectile_epoch
	for shot in batch:
		if epoch != projectile_epoch or not active or not is_instance_valid(player) or not player.active:
			continue
		var before: Vector2 = shot.position
		shot.position += shot.velocity * delta
		shot.life -= delta
		var ray := PhysicsRayQueryParameters2D.create(before, shot.position, 1)
		var blocked := not get_world_2d().direct_space_state.intersect_ray(ray).is_empty()
		var body := player.global_position + Vector2(0, -30)
		var nearest := Geometry2D.get_closest_point_to_segment(body, before, shot.position)
		var hit := nearest.distance_to(body) < 28
		if hit and not blocked: player.take_damage(attack_damage, signf(shot.velocity.x))
		if not hit and not blocked and shot.life > 0 and epoch == projectile_epoch:
			projectiles.append(shot)

func _update_animation() -> void:
	var clip := "idle"
	if state == "hurt": clip = "hurt"
	elif state in ["telegraph", "attack", "recovery"]: clip = "attack"
	elif absf(velocity.x) > 5: clip = "move"
	sprite.play(clip)
	if state == "telegraph":
		var duration := 1.0 if variant == "sporeling" else 1.15
		sprite.set_frame_and_progress(clampi(int((1 - state_time / duration) * 3), 0, 2), 0)
		sprite.pause()
	elif state == "attack":
		sprite.speed_scale = 1.0
		sprite.set_frame_and_progress(3 if state_time > 0.16 else 4, 0)
		sprite.pause()
	elif state == "recovery":
		sprite.set_frame_and_progress(5, 0)
		sprite.pause()
	else: sprite.speed_scale = 2.0 if state == "hurt" else 1.0
	# Animate the artwork only: the feet and damage geometry remain fixed.
	var stretch := Vector2.ONE
	sprite.position = Vector2.ZERO
	sprite.rotation = 0
	if state == "telegraph":
		var duration := 1.0 if variant == "sporeling" else 1.15
		var progress := clampf(1.0 - state_time / duration, 0.0, 1.0)
		stretch = Vector2(1.0 + progress * 0.05, 1.0 - progress * 0.06)
		sprite.position.x = -direction * progress * 7
	elif state == "attack":
		var progress := clampf(1.0 - state_time / 0.32, 0.0, 1.0)
		stretch = Vector2(1.06, 0.96)
		sprite.position.x = direction * sin(progress * PI) * 8
	elif state == "recovery":
		var duration := 1.2 if variant == "brambleguard" else 1.5
		var remaining := clampf(state_time / duration, 0.0, 1.0)
		stretch.y = 1.0 - remaining * 0.05
	elif state == "hurt":
		sprite.rotation = -direction * sin(clampf(state_time / 0.5, 0, 1) * PI) * 0.09
	sprite.scale = Vector2(size * direction, size) * stretch
	sprite.modulate = Color(1.4, 1.2, 1.0) if flash > 0 else Color.WHITE

func take_damage(amount: int, hit_direction: float) -> void:
	if state == "defeated" or amount <= 0: return
	health -= amount
	flash = 0.2
	state = "hurt"
	state_time = 0.5
	velocity.x = hit_direction * 160
	get_tree().call_group("prologue_presentation", "cue", "impact", global_position)
	if health <= 0:
		state = "defeated"
		collision_layer = 0
		_clear_projectiles()
		remove_from_group("enemies")
		Generated.one_shot(get_parent(), global_position, pack, "defeat", size, Vector2(256, 480), direction)
		get_tree().call_group("prologue_presentation", "cue", "enemy_defeat", global_position)
		visible = false
		defeated.emit()
		queue_redraw()

func _draw() -> void:
	if state == "telegraph":
		var duration := 1.0 if variant == "sporeling" else 1.15
		var progress := clampf(1.0 - state_time / duration, 0, 1)
		var radius := 43.0 if variant == "sporeling" else 66.0
		draw_arc(Vector2(0, -30), radius, PI, TAU, 24, Color(1, 0.84, 0.55, 0.18), 2, true)
		if progress > 0.01:
			draw_arc(Vector2(0, -30), radius, PI, PI + PI * progress, 24, Color("ffd58c"), 3, true)
		draw_line(Vector2(0, -108), Vector2(0, -91), Color("ffd58c"), 4)
		draw_circle(Vector2(0, -84), 2.5, Color("ffd58c"))
	for shot in projectiles:
		var at: Vector2 = to_local(shot.position)
		var travel: Vector2 = shot.velocity.normalized()
		draw_line(at - travel * 22, at, Color(1.0, 0.72, 0.3, 0.3), 5, true)
		draw_circle(at, 13, Color(1.0, 0.67, 0.15, 0.16))
		draw_circle(at, 7, Color("f7d370"))
		draw_circle(at + Vector2(-2, -2), 2, Color.WHITE)
