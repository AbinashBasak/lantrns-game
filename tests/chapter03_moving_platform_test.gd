extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var lift = load("res://scenes/interactables/chapter_03/c3_moving_platform.tscn").instantiate()
	lift.position = Vector2(300, 400)
	root.add_child(lift)
	var body: AnimatableBody2D = lift.get_node("Body")
	var animator: AnimationPlayer = body.get_node("AnimationPlayer")
	animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	body.sync_to_physics = false
	body.set_active(true)
	animator.advance(0.3)
	assert(body.position == Vector2.ZERO, "Lower endpoint must have dwell time")
	animator.advance(2.3)
	assert(body.position.is_equal_approx(Vector2(0, -192)))
	animator.advance(0.3)
	assert(body.position.is_equal_approx(Vector2(0, -192)), "Upper endpoint must hold")
	animator.advance(2.3)
	assert(body.position.is_equal_approx(Vector2.ZERO))
	assert(body.global_position.is_equal_approx(Vector2(300, 400)), "Root placement must not be overwritten")
	body.reset_to_lower_stop()
	assert(not animator.is_playing())
	body.sync_to_physics = true
	animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	var rider := CharacterBody2D.new()
	rider.position = Vector2(300, 390)
	rider.collision_layer = 2
	rider.collision_mask = 1
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(16, 20)
	collider.shape = shape
	rider.add_child(collider)
	root.add_child(rider)
	for i in 12:
		await physics_frame
		rider.velocity = Vector2(0, 80)
		rider.move_and_slide()
	assert(rider.is_on_floor(), "Body must provide a stable physical landing")
	body.set_active(true)
	for i in 100:
		await physics_frame
		rider.velocity = Vector2(0, 80)
		rider.move_and_slide()
	assert(rider.position.y < 370, "Native moving body must carry its rider upward")
	assert(absf(rider.position.y + 10 - body.global_position.y) < 4, "Rider must stay on the moving top")
	lift.queue_free()
	rider.queue_free()
	await process_frame
	print("PASS: native lift endpoints, dwell, root placement, pause/reset and actual rider carry")
	quit()
