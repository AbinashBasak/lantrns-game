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
	game.player.position=Vector2(7100,620)
	game.camera.reset_smoothing()
	game._start_boss()
	game.player.active=false
	game.player.visual.visible=true
	game.player.visual.play("idle")
	game.mote.position=game.player.position+Vector2(-58,-85)
	game.boss._begin_windup(true)
	game.boss._set_state("rootwave",0.4)
	game.boss.attack_elapsed=0.25
	game.boss.sprite.pause()
	game.boss.sprite.set_frame_and_progress(3,0)
	game.boss.queue_redraw()
	game._on_boss_phase("rejuvenating")
	game._on_boss_health(17,24)
	game.rewards.points=300
	for i in 35: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter01-encounter-style-preview.png")
	game.queue_free()
	for i in 4: await process_frame
	quit()
