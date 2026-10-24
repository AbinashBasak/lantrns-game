extends Node
## Runtime skin assembled from generated UI exports. Archive sources are unchanged.
const ROOT := "res://assets/runtime/prologue/ui/"
var game: Node
var hearts: Array[TextureRect] = []
var health_row: HBoxContainer
var vitality_bar: ProgressBar
var vitality_frame: TextureRect
var vitality_label: Label
var title_background: TextureRect

static func apply(target: Node) -> void:
	var skin := load("res://scripts/ui/prologue_skin.gd").new() as Node
	skin.game = target
	skin.process_mode = Node.PROCESS_MODE_ALWAYS
	target.add_child(skin)
	skin._install()

func _texture(name: String) -> Texture2D:
	return load(ROOT + name + ".png") as Texture2D

func _style(name: String, margin: float = 24.0) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = _texture(name)
	style.texture_margin_left = margin
	style.texture_margin_right = margin
	style.texture_margin_top = margin
	style.texture_margin_bottom = margin
	style.content_margin_left = 36
	style.content_margin_right = 36
	style.content_margin_top = 28
	style.content_margin_bottom = 28
	return style

func _buttons(node: Node) -> void:
	if node is Button and not node is CheckButton:
		for state in ["normal", "hover", "pressed", "disabled"]:
			# Keep ornamental artwork on the surrounding panel; button labels need a clear surface.
			var box := StyleBoxFlat.new()
			box.bg_color = {"normal": Color("18352f"), "hover": Color("294a3c"), "pressed": Color("102820"), "disabled": Color("26332e")}[state]
			box.border_color = Color("c4a265") if state != "disabled" else Color("676c55")
			box.set_border_width_all(1)
			box.set_corner_radius_all(8)
			box.content_margin_left = 24
			box.content_margin_right = 24
			box.content_margin_top = 12
			box.content_margin_bottom = 12
			node.add_theme_stylebox_override(state, box)
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color(0, 0, 0, 0)
		focus.border_color = Color("ffdb87")
		focus.set_border_width_all(2)
		focus.set_corner_radius_all(10)
		node.add_theme_stylebox_override("focus", focus)
		node.add_theme_color_override("font_color", Color("fff0ce"))
		node.add_theme_color_override("font_hover_color", Color.WHITE)
		node.add_theme_color_override("font_pressed_color", Color("ffe1a0"))
		node.custom_minimum_size.y = 56
	for child in node.get_children():
		_buttons(child)

func _picture(parent: Node, name: String, bounds: Rect2) -> TextureRect:
	var image := TextureRect.new()
	image.texture = _texture(name)
	image.position = bounds.position
	image.size = bounds.size
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	return image

