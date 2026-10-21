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
func run() -> void:
	var game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	paused = false
	game.player.active = false
	game.camera.enabled = false
	game.player.position = Vector2(7900,620)
	var lights = game.get_node("WorldLighting")
	lights._process(1.0)
	check(not lights.chest_light.visible and not lights.fragment_light.visible and not lights.portal_light.visible,"Reward sources stay dark until the boss is defeated")
	game.boss_defeated = true
	game.rewards.chest_available = true
	lights._process(1.0)
	check(lights.chest_light.visible and lights.fragment_light.visible and lights.portal_light.visible,"Defeated boss reveals real chest, fragment and portal PointLights")
	check(lights.chest_light.position.is_equal_approx(Vector2(7780,565)),"Chest light is anchored at the lock and lid")
	check(is_equal_approx(lights.fragment_light.position.y,475+sin(lights.clock*2)*6),"Fragment illumination follows the floating fragment")
	var closed_energy: float = lights.chest_light.energy
	game.rewards.chest_opened = true
	game.rewards.animation_time = 0.95
	lights._process(1.0)
	check(lights.chest_light.energy > closed_energy and lights.chest_light.energy < 0.55,"Chest reveal warms nearby stone without a white flash")
	game.rewards.animation_time = 8.0
	lights._process(1.0)
	check(lights.chest_light.energy < closed_energy,"Opened chest settles into a softer warm glow")
	game.fragment_collected = true
	lights._process(0.1)
	check(lights.fragment_light.energy > 0 and lights.fragment_light.energy < 0.3,"Collected fragment light fades instead of popping off")
	lights._process(2.0)
	check(not lights.fragment_light.visible and lights.portal_light.energy > 0.28,"Collected fragment vanishes while the onward portal strengthens")
	game.presentation.reduced_effects = true
	lights._process(3.0)
	var steady: float = lights.chest_light.energy
	game.rewards.animation_time = 0.95
	lights._process(3.0)
	check(is_equal_approx(lights.chest_light.energy,steady),"Reduced effects suppresses chest reveal pulses")
	var time: float = lights.clock
	paused = true
	await process_frame
	await process_frame
	check(is_equal_approx(lights.clock,time),"Reward lighting clock stops while paused")
	paused = false
	game.player.position.x = 1000
	lights._process(0.1)
	check(not lights.chest_light.visible and not lights.portal_light.visible,"Distant reward lights are culled")
	check(not lights.chest_light.shadow_enabled and not lights.portal_light.shadow_enabled,"Reward lights add no extra shadow render passes")
	game.boss_defeated = false
	lights._process(0.1)
	check(lights.chest_light.energy == 0 and lights.portal_light.energy == 0,"Restart removes reward light immediately")
	game.queue_free()
	for i in 6: await process_frame
	print("REWARD LIGHTING: ",checks-failures,"/",checks," checks passed")
	quit(1 if failures else 0)
