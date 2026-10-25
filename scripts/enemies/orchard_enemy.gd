extends CharacterBody2D
## Three illustrated orchard species with locked attacks and safe spawn leashes.
signal defeated
signal combat_feedback(kind: String, strength: float)
const Generated = preload("res://scripts/companions/generated_animation.gd")
const SPECIES := ["thornrunner", "sporespitter", "lantern_moth"]
const SIZES := [0.22, 0.20, 0.18]
const SEED_ART := "res://assets/runtime/chapter02/mossjaw/LATE-001_seed_pod.png"
@export_range(0, 2) var variant: int = 0
@export var active: bool = true
@export var leash: float = 100.0
var player: Node2D
var health: int = 3
var state := "idle"
var state_time := 0.0
var direction := -1.0
var attack_landed := false
var flash := 0.0
var spawn_position: Vector2
var floor_y := 620.0
var locked_target: Vector2
var sprite: AnimatedSprite2D
var pack := ""
var projectiles: Array[Dictionary] = []
var clock := 0.0
var art_ready := false
var narrative_frozen := false
var defeat_emitted := false
var engaged := false
var state_duration := 0.0
var projectile_epoch := 0

func _ready() -> void:
	variant = clampi(variant,0,2)
	spawn_position = global_position
	floor_y = spawn_position.y
	health = [3,4,2][variant]
	pack = "res://assets/runtime/chapter02/enemies/%s/manifest.json" % SPECIES[variant]
	collision_layer = 4
	collision_mask = 1
	process_mode = Node.PROCESS_MODE_PAUSABLE
	var body := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(40,65) if variant != 2 else Vector2(36,46)
	body.shape = rectangle
	body.position.y = -rectangle.size.y*0.5
	add_child(body)
	sprite = AnimatedSprite2D.new()
	sprite.centered = false
	sprite.offset = Vector2(-256,-460)
	sprite.scale = Vector2.ONE * SIZES[variant]
	add_child(sprite)
	# Missing production art must never silently substitute a different creature.
	if FileAccess.file_exists(pack):
		sprite.sprite_frames = Generated.frames_from_manifest(pack)
		art_ready = sprite.sprite_frames.has_animation("idle")
	if art_ready:
		sprite.animation = "idle"
		sprite.stop()
		add_to_group("enemies")
	else:
		collision_layer = 0
	if variant == 2: global_position.y = floor_y-120

func _enter(next_state: String, duration: float) -> void:
	state = next_state
	state_time = duration
	state_duration = duration
	velocity = Vector2.ZERO
	if next_state == "telegraph":
		direction = -1.0 if player.global_position.x < global_position.x else 1.0
		# Lock the player's body, not the floor. The shot never homes after release.
		locked_target = player.global_position + Vector2(0, -30)
		if variant == 2:
			locked_target.x = clampf(locked_target.x, spawn_position.x - _air_leash(), spawn_position.x + _air_leash())
			locked_target.y = clampf(locked_target.y, floor_y - 100, floor_y - 18)
		attack_landed = false
	elif next_state == "attack":
		get_tree().call_group("prologue_presentation", "cue", "enemy_attack", global_position)
		if variant == 1: _fire_seed()
	_update_visual()

func _air_leash() -> float:
	# The authored ground leash must not truncate a moth's advertised dive.
	return maxf(leash, 340.0)

func get_hurt_rect() -> Rect2:
	# World-space silhouette used by the sword, including low-flying moths.
	var size := Vector2(82, 84) if variant != 2 else Vector2(86, 70)
	return Rect2(global_position - Vector2(size.x * 0.5, size.y), size)

