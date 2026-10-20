extends CharacterBody2D
## Chapter 1 temple guardian: deliberate attacks, visible safe ground and a retained defeat pose.
signal defeated
signal health_changed(current: int, maximum: int)
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
	var offset := target.global_position - global_position
	var recovering: bool = target.invincible > 0
	match state:
		"wake":
			velocity.x = 0
			if state_time <= 0:
				_set_state("recover", 0.65)
		"approach":
			direction = -1.0 if offset.x < 0 else 1.0
			velocity.x = direction * (38.0 if health <= 6 else 58.0)
			if recovering:
				velocity.x = 0
			elif health <= 12 and not phase_transition_seen:
				phase_transition_seen = true
				_set_state("transition", 1.35)
			elif health <= 12 and attack_count % 2 == 1:
				_begin_windup(true)
			elif absf(offset.x) < 150:
				_begin_windup(false)
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
					_set_state("rootwave" if pending_wave else "swipe", 0.36 if pending_wave else 0.28)
					_cue("boss_slam" if pending_wave else "enemy_attack")
		"swipe":
			velocity.x = direction * 85
			if not attack_landed and not recovering and offset.x * direction > -10 and offset.x * direction < 170 and absf(offset.y) < 62:
				target.take_damage(40, direction)
				attack_landed = true
			if state_time <= 0:
				_set_state("recover", 1.75 if health <= 6 else 1.25)
		"rootwave":
			velocity.x = 0
			if not attack_landed and not recovering and absf(target.global_position.x - safe_center) > 130 and target.global_position.x >= ARENA_LEFT and target.global_position.x <= ARENA_RIGHT and target.global_position.y > FLOOR_Y - 65:
				target.take_damage(55, -1.0 if offset.x < 0 else 1.0)
				attack_landed = true
			if state_time <= 0:
				_set_state("recover", 2.0 if health <= 6 else 1.55)
		"recover":
			velocity.x = 0
			if state_time <= 0 and not recovering:
				_set_state("approach", 0)
	velocity.y = minf(velocity.y + 1600 * delta, 900)
	move_and_slide()
	global_position.x = clampf(global_position.x, ARENA_LEFT + 100, ARENA_RIGHT - 100)
	sprite.scale.x = direction * 0.40
	sprite.modulate = Color(1.35, 1.15, 0.8) if flash > 0 else Color.WHITE
	queue_redraw()

func _begin_windup(wave: bool) -> void:
	pending_wave = wave
	# A visible 260px safe pocket centered just beside the player; reachable before the wave.
	safe_center = clampf(target.global_position.x + direction * 145, ARENA_LEFT + 160, ARENA_RIGHT - 160)
	_set_state("windup", 1.25 if health <= 6 else 0.95)

func _set_state(next: String, duration: float) -> void:
	state = next
	state_time = duration
	match state:
		"wake": _play("wake", duration)
		"approach": _play("move")
		"windup": _play("windup", duration)
		"swipe": _play("swipe", duration)
		"rootwave": _play("slam", duration)
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
	if not activated or health <= 0 or state == "wake" or state == "transition":
		return
	health = maxi(0, health - amount)
	flash = 0.16
	_cue("boss_hit")
	health_changed.emit(health, max_health)
	if health == 0:
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
				draw_line(Vector2(x, -5), Vector2(x + 12, -38 if active else -16), danger, 4)
	elif state == "windup":
		draw_arc(Vector2(direction * 70, -60), 52, PI, TAU, 28, Color("ffca70"), 4)
		draw_line(Vector2(direction * 70, -152), Vector2(direction * 70, -130), Color("ffde9b"), 5)
		draw_circle(Vector2(direction * 70, -120), 3, Color("ffde9b"))
