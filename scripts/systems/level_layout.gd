extends Node2D
## Platforms are editable StaticBody2D nodes in underroot_01.tscn.
func get_platforms() -> Array[Rect2]:
	var result: Array[Rect2] = []
	for child in get_children():
		if child is StaticBody2D:
			var collision: CollisionShape2D = child.get_node("CollisionShape2D")
			var size: Vector2 = collision.shape.size
			result.append(Rect2(child.position-size/2,size))
	return result
