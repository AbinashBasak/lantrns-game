extends Control
## Live encounter HUD: text and fill remain driven by the chapter controller.
var game: Node
var objective_panel: Panel
var feedback_panel: Panel
var points_panel: Panel
var objective_heading: Label
var objective_detail: Label
var feedback_text: Label
var points_text: Label
var serif: SystemFont
var source_boss_title: Label
var portrait: TextureRect

static func apply(target: Node) -> void:
	var hud: Control = load("res://scripts/ui/encounter_hud.gd").new()
	hud.name = "EncounterHUD"
	hud.game = target
	hud.process_mode = Node.PROCESS_MODE_ALWAYS
	target.objective.get_parent().add_child(hud)
	hud._install()

func _box() -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.025,0.105,0.105,0.95)
	box.border_color = Color("d5b56e")
	box.set_border_width_all(2)
	box.set_corner_radius_all(11)
	box.shadow_color = Color(0.01,0.02,0.02,0.5)
	box.shadow_size = 4
	return box

func _panel(bounds: Rect2) -> Panel:
	var panel := Panel.new()
	panel.position = bounds.position
	panel.size = bounds.size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel",_box())
	add_child(panel)
	return panel

func _label(parent: Control, text: String, bounds: Rect2, font_size: int, gold: bool = false) -> Label:
	var label := Label.new()
	label.text = text
	label.position = bounds.position
	label.size = bounds.size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font",serif)
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("f4d592") if gold else Color("fff1cd"))
	label.add_theme_color_override("font_shadow_color",Color("071a19"))
	label.add_theme_constant_override("shadow_offset_y",2)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)
	return label

func _install() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif"])
	objective_panel = _panel(Rect2(20,88,360,90))
	_label(objective_panel,"◇   CHAPTER 1",Rect2(16,9,320,20),13,true)
	objective_heading = _label(objective_panel,"The Forgotten Trail",Rect2(44,29,300,29),21)
	objective_detail = _label(objective_panel,"",Rect2(44,55,300,32),14)
	feedback_panel = _panel(Rect2(20,194,360,64))
	feedback_panel.draw.connect(_draw_leaf_notice)
	feedback_text = _label(feedback_panel,"",Rect2(68,10,278,47),16)
	points_panel = _panel(Rect2(960,18,227,40))
	_label(points_panel,"◆",Rect2(12,6,24,27),22,true)
	points_text = _label(points_panel,"",Rect2(42,8,177,26),16,true)
	var hearts_frame := _panel(Rect2(20,13,237,48))
	move_child(hearts_frame,0)
	# The frame is underneath the existing generated hearts, rather than replacing life state.
	get_parent().move_child(self,1)
	for child in game.get_children():
		if child.get_script() and child.get_script().resource_path.ends_with("prologue_skin.gd"):
			child.health_row.position = Vector2(27,17)
			child.health_row.add_theme_constant_override("separation",3)
			for heart in child.hearts: heart.custom_minimum_size = Vector2(41,40)
	game.boss_ui.position = Vector2(400,80)
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

func _process(_delta: float) -> void:
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
	# Roman rune clues sit below the objective frame, with no collision with notices.
	game.rune_clue.position = Vector2(36,266 if feedback_panel.visible else 192)
	game.rune_clue.size = Vector2(335,90)
	queue_redraw()

func _draw() -> void:
	for bounds in [Rect2(20,88,360,90),Rect2(960,18,227,40),Rect2(20,13,237,48)]:
		if bounds.position == Vector2(20,88) and objective_panel.modulate.a == 0: continue
		var gold := Color("e9ce8b")
		for corner in [bounds.position+Vector2(10,0),bounds.position+Vector2(bounds.size.x-10,0),bounds.end-Vector2(10,0),bounds.position+Vector2(10,bounds.size.y)]:
			draw_polyline(PackedVector2Array([corner+Vector2(-5,0),corner+Vector2(0,-4),corner+Vector2(5,0),corner+Vector2(0,4),corner+Vector2(-5,0)]),gold,1,true)

func _draw_leaf_notice() -> void:
	feedback_panel.draw_circle(Vector2(31,32),24,Color("092b28"))
	feedback_panel.draw_arc(Vector2(31,32),24,0,TAU,40,Color("dbbd78"),1.5,true)
	feedback_panel.draw_line(Vector2(31,49),Vector2(31,15),Color("b8d78f"),2,true)
	feedback_panel.draw_colored_polygon(PackedVector2Array([Vector2(30,37),Vector2(18,32),Vector2(14,22),Vector2(23,23),Vector2(31,32)]),Color("9ecb79"))
	feedback_panel.draw_colored_polygon(PackedVector2Array([Vector2(32,29),Vector2(40,26),Vector2(46,15),Vector2(37,17),Vector2(31,24)]),Color("cee6a0"))
