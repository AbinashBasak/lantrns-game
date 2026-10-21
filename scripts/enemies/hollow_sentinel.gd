extends CharacterBody2D
## Chapter 1 temple guardian: deliberate attacks, visible safe ground and a retained defeat pose.
signal defeated
signal health_changed(current: int, maximum: int)
signal phase_changed(phase: String)
signal rejuvenated
const Generated = preload("res://scripts/companions/generated_animation.gd")
const PACK := "res://assets/runtime/chapter01/boss/manifest.json"
const ARENA_LEFT := 6500.0
const ARENA_RIGHT := 8100.0
const FLOOR_Y := 620.0
const SPAWN := Vector2(7350, 620)
const max_health := 24
var health := max_health
var activated := false
var state := "dormant"
var state_time := 0.0
var target: CharacterBody2D
var direction := -1.0
var attack_landed := false
var attack_count := 0
var phase_transition_seen := false
var berserk := false
var revival_used := false
var pending_attack := "swipe"
var attack_elapsed := 0.0
var eruption_centers: Array[float] = []
var pending_wave := false
var safe_center := 0.0
var flash := 0.0
var sprite: AnimatedSprite2D

func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Generated.frames_from_manifest(PACK)
	sprite.centered = false
	sprite.offset = Vector2(-256, -480)
	sprite.scale = Vector2(-0.40, 0.40)
	add_child(sprite)
	_play("idle")
	sprite.set_frame_and_progress(0, 0)
	sprite.pause()

func activate(player: CharacterBody2D) -> void:
	if activated or state == "defeated":
		return
	target = player
	activated = true
	phase_changed.emit("guardian")
	add_to_group("enemies")
	_set_state("wake", 1.6)
	health_changed.emit(health, max_health)

func reset_encounter() -> void:
	activated = false
	target = null
	health = max_health
	state = "dormant"
	state_time = 0
	attack_count = 0
	berserk = false
	revival_used = false
	pending_attack = "swipe"
	eruption_centers.clear()
	phase_changed.emit("guardian")
	phase_transition_seen = false
	pending_wave = false
	attack_landed = false
	flash = 0
	velocity = Vector2.ZERO
	global_position = SPAWN
	if is_in_group("enemies"):
		remove_from_group("enemies")
	if sprite != null:
		sprite.modulate = Color.WHITE
		_play("idle")
		sprite.set_frame_and_progress(0, 0)
		sprite.pause()
	health_changed.emit(health, max_health)
	queue_redraw()

