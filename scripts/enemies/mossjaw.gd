extends CharacterBody2D
## Briarwake guardian: readable attacks, open body hits and a definitive rescue.
signal health_changed(value: int)
signal phase_changed(value: int)
signal defeated
signal combat_feedback(kind: String, strength: float)

const Generated = preload("res://scripts/companions/generated_animation.gd")
const PACK := "res://assets/runtime/chapter02/mossjaw/manifest.json"
const FX_PACK := "res://assets/runtime/chapter01/presentation/manifest.json"
const ROOT_ART := "res://assets/runtime/chapter02/mossjaw/LATE-001_root_spike.png"
const SEED_ART := "res://assets/runtime/chapter02/mossjaw/LATE-001_seed_pod.png"
@export var max_health: int = 32
@export var arena_left: float = 5200.0
@export var arena_right: float = 6800.0
@export var floor_y: float = 620.0
var player: Node2D
var health: int = 32
var state: String = "dormant"
var direction: float = -1.0
var phase: int = 1
var state_time: float = 0.0
var clock: float = 0.0
var flash: float = 0.0
var attack_index: int = 0
var attack_count: int = 0
var attack_landed: bool = false
var sweep_radius: float = 0.0
var spawn_position: Vector2
var column_hits: int = 0
var freed_bindings: int = 0
var binding_exposed: bool = false
var sprite: AnimatedSprite2D
var eruption_x: float = 0.0
var projectiles: Array[Dictionary] = []
var root_sprites: Array[Sprite2D] = []
var volley_fired: bool = false
var combo_second: bool = false
var narrative_frozen: bool = false
var resume_animation: bool = false
var locked_target: Vector2
var state_duration: float = 0.0
var rush_second: bool = false
var hazard_epoch: int = 0

func _ready() -> void:
	spawn_position = global_position
	collision_layer = 4
	collision_mask = 1
	var body := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(120, 100)
	body.shape = rectangle
	body.position.y = -50
	add_child(body)
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Generated.frames_from_manifest(PACK)
	sprite.centered = false
	sprite.offset = Vector2(-280, -520)
	sprite.scale = Vector2(0.55, 0.55)
	add_child(sprite)
	reset_encounter()

func _clear_hazards() -> void:
	hazard_epoch += 1
	for shot in projectiles:
		if is_instance_valid(shot.get("sprite")): shot.sprite.queue_free()
	projectiles.clear()
	for root in root_sprites:
		if is_instance_valid(root): root.queue_free()
	root_sprites.clear()

func reset_encounter() -> void:
	_clear_hazards()
	global_position = spawn_position
	health = max_health
	state = "dormant"
	phase = 1
	state_time = 0.0
	clock = 0.0
	flash = 0.0
	attack_index = 0
	attack_count = 0
	rush_second = false
	locked_target = spawn_position
	narrative_frozen = false
	resume_animation = false
	attack_landed = false
	sweep_radius = 0.0
	column_hits = 0
	freed_bindings = 0
	binding_exposed = false
	velocity = Vector2.ZERO
	collision_layer = 4
	collision_mask = 1
	modulate = Color.WHITE
	if is_instance_valid(sprite):
		sprite.position = Vector2.ZERO
		sprite.rotation = 0.0
	if not is_in_group("enemies"): add_to_group("enemies")
	health_changed.emit(health)
	phase_changed.emit(phase)
	_update_visual()
	queue_redraw()

func activate() -> void:
	if state != "dormant": return
	if not is_instance_valid(player): player = get_tree().get_first_node_in_group("player")
	_enter("idle", 1.3)

