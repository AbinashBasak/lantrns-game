extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	for i in 20:
		if game.dialogue_lines.is_empty(): break
		game._advance_dialogue()
	game.player.position = Vector2(600, 620)
	game.player.velocity = Vector2.ZERO
	game.player.active = false
	game.player.visual.show()
	game.mote.position = Vector2(542,535)
	game.camera.reset_smoothing()
	for i in 10: await process_frame
	var tree: AnimationTree = game.player.animation_tree
	tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	game.player.animation_playback.start(&"attack_1", true)
	tree.advance(0.0)
	tree.advance(0.18)
	game.player.sword_hit.restart()
	game.player.landing_dust.restart()
	for i in 3: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter03/runtime-player-native-attack.png")
	game.player.sword_light.enabled = false
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter03/runtime-player-native-light-off.png")
	print("PASS: actual Chapter 1 player capture, native attack state at 0.18 s, strike light on/off")
	paused = false
	current_scene = null
	game.queue_free()
	for i in 3: await process_frame
	quit()