func _physics_process(delta: float) -> void:
	flash = maxf(0, flash - delta)
	if not activated:
		return
	if not is_instance_valid(target) or not target.active:
		velocity = Vector2.ZERO
		return
	state_time = maxf(0, state_time - delta)
	attack_elapsed += delta
	var offset := target.global_position - global_position
	var recovering: bool = target.invincible > 0
	match state:
		"wake":
			velocity.x = 0
			if state_time <= 0:
				_set_state("recover", 0.65)
		"approach":
			direction = -1.0 if offset.x < 0 else 1.0
			velocity.x = direction * (105.0 if berserk else 76.0)
			if recovering:
				velocity.x = 0
			elif health <= 12 and not phase_transition_seen:
				phase_transition_seen = true
				_set_state("transition", 1.35)
			elif health <= 12 and attack_count % 2 == 1:
				_begin_windup(true)
			elif absf(offset.x) < 185:
				_begin_attack("eruption" if attack_count % 3 == 2 else "swipe")
			elif absf(offset.x) > 360 and state_time <= 0:
				_begin_attack("charge" if attack_count % 2 == 0 else "eruption")
		"transition":
			velocity.x = 0
			if state_time <= 0:
				_set_state("recover", 0.8)
		"windup":
			velocity.x = 0
			# Facing and safe region remain locked for the entire warning.
			if state_time <= 0:
				if recovering:
					_set_state("recover", 0.65)
				else:
					attack_landed = false
					attack_count += 1
					_set_state(pending_attack, 0.65 if pending_attack == "charge" else (0.75 if pending_attack == "eruption" else (0.55 if pending_wave else 0.32)))
					_cue("boss_slam" if pending_attack in ["rootwave", "eruption"] else "enemy_attack")
		"swipe":
			velocity.x = direction * 85
			if not attack_landed and not recovering and offset.x * direction > -10 and offset.x * direction < 170 and absf(offset.y) < 62:
				target.take_damage(52 if berserk else 36, direction)
				attack_landed = true
			if state_time <= 0:
				_set_state("recover", 0.65 if berserk else 1.0)
		"rootwave":
			velocity.x = 0
			if not attack_landed and not recovering and absf(target.global_position.x - safe_center) > 130 and target.global_position.x >= ARENA_LEFT and target.global_position.x <= ARENA_RIGHT and target.global_position.y > FLOOR_Y - 65:
				target.take_damage(65 if berserk else 45, -1.0 if offset.x < 0 else 1.0)
				attack_landed = true
			if state_time <= 0:
				_set_state("recover", 0.85 if berserk else 1.3)
		"charge":
			velocity.x = direction * (490.0 if berserk else 390.0)
			if not attack_landed and not recovering and absf(offset.x) < 115 and absf(offset.y) < 70:
				target.take_damage(60 if berserk else 42, direction)
				attack_landed = true
			if state_time <= 0 or global_position.x <= ARENA_LEFT + 105 or global_position.x >= ARENA_RIGHT - 105:
				_set_state("recover", 0.85 if berserk else 1.35)
		"eruption":
			velocity.x = 0
			for center in eruption_centers:
				if not attack_landed and not recovering and absf(target.global_position.x - center) < 65 and target.global_position.y > FLOOR_Y - 115:
					target.take_damage(62 if berserk else 44, direction)
					attack_landed = true
			if state_time <= 0:
				_set_state("recover", 0.9 if berserk else 1.4)
		"collapse":
			velocity.x = 0
			if state_time <= 0:
				_set_state("rejuvenate", 2.2)
		"rejuvenate":
			velocity.x = 0
			if state_time <= 0:
				berserk = true
				health = max_health
				phase_transition_seen = true
				health_changed.emit(health, max_health)
				phase_changed.emit("berserk")
				rejuvenated.emit()
				_set_state("recover", 0.8)
		"recover":
			velocity.x = 0
			if state_time <= 0 and not recovering:
				_set_state("approach", 0.5)
	velocity.y = minf(velocity.y + 1600 * delta, 900)
	move_and_slide()
	global_position.x = clampf(global_position.x, ARENA_LEFT + 100, ARENA_RIGHT - 100)
	sprite.scale.x = direction * 0.40
	sprite.modulate = Color(1.35, 1.15, 0.8) if flash > 0 else (Color(1.25, 0.72, 0.5) if berserk else Color.WHITE)
	queue_redraw()

func _begin_windup(wave: bool) -> void:
	_begin_attack("rootwave" if wave else "swipe")

func _begin_attack(kind: String) -> void:
	pending_attack = kind
	pending_wave = kind == "rootwave"
	# Warnings lock aim. A player can jump the charge or leave eruption circles.
	direction = -1.0 if target.global_position.x < global_position.x else 1.0
	safe_center = clampf(target.global_position.x + direction * 145, ARENA_LEFT + 160, ARENA_RIGHT - 160)
	eruption_centers.assign([clampf(target.global_position.x, ARENA_LEFT + 100, ARENA_RIGHT - 100)])
	if berserk and kind == "eruption":
		eruption_centers.append(clampf(target.global_position.x + direction * 230, ARENA_LEFT + 100, ARENA_RIGHT - 100))
	_set_state("windup", 0.9 if berserk else 1.1)

func _set_state(next: String, duration: float) -> void:
	state = next
	state_time = duration
	attack_elapsed = 0
	match state:
		"wake": _play("wake", duration)
		"approach": _play("move")
		"windup": _play("windup", duration)
		"swipe": _play("swipe", duration)
		"rootwave", "eruption": _play("slam", duration)
		"charge": _play("move", duration)
		"collapse": _play("defeat", duration)
		"rejuvenate":
			_play("wake", duration)
		"transition": _play("transition", duration)
		"recover": _play("idle")

func _play(clip: String, duration: float = 0) -> void:
	sprite.speed_scale = 1.0
	if duration > 0:
		var total := 0.0
		for frame in sprite.sprite_frames.get_frame_count(clip):
			total += sprite.sprite_frames.get_frame_duration(clip, frame)
		sprite.speed_scale = total / duration
	sprite.play(clip)

