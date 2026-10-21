extends SceneTree
## Exercise layout with controller-fed content, rather than a fixed reference image.
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	checks += 1
	if ok:
		print("PASS: ", message)
	else:
		failures += 1
		push_error(message)

func settle() -> void:
	for i in 6:
		await process_frame

func fits_label(label: Label) -> bool:
	return label.get_minimum_size().y <= label.size.y + 1.0 and label.get_line_count() <= label.get_visible_line_count()

func contains_label(panel: Control, label: Label) -> bool:
	return panel.get_global_rect().grow(1.0).encloses(label.get_global_rect()) and fits_label(label)

func run() -> void:
	var game: Node = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	var hud: Node = game.objective.get_parent().get_node("EncounterHUD")
	game._begin()
	while not game.dialogue_lines.is_empty():
		game._advance_dialogue()
	game.player.set_physics_process(false)
	game.set_process(false) # Keep fixture text stable while the HUD continues processing.
	hud.layout_width = 1280.0
	game.rewards.points = 7
	game._notice("A root stirs.")
	await settle()
	var short_points_width: float = hud.points_panel.size.x
	var short_notice_height: float = hud.feedback_panel.size.y
	check(hud.visible and hud.points_text.text == "TRAIL POINTS  7", "HUD displays the controller's live short score")
	check(contains_label(hud.points_panel, hud.points_text), "Short score fits inside its assembled plaque")
	var skin: Node
	for child in game.get_children():
		if child.get_script() and child.get_script().resource_path.ends_with("prologue_skin.gd"):
			skin = child
	check(skin != null, "Player health uses the shared live UI skin")
	if skin != null:
		check(skin.hearts.size() == 5, "Player retains the previous five heart slots")
		check(skin.health_row.position == Vector2(27, 17) and skin.health_row.get_theme_constant("separation") == 3, "Heart row retains its previous position and spacing")
		for heart in skin.hearts:
			check(heart.custom_minimum_size == Vector2(41, 40), "Heart keeps its previous size")
		check(hud.hearts_frame.position == Vector2(20, 13) and hud.hearts_frame.size == Vector2(237, 48), "Hearts retain their previous compact frame")
		check(skin.vitality_frame is TextureRect and skin.vitality_frame.texture.resource_path == "res://assets/runtime/chapter01/story/boss_frame.png", "Vitality retains its original frame artwork")
		check(skin.vitality_frame.position == Vector2(256, 20) and skin.vitality_frame.size == Vector2(268, 70), "Vitality frame retains its previous position and size")
		game.player.health = 3
		game.player.vitality = 37
		await settle()
		check(skin.hearts[2].texture.resource_path.ends_with("health_full.png") and skin.hearts[3].texture.resource_path.ends_with("health_empty.png"), "Original heart artwork follows current remaining lives")
		check(skin.vitality_bar.value == 37 and skin.vitality_label.text == "37 / 100", "Vitality fill and numeric label follow the current player value")
		game.player.health = 5
		game.player.vitality = 100
		await settle()
	game.rewards.points = 987654321
	await settle()
	check(hud.points_text.text == "TRAIL POINTS  987654321", "Score updates without baking text into its artwork")
	check(hud.points_panel.size.x > short_points_width, "Points plaque widens to accommodate additional digits")
	check(contains_label(hud.points_panel, hud.points_text), "Expanded score remains inside its border")
	check(hud.points_panel.position.x >= 260 and hud.points_panel.get_rect().end.x <= 1188.0, "Wide viewport leaves room for hearts and the pause control")
	game._notice("The ancient roots restore the Hollow Sentinel. Take shelter beneath the lanterns, watch its sweeping branches, and wait for a clear opening before you strike again.")
	await settle()
	check(hud.feedback_text.get_line_count() > 1 and hud.feedback_panel.size.y > short_notice_height, "Long feedback wraps and grows its botanical notice")
	check(contains_label(hud.feedback_panel, hud.feedback_text), "Every line of the long notice fits inside its frame")
	game.objective.text = "CHAPTER 1  /  Search the forgotten forest for three ancient rune stones, then return beneath the lantern arch to unlock the hidden path."
	await settle()
	check(contains_label(hud.objective_panel, hud.objective_detail), "Long objective remains readable inside its expanding card")
	check(hud.feedback_panel.position.y >= hud.objective_panel.get_rect().end.y + 10.0, "Growing objective pushes its notice down without overlap")
	hud.layout_width = 800.0
	await settle()
	for panel in [hud.points_panel, hud.objective_panel, hud.feedback_panel]:
		check(panel.position.x >= 12.0 and panel.get_rect().end.x <= 788.0, "Content panel fits the narrow viewport: %s" % panel.name)
	check(contains_label(hud.points_panel, hud.points_text) and contains_label(hud.feedback_panel, hud.feedback_text), "Narrow layout keeps score and wrapped notice content inside their frames")
	game._notice("A root stirs.")
	await settle()
	check(hud.feedback_panel.size.y <= short_notice_height + 1.0, "Notice shrinks again when the live message becomes short")
	game.rewards.points = 7
	hud.layout_width = 1280.0
	await settle()
	check(hud.points_panel.size.x <= short_points_width + 1.0, "Points plaque returns to its compact size when fewer digits are shown")
	print("DYNAMIC_HUD_TESTS: %d/%d passed" % [checks - failures, checks])
	game.queue_free()
	await settle()
	quit(1 if failures else 0)
