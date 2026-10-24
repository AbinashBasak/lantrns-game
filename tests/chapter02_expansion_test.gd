extends SceneTree
## Full real-scene campaign regression. Run after generated packs are imported.
var game: Node
var failures := 0
var checks := 0
const Jungle = preload("res://scripts/systems/chapter02_jungle.gd")
func _initialize() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	checks += 1
	print(("PASS: " if ok else "FAIL: ")+label)
	if not ok:
		failures += 1
		push_error(label)
func frames(count: int) -> void:
	for i in count: await physics_frame
func dialogue() -> void:
	for i in 60:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()
func place(point: Vector2) -> void:
	game.player.position = point
	game.player.velocity = Vector2.ZERO
	game.player.invincible = 20
	await frames(3)
func walk_right(count: int) -> void:
	Input.action_press("move_right")
	await frames(count)
	Input.action_release("move_right")
func jump_gap(from: Vector2, far_bank: float, label: String) -> void:
	await place(from)
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(40)
	Input.action_release("jump")
	await frames(6)
	Input.action_release("move_right")
	await frames(15)
	check(game.player.position.x > far_bank and game.player.is_on_floor() and game.player.position.y < 650,label)
func interact(point: Vector2, id: String) -> void:
	await place(point)
	game.interact_at(id)
	dialogue()
	await frames(2)
