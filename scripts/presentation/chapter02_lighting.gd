extends Node2D
## Source-anchored world lighting; the Chapter 1 CanvasLayer HUD stays unchanged.
const RADIAL = preload("res://assets/runtime/shared/lighting/soft_radial.tres")
const MAX_SHADOW_LIGHTS := 2
var game: Node2D
var ambient: CanvasModulate
var player_light: PointLight2D
var mote_light: PointLight2D
var chest_light: PointLight2D
var fragment_light: PointLight2D
var binding_lights: Array[PointLight2D] = []
const BINDING_SOURCES := [Vector2(1500,378),Vector2(3300,548),Vector2(4300,548)]
var actor_shadow: LightOccluder2D
var reference_emitters: Array[PointLight2D] = []
var prop_emitters: Array[PointLight2D] = []
var occluders: Array[LightOccluder2D] = []
var region := ""
var clock := 0.0
var flash := 0.0
var reduced_effects := false
var target_ambient := Color("eeeeee")
var reward_glow := Vector2.ZERO
# Allows identical frozen on/off validation while retaining ambient and HUD.
var illumination_enabled := true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("world_lighting")
	ambient = CanvasModulate.new()
	ambient.color = target_ambient
	add_child(ambient)
	player_light = _light(Vector2.ZERO,Color("ffdc9c"),0.20,185.0)
	mote_light = _light(Vector2.ZERO,Color("b6eddd"),0.26,145.0)
	chest_light = _light(Vector2(6570,565),Color("ffc76a"),0.0,230.0)
	fragment_light = _light(Vector2(6720,497),Color("ffcf75"),0.0,195.0)
	for light in [player_light,mote_light,chest_light,fragment_light]:
		light.set_meta("shadow_candidate",false)
	for point: Vector2 in BINDING_SOURCES:
		binding_lights.append(_light(point,Color("ffd681"),0.18,120.0))
	actor_shadow = _occluder(PackedVector2Array([Vector2(-9,-2),Vector2(-12,-48),Vector2(-8,-68),Vector2(8,-68),Vector2(12,-48),Vector2(9,-2)]),Vector2.ZERO,2)
	if is_instance_valid(game) and is_instance_valid(game.player) and game.player.has_signal("action_event"):
		game.player.action_event.connect(_on_action)
	_process(0.0)

func _light(at: Vector2, tint: Color, strength: float, radius: float) -> PointLight2D:
	var light := PointLight2D.new()
	light.texture = RADIAL
	light.texture_scale = radius / 128.0
	light.color = tint
	light.energy = strength
	light.position = at
	light.range_item_cull_mask = 1
	light.range_layer_min = 0
	light.range_layer_max = 0
	light.range_z_min = -45
	light.range_z_max = 100
	light.shadow_item_cull_mask = 3
	light.shadow_filter = Light2D.SHADOW_FILTER_PCF5
	light.shadow_color = Color(0.04,0.07,0.08,0.28)
	light.set_meta("base_energy",strength)
	add_child(light)
	return light

func _occluder(points: PackedVector2Array, at: Vector2, mask: int = 1) -> LightOccluder2D:
	var item := LightOccluder2D.new()
	var polygon := OccluderPolygon2D.new()
	polygon.polygon = points
	item.occluder = polygon
	item.position = at
	item.occluder_light_mask = mask
	add_child(item)
	return item

func _on_action(action: String, _at: Vector2) -> void:
	if action in ["swing","attack","hurt","pickup","fragment","checkpoint"]:
		flash = 0.22 if action != "hurt" else 0.32

func _region_key() -> String:
	var area: Variant = game.get("jungle_area")
	return "jungle_%d" % int(area) if area != null and int(area) >= 0 else "orchard"

func _source() -> Node2D:
	if region.begins_with("jungle_"):
		var rooms: Variant = game.get("jungle_rooms")
		var index := int(game.get("jungle_area"))
		if rooms is Array and index >= 0 and index < rooms.size(): return rooms[index]
		return null
	return game.get("environment")