func _physics_process(delta: float) -> void:
	if state == "defeated":
		state_time -= delta
		if state_time <= 0: queue_free()
		return
	if not art_ready: return
	if not is_instance_valid(player): player = get_tree().get_first_node_in_group("player")
	var narrative: bool = not is_instance_valid(player) or not bool(player.get("active"))
	if not active or narrative:
		sprite.pause()
		narrative_frozen = true
		if not active: _clear_projectiles()
		queue_redraw()
		return
	var offset: Vector2 = player.global_position-global_position
	engaged = absf(offset.x)<600 and absf(player.global_position.y-floor_y)<230
	if not engaged and state == "idle" and projectiles.is_empty():
		sprite.stop()
		return
	if narrative_frozen:
		narrative_frozen = false
		_update_visual()
	clock += delta
	flash = maxf(0,flash-delta)
	state_time = maxf(0,state_time-delta)
	_update_projectiles(delta)
	# Damage callbacks can synchronously end or reset the room.
	if not active or is_queued_for_deletion() or not is_instance_valid(player) or not bool(player.get("active")):
		return
	match state:
		"idle":
			velocity.x = 0
			if variant == 2:
				global_position.y = move_toward(global_position.y,floor_y-120+sin(clock*2.2)*10,90*delta)
			if engaged and state_time <= 0:
				var reach := 400.0 if variant == 1 else (330.0 if variant == 2 else 135.0)
				if absf(offset.x)<reach:
					_enter("telegraph",0.7 if variant != 2 else 0.9)
				elif variant == 0:
					direction = signf(offset.x)
					velocity.x = direction * 90
				elif variant == 2:
					direction = signf(offset.x)
					global_position.x = move_toward(global_position.x, clampf(player.global_position.x, spawn_position.x - _air_leash(), spawn_position.x + _air_leash()), 110 * delta)
		"telegraph":
			if state_time <= 0: _enter("attack",0.5 if variant == 0 else (0.48 if variant == 1 else 0.85))
		"attack":
			if variant == 0:
				velocity.x = direction * 360
				if offset.x * direction > -30 and absf(offset.x) < 72 and absf(offset.y) < 78: _hit_player(28)
			elif variant == 2:
				# Aim is fixed at wind-up; Tavi can evade and counter at floor height.
				global_position = global_position.move_toward(locked_target + Vector2(0, 25), 460 * delta)
				if (player.global_position + Vector2(0, -28)).distance_to(global_position + Vector2(0, -32)) < 55: _hit_player(25)
			if state_time <= 0: _enter("recover",1.3 if variant != 2 else 1.5)
		"recover":
			# Moth remains low for a generous sword vulnerability window.
			if state_time <= 0: _enter("idle",0.8 if variant != 1 else 1.4)
		"hurt":
			velocity.x = move_toward(velocity.x,0,900*delta)
			if state_time <= 0: _enter("recover",0.7)
	if variant != 2:
		_safe_ground_motion(delta)
	else:
		global_position.x = clampf(global_position.x, spawn_position.x - _air_leash(), spawn_position.x + _air_leash())
	_update_visual()

func _safe_ground_motion(delta: float) -> void:
	var edge := global_position.x+signf(velocity.x)*34
	if (edge<spawn_position.x-leash and velocity.x<0) or (edge>spawn_position.x+leash and velocity.x>0): velocity.x = 0
	if absf(velocity.x)>0.1:
		var ray := PhysicsRayQueryParameters2D.create(Vector2(edge,global_position.y-30),Vector2(edge,global_position.y+65),1)
		if get_world_2d().direct_space_state.intersect_ray(ray).is_empty(): velocity.x = 0
	velocity.y = minf(velocity.y+1600*delta,700)
	move_and_slide()
	global_position.x = clampf(global_position.x,spawn_position.x-leash,spawn_position.x+leash)
	if global_position.y>floor_y+80:
		global_position = spawn_position
		velocity = Vector2.ZERO

func _fire_seed() -> void:
	if not ResourceLoader.exists(SEED_ART): return
	var art := Sprite2D.new()
	art.texture = load(SEED_ART)
	art.scale = Vector2.ONE*26/maxf(1,art.texture.get_height())
	add_child(art)
	var muzzle_reach := minf(30.0, absf(locked_target.x - global_position.x) * 0.35)
	var at := global_position + Vector2(direction * muzzle_reach, -65)
	art.global_position = at
	# Solve the launch velocity for this locked target and gravity. This reaches
	# Tavi's body at the chosen flight time instead of firing a random low arc.
	var flight := clampf(absf(locked_target.x - at.x) / 420.0, 0.55, 0.9)
	var launch := (locked_target - at) / flight - Vector2(0, 0.5 * 400.0 * flight)
	projectiles.append({"position": at, "velocity": launch, "life": 2.5, "sprite": art})

func _update_projectiles(delta: float) -> void:
	# Detach the batch before any damage callback: dying can synchronously
	# clear this enemy's projectiles or free the whole encounter.
	var batch: Array[Dictionary] = projectiles
	projectiles = []
	var epoch := projectile_epoch
	for shot in batch:
		if epoch != projectile_epoch or is_queued_for_deletion() or not active or not is_instance_valid(player):
			_dispose_shot(shot)
			continue
		if not is_instance_valid(shot.sprite): continue
		var before: Vector2 = shot.position
		var old_velocity: Vector2 = shot.velocity
		shot.position += old_velocity * delta + Vector2(0, 200.0 * delta * delta)
		shot.velocity += Vector2(0, 400.0 * delta)
		shot.life -= delta
		shot.sprite.global_position = shot.position
		shot.sprite.rotation += delta * 4
		var ray := PhysicsRayQueryParameters2D.create(before, shot.position, 1)
		var blocked := not get_world_2d().direct_space_state.intersect_ray(ray).is_empty()
		var body := player.global_position + Vector2(0, -30)
		var nearest := Geometry2D.get_closest_point_to_segment(body, before, shot.position)
		var hit := nearest.distance_to(body) < 28
		if hit:
			_dispose_shot(shot)
			_hit_player(26)
		elif blocked or shot.life <= 0:
			_dispose_shot(shot)
		else:
			projectiles.append(shot)

