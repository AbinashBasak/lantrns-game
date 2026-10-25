extends SceneTree

func _initialize() -> void:
	call_deferred("validate")

func validate() -> void:
	var packed := load("res://scenes/chapter_03/review/c3_chest_animation_review.tscn") as PackedScene
	assert(packed != null)
	var review := packed.instantiate()
	root.add_child(review)
	await process_frame
	var tree: AnimationTree = review.get_node("AnimationTree")
	tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	var playback: AnimationNodeStateMachinePlayback = tree.get("parameters/playback")
	assert(playback.get_current_node() == &"Closed")
	assert(review.get_node("Chest/MouthLight").energy == 0.0)
	var sprite: Sprite2D = review.get_node("Chest/Sprite2D")
	assert(sprite.texture.get_size() == Vector2(320, 392))
	assert(sprite.texture.region.position.y == 275)
	review.preview_opening()
	tree.advance(0.01)
	assert(playback.get_current_node() == &"Opening")
	tree.advance(0.32)
	var before_repeat := playback.get_current_play_position()
	review.preview_opening()
	assert(is_equal_approx(before_repeat, playback.get_current_play_position()))
	assert(review.get_node("Chest/MouthLight").energy > 0.0)
	tree.advance(0.6)
	tree.advance(0.01)
	assert(playback.get_current_node() == &"Open")
	assert(sprite.texture.region.position.x == 1462)
	review.reset_review()
	assert(playback.get_current_node() == &"Closed")
	assert(not review.opening_requested)
	assert(sprite.texture.region.position.x == 10)
	assert(review.get_node("Chest/MouthLight").energy == 0.0)
	review.preview_opening()
	tree.advance(0.2)
	review.reset_review()
	assert(playback.get_current_node() == &"Closed")
	assert(review.get_node("Chest/MouthLight").energy == 0.0)
	print("PASS chest review resource load, fixed atlas canvas, Closed→Opening→Open, repeat guard, light pulse, reset after and during opening")
	review.queue_free()
	await process_frame
	quit(0)
