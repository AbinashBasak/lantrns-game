extends SceneTree
## Feedback lifecycle regression and optional in-context graphical captures.
var failures := 0
var game: Node
func _initialize() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	print(("PASS: " if ok else "FAIL: ")+label)
	if not ok: failures += 1
func run() -> void:
	for chapter in ["chapter01_forgotten_trail", "chapter02_briarwake"]:
		game = load("res://scenes/levels/"+chapter+".tscn").instantiate()
		root.add_child(game)
		current_scene = game
		await process_frame
		game._begin()
		while not game.dialogue_lines.is_empty(): game._advance_dialogue()
		game.set_process(false)
		game.player.set_physics_process(false)
		game.player.active = true
		game.presentation.reduced_effects = false
		game.combat_feedback.pulse("test",0.65)
		game.combat_feedback._process(0.016)
		check(game.camera.offset.length()>0 and game.camera.offset.length()<9,"%s impact stays bounded" % chapter)
		game.combat_feedback._process(1.0)
		check(game.camera.offset==Vector2.ZERO,"%s impact settles" % chapter)
		game.combat_feedback.pulse("test",0.65)
		game.player.active = false
		game.combat_feedback._process(0.016)
		check(game.camera.offset==Vector2.ZERO,"%s dialogue clears camera" % chapter)
		game.player.active = true
		game.presentation.reduced_effects = true
		game.combat_feedback.pulse("test",0.65)
		check(game.combat_feedback.trauma==0,"%s reduced effects suppress shake" % chapter)
		game.presentation.reduced_effects = false
		game.player.active = false
		game.player.position = Vector2(2160,620) if chapter.begins_with("chapter01") else Vector2(1500,620)
		game.player.invincible = 0
		game.player.visual.play("idle")
		game.player.visual.show()
		game.mote.position = game.player.position+Vector2(-58,-85)
		game.camera.reset_smoothing()
		game._update_hud()
		if DisplayServer.get_name()!="headless":
			for i in 20: await process_frame
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://docs/"+chapter+"-polish.png")
		paused = false
		game.queue_free()
		for i in 4: await process_frame
	print("CHAPTER POLISH: %d failures" % failures)
	quit(1 if failures else 0)
