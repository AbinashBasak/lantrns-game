extends CharacterBody2D
## Chapter 1 temple guardian: deliberate attacks, visible safe ground and a retained defeat pose.
signal defeated
signal health_changed(current: int, maximum: int)
signal phase_changed(phase: String)
signal rejuvenated
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
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/States/playback")

func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	sprite = get_node("AnimatedSprite2D")
	_play("dormant")
	_sync_native_vfx()

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
		_play("dormant")
	health_changed.emit(health, max_health)
	_sync_native_vfx()

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
	_sync_native_vfx()

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
	_sync_native_vfx()

func _play(clip: String, duration: float = 0) -> void:
	var duration_scale := animation_player.get_animation(clip).length / duration if duration > 0 else 1.0
	animation_tree.set("parameters/Speed/scale", duration_scale)
	animation_state.travel(clip)

func take_damage(amount: int, _hit_direction: float) -> void:
	if not activated or health <= 0 or state == "wake" or state == "transition" or state == "collapse" or state == "rejuvenate":
		return
	health = maxi(0, health - amount)
	flash = 0.16
	var presentation := get_tree().get_first_node_in_group("chapter_presentation")
	if presentation == null or not presentation.reduced_effects:
		$ImpactDust.restart()
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
		_sync_native_vfx()

func _cue(event: String) -> void:
	get_tree().call_group("chapter_presentation", "cue", event, global_position)

var _vfx_cue := ""
var _vfx_reduced := false

func _sync_native_vfx() -> void:
	# All geometry and visual timing are authored in the scene. Only locked attack
	# anchors and gameplay visibility are supplied here; damage stays in the FSM.
	var warning := state == "windup"
	var wave := (warning and pending_wave) or state == "rootwave"
	var eruption := (warning and pending_attack == "eruption") or state == "eruption"
	var charge := warning and pending_attack == "charge"
	var reduced := false
	var presentation := get_tree().get_first_node_in_group("chapter_presentation")
	if presentation != null:
		reduced = presentation.reduced_effects
	$NativeVFX/Charge.visible = charge
	$NativeVFX/Charge/GroundWarning.scale.x = direction
	$NativeVFX/Anticipation.visible = warning and not wave and not eruption and not charge
	$NativeVFX/Anticipation.position.x = direction * 70.0
	$NativeVFX/Rootwave.visible = wave
	$NativeVFX/Rootwave.global_position = Vector2(ARENA_LEFT, FLOOR_Y)
	var safe_offset := safe_center - ARENA_LEFT
	$NativeVFX/Rootwave/SafeGround.position.x = safe_offset
	$NativeVFX/Rootwave/DangerLeft.scale.x = maxf(0.0, safe_offset - 130.0)
	$NativeVFX/Rootwave/DangerRight.position.x = safe_offset + 130.0
	$NativeVFX/Rootwave/DangerRight.scale.x = maxf(0.0, ARENA_RIGHT - safe_center - 130.0)
	for visual: Node2D in $NativeVFX/Rootwave/Roots.get_children():
		visual.visible = absf(visual.position.x - safe_offset) > 130.0
	for i in 2:
		var visual: Node2D = get_node("NativeVFX/Eruption%d" % i)
		visual.visible = eruption and i < eruption_centers.size()
		if visual.visible:
			visual.global_position = Vector2(eruption_centers[i], FLOOR_Y)
		visual.get_node("Roots").visible = state == "eruption"
	$NativeVFX/Rejuvenation.visible = state == "rejuvenate"
	$NativeVFX/Rejuvenation/RevivalMotes.emitting = state == "rejuvenate" and not reduced
	$NativeVFX/Rejuvenation/RevivalLight.enabled = not reduced
	var cue := ""
	if state == "rejuvenate": cue = "rejuvenate"
	elif state == "rootwave": cue = "rootwave"
	elif state == "eruption": cue = "eruption"
	elif warning: cue = "warning"
	if cue != _vfx_cue or reduced != _vfx_reduced:
		_vfx_cue = cue
		_vfx_reduced = reduced
		if cue.is_empty():
			$VFXAnimationPlayer.stop()
			$NativeVFX.modulate = Color.WHITE
		elif reduced:
			$VFXAnimationPlayer.play(cue)
			$VFXAnimationPlayer.seek($VFXAnimationPlayer.current_animation_length * 0.5 if cue in ["rootwave", "eruption"] else 0.0, true)
			$VFXAnimationPlayer.pause()
		else:
			$VFXAnimationPlayer.play(cue)
		if warning:
			$NativeVFX/Rootwave/Roots.scale.y = 0.12
