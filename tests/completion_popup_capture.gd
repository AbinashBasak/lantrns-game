extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	game.jungle_cleared.assign([0,1,2])
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game.player.position = Vector2(7660,620)
	game.player.active = false
	game.camera.reset_smoothing()
	game.rewards.points=1800
	game.boss_defeated=true
	game.environment.boss_defeated=true
	game.rewards.chest_available=true
	game.rewards.chest_opened=true
	game.fragment_collected=true
	game.boss.state="defeated"
	game.boss.sprite.play("defeat")
	game.boss.sprite.set_frame_and_progress(5,0)
	game.boss.sprite.pause()
	for i in 10: await process_frame
	game._complete_chapter()
	for i in 45: await process_frame
	print("CAPTURESTATE ",game.started," ",game.victory_panel.visible," ",game.victory_panel.size," ",game.menu.visible)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter01-popup-runtime-preview.png")
	paused=false
	game.queue_free()
	for i in 4: await process_frame
	quit()
