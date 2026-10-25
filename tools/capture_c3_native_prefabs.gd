extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	root.size = Vector2i(1280, 720)
	var scene: Node2D = load("res://scenes/vfx/chapter_03/c3_native_prefabs_review.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	var animation: AnimationPlayer = scene.get_node("AnimationPlayer")
	animation.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	animation.seek(2.0, true)
	for i: int in 5:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter03/native-prefab-completion.png")
	scene.queue_free()
	await process_frame
	quit()
