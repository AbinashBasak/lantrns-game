extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	root.size = Vector2i(1280, 720)
	var scene: Node2D = load("res://scenes/vfx/chapter_03/c3_depth_lighting_review.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	var animation: AnimationPlayer = scene.get_node("AnimationPlayer")
	animation.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	animation.play(&"sweep")
	animation.advance(0.0)
	var originals: Dictionary = {}
	for name: String in ["Arch", "Wall"]:
		var sprite: Sprite2D = scene.get_node(name + "/Artwork")
		assert(sprite.texture is CanvasTexture)
		assert(sprite.texture.normal_texture != null)
		assert(sprite.texture.specular_texture != null)
		assert(sprite.texture.diffuse_texture.get_size() == sprite.texture.normal_texture.get_size())
		assert(sprite.texture.diffuse_texture.get_size() == sprite.texture.specular_texture.get_size())
		originals[name] = sprite.texture
	for state: String in ["normal-left", "flat-left", "bitmap-flat", "off", "normal-right"]:
		for name: String in ["Arch", "Wall"]:
			var sprite: Sprite2D = scene.get_node(name + "/Artwork")
			sprite.texture = originals[name]
			if state == "flat-left" or state == "bitmap-flat":
				var flat: CanvasTexture = sprite.texture.duplicate()
				if state == "flat-left":
					flat.normal_texture = null
				else:
					flat.specular_texture = null
				sprite.texture = flat
		for light: Node in scene.get_node("LightSweep").get_children():
			light.enabled = state != "off"
		if state == "normal-right":
			animation.seek(2.0, true)
		for i: int in 5:
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/chapter03/lighting-vfx-preparation-depth-%s.png" % state)
	print("PASS CanvasTexture diffuse/normal/bitmap assignments, equal dimensions, native AnimationPlayer light sweep; five graphical comparisons captured")
	scene.queue_free()
	await process_frame
	quit()
