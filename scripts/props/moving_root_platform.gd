extends AnimatableBody2D
## Origin is the GLOBAL left edge of the top surface, not its center.
## Travel is the displacement to the other endpoint. One period is a round trip.

@export var origin := Vector2.ZERO
@export var travel := Vector2(300.0, 0.0)
@export_range(2.0, 30.0, 0.1) var period: float = 6.0
@export_range(60.0, 400.0, 1.0) var width: float = 180.0

const ROOT_TEXTURE: Texture2D = preload("res://assets/runtime/chapter01/reference_jungle/TILE-005_vine_platform.png")

var _elapsed: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	sync_to_physics = true
	collision_layer = 1
	collision_mask = 0
	# Run before the character so move_and_slide receives this tick's motion.
	process_physics_priority = -10
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width, 22.0)
	var collision := CollisionShape2D.new()
	collision.name = "RootCollision"
	collision.shape = shape
	collision.position = Vector2(width * 0.5, 11.0)
	collision.one_way_collision = true
	collision.one_way_collision_margin = 8.0
	add_child(collision)
	reset_motion()
	queue_redraw()

func _physics_process(delta: float) -> void:
	_elapsed = fmod(_elapsed + delta, maxf(period, 2.0))
	# Cosine eases to a complete stop at each end for readable boarding.
	var progress := (1.0 - cos(TAU * _elapsed / maxf(period, 2.0))) * 0.5
	global_position = origin + travel * progress

func reset_motion() -> void:
	_elapsed = 0.0
	global_position = origin
	# Avoid a rendered streak when returning to the checkpoint's initial position.
	reset_physics_interpolation()

func _draw() -> void:
	# Match the existing jungle's vine-platform art and native-size capped tiling.
	# The eight-pixel grass fringe sits above the actual collision surface.
	var height := minf(89.0, float(ROOT_TEXTURE.get_height()))
	var texture_scale := height / float(ROOT_TEXTURE.get_height())
	var cap := minf(32.0, minf(width * 0.25, ROOT_TEXTURE.get_width() * texture_scale * 0.4))
	var source_cap := cap / texture_scale
	var source_height := float(ROOT_TEXTURE.get_height())
	draw_texture_rect_region(ROOT_TEXTURE, Rect2(0, -8, cap, height), Rect2(0, 0, source_cap, source_height))
	draw_texture_rect_region(ROOT_TEXTURE, Rect2(width - cap, -8, cap, height), Rect2(ROOT_TEXTURE.get_width() - source_cap, 0, source_cap, source_height))
	var center_width := maxf(1.0, (ROOT_TEXTURE.get_width() - 2 * source_cap) * texture_scale)
	var x := cap
	while x < width - cap - 0.01:
		var segment_width := minf(center_width, width - cap - x)
		draw_texture_rect_region(ROOT_TEXTURE, Rect2(x, -8, segment_width, height), Rect2(source_cap, 0, segment_width / texture_scale, source_height))
		x += segment_width
