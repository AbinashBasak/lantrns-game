extends SceneTree
var game: Node
func _initialize() -> void: call_deferred("run")
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	for i in 5: await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	for index in 3:
		game._enter_jungle(index)
		for enemy in game.jungle_enemies:
			enemy.set_physics_process(false)
		game.player.position = Vector2(10000+index*5600+420,620)
		game.player.set_physics_process(false)
		game.player.visual.show()
		game.player.visual.play("idle")
		game.mote.position = game.player.position+Vector2(-58,-85)
		game.camera.reset_smoothing()
		for i in 20: await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/reference-jungle-%d-preview.png" % index)
	game.jungle_rooms[game.jungle_area].puzzle_cleared = true
	game._leave_jungle()
	game.player.position = Vector2(280,620)
	game.camera.reset_smoothing()
	for i in 20: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/reference-forest-preview.png")
	game.queue_free()
	for i in 4: await process_frame
	quit()
