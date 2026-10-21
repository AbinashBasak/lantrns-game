extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game._enter_jungle(0)
	for enemy in game.jungle_enemies: enemy.active = false
	game.player.active = false
	game.player.visual.show()
	DirAccess.make_dir_recursive_absolute("/tmp/lanterns-jungle-motion")
	for i in 36:
		game.player.position = Vector2(11100+i*15,620)
		game.mote.position = game.player.position+Vector2(-58,-85)
		game.camera.reset_smoothing()
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("/tmp/lanterns-jungle-motion/%03d.png" % i)
	game.queue_free()
	for i in 4: await process_frame
	quit()
