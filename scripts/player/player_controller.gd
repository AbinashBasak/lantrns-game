extends CharacterBody2D

signal health_changed(value: int)
signal vitality_changed(current: int, maximum: int)
signal died
signal action_event(kind: String, at: Vector2)
@export var speed: float = 330.0
@export var jump_speed: float = 680.0
@export var gravity: float = 1600.0
const MAX_VITALITY := 100
var health: int = 5 # Remaining lives; a complete vitality bar protects each life.
var vitality: int = MAX_VITALITY
var combo_index := 0
var combo_window := 0.0
var queued_attack := false
var attack_duration := 0.44
var facing: float = 1.0
var coyote: float = 0.0
var jump_buffer: float = 0.0
var attack_time: float = 0.0
var attack_cooldown: float = 0.0
var invincible: float = 0.0
var animation_time: float = 0.0
var hit_targets: Array = []
var active: bool = true
var attack_enabled: bool = true
var landing_time: float = 0.0
@onready var visual: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not active:
		return
	var was_grounded := is_on_floor()
	landing_time = maxf(0.0, landing_time - delta)
	animation_time += delta
	invincible = maxf(0.0, invincible - delta)
	attack_time = maxf(0.0, attack_time - delta)
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	combo_window = maxf(0.0, combo_window - delta)
	if queued_attack and attack_time <= 0:
		queued_attack = false
		_start_attack()
	coyote = 0.12 if is_on_floor() else maxf(0.0, coyote - delta)
	jump_buffer = maxf(0.0, jump_buffer - delta)
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0.12
	if jump_buffer > 0 and coyote > 0:
		velocity.y = -jump_speed
		action_event.emit("jump", global_position)
		jump_buffer = 0
		coyote = 0
	if Input.is_action_just_released("jump") and velocity.y < -220:
		velocity.y = -220
	velocity.y = minf(velocity.y + gravity * delta, 1000)
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, direction * speed, 2300 * delta)
	if direction != 0:
		facing = signf(direction)
	if Input.is_action_just_pressed("attack"):
		attack()
	move_and_slide()
	var attack_elapsed := attack_duration - attack_time
	if attack_time > 0 and attack_elapsed >= 0.12 and attack_elapsed <= 0.30:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var offset: Vector2 = enemy.global_position - global_position
			if offset.x * facing > -8 and offset.x * facing < 100 and absf(offset.y) < 75 and not enemy in hit_targets:
				hit_targets.append(enemy)
				enemy.take_damage(1, facing)
	if is_on_floor() and not was_grounded:
		landing_time = 0.22
		action_event.emit("land", global_position)
	_update_animation()
	if position.y > 950:
		died.emit()
	queue_redraw()

func attack() -> void:
	if not active or not attack_enabled:
		return
	# Buffer a follow-up during recovery, rather than restarting the anticipation.
	if attack_time > 0:
		if attack_time <= 0.20:
			queued_attack = true
		return
	if attack_cooldown <= 0:
		_start_attack()

func _start_attack() -> void:
	combo_index = (combo_index + 1) % 2 if combo_window > 0 else 0
	attack_duration = 0.48 if combo_index == 1 else 0.44
	attack_time = attack_duration
	attack_cooldown = attack_duration
	combo_window = attack_duration + 0.28
	hit_targets.clear()
	var clip := "attack_2" if combo_index == 1 and visual.sprite_frames.has_animation("attack_2") else "attack_1"
	visual.play(clip)
	visual.set_frame_and_progress(0, 0)
	action_event.emit("swing", global_position + Vector2(facing * 15, -35))

func take_damage(amount: int, direction: float = -1.0) -> void:
	if invincible > 0 or health <= 0 or amount <= 0:
		return
	vitality = maxi(0, vitality - amount)
	if vitality == 0:
		health = maxi(0, health - 1)
		vitality = MAX_VITALITY if health > 0 else 0
		health_changed.emit(health)
	vitality_changed.emit(vitality, MAX_VITALITY)
	action_event.emit("hurt", global_position)
	invincible = 1.1
	velocity = Vector2(direction * 260, -250)
	queued_attack = false
	if health <= 0:
		died.emit()

