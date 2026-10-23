extends Node2D
## Generated ENV-01 layers and individual exports, with collision kept independent of art.
const SceneArt = preload("res://scripts/editor/scene_art.gd")
var baking_static := false
var bake_art_path := NodePath("StaticArt")
const ART := "res://assets/runtime/prologue/environment/"
var cart_moved := false
var hearth_failed := false
var beam_moved := false
var clock := 0.0
var cart_body: StaticBody2D
var platforms: Array[Rect2] = [Rect2(0, 620, 4400, 180), Rect2(400, 575, 100, 45)]
var textures: Dictionary = {}
var font: Font
var darkness := 0.0
var prop_regions: Dictionary = {}
var wall_style := StyleBoxFlat.new()

func _ready() -> void:
	font = ThemeDB.fallback_font
	for key in ["distant_background", "distant_background_mirrored", "midground", "foreground"]:
		textures[key] = load(ART + "ENV-01_" + key + ".png")
	textures["surface"] = load(ART + "TILE-001_surface_strip.png")
	textures["timbers"] = load(ART + "TILE-006_timbers.png")
	textures["soil"] = load(ART + "TILE-002_soil_fill.png")
	for segment in ["00_left_entry", "01_middle_repeat", "02_right_entry"]:
		textures[segment] = load(ART + "PROP-006_" + segment + ".png")
	for actor in ["rusk", "villager"]:
		textures[actor] = load(ART + "ENV-01_" + actor + "_idle.png")
	for i in [0, 1, 2, 3, 5, 6, 7]:
		textures["decor%d" % i] = load(ART + "ENV-01_decorative_props_%02d.png" % i)
	for i in range(6):
		textures["interact%d" % i] = load(ART + "ENV-01_interactive_props_%02d.png" % i)
	for key in ["01_top_middle", "05_opaque_interior", "03_isolated_block"]:
		textures[key] = load(ART + "TILE-001_" + key + ".png")
	for key in ["PROP-004_00_intact", "PROP-009_closed_unlatched", "PROP-010_roof_left_eave", "PROP-010_roof_repeat", "PROP-010_roof_right_eave", "PROP-010_window_closed", "PROP-010_window_round", "PROP-011_bush_low", "PROP-011_bush_round", "PROP-011_flower_white", "PROP-011_mixed_ground_plants", "PROP-012_root_arch", "PROP-012_root_stump", "PROP-012_small_bare_tree", "PROP-012_sapling_leafy"]:
		textures[key] = load(ART + key + ".png")
	# Tight visible bounds anchor every isolated prop/NPC to its contact point.
	for key in textures:
		var image: Image = textures[key].get_image()
		if image == null: continue
		var bounds := image.get_used_rect()
		if bounds.has_area():
			var atlas := AtlasTexture.new()
			atlas.atlas = textures[key]
			atlas.region = bounds
			prop_regions[key] = atlas
	if not has_node("Terrain"):
		var terrain := Node2D.new()
		terrain.name = "Terrain"
		add_child(terrain)
		for rect in platforms: _add_body(rect, terrain)
	else:
		platforms.clear()
		for body in get_node("Terrain").get_children():
			for shape_node in body.get_children():
				if shape_node is CollisionShape2D and shape_node.shape is RectangleShape2D:
					var size: Vector2 = shape_node.shape.size * body.scale * shape_node.scale
					platforms.append(Rect2(body.position + shape_node.position - size * 0.5, size))
	cart_body = get_node_or_null("CartCollision")
	if cart_body == null:
		cart_body = _add_body(Rect2(1710, 578, 80, 42))
		cart_body.name = "CartCollision"

func _add_body(rect: Rect2, parent: Node = self) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	body.add_child(collision)
	parent.add_child(body)
	return body

func get_platforms() -> Array[Rect2]:
	return platforms

func move_cart() -> void:
	cart_moved = true
	cart_body.position.x = 1900

func _process(delta: float) -> void:
	clock += delta
	darkness = move_toward(darkness, 1.0 if hearth_failed else 0.0, delta * 1.7)
	if has_node("StaticArt"):
		get_node("StaticArt").modulate = Color.WHITE.lerp(Color(0.40, 0.52, 0.64), darkness * 0.8)
	_update_story_art()
	queue_redraw()

func _image(key: String, rect: Rect2, tint: Color = Color.WHITE) -> void:
	if textures.has(key):
		if baking_static: SceneArt.image(get_node(bake_art_path), textures[key], rect, tint)
		else: draw_texture_rect(textures[key], rect, false, tint)

