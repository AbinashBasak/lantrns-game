extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280, 800)
	var scene = load("res://scenes/chapter_03/review/c3_native_systems_review.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await create_timer(0.7).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter03/native-systems-review.png")
	quit()