func _install() -> void:
	if not game.has_node("WorldLighting") and not "chapter_number" in game:
		var lighting := Node2D.new()
		lighting.name = "WorldLighting"
		lighting.set_script(load("res://scripts/presentation/world_lighting.gd"))
		lighting.game = game
		game.add_child(lighting)
	var root: Control = game.objective.get_parent()
	_buttons(root)
	for child in root.get_children():
		if child is Button:
			child.text = ""
			child.icon = _texture("pause_icon")
			child.expand_icon = true
			child.add_theme_constant_override("icon_max_width", 52)
			child.position = Vector2(1198, 18)
			child.custom_minimum_size = Vector2(56, 56)
			child.size = Vector2(56, 56)
			child.tooltip_text = "Pause / Resume (Esc)"
			for state in ["normal", "hover", "pressed", "disabled"]:
				child.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	for panel in [game.menu, game.pause_panel, game.victory_panel, game.settings_panel]:
		panel.add_theme_stylebox_override("panel", _style("panel", 64))
	var menu_style := _style("panel", 64)
	menu_style.content_margin_top = 50
	menu_style.content_margin_bottom = 50
	game.menu.add_theme_stylebox_override("panel", menu_style)
	game.menu.position = Vector2(70, 28)
	game.menu.size = Vector2(610, 620)
	var column: VBoxContainer = game.menu.get_child(0)
	column.add_theme_constant_override("separation", 15)
	var title: Label = column.get_child(1)
	title.text = ""
	title.custom_minimum_size = Vector2(0, 240)
	_picture(title, "logo", Rect2(0, 0, 538, 240))
	title_background = _picture(root, "title_background", Rect2(0, 0, 1280, 720))
	title_background.stretch_mode = TextureRect.STRETCH_SCALE
	root.move_child(title_background, 0)
	if not "chapter_number" in game:
		load("res://scripts/ui/exact_title_menu.gd").apply(game,title_background)
	game.pause_panel.position = Vector2(410, 180)
	game.pause_panel.size = Vector2(460, 400)
	game.dialogue_box.position = Vector2(150, 285)
	game.dialogue_box.size = Vector2(980, 300)
	var parchment := _style("dialogue", 65)
	parchment.content_margin_left = 95
	parchment.content_margin_right = 95
	parchment.content_margin_top = 80
	parchment.content_margin_bottom = 65
	game.dialogue_box.add_theme_stylebox_override("panel", parchment)
	game.dialogue_label.custom_minimum_size = Vector2(780, 80)
	game.dialogue_label.add_theme_color_override("font_color", Color("243c37"))
	game.dialogue_label.add_theme_font_size_override("font_size", 21)
	game.dialogue_box.get_child(0).add_theme_constant_override("separation", 6)
	if "settings_panel" in game and is_instance_valid(game.settings_panel):
		game.settings_panel.position = Vector2(350, 90)
		game.settings_panel.size = Vector2(580, 550)
		var settings_style := _style("panel", 64)
		settings_style.content_margin_top = 50
		settings_style.content_margin_bottom = 50
		settings_style.content_margin_left = 55
		settings_style.content_margin_right = 55
		game.settings_panel.add_theme_stylebox_override("panel", settings_style)
	game.hud.hide()
	health_row = HBoxContainer.new()
	health_row.position = Vector2(30, 17)
	health_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_row.add_theme_constant_override("separation", 4)
	root.add_child(health_row)
	for i in 5:
		var heart := TextureRect.new()
		heart.custom_minimum_size = Vector2(40, 40)
		heart.texture = _texture("health_full")
		heart.mouse_filter = Control.MOUSE_FILTER_IGNORE
		health_row.add_child(heart)
		hearts.append(heart)
	vitality_bar = ProgressBar.new()
	vitality_bar.name = "VitalityBar"
	# Reuse the generated vine-and-gold UI-008 artwork at HUD scale.
	# Its inner opening remains clear so the fill is a true health proportion.
	vitality_bar.position = Vector2(280, 48)
	vitality_bar.size = Vector2(220, 16)
	vitality_bar.max_value = 100
	vitality_bar.show_percentage = false
	vitality_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vitality_bar.tooltip_text = "Health: an empty bar costs one life"
	for part in ["background", "fill"]:
		var skin := StyleBoxTexture.new()
		skin.texture = load("res://assets/runtime/chapter01/story/boss_%s.png" % ("track" if part == "background" else "fill"))
		skin.texture_margin_left = 9
		skin.texture_margin_right = 9
		vitality_bar.add_theme_stylebox_override(part, skin)
	root.add_child(vitality_bar)
	vitality_frame = TextureRect.new()
	vitality_frame.name = "VitalityVineFrame"
	vitality_frame.texture = load("res://assets/runtime/chapter01/story/boss_frame.png")
	vitality_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	vitality_frame.position = Vector2(256, 20)
	vitality_frame.size = Vector2(268, 70)
	vitality_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(vitality_frame)
	vitality_label = Label.new()
	vitality_label.name = "VitalityValue"
	vitality_label.position = Vector2(280, 45)
	vitality_label.size = Vector2(220, 22)
	vitality_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vitality_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vitality_label.add_theme_font_size_override("font_size", 13)
	vitality_label.add_theme_color_override("font_color", Color("fff0ce"))
	vitality_label.add_theme_color_override("font_shadow_color", Color("081719"))
	vitality_label.add_theme_constant_override("shadow_outline_size", 4)
	vitality_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(vitality_label)
	game.objective.position = Vector2(34, 91)
	game.objective.size = Vector2(1120, 58)
	game.objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game.objective.add_theme_color_override("font_color", Color("fff0cf"))
	game.objective.add_theme_color_override("font_shadow_color", Color("081719"))
	game.objective.add_theme_constant_override("shadow_outline_size", 5)
	game.hint.position = Vector2(300, 500)
	game.hint.size = Vector2(680, 40)
	game.hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.hint.add_theme_color_override("font_shadow_color", Color("081719"))
	game.hint.add_theme_constant_override("shadow_outline_size", 6)
	for button in game.touch_layer.get_children():
		var normal := ""
		var pressed := ""
		match button.action:
			"move_left": normal = "left_rest"; pressed = "left_pressed"
			"move_right": normal = "right_rest"; pressed = "right_pressed"
			"jump": normal = "jump_normal"; pressed = "jump_pressed"
			"attack": normal = "attack_normal"; pressed = "attack_pressed"
			"interact": normal = "interact"; pressed = "interact"
		if normal != "":
			button.texture_normal = _texture(normal)
			button.texture_pressed = _texture(pressed)
			button.position.y = 604
			for label in button.get_children():
				label.visible = button.action == "interact"
				if button.action == "interact":
					label.position = Vector2(22, 26)
					label.add_theme_color_override("font_color", Color("23433a"))
					label.add_theme_font_size_override("font_size", 16)
					label.text = "USE"
	_process(0)

	load("res://scripts/ui/botanical_dialogue.gd").apply(game)
	load("res://scripts/ui/popup_typography.gd").apply(game)

func _process(_delta: float) -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.player):
		return
	for i in hearts.size():
		hearts[i].texture = _texture("health_full" if i < game.player.health else "health_empty")
	title_background.visible = game.menu.visible
	var root: Control = game.objective.get_parent()
	game.objective.visible = game.started
	game.hint.visible = game.started and not game.get_tree().paused
	for name in ["ChapterLabel", "PauseButton", "ControlsHint"]:
		var element := root.get_node_or_null(name)
		if element:
			element.visible = game.started and (name != "ControlsHint" or not game.touch_layer.visible)
	health_row.visible = game.started and not game.menu.visible
	vitality_bar.visible = health_row.visible
	vitality_frame.visible = health_row.visible
	vitality_label.visible = health_row.visible
	vitality_label.text = "%d / 100" % game.player.vitality
	vitality_bar.value = game.player.vitality
	vitality_bar.modulate = Color("ffae8f") if game.player.vitality <= 25 else Color.WHITE
	game.touch_layer.visible = (OS.has_feature("mobile") or "--touch" in OS.get_cmdline_user_args()) and game.started and not game.get_tree().paused

	if "chapter_number" in game and game.completed:
		game.objective.hide()
		game.hint.hide()
		root.get_node("ControlsHint").hide()
