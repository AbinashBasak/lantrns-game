extends RefCounted
## Shared serif text and restrained emerald/gold controls for utility popups.
static func apply(game: Node) -> void:
	var face := SystemFont.new()
	face.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif","Times New Roman"])
	for panel in [game.pause_panel,game.settings_panel]:
		_style_branch(panel,face)
static func _style_branch(node: Node, face: Font) -> void:
	if node is Label or node is Button or node is CheckButton:
		node.add_theme_font_override("font",face)
		node.add_theme_color_override("font_color",Color("f8e4b9"))
	if node is Button and not node is CheckButton:
		node.add_theme_font_size_override("font_size",21)
		for state in ["normal","hover","pressed","disabled","focus"]:
			var box := StyleBoxFlat.new()
			box.bg_color = Color("07352f") if state == "hover" else Color("082522")
			box.border_color = Color("ffdf8a") if state in ["hover","focus"] else Color("b58c43")
			box.set_border_width_all(2 if state == "focus" else 1)
			box.set_corner_radius_all(8)
			box.content_margin_left = 18
			box.content_margin_right = 18
			box.content_margin_top = 7
			box.content_margin_bottom = 7
			node.add_theme_stylebox_override(state,box)
	for child in node.get_children(): _style_branch(child,face)