func run() -> void:
	if has_meta("from_chapter01"): remove_meta("from_chapter01")
	set_meta("campaign_progress",{"points":1700,"attack_damage":2})
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	var ui: Control = game.objective.get_parent()
	var hud: Control = ui.get_node("Chapter02HUD")
	check(paused and game.menu.visible,"Chapter 2 launches its updated title")
	check(ui.get_node_or_null("Chapter02Title") != null,"Chapter 2 has the latest artwork title with its own actions")
	check(game.rewards.points == 1700 and game.player.attack_damage == 2,"Campaign points and Rootward Charm carry into Chapter 2")
	game._begin()
	dialogue()
	await frames(30)
	check(hud.points_text.text.contains("1700") and not hud.objective_detail.text.is_empty(),"Real HUD displays campaign points and current objective")
	check(hud.hint_panel.get_theme_stylebox("panel") is StyleBoxTexture,"Guidance retains Chapter 1 texture frame")
	game.interact_at("binding_0")
	check(not game.bindings_freed[0],"A remote binding interaction cannot skip traversal")
	game.rewards.open_chest()
	check(not game.rewards.chest_opened,"Mossjaw chest stays locked before guardian rescue")
	game._start_guardian()
	check(not game.boss_active,"Guardian activation cannot skip four jungle missions")
	var total_enemies := 0
	for index in 4:
		game.player.health = 3
		game.player.vitality = 57
		await place(Vector2(game.JUNGLE_ENTRANCES[index]-35,620))
		await walk_right(24)
		dialogue()
		await frames(3)
		var room: Node2D = game.jungle_rooms[index]
		check(game.jungle_area==index and room.active,"Route enters jungle %d" % (index+1))
		check(game.player.health==3 and game.player.vitality==57,"Jungle %d entry preserves lives and vitality" % (index+1))
		check(room.enemies.size()==7,"Jungle %d contains seven authored enemy placements" % (index+1))
		for enemy in room.enemies:
			total_enemies += 1
			check(enemy.art_ready and enemy.sprite.visible and enemy.is_in_group("enemies"),"Generated species texture loaded in jungle %d" % (index+1))
			check(enemy.sprite.sprite_frames.get_frame_texture("attack",0)!=null,"Enemy has actual illustrated attack frames")
			# Freeze attacks during traversal assertions; real gameplay scripts remain installed.
			enemy.active = false
		var spots: Array[Vector2] = room.puzzle_positions()
		room.interact_at("jungle_%d_control_0" % index)
		check(room.progress==0,"Remote puzzle interaction rejected in jungle %d" % (index+1))
		var wrong: int = (Jungle.ORDERS[index][0]+1)%3
		await interact(room.to_global(spots[wrong]),"jungle_%d_control_%d" % [index,wrong])
		check(room.progress==0 and not room.completed,"Wrong-order puzzle resets jungle %d" % (index+1))
		await place(room.to_global(Vector2(Jungle.GATE_X-80,620)))
		await walk_right(40)
		check(game.player.global_position.x<room.global_position.x+Jungle.GATE_X,"Unsolved jungle %d has a physical exit gate" % (index+1))
		if index==2: await jump_gap(room.to_global(Vector2(690,620)),room.global_position.x+900,"Underground route gap is traversable with real jump input")
		var points_before: int = game.rewards.points
		for choice in Jungle.ORDERS[index]:
			await interact(room.to_global(spots[choice]),"jungle_%d_control_%d" % [index,choice])
		check(room.completed and room.gate_collision.disabled,"Correct puzzle order opens jungle %d gate" % (index+1))
		check(game.rewards.points>=points_before+500,"Jungle %d puzzle grants its one-time reward" % (index+1))
		var earned_points: int = game.rewards.points
		var enemy = room.enemies[0]
		if is_instance_valid(enemy):
			enemy.active = true
			enemy.take_damage(99,1)
		check(game.rewards.points==earned_points+100,"Room enemy grants100points")
		var after_enemy: int = game.rewards.points
		game._respawn()
		await frames(3)
		check(game.player.health==5 and game.player.vitality==100,"Death retry explicitly restores lives and vitality in jungle %d" % (index+1))
		check(room.completed and room.gate_collision.disabled,"Checkpoint preserves jungle %d puzzle" % (index+1))
		var replacement = room.enemies[0]
		replacement.active = true
		replacement.take_damage(99,1)
		check(game.rewards.points==after_enemy,"Respawn cannot farm the same jungle enemy")
		for foe in room.enemies:
			if is_instance_valid(foe): foe.active = false
		game.player.health = 2
		game.player.vitality = 41
		await place(room.to_global(Vector2(Jungle.EXIT_X-90,620)))
		await walk_right(35)
		await frames(3)
		check(game.jungle_area==-1 and not room.active,"Walking through solved jungle %d returns to orchard" % (index+1))
		check(game.player.health==2 and game.player.vitality==41,"Jungle %d exit preserves lives and vitality" % (index+1))
		if index<3: await interact(game.BINDINGS[index],"binding_%d" % index)
	check(game.bindings_freed.count(true)==3,"Three bindings unlock after their required jungle routes")
	check(total_enemies==28,"Four expeditions provide28distinct enemy placements")
	for crossing in 2:
		var moving: AnimatableBody2D = game.moving_roots[crossing]
		moving.reset_motion()
		await frames(3)
		await place(moving.global_position+Vector2(80,0))
		await frames(145)
		Input.action_press("move_right")
		Input.action_press("jump")
		await frames(38)
		Input.action_release("jump")
		Input.action_release("move_right")
		await frames(35)
		check(game.player.is_on_floor() and game.player.position.x>[2500,4700][crossing],"Real running jump completes orchard moving-root crossing %d" % (crossing+1))
	await interact(Vector2(4890,620),"carving")
	check(game.carving_read and game.orchard_gate.disabled,"All jungle missions unlock the guardian gate")
	await place(Vector2(5320,620))
	dialogue()
	await frames(3)
	check(game.boss_active and not game.arena_entry.disabled,"Guardian encounter closes arena entry")
	game.boss.set_physics_process(false)
	game.boss.health = game.boss.max_health/2
	# SceneTree emits process_frame before child Control._process updates the bar.
	await process_frame
	await process_frame
	check(hud.boss_panel.visible and is_equal_approx(hud.boss_health.value/hud.boss_health.max_value,0.5),"Mossjaw has a live proportional textured health bar")
	game.boss.attack_index = 0
	game.player.position = Vector2(5500,620)
	game.boss.position = Vector2(6200,620)
	for expected in ["charge_warning","eruption_warning","claw_warning","leap_warning","volley_warning","sweep_warning","rush_warning"]:
		game.boss._choose_attack()
		check(game.boss.state==expected,"Mossjaw pattern: "+expected)
	var target_x: float = game.boss.eruption_x
	var facing: float = game.boss.direction
	game.player.position.x = 6600
	check(game.boss.eruption_x==target_x and game.boss.direction==facing,"Guardian wind-up locks target and facing")
	game.boss._enter("volley",1.2)
	game.boss._spawn_volley()
	var seed_position: Vector2 = game.boss.projectiles[0].position
	var timer: float = game.boss.state_time
	game.player.active = false
	game.boss._physics_process(0.3)
	check(game.boss.projectiles[0].position==seed_position and game.boss.state_time==timer,"Dialogue freezes boss seeds and attack timers")
	game.player.active = true
	game.boss._clear_hazards()
	game.boss.health = game.boss.max_health
	game.boss._enter("recover",3)
	game.boss.direction = 1
	game.boss.take_damage(3,-1)
	check(game.boss.health==game.boss.max_health-3,"Front sword strike damages guardian body")
	game.boss.flash = 0
	game.boss.take_damage(game.boss.health-9,1)
	check(game.boss.health==9 and not game.boss_defeated and not game.rewards.chest_available,"Living weakened guardian supports optional binding rescue")
	await interact(Vector2(6410,620),"column")
	for i in 2: game.interact_at("column")
	check(game.boss.binding_exposed,"Three real nearby column interactions expose bindings")
	await place(game.boss.position+Vector2(-100,0))
	game.boss._enter("idle",1)
	game.interact_at("guardian_binding")
	check(game.boss.freed_bindings==0,"Binding interaction requires the recovery window")
	game.boss._enter("recover",3)
	for i in 3: game.interact_at("guardian_binding")
	dialogue()
	check(game.boss_defeated and game.rewards.chest_available,"Three binding cuts free Mossjaw and unlock its chest")
	await interact(Vector2(6720,620),"fragment")
	check(not game.fragment_collected,"Anchor fragment requires opening Mossjaw chest")
	var before_chest: int = game.rewards.points
	await interact(Vector2(6570,620),"chest")
	game.rewards.open_chest()
	check(game.rewards.points==before_chest+500 and game.player.attack_damage==3,"Orchard Charm grants500points and capped sword upgrade once")
	check(game.player.health==5 and game.player.vitality==100,"Reward restores lives and vitality")
	await place(Vector2(6720,620))
	game.interact_at("fragment")
	await process_frame
	await process_frame
	check(game.memory.visible and game.memory.get_node_or_null("MemoryFrame")!=null,"Anchor memory reuses Chapter 1 botanical popup artwork")
	dialogue()
	check(not game.memory.visible,"Memory Continue closes its illustration and restores play")
	check(game.fragment_collected,"Opened chest unlocks the Anchor memory")
	await interact(Vector2(7310,620),"exit")
	check(game.completed and paused and game.victory_panel.visible,"Sable warning completes the expanded chapter")
	paused = false
	game.queue_free()
	await frames(3)
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game.rewards.points = 4321
	game.player.attack_damage = 2
	game.victory_panel.get_child(1).get_node("ContinueChapter").pressed.emit()
	for i in 8: await process_frame
	game = current_scene
	check(game.chapter_number==2 and game.started,"Real Chapter 1 Continue button enters Chapter 2 directly")
	check(game.rewards.points==4321 and game.player.attack_damage==2,"Real chapter transition retains points and sword charm")
	paused = false
	game.queue_free()
	await frames(3)
	print("CHAPTER02 EXPANSION: ",checks," checks, ",failures," failures")
	quit(0 if failures==0 else 1)
