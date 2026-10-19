extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-title-preview.png")
	game._begin()
	game.moved_once = true
	game.jumped_once = true
	game.player.position = Vector2(1040, 600)
	for i in 80: await physics_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-village-preview.png")
	game.interact_at("hearth")
	for i in 5: game._advance_dialogue()
	game.interact_at("cart")
	for i in 5: game._advance_dialogue()
	game._start_failure()
	game._finish_failure()
	for i in 5: game._advance_dialogue()
	game.player.position = Vector2(2400, 600)
	for i in 80: await physics_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-failure-preview.png")
	game.interact_at("beam")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-dialogue-preview.png")
	for i in 10: game._advance_dialogue()
	game.player.position = Vector2(2860, 600)
	for i in 80: await physics_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-combat-preview.png")
	game._toggle_pause()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-pause-preview.png")
	game.pause_panel.hide()
	game.settings_panel.show()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/prologue-settings-preview.png")
	quit()
