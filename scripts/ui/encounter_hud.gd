extends Control
## Live encounter HUD: text and fill remain driven by the chapter controller.
var game: Node
var objective_panel: PanelContainer
var feedback_panel: PanelContainer
var points_panel: PanelContainer
var objective_heading: Label
var objective_detail: Label
var feedback_text: Label
var points_text: Label
var serif: SystemFont
var source_boss_title: Label
var portrait: TextureRect
var hearts_frame: Panel
var hint_panel: PanelContainer
var hint_text: Label
var hint_remaining := 0.0
var last_hint := ""
const HINT_DURATION := 5.0
const HINT_FADE := 0.6

static func apply(target: Node) -> void:
	var hud: Control = load("res://scripts/ui/encounter_hud.gd").new()
	hud.name = "EncounterHUD"
	hud.game = target
	hud.process_mode = Node.PROCESS_MODE_ALWAYS
	target.objective.get_parent().add_child(hud)
	hud._install()

const Ornate = preload("res://scripts/ui/ornate_skin.gd")
var layout_width := 0.0
var objective_column: VBoxContainer
var points_row: HBoxContainer
var feedback_row: HBoxContainer

func _panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel",Ornate.panel_style())
	add_child(panel)
	return panel

func _label(parent: Control, text: String, font_size: int, gold: bool = false) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font",serif)
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("f4d592") if gold else Color("fff1cd"))
	label.add_theme_color_override("font_shadow_color",Color("071a19"))
	label.add_theme_constant_override("shadow_offset_y",2)
	parent.add_child(label)
	return label

func _wrap(label: Label) -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _layout() -> void:
	var width := layout_width if layout_width > 0 else get_viewport_rect().size.x
	var card_width := minf(370,width-40)
	objective_panel.position = Vector2(20,104)
	objective_panel.size = Vector2(card_width,0)
	# Autowrapped Labels report their measured height after the container sorts.
	feedback_panel.position = Vector2(20,objective_panel.get_rect().end.y+12)
	feedback_panel.size = Vector2(card_width,0)
	var text_width := serif.get_string_size(points_text.text,HORIZONTAL_ALIGNMENT_LEFT,-1,17).x
	var points_width := minf(text_width+90,maxf(140,width-132))
	points_panel.size = Vector2(points_width,0)
	points_panel.position = Vector2(width-92-points_width,18)
	game.rune_clue.position = Vector2(36,(feedback_panel.get_rect().end.y+12) if feedback_panel.visible else objective_panel.get_rect().end.y+12)
	game.rune_clue.size = Vector2(card_width-24,90)
	var hint_y: float = game.rune_clue.position.y
	if game.rune_clue.visible and not game.rune_clue.text.is_empty():
		hint_y += game.rune_clue.size.y + 12
	hint_panel.position = Vector2(20,hint_y)
	hint_panel.size = Vector2(card_width,0)

func _install() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	serif = Ornate.font()
	objective_panel = _panel()
	objective_column = VBoxContainer.new()
	objective_column.add_theme_constant_override("separation",3)
	objective_panel.add_child(objective_column)
	_label(objective_column,"◇   CHAPTER 1",14,true)
	objective_heading = _label(objective_column,"The Forgotten Trail",22)
	_wrap(objective_heading)
	objective_detail = _label(objective_column,"",16)
	_wrap(objective_detail)
	feedback_panel = _panel()
	feedback_row = HBoxContainer.new()
	feedback_row.add_theme_constant_override("separation",12)
	feedback_panel.add_child(feedback_row)
	Ornate.icon(feedback_row,"res://assets/runtime/shared/ui/UI-004_notice_medallion.png",44)
	feedback_text = _label(feedback_row,"",17)
	_wrap(feedback_text)
	feedback_text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	points_panel = _panel()
	points_row = HBoxContainer.new()
	points_row.add_theme_constant_override("separation",10)
	points_panel.add_child(points_row)
	Ornate.icon(points_row,"res://assets/runtime/shared/ui/UI-003_crystal.png",28)
	points_text = _label(points_row,"",17,true)
	_wrap(points_text)
	points_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_panel = _panel()
	hint_panel.name = "TransientGuidance"
	hint_text = _label(hint_panel,"",16)
	_wrap(hint_text)
	hint_panel.hide()
	_install_previous_health_frame()
	get_parent().move_child(self,1)
	game.boss_ui.position = Vector2(410,104)
	game.boss_ui.size = Vector2(550,138)
	source_boss_title = game.boss_ui.get_child(0)
	source_boss_title.position = Vector2(128,43)
	source_boss_title.size = Vector2(337,25)
	source_boss_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	source_boss_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	source_boss_title.add_theme_font_override("font",serif)
	source_boss_title.add_theme_font_size_override("font_size",14)
	source_boss_title.z_index = 2
	for child in game.boss_ui.get_children():
		if child is TextureRect: child.hide()
	portrait = TextureRect.new()
	portrait.name = "SentinelPortraitFrame"
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.texture = load("res://assets/runtime/chapter01/ui/UI-008_sentinel_portrait_frame.png")
	portrait.position = Vector2.ZERO
	portrait.size = Vector2(550,138)
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.boss_ui.add_child(portrait)
	portrait.set_deferred("size",Vector2(550,138))
	game.boss_ui.move_child(portrait,1)
	# The generated track stays dark; only this live proportional fill sits over its opening.
	game.boss_health.position = Vector2(141,80)
	game.boss_health.size = Vector2(366,17)
	game.boss_health.texture_under = null
	game.boss_health.stretch_margin_left = 8
	game.boss_health.stretch_margin_right = 8
	game.boss_health.z_index = 1
	game.rune_clue.add_theme_font_override("font",serif)
	game.rune_clue.add_theme_font_size_override("font_size",16)
	_process(0)