func _enter(next_state: String, duration: float) -> void:
	state = next_state
	# Arena platforms remain traversable for Tavi; this large guardian's leap
	# follows its marked ground landing instead of catching on their undersides.
	collision_mask = 0 if next_state == "leap" else 1
	state_time = duration
	state_duration = duration
	if next_state == "leap_warning":
		# The marker must describe the reachable landing point, even when Tavi
		# stands beyond this jump's range. Lock once, before the warning starts.
		locked_target.x = clampf(locked_target.x, global_position.x - 360.0, global_position.x + 360.0)
		locked_target.x = clampf(locked_target.x, arena_left + 165.0, arena_right - 165.0)
		locked_target.y = floor_y
	velocity.x = 0.0
	attack_landed = false
	sweep_radius = 0.0
	volley_fired = false
	combo_second = false
	for root in root_sprites:
		if is_instance_valid(root): root.queue_free()
	root_sprites.clear()
	if next_state in ["sweep", "eruption"]:
		for side in ([-1.0, 1.0] if next_state == "sweep" else [0.0]):
			var root := _art_sprite(ROOT_ART, 110.0, true)
			root.position = Vector2(side * 20.0 if next_state == "sweep" else eruption_x - global_position.x, floor_y - global_position.y)
			root_sprites.append(root)
		_cue("boss_slam")
		combat_feedback.emit("root_impact", 0.65)
	elif next_state in ["charge", "claw", "volley"]: _cue("enemy_attack")
	if next_state == "leap":
		velocity = Vector2((locked_target.x - global_position.x) / 0.825, -660.0)
	elif next_state == "slam_impact":
		_cue("boss_slam")
		combat_feedback.emit("leap_impact", 1.0)
	elif next_state == "rush":
		_cue("enemy_attack")
		combat_feedback.emit("rush", 0.38)
	_update_visual()
	queue_redraw()

func _choose_attack() -> void:
	# Face and target lock before the warning; no tracking during an attack.
	direction = -1.0 if player.global_position.x < global_position.x else 1.0
	eruption_x = clampf(player.global_position.x, arena_left + 90.0, arena_right - 90.0)
	locked_target = player.global_position + Vector2(0, -30)
	locked_target.x = eruption_x
	rush_second = false
	attack_index += 1
	attack_count += 1
	var pattern: Array[String] = ["charge", "eruption", "claw", "leap", "volley", "sweep", "rush"]
	var choice := pattern[(attack_index - 1) % pattern.size()]
	if absf(player.global_position.x - global_position.x) < 190.0 and attack_index % 3 == 0:
		choice = "claw"
	_enter(choice + "_warning", 1.25 if phase == 1 else 1.0)

