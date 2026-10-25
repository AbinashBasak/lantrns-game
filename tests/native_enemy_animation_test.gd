extends SceneTree

func _initialize() -> void:
	call_deferred("validate")

func validate() -> void:
	for scene_name in ["thornling", "hollow_sentinel"]:
		var enemy = load("res://scenes/enemies/" + scene_name + ".tscn").instantiate()
		root.add_child(enemy)
		enemy.set_physics_process(false)
		var tree: AnimationTree = enemy.get_node("AnimationTree")
		var player: AnimationPlayer = enemy.get_node("AnimationPlayer")
		var sprite: AnimatedSprite2D = enemy.get_node("AnimatedSprite2D")
		var states: AnimationNodeStateMachinePlayback = tree.get("parameters/States/playback")
		tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
		assert(tree.active and not sprite.is_playing())
		for family: StringName in sprite.sprite_frames.get_animation_names():
			assert(player.has_animation(family))
			tree.set("parameters/Speed/scale", 1.0)
			states.start(family, true)
			tree.advance(0.0)
			assert(sprite.animation == family and sprite.frame == 0)
			tree.advance(player.get_animation(family).length * 0.6)
			assert(sprite.frame >= 2 and not sprite.is_playing(), "Native tree must own frame stepping")
			states.travel("idle")
			tree.advance(0.01)
			assert(states.get_current_node() == &"idle")
		if scene_name == "thornling":
			enemy._play("telegraph")
			tree.advance(0.0)
			tree.advance(0.6)
			assert(sprite.animation == &"attack" and sprite.frame == 0, "Warning holds first attack pose")
			enemy.take_damage(5, 1.0)
			tree.advance(0.0)
			assert(enemy.dying and not enemy.is_in_group("enemies") and enemy.collision_layer == 0)
			assert(states.get_current_node() == &"defeat")
		else:
			enemy._play("swipe", 0.32)
			tree.advance(0.001)
			tree.advance(0.01)
			tree.advance(0.3)
			assert(sprite.frame >= 4, "Attack animation follows existing combat duration")
			enemy.reset_encounter()
			tree.advance(0.0)
			tree.advance(0.4)
			assert(sprite.animation == &"idle" and sprite.frame == 0)
		var particles: CPUParticles2D = enemy.get_node("ImpactDust")
		assert(particles.one_shot)
		particles.restart()
		assert(particles.emitting)
		enemy.queue_free()
		await process_frame
	print("PASS: both native enemy graphs, all available clips, windup hold, combat tempo, death/reset, CPU dust")
	quit()
