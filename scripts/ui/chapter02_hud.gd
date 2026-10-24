extends Control
## Chapter 2 shares Chapter 1’s actual panel, guidance and keyboard artwork.
var game: Node
var objective_panel: PanelContainer
var feedback_panel: PanelContainer
var points_panel: PanelContainer
var objective_heading: Label
var objective_detail: Label
var objective_progress: Label
var feedback_text: Label
var points_text: Label
var serif: SystemFont
var source_boss_title: Label
var boss_panel: PanelContainer
var boss_health: TextureProgressBar
var boss_tell: Label
var portrait: TextureRect
var hearts_frame: Panel
var hint_panel: PanelContainer
var hint_text: Label
var reference_controls: HBoxContainer
var hint_remaining := 0.0
var last_hint := ""
const HINT_DURATION := 5.0
const HINT_FADE := 0.6

static func apply(target: Node) -> void:
	var hud: Control = load("res://scripts/ui/chapter02_hud.gd").new()
	hud.name = "Chapter02HUD"
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
	var hint_y: float = feedback_panel.get_rect().end.y+12 if feedback_panel.visible else objective_panel.get_rect().end.y+12
	hint_panel.position = Vector2(20,hint_y)
	hint_panel.size = Vector2(card_width,0)
	boss_panel.position = Vector2(maxf(420,(width-620)/2),104)
	boss_panel.size = Vector2(minf(620,width-440),0)
	if reference_controls:
		reference_controls.position = Vector2(30,get_viewport_rect().size.y-92)
		reference_controls.scale = Vector2.ONE*minf(1.0,(width-60)/maxf(1,reference_controls.get_combined_minimum_size().x))

func _install() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	serif = Ornate.font()
	objective_panel = _panel()
	objective_column = VBoxContainer.new()
	objective_column.add_theme_constant_override("separation",3)
	objective_panel.add_child(objective_column)
	_label(objective_column,"◇   CHAPTER 2",14,true)
	objective_heading = _label(objective_column,"The Guardian of Briarwake",22)
	_wrap(objective_heading)
	objective_detail = _label(objective_column,"",16)
	_wrap(objective_detail)
	objective_progress = _label(objective_column,"",14,true)
	_wrap(objective_progress)
	objective_progress.hide()
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
	hint_panel.add_theme_stylebox_override("panel",_reference_style("UI-004_leaf_hint_frame.png",Vector2(36,20),Vector2(22,20)))
	var hint_row := HBoxContainer.new()
	hint_row.add_theme_constant_override("separation",8)
	hint_panel.add_child(hint_row)
	Ornate.icon(hint_row,"res://assets/runtime/chapter01/reference_jungle/UI-004_hint_attention.png",32)
	hint_text = _label(hint_row,"",16,true)
	_wrap(hint_text)
	hint_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	Ornate.icon(hint_row,"res://assets/runtime/chapter01/reference_jungle/UI-004_hint_arrow.png",28)
	_install_reference_controls()
	hint_panel.hide()
	_install_previous_health_frame()
	get_parent().move_child(self,1)
	boss_panel = _panel()
	boss_panel.name = "MossjawHealthPanel"
	var boss_column := VBoxContainer.new()
	boss_column.add_theme_constant_override("separation",4)
	boss_panel.add_child(boss_column)
	source_boss_title = _label(boss_column,"MOSSJAW · THE BOUND GUARDIAN",18,true)
	source_boss_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_health = TextureProgressBar.new()
	boss_health.name = "LiveMossjawHealth"
	boss_health.texture_under = load("res://assets/runtime/chapter01/story/boss_track.png")
	boss_health.texture_progress = load("res://assets/runtime/chapter01/story/boss_fill.png")
	boss_health.nine_patch_stretch = true
	boss_health.stretch_margin_left = 9
	boss_health.stretch_margin_right = 9
	boss_health.custom_minimum_size = Vector2(0,18)
	boss_health.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boss_health.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boss_column.add_child(boss_health)
	boss_tell = _label(boss_column,"",15)
	_wrap(boss_tell)
	boss_tell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_process(0)