func _rebuild_region() -> void:
	for item in occluders: item.queue_free()
	occluders.clear()
	target_ambient = Color("eeeeee")
	var terrain: Array = []
	var origin := Vector2.ZERO
	var source := _source()
	if region == "orchard":
		var authored: Variant = game.get("platforms")
		if authored is Array: terrain = authored
	elif is_instance_valid(source):
		origin = source.global_position
		if source.has_method("terrain"): terrain = source.terrain()
		var index := int(game.get("jungle_area"))
		# The roots/cistern are modestly shaded with neutral grey, retaining hues.
		target_ambient = Color("dddddd") if index in [2,3] else Color("eeeeee")
	for rect: Rect2 in terrain:
		if rect.size.x <= 0.0 or rect.size.y <= 0.0: continue
		# Only authored solid rectangles: no arena gates, foliage or pit-spanning box.
		var points := PackedVector2Array([rect.position,rect.position+Vector2(rect.size.x,0),rect.end,rect.position+Vector2(0,rect.size.y)])
		occluders.append(_occluder(points,origin))

func _process(delta: float) -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.player): return
	var presentation: Variant = game.get("presentation")
	reduced_effects = is_instance_valid(presentation) and bool(presentation.get("reduced_effects"))
	var animating: bool = game.player.active
	if animating:
		clock += delta
		flash = maxf(0.0,flash-delta)
	var next := _region_key()
	if region != next:
		region = next
		_rebuild_region()
	ambient.color = ambient.color.lerp(target_ambient,1.0-exp(-delta*2.0))
	actor_shadow.global_position = game.player.global_position
	actor_shadow.visible = illumination_enabled and not reduced_effects
	player_light.global_position = game.player.global_position+Vector2(0,-52)
	player_light.energy = 0.20+(0.0 if reduced_effects else flash*0.25)
	var mote: Variant = game.get("mote")
	var mote_visible: bool = is_instance_valid(mote) and mote.is_visible_in_tree()
	if mote_visible: mote_light.global_position = mote.global_position
	mote_light.energy = 0.26 if reduced_effects else 0.26+sin(clock*2.0)*0.012
	var camera := get_viewport().get_camera_2d()
	var center: Vector2 = camera.get_screen_center_position() if camera else game.player.global_position
	_visible_light(player_light,_in_view(player_light,center))
	_visible_light(mote_light,mote_visible and _in_view(mote_light,center))
	_update_bindings(delta if animating else 0.0,center)
	_update_reference(center)
	_update_props(center)
	_update_rewards(delta if animating else 0.0,center)
	_update_shadows(center)

func _update_bindings(delta: float, center: Vector2) -> void:
	var freed: Variant = game.get("bindings_freed")
	for index in binding_lights.size():
		var light := binding_lights[index]
		var restored: bool = freed is Array and index < freed.size() and bool(freed[index])
		var tint := Color("b6eddd") if restored else Color("ffd681")
		var energy := 0.08 if restored else 0.18
		var blend := 1.0-exp(-delta*3.0)
		light.color = light.color.lerp(tint,blend)
		light.energy = lerpf(light.energy,energy,blend)
		light.position.y = BINDING_SOURCES[index].y + (42.0 if restored else 0.0)
		_visible_light(light,region == "orchard" and _in_view(light,center))

func _update_reference(center: Vector2) -> void:
	var source := _source()
	var anchors: Array = []
	if is_instance_valid(source) and source.has_method("get_reference_light_anchors"):
		anchors = source.get_reference_light_anchors()
	while reference_emitters.size() > anchors.size():
		var old: PointLight2D = reference_emitters.pop_back()
		old.queue_free()
	while reference_emitters.size() < anchors.size():
		reference_emitters.append(_light(Vector2.ZERO,Color("ffc75a"),0.22,190.0))
	for i in anchors.size():
		var entry: Dictionary = anchors[i]
		var light := reference_emitters[i]
		light.global_position = entry.get("world_position",source.to_global(entry.get("local_position",Vector2.ZERO)))
		light.texture_scale = float(entry.get("radius",190.0))/128.0
		light.color = entry.get("color",Color("ffc75a"))
		var strength := minf(float(entry.get("energy",0.22)),0.32)
		light.energy = strength*_flicker(i*2.1)
		_visible_light(light,bool(entry.get("active",true)) and source.is_visible_in_tree() and _in_view(light,center))

