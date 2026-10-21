extends Node2D
## World-only realtime light. CanvasLayer menus and HUD keep their authored colours.
const Jungle = preload("res://scripts/systems/chapter01_jungle.gd")
const MAX_SHADOW_LIGHTS := 2
const RADIAL = preload("res://assets/runtime/shared/lighting/soft_radial.tres")
var game: Node2D
var ambient: CanvasModulate
var player_light: PointLight2D
var mote_light: PointLight2D
var actor_shadow: LightOccluder2D
var boss_light: PointLight2D
var chest_light: PointLight2D
var fragment_light: PointLight2D
var portal_light: PointLight2D
var chest_glow := 0.0
var fragment_glow := 0.0
var portal_glow := 0.0
var landmarks: Array[PointLight2D] = []
var lantern_emitters: Array[PointLight2D] = []
var prop_emitters: Array[PointLight2D] = []
var reference_emitters: Array[PointLight2D] = []
var boss_burst := 0.0
# Measured flame centres in the unchanged 1536 × 1024 ENV-03 source.
const TEMPLE_FLAMES := [Vector2(300,300),Vector2(374,418),Vector2(800,580),Vector2(1196,418),Vector2(1308,296),Vector2(1460,410)]
var occluders: Array[LightOccluder2D] = []
var region := ""
var clock := 0.0
var reduced_effects := false
var flash := 0.0
var radial: GradientTexture2D
var target_ambient := Color("eeeeee")
var previous_boss_state := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("world_lighting")
	radial = RADIAL
	ambient = CanvasModulate.new()
	ambient.color = target_ambient
	add_child(ambient)
	player_light = _light(Vector2.ZERO,Color("ffdc9c"),0.22,1.65)
	mote_light = _light(Vector2.ZERO,Color("b6eddd"),0.28,1.15)
	boss_light = _light(Vector2.ZERO,Color("ffc177"),0.30,2.7)
	boss_light.hide()
	chest_light = _light(Vector2(7780,565),Color("ffc76a"),0.0,1.85)
	fragment_light = _light(Vector2(7950,475),Color("ffcf75"),0.0,1.55)
	portal_light = _light(Vector2(8600,520),Color("ffb95f"),0.0,2.15)
	for light in [chest_light,fragment_light,portal_light]:
		light.hide()
		light.shadow_enabled = false
	actor_shadow = LightOccluder2D.new()
	var body := OccluderPolygon2D.new()
	body.polygon = PackedVector2Array([Vector2(-9,-2),Vector2(-12,-48),Vector2(-8,-68),Vector2(8,-68),Vector2(12,-48),Vector2(9,-2)])
	actor_shadow.occluder = body
	actor_shadow.occluder_light_mask = 2
	add_child(actor_shadow)
	if is_instance_valid(game) and is_instance_valid(game.player) and game.player.has_signal("action_event"):
		game.player.action_event.connect(_on_action)
	_process(0.0)

func _light(at: Vector2, tint: Color, strength: float, radius: float) -> PointLight2D:
	var light := PointLight2D.new()
	light.texture = radial
	light.texture_scale = radius
	light.color = tint
	light.energy = strength
	light.position = at
	light.range_item_cull_mask = 1
	light.range_z_min = -45
	light.range_z_max = 100
	light.range_layer_min = 0
	light.range_layer_max = 0
	light.shadow_item_cull_mask = 3
	light.shadow_filter = Light2D.SHADOW_FILTER_PCF5
	light.shadow_color = Color(0.04,0.07,0.08,0.32)
	add_child(light)
	light.set_meta("base_energy",strength)
	return light

func _on_action(action: String, _position: Vector2) -> void:
	if action in ["swing","attack","hurt","pickup","fragment","checkpoint"]:
		flash = 0.25 if action != "hurt" else 0.4

func _region_key() -> String:
	if "jungle_area" in game:
		if game.jungle_area >= 0: return "jungle_%d" % game.jungle_area
		if game.boss_active: return "boss"
		return "temple" if game.player.position.x > 4500 else "forest"
	return "village"

