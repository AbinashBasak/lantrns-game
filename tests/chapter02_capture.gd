extends SceneTree
var game: Node
func _initialize() -> void: call_deferred("run")
func dialogue() -> void:
	for i in 20:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func capture(label: String, point: Vector2) -> void:
	game.player.position = point
	game.player.velocity = Vector2.ZERO
	game.player.active = false
	game.player.visual.play("idle")
	game.player.visual.visible = true
	game.mote.position = point + Vector2(-58,-85)
	game.camera.reset_smoothing()
	for i in 10: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter02-"+label+"-preview.png")
func run() -> void:
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	await capture("title",Vector2(160,620))
	game._begin()
	dialogue()
	await capture("orchard",Vector2(1300,620))
	await capture("crossing",Vector2(1800,620))
	game.bindings_freed.assign([true,true,true])
	game.carving_read = true
	game.orchard_gate.disabled = true
	game.boss_intro_seen = true
	game._start_guardian()
	game.boss._enter("charge_warning",10)
	await capture("mossjaw",Vector2(5740,620))
	game.boss.column_hits = 3
	game.boss.binding_exposed = true
	game.boss._enter("recover",10)
	await capture("bindings",Vector2(6300,620))
	game.boss.state = "defeated"
	game._guardian_freed()
	dialogue()
	await capture("fragment",Vector2(6680,620))
	game.fragment_collected = true
	game._complete_chapter()
	await capture("complete",Vector2(7310,620))
	paused = false
	game.queue_free()
	for i in 4: await process_frame
	quit()