func _prop(key: String, at: Vector2, size: Vector2, tint: Color = Color.WHITE) -> void:
	if not prop_regions.has(key): return
	var texture: Texture2D = prop_regions[key]
	var ratio := texture.get_width() / float(texture.get_height())
	var height := minf(size.y, size.x / ratio)
	var visible_size := Vector2(height * ratio, height)
	var rect := Rect2(at - Vector2(visible_size.x / 2, visible_size.y), visible_size)
	if baking_static: SceneArt.image(get_node(bake_art_path), texture, rect, tint)
	else: draw_texture_rect(texture, rect, false, tint)

func _text(at: Vector2, text: String, color: Color = Color("e5d7b4"), size: int = 15) -> void:
	if baking_static:
		SceneArt.text(get_node(bake_art_path), at, text, color, size)
		return
	draw_string(font, at + Vector2(1, 2), text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color("152322"))
	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func bake_static_art() -> void:
	if has_node("StaticArt"): get_node("StaticArt").free()
	var art := Node2D.new()
	art.name = "StaticArt"
	add_child(art)
	baking_static = true
	_draw_static()
	baking_static = false

func bake_story_art() -> void:
	var props := Node2D.new()
	props.name = "StoryProps"
	add_child(props)
	baking_static = true
	for spec in [
		["HearthLit","interact1",Vector2(1200,622),Vector2(220,240)],
		["HearthFailed","interact0",Vector2(1200,622),Vector2(220,240)],
		["CartInitial","interact2",Vector2(1750,622),Vector2(135,114)],
		["CartMoved","interact3",Vector2(1900,622),Vector2(135,114)],
		["BeamFallen","interact4",Vector2(2460,622),Vector2(220,170)],
		["BeamMoved","interact5",Vector2(2460,622),Vector2(220,170)],
	]:
		var item := Node2D.new()
		item.name = spec[0]
		props.add_child(item)
		bake_art_path = item.get_path()
		_prop(spec[1],spec[2],spec[3])
	baking_static = false
	bake_art_path = NodePath("StaticArt")
	_update_story_art()

func _update_story_art() -> void:
	var props := get_node_or_null("StoryProps")
	if props == null: return
	props.modulate = Color.WHITE.lerp(Color(0.40,0.52,0.64),darkness*0.8)
	props.get_node("HearthLit").visible = not hearth_failed
	props.get_node("HearthFailed").visible = hearth_failed
	props.get_node("CartInitial").visible = not cart_moved
	props.get_node("CartMoved").visible = cart_moved
	props.get_node("BeamFallen").visible = hearth_failed and not beam_moved
	props.get_node("BeamMoved").visible = hearth_failed and beam_moved

func _draw_static() -> void:
	if textures.is_empty(): return
	var scene_tint := Color.WHITE.lerp(Color(0.40, 0.52, 0.64), darkness * 0.8)
	# World-scale authored districts: homes, communal square, supply bridge,
	# damaged old roots, then the warden's cottage and forest threshold.
	_house(245, 280, 220, scene_tint)
	_house(3310, 285, 219, scene_tint)
	_house(3840, 260, 208, scene_tint)
	_prop("PROP-012_small_bare_tree", Vector2(2700, 620), Vector2(380, 450), scene_tint)
	_prop("PROP-012_root_arch", Vector2(2450, 620), Vector2(375, 340), scene_tint)
	for x in [100, 1550, 3060, 4100]:
		_prop("PROP-012_sapling_leafy", Vector2(x, 620), Vector2(135, 195), scene_tint)
	# Festival decoration belongs to the square, suspended from two visible poles.
	for x in [1010, 1390]:
		SceneArt.line(get_node(bake_art_path),PackedVector2Array([Vector2(x,620),Vector2(x,342)]),Color("5c4930"),9)
	SceneArt.line(get_node(bake_art_path),PackedVector2Array([Vector2(1010,342),Vector2(1200,365),Vector2(1390,342)]),Color("9a8153") * scene_tint,3)
	_prop("decor7", Vector2(1200, 440), Vector2(390, 90), scene_tint)
	for x in [1010,1390]:
		_prop("decor0", Vector2(x, 450), Vector2(45,75), scene_tint)
	# Opaque soil is backed by a single dark fill so alpha at tile boundaries cannot reveal the sky.
	SceneArt.rect(get_node(bake_art_path),Rect2(0,624,4400,300),Color("38402e"))
	for x in range(0, 4416, 64):
		for y in [640, 704, 768, 832]:
			_image("soil", Rect2(x, y, 65, 65), scene_tint)
		_image("surface", Rect2(x, 616, 65, 39), scene_tint)
	SceneArt.image(get_node(bake_art_path),prop_regions["03_isolated_block"],Rect2(400,575,100,45),scene_tint)
	for x in [215, 710, 930, 1470, 2080, 2830, 3540, 3970, 4240]:
		_prop("PROP-011_bush_low", Vector2(x, 624), Vector2(110, 52), scene_tint)
	for x in [340, 740, 1510, 2920, 3590, 4150]:
		_prop("PROP-011_flower_white", Vector2(x, 623), Vector2(45, 36), scene_tint)
	_prop("PROP-004_00_intact", Vector2(1570, 620), Vector2(67, 65), scene_tint)
	_prop("PROP-004_00_intact", Vector2(2080, 620), Vector2(80, 78), scene_tint)
	_prop("PROP-012_root_stump", Vector2(2870, 620), Vector2(100, 95), scene_tint)
	# Bridge deck follows collision top620; rail is behind the player and cart.
	_image("00_left_entry", Rect2(1600, 515, 150, 143), scene_tint)
	_image("01_middle_repeat", Rect2(1748, 591, 152, 48), scene_tint)
	_image("02_right_entry", Rect2(1898, 515, 150, 146), scene_tint)
	for x in [850, 1400, 4200]:
		_prop("decor2", Vector2(x, 620), Vector2(100, 105), scene_tint)

	_text(Vector2(1120, 370), "HEARTHLIGHT SQUARE", Color("eac38a"), 18)


	_text(Vector2(4040, 480), "FORGOTTEN TRAIL  →", Color("eac38a"), 19)
	_npc(Vector2(650, 620), "villager", scene_tint)
	_npc(Vector2(3700, 620), "rusk", scene_tint)
	_text(Vector2(3665, 525), "RUSK")

