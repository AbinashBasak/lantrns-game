extends SceneTree

func _initialize() -> void:
	call_deferred("validate")

func validate() -> void:
	var actor := load("res://scenes/player/player.tscn").instantiate() as CharacterBody2D
	root.add_child(actor)
	actor.set_physics_process(false)
	var tree: AnimationTree = actor.get_node("AnimationTree")
	var animator: AnimationPlayer = actor.get_node("AnimationPlayer")
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	assert(tree.active and not sprite.is_playing())
	var playback: AnimationNodeStateMachinePlayback = tree.get("parameters/playback")
	for family: StringName in sprite.sprite_frames.get_animation_names():
		assert(animator.has_animation(family))
		playback.start(family, true)
		tree.advance(0.0)
		assert(sprite.animation == family and sprite.frame == 0)
		var clip := animator.get_animation(family)
		tree.advance(clip.length * 0.45)
		assert(sprite.frame >= 3, "Tree must advance frames without AnimatedSprite2D.play")
		assert(not sprite.is_playing())
		playback.travel(&"idle")
		tree.advance(0.01)
		assert(playback.get_current_node() == &"idle")
	actor.attack()
	tree.advance(0.13)
	actor.attack_time = actor.attack_duration - 0.13
	actor._update_animation()
	assert(sprite.animation == &"attack_1" and sprite.frame >= 2)
	assert(actor.sword_light.energy > 0.0)
	actor.facing = -1.0
	actor._update_animation()
	assert(actor.sword_light.position.x < 0.0)
	actor.attack_time = 0.1
	tree.advance(0.2)
	actor._update_animation()
	assert(actor.sword_light.energy == 0.0)
	actor.combo_index = 1
	actor.attack_duration = 0.48
	playback.start(&"attack_combo", true)
	tree.advance(0.0)
	tree.advance(0.4)
	assert(sprite.frame == 6, "Follow-up keeps the existing 0.48-second tempo")
	for emitter_name: String in ["JumpDust", "LandingDust", "SwordHit"]:
		var emitter := actor.get_node("Effects/" + emitter_name) as CPUParticles2D
		assert(emitter.one_shot and not emitter.local_coords)
		emitter.restart()
		assert(emitter.emitting)
	actor.reset_at(Vector2.ZERO)
	assert(actor.sword_light.energy == 0.0)
	actor.queue_free()
	await process_frame
	print("PASS: runtime player native clips, state travel, combo timing, strike light and particle emitters")
	quit()
