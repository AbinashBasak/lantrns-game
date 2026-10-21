extends Node2D
## Restrained real-time lantern light over the reference title artwork only.
## Controls remain outside light mask 2, keeping their typography unchanged.
var game: Node
var backdrop: TextureRect
var enabled := true
var strength := 1.0
var canvas_layer := 1
var lights: Array[PointLight2D] = []
var elapsed := 0.0
var radial: GradientTexture2D
const REFERENCE_SIZE := Vector2(1672, 941)
const LANTERNS := [Vector2(145,190), Vector2(1250,174), Vector2(1170,260), Vector2(1370,280), Vector2(1460,480), Vector2(1610,700)]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	name = "TitleMenuLighting"
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.18, 0.5, 1.0])
	gradient.colors = PackedColorArray([Color.WHITE, Color(1,1,1,0.65), Color(1,1,1,0.12), Color(1,1,1,0)])
	radial = GradientTexture2D.new()
	radial.gradient = gradient
	radial.width = 256
	radial.height = 256
	radial.fill = GradientTexture2D.FILL_RADIAL
	radial.fill_from = Vector2(0.5,0.5)
	radial.fill_to = Vector2(1,0.5)
	for index in LANTERNS.size():
		var light := PointLight2D.new()
		light.name = "MenuLantern%d" % index
		light.texture = radial
		light.texture_scale = 0.85 if index == 0 else 1.15
		light.color = Color("ffd487")
		light.energy = 0.0
		light.range_item_cull_mask = 2
		light.range_layer_min = canvas_layer
		light.range_layer_max = canvas_layer
		light.shadow_enabled = false
		add_child(light)
		lights.append(light)
	_process(0.0)

func _process(delta: float) -> void:
	var menu_open: bool = is_instance_valid(game) and is_instance_valid(game.menu) and game.menu.visible
	visible = enabled and menu_open
	var reduced := false
	if is_instance_valid(game) and is_instance_valid(game.presentation):
		reduced = game.presentation.reduced_effects
	if not visible or reduced:
		for light in lights:
			light.energy = 0.0
		return
	elapsed += delta
	if not is_instance_valid(backdrop):
		return
	# The backdrop fills a 1280x720 design canvas; use its live dimensions.
	var ratio := backdrop.size / REFERENCE_SIZE
	for index in lights.size():
		lights[index].global_position = backdrop.global_position + LANTERNS[index] * ratio
		var pulse := 1.0 + sin(elapsed * 1.35 + index * 1.7) * 0.07 + sin(elapsed * 2.8 + index) * 0.025
		lights[index].energy = (0.025 if index == 0 else 0.035) * clampf(strength, 0.0, 1.0) * pulse

func _exit_tree() -> void:
	for light in lights:
		if is_instance_valid(light):
			light.texture = null
	lights.clear()
	radial = null