func _draw() -> void:
	if textures.is_empty(): return
	if darkness < 0.98:
		for r in [48.0, 78.0, 113.0]:
			draw_circle(Vector2(1200, 512), r, Color(1.0, 0.64, 0.22, (1.0 - darkness) * (0.03 + sin(clock * 2) * 0.004)))
	# Sparse particles keep the lantern-wake alive, without obscuring the player route.
	if darkness < 0.98:
		for i in range(28):
			var at := Vector2(fmod(i * 173.0 + clock * 9.0, 4400.0), 450 + sin(clock * 0.7 + i) * 65)
			draw_circle(at, 1.5, Color(1, 0.8, 0.4, (1.0 - darkness) * 0.45))


func _npc(at: Vector2, actor: String, tint: Color) -> void:
	var texture: Texture2D = textures[actor]
	var height := 92.0 if actor == "rusk" else 85.0
	var width := height * texture.get_width() / texture.get_height()
	_prop(actor, at, Vector2(width, height), tint)

func _house(x: float, width: float, height: float, tint: Color) -> void:
	# Structural timber wall fills the space between generated roof/door/window modules.
	var wall := Rect2(x - width * 0.43, 620 - height * 0.72, width * 0.86, height * 0.72)
	SceneArt.rect(get_node(bake_art_path),wall,Color("746449")*tint)
	SceneArt.image(get_node(bake_art_path),textures["timbers"],wall.grow(-4),Color(0.66,0.64,0.57)*tint,true)
	for offset in [-0.4, 0.0, 0.4]:
		SceneArt.line(get_node(bake_art_path),PackedVector2Array([Vector2(x+width*offset,wall.position.y),Vector2(x+width*offset,620)]),Color("403b2a")*tint,7)
	_prop("PROP-010_roof_repeat", Vector2(x, wall.position.y + 20), Vector2(width * 0.78, 110), tint)
	_prop("PROP-010_roof_left_eave", Vector2(x - width * 0.39, wall.position.y + 21), Vector2(width * 0.39, 120), tint)
	_prop("PROP-010_roof_right_eave", Vector2(x + width * 0.39, wall.position.y + 21), Vector2(width * 0.39, 120), tint)
	_prop("PROP-009_closed_unlatched", Vector2(x, 621), Vector2(74, 119), tint)
	for side in [-1, 1]:
		_prop("PROP-010_window_closed", Vector2(x + side * width * 0.28, 560), Vector2(52, 66), tint)

func _wall_style(tint: Color) -> StyleBoxFlat:
	var style := wall_style
	style.bg_color = Color("746449") * tint
	style.border_color = Color("403b2a") * tint
	style.set_border_width_all(5)
	style.set_corner_radius_all(8)
	return style
