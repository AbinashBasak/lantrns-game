@tool
extends Node2D
## Selected ENV-02/03 art, finite parallax planes and contact-aligned world props.
## Gameplay owns collisions; this node draws exactly the supplied platform rectangles.
const SceneArt = preload("res://scripts/editor/scene_art.gd")
var art_target: Node2D
const ReferenceDecor = preload("res://scripts/systems/reference_jungle_decor.gd")
var reference_decor = ReferenceDecor.new()
const ART := "res://assets/runtime/chapter01/environment/"
var platforms: Array[Rect2] = []
var bridge_open := false
var checkpoint_active := false
var boss_defeated := false
var boss_active := false
var fragment_collected := false
var rune_progress := 0
var rune_hint := -1
var textures: Dictionary = {}
var prop_regions: Dictionary = {}
var forest_layers: Array[Parallax2D] = []
var temple_layers: Array[Parallax2D] = []
var clock := 0.0

func _ready() -> void:
	load_assets()
	var terrain := get_parent().get_node_or_null("Terrain")
	if terrain:
		platforms.clear()
		for body in terrain.get_children():
			var shape: CollisionShape2D = body.get_node("CollisionShape2D")
			platforms.append(Rect2(body.position-shape.shape.size/2,shape.shape.size))
	_build_layers("ENV-02", forest_layers)
	_build_layers("ENV-03", temple_layers)
	for layer in temple_layers: layer.modulate.a = 0.0

func load_assets() -> void:
	if not textures.is_empty(): return
	reference_decor.load_assets()
	for pack in ["ENV-02", "ENV-03"]:
		for layer in ["distant_background", "midground", "foreground"]:
			_cache(pack + "_" + layer)
		for i in range(8): _cache(pack + "_decorative_props_%02d" % i)
		for i in range(6): _cache(pack + "_interactive_props_%02d" % i)
	for key in ["TILE-001_surface_strip", "TILE-002_soil_fill", "TILE-003_01_top_middle", "TILE-003_05_opaque_interior", "TILE-003_03_isolated_block"]:
		_cache(key)
func _cache(key: String) -> void:
	textures[key] = load(ART + key + ".png")
	if "_props_" in key:
		var texture: Texture2D = textures[key]
		var image := texture.get_image()
		var left := image.get_width()
		var top := image.get_height()
		var right := -1
		var bottom := -1
		# Export canvases retain faint atlas residue below the actual artwork.
		# Anchor the visible silhouette, ignoring nearly transparent pixels.
		for y in range(image.get_height()):
			for x in range(image.get_width()):
				if image.get_pixel(x, y).a < 0.125: continue
				left = mini(left, x)
				top = mini(top, y)
				right = maxi(right, x)
				bottom = maxi(bottom, y)
		prop_regions[key] = Rect2(left, top, right - left + 1, bottom - top + 1) if right >= left else Rect2(Vector2.ZERO, texture.get_size())

func _build_layers(pack: String, collection: Array[Parallax2D]) -> void:
	if has_node(pack + "Light"):
		for suffix in ["Light", "Horizon", "Architecture", "Canopy"]:
			collection.append(get_node(pack + suffix))
		return
	for index in range(4):
		var layer := Parallax2D.new()
		layer.name = pack + ["Light", "Horizon", "Architecture", "Canopy"][index]
		layer.scroll_scale = Vector2([0.05, 0.12, 0.24, 0.45][index], 0.12)
		layer.z_index = [-40, -35, -30, -5][index]
		# Finite world coverage; no native repeat can leak a temple beyond its transition.
		add_child(layer)
		collection.append(layer)
		var key: String = pack + "_" + ["distant_background", "distant_background", "midground", "foreground"][index]
		var forest_width := 1800
		if pack=="ENV-02" and reference_decor.available():
			var background: Texture2D = reference_decor.textures["ENV-02_background"]
			forest_width=ceili(1000.0*background.get_width()/background.get_height())
		for x in range(-forest_width, 12600, forest_width):
			var sprite := Sprite2D.new()
			sprite.texture = reference_decor.textures["ENV-02_background"] if pack=="ENV-02" and reference_decor.available() else textures[key]
			sprite.centered = false
			sprite.position = Vector2(x, -230)
			sprite.scale = Vector2(forest_width+1.0, 1000.0) / sprite.texture.get_size()
			sprite.flip_h = posmod(x / forest_width, 2) == 0
			sprite.modulate = [Color("9ac4bd"), Color(0.48,0.65,0.64,0.2), Color(0.55,0.69,0.67,0.65), Color(0.55,0.72,0.67,0.65)][index]
			if pack == "ENV-02": sprite.modulate = Color(1,1,1,1 if index==0 else 0)
			if pack == "ENV-03":
				sprite.modulate = [Color("e0ddc9"),Color(0.70,0.68,0.53,0.2),Color(0.72,0.76,0.70,0.65),Color(0.64,0.70,0.62,0.60)][index]
			if index == 2 or index == 3:
				var shader := Shader.new()
				shader.code = "shader_type canvas_item; varying vec4 tint; void vertex(){tint=COLOR;} void fragment(){vec4 c=texture(TEXTURE,UV); c.a *= 1.0-smoothstep(" + ("0.60,0.87" if index == 2 else "0.12,0.42") + ",UV.y); COLOR=c*tint;}"
				var material := ShaderMaterial.new()
				material.shader = shader
				sprite.material = material
			layer.add_child(sprite)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	clock += delta
	var camera := get_viewport().get_camera_2d()
	var camera_x: float = camera.get_screen_center_position().x if camera else 0.0
	var blend := smoothstep(4100.0, 4900.0, camera_x)
	for layer in forest_layers: layer.modulate.a = 1.0 - blend
	for layer in temple_layers: layer.modulate.a = blend
	queue_redraw()

