extends Node2D
## Briarwake's orchard scenery. Chapter gameplay owns every collision and platform.
## Assign `game` before adding this node; the parent is the fallback controller.
const ReferenceDecor = preload("res://scripts/systems/reference_jungle_decor.gd")
const SceneArt = preload("res://scripts/editor/scene_art.gd")
const BINDING_X := [1500.0, 3300.0, 4300.0]
const BINDING_Y := [450.0, 620.0, 620.0]
const FRAGMENT = preload("res://assets/runtime/chapter01/story/fragment.png")
const ORCHARD_BACKGROUND = preload("res://assets/runtime/chapter01/story/orchard_background.png")
const ORCHARD_TREES = preload("res://assets/runtime/chapter01/story/orchard_trees.png")
const COLUMN = preload("res://assets/runtime/chapter01/environment/ENV-03_decorative_props_01.png")
const RUBBLE = preload("res://assets/runtime/chapter01/environment/ENV-03_decorative_props_05.png")
const WORLD_WIDTH := 7600.0
var game: Node
var platforms: Array[Rect2] = [Rect2(0, 620, 1900, 420), Rect2(2500, 620, 1900, 420), Rect2(4700, 620, 2900, 420)]
var decor = ReferenceDecor.new()
var clock := 0.0
var _lanterns: Array[Dictionary] = []
var reduced_effects := false

func _ready() -> void:
	if game == null:
		game = get_parent()
	z_index = -10
	decor.load_assets()
	_build_background()
	_build_orchard()
	queue_redraw()

func _build_background() -> void:
	if not decor.available(): return
	var layer := Parallax2D.new()
	layer.name = "OrchardDistance"
	layer.scroll_scale = Vector2(0.10, 0.12)
	layer.z_index = -30
	add_child(layer)
	var texture: Texture2D = ORCHARD_BACKGROUND
	# The original 1536x1024 painting is reduced slightly, never enlarged.
	var scale_factor := minf(1.0, 1000.0 / texture.get_height())
	var size := texture.get_size() * scale_factor
	for tile in range(-1, 7):
		var sprite := SceneArt.image(layer, texture, Rect2(Vector2(tile * size.x, -200), size))
		sprite.flip_h = posmod(tile, 2) == 1

func _build_orchard() -> void:
	var scenery := Node2D.new()
	scenery.name = "RootedOrchard"
	scenery.show_behind_parent = true
	add_child(scenery)
	# ENV-04's authored orchard plane already includes real blossoms, fruit and ruins.
	# Keep its base on the broad solid islands and preserve the original palette.
	for x in [10.0, 2580.0, 4780.0, 6190.0]:
		var plane := SceneArt.image(scenery, ORCHARD_TREES, Rect2(x, -301, 1400, 933.333))
		var edge := Shader.new()
		edge.code = "shader_type canvas_item; void fragment() { vec4 pixel=texture(TEXTURE,UV); pixel.a *= smoothstep(0.0,0.07,UV.x) * smoothstep(0.0,0.07,1.0-UV.x); COLOR = pixel * COLOR; }"
		var edge_material := ShaderMaterial.new()
		edge_material.shader = edge
		plane.material = edge_material
	decor.building_nodes = true
	# Waterfalls fill real gaps; they cannot be mistaken for safe platforms.
	for x in [2200.0, 4550.0]:
		decor.prop(scenery, "ENV-02_waterfall", Vector2(x, 1100), Vector2(280, 670))
	decor.building_nodes = false
	for rect in platforms:
		decor.build_terrain(scenery, rect)
	decor.build_foliage(scenery, platforms)
	# Low orchard shrubs keep combat silhouettes and the ground edge visible.
	decor.building_nodes = true
	for x in [160.0, 840.0, 1190.0, 1720.0, 2660.0, 3100.0, 3650.0, 4100.0, 4880.0, 5060.0, 6900.0, 7440.0]:
		decor.prop(scenery, "PROP-011_bush", Vector2(x, 626), Vector2(145, 65))
	for x in [360.0, 1040.0, 2790.0, 3750.0, 4950.0, 7000.0]:
		var item := {"key":"PROP-001_lantern_post", "foot":Vector2(x,620), "bounds":Vector2(84,210)}
		_build_lantern(scenery, item)
	for x in [5540.0, 6400.0]:
		var item := {"key":"PROP-002_lantern_hanging", "foot":Vector2(x,305), "bounds":Vector2(76,116)}
		_build_lantern(scenery, item)
	decor.building_nodes = false
	for entry in [[250.0, "BRIARWAKE ORCHARD"], [2620.0, "THE TANGLED BOUGHS"], [4940.0, "HEARTROOT CLEARING"], [7010.0, "THE WAY BELOW"]]:
		SceneArt.text(scenery, Vector2(entry[0]-100, 390), entry[1], Color("ffe3a0"), 18)

func _build_lantern(parent: Node2D, item: Dictionary) -> void:
	var bounds := decor.prop_rect(item.key, item.foot, item.bounds)
	var pivot := Node2D.new()
	pivot.position = bounds.position + Vector2(bounds.size.x * 0.5, 0.0)
	parent.add_child(pivot)
	SceneArt.image(pivot, decor.textures[item.key], Rect2(bounds.position - pivot.position, bounds.size))
	item["pivot"] = pivot
	item["flame_offset"] = decor.lantern_flame(item) - pivot.position
	_lanterns.append(item)

