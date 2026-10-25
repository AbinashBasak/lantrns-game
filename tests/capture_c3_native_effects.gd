extends SceneTree
## Real renderer proof. Only native light enable changes between frozen captures.
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Requires graphical renderer")
		quit(1)
		return
	root.size = Vector2i(1280, 800)
	var scene = load("res://scenes/chapter_03/review/c3_chest_animation_review.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	for i in 4: await process_frame
	scene.get_node("AnimationTree").active = false
	scene.get_node("AnimationPlayer").play("Opening")
	scene.get_node("AnimationPlayer").seek(0.45, true)
	scene.get_node("AnimationPlayer").pause()
	scene.get_node("Chest/OpeningGoldParticles").emitting = true
	await create_timer(0.35).timeout
	scene.process_mode = Node.PROCESS_MODE_DISABLED
	var light = scene.get_node("Chest/MouthLight")
	light.energy = 0.4
	await process_frame
	await RenderingServer.frame_post_draw
	var on = root.get_texture().get_image()
	on.save_png("res://docs/chapter03/native-chest-light-on.png")
	light.enabled = false
	await process_frame
	await RenderingServer.frame_post_draw
	var off = root.get_texture().get_image()
	off.save_png("res://docs/chapter03/native-chest-light-off.png")
	var changed := 0
	var ui_changed := 0
	for y in on.get_height():
		for x in on.get_width():
			if on.get_pixel(x,y) != off.get_pixel(x,y):
				changed += 1
				if y < 110: ui_changed += 1
	scene.get_node("Chest/OpeningGoldParticles").visible = false
	await process_frame
	await RenderingServer.frame_post_draw
	var no_particles = root.get_texture().get_image()
	var particle_changed := 0
	for y in off.get_height():
		for x in off.get_width():
			if off.get_pixel(x,y) != no_particles.get_pixel(x,y): particle_changed += 1
	var report = {"particle_changed_pixels": particle_changed, "changed_pixels": changed, "ui_changed_pixels": ui_changed, "method": "Identical frozen viewport, only MouthLight.enabled toggled", "particles": scene.get_node("Chest/OpeningGoldParticles").amount, "ambient": scene.get_node("CanvasModulate").color.to_html()}
	FileAccess.open("res://docs/chapter03/native-effects-render-proof.json", FileAccess.WRITE).store_string(JSON.stringify(report,"\t"))
	print(JSON.stringify(report))
	quit(0 if changed > 100 and ui_changed == 0 and particle_changed > 10 else 1)
