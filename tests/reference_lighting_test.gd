extends SceneTree
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	paused = false
	game.player.active = false
	game.camera.enabled = false
	game.player.position = Vector2(1000,600)
	var lights = game.get_node("WorldLighting")
	lights._process(1.0)
	var anchors: Array = game.environment.get_reference_light_anchors()
	check(not anchors.is_empty() and lights.reference_emitters.size()==anchors.size(),"Forest props provide individual realtime lantern and seal light anchors")
	var positions_match := true
	var shared := true
	var isolated := true
	var unseen_disabled := true
	for index in anchors.size():
		var light: PointLight2D = lights.reference_emitters[index]
		positions_match = positions_match and light.global_position.is_equal_approx(anchors[index].world_position)
		shared = shared and light.texture==load("res://assets/runtime/shared/lighting/soft_radial.tres")
		isolated = isolated and light.range_layer_min==0 and light.range_layer_max==0 and light.range_item_cull_mask==1 and light.shadow_item_cull_mask==3
		if not light.visible: unseen_disabled = unseen_disabled and not light.enabled and not light.shadow_enabled
	check(positions_match,"Every realtime light follows the exact flame geometry used to draw its prop")
	check(shared,"All lanterns reuse the saved soft radial resource")
	var radial: GradientTexture2D = load("res://assets/runtime/shared/lighting/soft_radial.tres")
	check(radial.fill==GradientTexture2D.FILL_RADIAL and radial.gradient.get_color(0).r==1.0 and radial.gradient.get_color(radial.gradient.get_point_count()-1).r==0.0,"Additive radial texture fades to black at its edge instead of lighting a rectangle")
	check(isolated and game.objective.get_canvas()!=lights.ambient.get_canvas(),"Light receive masks and world canvas keep HUD authored colors intact")
	check(unseen_disabled,"Offscreen reference lights are disabled, including their shadow passes")
	check(lights.target_ambient.r==lights.target_ambient.g and lights.target_ambient.g==lights.target_ambient.b and lights.target_ambient.r>0.92,"Forest ambient preserves reference hue and vibrancy")
	var first: PointLight2D = lights.reference_emitters[0]
	var before := first.energy
	lights._process(0.71)
	check(not is_equal_approx(before,first.energy) and first.energy<0.35,"Lantern illumination flickers over time without bleaching source colors")
	var previous: Vector2 = lights.player_light.global_position
	game.player.position += Vector2(190,0)
	game.mote.position += Vector2(150,20)
	lights._process(0.1)
	check(lights.player_light.global_position.is_equal_approx(previous+Vector2(190,0)) and lights.mote_light.global_position.is_equal_approx(game.mote.global_position),"Moving player and companion illumination follows gameplay positions")
	var shadow_count := 0
	var furthest := 0.0
	var nearest_unselected := INF
	for light in lights.reference_emitters:
		if not light.visible: continue
		var distance: float = light.global_position.distance_squared_to(game.player.global_position)
		if light.shadow_enabled:
			shadow_count += 1
			furthest = maxf(furthest,distance)
		else: nearest_unselected = minf(nearest_unselected,distance)
	check(shadow_count<=2 and furthest<=nearest_unselected,"Only the nearest visible sources receive the two available shadow passes")
	game.presentation.reduced_effects = true
	lights._process(1.0)
	before = first.energy
	lights._process(0.71)
	var shadows_off := true
	for light in lights.reference_emitters: shadows_off = shadows_off and not light.shadow_enabled
	check(is_equal_approx(before,first.energy) and shadows_off,"Reduced effects removes flicker and dynamic shadow passes")
	game.jungle_area = 0
	var room: Node2D = game.jungle_rooms[0]
	room.active = true
	room.show()
	game.player.global_position = room.global_position+Vector2(1000,600)
	lights._process(0.1)
	anchors = room.get_reference_light_anchors()
	positions_match = lights.reference_emitters.size()==anchors.size() and not anchors.is_empty()
	for index in anchors.size():
		positions_match = positions_match and lights.reference_emitters[index].global_position.is_equal_approx(anchors[index].world_position)
	check(positions_match,"Jungle rooms use their own world-offset prop and puzzle anchors")
	game.queue_free()
	for i in 6: await process_frame
	print("REFERENCE LIGHTING: ",checks-failures,"/",checks," checks passed")
	quit(1 if failures else 0)
