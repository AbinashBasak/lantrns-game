extends Node2D
## World-only realtime light. CanvasLayer menus and HUD keep their authored colours.
const Jungle = preload("res://scripts/systems/chapter01_jungle.gd")
const MAX_SHADOW_LIGHTS := 2
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
var boss_burst := 0.0
# Measured flame centres in the unchanged 1536 × 1024 ENV-03 source.
const TEMPLE_FLAMES := [Vector2(300,300),Vector2(374,418),Vector2(800,580),Vector2(1196,418),Vector2(1308,296),Vector2(1460,410)]
var occluders: Array[LightOccluder2D] = []
var region := ""
var clock := 0.0
var reduced_effects := false
var flash := 0.0
var radial: GradientTexture2D
var target_ambient := Color("d5ddd2")
var previous_boss_state := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("world_lighting")
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0,0.10,0.35,0.68,1.0])
	gradient.colors = PackedColorArray([Color(1,1,1,1),Color(1,1,1,0.88),Color(1,1,1,0.31),Color(1,1,1,0.065),Color(1,1,1,0)])
	radial = GradientTexture2D.new()
	radial.gradient = gradient
	radial.width = 256
	radial.height = 256
	radial.fill = GradientTexture2D.FILL_RADIAL
	radial.fill_from = Vector2(0.5,0.5)
	radial.fill_to = Vector2(1,0.5)
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
		target_ambient = Color("b8c8cd") if game.village.hearth_failed else Color("d8d9c4")
	var tint := Color("edf0e7") if reduced_effects else target_ambient
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
	_update_temple_lanterns(center)
	_update_reward_lights(delta,center)
	var shadow_count := 0
	for light in landmarks:
		light.visible = absf(light.global_position.x-center.x) < 1000
		var base: float = light.get_meta("base_energy")
		light.energy = base if reduced_effects else base*(1.0+sin(clock*2.5+light.position.x)*0.035)
		if region == "village" and light == landmarks[0] and game.village.hearth_failed: light.energy = 0.04
		light.shadow_enabled = light.visible and shadow_count < MAX_SHADOW_LIGHTS
		if light.shadow_enabled: shadow_count += 1
		if region == "boss":
			light.color = Color("ff9157") if game.boss.berserk else Color("ffc98b")
			light.energy += 0.0 if reduced_effects else boss_burst*0.12

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
		light.visible = light.energy > 0.005 and absf(light.global_position.x-center.x) < 1000 and absf(light.global_position.y-center.y) < 650

func _update_temple_lanterns(center: Vector2) -> void:
	# The lights follow the authored lanterns, including native parallax and mirrored tiles.
	# World coordinates alone would leave halos drifting away from their flames.
	for light in lantern_emitters:
		var anchor: Sprite2D = light.get_meta("anchor")
		if not is_instance_valid(anchor):
			light.hide()
			continue
		var uv: Vector2 = light.get_meta("flame_uv")
		if anchor.flip_h: uv.x = 1.0-uv.x
		light.global_position = anchor.to_global(uv*anchor.texture.get_size())
		light.visible = anchor.is_visible_in_tree() and absf(light.global_position.x-center.x) < 850 and absf(light.global_position.y-center.y) < 650
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
			target_ambient = Color("d8d9c4")
			terrain = game.village.platforms
			points.assign([Vector2(1200,490),Vector2(1010,430),Vector2(1390,430),Vector2(2460,465),Vector2(2870,520)])
			if "village" in game and is_instance_valid(game.village) and "hearth_failed" in game.village and game.village.hearth_failed:
				points[0] = Vector2(1200,540)
		"forest":
			target_ambient = Color("d1dfd4")
			points.assign([Vector2(300,490),Vector2(2300,430),Vector2(2860,500),Vector2(3140,500)])
			terrain = game.BASE_PLATFORMS.duplicate()
			if game.bridge_open: terrain.append_array(game.BRIDGE_PLATFORMS)
		"temple","boss":
			target_ambient = Color("cbd1c0") if region == "temple" else Color("d2ceba")
			_build_temple_lanterns()
			points.assign([Vector2(4700,440),Vector2(5300,460),Vector2(6100,490),Vector2(6700,420),Vector2(7400,450)])
			terrain = game.BASE_PLATFORMS
		_:
			var index: int = game.jungle_area
			offset = Vector2(10000+index*Jungle.SPACING,0)
			target_ambient = [Color("d1e1d4"),Color("c2d8da"),Color("d8ddc8")][index]
			points.assign([Vector2(1500,285),Vector2(2800,460),Vector2(3300,300),Vector2(4000,500)])
			terrain = game.jungle_rooms[index].terrain()
	for point in points:
		landmarks.append(_light(point+offset,Color("ffd18a"),0.32,2.1))
	for rect: Rect2 in terrain:
		var occluder := LightOccluder2D.new()
		var polygon := OccluderPolygon2D.new()
		polygon.polygon = PackedVector2Array([rect.position,rect.position+Vector2(rect.size.x,0),rect.end,rect.position+Vector2(0,rect.size.y)])
		occluder.occluder = polygon
		occluder.position = offset
		add_child(occluder)
		occluders.append(occluder)

func _exit_tree() -> void:
	for child in get_children():
		if child is PointLight2D: child.texture = null
		if child is LightOccluder2D: child.occluder = null
	landmarks.clear()
	lantern_emitters.clear()
	occluders.clear()
	radial = null