func _physics_process(delta: float) -> void:
	if state == "dormant": return
	if state == "defeated":
		modulate.a = maxf(0.0, modulate.a - delta * 0.22)
		return
	# Pause menus inherit process pause; narrative freezes the entire hazard simulation.
	if not is_instance_valid(player) or not player.get("active"):
		if not narrative_frozen:
			narrative_frozen = true
			resume_animation = sprite.is_playing()
			sprite.pause()
		return
	if narrative_frozen:
		narrative_frozen = false
		if resume_animation: sprite.play()
	clock += delta
	state_time = maxf(0.0, state_time - delta)
	flash = maxf(0.0, flash - delta)
	var frame_epoch := hazard_epoch
	_update_projectiles(delta)
	if frame_epoch != hazard_epoch or state in ["dormant", "defeated"]: return
	match state:
		"idle":
			if state_time <= 0.0: _choose_attack()
		"charge_warning", "sweep_warning", "eruption_warning", "volley_warning", "claw_warning", "leap_warning", "rush_warning":
			if state_time <= 0.0:
				var attack := state.trim_suffix("_warning")
				var durations := {"charge": 0.85, "sweep": 1.15, "eruption": 0.65, "volley": 1.2, "claw": 1.05, "leap": 1.0, "rush": 0.48}
				_enter(attack, durations[attack])
		"charge":
			velocity.x = direction * (520.0 if phase == 1 else 600.0)
			var offset: Vector2 = player.global_position - global_position
			if absf(offset.x) < 92.0 and absf(offset.y) < 56.0:
				if _hit_player(30): return
			var at_edge := (direction < 0.0 and global_position.x <= arena_left + 90.0) or (direction > 0.0 and global_position.x >= arena_right - 90.0)
			if state_time <= 0.0 or at_edge or is_on_wall(): _recover()
		"sweep":
			var previous_radius := sweep_radius
			sweep_radius = (1.15 - state_time) * 620.0
			for i in root_sprites.size():
				if is_instance_valid(root_sprites[i]): root_sprites[i].position.x = (-1.0 if i == 0 else 1.0) * sweep_radius
			var feet: Vector2 = player.global_position
			var distance := absf(feet.x - global_position.x)
			if distance >= previous_radius - 30.0 and distance <= sweep_radius + 30.0 and feet.y > floor_y - 55.0 and feet.y < floor_y + 35.0:
				if _hit_player(24): return
			if state_time <= 0.0: _recover()
		"eruption":
			if absf(player.global_position.x - eruption_x) < 65.0 and player.global_position.y > floor_y - 112.0 and player.global_position.y < floor_y + 35.0:
				if _hit_player(26): return
			if state_time <= 0.0: _recover()
		"volley":
			if not volley_fired and state_time <= 0.95:
				volley_fired = true
				_spawn_volley()
			# The volley finishes before the recovery window begins.
			if state_time <= 0.0 and projectiles.is_empty(): _recover()
		"claw":
			# Two separated swipes, each with its own visible retraction/tell.
			if phase >= 2 and state_time < 0.38 and not combo_second:
				combo_second = true
				attack_landed = false
				_cue("enemy_attack")
			var active_swipe := (state_time < 0.83 and state_time > 0.58) or (phase >= 2 and state_time < 0.25)
			var offset: Vector2 = player.global_position - global_position
			if active_swipe and offset.x * direction > -25.0 and offset.x * direction < 185.0 and absf(offset.y) < 95.0:
				if _hit_player(22): return
			if state_time <= 0.0: _recover()
		"leap":
			var descending := velocity.y >= 0.0
			if descending and global_position.y >= floor_y:
				global_position.y = floor_y
				velocity.y = 0.0
				_enter("slam_impact", 0.38)
		"slam_impact":
			var offset: Vector2 = player.global_position - global_position
			if absf(offset.x) < 165.0 and offset.y > -70.0 and offset.y < 40.0:
				if _hit_player(28): return
			if state_time <= 0.0: _recover()
		"rush":
			velocity.x = direction * 700.0
			var offset: Vector2 = player.global_position - global_position
			if absf(offset.x) < 105.0 and absf(offset.y) < 65.0:
				if _hit_player(24): return
			var at_edge := (direction < 0.0 and global_position.x <= arena_left + 100.0) or (direction > 0.0 and global_position.x >= arena_right - 100.0)
			if state_time <= 0.0 or at_edge or is_on_wall():
				if rush_second:
					_recover()
				else:
					rush_second = true
					direction = -direction
					_enter("rush_warning", 0.75)
		"recover":
			if state_time <= 0.0: _enter("idle", 0.7 if phase < 3 else 0.5)
	# Damage emits player death synchronously; a chapter reset can occur above.
	if frame_epoch != hazard_epoch or state in ["dormant", "defeated"]: return
	velocity.y = minf(velocity.y + 1600.0 * delta, 1000.0)
	move_and_slide()
	global_position.x = clampf(global_position.x, arena_left + 70.0, arena_right - 70.0)
	_update_visual()
	queue_redraw()

func _recover() -> void:
	_enter("recover", 3.0 if phase < 3 else 3.5)

func _art_sprite(path: String, height: float, grounded: bool) -> Sprite2D:
	var art := Sprite2D.new()
	if ResourceLoader.exists(path):
		art.texture = load(path)
		var size := art.texture.get_size()
		art.scale = Vector2.ONE * height / maxf(size.y, 1.0)
		if grounded: art.offset.y = -size.y * 0.5
	add_child(art)
	art.z_index = 3
	return art

