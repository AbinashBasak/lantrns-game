extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.size = Vector2i(1280, 720)
	var review = load("res://scenes/chapter_03/review/c3_shrine_light_review.tscn").instantiate()
	root.add_child(review)
	await process_frame
	var effect = review.get_node("ShrineLight")
	var animation: AnimationPlayer = effect.get_node("AnimationPlayer")
	animation.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	effect.set_idle()
	animation.advance(0.5)
	effect.get_node("Sparks").emitting = false
	effect.get_node("Sparks").visible = false
	effect.get_node("ActivationBurst").visible = false
	for state in [true, false]:
		effect.get_node("PointLight2D").visible = state
		for i in range(4):
			await process_frame
		await RenderingServer.frame_post_draw
		var suffix := "on" if state else "off"
		root.get_texture().get_image().save_png("res://docs/chapter03/native-shrine-light-%s.png" % suffix)
	review.queue_free()
	await process_frame
	quit()