func _image(key: String, rect: Rect2, tint := Color.WHITE) -> void:
	if not textures.has(key): return
	if art_target: SceneArt.image(art_target,textures[key],rect,tint)
	else: draw_texture_rect(textures[key], rect, false, tint)

func _prop(key: String, foot: Vector2, bounds: Vector2, tint := Color.WHITE) -> void:
	if not textures.has(key): return
	var texture: Texture2D = textures[key]
	var region: Rect2 = prop_regions.get(key, Rect2(Vector2.ZERO, texture.get_size()))
	var size := region.size * minf(bounds.x / region.size.x, bounds.y / region.size.y)
	var bounds_rect := Rect2(foot - Vector2(size.x * 0.5, size.y), size)
	if art_target: SceneArt.region(art_target,texture,bounds_rect,region,tint)
	else: draw_texture_rect_region(texture,bounds_rect,region,tint)

func _terrain(rect: Rect2) -> void:
	if rect.position.x < 4500 and rect.end.x > 4500:
		_terrain(Rect2(rect.position, Vector2(4500-rect.position.x,rect.size.y)))
		_terrain(Rect2(4500,rect.position.y,rect.end.x-4500,rect.size.y))
		return
	if rect.end.x <= 4500 and reference_decor.available():
		reference_decor.build_terrain(art_target,rect) if art_target else reference_decor.draw_terrain(self,rect)
		return
	var temple := rect.position.x >= 4500
	var surface := "TILE-003_01_top_middle" if temple else "TILE-001_surface_strip"
	var fill := "TILE-003_05_opaque_interior" if temple else "TILE-002_soil_fill"
	if art_target: SceneArt.rect(art_target,rect,Color("29332e"))
	else: draw_rect(rect, Color("29332e"))
	for x in range(int(rect.position.x), int(rect.end.x), 64):
		var width := minf(64.0, rect.end.x - x)
		for y in range(int(rect.position.y + 25), int(rect.end.y), 64):
			_image(fill, Rect2(x,y,width,minf(65.0,rect.end.y-y)))
		_image(surface, Rect2(x,rect.position.y-3,width+0.5,minf(39.0,rect.size.y+3)))