func restore_vitality() -> void:
	vitality = MAX_VITALITY
	vitality_changed.emit(vitality, MAX_VITALITY)

func reset_at(point: Vector2) -> void:
	global_position = point
	velocity = Vector2.ZERO
	health = 5
	restore_vitality()
	attack_time = 0
	attack_cooldown = 0
	combo_window = 0
	queued_attack = false
	invincible = 1.5
	health_changed.emit(health)
	action_event.emit("respawn", global_position)

func _update_animation() -> void:
	visual.flip_h = facing < 0
	visual.visible = not (invincible > 0 and int(animation_time * 16) % 2 == 0)
	var state := "idle"
	if attack_time > 0:
		state = "attack_2" if combo_index == 1 and visual.sprite_frames.has_animation("attack_2") else "attack_1"
	elif not is_on_floor():
		state = "jump_rise" if velocity.y < 0 else "jump_fall"
	elif landing_time > 0:
		state = "landing"
	elif absf(velocity.x) > 20:
		state = "run"
	visual.speed_scale = 1.0
	if attack_time > 0:
		# Fit all eight generated frames to the hit/recovery window.
		visual.speed_scale = float(visual.sprite_frames.get_frame_count(state)) / (visual.sprite_frames.get_animation_speed(state) * attack_duration)
	if visual.animation != state:
		visual.play(state)

func _draw() -> void:
	if is_instance_valid(visual):
		return
	if invincible > 0 and int(animation_time * 16) % 2 == 0:
		return
	var bob := sin(animation_time * 13) * 2 if absf(velocity.x) > 20 and is_on_floor() else sin(animation_time * 3) * 1.5
	draw_set_transform(Vector2(0, bob), 0, Vector2(facing, 1))
	# Temporary vector character; original illustrations are preserved separately.
	draw_circle(Vector2(0, -33), 28, Color(0.8, 0.57, 0.27, 0.04))
	var step := sin(animation_time * 14) * 8 if absf(velocity.x) > 20 else 0.0
	draw_line(Vector2(-7, -24), Vector2(-9 - step, -4), Color("263439"), 11)
	draw_line(Vector2(7, -24), Vector2(10 + step, -4), Color("263439"), 11)
	draw_line(Vector2(-10 - step, -3), Vector2(-3 - step, -3), Color("70513b"), 8)
	draw_line(Vector2(7 + step, -3), Vector2(17 + step, -3), Color("70513b"), 8)
	draw_colored_polygon(PackedVector2Array([Vector2(-13,-47),Vector2(12,-47),Vector2(16,-23),Vector2(-15,-23)]),Color("d4c8a1"))
	draw_line(Vector2(-10,-45),Vector2(10,-26),Color("69503a"),6)
	draw_line(Vector2(-14,-25),Vector2(14,-25),Color("6b4532"),5)
	draw_circle(Vector2(0,-58),12,Color("e2b78d"))
	draw_colored_polygon(PackedVector2Array([Vector2(-14,-56),Vector2(-15,-66),Vector2(-7,-74),Vector2(-1,-71),Vector2(5,-77),Vector2(8,-69),Vector2(16,-67),Vector2(12,-59),Vector2(2,-64),Vector2(-7,-58)]),Color("37688f"))
	draw_circle(Vector2(8,-58),1.7,Color("283032"))
	draw_line(Vector2(-10,-48),Vector2(9,-48),Color("bf594a"),6)
	draw_colored_polygon(PackedVector2Array([Vector2(-9,-49),Vector2(-34,-46+sin(animation_time*7)*4),Vector2(-24,-37),Vector2(-8,-43)]),Color("b64a40"))
	draw_line(Vector2(9,-43),Vector2(20,-31),Color("d6bc93"),7)
	if attack_time > 0:
		var angle := lerpf(-1.5,1.1,1.0-attack_time/0.38)
		var hand := Vector2(17,-37)
		var tip := hand + Vector2.from_angle(angle)*64
		draw_line(hand,tip,Color("d6e1d4"),5)
		draw_line(hand+Vector2(-5,3),hand+Vector2(7,-4),Color("dcad58"),5)
		draw_arc(hand,67,angle-0.65,angle,12,Color(1,0.82,0.43,0.6),5,true)
	draw_set_transform(Vector2.ZERO)
