extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	root.size = Vector2i(1280, 720)
	var scene: Node2D = load("res://scenes/vfx/chapter_03/c3_effects_review.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.get_node("Waterfall").set_reduced_effects(true)
	scene.get_node("Caustics").set_reduced_effects(true)
	scene.get_node("Bubbles").set_reduced_effects(true)
	scene.get_node("ShrineLight").set_reduced_effects(true)
	scene.get_node("ShrineLight/Sparks").visible = false
	scene.get_node("ShrineLight/ActivationBurst").visible = false
	scene.get_node("Waterfall/Mist").visible = false
	for enabled: bool in [true, false]:
		scene.get_node("ShrineLight/PointLight2D").visible = enabled
		for i: int in 4:
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/chapter03/lighting-vfx-preparation-%s.png" % ("on" if enabled else "off"))
	scene.queue_free()
	await process_frame
	quit()