func take_damage(amount: int, _hit_direction: float) -> void:
	if not activated or health <= 0 or state == "wake" or state == "transition" or state == "collapse" or state == "rejuvenate":
		return
	health = maxi(0, health - amount)
	flash = 0.16
	_cue("boss_hit")
	health_changed.emit(health, max_health)
	if health == 0:
		if not revival_used:
			revival_used = true
			velocity = Vector2.ZERO
			phase_changed.emit("rejuvenating")
			_set_state("collapse", 1.6)
			_cue("boss_slam")
			return
		activated = false
		state = "defeated"
		velocity = Vector2.ZERO
		remove_from_group("enemies")
		_play("defeat", 1.9)
		# AnimatedSprite2D retains the final kneeling frame rather than disappearing.
		_cue("boss_defeat")
		defeated.emit()
		queue_redraw()

func _cue(event: String) -> void:
	get_tree().call_group("chapter_presentation", "cue", event, global_position)

func _draw() -> void:
	if state == "rejuvenate":
		draw_string(ThemeDB.fallback_font, Vector2(-90, -180), "REJUVENATING", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("ffdc96"))
		var pulse := 1.0 + sin(attack_elapsed * 7.0) * 0.15
		draw_arc(Vector2(0, -90), (65 + attack_elapsed * 20) * pulse, 0, TAU, 48, Color(1, 0.65, 0.25, 0.7), 5)
		for i in 12:
			var angle := float(i) * TAU / 12.0 + attack_elapsed
			draw_circle(Vector2(0, -90) + Vector2.from_angle(angle) * (125 - attack_elapsed * 30), 4, Color("ffd38a"))
	if state == "windup" and pending_attack == "charge":
		draw_rect(Rect2(-40 if direction > 0 else -600, -12, 640, 12), Color(1, 0.55, 0.2, 0.4))
		draw_string(ThemeDB.fallback_font, Vector2(-50, -155), "CHARGE — JUMP", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("ffdc96"))
	if (state == "windup" and pending_attack == "eruption") or state == "eruption":
		for center in eruption_centers:
			var x := center - global_position.x
			draw_ellipse_root(x, state == "eruption")
	if state == "windup" and pending_wave or state == "rootwave":
		var left := ARENA_LEFT - global_position.x
		var right := ARENA_RIGHT - global_position.x
		var safe := safe_center - global_position.x
		var active := state == "rootwave"
		var danger := Color(0.95, 0.46, 0.12, 0.8 if active else 0.35)
		draw_rect(Rect2(left, -8, safe - 130 - left, 8), danger)
		draw_rect(Rect2(safe + 130, -8, right - safe - 130, 8), danger)
		draw_rect(Rect2(safe - 130, -95, 260, 95), Color(0.45,0.9,0.65,0.10))
		draw_rect(Rect2(safe - 130, -6, 260, 6), Color("9be3b0"))
		draw_line(Vector2(safe-130,-6),Vector2(safe-130,-85),Color("9be3b0"),2)
		draw_line(Vector2(safe+130,-6),Vector2(safe+130,-85),Color("9be3b0"),2)
		draw_string(ThemeDB.fallback_font,Vector2(safe-25,-65),"SAFE",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("bff2ce"))
		for x in range(int(left), int(right), 48):
			if absf(float(x) - safe) > 130:
				var rise := (sin(clampf(attack_elapsed / 0.55, 0, 1) * PI) * 95.0 + 25.0) if active else 12.0 + sin(attack_elapsed * 8 + x) * 4
				_draw_root(float(x), rise, danger)
	elif state == "windup":
		draw_arc(Vector2(direction * 70, -60), 52, PI, TAU, 28, Color("ffca70"), 4)
		draw_line(Vector2(direction * 70, -152), Vector2(direction * 70, -130), Color("ffde9b"), 5)
		draw_circle(Vector2(direction * 70, -120), 3, Color("ffde9b"))

func draw_ellipse_root(x: float, active: bool) -> void:
	draw_arc(Vector2(x, -4), 65, PI, TAU, 24, Color("ffb265"), 3)
	if active:
		var rise := 35.0 + sin(clampf(attack_elapsed / 0.75, 0, 1) * PI) * 125.0
		for n in 3:
			_draw_root(x - 34 + n * 34, rise - n * 10, Color("db8d40"))

func _draw_root(x: float, rise: float, tint: Color) -> void:
	var bend := sin(attack_elapsed * 11 + x) * 15
	var points := PackedVector2Array([Vector2(x - 11, -4), Vector2(x + bend + 8, -rise), Vector2(x + 12, -4)])
	draw_colored_polygon(points, Color("4b3420"))
	draw_polyline(PackedVector2Array([Vector2(x - 9, -5), Vector2(x - 5 + bend * 0.3, -rise * 0.45), Vector2(x + bend + 8, -rise)]), tint, 3, true)
