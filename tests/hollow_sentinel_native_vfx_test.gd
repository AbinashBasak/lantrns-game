extends SceneTree

class DummyPlayer extends CharacterBody2D:
	var active := true
	var invincible := 0.0
	func take_damage(_amount: int, _direction: float) -> void: pass

func _initialize() -> void:
	call_deferred("validate")

func validate() -> void:
	var boss = load("res://scenes/enemies/hollow_sentinel.tscn").instantiate()
	var target := DummyPlayer.new()
	root.add_child(target)
	root.add_child(boss)
	boss.set_physics_process(false)
	target.position = Vector2(7200, 620)
	boss.position = Vector2(7350, 620)
	boss.activate(target)
	var vfx: AnimationPlayer = boss.get_node("VFXAnimationPlayer")
	vfx.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	boss._begin_attack("charge")
	assert(boss.get_node("NativeVFX/Charge").visible)
	assert(boss.get_node("NativeVFX/Charge/GroundWarning").scale.x == -1.0)
	assert(not boss.get_node("NativeVFX/Anticipation").visible)
	var locked_direction: float = boss.direction
	target.position.x = 7900
	boss._physics_process(0.1)
	assert(boss.direction == locked_direction)
	boss._begin_attack("rootwave")
	var wave: Node2D = boss.get_node("NativeVFX/Rootwave")
	assert(wave.visible and wave.global_position == Vector2(6500, 620))
	assert(is_equal_approx(wave.get_node("SafeGround").global_position.x, boss.safe_center))
	var left: Polygon2D = wave.get_node("DangerLeft")
	var right: Polygon2D = wave.get_node("DangerRight")
	assert(is_equal_approx(left.global_position.x + left.scale.x, boss.safe_center - 130.0))
	assert(is_equal_approx(right.global_position.x, boss.safe_center + 130.0))
	assert(wave.get_node("Roots").get_child_count() == 34)
	for visual: Node2D in wave.get_node("Roots").get_children():
		assert(visual.visible == (absf(visual.global_position.x - boss.safe_center) > 130.0))
	boss._set_state("rootwave", 0.55)
	vfx.advance(0.275)
	assert(wave.get_node("Roots").scale.y > 0.9, "Authored strike clip raises roots")
	boss.berserk = true
	boss._begin_attack("eruption")
	var fixed_centers: Array = boss.eruption_centers.duplicate()
	for i in 2:
		var region: Node2D = boss.get_node("NativeVFX/Eruption%d" % i)
		assert(region.visible and region.global_position == Vector2(fixed_centers[i], 620))
		assert(not region.get_node("Roots").visible)
	target.position.x = 6800
	boss._physics_process(0.1)
	assert(boss.eruption_centers == fixed_centers)
	boss._set_state("eruption", 0.75)
	vfx.advance(0.375)
	assert(boss.get_node("NativeVFX/Eruption0/Roots").visible)
	assert(boss.get_node("NativeVFX/Eruption0/Roots").scale.y > 0.9)
	boss._set_state("rejuvenate", 2.2)
	vfx.advance(1.1)
	assert(boss.get_node("NativeVFX/Rejuvenation").visible)
	assert(boss.get_node("NativeVFX/Rejuvenation/RevivalMotes").emitting)
	assert(boss.get_node("NativeVFX/Rejuvenation/RevivalLight").energy > 0.6)
	boss.reset_encounter()
	for name in ["Charge", "Anticipation", "Rootwave", "Eruption0", "Eruption1", "Rejuvenation"]:
		assert(not boss.get_node("NativeVFX/" + name).visible)
	assert(not boss.get_node("NativeVFX/Rejuvenation/RevivalMotes").emitting)
	assert(not vfx.is_playing())
	boss.queue_free()
	target.queue_free()
	await process_frame
	print("PASS: native Sentinel warning anchors, safe gap, locked eruptions, authored root/revival timelines, light/motes and reset")
	quit()
