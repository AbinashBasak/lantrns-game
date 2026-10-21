extends SceneTree
## Guidance stays in the HUD column and expires even if the controller repeats it.
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

func run() -> void:
	var game: Node = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	game._begin()
	while not game.dialogue_lines.is_empty():
		game._advance_dialogue()
	game.set_process(false)
	game.player.set_physics_process(false)
	var hud: Node = game.objective.get_parent().get_node("EncounterHUD")
	hud.layout_width = 800.0
	game.hint.text = "Explore east through the jungle · Solve the root seal to continue. Follow the lanterns through the ancient trees until you reach the next clearing."
	game.hint.show()
	game.hint.modulate.a = 1.0
	await settle()
	check(hud.hint_panel.visible and hud.hint_text.text == game.hint.text, "Guidance mirrors the live instruction in its HUD panel")
	check(game.hint.self_modulate.a == 0.0, "Original middle-screen guidance is suppressed")
	check(is_equal_approx(hud.hint_panel.position.x, 20.0) and hud.hint_panel.position.y >= hud.objective_panel.get_rect().end.y + 12.0, "Guidance sits in the upper-left column below the objective")
	check(hud.hint_text.get_line_count() > 1 and hud.hint_panel.get_global_rect().grow(1).encloses(hud.hint_text.get_global_rect()) and hud.hint_text.get_line_count() <= hud.hint_text.get_visible_line_count(), "Long guidance wraps fully inside its dynamic frame")
	game._notice("The ancient roots are stirring.")
	await settle()
	check(hud.hint_panel.position.y >= hud.feedback_panel.get_rect().end.y + 12.0, "Active feedback pushes guidance down without overlap")
	hud.set_process(false)
	hud._update_hint(6.0, true)
	check(not hud.hint_panel.visible and hud.hint_remaining == 0.0, "Guidance automatically hides after its display duration")
	hud._update_hint(0.1, true)
	check(not hud.hint_panel.visible and hud.hint_remaining == 0.0, "Repeating an unchanged instruction does not restart its timer")
	game.hint.text = "A new path opens beyond the roots."
	hud._update_hint(0.0, true)
	check(hud.hint_panel.visible and is_equal_approx(hud.hint_remaining, hud.HINT_DURATION), "A changed instruction starts a fresh timed notice")
	hud._update_hint(hud.HINT_DURATION - hud.HINT_FADE / 2.0, true)
	check(hud.hint_panel.visible and is_equal_approx(hud.hint_panel.modulate.a, 0.5), "Guidance fades smoothly before hiding")
	var remaining: float = hud.hint_remaining
	hud._update_hint(2.0, false)
	check(not hud.hint_panel.visible and is_equal_approx(hud.hint_remaining, remaining), "Gameplay overlays hide guidance and freeze its timer")
	game.hint.text = ""
	hud._update_hint(0.0, true)
	check(not hud.hint_panel.visible and hud.hint_remaining == 0.0 and hud.hint_text.text.is_empty(), "Cleared controller instructions dismiss immediately")
	print("TRANSIENT_HINT_TESTS: %d/%d passed" % [checks - failures, checks])
	game.queue_free()
	await settle()
	quit(1 if failures else 0)
