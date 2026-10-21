extends SceneTree
class DummyPlayer extends CharacterBody2D:
	var active := true
	var invincible := 0.0
	var damage_taken := 0
	func take_damage(amount: int, _direction: float) -> void:
		damage_taken += amount
		invincible = 1.0
var failures := 0
var defeated_count := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if ok: print("PASS: ", message)
	else:
		failures += 1
		push_error(message)
func run() -> void:
	var boss = load("res://scenes/enemies/hollow_sentinel.tscn").instantiate()
	var player := DummyPlayer.new()
	root.add_child(player)
	root.add_child(boss)
	boss.set_physics_process(false)
	boss.defeated.connect(func(): defeated_count += 1)
	player.position = Vector2(7200,620)
	boss.activate(player)
	boss.state = "recover"
	boss.take_damage(24, 1)
	check(boss.state == "collapse" and defeated_count == 0 and boss.activated, "First depletion collapses without clearing the encounter")
	boss.take_damage(24, 1)
	check(boss.health == 0 and boss.state == "collapse", "Collapse rejects sword damage")
	boss._physics_process(1.7)
	check(boss.state == "rejuvenate", "Generated collapse leads into rejuvenation animation")
	boss.take_damage(24, 1)
	check(boss.health == 0, "Rejuvenation rejects sword damage")
	boss._physics_process(2.3)
	check(boss.health == 24 and boss.berserk and boss.revival_used, "Rejuvenation restores full health and unlocks berserk exactly once")
	boss.position = Vector2(7350,620)
	player.position = Vector2(6750,620)
	boss.state = "approach"
	boss.state_time = 0
	boss.attack_count = 0
	boss._physics_process(0.01)
	check(boss.pending_attack == "charge" and boss.state == "windup", "Distant target provokes a telegraphed gap-closing charge")
	var locked_direction: float = boss.direction
	player.position.x = 7800
	boss._physics_process(0.1)
	check(boss.direction == locked_direction, "Charge warning locks facing rather than tracking the dodge")
	boss._begin_attack("eruption")
	check(boss.eruption_centers.size() == 2, "Berserk eruption warns two fixed root locations")
	boss.position = Vector2(7350,620)
	player.position = Vector2(7400,620)
	boss.direction = 1
	boss.state = "swipe"
	boss.state_time = 0.3
	boss.attack_landed = false
	boss._physics_process(0.01)
	check(player.damage_taken == 52, "Berserk swipe deals stronger health damage")
	boss._physics_process(0.01)
	check(player.damage_taken == 52, "One attack cannot repeatedly damage the player")
	boss.take_damage(24, 1)
	check(boss.state == "defeated" and defeated_count == 1 and not boss.is_in_group("enemies"), "Second depletion alone unlocks the final defeat reward gate")
	boss.reset_encounter()
	check(not boss.berserk and not boss.revival_used and boss.health == 24 and boss.state == "dormant", "Retry resets both boss lives and berserk state")
	boss.queue_free()
	player.queue_free()
	await process_frame
	quit(0 if failures == 0 else 1)
