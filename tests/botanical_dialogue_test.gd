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
func settle() -> void:
	for i in 4: await process_frame
func click(button: Button) -> void:
	for down in [true,false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.position = button.get_global_rect().get_center()
		event.pressed = down
		root.push_input(event,true)
		await process_frame
	await settle()
func run() -> void:
	var game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	var dialogue = game.get_node_or_null("BotanicalDialogue")
	check(dialogue != null,"Prologue installs the shared botanical dialogue helper")
	if dialogue == null:
		quit(1)
		return
	check(not dialogue.card.visible,"Botanical dialogue stays hidden on the title")
	game._begin()
	game._show_dialogue("rescue")
	await settle()
	check(dialogue.card.visible and not game.dialogue_box.visible and not game.player.active,"Botanical dialogue replaces the legacy render while keeping movement suspended")
	check(dialogue.frame.texture != null and dialogue.frame.texture.resource_path.ends_with("UI-009_botanical_dialogue.png"),"Reusable generated botanical artwork is loaded")
	check(dialogue.speaker.text == "Tavi:" and dialogue.message.text == "Hold still. I'll lift this end.","Speaker and body are live text split from the dialogue model")
	check(dialogue.message.get_rect().end.y < dialogue.continue_button.position.y and dialogue.card.get_global_rect().end.y < 620,"Text, Continue and player feet have separate safe layout space")
	check(dialogue.continue_button.focus_mode == Control.FOCUS_NONE,"Continue leaves keyboard dialogue input under the controller")
	if "--capture" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/botanical-dialogue-preview.png")
	await click(dialogue.continue_button)
	check(game.dialogue_index == 1 and dialogue.speaker.text == "Narrator" and dialogue.message.text.begins_with("The little root-creature"),"Actual mouse Continue advances exactly one line and displays narration")
	game._toggle_pause()
	await settle()
	check(paused and not dialogue.card.visible and game.pause_panel.visible,"Pause hides the dialogue artwork and leaves the pause menu interactive")
	game._toggle_pause()
	await settle()
	check(not paused and dialogue.card.visible and game.dialogue_index == 1,"Resume restores the same dialogue line")
	Input.action_press("start")
	await process_frame
	Input.action_release("start")
	await settle()
	check(game.dialogue_index == 2 and dialogue.speaker.text == "Tavi:","Keyboard Continue advances exactly one line without duplicate focus activation")
	await click(dialogue.continue_button)
	check(game.dialogue_lines.is_empty() and not dialogue.card.visible and game.player.active,"Final Continue closes the artwork and restores player control")
	game._show_dialogue("rusk")
	game.dialogue_index = game.dialogue_lines.size()-1
	game.dialogue_label.text = game.dialogue_lines[game.dialogue_index]
	await settle()
	check(dialogue.speaker.text == "Rusk:" and dialogue.message.get_line_count() * dialogue.message.get_line_height() <= dialogue.message.size.y and dialogue.message.get_theme_font_size("font_size") >= 17,"Longest Rusk speech remains readable and fits the parchment body")
	if "--capture" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/botanical-dialogue-rusk-preview.png")
	game._show_dialogue("weapon")
	game.dialogue_index = game.dialogue_lines.size()-1
	game.dialogue_label.text = game.dialogue_lines[game.dialogue_index]
	await settle()
	check(dialogue.message.get_line_count() * dialogue.message.get_line_height() <= dialogue.message.size.y,"Longest health tutorial wraps within the same safe dialogue body")
	var pause_button: Button = game.pause_panel.get_child(0).get_child(1)
	check(pause_button.get_theme_font("font") is SystemFont and pause_button.get_theme_stylebox("normal") is StyleBoxFlat,"Pause controls share serif typography and emerald-gold button styling")
	paused = false
	game.queue_free()
	current_scene = null
	await settle()
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	dialogue = game.get_node_or_null("BotanicalDialogue")
	check(dialogue != null,"Chapter 1 uses the same dialogue helper")
	if dialogue != null:
		game._begin()
		while not game.dialogue_lines.is_empty(): game._advance_dialogue()
		game.boss_defeated = true
		game.rewards.chest_opened = true
		game._collect_fragment()
		await settle()
		check(game.memory.visible and not dialogue.card.visible,"Orchard memory keeps its dedicated popup without a second dialogue card")
	paused = false
	game.queue_free()
	await settle()
	print("BOTANICAL_DIALOGUE_TESTS: ",checks-failures,"/",checks," passed")
	quit(1 if failures else 0)
