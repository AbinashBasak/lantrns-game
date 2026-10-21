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
	for i in 6: await process_frame
func launch(path: String) -> Node:
	paused = false
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null
		await settle()
	var game = load(path).instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	return game
func click(button: Button) -> void:
	var point := button.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = point
	root.push_input(motion,true)
	await process_frame
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
	var game = await launch("res://scenes/levels/chapter01_forgotten_trail.tscn")
	var menu = game.menu.get_parent().get_node_or_null("ExactTitleMenu")
	check(menu != null,"Exact title menu is installed in the game UI")
	if menu == null:
		quit(1)
		return
	var records = JSON.parse_string(FileAccess.get_file_as_string("res://assets/runtime/chapter01/ui/manifest.json"))
	var record: Dictionary = {}
	for item in records.files:
		if item.get("role","") == "exact_title_menu": record = item
	check(not record.is_empty(),"Exact title reference has a provenance manifest entry")
	if not record.is_empty():
		var texture = load("res://" + record.runtime)
		var pixels: Image = texture.get_image()
		pixels.convert(Image.FORMAT_RGBA8)
		var digest := HashingContext.new()
		digest.start(HashingContext.HASH_SHA256)
		digest.update(pixels.get_data())
		var pixel_hash := digest.finish().hex_encode()
		var bytes_match: bool = record.source_sha256 == record.sha256
		if FileAccess.file_exists("res://" + record.runtime):
			bytes_match = bytes_match and FileAccess.get_sha256("res://" + record.runtime) == record.source_sha256
		check(bytes_match and pixel_hash == record.get("pixel_sha256",""),"Runtime title preserves the exact supplied pixels and available source bytes")
		check(texture.get_size() == Vector2(1672,941),"Title retains the original 1672 by 941 pixel dimensions")
		var picture: TextureRect = menu.background
		var drawn_reference: bool = picture.texture != null and picture.texture.resource_path == "res://" + record.runtime and picture.is_visible_in_tree() and picture.get_global_rect().is_equal_approx(Rect2(0,0,1280,720))
		check(drawn_reference,"The displayed full-screen texture is the exact archived reference")
	check(paused and not game.started and game.menu.visible,"Title pauses gameplay before starting")
	check(not game.menu.get_child(0).visible,"Legacy title text and buttons are hidden")
	check(menu.get_global_rect().is_equal_approx(Rect2(0,0,1280,720)),"Exact title artwork covers the full 1280 by 720 game view")
	check(menu.primary.is_visible_in_tree() and menu.replay.is_visible_in_tree(),"Both artwork buttons have live visible input targets")
	check(menu.primary.get_global_rect().has_point(Vector2(354,455)) and menu.replay.get_global_rect().has_point(Vector2(355,602)),"Button targets align with the supplied Begin and Replay artwork")
	Input.action_press("start")
	await process_frame
	Input.action_release("start")
	await settle()
	check(game.started and not paused and not menu.is_visible_in_tree(),"Keyboard start enters Chapter 1 and hides exact title artwork")
	game = await launch("res://scenes/levels/prologue_brackenreach.tscn")
	menu = game.menu.get_parent().get_node("ExactTitleMenu")
	await click(menu.primary)
	check(current_scene.scene_file_path.ends_with("chapter01_forgotten_trail.tscn") and current_scene.started and not paused,"Actual Begin Chapter 1 mouse click skips the prologue and starts the chapter")
	game = await launch("res://scenes/levels/chapter01_forgotten_trail.tscn")
	menu = game.menu.get_parent().get_node("ExactTitleMenu")
	await click(menu.replay)
	check(current_scene.scene_file_path.ends_with("prologue_brackenreach.tscn") and current_scene.started and not paused,"Actual Replay mouse click starts the prologue without another title")
	paused = false
	current_scene.queue_free()
	await settle()
	print("EXACT_TITLE_MENU_TESTS: ",checks-failures,"/",checks," passed")
	quit(1 if failures else 0)
