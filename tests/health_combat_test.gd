extends SceneTree
var failures := 0
var checks := 0
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
	print(("PASS " if value else "FAIL ") + label)
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	for action in ["jump", "move_left", "move_right", "attack"]:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	var player = load("res://scenes/player/player.tscn").instantiate()
	root.add_child(player)
	player.set_physics_process(false)
	check(player.health == 5 and player.vitality == 100, "Five lives each begin with full health")
	player.take_damage(25)
	check(player.health == 5 and player.vitality == 75, "Rootling hit removes health, preserving life")
	player.take_damage(25)
	check(player.vitality == 75, "Recovery immunity prevents repeated damage")
	player.invincible = 0
	player.take_damage(40)
	check(player.health == 5 and player.vitality == 35, "Stronger swipe removes forty health")
	player.invincible = 0
	player.take_damage(55)
	check(player.health == 4 and player.vitality == 100, "Empty health costs exactly one life and refills bar")
	player.invincible = 0
	player.take_damage(-25)
	check(player.vitality == 100, "Invalid negative damage cannot heal or cost lives")
	player.health = 1
	player.vitality = 20
	var deaths := [0]
	player.died.connect(func(): deaths[0] += 1)
	player.take_damage(55)
	check(player.health == 0 and player.vitality == 0 and deaths[0] == 1, "Final empty health bar emits death once")
	player.invincible = 0
	player.take_damage(55)
	check(deaths[0] == 1, "Already defeated player cannot emit repeated death")
	player.reset_at(Vector2(100,620))
	check(player.health == 5 and player.vitality == 100 and player.invincible > 0, "Checkpoint reset restores lives and health safely")
	player.attack()
	check(player.attack_time == 0.44 and player.visual.frame == 0, "Sword begins at generated anticipation frame")
	player.attack_time = 0.15
	player.attack()
	check(player.queued_attack, "Recovery input buffers next sword swing")
	player.attack_time = 0
	player.attack_cooldown = 0
	player._physics_process(0.001)
	check(not player.queued_attack and player.combo_index == 1 and player.attack_time > 0.46, "Buffered follow-up uses second combo tempo")
	player.reset_at(Vector2.ZERO)
	check(not player.queued_attack and player.attack_time == 0 and player.combo_window == 0, "Respawn clears attack combo state")
	player.queue_free()
	await process_frame
	print("Health combat: %d checks; %d failures" % [checks,failures])
	quit(1 if failures else 0)
