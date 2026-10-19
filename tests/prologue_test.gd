extends SceneTree
var failures: Array[String] = []
func check(condition: bool, message: String) -> void:
	if condition: print("PASS: ", message)
	else:
		failures.append(message)
		push_error(message)
func frames(count: int) -> void:
	for i in count: await physics_frame
func finish_dialogue(scene: Node) -> void:
	for i in 20:
		if scene.dialogue_lines.is_empty(): return
		scene._advance_dialogue()
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var scene = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	check(paused and scene.menu.visible, "Prologue title pauses gameplay")
	check(scene.mote.sprite.sprite_frames.has_animation("follow"), "Generated Mote follow animation is loaded")
	check(scene.presentation.music.stream != null and scene.presentation.music.stream.loop, "Generated village music is loaded as a loop")
	check(scene.village.textures["distant_background"] != null, "Generated village layer is loaded")
	scene._begin()
	await frames(35)
	var p = scene.player
	check(p.is_on_floor(), "Village spawn has safe collision floor")
	p.attack()
	check(p.attack_time == 0, "Sword locked before rescue")
	scene.interact_at("exit")
	check(not scene.dialogue_lines.is_empty(), "Exit explains unfinished village objective")
	finish_dialogue(scene)
	scene.interact_at("hearth")
	check(not p.active, "Dialogue freezes player movement and attacks")
	scene._toggle_pause()
	scene._advance_dialogue()
	check(scene.dialogue_index == 0, "Pause freezes dialogue advancement")
	scene._toggle_pause()
	finish_dialogue(scene)
	check(scene.beat == scene.Beat.CART, "Hearth inspection introduces cart errand")
	scene.interact_at("cart")
	finish_dialogue(scene)
	check(scene.village.cart_moved and scene.beat == scene.Beat.RETURN, "Cart moves and asks player to return")
	scene.interact_at("hearth")
	check(scene.beat == scene.Beat.FAILURE and not p.active, "Returning triggers controlled Hearthlight event")
	var timer: float = scene.failure_time
	scene._toggle_pause()
	await frames(5)
	check(scene.failure_time == timer, "Pause freezes cinematic timer")
	check(not scene.presentation.can_process(), "Pause freezes audio and presentation processing")
	scene._toggle_pause()
	scene._finish_failure()
	finish_dialogue(scene)
	check(scene.village.hearth_failed and p.active, "Failure leaves darkened village and restores control")
	scene.interact_at("hearth")
	finish_dialogue(scene)
	check(scene.failure_count == 1, "Hearthlight failure cannot retrigger")
	scene.interact_at("beam")
	finish_dialogue(scene)
	check(scene.rescued and scene.village.beam_moved and p.attack_enabled, "Beam rescue unlocks companion and practice blade")
	check(get_nodes_in_group("enemies").size() == 1, "Tutorial introduces one enemy at a time")
	var first = get_nodes_in_group("enemies")[0]
	check(first.sprite.sprite_frames.has_animation("attack"), "Generated Rootling combat animation is loaded")
	scene.presentation.reduced_effects = true
	check(not first._effects_enabled(), "Reduced-effects preference suppresses enemy particle bursts")
	var effect_count: int = scene.presentation.get_child_count()
	scene.presentation.cue("jump", p.position)
	check(scene.presentation.get_child_count() == effect_count, "Reduced-effects preference suppresses player particle bursts")
	scene.presentation.reduced_effects = false
	p.position = first.position + Vector2(-50, 0)
	p.velocity = Vector2.ZERO
	p.invincible = 0
	await frames(8)
	check(first.state == "telegraph" and p.health == 5, "Thornling warns visibly before dealing damage")
	await frames(25)
	check(p.health == 5, "Telegraph gives player time to react")
	await frames(30)
	check(p.health == 4, "Only active attack deals damage")
	p.active = false
	p.invincible = 0
	var safe_health: int = p.health
	await frames(70)
	check(p.health == safe_health, "Inactive dialogue player is safe from enemies")
	p.active = true
	p.reset_at(Vector2(2650, 590))
	first.take_damage(2, 1)
	await frames(2)
	check(scene.defeated_count == 1 and get_nodes_in_group("enemies").size() == 1, "Second Thornling follows first defeat")
	p.invincible = 0
	p.take_damage(5)
	await frames(2)
	check(p.health == 5 and scene.defeated_count == 0 and get_nodes_in_group("enemies").size() == 1, "Combat defeat resets encounter at local checkpoint")
	get_nodes_in_group("enemies")[0].take_damage(2, 1)
	await frames(2)
	get_nodes_in_group("enemies")[0].take_damage(2, 1)
	await frames(2)
	finish_dialogue(scene)
	scene._toggle_pause()
	scene.pause_panel.hide()
	scene.settings_panel.show()
	Input.action_press("pause")
	await process_frame
	Input.action_release("pause")
	await process_frame
	check(paused and not scene.settings_panel.visible and scene.pause_panel.visible, "Escape leaves settings without resuming gameplay")
	scene._toggle_pause()
	check(scene.beat == scene.Beat.RUSK, "Both defeats unlock Rusk send-off")
	scene.interact_at("rusk")
	finish_dialogue(scene)
	check(scene.beat == scene.Beat.EXIT, "Rusk gives journey objective")
	scene.interact_at("exit")
	await frames(3)
	check(current_scene != scene and current_scene.started and not paused, "Village exit starts Forgotten Trail without scene reset or second title")
	print("PROLOGUE TEST: ", "PASS" if failures.is_empty() else "FAIL", " (", failures.size(), " failures)")
	quit(0 if failures.is_empty() else 1)