func _process(delta: float) -> void:
	if not is_instance_valid(game): return
	var playing: bool = game.started and not game.menu.visible and not game.get_tree().paused and not game.dialogue_box.visible and not game.memory.visible and not game.victory_panel.visible
	visible = playing
	game.boss_ui.modulate.a = 1.0 if playing else 0.0
	game.objective.modulate.a = 0
	game.feedback.modulate.a = 0
	if is_instance_valid(game.rewards):
		game.rewards.score_label.modulate.a = 0
		points_text.text = "TRAIL POINTS  %d" % game.rewards.points
	var caption := get_parent().get_node_or_null("ChapterLabel")
	if caption: caption.modulate.a = 0
	var full_text: String = game.objective.text.trim_prefix("CHAPTER 1  /  ")
	var boss_visible: bool = game.boss_ui.visible
	objective_heading.text = "Hollow Sentinel" if boss_visible else ("Jungle Exploration" if game.jungle_area >= 0 else "The Forgotten Trail")
	objective_detail.text = "Watch the wind-up; strike during recovery." if boss_visible else full_text
	feedback_panel.visible = game.feedback_time > 0 and not game.feedback.text.is_empty()
	feedback_text.text = game.feedback.text
	_update_hint(delta,playing)
	_layout()

func _update_hint(delta: float, playing: bool) -> void:
	# The chapter rewrites its hint every frame. Only a changed instruction
	# starts a new notice; an unchanged instruction must stay dismissed.
	game.hint.self_modulate.a = 0
	if playing:
		var content: String = game.hint.text.strip_edges()
		if content != last_hint:
			last_hint = content
			hint_text.text = content
			hint_remaining = HINT_DURATION if not content.is_empty() else 0.0
		else:
			hint_remaining = maxf(0,hint_remaining-delta)
	hint_panel.visible = playing and hint_remaining > 0 and game.hint.visible and game.hint.modulate.a > 0
	hint_panel.modulate.a = clampf(hint_remaining / HINT_FADE,0,1)

func _install_previous_health_frame() -> void:
	# Preserve the player health presentation from before the content-panel update.
	hearts_frame = Panel.new()
	hearts_frame.name = "OriginalHeartsFrame"
	hearts_frame.position = Vector2(20,13)
	hearts_frame.size = Vector2(237,48)
	hearts_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.025,0.105,0.105,0.95)
	box.border_color = Color("d5b56e")
	box.set_border_width_all(2)
	box.set_corner_radius_all(11)
	box.shadow_color = Color(0.01,0.02,0.02,0.5)
	box.shadow_size = 4
	hearts_frame.add_theme_stylebox_override("panel",box)
	add_child(hearts_frame)
	move_child(hearts_frame,0)
	hearts_frame.draw.connect(func():
		for corner in [Vector2(10,0),Vector2(227,0),Vector2(227,48),Vector2(10,48)]:
			hearts_frame.draw_polyline(PackedVector2Array([corner+Vector2(-5,0),corner+Vector2(0,-4),corner+Vector2(5,0),corner+Vector2(0,4),corner+Vector2(-5,0)]),Color("e9ce8b"),1,true))
	for child in game.get_children():
		if child.get_script() and child.get_script().resource_path.ends_with("prologue_skin.gd"):
			child.health_row.position = Vector2(27,17)
			child.health_row.add_theme_constant_override("separation",3)
			for heart in child.hearts:
				heart.custom_minimum_size = Vector2(41,40)