func _process(delta: float) -> void:
	if not is_instance_valid(game): return
	var playing: bool = game.started and not game.menu.visible and not game.get_tree().paused and game.dialogue_lines.is_empty() and not game.victory_panel.visible
	visible = playing
	if reference_controls:
		reference_controls.visible = playing and not game.touch_layer.visible
	var old_controls := get_parent().get_node_or_null("ControlsHint")
	if old_controls: old_controls.self_modulate.a = 0
	game.objective.self_modulate.a = 0
	if "guidance" in game and is_instance_valid(game.guidance): game.guidance.self_modulate.a = 0
	if "boss_label" in game and is_instance_valid(game.boss_label): game.boss_label.self_modulate.a = 0
	if is_instance_valid(game.rewards):
		if "score_label" in game.rewards and is_instance_valid(game.rewards.score_label): game.rewards.score_label.self_modulate.a = 0
		points_text.text = "TRAIL POINTS  %d" % game.rewards.points
	var caption := get_parent().get_node_or_null("ChapterLabel")
	if caption: caption.self_modulate.a = 0
	var full_text: String = game.objective.text.trim_prefix("BRIARWAKE  /  ").trim_prefix("CHAPTER 2  /  ")
	objective_heading.text = "Mossjaw’s Sanctuary" if game.boss_active else ("Jungle Exploration" if game.jungle_area >= 0 else "The Guardian of Briarwake")
	objective_detail.text = full_text
	objective_progress.text = game.mission_text
	objective_progress.visible = not game.mission_text.is_empty()
	if is_instance_valid(game.jungle_label):
		game.jungle_label.self_modulate.a = 0
		if not game.jungle_label.text.is_empty():
			objective_progress.text = game.jungle_label.text + ("\n"+game.mission_text if not game.mission_text.is_empty() else "")
			objective_progress.show()
	feedback_panel.visible = false
	if "feedback" in game and is_instance_valid(game.feedback):
		game.feedback.self_modulate.a = 0
		feedback_panel.visible = game.feedback_time > 0 and not game.feedback.text.is_empty()
		feedback_text.text = game.feedback.text
	boss_panel.visible = game.boss_active and not game.boss_defeated and is_instance_valid(game.boss)
	if boss_panel.visible:
		boss_health.max_value = game.boss.max_health
		boss_health.value = game.boss.health
		source_boss_title.text = "MOSSJAW · %d / %d" % [game.boss.health,game.boss.max_health]
		boss_tell.text = _attack_tell(game.boss.state)
	_update_hint(delta,playing)
	_layout()

func _attack_tell(state: String) -> String:
	match state:
		"leap_warning": return "LEAP SLAM · Move away from the marked landing zone"
		"leap", "slam_impact": return "LEAP SLAM · Jump clear of the landing shock"
		"rush_warning", "rush": return "DOUBLE RUSH · Jump the charge; watch for its return"
		"recover": return "RECOVERY · Strike its body or free an exposed binding"
		"charge_warning", "charge": return "CHARGE · Jump clear, then counterattack"
		"eruption_warning", "eruption": return "ROOT ERUPTION · Move away from the locked golden root mark"
		"sweep_warning", "sweep": return "ROOT SWEEP · Jump over the advancing roots"
		"volley_warning", "volley": return "SEED VOLLEY · Jump between the arcing seeds"
		"claw_warning", "claw": return "CLAW SWIPES · Back away, then strike its body"
		_: return state.replace("_"," ").to_upper() + " · Watch Mossjaw’s movement"

func _update_hint(delta: float, playing: bool) -> void:
	# The chapter rewrites its hint every frame. Only a changed instruction
	# starts a new notice; an unchanged instruction must stay dismissed.
	game.hint.self_modulate.a = 0
	if playing:
		var content: String = game.hint.text.strip_edges()
		if content.is_empty() and "guidance_time" in game and game.guidance_time > 0:
			var guidance_content: String = game.guidance.text.strip_edges()
			var feedback_duplicate: bool = game.feedback_time > 0 and is_instance_valid(game.feedback) and guidance_content == game.feedback.text.strip_edges()
			if not feedback_duplicate: content = guidance_content
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

func _reference_style(file: String, corners: Vector2, padding: Vector2) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/runtime/chapter01/reference_jungle/"+file)
	for edge in [SIDE_LEFT,SIDE_RIGHT]:
		style.set_texture_margin(edge,corners.x)
		style.set_content_margin(edge,padding.x)
	for edge in [SIDE_TOP,SIDE_BOTTOM]:
		style.set_texture_margin(edge,corners.y)
		style.set_content_margin(edge,padding.y)
	return style

func _install_reference_controls() -> void:
	reference_controls = HBoxContainer.new()
	reference_controls.name = "ReferenceKeyboardControls"
	reference_controls.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reference_controls.add_theme_constant_override("separation",24)
	add_child(reference_controls)
	for entry in [["A  ←","Move left"],["D  →","Move right"],["SPACE","Jump"],["J","Sword"],["E","Interact"],["ESC","Pause"]]:
		var column := VBoxContainer.new()
		column.add_theme_constant_override("separation",5)
		reference_controls.add_child(column)
		var key := PanelContainer.new()
		key.mouse_filter = Control.MOUSE_FILTER_IGNORE
		key.add_theme_stylebox_override("panel",_reference_style("UI-025_keycap.png",Vector2(12,12),Vector2(14,8)))
		column.add_child(key)
		var key_label := _label(key,entry[0],22)
		key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_label.custom_minimum_size = Vector2(42,30)
		var caption := _label(column,entry[1],15)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
