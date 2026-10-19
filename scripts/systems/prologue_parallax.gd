extends Node2D
## Independent native Parallax2D planes; grounded gameplay art stays in world space.
const ART := "res://assets/runtime/prologue/environment/"
var village: Node2D
var layers: Array[Parallax2D] = []
var darkness := 0.0


func _ready() -> void:
	# Each period contains a normal and mirrored tile. Repeat sizes use displayed pixels.
	var sky := _layer("Sky", 0.12, -40, 2560)
	_tile(sky, "distant_background", Vector2(0, -150), Vector2(1280, 854), Color("a3b1b2"))
	_tile(sky, "distant_background_mirrored", Vector2(1280, -150), Vector2(1280, 854), Color("a3b1b2"))
	var hills := _layer("ForestHorizon", 0.28, -35, 2560)
	for x in [0, 1280]:
		var band: Texture2D = load(ART + "ENV-01_distant_background.png")
		var sprite := Sprite2D.new()
		sprite.texture = band
		sprite.centered = false
		sprite.position = Vector2(x, -197)
		sprite.scale = Vector2(1280.0 / 1536.0, 0.9)
		sprite.flip_h = x != 0
		sprite.modulate = Color(0.6, 0.75, 0.79, 0.8)
		sprite.material = _fade_material(true)
		hills.add_child(sprite)
	var forest := _layer("DistantVillage", 0.42, -30, 3200)
	_tile(forest, "midground", Vector2(0, -345), Vector2(1600, 1067), Color(0.48, 0.59, 0.63, 0.72))
	_tile(forest, "midground", Vector2(1600, -345), Vector2(1600, 1067), Color(0.48, 0.59, 0.63, 0.72), true)
	var canopy := _layer("NearCanopy", 1.12, 10, 2560)
	# Fade the full foreground image rather than cutting lanterns/leaves at an atlas edge.
	for x in [0, 1280]:
		var sprite := Sprite2D.new()
		sprite.texture = load(ART + "ENV-01_foreground.png")
		sprite.centered = false
		sprite.position = Vector2(x, -160)
		sprite.scale = Vector2(1280.0 / 1536.0, 0.74)
		sprite.modulate = Color(0.6, 0.73, 0.72, 0.75)
		sprite.material = _fade_material(false)
		canopy.add_child(sprite)

func _fade_material(top: bool) -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = "shader_type canvas_item; varying vec4 layer_tint; void vertex() { layer_tint = COLOR; } void fragment() { vec4 sample_color = texture(TEXTURE, UV); sample_color.a *= " + ("smoothstep(0.42, 0.60, UV.y)" if top else "(1.0 - smoothstep(0.24, 0.49, UV.y))") + "; COLOR = sample_color * layer_tint; }"
	var material := ShaderMaterial.new()
	material.shader = shader
	return material

func _layer(label: String, speed: float, depth: int, period: float) -> Parallax2D:
	var plane := Parallax2D.new()
	plane.name = label
	plane.scroll_scale = Vector2(speed, 1)
	plane.repeat_size = Vector2(period, 0)
	plane.repeat_times = 3
	plane.z_index = depth
	add_child(plane)
	layers.append(plane)
	return plane

func _tile(plane: Parallax2D, key: String, at: Vector2, size: Vector2, tint: Color, mirror := false) -> void:
	var texture: Texture2D = load(ART + "ENV-01_" + key + ".png")
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = at
	sprite.scale = size / texture.get_size()
	sprite.flip_h = mirror
	sprite.modulate = tint
	plane.add_child(sprite)

func _process(delta: float) -> void:
	if not is_instance_valid(village): return
	darkness = move_toward(darkness, 1.0 if village.hearth_failed else 0.0, delta * 1.7)
	modulate = Color.WHITE.lerp(Color(0.32, 0.45, 0.61), darkness * 0.8)

func _exit_tree() -> void:
	# Drop shader/texture references when a level is replaced, including native repeats.
	for layer in layers:
		for child in layer.get_children():
			if child is Sprite2D:
				child.material = null
				child.texture = null
	layers.clear()
	village = null