func _spawn_volley() -> void:
	# Lock aim at the warning, solve ballistic flight, then leave fair gaps.
	for i in 3:
		var art := _art_sprite(SEED_ART, 29.0, false)
		var at := global_position + Vector2(direction * 75.0, -110.0)
		art.global_position = at
		var target := locked_target + Vector2((i - 1) * 110.0, 0.0)
		var flight := clampf(absf(target.x - at.x) / 650.0, 0.65, 1.05)
		var shot_velocity := (target - at) / flight - Vector2(0.0, 230.0 * flight)
		projectiles.append({"position": at, "velocity": shot_velocity, "life": 2.2, "sprite": art})

func _update_projectiles(delta: float) -> void:
	# Own this batch while damage callbacks may reset or defeat the encounter.
	var batch: Array[Dictionary] = projectiles
	projectiles = []
	var epoch := hazard_epoch
	for shot in batch:
		if not is_instance_valid(shot.get("sprite")): continue
		var before: Vector2 = shot.position
		shot.velocity.y += 460.0 * delta
		shot.position += shot.velocity * delta
		shot.life -= delta
		shot.sprite.global_position = shot.position
		shot.sprite.rotation += delta * 4.0
		var feet: Vector2 = player.global_position + Vector2(0, -30)
		var nearest := Geometry2D.get_closest_point_to_segment(feet, before, shot.position)
		var hit := feet.distance_to(nearest) < 30.0
		if hit: _hit_player(20)
		if hazard_epoch != epoch:
			for abandoned in batch:
				if is_instance_valid(abandoned.get("sprite")): abandoned.sprite.queue_free()
			return
		if hit or shot.life <= 0.0 or shot.position.y >= floor_y - 8.0 or shot.position.x < arena_left or shot.position.x > arena_right:
			shot.sprite.queue_free()
		else:
			projectiles.append(shot)

func _cue(kind: String) -> void:
	get_tree().call_group("prologue_presentation", "cue", kind, global_position)

func _hit_player(amount: int) -> bool:
	if attack_landed or not is_instance_valid(player) or state in ["dormant", "defeated"]: return false
	attack_landed = true
	var epoch := hazard_epoch
	var push := -1.0 if player.global_position.x < global_position.x else 1.0
	player.take_damage(amount, push)
	return hazard_epoch != epoch

func take_damage(amount: int, _hit_direction: float = 1.0) -> void:
	# Every visible part of the body is vulnerable from either side.
	if state in ["dormant", "defeated"] or amount <= 0 or flash > 0.0: return
	health = maxi(0, health - amount)
	flash = 0.18
	combat_feedback.emit("hurt", 0.24)
	if health == 0:
		health_changed.emit(health)
		_defeat()
		return
	var next_phase := 3 if health <= max_health / 3 else (2 if health <= max_health * 2 / 3 else 1)
	if phase != next_phase:
		phase = next_phase
		phase_changed.emit(phase)
		_cue("boss_slam")
	health_changed.emit(health)
	get_tree().call_group("prologue_presentation", "cue", "impact", global_position + Vector2(-direction * 42.0, -85.0))
	_update_visual()

func get_hurt_rect() -> Rect2:
	return Rect2(global_position + Vector2(-140, -215), Vector2(280, 215))

func _defeat() -> void:
	if state == "defeated": return
	state = "defeated"
	collision_mask = 1
	velocity = Vector2.ZERO
	collision_layer = 0
	_clear_hazards()
	remove_from_group("enemies")
	_update_visual()
	combat_feedback.emit("defeat", 0.8)
	defeated.emit()

func strike_column() -> void:
	if state != "recover" or health > 9 or column_hits >= 3: return
	column_hits += 1
	if column_hits >= 3: binding_exposed = true

func cut_binding() -> void:
	if state != "recover" or not binding_exposed or freed_bindings >= 3: return
	freed_bindings += 1
	if freed_bindings == 3:
		_defeat()
	queue_redraw()

