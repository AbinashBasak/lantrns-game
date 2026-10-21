extends SceneTree
## Graphical capture: run with a real renderer. Both frames use exactly the same
## frozen scene; only PointLight2D.enabled changes, with CanvasModulate retained.
var game: Node2D
func _initialize() -> void: call_deferred("run")
func _freeze(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	for child in node.get_children(): _freeze(child)
func _point_lights(node: Node, result: Array[PointLight2D]) -> void:
	if node is PointLight2D: result.append(node)
	for child in node.get_children(): _point_lights(child,result)
func run() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("This capture requires a graphical renderer; use the headless reference_lighting_test.gd for logic checks.")
		quit(1)
		return
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game._enter_jungle(0)
	for enemy in game.jungle_enemies: enemy.active = false
	game.player.position = Vector2(10350,620)
	game.player.active = false
	game.player.visual.show()
	game.player.visual.play("idle")
	game.mote.position = game.player.position+Vector2(-58,-85)
	game.camera.reset_smoothing()
	for i in 35: await process_frame
	var lighting = game.get_node("WorldLighting")
	lighting._process(0.0)
	var sources: Array[PointLight2D] = []
	_point_lights(lighting,sources)
	var enabled_count := 0
	for light in sources:
		if light.enabled and light.is_visible_in_tree(): enabled_count+=1
	_freeze(game)
	await process_frame
	await RenderingServer.frame_post_draw
	var light_on := root.get_texture().get_image()
	light_on.save_png("res://docs/reference-lighting-on.png")
	for light in sources: light.enabled = false
	await process_frame
	await RenderingServer.frame_post_draw
	var light_off := root.get_texture().get_image()
	light_off.save_png("res://docs/reference-lighting-off.png")
	var changed := 0
	var changed_world := 0
	var changed_top_left := 0
	var maximum_delta := 0.0
	var difference := Image.create(light_on.get_width(),light_on.get_height(),false,Image.FORMAT_RGBA8)
	for y in light_on.get_height():
		for x in light_on.get_width():
			var a := light_on.get_pixel(x,y)
			var b := light_off.get_pixel(x,y)
			var distance := maxf(absf(a.r-b.r),maxf(absf(a.g-b.g),absf(a.b-b.b)))
			maximum_delta = maxf(maximum_delta,distance)
			if distance>1.0/255.0:
				changed+=1
				if y>=220: changed_world+=1
				if x<480 and y<180: changed_top_left+=1
			difference.set_pixel(x,y,Color(absf(a.r-b.r)*4.0,absf(a.g-b.g)*4.0,absf(a.b-b.b)*4.0,1.0))
	difference.save_png("res://docs/reference-lighting-difference.png")
	var report := {
		"method":"Identical frozen frame with all world PointLight2D enabled versus disabled; ambient retained. Difference image multiplied by four for inspection.",
		"on":"reference-lighting-on.png","off":"reference-lighting-off.png","difference":"reference-lighting-difference.png",
		"enabled_visible_world_lights":enabled_count,"changed_pixels":changed,"changed_world_pixels_below_220":changed_world,
		"changed_pixels_top_left_480x180":changed_top_left,"maximum_channel_delta":maximum_delta,
		"hud_separate_canvas":game.objective.get_canvas()!=lighting.ambient.get_canvas(),
		"ambient_color_on_and_off":lighting.ambient.color.to_html(),"player_position":[10350,620],
		"viewport":[light_on.get_width(),light_on.get_height()]
	}
	var file := FileAccess.open("res://docs/reference-lighting-render-proof.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t")+"\n")
	file.close()
	print("REFERENCE LIGHT RENDER: ",JSON.stringify(report))
	game.queue_free()
	for i in 6: await process_frame
	quit(0 if changed_world>100 and report.hud_separate_canvas else 1)
