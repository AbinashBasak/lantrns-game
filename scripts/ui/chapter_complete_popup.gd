extends Control
## Separate runtime typography and hit targets over the generated, text-free modal art.
const ART := "res://assets/runtime/chapter01/ui/UI-023_completion_popup.png"
var game: Node
var backdrop: ColorRect
var was_visible := false
var replay: Button
func install(target: Node) -> void:
	game = target
	var orchard: bool = "chapter_number" in game and game.chapter_number == 2
	process_mode = Node.PROCESS_MODE_ALWAYS
	var panel: PanelContainer = game.victory_panel
	panel.get_child(0).hide()
	var empty := StyleBoxEmpty.new()
	panel.add_theme_stylebox_override("panel",empty)
	panel.position = Vector2(170,45)
	panel.size = Vector2(940,627)
	custom_minimum_size = Vector2(940,627)
	mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_child(self)
	var picture := TextureRect.new()
	picture.texture = load(ART)
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_SCALE
	picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(picture)
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif","Times New Roman"])
	serif.font_weight = 400
	text_line("BRIARWAKE ORCHARD — COMPLETE" if orchard else "THE FORGOTTEN TRAIL — COMPLETE",Rect2(190,165,560,50),20,Color("332414"),serif)
	text_line("First true Anchor fragment recovered" if orchard else "First Golden Fragment recovered",Rect2(135,237,670,56),29,Color("ffe4ac"),serif)
	text_line("Four jungle seals restored. Mossjaw is free.\nSable’s warning leads toward Glasswater Fen." if orchard else "The sword remembers an orchard.\nA newly opened passage leads toward Briarwake.",Rect2(160,327,620,76),22,Color("e0e4d9"),serif)
	replay = Button.new()
	replay.name = "ReplayChapter"
	replay.text = "Replay Chapter 2    ›" if orchard else "Replay Chapter 1    ›"
	replay.position = Vector2(257,446)
	replay.size = Vector2(426,62)
	replay.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	replay.add_theme_font_override("font",serif)
	replay.add_theme_font_size_override("font_size",25)
	for state in ["normal","hover","pressed","disabled"]:
		replay.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:
		replay.add_theme_color_override(state,Color("2c1b09"))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color(1,0.9,0.6,0.05)
	focus.border_color = Color("fff5cb")
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(14)
	replay.add_theme_stylebox_override("focus",focus)
	replay.mouse_entered.connect(func(): picture.modulate=Color(1.08,1.06,1.0))
	replay.mouse_exited.connect(func(): picture.modulate=Color.WHITE)
	replay.pressed.connect(game._restart)
	add_child(replay)
	if not orchard:
		var proceed := Button.new()
		proceed.name = "ContinueChapter"
		proceed.text = "Continue to Briarwake    ›"
		proceed.position = Vector2(257, 525)
		proceed.size = Vector2(426, 52)
		proceed.add_theme_font_override("font", serif)
		proceed.add_theme_font_size_override("font_size", 22)
		proceed.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var existing_button: Button = game.pause_panel.get_child(0).get_child(1)
		for state in ["normal","hover","pressed","disabled","focus"]:
			proceed.add_theme_stylebox_override(state,existing_button.get_theme_stylebox(state))
		proceed.add_theme_color_override("font_color",Color("fff0ce"))
		proceed.pressed.connect(game._continue_to_chapter02)
		add_child(proceed)
	backdrop = ColorRect.new()
	backdrop.name = "CompletionBackdrop"
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.color = Color(0.015,0.025,0.025,0.48)
	var root: Control = game.objective.get_parent()
	root.add_child(backdrop)
	root.move_child(panel,root.get_child_count()-1)
	backdrop.hide()
func text_line(value: String, rect: Rect2, font_size: int, color: Color, face: Font) -> void:
	var label := Label.new()
	label.text = value
	label.position = rect.position
	label.size = rect.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font",face)
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",color)
	add_child(label)
func _process(_delta: float) -> void:
	if not is_instance_valid(game): return
	var shown: bool = game.victory_panel.visible
	backdrop.visible = shown
	if shown and not was_visible:
		pivot_offset = Vector2(470,313.5)
		scale = Vector2.ONE*0.96
		modulate.a = 0
		var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel(true)
		tween.tween_property(self,"scale",Vector2.ONE,0.24).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self,"modulate:a",1.0,0.18)
		replay.grab_focus()
	was_visible = shown

func _exit_tree() -> void:
	if is_instance_valid(backdrop): backdrop.queue_free()
