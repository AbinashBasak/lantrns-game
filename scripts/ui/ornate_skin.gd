extends RefCounted
## A small, text-free texture is nine-sliced; corners never scale with content.
const PANEL = preload("res://assets/runtime/shared/ui/UI-004_panel.png")
static func panel_style() -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = PANEL
	for edge in [SIDE_LEFT,SIDE_TOP,SIDE_RIGHT,SIDE_BOTTOM]:
		style.set_texture_margin(edge,32)
		style.set_content_margin(edge,18)
	return style
static func font() -> SystemFont:
	var face := SystemFont.new()
	face.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif"])
	return face
static func icon(parent: Node, path: String, extent: float = 32) -> TextureRect:
	var image := TextureRect.new()
	image.texture = load(path)
	image.custom_minimum_size = Vector2(extent,extent)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	return image