func _process(delta: float) -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.player): return
	reduced_effects = is_instance_valid(game.presentation) and game.presentation.reduced_effects
	clock += delta
	var next := _region_key()
	if next != region:
		region = next
		_rebuild_region()
	if region == "village":
		target_ambient = Color("b8c8cd") if game.village.hearth_failed else Color("eeeeee")
	var tint := Color("f7f7f7") if reduced_effects else target_ambient
	ambient.color = ambient.color.lerp(tint,1.0-exp(-delta*2.0))
	actor_shadow.global_position = game.player.global_position
	player_light.global_position = game.player.global_position + Vector2(0,-52)
	mote_light.visible = is_instance_valid(game.mote) and game.mote.visible
	if mote_light.visible: mote_light.global_position = game.mote.global_position
	flash = maxf(0,flash-delta)
	boss_burst = maxf(0,boss_burst-delta*1.4)
	player_light.energy = 0.22 + (0.0 if reduced_effects else flash*0.35)
	mote_light.energy = 0.28 if reduced_effects else 0.28 + sin(clock*2.0)*0.018
	boss_light.visible = "boss" in game and is_instance_valid(game.boss) and game.boss_active
	if boss_light.visible:
		boss_light.global_position = game.boss.global_position+Vector2(0,-95)
		boss_light.color = Color("ff9157") if game.boss.berserk else Color("ffc98b")
		boss_light.energy = 0.30 if reduced_effects else 0.30+flash*0.25+boss_burst*0.20
		var state: String = game.boss.state
		if state != previous_boss_state and state in ["rootwave","eruption","rejuvenate","charge"]:
			flash = 0.35
			boss_burst = 0.8 if state == "rejuvenate" else 0.4
		previous_boss_state = state
	var camera := get_viewport().get_camera_2d()
	var center: Vector2 = camera.get_screen_center_position() if camera else game.player.global_position
	_set_light_visible(player_light,_in_view(player_light,center))
	_set_light_visible(mote_light,mote_light.visible and _in_view(mote_light,center))
	_set_light_visible(boss_light,boss_light.visible and _in_view(boss_light,center))
	_update_reference_lights(center)
	_update_prop_lights(center)
	_update_temple_lanterns(center)
	_update_reward_lights(delta,center)
	for light in landmarks:
		_set_light_visible(light,not light.get_meta("reference_replaced",false) and _in_view(light,center))
		var base: float = light.get_meta("base_energy")
		light.energy = base if reduced_effects else base*(1.0+sin(clock*2.5+light.position.x)*0.035)
		if region == "village" and light == landmarks[0] and game.village.hearth_failed: light.energy = 0.04

		if region == "boss":
			light.color = Color("ff9157") if game.boss.berserk else Color("ffc98b")
			light.energy += 0.0 if reduced_effects else boss_burst*0.12

	_update_shadow_budget(center)

func _update_reward_lights(delta: float, center: Vector2) -> void:
	# Source-gated lights remain separate from decorative landmark lights: a hidden
	# reward must never reveal itself through a halo before the encounter is won.
	var chapter := "boss_defeated" in game
	var defeated: bool = chapter and game.boss_defeated
	var rewards: Node = game.rewards if chapter and "rewards" in game else null
	var available: bool = defeated and is_instance_valid(rewards) and rewards.chest_available
	var collected: bool = chapter and game.fragment_collected
	var chest_target := 0.0
	if available:
		chest_target = 0.16 if rewards.chest_opened else 0.23
		if not reduced_effects:
			chest_target += sin(clock*2.2)*0.012
			if "animation_time" in rewards and rewards.chest_opened:
				# A broad warm swell, never a full-screen flash or a white core.
				var opening_time: float = rewards.animation_time
				chest_target += 0.32*exp(-pow((opening_time-0.95)/0.52,2.0))
			elif rewards.opening > 0:
				chest_target += minf(rewards.opening,1.0)*0.22
	var fragment_target := 0.30 if defeated and not collected else 0.0
	var portal_target := (0.30 if collected else 0.13) if defeated else 0.0
	if not reduced_effects:
		fragment_target *= 1.0+sin(clock*2.0)*0.055
		portal_target *= 1.0+sin(clock*1.25)*0.025
	var blend := 1.0-exp(-delta*5.0)
	chest_glow = lerpf(chest_glow,chest_target,blend)
	fragment_glow = lerpf(fragment_glow,fragment_target,blend)
	portal_glow = lerpf(portal_glow,portal_target,blend)
	# Hide immediately when the chapter is reset; collection itself fades gently.
	if not defeated:
		chest_glow = 0.0
		fragment_glow = 0.0
		portal_glow = 0.0
	chest_light.energy = chest_glow
	fragment_light.energy = fragment_glow
	portal_light.energy = portal_glow
	fragment_light.position.y = 475.0 + (0.0 if reduced_effects else sin(clock*2.0)*6.0)
	for light in [chest_light,fragment_light,portal_light]:
		_set_light_visible(light,light.energy > 0.005 and _in_view(light,center))

