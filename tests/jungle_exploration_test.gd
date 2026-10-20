extends SceneTree
var game: Node
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool,message: String) -> void:
	if ok: print("PASS: ",message)
	else:
		failures += 1
		push_error(message)
func frames(count: int) -> void:
	for i in count: await physics_frame
func jump_from(at: Vector2, count: int) -> void:
	game.player.position = at
	game.player.velocity = Vector2.ZERO
	await frames(5)
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(count)
	Input.action_release("move_right")
	Input.action_release("jump")
	await frames(30)
func run() -> void:
	game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	while not game.dialogue_lines.is_empty(): game._advance_dialogue()
	await frames(10)
	check(game.jungle_rooms.size() == 3,"Three distinct authored exploration rooms are available")
	game.player.position = Vector2(650,620)
	check(game._nearby_interaction()[0] == "jungle_0","Canopy entrance has an accessible interaction prompt")
	game.interact_at("jungle_0")
	await frames(40)
	check(game.jungle_area == 0 and game.player.is_on_floor(),"Canopy transition places Tavi on solid terrain")
	check(game.camera.limit_left == 10000 and game.camera.limit_right == 13000,"Exploration camera stays within the room")
	check(game.jungle_enemies.size() == 2,"Exploration rooms contain two distinct enemy encounters")
	await jump_from(Vector2(10840,620),52)
	check(game.player.position.x > 11050 and game.player.is_on_floor(),"Canopy lower gap is traversable with an ordinary jump")
	await jump_from(Vector2(10430,620),28)
	check(game.player.position.y < 530 and game.player.is_on_floor(),"Canopy upper route begins with a reachable climb")
	# Complete the upper route using ordinary player input, rather than placing at the reward.
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(40)
	Input.action_release("move_right")
	Input.action_release("jump")
	await frames(30)
	check(game.player.position.y < 440 and game.player.is_on_floor(),"Canopy second climbing step is reachable")
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(52)
	Input.action_release("move_right")
	Input.action_release("jump")
	await frames(30)
	check(game.player.position.y < 360 and game.player.is_on_floor(),"Canopy watchpost approach is reachable")
	Input.action_press("move_right")
	await frames(44)
	Input.action_release("move_right")
	Input.action_press("jump")
	Input.action_press("move_right")
	await frames(52)
	Input.action_release("move_right")
	Input.action_release("jump")
	await frames(30)
	check(game.jungle_discoveries.has(0),"Full canopy climb and upper gap reaches the discovery through movement")
	game.player.position = Vector2(11560,350)
	game.player.velocity = Vector2.ZERO
	await frames(3)
	check(game.jungle_discoveries.has(0),"Climbing the canopy route reveals the hidden map")
	game._leave_jungle(true)
	await frames(3)
	check(game.jungle_area == -1 and game.player.position.x < 1000,"Canopy return shortcut restores the main trail")
	for index in [1,2]:
		game._enter_jungle(index)
		await frames(25)
		check(game.player.is_on_floor(),"Room %d entry is grounded" % index)
		if index == 1:
			await jump_from(Vector2(14640,620),52)
			check(game.player.position.x > 14860 and game.player.is_on_floor(),"Flooded root stepping stones are physically traversable")
		var local := Vector2(1510,365) if index == 1 else Vector2(1560,350)
		game.player.position = local+Vector2(10000+index*4000,0)
		game.player.velocity = Vector2.ZERO
		await frames(3)
		check(game.jungle_discoveries.has(index),"Room %d rewards its elevated exploration route" % index)
		game._respawn()
		await frames(20)
		check(game.jungle_area == index and game.player.position.x < 10300+index*4000,"Exploration death restarts the same room")
		game._leave_jungle(true)
		await frames(3)
	check(game.jungle_discoveries.size() == 3,"Three optional discoveries persist after returning")
	check(not game.bridge_open and not game.boss_defeated,"Side trails preserve rune and boss progression gates")
	game._enter_jungle(0)
	game._enter_jungle(1)
	check(game.jungle_area == 1 and not game.jungle_rooms[0].visible and game.jungle_rooms[1].visible,"Interconnected room transitions hide the prior room")
	game._leave_jungle()
	check(game.camera.limit_right == 9000 and not game.jungle_label.visible,"Main trail camera and HUD restore after exploration")
	game.queue_free()
	for i in 4: await process_frame
	print("JUNGLE FAILURES: ",failures)
	quit(1 if failures else 0)
