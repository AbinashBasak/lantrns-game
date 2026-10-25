extends CharacterBody2D
signal defeated
var sprite: AnimatedSprite2D
@export var attack_damage: int = 25
var direction: float = -1.0
var health: int = 2
var flash: float = 0.0
var clock: float = 0.0
var dying := false
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/States/playback")

func _ready() -> void:
	add_to_group("enemies")
	sprite = get_node("AnimatedSprite2D")
	_play("idle")

var state := "idle"
var state_time := 0.0
var attack_landed := false

func _physics_process(delta: float) -> void:
	if dying:
		return
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
					target.take_damage(attack_damage, direction)
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
	_play("telegraph" if state == "telegraph" else clip, 4.7 if clip == "attack" else (4.4 if clip == "hurt" else 1.0))
	sprite.scale.x = 0.18 * direction
	sprite.modulate = Color(1.5, 1.3, 1.0) if flash > 0 else Color.WHITE
	$Telegraph.visible = state == "telegraph" and not dying
	$Strike.visible = state == "attack" and not dying
	$Strike.scale.x = direction

func take_damage(amount: int, hit_direction: float) -> void:
	if dying:
		return
	health -= amount
	get_tree().call_group("prologue_presentation", "cue", "impact", global_position)
	if _effects_enabled():
		$ImpactDust.restart()
	flash = 0.2
	state = "recovery"
	state_time = 0.6
	velocity.x = hit_direction * 230
	if health <= 0:
		get_tree().call_group("prologue_presentation", "cue", "enemy_defeat", global_position)
		if _effects_enabled():
			$ImpactDust.restart()
		remove_from_group("enemies")
		defeated.emit()
		$Telegraph.hide()
		$Strike.hide()
		dying = true
		velocity = Vector2.ZERO
		collision_layer = 0
		$CollisionShape2D.set_deferred("disabled", true)
		_play("defeat")
		get_tree().create_timer(animation_player.get_animation("defeat").length).timeout.connect(queue_free)

func _effects_enabled() -> bool:
	var presentation := get_tree().get_first_node_in_group("prologue_presentation")
	return presentation == null or not presentation.reduced_effects

# The editor-authored tree owns all frame stepping; AI supplies only a state and speed.
func _play(clip: String, speed: float = 1.0) -> void:
	animation_tree.set("parameters/Speed/scale", speed)
	animation_state.travel(clip)