func _update_temple_lanterns(center: Vector2) -> void:
	# The lights follow the authored lanterns, including native parallax and mirrored tiles.
	# World coordinates alone would leave halos drifting away from their flames.
	for light in lantern_emitters:
		var anchor: Sprite2D = light.get_meta("anchor")
		if not is_instance_valid(anchor):
			_set_light_visible(light,false)
			continue
		var uv: Vector2 = light.get_meta("flame_uv")
		if anchor.flip_h: uv.x = 1.0-uv.x
		light.global_position = anchor.to_global(uv*anchor.texture.get_size())
		_set_light_visible(light,anchor.is_visible_in_tree() and _in_view(light,center))
		var base: float = light.get_meta("base_energy")
		var flicker := 1.0 if reduced_effects else 1.0+sin(clock*2.4+uv.x*31.0)*0.035+sin(clock*4.1+uv.y*17.0)*0.015
		light.energy = base*flicker
		light.color = Color("ffbd64")
		if region == "boss" and not reduced_effects:
			light.energy += boss_burst*0.06

func _build_temple_lanterns() -> void:
	if not ("environment" in game) or not is_instance_valid(game.environment): return
	if game.environment.temple_layers.is_empty(): return
	var layer: Parallax2D = game.environment.temple_layers[0]
	for sprite in layer.get_children():
		if not sprite is Sprite2D: continue
		for flame in TEMPLE_FLAMES:
			# Broad warm falloff lights the stone; a smaller core holds the actual flame.
			for profile in [Vector2(0.19,2.65),Vector2(0.15,0.62)]:
				var light := _light(Vector2.ZERO,Color("ffbd64"),profile.x,profile.y)
				light.set_meta("shadow_candidate",profile.y > 1.0)
				light.set_meta("anchor",sprite)
				light.set_meta("flame_uv",flame/Vector2(1536,1024))
				light.range_z_min = -45
				light.range_z_max = 1
				lantern_emitters.append(light)

func _rebuild_region() -> void:
	for light in lantern_emitters:
		remove_child(light)
		light.queue_free()
	lantern_emitters.clear()
	boss_burst = 0.0

	for light in landmarks:
		remove_child(light)
		light.queue_free()
	landmarks.clear()
	for occluder in occluders:
		remove_child(occluder)
		occluder.queue_free()
	occluders.clear()
	var terrain: Array = []
	var points: Array[Vector2] = []
	var offset := Vector2.ZERO
	match region:
		"village":
			target_ambient = Color("eeeeee")
			terrain = game.village.platforms
			points.assign([Vector2(1200,490),Vector2(1010,430),Vector2(1390,430),Vector2(2460,465),Vector2(2870,520)])
			if "village" in game and is_instance_valid(game.village) and "hearth_failed" in game.village and game.village.hearth_failed:
				points[0] = Vector2(1200,540)
		"forest":
			target_ambient = Color("efefef")
			points.assign([Vector2(300,490),Vector2(2300,430),Vector2(2860,500),Vector2(3140,500)])
			terrain = game.BASE_PLATFORMS.duplicate()
			if game.bridge_open: terrain.append_array(game.BRIDGE_PLATFORMS)
		"temple","boss":
			target_ambient = Color("e4e4e4") if region == "temple" else Color("e8e8e8")
			_build_temple_lanterns()
			points.assign([Vector2(4700,440),Vector2(5300,460),Vector2(6100,490),Vector2(6700,420),Vector2(7400,450)])
			terrain = game.BASE_PLATFORMS
		_:
			var index: int = game.jungle_area
			offset = Vector2(10000+index*Jungle.SPACING,0)
			target_ambient = [Color("eeeeee"),Color("e9e9e9"),Color("f0f0f0")][index]
			points.assign([Vector2(1500,285),Vector2(2800,460),Vector2(3300,300),Vector2(4000,500)])
			terrain = game.jungle_rooms[index].terrain()
	for point in points:
		landmarks.append(_light(point+offset,Color("ffd18a"),0.22,2.1))
	for rect: Rect2 in terrain:
		var occluder := LightOccluder2D.new()
		var polygon := OccluderPolygon2D.new()
		polygon.polygon = PackedVector2Array([rect.position,rect.position+Vector2(rect.size.x,0),rect.end,rect.position+Vector2(0,rect.size.y)])
		occluder.occluder = polygon
		occluder.position = offset
		add_child(occluder)
		occluders.append(occluder)


func _set_light_visible(light: PointLight2D, active: bool) -> void:
	light.visible = active
	light.enabled = active
	if not active: light.shadow_enabled = false

func _in_view(light: PointLight2D, center: Vector2) -> bool:
	var camera := get_viewport().get_camera_2d()
	var half := get_viewport_rect().size * 0.5
	if camera: half /= camera.zoom
	# Include the actual falloff radius so a nearby offscreen flame can still
	# illuminate the screen edge. Lights beyond that cannot affect this view.
	var reach := Vector2.ONE * (128.0 * light.texture_scale + 32.0)
	return Rect2(center-half-reach,(half+reach)*2.0).has_point(light.global_position)

