extends Node
## Live orchard art and dialogue layered under a reusable text-free botanical frame.
var game: Node
var frame: TextureRect
var message: Label
var continue_button: Button
var backdrop: ColorRect
var was_visible := false
func install(target: Node) -> void:
	game = target
	process_mode = Node.PROCESS_MODE_ALWAYS
	target.add_child(self)
	game.memory.position = Vector2(210,85)
	game.memory.size = Vector2(860,573)
	game.memory.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for picture in game.memory.get_children():
		picture.position = Vector2(130,74)
		picture.size = Vector2(600,196)
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	frame = TextureRect.new()
	frame.name = "MemoryFrame"
	frame.texture = load("res://assets/runtime/chapter01/ui/UI-009_memory_popup.png")
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.position = Vector2.ZERO
	frame.size = Vector2(860,573)
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	game.memory.add_child(frame)
	var face := SystemFont.new()
	face.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif","Times New Roman"])
	face.font_weight = 400
	message = Label.new()
	message.name = "MemoryText"
	message.position = Vector2(150,302)
	message.size = Vector2(560,83)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.mouse_filter = Control.MOUSE_FILTER_IGNORE
	message.add_theme_font_override("font",face)
	message.add_theme_font_size_override("font_size",21)
	message.add_theme_color_override("font_color",Color("30291b"))
	game.memory.add_child(message)
	continue_button = Button.new()
	continue_button.name = "MemoryContinue"
	continue_button.text = "Continue   E / Y / Enter"
	continue_button.position = Vector2(220,397)
	continue_button.size = Vector2(420,54)
	# Keyboard/controller continuation is handled once by the shared dialogue input.
	continue_button.focus_mode = Control.FOCUS_NONE
	continue_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	continue_button.add_theme_font_override("font",face)
	continue_button.add_theme_font_size_override("font_size",22)
	for state in ["normal","hover","pressed","disabled","focus"]:
		continue_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color"]:
		continue_button.add_theme_color_override(state,Color("ffdfa0"))
	continue_button.pressed.connect(game._advance_dialogue)
	continue_button.mouse_entered.connect(func(): frame.modulate=Color(1.05,1.04,1))
	continue_button.mouse_exited.connect(func(): frame.modulate=Color.WHITE)
	game.memory.add_child(continue_button)
	backdrop = ColorRect.new()
	backdrop.name = "MemoryBackdrop"
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.02,0.035,0.025,0.26)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	var root: Control = game.objective.get_parent()
	root.add_child(backdrop)
	root.move_child(game.memory,root.get_child_count()-1)
	backdrop.hide()
func _process(_delta: float) -> void:
	if not is_instance_valid(game): return
	var shown: bool = game.memory.visible
	var active: bool = shown and not game.get_tree().paused
	backdrop.visible = active
	for child in game.memory.get_children(): child.visible = active
	if active:
		game.dialogue_box.hide()
		message.text = game.dialogue_label.text
	if shown and not was_visible:
		game.memory.pivot_offset = Vector2(430,286.5)
		game.memory.scale = Vector2.ONE*0.97
		game.memory.modulate.a = 0
		var tween := create_tween().set_parallel(true)
		tween.tween_property(game.memory,"scale",Vector2.ONE,0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(game.memory,"modulate:a",1.0,0.16)
	was_visible = shown
func _exit_tree() -> void:
	if is_instance_valid(backdrop): backdrop.queue_free()