func _process(delta: float) -> void:
	var presentation: Variant = game.get("presentation") if is_instance_valid(game) else null
	reduced_effects = is_instance_valid(presentation) and bool(presentation.get("reduced_effects"))
	var player: Variant = game.get("player") if is_instance_valid(game) else null
	if is_instance_valid(player) and bool(player.get("active")):
		clock += delta
	for index in _lanterns.size():
		var item: Dictionary = _lanterns[index]
		if item.key == "PROP-002_lantern_hanging":
			var pivot: Node2D = item.pivot
			pivot.rotation = 0.0 if reduced_effects else sin(clock * 1.15 + index * 1.7) * 0.025
	queue_redraw()

func _flag(property_name: String) -> bool:
	return bool(game.get(property_name)) if is_instance_valid(game) else false

func _binding_freed(index: int) -> bool:
	if not is_instance_valid(game): return false
	var values = game.get("bindings_freed")
	return values is Array and index < values.size() and bool(values[index])

func _draw() -> void:
	if not decor.available(): return
	for index in range(BINDING_X.size()):
		var x: float = BINDING_X[index]
		var floor_y: float = BINDING_Y[index]
		var freed := _binding_freed(index)
		if freed:
			decor.prop(self, "PROP-012_stump", Vector2(x, floor_y), Vector2(75, 65))
			decor.prop(self, "PROP-011_lush_fern", Vector2(x+50, floor_y), Vector2(85, 50))
		else:
			decor.prop(self, "OBJ-004_root_seal", Vector2(x,floor_y), Vector2(135,185))
			# The knot's warm core marks an interactable, never a false landing.
			var pulse := 0.65 if reduced_effects else 0.65 + 0.15 * sin(clock * 2.2 + index)
			draw_arc(Vector2(x, floor_y-72), 22, 0, TAU, 32, Color(1.0, 0.76, 0.30, pulse), 2, true)
		var label := "RESTORED" if freed else "ROOT BINDING %s" % ["I", "II", "III"][index]
		draw_string(ThemeDB.fallback_font, Vector2(x-70, floor_y-208), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("ffe3a0"))
	_draw_lantern_embers()
	_draw_column()
	var defeated := _flag("boss_defeated")
	if _flag("boss_active") and not defeated:
		# Low thorn silhouettes mark the arena boundary without hiding the boss.
		for x in [5230.0, 6780.0]:
			decor.prop(self, "OBJ-004_root_seal", Vector2(x, 620), Vector2(95, 145))
	if defeated:
		for x in [5400.0, 5620.0, 6200.0, 6500.0]:
			decor.prop(self, "PROP-011_lush_fern", Vector2(x, 620), Vector2(110, 48))
	# Gameplay owns pickup distance; the icon shares the grounded plinth's location.
	decor.prop(self, "PROP-012_stump", Vector2(6720, 620), Vector2(100, 90))
	if defeated and not _flag("fragment_collected") and is_instance_valid(game.get("rewards")) and game.rewards.chest_opened:
		draw_arc(Vector2(6720, 497), 35 + (0.0 if reduced_effects else sin(clock*2.0)*3), PI, TAU, 32, Color("ffd681"), 2, true)
		var icon_size: Vector2 = FRAGMENT.get_size()
		icon_size *= minf(1.0, 54.0 / maxf(icon_size.x, icon_size.y))
		draw_texture_rect(FRAGMENT, Rect2(Vector2(6720,497 + (0.0 if reduced_effects else sin(clock*2.0)*4))-icon_size*0.5, icon_size), false)

func _draw_column() -> void:
	var hits := 0
	var exposed := false
	if is_instance_valid(game):
		var boss = game.get("boss")
		if is_instance_valid(boss):
			hits = int(boss.get("column_hits"))
			exposed = bool(boss.get("binding_exposed"))
	var broken := hits >= 3 or exposed
	var texture: Texture2D = RUBBLE if broken else COLUMN
	# Reuse the actual root-wrapped temple column and its matching rubble.
	# Hit counts remain dynamic text; no invented damage artwork is substituted.
	var size := texture.get_size()
	size *= minf(1.0, minf(150.0 / size.x, 210.0 / size.y))
	draw_texture_rect(texture, Rect2(Vector2(6410-size.x*0.5,620-size.y),size),false)
	if _flag("boss_active") and not broken:
		draw_string(ThemeDB.fallback_font, Vector2(6335,620-size.y-16), "OPTIONAL COLUMN  %d / 3" % hits, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("ffe3a0"))

func _draw_lantern_embers() -> void:
	if reduced_effects: return
	# Sparse embers stay at actual flame sources, clear of the combat silhouette.
	for index in _lanterns.size():
		var item: Dictionary = _lanterns[index]
		var pivot: Node2D = item.pivot
		var flame := to_local(pivot.to_global(item.flame_offset))
		for ember in 3:
			var life := fposmod(clock * 0.28 + index * 0.37 + ember / 3.0, 1.0)
			var at := flame + Vector2(sin(life * TAU + index) * 6.0, -life * 31.0)
			draw_circle(at, 1.2, Color(1.0, 0.78, 0.38, sin(life * PI) * 0.40))

func get_reference_light_anchors() -> Array[Dictionary]:
	var anchors: Array[Dictionary] = []
	for item in _lanterns:
		var pivot: Node2D = item.pivot
		var flame := to_local(pivot.to_global(item.flame_offset))
		anchors.append({"world_position":to_global(flame), "local_position":flame, "color":Color("ffc75a"), "energy":0.55, "radius":190.0, "active":true})
	return anchors
