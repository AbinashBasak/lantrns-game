extends SceneTree
var game: Node
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	checks += 1
	if ok: print("PASS: ",label)
	else:
		failures += 1
		push_error(label)
func frames(count: int) -> void:
	for i in count: await physics_frame
func dialogue() -> void:
	for i in 20:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func place(point: Vector2) -> void:
	game.player.position = point
	game.player.velocity = Vector2.ZERO
	await frames(2)
func jump(count: int) -> void:
	Input.action_press("jump")
	Input.action_press("move_right")
	await frames(count)
	Input.action_release("jump")
	Input.action_release("move_right")
	await frames(35)
func run() -> void:
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	check(paused and game.menu.visible,"Chapter 2 launches with its own title")
	check(game.objective.get_parent().get_node_or_null("ExactTitleMenu") == null,"Orchard title cannot accidentally launch Chapter 1")
	game.jungle_cleared.assign([true,true,true,true])
	for room in game.jungle_rooms: room.completed = true
	game._begin()
	check(not game.player.active,"Intro disables movement and attack")
	dialogue()
	await frames(35)
	check(game.player.is_on_floor(),"Orchard spawn settles on terrain")
	game.interact_at("binding_0")
	check(not game.bindings_freed[0],"Remote interaction cannot skip grove traversal")
	await place(Vector2(1095,620))
	await jump(30)
	check(game.player.is_on_floor() and game.player.position.y < 550,"Climbing grove first ledge is reachable")
	await jump(38)
	check(game.player.position.y < 470,"First binding ledge is reachable")
	await place(Vector2(1500,450))
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	await process_frame
	check(game.bindings_freed[0],"Actual interact input cuts elevated binding")
	dialogue()
	check(not is_instance_valid(game.grove_enemies[0][0]),"Unbinding releases the grove enemy")
	# Ride the root from its starting bank, with no held movement input.
	var root_platform: AnimatableBody2D = game.moving_roots[0]
	root_platform.reset_motion()
	await frames(3)
	await place(root_platform.global_position + Vector2(80,0))
	await frames(15)
	var ride_start: float = game.player.position.x
	await frames(145)
	check(game.player.position.x > ride_start+100 and game.player.is_on_floor(),"Moving root carries a standing player across the ravine")
	await jump(38)
	check(game.player.position.x >= 2500 and game.player.is_on_floor(),"First moving-root crossing reaches the far bank")
	var root_position: Vector2 = root_platform.global_position
	game._toggle_pause()
	await frames(8)
	check(root_platform.global_position == root_position,"Pause freezes moving roots")
	game._toggle_pause()
	await place(Vector2(3300,620))
	game.interact_at("binding_1")
	dialogue()
	await place(Vector2(4300,620))
	game.interact_at("binding_2")
	dialogue()
	check(game.bindings_freed.count(true) == 3,"All three independent grove bindings can be released")
	var second_root: AnimatableBody2D = game.moving_roots[1]
	second_root.reset_motion()
	await frames(3)
	await place(second_root.global_position+Vector2(80,0))
	await frames(145)
	await jump(35)
	check(game.player.position.x > 4700 and game.player.is_on_floor(),"Second irrigation gap is crossable using its moving root")
	game._notice("A single five-second guidance message")
	game.guidance_time = 0.2
	game._notice("A single five-second guidance message")
	check(game.guidance_time == 0.2,"Repeated guidance does not restart its timer")
	game.player.health = 3
	game.player.vitality = 57
	game.player.invincible = 60
	await place(Vector2(4780,620))
	check(game.checkpoint_active,"Orchard checkpoint activates after traversal")
	check(game.player.health == 3 and game.player.vitality == 57,"Checkpoint activation preserves current lives and vitality")
	await place(Vector2(4890,620))
	game.interact_at("carving")
	dialogue()
	await frames(2)
	check(game.carving_read and game.orchard_gate.disabled,"Voice memory opens the guardian passage")
	await place(Vector2(5320,620))
	check(game.boss_active and not game.dialogue_lines.is_empty(),"Guardian enters with a skippable tutorial")
	dialogue()
	await frames(2)
	check(not game.arena_entry.disabled,"Guardian encounter closes its entrance")
	var hp: int = game.boss.health
	game.boss.take_damage(3,game.boss.direction)
	check(game.boss.health == hp-3,"Guardian body takes sword damage outside recovery")
	game.boss._enter("idle",0)
	await frames(2)
	var locked_direction: float = game.boss.direction
	await place(Vector2(6550,620))
	check(game.boss.state == "charge_warning" and game.boss.direction == locked_direction,"Charge warning locks its direction before Tavi moves")
	game._toggle_pause()
	var boss_timer: float = game.boss.state_time
	await frames(8)
	check(game.boss.state_time == boss_timer,"Pause freezes guardian attack timing")
	game._toggle_pause()
	game.boss.health = game.boss.max_health
	game.boss.flash = 0
	game.boss._enter("recover",3)
	game.boss.direction = 1
	await place(game.boss.position+Vector2(-75,0))
	game.player.facing = 1
	game.player.attack()
	await frames(15)
	check(game.boss.health == game.boss.max_health-1,"Actual player sword hits illustrated guardian once from the left")
	game.boss.health = game.boss.max_health
	game.boss.flash = 0
	game.boss._enter("recover",3)
	game.boss.take_damage(1,-game.boss.direction)
	check(game.boss.health == game.boss.max_health-1,"Frontal sword damage reaches guardian body")
	game.boss.flash = 0
	game.boss.take_damage(game.boss.health-9,game.boss.direction)
	check(game.boss.health == 9,"Weakening guardian to nine health opens optional column stage")
	await place(Vector2(6410,620))
	game.boss._enter("recover",3)
	game.interact_at("column")
	game.interact_at("column")
	game.interact_at("column")
	check(game.boss.binding_exposed and game.boss.column_hits == 3,"Three nearby column strikes expose the parasite")
	game.player.health = 1
	game.player.vitality = 1
	game.player.invincible = 0
	game.player.take_damage(100)
	await frames(3)
	check(not game.boss_active and game.boss.health == game.boss.max_health and game.boss.column_hits == 0,"Death resets guardian strength and column for a fair retry")
	check(game.bindings_freed.count(true) == 3 and game.carving_read,"Checkpoint retry preserves all grove and story progress")
	check(game.player.health == 5 and absf(game.player.position.x-4850) < 25,"Retry restores Tavi at orchard checkpoint")
	await place(Vector2(5320,620))
	check(game.boss_active and game.dialogue_lines.is_empty(),"Retry starts boss without replaying tutorial")
	game.boss._enter("recover",3)
	game.boss.take_damage(game.boss.max_health-9,game.boss.direction)
	check(not game.boss_defeated and game.boss.health == 9,"Weakened living guardian supports optional binding rescue")
	await place(Vector2(6410,620))
	game.boss._enter("recover",3)
	for i in 3: game.interact_at("column")
	await place(game.boss.position+Vector2(-100,0))
	game.boss._enter("idle",1)
	game.interact_at("guardian_binding")
	check(game.boss.freed_bindings == 0,"Binding cut is blocked outside recovery")
	game.boss._enter("recover",3)
	for i in 3: game.interact_at("guardian_binding")
	check(game.boss_defeated and game.boss.freed_bindings == 3,"Three recovery-window cuts free Mossjaw")
	dialogue()
	await frames(2)
	check(game.arena_exit.disabled and not game.boss.is_in_group("enemies"),"Freed guardian opens exit and ceases being a sword target")
	await place(Vector2(7310,620))
	game.interact_at("exit")
	dialogue()
	check(not game.completed,"Fragment is required before the chapter ending")
	game.rewards.open_chest()
	await place(Vector2(6720,620))
	game.interact_at("fragment")
	dialogue()
	check(game.fragment_collected,"Anchor fragment grants the orchard memory")
	await place(Vector2(7310,620))
	game.interact_at("exit")
	dialogue()
	check(game.completed and paused and game.victory_panel.visible,"Sable warning completes Chapter 2")
	game._restart()
	for i in 5: await process_frame
	game = current_scene
	check(game.bindings_freed.count(true) == 0 and not game.fragment_collected and game.boss.state == "dormant","Restart clears Chapter 2 session progression")
	check(paused and game.menu.visible,"Restart returns to Chapter 2 title")
	paused = false
	game.queue_free()
	for i in 4: await process_frame
	# Verify the real Chapter 1 continuation entry point.
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game.victory_panel.get_child(1).get_node("ContinueChapter").pressed.emit()
	for i in 6: await process_frame
	game = current_scene
	check("chapter_number" in game and game.started and not paused,"Chapter 1 continuation starts Chapter 2 directly")
	paused = false
	game.queue_free()
	for i in 6: await process_frame
	print("CHAPTER 2 TEST: ","PASS" if failures == 0 else "FAIL"," (",checks," checks, ",failures," failures)")
	quit(0 if failures == 0 else 1)
