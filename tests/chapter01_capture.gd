extends SceneTree
var game: Node
func _initialize() -> void: call_deferred("run")
func dialogue() -> void:
	for i in 20:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func capture(label: String, x: float, y := 620.0) -> void:
	game.player.position = Vector2(x,y)
	game.player.velocity = Vector2.ZERO
	game.player.active = false
	game.player.visual.play("idle")
	game.player.visual.visible = true
	game.mote.position = game.player.position + Vector2(-58,-85)
	game.camera.reset_smoothing()
	for i in 10: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter01-"+label+"-preview.png")
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	game.jungle_cleared.assign([0,1,2])
	dialogue()
	await capture("forest",600)
	await capture("watchpost",2180)
	game.puzzle_time = 29
	await capture("runes",3000)
	for index in [0,1,2,1,2]: game.activate_rune(index)
	dialogue()
	await capture("crossing",3450,610)
	await capture("temple",6100)
	await capture("sentinel",6900)
	game.boss.health = 12
	game.boss.health_changed.emit(12, 24)
	game.boss._begin_windup(true)
	game.boss.queue_redraw()
	await capture("rootwave",7100)
	game.boss._set_state("rootwave",0.4)
	game.boss.attack_elapsed = 0.25
	game.boss.queue_redraw()
	await capture("root-strike",7100)
	game.boss.state = "recover"
	game.boss.take_damage(24,1)
	game.boss.set_physics_process(false)
	game.boss._set_state("rejuvenate",2.2)
	await capture("rejuvenation",7100)
	game.player.active = true
	game.boss._physics_process(2.3)
	await capture("berserk",7100)
	game.boss.take_damage(24,1)
	await process_frame
	dialogue()
	await capture("reward-chest",7660)
	game.rewards.open_chest()
	game.rewards.opening = 0.7
	await capture("reward-open",7660)
	game.interact_at("fragment")
	await capture("memory",7900)
	dialogue()
	game.interact_at("exit")
	dialogue()
	for i in 30: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter01-complete-preview.png")
	paused = false
	game.queue_free()
	for i in 4: await process_frame
	quit()
