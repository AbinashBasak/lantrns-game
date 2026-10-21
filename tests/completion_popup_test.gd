extends SceneTree
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	var popup = game.victory_panel.get_child(1)
	check(not popup.backdrop.visible,"Completion backdrop stays hidden during title")
	game.menu.hide()
	game._complete_chapter()
	await create_timer(0.4,true).timeout
	check(paused and popup.is_visible_in_tree() and popup.modulate.a > 0.99 and popup.scale.is_equal_approx(Vector2.ONE),"Popup entrance completes while gameplay is paused")
	check(popup.backdrop.visible and popup.backdrop.get_global_rect().encloses(Rect2(Vector2.ZERO,root.get_visible_rect().size)),"Backdrop dims the full game viewport")
	check(popup.backdrop.mouse_filter == Control.MOUSE_FILTER_STOP and popup.backdrop.get_index() < game.victory_panel.get_index(),"Backdrop blocks game input behind the active popup")
	var live_labels := 0
	var safe_labels := true
	for child in popup.get_children():
		if child is Label:
			live_labels += 1
			safe_labels = safe_labels and Rect2(Vector2(100,130),Vector2(740,310)).encloses(child.get_rect()) and child.get_minimum_size().y <= child.size.y
	check(live_labels == 3 and safe_labels,"Three live text blocks fit safely inside the artwork")
	check(popup.replay.is_visible_in_tree() and popup.replay.size.x >= 400 and popup.replay.size.y >= 60 and popup.replay.has_focus(),"Replay has a large visible keyboard-focusable hit target")
	var center: Vector2 = popup.replay.get_global_rect().get_center()
	check(popup.get_global_rect().has_point(center) and not popup.backdrop.get_global_rect().size.is_zero_approx(),"Replay hit target lies within the frontmost modal")
	var old_id: int = game.get_instance_id()
	var motion := InputEventMouseMotion.new()
	motion.position = center
	root.push_input(motion,true)
	await process_frame
	for pressed in [true,false]:
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.position = center
		click.pressed = pressed
		root.push_input(click,true)
		await process_frame
	for i in 5: await process_frame
	check(current_scene.get_instance_id() != old_id and paused and current_scene.menu.visible and not current_scene.completed,"Actual mouse Replay click reloads a usable chapter title")
	paused = false
	current_scene.queue_free()
	for i in 4: await process_frame
	print("COMPLETION POPUP: ",checks," checks; ",failures," failures")
	quit(0 if failures == 0 else 1)
