extends SceneTree

func _initialize() -> void:
	call_deferred("validate")

func validate() -> void:
	var effect = load("res://scenes/vfx/chapter_03/c3_shrine_light.tscn").instantiate()
	root.add_child(effect)
	await process_frame
	var animation: AnimationPlayer = effect.get_node("AnimationPlayer")
	animation.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	effect.set_dormant()
	assert(is_zero_approx(effect.get_node("PointLight2D").energy))
	assert(not effect.get_node("Sparks").emitting)
	effect.set_idle()
	assert(effect.get_node("Sparks").emitting)
	assert(effect.get_node("PointLight2D").energy > 0.6)
	effect.activate()
	animation.advance(0.07)
	assert(effect.get_node("ActivationBurst").emitting)
	animation.advance(0.13)
	var before := animation.current_animation_position
	effect.activate()
	assert(is_equal_approx(animation.current_animation_position, before))
	animation.advance(0.43)
	assert(effect.get_node("PointLight2D").energy > 1.0)
	animation.advance(0.9)
	await process_frame
	assert(animation.current_animation == &"idle")
	effect.set_reduced_effects(true)
	assert(not animation.is_playing())
	assert(not effect.get_node("Sparks").emitting)
	assert(not effect.get_node("ActivationBurst").emitting)
	assert(effect.get_node("PointLight2D").energy > 0.6)
	effect.queue_free()
	await process_frame
	print("PASS native shrine clips, dormant/idle/activation, repeat guard, pulse, idle return and reduced effects")
	quit()
