extends SceneTree
## Exercise real combat callbacks, sword frames, aimed shots, and chapter travel.
const Enemy = preload("res://scripts/enemies/orchard_enemy.gd")
var game: Node
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	checks += 1
	print(("PASS: " if ok else "FAIL: ") + label)
	if not ok: failures += 1

func frames(count: int) -> void:
	for i in count: await physics_frame

func dialogue() -> void:
	for i in 60:
		if game.dialogue_lines.is_empty(): return
		game._advance_dialogue()

func freeze_foes() -> void:
	for foe in get_nodes_in_group("enemies"):
		foe.set_physics_process(false)
		if foe.get("active") != null: foe.active = false

func foe_at(variant: int, at: Vector2) -> Node2D:
	var foe := CharacterBody2D.new()
	foe.set_script(Enemy)
	foe.variant = variant
	foe.position = at
	root.add_child(foe)
	foe.set_physics_process(false)
	foe.player = game.player
	return foe

func shot_at(owner: Node2D, at: Vector2) -> Dictionary:
	var art := Sprite2D.new()
	owner.add_child(art)
	art.global_position = at
	return {"position": at, "velocity": Vector2.ZERO, "life": 2.0, "sprite": art}

func run() -> void:
	remove_meta("from_chapter01")
	game = load("res://scenes/levels/chapter02_briarwake.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	dialogue()
	game.set_process(false)
	freeze_foes()
	game.player.set_physics_process(false)
	game.player.invincible = 0
	await test_travel_health()
	await test_enemy_attacks()
	await test_projectile_reset()
	await test_sword_body_hits()
	test_boss_volley()
	await test_boss_moves()
	await test_camera_feedback()
	await test_defeat()
	paused = false
	game.queue_free()
	await frames(2)
	print("CHAPTER02 COMBAT FIX: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)

func test_travel_health() -> void:
	game.player.health = 2
	game.player.vitality = 30
	for index in 4:
		game._enter_jungle(index)
		check(game.jungle_area == index and game.player.health == 2 and game.player.vitality == 30,
			"Entering expedition %d retains lives and vitality" % (index + 1))
		game.jungle_rooms[index].completed = true
		game._leave_jungle(index)
		check(game.jungle_area == -1 and game.player.health == 2 and game.player.vitality == 30,
			"Returning from expedition %d retains lives and vitality" % (index + 1))
	game.player.position = Vector2(4800, 590)
	game._process(0.016)
	check(game.checkpoint_active and game.player.health == 2 and game.player.vitality == 30,
		"Passing the orchard checkpoint does not silently heal")
	game._respawn()
	freeze_foes()
	check(game.player.health == 5 and game.player.vitality == 100, "Actual death retry still restores health")
	await frames(2)

func test_enemy_attacks() -> void:
	for variant in 3:
		var foe = foe_at(variant, Vector2(-20000, 620))
		game.player.position = Vector2(-19800 if variant == 2 else -19930, 620)
		game.player.invincible = 0
		game.player.health = 5
		game.player.vitality = 100
		foe._enter("telegraph", 0.7)
		var windup_texture = foe.sprite.sprite_frames.get_frame_texture(foe.sprite.animation, foe.sprite.frame)
		foe._enter("attack", 0.85 if variant == 2 else 0.5)
		var strike_texture = foe.sprite.sprite_frames.get_frame_texture(foe.sprite.animation, foe.sprite.frame)
		check(windup_texture != strike_texture and foe.sprite.frame == 1,
			"Species %d reaches a distinct illustrated strike pose" % variant)
		if variant == 2:
			foe.set_physics_process(true)
			await frames(48)
			foe.set_physics_process(false)
			check(game.player.vitality < 100 and foe.position.x > -19870,
				"Moth dive reaches and strikes a target 200 pixels from its perch")
		elif variant == 0:
			foe._physics_process(0.016)
			check(game.player.vitality < 100, "Thornrunner damaging lunge is active")
		foe._enter("recover", 1.3)
		check(foe.sprite.frame == 2, "Species %d displays the recovery artwork" % variant)
		foe.queue_free()
		await frames(1)
	# Stationary targets in both directions and on different platform heights.
	for offset in [Vector2(260, 0), Vector2(-260, 0), Vector2(240, -100), Vector2(-240, 80)]:
		var foe = foe_at(1, Vector2(-20000, 620))
		game.player.position = foe.position + offset
		game.player.invincible = 0
		game.player.vitality = 100
		foe._enter("telegraph", 0.7)
		var target: Vector2 = foe.locked_target
		foe._enter("attack", 0.48)
		for i in 80: foe._update_projectiles(1.0 / 120.0)
		check(game.player.vitality == 74, "Spitter trajectory hits the locked body target at %s" % offset)
		check(foe.locked_target == target, "Spitter shot preserves its telegraphed target")
		foe.queue_free()
		await frames(1)
	var spitter = foe_at(1, Vector2(-20000, 620))
	game.player.position = Vector2(-19740, 620)
	game.player.invincible = 0
	game.player.vitality = 100
	spitter._enter("telegraph", 0.7)
	var advertised_target: Vector2 = spitter.locked_target
	spitter._enter("attack", 0.48)
	game.player.position = Vector2(-19740, 400)
	for i in 110: spitter._update_projectiles(1.0 / 120.0)
	check(game.player.vitality == 100 and spitter.locked_target == advertised_target,
		"Jumping clear of the advertised seed path evades a shot without homing")
	spitter.queue_free()
	await frames(1)

func test_projectile_reset() -> void:
	game.player.position = Vector2(5500, 620)
	game.player.health = 1
	game.player.vitality = 1
	game.player.invincible = 0
	game.boss.player = game.player
	game.boss.activate()
	game.boss._enter("volley", 1.2)
	var shots: Array[Sprite2D] = []
	for i in 3:
		var shot := shot_at(game.boss, game.player.position + Vector2(0, -30))
		shots.append(shot.sprite)
		game.boss.projectiles.append(shot)
	game.boss._update_projectiles(0.016)
	check(game.player.health == 5 and game.boss.state == "dormant" and game.boss.projectiles.is_empty(),
		"Fatal boss seed safely resets the encounter inside a three-projectile update")
	check(shots.all(func(art): return art.is_queued_for_deletion()), "All detached boss seeds are disposed after reset")
	game.boss._update_projectiles(0.016)
	check(game.boss.projectiles.is_empty(), "Empty projectile update remains safe")
	freeze_foes()
	# This enemy's death callback synchronously resets the chapter and clears it.
	var foe = game.orchard_enemies[0]
	foe.active = true
	foe.player = game.player
	foe.attack_landed = false
	game.player.health = 1
	game.player.vitality = 1
	game.player.invincible = 0
	shots.clear()
	for i in 3:
		var shot := shot_at(foe, game.player.position + Vector2(0, -30))
		shots.append(shot.sprite)
		foe.projectiles.append(shot)
	foe._update_projectiles(0.016)
	check(game.player.health == 5 and foe.is_queued_for_deletion(),
		"Fatal enemy projectile can replace its owner during the same update")
	check(shots.all(func(art): return art.is_queued_for_deletion()), "Detached enemy projectile batch is cleaned on reentrant death")
	freeze_foes()
	await frames(2)

func test_sword_body_hits() -> void:
	game.boss.reset_encounter()
	game.boss.player = game.player
	game.boss.activate()
	game.boss.position = Vector2(6200, 620)
	game.player.gravity = 0
	game.player.collision_mask = 0
	game.player.active = true
	game.player.invincible = 100
	game.player.set_physics_process(true)
	for offset in [Vector2(-190, 0), Vector2(190, 0), Vector2(-175, -155), Vector2(175, -155)]:
		game.player.position = game.boss.position + offset
		game.player.velocity = Vector2.ZERO
		game.player.facing = 1.0 if offset.x < 0 else -1.0
		game.player.attack_time = 0
		game.player.attack_cooldown = 0
		game.player.queued_attack = false
		game.boss.flash = 0
		var before: int = game.boss.health
		game.player.attack()
		await frames(24)
		check(game.boss.health == before - game.player.attack_damage,
			"Real sword swing hits visible boss body at %s exactly once" % offset)
	game.player.set_physics_process(false)
	game.player.gravity = 1600
	game.player.collision_mask = 1

func test_boss_moves() -> void:
	game.boss.attack_index = 0
	game.player.position = Vector2(5500, 620)
	game.boss.position = Vector2(6200, 620)
	var patterns: Dictionary = {}
	for i in 7:
		game.boss._choose_attack()
		patterns[game.boss.state] = true
	check(patterns.size() == 7 and patterns.has("leap_warning") and patterns.has("rush_warning"),
		"Boss exposes seven distinct advertised attack moves")
	game.boss.attack_index = 3
	game.boss._choose_attack()
	var locked: Vector2 = game.boss.locked_target
	var facing: float = game.boss.direction
	game.player.position = Vector2(6600, 480)
	game.boss._physics_process(0.1)
	check(game.boss.locked_target == locked and game.boss.direction == facing, "Leap destination and facing stay locked during warning")
	game.boss._enter("leap", 1.0)
	check(game.boss.velocity.x < 0 and game.boss.velocity.y < 0, "Leap launches toward the advertised destination")
	game.boss.set_physics_process(true)
	for i in 90:
		await physics_frame
		if game.boss.state == "slam_impact": break
	game.boss.set_physics_process(false)
	check(game.boss.state == "slam_impact" and absf(game.boss.position.x - locked.x) < 60,
		"Actual leap lands at its advertised ground marker (state %s, at %.1f, marker %.1f)" % [game.boss.state, game.boss.position.x, locked.x])

func test_boss_volley() -> void:
	for side in [-1.0, 1.0]:
		game.boss._clear_hazards()
		game.boss.position = Vector2(6000, 620)
		game.player.position = Vector2(6000 + side * 420, 620)
		game.player.vitality = 100
		game.player.invincible = 0
		game.boss.direction = side
		game.boss.locked_target = game.player.position + Vector2(0, -30)
		game.boss._enter("volley", 1.2)
		game.boss._spawn_volley()
		for i in 150: game.boss._update_projectiles(1.0 / 120.0)
		check(game.player.vitality == 80, "Mossjaw's aimed seed volley reaches a stationary player on side %s" % side)

func test_camera_feedback() -> void:
	var original_reduced: bool = game.presentation.reduced_effects
	game.presentation.reduced_effects = false
	game.player.active = true
	game.boss.combat_feedback.emit("leap_impact", 1.0)
	await process_frame
	await process_frame
	check(game.camera.offset.length() > 0 and absf(game.camera.offset.x) <= 7 and absf(game.camera.offset.y) <= 4.5,
		"Real boss impact produces bounded camera shake")
	await frames(30)
	check(game.camera.offset == Vector2.ZERO, "Impact shake fully settles without leaving a camera offset")
	game.boss.combat_feedback.emit("leap_impact", 1.0)
	game.presentation.reduced_effects = true
	await process_frame
	await process_frame
	check(game.camera.offset == Vector2.ZERO, "Reduced effects clears active camera shake")
	game.presentation.reduced_effects = false
	game.boss.combat_feedback.emit("leap_impact", 1.0)
	paused = true
	await process_frame
	await process_frame
	check(game.camera.offset == Vector2.ZERO, "Opening pause clears active camera shake")
	paused = false
	game.boss.combat_feedback.emit("leap_impact", 1.0)
	game.player.active = false
	await process_frame
	await process_frame
	check(game.camera.offset == Vector2.ZERO, "Narrative freeze clears active camera shake")
	game.player.active = true
	game.presentation.reduced_effects = original_reduced

func test_defeat() -> void:
	game.boss._enter("volley", 1.2)
	game.boss.projectiles.append(shot_at(game.boss, Vector2(6000, 500)))
	game.boss._enter("sweep", 1.15)
	var defeats := [0]
	game.boss.defeated.connect(func(): defeats[0] += 1)
	game.boss.flash = 0
	game.boss.take_damage(999, -1)
	check(game.boss.health == 0 and game.boss.state == "defeated" and game.boss_defeated,
		"Zero boss health completes the encounter immediately")
	check(game.boss.projectiles.is_empty() and game.boss.root_sprites.is_empty() and not game.boss.is_in_group("enemies"),
		"Defeat clears roots, seeds and sword targets")
	check(game.rewards.chest_available, "Normal combat victory unlocks Mossjaw's reward chest")
	game.boss.take_damage(999, 1)
	game.boss._defeat()
	check(defeats[0] == 1, "Boss defeat emits once even after repeated damage")
	dialogue()
	game.player.health = 2
	game.player.vitality = 30
	game.rewards.open_chest()
	check(game.player.health == 5 and game.player.vitality == 100, "Explicit Orchard Charm reward still restores health")
