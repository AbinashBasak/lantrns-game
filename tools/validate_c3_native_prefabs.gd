extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	for path: String in ["res://scenes/props/chapter_03/c3_ruined_arch_mapped.tscn", "res://scenes/props/chapter_03/c3_wall_relief_mapped.tscn"]:
		var prop: Node2D = load(path).instantiate()
		root.add_child(prop)
		var sprite: Sprite2D = prop.get_node("Artwork")
		assert(sprite.texture is CanvasTexture)
		assert(sprite.texture.normal_texture != null)
		assert(sprite.texture.specular_texture != null)
		assert(is_equal_approx(sprite.offset.y, -sprite.texture.get_height() / 2.0))
		assert(prop.get_node("GroundAnchor").position == Vector2.ZERO)
		assert(prop.find_children("*", "CollisionShape2D").is_empty())
		assert(prop.find_children("*", "PointLight2D").is_empty())
		prop.queue_free()
	var bolt: Node2D = load("res://scenes/vfx/chapter_03/c3_crystal_wisp_bolt.tscn").instantiate()
	root.add_child(bolt)
	assert(bolt.get_node("VisualBody/Artwork") is Sprite2D)
	assert(bolt.get_node("CoreLight") is PointLight2D)
	assert(bolt.get_node("AttackArea") is Area2D)
	assert(not bolt.get_node("AttackArea").monitoring)
	assert(not bolt.get_node("AttackArea").monitorable)
	assert(bolt.get_node("AttackArea/AttackShape").disabled)
	assert(bolt.get_node("AttackArea").collision_mask == 0)
	var source: Vector2 = bolt.get_node("CoreLight").global_position
	bolt.position += Vector2(190, 35)
	assert(bolt.get_node("CoreLight").global_position == source + Vector2(190, 35))
	bolt.queue_free()
	await process_frame
	print("PASS native mapped prop prefab paths/pivots/materials/no inferred collision; separate bolt art/light/disabled attack shape; light follows source")
	quit()
