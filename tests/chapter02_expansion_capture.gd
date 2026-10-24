extends SceneTree
## Graphical evidence from the actual chapter. Run with a real renderer.
const OUTPUT := "res://docs/chapter02-expansion"
var game: Node2D
var saved: Array[String] = []
func _initialize() -> void: call_deferred("run")
func dialogue() -> void:
	for i in 60:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func _freeze(node: Node, modes: Dictionary) -> void:
	modes[node] = node.process_mode
	node.process_mode = Node.PROCESS_MODE_DISABLED
	for child in node.get_children(): _freeze(child,modes)
func _restore(modes: Dictionary) -> void:
	for node in modes:
		if is_instance_valid(node): node.process_mode = modes[node]
func _lights(node: Node, result: Array[PointLight2D]) -> void:
	if node is PointLight2D: result.append(node)
	for child in node.get_children(): _lights(child,result)
func capture(label: String, point: Vector2) -> void:
	game.player.position = point
	game.player.velocity = Vector2.ZERO
	game.player.active = false
	game.player.visual.show()
	game.player.visual.play("idle")
	game.mote.position = point+Vector2(-58,-85)
	game.camera.reset_smoothing()
	game._update_hud()
	for i in 12: await process_frame
	var modes: Dictionary = {}
	_freeze(game,modes)
	await process_frame
	await RenderingServer.frame_post_draw
	var path := OUTPUT+"/"+label+".png"
	root.get_texture().get_image().save_png(path)
	saved.append(path)
	_restore(modes)
func light_pair(point: Vector2) -> void:
	game.player.position = point
	game.player.velocity = Vector2.ZERO
	game.player.active = false
	game.mote.position = point+Vector2(-58,-85)
	game.camera.reset_smoothing()
	for i in 20: await process_frame
	game.lighting._process(0.0)
	var sources: Array[PointLight2D] = []
	_lights(game.lighting,sources)
	var modes: Dictionary = {}
	_freeze(game,modes)
	await process_frame
	await RenderingServer.frame_post_draw
	var on := root.get_texture().get_image()
	on.save_png(OUTPUT+"/lighting-on.png")
	for light in sources: light.enabled = false
	await process_frame
	await RenderingServer.frame_post_draw
	var off := root.get_texture().get_image()
	off.save_png(OUTPUT+"/lighting-off.png")
	var changed_world := 0
	var changed_top_left_including_world := 0
	var difference := Image.create(on.get_width(),on.get_height(),false,Image.FORMAT_RGBA8)
	for y in on.get_height():
		for x in on.get_width():
			var a := on.get_pixel(x,y)
			var b := off.get_pixel(x,y)
			var delta := maxf(absf(a.r-b.r),maxf(absf(a.g-b.g),absf(a.b-b.b)))
			if delta>1.0/255.0:
				if y>=220: changed_world+=1
				if x<400 and y<180: changed_top_left_including_world+=1
			difference.set_pixel(x,y,Color(absf(a.r-b.r)*4,absf(a.g-b.g)*4,absf(a.b-b.b)*4,1))
	difference.save_png(OUTPUT+"/lighting-difference.png")
	var proof := {"method":"Identical frozen frame, PointLight2D enabled versus disabled; ambient and UI nodes frozen. Region differences include background visible between HUD panels; they do not isolate opaque UI pixels.", "changed_world_pixels_below_220":changed_world,"changed_top_left_including_world_pixels_400x180":changed_top_left_including_world,"source_count":sources.size(),"viewport":[on.get_width(),on.get_height()]}
	var file := FileAccess.open(OUTPUT+"/lighting-proof.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(proof,"\t")+"\n")
	file.close()
	for light in sources: light.enabled = true
	_restore(modes)
	print("LIGHTING PROOF: ",JSON.stringify(proof))
func run() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("Expansion captures require a graphical renderer.")
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	if has_meta("from_chapter01"): remove_meta("from_chapter01")
	set_meta("campaign_progress",{"points":1700,"attack_damage":2})
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	await capture("01-title",Vector2(160,620))
	game._begin()
	dialogue()
	await capture("02-orchard",Vector2(470,620))
	for index in 4:
		game._enter_jungle(index)
		dialogue()
		for enemy in game.jungle_rooms[index].enemies:
			if is_instance_valid(enemy): enemy.active = false
		await capture("03-jungle-%d" % (index+1),game.jungle_rooms[index].to_global(Vector2(1300,620)))
		if index==1: await light_pair(game.jungle_rooms[index].to_global(Vector2(3260,620)))
		game.jungle_rooms[index].completed = true
		game.jungle_rooms[index].gate_collision.disabled = true
		game._leave_jungle(index)
	game.bindings_freed.assign([true,true,true])
	game.carving_read = true
	game.orchard_gate.disabled = true
	game.boss_intro_seen = true
	game.player.active = true
	game._start_guardian()
	game.boss.set_physics_process(false)
	game.boss.health = game.boss.max_health/2
	game.boss.direction = -1
	for attack in ["charge","eruption","sweep","volley","claw"]:
		game.boss.eruption_x = 5740
		game.boss._enter(attack,1.0)
		if attack=="volley": game.boss._spawn_volley()
		if attack=="sweep":
			for i in game.boss.root_sprites.size(): game.boss.root_sprites[i].position.x = (-1 if i==0 else 1)*230
		await capture("04-mossjaw-"+attack,Vector2(5740,620))
		game.boss._clear_hazards()
	game.boss.binding_exposed = true
	game.boss.column_hits = 3
	game.boss._enter("recover",8)
	await capture("05-binding-recovery",Vector2(6090,620))
	game.boss.state = "defeated"
	game.boss._update_visual()
	game._guardian_freed()
	dialogue()
	await capture("06-mossjaw-chest",Vector2(6460,620))
	game.player.active = true
	game.rewards.open_chest()
	game.rewards.animation_time = 1.8
	game.rewards._process(0.0)
	await capture("07-orchard-charm",Vector2(6460,620))
	game.fragment_collected = true
	game.memory.show()
	game._show_dialogue("memory",func(): game.memory.hide())
	await capture("08-anchor-fragment",Vector2(6680,620))
	dialogue()
	game._complete_chapter()
	await capture("09-completion",Vector2(7310,620))
	var file := FileAccess.open(OUTPUT+"/capture-index.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"scene":"chapter02_briarwake","captures":saved,"note":"Real runtime scenery, generated species, live HUD and five guardian attack poses. Capture placement/progression are staged; behavior is checked separately by chapter02_expansion_test.gd."},"\t")+"\n")
	file.close()
	paused = false
	game.queue_free()
	for i in 4: await process_frame
	print("CHAPTER02 EXPANSION CAPTURES: ",saved.size()," images plus identical-frame lighting proof")
	quit()
