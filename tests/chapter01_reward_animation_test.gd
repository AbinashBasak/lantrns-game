extends SceneTree
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, text: String) -> void:
	checks += 1
	print(("PASS: " if ok else "FAIL: ")+text)
	if not ok: failures += 1
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	var rewards = game.rewards
	rewards.set_process(false)
	rewards.chest_available = true
	rewards.open_chest()
	check(rewards.chest_phase == "rattle" and rewards.opening > 0,"Chest begins anticipation while granting gameplay reward immediately")
	check(game.player.attack_damage == 2 and rewards.points == 500,"Visual timeline preserves immediate charm and point grant")
	rewards._process(0.5)
	check(rewards.chest_phase == "unlatch","Anticipation transitions into unlatching")
	rewards._process(0.5)
	check(rewards.chest_phase == "open","Lid opening follows the latch")
	rewards._process(0.8)
	check(rewards.chest_phase == "reveal" and rewards.reveal_progress > 0.8,"Charm reveal ramps smoothly after the lid opens")
	var time: float = rewards.animation_time
	var ambient: float = rewards.effect_time
	paused = true
	rewards._process(1.0)
	check(rewards.animation_time == time and rewards.effect_time == ambient,"Pause freezes chest and ambient particle clocks")
	paused = false
	game.presentation.reduced_effects = true
	rewards._process(0.1)
	check(rewards.reduced_effects and rewards.reveal_progress > 0,"Reduced effects retains readable reward reveal without orbit particles")
	rewards._process(2.0)
	check(rewards.chest_phase == "looted" and rewards.opening == 0 and rewards.reveal_progress == 0,"Chest settles into stable looted state")
	rewards.open_chest()
	check(rewards.points == 500 and rewards.chest_phase == "looted","Reinteraction cannot restart the reward or animation")
	game.queue_free()
	for i in 6: await process_frame
	print("REWARD ANIMATION FAILURES: ",failures," CHECKS: ",checks)
	quit(1 if failures else 0)
