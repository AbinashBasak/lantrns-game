extends SceneTree
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, message: String) -> void:
	checks += 1
	if value: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	var system = game.get_node_or_null("WorldLighting")
	if system == null:
		system = load("res://scripts/presentation/world_lighting.gd").new()
		system.game = game
		game.add_child(system)
	paused = false
	game.player.active = false
	check(system.ambient is CanvasModulate,"World lighting uses real canvas modulation")
	check(system.player_light is PointLight2D and system.player_light.texture is GradientTexture2D,"Player light uses a real runtime radial PointLight2D")
	game.player.position = Vector2(1000,600)
	game.mote.position = Vector2(940,510)
	system._process(0.1)
	check(system.player_light.global_position.is_equal_approx(game.player.global_position+Vector2(0,-52)),"Player light follows the actor")
	check(system.mote_light.global_position.is_equal_approx(game.mote.global_position),"Companion light follows Mote")
	check(system.actor_shadow.global_position.is_equal_approx(game.player.global_position) and system.actor_shadow.occluder_light_mask == 2,"Actor casts a moving shadow from nearby landmark lights")
	var forest: Color = system.target_ambient
	game.player.position.x = 5000
	system._process(0.1)
	check(system.region == "temple" and system.target_ambient != forest,"Temple changes the ambient lighting palette")
	check(not system.occluders.is_empty() and system.occluders[0] is LightOccluder2D,"Terrain casts real runtime shadows")
	check(not system.lantern_emitters.is_empty(),"Temple flames have real soft-core and broad-falloff light pairs")
	var lamp: PointLight2D = system.lantern_emitters[0]
	var anchor: Sprite2D = lamp.get_meta("anchor")
	var uv: Vector2 = lamp.get_meta("flame_uv")
	if anchor.flip_h: uv.x = 1.0-uv.x
	check(lamp.global_position.is_equal_approx(anchor.to_global(uv*anchor.texture.get_size())),"Temple light centres match the authored lanterns including mirrored tiles")
	var anchor_position := anchor.position
	anchor.position += Vector2(80,10)
	system._process(0.1)
	check(lamp.global_position.is_equal_approx(anchor.to_global(uv*anchor.texture.get_size())),"Temple light follows parallax motion instead of drifting from its source")
	anchor.position = anchor_position
	var lit_lanterns := 0
	for emitter in system.lantern_emitters:
		if emitter.visible: lit_lanterns += 1
	check(lit_lanterns < 24,"Offscreen temple lights are culled to bound render cost")
	game.boss_active = true
	game.boss.state = "rejuvenate"
	system._process(0.1)
	check(system.region == "boss" and system.boss_burst > 0.5,"Boss revival triggers a restrained realtime warm light pulse")
	game.boss_active = false
	game.boss.state = "dormant"

	var shadow_count := 0
	for light in system.landmarks:
		if light.shadow_enabled: shadow_count += 1
	check(shadow_count <= system.MAX_SHADOW_LIGHTS,"Shadow lights are bounded for rendering performance")
	for index in 3:
		game.jungle_area = index
		system._process(0.1)
		check(system.region == "jungle_%d" % index and not system.landmarks.is_empty(),"Jungle %d has its own active realtime light setup" % (index+1))
	game.presentation.reduced_effects = true
	system._process(1.0)
	check(is_equal_approx(system.mote_light.energy,0.28) and system.ambient.color.r > 0.9,"Reduced effects removes light pulsation and increases visibility")
	var time: float = system.clock
	paused = true
	await process_frame
	await process_frame
	check(is_equal_approx(system.clock,time),"Realtime light animation pauses with gameplay")
	paused = false
	game.queue_free()
	game = null
	system = null
	for i in 4: await process_frame
	game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	paused = false
	system = game.get_node("WorldLighting")
	system._process(0.1)
	check(system.region == "village" and system.landmarks.size() > 0,"Village has real Hearthlight and lantern emitters")
	var before: float = system.landmarks[0].energy
	game.village.hearth_failed = true
	system._process(0.1)
	check(system.landmarks[0].energy < before and system.target_ambient.r < 0.8,"Hearthlight failure dims its real light and village ambient")
	check(game.objective.get_canvas() != system.ambient.get_canvas(),"World modulation is isolated from the HUD canvas")
	game.queue_free()
	for i in 6: await process_frame
	print("LIGHTING: ",checks-failures,"/",checks," checks passed")
	quit(1 if failures else 0)
