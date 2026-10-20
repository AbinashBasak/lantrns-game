extends SceneTree
const Enemy = preload("res://scripts/enemies/jungle_enemy.gd")
var count := 0
var failed := false
class DummyPlayer extends Node2D:
	var active := true
	var invincible := 0.0
	var damage := 0
	var hits := 0
	func take_damage(amount: int, _direction: float) -> void:
		damage += amount
		hits += 1
func check(value: bool, label: String) -> void:
	count += 1
	print(("PASS " if value else "FAIL ") + label)
	if not value: failed = true
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player := DummyPlayer.new()
	world.add_child(player)
	player.add_to_group("player")
	var caster := Enemy.new()
	caster.position = Vector2(100, 620)
	world.add_child(caster)
	caster.set_physics_process(false)
	caster.player = player
	var guard := Enemy.new()
	guard.variant = "brambleguard"
	guard.position = Vector2(700, 620)
	world.add_child(guard)
	guard.set_physics_process(false)
	guard.player = player
	check(caster.attack_damage == 18 and guard.attack_damage == 35, "Enemy variants have distinct vitality damage")
	check(caster.health == 3 and guard.health == 5, "Variant durability differs")
	check(caster.sprite.sprite_frames.get_frame_count("attack") == 6 and guard.sprite.sprite_frames.get_frame_count("attack") == 6, "Both generated six-pose attacks load")
	caster.direction = 1
	caster._release_attack()
	check(caster.projectiles.size() == 1, "Sporeling releases one ranged projectile")
	player.position = Vector2(180, 608)
	caster._update_projectiles(0.2)
	check(player.damage == 18 and caster.projectiles.is_empty(), "Ranged projectile applies eighteen once and disappears")
	guard.direction = -1
	guard._release_attack()
	player.position = Vector2(620, 620)
	guard._physics_process(0.01)
	guard._physics_process(0.01)
	check(player.damage == 53 and player.hits == 2, "Brambleguard heavy attack hits once for thirty-five")
	guard.state = "telegraph"
	guard.state_time = 0.8
	guard.direction = -1
	player.position = Vector2(800, 620)
	guard._physics_process(0.01)
	check(guard.direction == -1 and player.hits == 2, "Wind-up locks facing and cannot damage")
	caster.take_damage(1, -1)
	check(caster.state == "hurt" and caster.health == 2, "Sword hit interrupts caster wind-up")
	guard.take_damage(5, 1)
	check(not guard.is_in_group("enemies") and not guard.visible, "Defeat removes attack targeting and visible body")
	guard.reset_encounter()
	check(guard.health == 5 and guard.visible and guard.is_in_group("enemies") and guard.global_position == guard.spawn_position, "Checkpoint reset restores defeated enemy at original spawn")
	caster.projectiles.append({"position":Vector2.ZERO,"velocity":Vector2.ZERO,"life":2})
	player.active = false
	caster._physics_process(0.01)
	check(caster.projectiles.is_empty() and caster.state == "idle", "Narrative inactivity clears travelling hazards")
	print("New enemy checks: %d" % count)
	world.queue_free()
	await process_frame
	quit(1 if failed else 0)