func _update_reference_lights(center: Vector2) -> void:
	var anchors: Array = []
	var source: Node2D
	if region.begins_with("jungle_"):
		source = game.jungle_rooms[game.jungle_area]
	elif region == "forest":
		source = game.environment
	if is_instance_valid(source) and source.has_method("get_reference_light_anchors"):
		anchors = source.get_reference_light_anchors()
	while reference_emitters.size() > anchors.size():
		var removed: PointLight2D = reference_emitters.pop_back()
		remove_child(removed)
		removed.queue_free()
	while reference_emitters.size() < anchors.size():
		reference_emitters.append(_light(Vector2.ZERO,Color("ffc75a"),0.22,1.65))
	for index in anchors.size():
		var anchor: Dictionary = anchors[index]
		var light := reference_emitters[index]
		light.global_position = anchor.get("world_position",source.to_global(anchor.get("local_position",Vector2.ZERO)))
		light.texture_scale = float(anchor.get("radius",210.0))/128.0
		light.color = anchor.get("color",Color("ffc75a"))
		# Restrained additive light protects the original yellow foliage and cyan water.
		var strength := minf(float(anchor.get("energy",0.22)),0.32)
		light.set_meta("base_energy",strength)
		light.energy = strength if reduced_effects else strength*(1.0+sin(clock*2.4+index*2.1)*0.035+sin(clock*4.1+index)*0.015)
		_set_light_visible(light,bool(anchor.get("active",true)) and source.is_visible_in_tree() and _in_view(light,center))
	# Avoid invisible-source lighting pools wherever the reference props are drawn.
	if not anchors.is_empty():
		for light in landmarks: light.set_meta("reference_replaced",true)

func _update_prop_lights(center: Vector2) -> void:
	# Each independently placed lantern / seal owns an anchor. Shared texture
	# coordinates also handle rescaling and mirrored decoration instances.
	var anchors := get_tree().get_nodes_in_group("jungle_light_anchor")
	for anchor in anchors:
		if not anchor is Sprite2D or not game.is_ancestor_of(anchor): continue
		var found := false
		for light in prop_emitters:
			if light.get_meta("anchor",null) == anchor:
				found = true
				break
		if not found:
			var light := _light(Vector2.ZERO,Color("ffca79"),float(anchor.get_meta("light_energy",0.22)),float(anchor.get_meta("light_radius",1.8)))
			light.set_meta("anchor",anchor)
			prop_emitters.append(light)
	for index in range(prop_emitters.size()-1,-1,-1):
		var light := prop_emitters[index]
		var anchor = light.get_meta("anchor",null)
		if not is_instance_valid(anchor):
			light.queue_free()
			prop_emitters.remove_at(index)
			continue
		var uv: Vector2 = anchor.get_meta("light_uv",Vector2(0.5,0.5))
		if anchor.flip_h: uv.x = 1.0-uv.x
		if anchor.flip_v: uv.y = 1.0-uv.y
		var local: Vector2 = uv * anchor.texture.get_size() + anchor.offset
		if anchor.centered: local -= anchor.texture.get_size()*0.5
		light.global_position = anchor.to_global(local)
		_set_light_visible(light,anchor.is_visible_in_tree() and _in_view(light,center))
		var base: float = light.get_meta("base_energy")
		var phase: float = float(anchor.get_instance_id()%101)
		light.energy = base if reduced_effects else base*(1.0+sin(clock*2.4+phase)*0.035+sin(clock*4.1+phase)*0.015)

func _update_shadow_budget(center: Vector2) -> void:
	var candidates: Array[PointLight2D] = []
	for collection in [landmarks,lantern_emitters,prop_emitters,reference_emitters]:
		for light in collection:
			light.shadow_enabled = false
			if light.visible and light.enabled and light.get_meta("shadow_candidate",true):
				candidates.append(light)
	# Spend shadow passes on nearby sources, rather than array/level order.
	candidates.sort_custom(func(a: PointLight2D,b: PointLight2D) -> bool:
		return a.global_position.distance_squared_to(center) < b.global_position.distance_squared_to(center))
	if reduced_effects: return
	for index in mini(MAX_SHADOW_LIGHTS,candidates.size()):
		candidates[index].shadow_enabled = true

func _exit_tree() -> void:
	for child in get_children():
		if child is PointLight2D: child.texture = null
		if child is LightOccluder2D: child.occluder = null
	landmarks.clear()
	lantern_emitters.clear()
	prop_emitters.clear()
	reference_emitters.clear()
	occluders.clear()
	radial = null
