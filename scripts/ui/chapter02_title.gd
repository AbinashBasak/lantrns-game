extends Control
## Reuses the latest Chapter 1 title art with correctly labeled Chapter 2 controls.
const ART := "res://assets/runtime/chapter01/ui/UI-016_exact_title_menu.png"
const Ornate = preload("res://scripts/ui/ornate_skin.gd")
var game: Node
var background: TextureRect
var transition_pending := false

static func apply(target: Node, backdrop: TextureRect = null) -> void:
	var title: Control = load("res://scripts/ui/chapter02_title.gd").new()
	title.name = "Chapter02Title"
	title.game = target
	title.background = backdrop
	if not is_instance_valid(backdrop):
		for child in target.get_children():
			if child.get_script() and child.get_script().resource_path.ends_with("prologue_skin.gd"):
				title.background = child.title_background
	title.process_mode = Node.PROCESS_MODE_ALWAYS
	target.objective.get_parent().add_child(title)
	title._install()

func _install() -> void:
	position = Vector2.ZERO
	size = Vector2(1280,720)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_instance_valid(background):
		background.texture = load(ART)
		background.light_mask = 2
		background.position = Vector2.ZERO
		background.size = Vector2(1280,720)
		background.stretch_mode = TextureRect.STRETCH_SCALE
	game.menu.get_child(0).hide()
	game.menu.add_theme_stylebox_override("panel",StyleBoxEmpty.new())
	game.menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# The original image has Chapter 1 labels baked into its lower half.
	# Reusable text-free botanical panels fully cover those labels at native scale.
	var info := PanelContainer.new()
	info.position = Vector2(118,334)
	info.size = Vector2(466,80)
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_theme_stylebox_override("panel",_panel(10))
	add_child(info)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",3)
	info.add_child(column)
	_text(column,"The Guardian of Briarwake",22)
	_text(column,"New jungles · ancient roots · a guardian to free",14)
	_button("Continue Chapter 2   ↵",Rect2(108,418,492,75),_continue)
	var chapter := PanelContainer.new()
	chapter.position = Vector2(129,519)
	chapter.size = Vector2(452,42)
	chapter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chapter.add_theme_stylebox_override("panel",_panel(9))
	add_child(chapter)
	_text(chapter,"◇  CHAPTER 2 · BRIARWAKE ORCHARD",16)
	var replay_backing := Panel.new()
	replay_backing.position = Vector2(155,570)
	replay_backing.size = Vector2(400,78)
	replay_backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	replay_backing.add_theme_stylebox_override("panel",_panel(8))
	add_child(replay_backing)
	_button("Replay Chapter 1",Rect2(163,577,382,51),_replay)
	if is_instance_valid(background):
		var lighting := Node2D.new()
		lighting.set_script(load("res://scripts/ui/title_menu_lighting.gd"))
		lighting.game = game
		lighting.backdrop = background
		get_parent().add_child(lighting)
		get_parent().move_child(lighting,get_index())

func _panel(padding: float) -> StyleBoxTexture:
	var style := Ornate.panel_style()
	for edge in [SIDE_LEFT,SIDE_RIGHT,SIDE_TOP,SIDE_BOTTOM]:
		style.set_content_margin(edge,padding)
	return style

func _text(parent: Control, content: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = content
	label.add_theme_font_override("font",Ornate.font())
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("ffedb4"))
	label.add_theme_color_override("font_shadow_color",Color("071a19"))
	label.add_theme_constant_override("shadow_offset_y",2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _button(content: String, bounds: Rect2, action: Callable) -> Button:
	var button := Button.new()
	button.text = content
	button.position = bounds.position
	button.size = bounds.size
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_override("font",Ornate.font())
	button.add_theme_font_size_override("font_size",23 if bounds.size.y > 60 else 18)
	for state in ["normal","hover","pressed","disabled"]:
		var style := StyleBoxTexture.new()
		style.texture = load("res://assets/runtime/prologue/ui/button_%s.png" % state)
		for edge in [SIDE_LEFT,SIDE_RIGHT]: style.set_texture_margin(edge,64)
		for edge in [SIDE_TOP,SIDE_BOTTOM]: style.set_texture_margin(edge,32)
		button.add_theme_stylebox_override(state,style)
	button.add_theme_stylebox_override("focus",Ornate.panel_style())
	button.add_theme_color_override("font_color",Color("fff0ce"))
	button.add_theme_color_override("font_hover_color",Color("fff7df"))
	button.add_theme_color_override("font_focus_color",Color("ffe2a3"))
	button.pressed.connect(action)
	add_child(button)
	return button

func _continue() -> void:
	if transition_pending: return
	transition_pending = true
	game._begin()

func _replay() -> void:
	if transition_pending: return
	transition_pending = true
	game._replay_chapter01()

func _process(_delta: float) -> void:
	visible = game.menu.visible
