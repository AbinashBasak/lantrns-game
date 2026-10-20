extends SceneTree
var game: Node
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func frames(count: int) -> void:
	for i in count: await physics_frame
func dialogue() -> void:
	for i in 20:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func place(at: Vector2) -> void:
	game.player.position = at
	game.player.velocity = Vector2.ZERO
	await frames(3)
func jump_right(count: int) -> void:
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(count)
	Input.action_release("move_right")
	Input.action_release("jump")
	await frames(35)
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	check(paused and game.menu.visible,"Chapter can launch directly with a title")
	game._begin()
	check(not game.player.active and not game.dialogue_lines.is_empty(),"Chapter intro is skippable dialogue")
	dialogue()
	await frames(35)
	check(game.player.is_on_floor(),"Chapter spawn settles on authored terrain")
	check(game.environment.forest_layers.size() == 4 and game.environment.temple_layers.size() == 4,"Forest and temple have independent four-layer backgrounds")
	game.interact_at("marker")
	dialogue()
	check(game.marker_read,"Trail marker inspection records the introduction")
	await place(Vector2(820,620))
	await jump_right(52)
	check(game.player.position.x > 1060 and game.player.is_on_floor(),"First root gap is crossable with a normal jump")
	await place(Vector2(1650,620))
	await jump_right(52)
	check(game.player.position.x > 1900 and game.player.is_on_floor(),"Wider second root gap is crossable with a normal jump")
	await place(Vector2(1950,620))
	await jump_right(30)
	check(game.player.is_on_floor() and game.player.position.y < 550,"Optional watchpost first step is reachable")
	await jump_right(33)
	check(game.token_collected,"Optional token is collected by reaching the watchpost ledge")
	await place(Vector2(3100,620))
	var hp: int = game.player.health
	game.activate_rune(2)
	check(game.rune_progress == 0 and game.rune_attempts == 1 and game.player.health == hp,"Incorrect rune input resets gently without damage")
	await place(Vector2(3140,620))
	check(game._nearby_interaction()[0] == "rune_2","Nearest prompt selects rune III rather than the adjacent arch")
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	await process_frame
	check(game.rune_attempts == 2,"Actual interact-button input activates the nearby rune")
	await place(Vector2(3240,620))
	check(game._nearby_interaction()[0] == "arch","Standing by the arch selects its story interaction")
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	await process_frame
	check(not game.dialogue_lines.is_empty(),"Actual interact-button input opens the arch clue")
	dialogue()
	game.puzzle_time = 29
	await frames(2)
	check(game.rune_clue.visible and "III" in game.rune_clue.text,"Rune clue exposes a complete visual sequence without sound")
	for i in [0,1,2,1,2]: game.activate_rune(i)
	dialogue()
	await frames(2)
	check(game.bridge_open and game.puzzle_gate.disabled,"Five correct rune activations unlock the crossing")
	check(game.environment.bridge_open,"Generated root crossing reflects solved state")
	await place(Vector2(3260,620))
	for count in [33,28,30,37]: await jump_right(count)
	check(game.player.position.x > 3900 and game.player.is_on_floor(),"Revealed root platforms provide a fully traversable crossing")
	game.interact_at("exit")
	dialogue()
	check(not game.completed,"Chapter exit requires the fragment")
	game.interact_at("fragment")
	check(not game.fragment_collected,"Fragment cannot be collected before Sentinel defeat")
	await place(Vector2(6100,620))
	check(game.checkpoint_active and game.checkpoint.x == 6100,"Temple checkpoint activates near its generated mark")
	game.player.health = 1
	game.player.invincible = 0
	game.player.take_damage(100)
	await frames(3)
	check(game.player.health == 5 and absf(game.player.position.x-6100) < 35,"Defeat restores full health at the temple checkpoint")
	check(game.boss.health == 24 and game.boss.state == "dormant","Checkpoint recovery restores the unstarted Sentinel encounter")
	await place(Vector2(6700,620))
	check(game.boss_active and game.boss.state == "wake","Arena entry wakes the Hollow Sentinel")
	var boss_hp: int = game.boss.health
	game.boss.take_damage(1,1)
	check(game.boss.health == boss_hp,"Sentinel awakening cannot be skipped by sword damage")
	await frames(105)
	await place(game.boss.position + Vector2(-75,0))
	game.player.facing = 1
	game.player.attack()
	await frames(15)
	check(game.boss.health == 23,"Player sword damages the active Sentinel once per swing")
	game._toggle_pause()
	var timer: float = game.boss.state_time
	await frames(8)
	check(game.boss.state_time == timer and not game.presentation.can_process(),"Pause freezes boss state and audio presentation")
	game._toggle_pause()
	game.boss.health = 12
	game.boss.state = "approach"
	game.player.invincible = 0
	await frames(2)
	check(game.boss.phase_transition_seen and game.boss.state == "transition","Half-health Sentinel enters its second phase")
	await frames(90)
	game.boss.attack_count = 1
	game.boss.state = "approach"
	await frames(2)
	check(game.boss.state == "windup" and game.boss.pending_wave,"Second phase telegraphs a root wave")
	var locked_safe: float = game.boss.safe_center
	var locked_facing: float = game.boss.direction
	game.player.position = Vector2(locked_safe,620)
	await frames(4)
	check(game.boss.safe_center == locked_safe and game.boss.direction == locked_facing,"Root-wave safe pocket and facing remain locked during the warning")
	game.player.health = 5
	game.player.restore_vitality()
	game.player.invincible = 0
	await frames(65)
	check(game.player.health == 5,"Visible safe ground avoids the Sentinel root wave")
	game.boss.state = "rootwave"
	game.boss.state_time = 0.25
	game.boss.attack_landed = false
	game.boss.safe_center = 6660
	game.player.position = Vector2(7400,620)
	game.player.health = 5
	game.player.restore_vitality()
	game.player.invincible = 0
	await frames(2)
	check(game.player.health == 5 and game.player.vitality == 45,"Root-wave danger ground deals 55 vitality damage")
	await frames(3)
	check(game.player.health == 5 and game.player.vitality == 45,"A single wave does not chain-hit the player")
	game.player.invincible = 0
	game.player.health = 1
	game.player.take_damage(100)
	await frames(3)
	check(not game.boss_active and game.boss.health == 24 and game.boss.state == "dormant","Losing to the boss resets it for a quick checkpoint retry")
	check(game.bridge_open and game.token_collected,"Checkpoint retry preserves solved puzzle and optional discovery")
	await place(Vector2(6700,620))
	await frames(105)
	game.boss.state = "recover"
	game.boss.take_damage(24,1)
	await frames(3)
	dialogue()
	check(game.boss_defeated and game.arena_exit.disabled and not game.boss.is_in_group("enemies"),"Sentinel defeat opens the arena and removes attack targeting")
	game.interact_at("fragment")
	check(game.fragment_collected and game.memory.visible,"Golden Fragment reveals the generated orchard memory")
	dialogue()
	check(not game.memory.visible,"Memory closes after skippable fragment dialogue")
	game.interact_at("fragment")
	check(game.fragment_collected and game.dialogue_lines.is_empty(),"Fragment collection is one-shot")
	game.interact_at("exit")
	dialogue()
	check(game.completed and paused and game.victory_panel.visible,"Fragment and exit complete The Forgotten Trail")
	game._restart()
	for i in 4: await process_frame
	game = current_scene
	check(not game.bridge_open and not game.token_collected and not game.fragment_collected and game.boss.health == 24,"Chapter restart resets puzzle, optional token, fragment and boss")
	check(paused and game.menu.visible,"Restart returns to a usable chapter title")
	paused = false
	game.queue_free()
	game = null
	for i in 4: await process_frame
	print("CHAPTER 1 TEST: ","PASS" if failures == 0 else "FAIL"," (",failures," failures)")
	quit(0 if failures == 0 else 1)