func _update_props(center: Vector2) -> void:
	# Independently authored moving/mirrored lanterns keep their real flame origin.
	for anchor in get_tree().get_nodes_in_group("jungle_light_anchor"):
		if not anchor is Sprite2D or not game.is_ancestor_of(anchor): continue
		var found := false
		for light in prop_emitters:
			if light.get_meta("anchor",null) == anchor: found = true
		if found: continue
		var light := _light(Vector2.ZERO,Color("ffca79"),minf(float(anchor.get_meta("light_energy",0.22)),0.32),float(anchor.get_meta("light_radius",1.8))*128.0)
		light.set_meta("anchor",anchor)
		prop_emitters.append(light)
	for i in range(prop_emitters.size()-1,-1,-1):
		var light := prop_emitters[i]
		var anchor: Sprite2D = light.get_meta("anchor",null)
		if not is_instance_valid(anchor) or anchor.texture == null:
			light.queue_free()
			prop_emitters.remove_at(i)
			continue
		var uv: Vector2 = anchor.get_meta("light_uv",Vector2(0.5,0.5))
		if anchor.flip_h: uv.x = 1.0-uv.x
		if anchor.flip_v: uv.y = 1.0-uv.y
		var local := uv*anchor.texture.get_size()+anchor.offset
		if anchor.centered: local -= anchor.texture.get_size()*0.5
		light.global_position = anchor.to_global(local)
		light.energy = float(light.get_meta("base_energy"))*_flicker(float(anchor.get_instance_id()%101))
		var duplicate := false
		for reference in reference_emitters:
			if reference.enabled and reference.global_position.distance_squared_to(light.global_position) < 32.0*32.0:
				duplicate = true
				break
		_visible_light(light,not duplicate and anchor.is_visible_in_tree() and _in_view(light,center))

func _flicker(phase: float) -> float:
	return 1.0 if reduced_effects else 1.0+sin(clock*2.4+phase)*0.025+sin(clock*4.1+phase)*0.01

func _update_rewards(delta: float, center: Vector2) -> void:
	var defeated := bool(game.get("boss_defeated")) and region == "orchard"
	var collected := bool(game.get("fragment_collected"))
	var rewards: Variant = game.get("rewards")
	var available := defeated and is_instance_valid(rewards) and bool(rewards.get("chest_available"))
	var chest := (0.15 if bool(rewards.get("chest_opened")) else 0.22) if available else 0.0
	if available and not reduced_effects:
		var opening: Variant = rewards.get("animation_time")
		if opening != null and bool(rewards.get("chest_opened")):
			chest += 0.24*exp(-pow((float(opening)-0.95)/0.52,2.0))
	var fragment := 0.28 if available and bool(rewards.get("chest_opened")) and not collected else 0.0
	var blend := 1.0-exp(-delta*5.0)
	reward_glow = reward_glow.lerp(Vector2(chest,fragment),blend)
	if not defeated: reward_glow = Vector2.ZERO
	chest_light.energy = reward_glow.x
	fragment_light.energy = reward_glow.y*_flicker(1.3)
	var environment: Variant = game.get("environment")
	var source_time := float(environment.get("clock")) if is_instance_valid(environment) and "clock" in environment else clock
	fragment_light.position.y = 497.0+(0.0 if reduced_effects else sin(source_time*2.0)*4.0)
	for light in [chest_light,fragment_light]:
		_visible_light(light,light.energy > 0.005 and _in_view(light,center))

func _visible_light(light: PointLight2D, active: bool) -> void:
	light.visible = active and illumination_enabled
	light.enabled = active and illumination_enabled
	if not light.enabled: light.shadow_enabled = false

func _in_view(light: PointLight2D, center: Vector2) -> bool:
	var camera := get_viewport().get_camera_2d()
	var half := get_viewport_rect().size*0.5
	if camera: half /= camera.zoom
	var reach := Vector2.ONE*(128.0*light.texture_scale+32.0)
	return Rect2(center-half-reach,(half+reach)*2.0).has_point(light.global_position)

func _update_shadows(center: Vector2) -> void:
	var candidates: Array[PointLight2D] = []
	for collection in [reference_emitters,prop_emitters]:
		for light in collection:
			light.shadow_enabled = false
			if light.visible and light.enabled: candidates.append(light)
	if reduced_effects or not illumination_enabled: return
	candidates.sort_custom(func(a: PointLight2D,b: PointLight2D) -> bool:
		return a.global_position.distance_squared_to(center)<b.global_position.distance_squared_to(center))
	for i in mini(MAX_SHADOW_LIGHTS,candidates.size()): candidates[i].shadow_enabled = true

func _exit_tree() -> void:
	for child in get_children():
		if child is PointLight2D: child.texture = null
		if child is LightOccluder2D: child.occluder = null
