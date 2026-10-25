extends SceneTree
func _initialize() -> void:
	call_deferred("review")
func review() -> void:
	root.size=Vector2i(1280,720)
	var scene: Node2D = load("res://scenes/chapter_03/review/c3_terrain_seam_review.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var physics: PhysicsDirectSpaceState2D = scene.get_world_2d().direct_space_state
	for column: int in 12:
		var x: float=112.0+64.0*column
		var ray:=PhysicsRayQueryParameters2D.create(Vector2(x,100),Vector2(x,250),1)
		var hit: Dictionary=physics.intersect_ray(ray)
		if hit.is_empty() or absf(hit.position.y-183.0) > .1:
			push_error("Terrain flat collision failed at column %d"%column)
			quit(1)
			return
	for x: float in [79.0,849.0]:
		if not physics.intersect_ray(PhysicsRayQueryParameters2D.create(Vector2(x,100),Vector2(x,250),1)).is_empty():
			push_error("Terrain collision extends past intended edge")
			quit(1)
			return
	for frame: int in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/chapter03/terrain-native-review.png")
	print("C3 terrain: 12 surface rays + 2 edge-clearance rays pass; native screenshot saved")
	scene.queue_free()
	await process_frame
	quit()
