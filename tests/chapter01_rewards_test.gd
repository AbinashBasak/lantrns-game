extends SceneTree
var failures := 0
var checks := 0
var game: Node
func _initialize() -> void: call_deferred("run")
func check(ok: bool, text: String) -> void:
	checks += 1
	print(("PASS: " if ok else "FAIL: ")+text)
	if not ok: failures += 1
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game.jungle_cleared.assign([0,1,2])
	check(game.rewards.points == 0,"Journey starts with zero trail points")
	var enemy = get_nodes_in_group("enemies")[0]
	enemy.take_damage(99,1)
	check(game.rewards.points == 100 and game.rewards.motes.size() == 1,"Enemy kill grants points and animated reward burst")
	game._reset_trail_enemies()
	await process_frame
	var retry = get_nodes_in_group("enemies")[0]
	retry.take_damage(99,1)
	check(game.rewards.points == 100,"Checkpoint enemy repeat cannot farm points")
	game.rewards.open_chest()
	check(not game.rewards.chest_opened and game.player.attack_damage == 1,"Chest cannot be opened before boss completion")
	game.boss.activate(game.player)
	game.boss.state = "recover"
	game.boss.take_damage(24,1)
	check(not game.boss_defeated and not game.rewards.chest_available,"First boss depletion does not grant chest or victory")
	game.boss._physics_process(1.7)
	game.boss._physics_process(2.3)
	game.boss.state = "recover"
	game.boss.take_damage(24,1)
	check(game.boss_defeated and game.rewards.chest_available and game.rewards.points == 1100,"Final berserk defeat grants chest and 1000 points")
	game._collect_fragment()
	check(not game.fragment_collected,"Golden Fragment remains gated behind reward chest")
	game.rewards.open_chest()
	check(game.rewards.chest_opened and game.rewards.opening > 0,"Reward chest starts opening animation")
	check(game.player.attack_damage == 2 and game.rewards.points == 1600,"Chest grants Rootward Charm and500points")
	game.rewards.open_chest()
	check(game.rewards.points == 1600,"Chest reward is one-shot")
	for i in 3: await process_frame
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	game._collect_fragment()
	check(game.fragment_collected,"Opened chest unlocks the story fragment")
	game.queue_free()
	for i in 4: await process_frame
	print("REWARD FAILURES: ",failures," CHECKS: ",checks)
	quit(1 if failures else 0)
