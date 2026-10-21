extends Node
## Live accessible dialogue text over the reusable, text-free botanical frame.
var game: Node
var card: Control
var frame: TextureRect
var speaker: Label
var message: Label
var continue_button: Button
var last_line := ""
static func apply(target: Node) -> Node:
	var helper = load("res://scripts/ui/botanical_dialogue.gd").new()
	helper.name = "BotanicalDialogue"
	helper.game = target
	helper.process_mode = Node.PROCESS_MODE_ALWAYS
	target.add_child(helper)
	helper.install()
	return helper
func install() -> void:
	card = Control.new()
	card.name = "BotanicalDialogueCard"
	card.position = Vector2(245,285)
	card.size = Vector2(790,253)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.objective.get_parent().add_child(card)
	frame = TextureRect.new()
	frame.name = "BotanicalDialogueFrame"
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.texture = load("res://assets/runtime/chapter01/ui/UI-009_botanical_dialogue.png")
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.size = card.size
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(frame)
	var face := SystemFont.new()
	face.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif","Times New Roman"])
	speaker = _label(face,Rect2(100,80,120,39),Color("ffe2a0"),22)
	speaker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message = _label(face,Rect2(245,62,450,76),Color("292a1b"),21)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	continue_button = Button.new()
	continue_button.name = "BotanicalContinue"
	continue_button.position = Vector2(165,145)
	continue_button.size = Vector2(460,53)
	continue_button.text = "Continue   E / Y / Enter"
	continue_button.focus_mode = Control.FOCUS_NONE
	continue_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	continue_button.add_theme_font_override("font",face)
	continue_button.add_theme_font_size_override("font_size",22)
	for state in ["normal","hover","pressed","disabled","focus"]:
		continue_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color"]:
		continue_button.add_theme_color_override(state,Color("ffe5ac"))
	continue_button.pressed.connect(game._advance_dialogue)
	card.add_child(continue_button)
	card.hide()
func _label(face: Font, bounds: Rect2, color: Color, size: int) -> Label:
	var label := Label.new()
	label.position = bounds.position
	label.size = bounds.size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font",face)
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",color)
	card.add_child(label)
	return label
func _process(_delta: float) -> void:
	if not is_instance_valid(game): return
	var memory = game.get("memory")
	var showing_memory: bool = is_instance_valid(memory) and memory.visible
	var active: bool = game.started and not game.get_tree().paused and not game.dialogue_lines.is_empty() and not showing_memory
	card.visible = active
	if not game.dialogue_lines.is_empty(): game.dialogue_box.hide()
	if not active: return
	var line: String = game.dialogue_label.text
	if line != last_line:
		last_line = line
		var separator := line.find(":")
		var prefix := line.left(separator).strip_edges() if separator >= 0 else ""
		if prefix in ["Tavi","Rusk","Villager","Mote"]:
			speaker.text = prefix + ":"
			message.text = line.substr(separator+1).strip_edges()
		else:
			speaker.text = "Narrator"
			message.text = line
		var text_size := 21
		message.add_theme_font_size_override("font_size",text_size)
		while text_size > 17 and message.get_line_count() * message.get_line_height() > int(message.size.y):
			text_size -= 1
			message.add_theme_font_size_override("font_size",text_size)
func _exit_tree() -> void:
	if is_instance_valid(card): card.queue_free()
