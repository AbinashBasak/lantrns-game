extends SceneTree
var game: Node
var frame_index := 0
const OUTPUT := "res://docs/chapter02-combat-review/"
const FRAMES := "/private/tmp/lantrns-combat-review-frames/"
func _initialize() -> void: call_deferred("run")
func dialogue() -> void:
	for i in 60:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUTPUT+name+".png")
func record() -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(FRAMES+"%04d.png" % frame_index)
	frame_index += 1
func run() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	DirAccess.make_dir_recursive_absolute(FRAMES)
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game.jungle_cleared.assign([true,true,true,true])
	for room in game.jungle_rooms: room.completed = true
	game.bindings_freed.assign([true,true,true])
	game.carving_read = true
	game.orchard_gate.disabled = true
	game.boss_intro_seen = true
	game._begin()
	dialogue()
	for enemy in get_nodes_in_group("enemies"):
		if enemy != game.boss: enemy.process_mode = Node.PROCESS_MODE_DISABLED
	game.player.position = Vector2(5670,620)
	game.player.invincible = 999
	game.player.set_physics_process(false)
	game.player.attack_damage = 1
	game._start_guardian()
	game.camera.reset_smoothing()
	game.feedback_time = 0
	game.guidance_time = 0
	var moves := ["claw","eruption","volley","leap","rush","charge","sweep"]
	for move in moves:
		game.player.position = Vector2(5670,620)
		game.player.health = 5
		game.player.vitality = 100
		game.player.invincible = 999
		game.player.active = true
		game.boss_active = true
		game.boss._clear_hazards()
		game.boss.position = Vector2(6200,620)
		game.boss.velocity = Vector2.ZERO
		game.boss.direction = -1
		game.boss.locked_target = Vector2(5840 if move=="leap" else game.player.position.x,590)
		game.boss.eruption_x = game.player.position.x
		game.boss.rush_second = false
		game.boss.phase = 2
		game.boss._enter(move+"_warning",0.9)
		var captured := false
		for i in 132:
			await physics_frame
			game.player.visual.visible = true
			if not captured and game.boss.state==move and game.boss.state_time<game.boss.state_duration*0.6:
				captured = true
				await shot("boss-"+move)
			if i%6==0: await record()
	game.set_process(false)
	game.boss._clear_hazards()
	game.boss.state = "dormant"
	game.boss.set_physics_process(false)
	game.boss.hide()
	game.boss_active = false
	game._update_hud()
	for variant in 3:
		var enemy = load("res://scripts/enemies/orchard_enemy.gd").new()
		enemy.variant = variant
		enemy.position = game.player.position + Vector2(120 if variant==0 else 240,0)
		game.add_child(enemy)
		for i in 150:
			await physics_frame
			game.player.visual.visible = true
			if enemy.state=="attack" and i%4==0: await shot("enemy-%d" % variant)
			if i%6==0: await record()
		enemy.queue_free()
		await process_frame
	game.combat_feedback.clear()
	var file := FileAccess.open(OUTPUT+"capture-notes.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"method":"Real60Hz physics and rendered attacks; seven staged starts plus three independently staged enemies. Invulnerable stationary player used for a safe visual review. No simulation of normal encounter balance is claimed.","frames":frame_index,"fps":10,"frame_directory":FRAMES},"\t"))
	file.close()
	game.queue_free()
	for i in 4: await process_frame
	print("COMBAT MOTION CAPTURE: ",frame_index," frames")
	quit()
