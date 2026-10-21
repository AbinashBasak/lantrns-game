extends SceneTree
var game: Node
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func settle() -> void:
	for i in 3: await process_frame
func action(name: String) -> void:
	Input.action_press(name)
	await process_frame
	Input.action_release(name)
	await settle()
func click(button: Button) -> void:
	var point := button.get_global_rect().get_center()
	for down in [true,false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.position = point
		event.global_position = point
		event.pressed = down
		root.push_input(event,true)
		await process_frame
	await settle()
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game.boss_defeated = true
	game.rewards.chest_opened = true
	game._collect_fragment()
	await create_timer(0.3).timeout
	var popup: Node = game.get_node_or_null("MemoryPopup")
	if popup == null:
		for child in game.get_children():
			if child.get_script() and child.get_script().resource_path.ends_with("memory_popup.gd"): popup = child
	var images: Array[TextureRect] = []
	for child in game.memory.get_children():
		if child is TextureRect and child != popup.frame: images.append(child)
	check(images.size() == 2 and images[0].texture != null and images[1].texture != null and images[0].visible and images[1].visible,"Memory popup retains both live generated orchard layers")
	check(images[0].position == images[1].position and images[0].size == images[1].size and images[0].size.x > 500,"Orchard layers share the large framed image window")
	check(popup.message.text == game.dialogue_lines[0] and "Memory opens" in popup.message.text,"First memory line is copied into the parchment text")
	check(game.memory.visible and popup.backdrop.visible and not game.dialogue_box.visible,"Memory overlay replaces the legacy dialogue box")
	check(not game.player.active,"Memory dialogue suspends player movement")
	check(popup.message.get_rect().end.y < popup.continue_button.position.y,"Memory text and Continue button have separate layout space")
	check(popup.continue_button.position.y + popup.continue_button.size.y < game.memory.size.y and popup.message.position.x > 0,"Memory controls remain inside the botanical frame")
	await click(popup.continue_button)
	check(game.dialogue_index == 1 and popup.message.text == game.dialogue_lines[1],"Actual mouse click advances exactly one memory line")
	await action("pause")
	check(paused and game.pause_panel.visible and not popup.frame.visible and not popup.backdrop.visible,"Pause hides memory artwork and backdrop while showing pause menu")
	game._toggle_pause()
	await settle()
	check(not paused and popup.frame.visible and popup.backdrop.visible and not game.dialogue_box.visible and game.dialogue_index == 1,"Resume restores the memory popup on the same line")
	await action("start")
	check(game.dialogue_index == 2 and popup.message.text == game.dialogue_lines[2],"Enter action advances exactly one memory line without button focus duplication")
	await click(popup.continue_button)
	check(game.dialogue_lines.is_empty() and not game.memory.visible and not popup.backdrop.visible and game.player.active,"Final third line closes memory and backdrop and restores player movement")
	print("MEMORY_POPUP_TESTS: ",checks-failures,"/",checks," passed")
	paused = false
	game.queue_free()
	game = null
	popup = null
	images.clear()
	for i in 4: await process_frame
	quit(1 if failures else 0)
