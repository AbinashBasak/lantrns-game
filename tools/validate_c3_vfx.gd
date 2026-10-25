extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	for name: String in ["waterfall_stream", "water_caustics", "underwater_bubbles", "water_splash", "fragment_pickup"]:
		var effect: Node2D = load("res://scenes/vfx/chapter_03/c3_%s.tscn" % name).instantiate()
		root.add_child(effect)
		await process_frame
		effect.set_reduced_effects(true)
		if effect.has_node("Particles"):
			assert(not effect.get_node("Particles").emitting)
		else:
			assert(effect.get_node("Artwork").material.get_shader_parameter("motion") == 0.0)
		effect.queue_free()
		await process_frame
	var lamps: Array[Node2D] = []
	for i: int in 20:
		var lamp: Node2D = load("res://scenes/props/chapter_03/c3_lantern_light.tscn").instantiate()
		lamp.position = Vector2(i * 10, 120)
		root.add_child(lamp)
		lamps.append(lamp)
	var budget: Node = load("res://resources/chapter_03/lighting/light_budget.tscn").instantiate()
	root.add_child(budget)
	budget.update_budget()
	var active: int = 0
	var shadows: int = 0
	for lamp: Node2D in lamps:
		active += int(lamp.get_node("PointLight2D").visible)
		shadows += int(lamp.get_node("PointLight2D").shadow_enabled)
	assert(active <= 16 and shadows <= 2)
	budget.reduced_effects = true
	budget.update_budget()
	for lamp: Node2D in lamps:
		assert(not lamp.get_node("PointLight2D").shadow_enabled)
		assert(not lamp.get_node("AnimationPlayer").is_playing())
		lamp.position.x += 9000
	budget.update_budget()
	for lamp: Node2D in lamps:
		assert(not lamp.get_node("PointLight2D").visible)
		lamp.queue_free()
	budget.queue_free()
	await process_frame
	print("PASS Chapter3 water resources, reduced effects, 16-light/two-shadow cap, offscreen culling")
	quit()
