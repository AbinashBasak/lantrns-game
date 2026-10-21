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
	if not game.objective.get_parent().has_node("RewardSceneHUD"):
		load("res://scripts/ui/reward_scene_hud.gd").apply(game)
	var hud: Node = game.objective.get_parent().get_node("RewardSceneHUD")
	check(not hud.visible,"Reward HUD does not appear on title")
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game.jungle_cleared.assign([0,1,2])
	game.boss_defeated = true
	game.rewards.chest_available = true
	game.player.position = Vector2(7740,620)
	game.player.set_physics_process(false)
	await settle()
	check(hud.visible and hud.chapter_banner.visible,"Defeated Sentinel reveals slim reward objective")
	check(hud.encounter.objective_panel.modulate.a == 0,"Reward objective replaces encounter card")
	check(hud.badge_active and hud.use_button.visible and game.hint.modulate.a == 0,"Chest proximity provides one readable use prompt")
	check(hud.use_button.position.x >= 12 and hud.use_button.position.y <= 580,"Chest use prompt remains in safe viewport bounds")
	var points: int = game.rewards.points
	hud.use_button.pressed.emit()
	await settle()
	check(game.rewards.chest_opened and game.rewards.points == points+500,"Chest button invokes existing one-shot reward interaction")
	check(not hud.badge_active and game.hint.modulate.a == 1,"Opened chest releases ordinary interaction hints")
	check("Collect the Golden Fragment" in hud.objective_text.text,"Objective advances to fragment after chest reward")
	game.fragment_collected = true
	await settle()
	check("Briarwake" in hud.objective_text.text,"Collected fragment advances objective toward exit")
	game._toggle_pause()
	await settle()
	check(not hud.visible,"Reward HUD hides while paused")
	game._toggle_pause()
	game.boss_defeated = false
	await settle()
	check(hud.encounter.objective_panel.modulate.a == 1,"Ordinary encounter objective returns outside reward phase")
	print("REWARD_SCENE_HUD_TESTS: %d/%d passed" % [checks-failures,checks])
	quit(1 if failures else 0)