func build_static_art() -> void:
	load_assets()
	if has_node("StaticArt"): return
	art_target = Node2D.new()
	art_target.name = "StaticArt"
	# Scripted state overlays draw above the saved scenery, as before.
	art_target.show_behind_parent = true
	add_child(art_target)
	# Grounded architecture uses the same platform coordinates as gameplay.
	var forest_platforms: Array = []
	for rect in platforms:
		if rect.position.x < 4500: forest_platforms.append(Rect2(rect.position,Vector2(minf(rect.end.x,4500)-rect.position.x,rect.size.y)))
	var architecture := Node2D.new()
	architecture.name = "Architecture"
	architecture.z_index = -1
	art_target.add_child(architecture)
	reference_decor.build_architecture(architecture,forest_platforms)
	var scenery := art_target
	var terrain := get_parent().get_node_or_null("Terrain")
	if terrain:
		for body in terrain.get_children():
			art_target = Node2D.new()
			art_target.name = "Art"
			art_target.position = -body.position
			body.add_child(art_target)
			var collision: CollisionShape2D = body.get_node("CollisionShape2D")
			_terrain(Rect2(body.position-collision.shape.size/2,collision.shape.size))
	else:
		for rect in platforms: _terrain(rect)
	art_target = scenery
	reference_decor.build_foliage(art_target,forest_platforms)
	reference_decor.build_lanterns(art_target,forest_platforms,4500)
	for entry in [[650,"CANOPY PATH"],[4250,"FLOODED ROOTS"],[5800,"LANTERN GROVE"]]:
		_prop("ENV-02_decorative_props_00",Vector2(entry[0],620),Vector2(75,115))
		SceneArt.text(art_target,Vector2(entry[0]-65,480),entry[1],Color("f4d68c"),16)
	# Small landmarks are readable silhouettes, each belonging to its encounter.
	_prop("ENV-02_decorative_props_00", Vector2(300,620), Vector2(95,145))
	_prop("ENV-02_decorative_props_01", Vector2(2300,620), Vector2(220,335))
	_prop("ENV-02_decorative_props_06", Vector2(2150,620), Vector2(68,170))
	for x in [70,530,1360,2040,2590,4120,4360]:
		_prop("ENV-02_decorative_props_05", Vector2(x,624), Vector2(90,57))
	for x in [620,1480,2730]:
		_prop("ENV-02_decorative_props_04", Vector2(x,620), Vector2(75,75))
	_prop("ENV-03_interactive_props_05", Vector2(4700,620), Vector2(310,365))
	_prop("ENV-03_decorative_props_00", Vector2(5300,620), Vector2(250,220))
	for x in [5600,6440,8220,8800]:
		_prop("ENV-03_decorative_props_01",Vector2(x,620),Vector2(120,355),Color(0.62,0.72,0.73))
	_prop("ENV-03_interactive_props_01",Vector2(7950,620),Vector2(145,105))
	for x in [4900,5750,6320,8370]:
		_prop("ENV-03_decorative_props_05",Vector2(x,620),Vector2(85,55))
	art_target = null

func _draw() -> void:
	if textures.is_empty(): return
	reference_decor.draw_gate(self,3270,bridge_open)
	if bridge_open:
		for rect in [Rect2(3320,610,150,28),Rect2(3510,560,150,28),Rect2(3710,610,150,28)]:
			_image("ENV-02_interactive_props_05", rect)
	for i in range(3):
		var active := i < rune_progress
		var color := Color.WHITE if active else Color(0.70,0.84,0.80)
		if i == rune_hint: color = Color(1.0,0.86,0.45) * (1.0 + sin(clock*5.0)*0.22)
		_prop("ENV-02_interactive_props_%02d" % (4 if active else 1), Vector2(2860+i*140,620), Vector2(75,122),color)
		draw_string(ThemeDB.fallback_font,Vector2(2852+i*140,480),["I","II","III"][i],HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("f4d68c"))

	_prop("ENV-03_interactive_props_%02d" % (3 if checkpoint_active else 0), Vector2(6100,620), Vector2(150,185))
	if boss_active and not boss_defeated:
		_prop("ENV-03_interactive_props_02",Vector2(6500,620),Vector2(100,240),Color(0.75,0.52,0.42,0.9))
	_prop("ENV-03_interactive_props_%02d" % (5 if boss_defeated else 2),Vector2(8140,620),Vector2(140,230))
	_prop("ENV-03_interactive_props_%02d" % (5 if fragment_collected else 2), Vector2(8600,620),Vector2(220,290))
	if checkpoint_active:
		draw_arc(Vector2(6100,616),45,PI,TAU,24,Color(0.95,0.71,0.30,0.65),2,true)

func _exit_tree() -> void:
	forest_layers.clear()
	temple_layers.clear()

func get_reference_light_anchors() -> Array[Dictionary]:
	var forest_platforms: Array = []
	for rect in platforms:
		if rect.position.x < 4500: forest_platforms.append(Rect2(rect.position,Vector2(minf(rect.end.x,4500)-rect.position.x,rect.size.y)))
	var anchors: Array[Dictionary] = reference_decor.light_anchors(forest_platforms,4500,global_position)
	if not bridge_open: anchors.append({"world_position":global_position+Vector2(3270,480),"color":Color("ffc75a"),"energy":0.5,"radius":165.0,"active":true})
	return anchors
