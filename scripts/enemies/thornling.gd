extends CharacterBody2D
signal defeated
const Generated = preload("res://scripts/companions/generated_animation.gd")
var sprite: AnimatedSprite2D
const ROOTLING_PACK := "res://assets/runtime/prologue/characters/rootling/manifest.json"
var direction: float = -1.0
var health: int = 2
var flash: float = 0.0
var clock: float = 0.0

func _ready() -> void:
	add_to_group("enemies")
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Generated.frames_from_manifest(ROOTLING_PACK)
	sprite.centered = false
	sprite.offset = Vector2(-256, -480)
	sprite.scale = Vector2.ONE * 0.18
	add_child(sprite)
	sprite.play("idle")

var state := "idle"
var state_time := 0.0
var attack_landed := false

func _physics_process(delta: float) -> void:
	clock += delta
	flash = maxf(0.0, flash - delta)
	state_time = maxf(0.0, state_time - delta)
	var target: Node2D = null
	for candidate in get_tree().get_nodes_in_group("player"):
		if candidate.active:
			target = candidate
			break
	if flash > 0:
		velocity.x = move_toward(velocity.x, 0, 650 * delta)
	elif target == null:
		velocity.x = 0
		state = "idle"
	else:
		var offset: Vector2 = target.global_position - global_position
		match state:
			"idle":
				velocity.x = 0
				if absf(offset.x) < 260 and absf(offset.y) < 90:
					state = "approach"
			"approach":
				direction = -1.0 if offset.x < 0 else 1.0
				velocity.x = direction * 58
				if absf(offset.x) < 62 and absf(offset.y) < 70:
					state = "telegraph"
					state_time = 0.75
					velocity.x = 0
				elif absf(offset.x) > 340:
					state = "idle"
			"telegraph":
				velocity.x = 0
				if state_time <= 0:
					state = "attack"
					state_time = 0.18
					attack_landed = false
					get_tree().call_group("prologue_presentation", "cue", "enemy_attack", global_position)
			"attack":
				velocity.x = direction * 120
				if not attack_landed and absf(offset.x) < 68 and absf(offset.y) < 65 and offset.x * direction > -10:
					target.take_damage(1, direction)
					attack_landed = true
				if state_time <= 0:
					state = "recovery"
					state_time = 0.8
			"recovery":
				velocity.x = 0
				if state_time <= 0: state = "approach"
	velocity.y += 1600 * delta
	move_and_slide()
	var clip := "hurt" if flash > 0 else ("attack" if state == "attack" or state == "telegraph" else ("move" if absf(velocity.x) > 5 else "idle"))
	# Hold the generated attack anticipation during the readable wind-up.
	if state == "telegraph":
		sprite.play("attack")
		sprite.set_frame_and_progress(0, 0)
		sprite.pause()
	else:
		sprite.speed_scale = 4.7 if clip == "attack" else (4.4 if clip == "hurt" else 1.0)
		sprite.play(clip)
	sprite.scale.x = 0.18 * direction
	sprite.modulate = Color(1.5, 1.3, 1.0) if flash > 0 else Color.WHITE
	queue_redraw()

func take_damage(amount: int, hit_direction: float) -> void:
	health -= amount
	get_tree().call_group("prologue_presentation", "cue", "impact", global_position)
	if _effects_enabled():
		Generated.one_shot(get_parent(), global_position + Vector2(0, -25), "res://assets/runtime/prologue/effects/FX-002/manifest.json", "main", 0.45, Vector2(96, 96))
	flash = 0.2
	state = "recovery"
	state_time = 0.6
	velocity.x = hit_direction * 230
	if health <= 0:
		get_tree().call_group("prologue_presentation", "cue", "enemy_defeat", global_position)
		Generated.one_shot(get_parent(), global_position, ROOTLING_PACK, "defeat", 0.18, Vector2(256, 480), direction)
		if _effects_enabled():
			Generated.one_shot(get_parent(), global_position + Vector2(0, -20), "res://assets/runtime/prologue/effects/FX-004/manifest.json", "main", 0.6, Vector2(96, 92))
		remove_from_group("enemies")
		defeated.emit()
		queue_free()

func _effects_enabled() -> bool:
	var presentation := get_tree().get_first_node_in_group("prologue_presentation")
	return presentation == null or not presentation.reduced_effects

func _draw() -> void:
	if state == "telegraph":
		draw_arc(Vector2(0, -20), 34, PI, TAU, 20, Color("ffc775"), 3)
		draw_line(Vector2(0, -68), Vector2(0, -54), Color("ffe2a0"), 4)
		draw_circle(Vector2(0, -47), 2, Color("ffe2a0"))
	if state == "attack":
		draw_arc(Vector2(direction * 22, -20), 30, -PI / 2, PI / 2, 16, Color("ddaa68"), 4)
