extends Node2D
## Generated Mote exports, retaining authored per-frame timings and center pivot.
const Generated = preload("res://scripts/companions/generated_animation.gd")
var target: Node2D
var rescued := false
var active := true
var signaling := false
var clock := 0.0
var was_rescued := false
var celebrate_time := 0.0
var sprite: AnimatedSprite2D

func _ready() -> void:
	position = Vector2(2470, 590)
	z_index = 5
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Generated.frames_from_manifest("res://assets/runtime/prologue/characters/mote/manifest.json")
	sprite.centered = false
	sprite.offset = Vector2(-256, -256)
	sprite.scale = Vector2.ONE * 0.19
	add_child(sprite)
	sprite.play("alert")

func _process(delta: float) -> void:
	if not active:
		sprite.pause()
		return
	clock += delta
	if rescued and not was_rescued:
		celebrate_time = 1.0
	was_rescued = rescued
	celebrate_time = maxf(0, celebrate_time - delta)
	var moving := false
	if rescued and is_instance_valid(target):
		var desired := target.global_position + Vector2(-58 * target.facing, -85)
		moving = global_position.distance_to(desired) > 24
		global_position = global_position.lerp(desired + Vector2(0, sin(clock * 3) * 6), 1.0 - exp(-4.5 * delta))
		sprite.flip_h = target.global_position.x < global_position.x
	var clip := "rescue" if celebrate_time > 0 else ("follow" if moving else ("idle" if rescued else "alert"))
	sprite.play(clip)
	queue_redraw()

func _draw() -> void:
	# Mote's story signal: three slow taps followed by two quick taps.
	if rescued and not signaling: return
	var beat := fmod(clock, 4.0)
	for tap in [0.0, 0.7, 1.4, 2.35, 2.6]:
		var age: float = beat - float(tap)
		if age >= 0 and age < 0.3:
			draw_arc(Vector2.ZERO, 18 + age * 65, 0, TAU, 32, Color(0.7, 1, 0.8, (1.0 - age / 0.3) * 0.7), 2)
