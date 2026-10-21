extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	game._begin()
	game.player.position=Vector2(2400,620)
	game.camera.reset_smoothing()
	game.mote.position=game.player.position+Vector2(58,-85)
	game.village.hearth_failed=true
	game.beat=game.Beat.RESCUE
	game._update_hud()
	game._show_dialogue("rescue")
	for i in 25: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/botanical-dialogue-preview.png")
	game.queue_free()
	for i in 4: await process_frame
	quit()
