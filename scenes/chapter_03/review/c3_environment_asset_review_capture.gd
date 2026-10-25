extends SceneTree
## Run using Godot --path . --script res://scenes/chapter_03/review/c3_environment_asset_review_capture.gd
func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.size = Vector2i(1280, 720)
	for page: int in range(1, 9):
		var packed: PackedScene = load("res://scenes/chapter_03/review/c3_environment_asset_review_%02d.tscn" % page)
		if packed == null:
			quit(1)
			return
		var scene: Node2D = packed.instantiate()
		root.add_child(scene)
		for frame: int in 4:
			await process_frame
		await RenderingServer.frame_post_draw
		var result: Error = root.get_texture().get_image().save_png("res://docs/chapter03/environment-asset-preparation-native-%02d.png" % page)
		if result != OK:
			quit(1)
			return
		scene.queue_free()
		await process_frame
	print("C3 environment: eight native galleries rendered")
	quit()
