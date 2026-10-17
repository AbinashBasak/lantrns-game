extends Node
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var game = load("res://scenes/main/main.tscn").instantiate()
	add_child(game)
	for i in 8: await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://docs/preview-title.png")
	game._begin()
	for i in 75: await get_tree().physics_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://docs/preview-gameplay.png")
	print("PREVIEW_CAPTURE_OK")
	get_tree().paused = false
	get_tree().paused = true