func _dispose_shot(shot: Dictionary) -> void:
	if is_instance_valid(shot.get("sprite")) and not shot.sprite.is_queued_for_deletion():
		shot.sprite.queue_free()

func _hit_player(amount: int) -> void:
	if attack_landed or not is_instance_valid(player): return
	attack_landed = true
	combat_feedback.emit("enemy_strike", 0.28)
	player.take_damage(amount,-1.0 if player.global_position.x<global_position.x else 1.0)

func _clear_projectiles() -> void:
	projectile_epoch += 1
	for shot in projectiles: _dispose_shot(shot)
	projectiles.clear()

func _update_visual() -> void:
	if not art_ready: return
	var clip := "idle"
	if state in ["telegraph", "attack", "recover"]: clip = "attack"
	elif state in ["hurt", "defeated"]: clip = "hurt" if state == "hurt" else "defeat"
	elif absf(velocity.x) > 5 or (variant == 2 and state == "idle"): clip = "move"
	if not sprite.sprite_frames.has_animation(clip): clip = "idle"
	if sprite.animation != clip: sprite.play(clip)
	# These poses are driven by combat phase, so an attack always reaches its
	# actual strike art even when the preceding windup held the same clip.
	if state in ["telegraph", "attack", "recover"]:
		sprite.pause()
		var pose := 0 if state == "telegraph" else (1 if state == "attack" else 2)
		sprite.frame = mini(pose, sprite.sprite_frames.get_frame_count(clip) - 1)
	elif state in ["hurt", "defeated"]:
		sprite.pause()
		sprite.frame = 0
	elif not sprite.is_playing():
		sprite.play()
	var progress := 1.0 - state_time / maxf(state_duration, 0.001)
	var squash := Vector2.ONE
	sprite.position = Vector2.ZERO
	sprite.rotation = 0
	match state:
		"telegraph":
			squash = Vector2(1.0 + progress * 0.06, 1.0 - progress * 0.08)
			sprite.position.x = -direction * 7 * progress
			if variant == 2: sprite.position.y = -sin(progress * PI) * 12
		"attack":
			squash = Vector2(1.06, 0.96)
			sprite.position.x = direction * sin(progress * PI) * 9
			if variant == 1: sprite.rotation = -direction * sin(progress * PI) * 0.08
		"recover":
			squash = Vector2(1.0, 0.95 + 0.05 * progress)
		"hurt":
			sprite.rotation = direction * sin(progress * PI) * 0.12
		"defeated":
			sprite.position.y = progress * 18
			sprite.modulate.a = 1.0 - progress
	sprite.scale = Vector2(direction * SIZES[variant], SIZES[variant]) * squash
	var tint := Color(1.25, 1.15, 1.0) if flash > 0 or state == "telegraph" else Color.WHITE
	tint.a = 1.0 - progress if state == "defeated" else 1.0
	sprite.modulate = tint
	queue_redraw()

func take_damage(amount: int, hit_direction: float = 1.0) -> void:
	if state=="defeated" or defeat_emitted or not active or not art_ready or amount<=0 or flash>0: return
	health = maxi(0,health-amount)
	flash = 0.22
	combat_feedback.emit("enemy_hit", 0.18)
	get_tree().call_group("prologue_presentation","cue","impact",global_position)
	if health<=0:
		defeat_emitted = true
		_clear_projectiles()
		if is_in_group("enemies"): remove_from_group("enemies")
		collision_layer = 0
		_enter("defeated",0.7)
		defeated.emit()
		get_tree().call_group("prologue_presentation","cue","enemy_defeat",global_position)
	else:
		_enter("hurt",0.4)
		velocity.x = hit_direction*100

func _exit_tree() -> void:
	_clear_projectiles()

func _draw() -> void:
	if not active or narrative_frozen or not engaged or state != "telegraph": return
	# The filling arc communicates time-to-strike without recoloring the creature.
	var progress := clampf(1.0 - state_time / maxf(state_duration, 0.001), 0.0, 1.0)
	var center := Vector2(0, -100 if variant != 2 else -87)
	var gold := Color(1.0, 0.84, 0.55, 0.85)
	draw_arc(center, 13, PI, TAU, 20, Color(1, 0.84, 0.55, 0.2), 2, true)
	if progress > 0.01:
		draw_arc(center, 13, PI, PI + progress * PI, 20, gold, 2.5, true)
	# Direction stays fixed with the locked aim; the warning never follows Tavi.
	var tip := center + Vector2(direction * 5, 7)
	draw_line(tip - Vector2(direction * 5, 4), tip, gold, 2, true)
	draw_line(tip - Vector2(direction * 5, -4), tip, gold, 2, true)
