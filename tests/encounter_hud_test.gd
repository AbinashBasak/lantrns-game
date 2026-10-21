extends SceneTree
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func settle() -> void:
	for i in 4: await process_frame
func run() -> void:
	var game: Node = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await settle()
	var hud: Node = game.objective.get_parent().get_node_or_null("EncounterHUD")
	if hud == null:
		load("res://scripts/ui/encounter_hud.gd").apply(game)
		hud = game.objective.get_parent().get_node("EncounterHUD")
	check(not hud.visible,"Encounter HUD stays hidden on title menu")
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	await settle()
	check(hud.visible and hud.objective_panel.visible,"Playing chapter shows the framed live objective")
	check(hud.objective_detail.text in game.objective.text,"Objective detail mirrors current chapter instruction")
	game.rewards.points = 379
	game._notice("The roots restore the Sentinel — brace for its berserk return!")
	await settle()
	check(hud.points_text.text == "TRAIL POINTS  379","Points plaque reads the live reward total")
	check(hud.feedback_panel.visible and "berserk" in hud.feedback_text.text,"Botanical notice displays live encounter feedback")
	game.jungle_cleared.assign([0,1,2])
	game._start_boss()
	await settle()
	check(hud.objective_heading.text == "Hollow Sentinel","Boss encounter updates the objective heading")
	check(game.boss_ui.get_child(0) == hud.source_boss_title,"Boss phase label retains controller child-zero contract")
	game._on_boss_health(8,24)
	check(game.boss_health.value == 8 and game.boss_health.max_value == 24,"Boss health remains a live proportional fill")
	check(game.boss_health.size.x > 350 and hud.portrait.texture != null and hud.portrait.size.x <= 550,"Wide health bar retains generated Sentinel portrait")
	check(game.boss_ui.position.x > hud.objective_panel.get_rect().end.x,"Boss bar and objective occupy distinct horizontal regions")
	game._toggle_pause()
	await settle()
	check(not hud.visible,"Pause hides encounter panels")
	game._toggle_pause()
	game.victory_panel.show()
	await settle()
	check(not hud.visible,"Completion popup hides encounter panels")
	print("ENCOUNTER_HUD_TESTS: %d/%d passed" % [checks-failures,checks])
	quit(1 if failures else 0)
