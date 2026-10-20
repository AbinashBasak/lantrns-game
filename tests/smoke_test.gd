extends SceneTree
var failures: Array[String] = []
func check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ",message)
	else:
		failures.append(message)
		push_error(message)
func frames(count: int) -> void:
	for i in count: await physics_frame
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	check(paused and scene.menu.visible,"Title pauses gameplay")
	scene._begin()
	await frames(35)
	var p = scene.player
	check(p.is_on_floor(),"Player settles on collision floor")
	var start_x: float = p.position.x
	Input.action_press("move_right")
	await frames(20)
	Input.action_release("move_right")
	check(p.position.x > start_x+50,"Movement advances the player")
	Input.action_press("jump")
	await frames(3)
	check(p.velocity.y < 0,"Jump leaves the floor")
	Input.action_release("jump")
	await frames(50)
	p.position = Vector2(250,620)
	p.velocity = Vector2.ZERO
	await frames(3)
	Input.action_press("move_right")
	Input.action_press("jump")
	await frames(44)
	Input.action_release("move_right")
	Input.action_release("jump")
	check(p.is_on_floor() and p.position.y < 500,"First raised platform is reachable by a normal jump")
	p.position = Vector2(1510,590)
	p.velocity = Vector2.ZERO
	await frames(10)
	check(scene.checkpoint_active,"Lantern checkpoint activates")
	p.health = 1
	p.invincible = 0
	p.take_damage(100)
	await frames(2)
	check(p.health == 5 and p.position.distance_to(scene.checkpoint)<45,"Lethal damage restores health at checkpoint")
	var enemy = scene.get_tree().get_nodes_in_group("enemies")[0]
	p.position = enemy.position+Vector2(-60,0)
	p.facing = 1
	p.velocity = Vector2.ZERO
	p.attack()
	await frames(15)
	check(enemy.health == 1,"Sword damages enemy during active window")
	await frames(20)
	p.position = enemy.position+Vector2(-60,0)
	p.velocity = Vector2.ZERO
	p.attack()
	await frames(16)
	check(not is_instance_valid(enemy),"Two sword hits defeat a thornling")
	p.position = Vector2(720,544)
	p.velocity = Vector2.ZERO
	await frames(2)
	check(scene.collected >= 1,"Nearby light seed is collected")
	scene._toggle_pause()
	var paused_x: float = p.position.x
	Input.action_press("move_right")
	await frames(5)
	Input.action_release("move_right")
	check(p.position.x == paused_x,"Pause freezes physics")
	scene._toggle_pause()
	p.position = Vector2(3320,600)
	p.velocity = Vector2.ZERO
	scene.collected = 0
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	await process_frame
	check(not scene.completed,"Arch rejects insufficient seeds")
	scene.collected = 3
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	check(scene.completed and scene.victory_panel.visible,"Arch completes trail with three seeds")
	paused = false
	scene.queue_free()
	await process_frame
	print("SMOKE TEST: ","PASS" if failures.is_empty() else "FAIL", " (",failures.size()," failures)")
	quit(0 if failures.is_empty() else 1)
