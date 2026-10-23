@tool
extends RefCounted
## Convert authored drawing primitives to ordinary editable scene nodes.

static func image(parent: Node, texture: Texture2D, bounds: Rect2, tint := Color.WHITE, tiled := false) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = texture.resource_path.get_file().get_basename().validate_node_name() if not texture.resource_path.is_empty() else "Art"
	sprite.texture = texture
	sprite.centered = false
	sprite.position = bounds.position
	sprite.modulate = tint
	if tiled:
		sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		sprite.region_enabled = true
		sprite.region_rect = Rect2(Vector2.ZERO, bounds.size)
	else:
		sprite.scale = bounds.size / texture.get_size()
	parent.add_child(sprite, true)
	return sprite

static func region(parent: Node, texture: Texture2D, bounds: Rect2, source: Rect2, tint := Color.WHITE) -> Sprite2D:
	var sprite := image(parent, texture, bounds, tint)
	sprite.region_enabled = true
	sprite.region_rect = source
	sprite.region_filter_clip_enabled = true
	sprite.scale = bounds.size / source.size
	return sprite

static func rect(parent: Node, bounds: Rect2, color: Color) -> Polygon2D:
	var shape := Polygon2D.new()
	shape.name = "Fill"
	shape.position = bounds.position
	shape.polygon = PackedVector2Array([Vector2.ZERO, Vector2(bounds.size.x, 0), bounds.size, Vector2(0, bounds.size.y)])
	shape.color = color
	parent.add_child(shape, true)
	return shape

static func line(parent: Node, points: PackedVector2Array, color: Color, width: float) -> Line2D:
	var stroke := Line2D.new()
	stroke.name = "Detail"
	stroke.points = points
	stroke.default_color = color
	stroke.width = width
	stroke.antialiased = true
	parent.add_child(stroke, true)
	return stroke

static func text(parent: Node, at: Vector2, value: String, color: Color, size: int) -> Label:
	var label := Label.new()
	label.name = "Sign"
	label.text = value
	# Drawing strings use a baseline; Controls use a top-left origin.
	label.position = at - Vector2(0, ThemeDB.fallback_font.get_ascent(size))
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label, true)
	return label