func _update_visual() -> void:
	if not is_instance_valid(sprite): return
	var clip := "idle"
	match state:
		"charge_warning", "sweep_warning", "eruption_warning", "volley_warning", "claw_warning", "leap_warning", "rush_warning": clip = "windup"
		"charge", "rush", "leap": clip = "charge"
		"sweep", "slam_impact": clip = "slam"
		"claw": clip = "claw"
		"eruption": clip = "eruption"
		"volley": clip = "volley"
		"recover": clip = "recover"
		"defeated": clip = "defeat"
	if not sprite.sprite_frames.has_animation(clip): clip = "slam" if state in ["claw", "eruption"] else "windup"
	var elapsed := state_duration - state_time
	var squash := Vector2.ONE
	sprite.rotation = 0.0
	sprite.position = Vector2.ZERO
	if state.ends_with("_warning"):
		var anticipation := clampf(elapsed / maxf(state_duration, 0.01), 0.0, 1.0)
		squash = Vector2(1.0 + anticipation * 0.06, 1.0 - anticipation * 0.08)
		sprite.rotation = -direction * anticipation * 0.035
	elif state in ["charge", "rush"]:
		sprite.position.y = -absf(sin(elapsed * 22.0)) * 7.0
		sprite.rotation = direction * 0.04
	elif state == "leap":
		squash = Vector2(0.94, 1.08)
	elif state == "slam_impact":
		var impact := state_time / maxf(state_duration, 0.01)
		squash = Vector2(1.0 + impact * 0.13, 1.0 - impact * 0.14)
	elif state == "claw":
		sprite.rotation = direction * sin(clampf(elapsed / 0.6, 0.0, 1.0) * PI) * 0.09
	sprite.scale = Vector2(direction * 0.55, 0.55) * squash
	# Match dedicated frames to the actual damaging portion of each move.
	sprite.speed_scale = 1.0
	if clip in ["claw", "eruption", "volley", "slam"] and state_duration > 0.0:
		var clip_seconds := 0.0
		var frames := sprite.sprite_frames
		for frame in frames.get_frame_count(clip):
			clip_seconds += frames.get_frame_duration(clip, frame) / frames.get_animation_speed(clip)
		sprite.speed_scale = clip_seconds / minf(state_duration, 0.85)
	sprite.modulate = Color(1.35, 1.2, 1.0) if flash > 0.0 else Color.WHITE
	if sprite.animation != clip: sprite.play(clip)
	elif not sprite.is_playing() and state != "defeated" and sprite.sprite_frames.get_animation_loop(clip): sprite.play()

func _draw() -> void:
	# Ground-only danger telegraphs. Monsters and projectiles use illustrated art.
	var ground := floor_y - global_position.y - 5.0
	if state in ["charge_warning", "rush_warning"]:
		var end_x := (arena_left + 70.0 if direction < 0.0 else arena_right - 70.0) - global_position.x
		draw_line(Vector2(0, ground), Vector2(end_x, ground), Color(1.0, 0.77, 0.35, 0.6), 5.0)
	elif state == "sweep_warning":
		draw_line(Vector2(-700, ground), Vector2(700, ground), Color(0.94, 0.72, 0.28, 0.5), 4.0)
	elif state == "eruption_warning":
		var x := eruption_x - global_position.x
		draw_line(Vector2(x - 65, ground), Vector2(x + 65, ground), Color("ffd58c"), 6.0)
		draw_line(Vector2(x, ground), Vector2(x, ground - 16), Color("ffd58c"), 3.0)
	elif state == "leap_warning":
		var x := locked_target.x - global_position.x
		draw_line(Vector2(x - 165, ground), Vector2(x + 165, ground), Color("ffd58c"), 6.0)
	elif state == "claw_warning":
		draw_line(Vector2(direction * 30, ground), Vector2(direction * 185, ground), Color("ffd58c"), 5.0)
	elif state == "volley_warning":
		for i in 3:
			var x := locked_target.x - global_position.x + (i - 1) * 110.0
			draw_line(Vector2(x - 20, ground), Vector2(x + 20, ground), Color("ffd58c"), 4.0)
