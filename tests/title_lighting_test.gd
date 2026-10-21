extends SceneTree
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if ok: print("PASS: ", message)
	else:
		failures += 1
		push_error(message)
func run() -> void:
	var game: Node = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	for frame in 4: await process_frame
	var original_reduced: bool = game.presentation.reduced_effects
	game.presentation.reduced_effects = false
	var ui: Node = game.objective.get_parent()
	var lighting: Node = ui.get_node_or_null("TitleMenuLighting")
	check(lighting != null, "Exact title installs a dedicated menu lighting system")
	if lighting == null:
		print("TITLE_LIGHTING_TESTS: %d/%d passed" % [checks-failures, checks])
		quit(1)
		return
	check(lighting.lights.size() == 6, "Six real PointLight2D sources match reference lanterns")
	var valid_lights := true
	var isolated: bool = lighting.backdrop.light_mask == 2
	var positions := true
	var energies := true
	for index in lighting.lights.size():
		var light: PointLight2D = lighting.lights[index]
		valid_lights = valid_lights and light.texture != null
		isolated = isolated and light.range_item_cull_mask == 2 and light.range_layer_min == 1 and light.range_layer_max == 1
		var expected: Vector2 = lighting.backdrop.global_position + lighting.LANTERNS[index] * Vector2(1280,720) / Vector2(1672,941)
		positions = positions and light.global_position.distance_to(expected) < 0.1
		energies = energies and light.energy > 0.0 and light.energy <= 0.04
	check(valid_lights, "Every menu lantern uses a live radial light texture")
	check(isolated, "Menu lights affect only the reference backdrop on UI layer 1")
	check(positions, "Lantern coordinates scale from reference to the 1280 by 720 canvas")
	check(energies, "Restrained light energy preserves reference artwork and typography")
	paused = true
	var prior: float = lighting.lights[0].energy
	lighting._process(0.65)
	check(lighting.process_mode == Node.PROCESS_MODE_ALWAYS and not is_equal_approx(prior,lighting.lights[0].energy), "Lantern flicker remains active while the title pauses gameplay")
	game.presentation.reduced_effects = true
	lighting._process(0.1)
	var all_zero := true
	for light in lighting.lights: all_zero = all_zero and light.energy == 0.0
	check(all_zero, "Reduced effects restores the unchanged reference image")
	game.presentation.reduced_effects = false
	game.menu.hide()
	lighting._process(0.1)
	check(not lighting.visible, "Menu lighting hides when gameplay begins")
	all_zero = true
	for light in lighting.lights: all_zero = all_zero and light.energy == 0.0
	check(all_zero, "Hidden menu lights cannot illuminate gameplay")
	game.presentation.reduced_effects = original_reduced
	paused = false
	game.queue_free()
	await process_frame
	await process_frame
	print("TITLE_LIGHTING_TESTS: %d/%d passed" % [checks-failures, checks])
	quit(1 if failures else 0)
