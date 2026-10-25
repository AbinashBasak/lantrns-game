extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var scene = load("res://scenes/chapter_03/review/c3_chest_animation_review.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.preview_opening()
	scene.get_node("AnimationTree").advance(0.0)
	for i in 8: scene.get_node("AnimationTree").advance(0.05)
	print(scene.playback.get_current_node(), " energy ", scene.get_node("Chest/MouthLight").energy, " emit ",scene.get_node("Chest/OpeningGoldParticles").emitting)
	var particles = scene.get_node("Chest/OpeningGoldParticles")
	assert(particles.emitting, "Opening animation must emit native gold particles")
	assert(scene.get_node("Chest/MouthLight").energy > 0.0)
	scene.reset_review()
	assert(not particles.emitting, "Closed animation must stop native gold particles")
	assert(scene.get_node("Chest/BaseOccluder").occluder.polygon.size() == 4)
	for path in ["lighting/c3_lantern_light", "vfx/c3_lantern_sparks", "vfx/c3_crystal_motes", "vfx/c3_waterfall_mist"]:
		var rig = load("res://scenes/chapter_03/%s.tscn" % path).instantiate()
		root.add_child(rig)
		assert(rig.get_child_count() > 0)
		rig.queue_free()
	print("CHAPTER 3 NATIVE EFFECTS PASS: native emission keys, light keys, occluder, reusable scene resources")
	scene.queue_free()
	await process_frame
	quit()
