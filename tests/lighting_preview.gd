extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	game._begin()
	game.jungle_cleared.assign([0,1,2])
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game.checkpoint_active=true
	game.player.active=false
	game.player.visual.show()
	game.player.visual.play("idle")
	game.hint.hide()
	game.player.position=Vector2(5900,620)
	game.camera.position=Vector2(300,-260)
	game.camera.reset_smoothing()
	for i in 40: await process_frame
	DirAccess.make_dir_recursive_absolute("/tmp/lanterns-lighting-preview")
	for i in 32:
		game.player.position=Vector2(5900+i*15,620)
		game.camera.position=Vector2(6200-game.player.position.x,-260)
		game.camera.reset_smoothing()
		game.mote.position=game.player.position+Vector2(-58,-85)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("/tmp/lanterns-lighting-preview/%03d.png" % i)
	game.queue_free()
	for i in 4: await process_frame
	quit()
