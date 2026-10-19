extends Node2D
const PlayerScene = preload("res://scenes/player/player.tscn")
const EnemyScene = preload("res://scenes/enemies/thornling.tscn")
const LevelScene = preload("res://scenes/levels/underroot_01.tscn")
const Forest = preload("res://scripts/systems/forest.gd")
var player: CharacterBody2D
var checkpoint := Vector2(150,590)
var seeds: Array[Vector2] = [Vector2(460,445),Vector2(720,520),Vector2(1110,490),Vector2(1510,535),Vector2(2130,440),Vector2(2800,500)]
var collected: int = 0
var checkpoint_active: bool = false
var completed: bool = false
var started: bool = false
var clock: float = 0.0
var hud: Label
var objective: Label
var hint: Label
var menu: PanelContainer
var pause_panel: PanelContainer
var victory_panel: PanelContainer
var touch_layer: Control
var platforms: Array[Rect2] = []
var font: Font

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_inputs()
	font = ThemeDB.fallback_font
	var forest := Node2D.new()
	forest.set_script(Forest)
	forest.z_index = -10
	add_child(forest)
	forest.process_mode = Node.PROCESS_MODE_PAUSABLE
	var level := LevelScene.instantiate()
	add_child(level)
	platforms = level.get_platforms()
	player = PlayerScene.instantiate()
	player.position = checkpoint
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	player.health_changed.connect(func(_value: int): _update_hud())
	player.died.connect(_respawn)
	var camera := Camera2D.new()
	camera.position = Vector2(0,-205)
	camera.limit_left = 0
	camera.limit_right = 3600
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 6
	player.add_child(camera)
	_spawn_enemies()
	_build_ui()
	_update_hud()
	get_tree().paused = true
	if get_tree().has_meta("from_prologue"):
		get_tree().remove_meta("from_prologue")
		_begin()

func _setup_inputs() -> void:
	var bindings := {"move_left":[KEY_A,KEY_LEFT],"move_right":[KEY_D,KEY_RIGHT],"jump":[KEY_SPACE,KEY_W,KEY_UP],"attack":[KEY_J,KEY_X],"interact":[KEY_E],"pause":[KEY_ESCAPE],"restart":[KEY_R],"start":[KEY_ENTER]}
	for action in bindings:
		if not InputMap.has_action(action): InputMap.add_action(action)
		InputMap.action_erase_events(action)
		for key in bindings[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action,event)
	for binding in [["move_left",JOY_AXIS_LEFT_X,-1.0],["move_right",JOY_AXIS_LEFT_X,1.0]]:
		var event := InputEventJoypadMotion.new()
		event.axis = binding[1]
		event.axis_value = binding[2]
		InputMap.action_add_event(binding[0],event)
	for binding in [["jump",JOY_BUTTON_A],["attack",JOY_BUTTON_X],["interact",JOY_BUTTON_Y],["pause",JOY_BUTTON_START]]:
		var event := InputEventJoypadButton.new()
		event.button_index = binding[1]
		InputMap.action_add_event(binding[0],event)

func _spawn_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for x in [650,1250,2340,3040]:
		var enemy := EnemyScene.instantiate()
		enemy.position = Vector2(x,600)
		enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start") and not started:
		_begin()
	if Input.is_action_just_pressed("restart") and started:
		_restart()
	if Input.is_action_just_pressed("pause") and started and not completed:
		_toggle_pause()
	if get_tree().paused:
		return
	clock += delta
	for i in range(seeds.size()-1,-1,-1):
		if player.position.distance_to(seeds[i]+Vector2(0,24)) < 48:
			seeds.remove_at(i)
			collected += 1
			_update_hud()
	if player.position.distance_to(Vector2(1510,620)) < 90 and not checkpoint_active:
		checkpoint_active = true
		checkpoint = Vector2(1510,590)
		player.health = 5
		_update_hud()
	var near_gate := player.position.x > 3200
	hint.text = "E  /  Y     Listen to the old arch" if near_gate else ""
	if near_gate and Input.is_action_just_pressed("interact"):
		if collected >= 3:
			completed = true
			victory_panel.show()
			get_tree().paused = true
		else:
			hint.text = "The arch needs 3 light seeds. Explore the trail."
	queue_redraw()

func _respawn() -> void:
	player.reset_at(checkpoint)

func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _begin() -> void:
	started = true
	menu.hide()
	get_tree().paused = false

func _toggle_pause() -> void:
	if not started or completed:
		return
	get_tree().paused = not get_tree().paused
	pause_panel.visible = get_tree().paused
	for action in ["move_left","move_right","jump","attack","interact"]:
		Input.action_release(action)

func _update_hud() -> void:
	if not is_instance_valid(hud): return
	hud.text = "TAVI    " + "♥ ".repeat(player.health) + "♡ ".repeat(5-player.health) + "     •     LIGHT SEEDS   %02d / 06" % collected
	objective.text = "THE FORGOTTEN TRAIL  /  " + ("Lantern kindled · Find the old arch" if checkpoint_active else "Gather 3 light seeds · Follow the lanterns")

func _label(text: String, size: int, color: Color = Color("eee2c1")) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",color)
	return label

func _panel(parent: Node, bounds: Rect2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = bounds.position
	panel.size = bounds.size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035,0.08,0.09,0.96)
	style.border_color = Color("78664a")
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	style.content_margin_left = 36
	style.content_margin_right = 36
	style.content_margin_top = 30
	style.content_margin_bottom = 30
	panel.add_theme_stylebox_override("panel",style)
	parent.add_child(panel)
	return panel

func _button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0,52)
	button.add_theme_font_size_override("font_size",20)
	button.pressed.connect(callback)
	return button

func _build_ui() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var control := Control.new()
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(control)
	hud = _label("",21)
	hud.position = Vector2(34,25)
	control.add_child(hud)
	objective = _label("",16,Color("a6bdab"))
	objective.position = Vector2(34,58)
	control.add_child(objective)
	var chapter := _label("01   /   BRACKENREACH OUTSKIRTS",14,Color("c5b17d"))
	chapter.name = "ChapterLabel"
	chapter.position = Vector2(920,32)
	control.add_child(chapter)
	var controls := _label("A D / ← →   Move      SPACE   Jump      J   Sword      E   Listen      ESC   Pause",16,Color("a6bdab"))
	controls.name = "ControlsHint"
	controls.position = Vector2(34,680)
	control.add_child(controls)
	hint = _label("",22,Color("f5cc80"))
	hint.position = Vector2(430,600)
	control.add_child(hint)
	menu = _panel(control,Rect2(320,140,640,440))
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",18)
	menu.add_child(column)
	column.add_child(_label("A LIGHT BENEATH THE FOREST",15,Color("d5b77b")))
	column.add_child(_label("LANTERNS\nUNDERROOT",48))
	column.add_child(_label("The Hearthlight has gone dark.\nWalk the changed paths with Tavi and Mote.",20,Color("a6bdab")))
	column.add_child(_button("Begin the trail    ↵",_begin))
	column.add_child(_label("Chapter 1 · Initial playable prototype",14,Color("8ba39a")))
	pause_panel = _panel(control,Rect2(430,210,420,280))
	var pause_col := VBoxContainer.new()
	pause_col.add_theme_constant_override("separation",16)
	pause_panel.add_child(pause_col)
	pause_col.add_child(_label("A moment of stillness",28))
	pause_col.add_child(_button("Continue",_toggle_pause))
	pause_col.add_child(_button("Restart trail",_restart))
	pause_panel.hide()
	victory_panel = _panel(control,Rect2(290,170,700,380))
	var victory_col := VBoxContainer.new()
	victory_col.add_theme_constant_override("separation",20)
	victory_panel.add_child(victory_col)
	victory_col.add_child(_label("THE OLD ARCH ANSWERS",17,Color("e5bf75")))
	victory_col.add_child(_label("A fixed road is safe\nuntil the world needs to move.",30))
	victory_col.add_child(_label("Tavi copies the words. Mote taps three times, then twice.\nThe root-temple lies ahead. This prototype ends here.",18,Color("a6bdab")))
	victory_col.add_child(_button("Walk the trail again",_restart))
	victory_panel.hide()
	var pause_button := _button("Ⅱ",_toggle_pause)
	pause_button.name = "PauseButton"
	pause_button.position = Vector2(1210,20)
	control.add_child(pause_button)
	touch_layer = Control.new()
	touch_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.add_child(touch_layer)
	touch_layer.visible = OS.has_feature("mobile") or "--touch" in OS.get_cmdline_user_args()
	for spec in [["◀","move_left",40],["▶","move_right",130],["JUMP","jump",1000],["SWORD","attack",1100],["E","interact",900]]:
		var button := TouchScreenButton.new()
		var image := Image.create(80,70,false,Image.FORMAT_RGBA8)
		image.fill(Color(0.04,0.09,0.1,0.75))
		button.texture_normal = ImageTexture.create_from_image(image)
		var pressed_image := Image.create(80,70,false,Image.FORMAT_RGBA8)
		pressed_image.fill(Color(0.4,0.48,0.32,0.9))
		button.texture_pressed = ImageTexture.create_from_image(pressed_image)
		button.action = spec[1]
		button.position = Vector2(spec[2],590)
		var shape := RectangleShape2D.new()
		shape.size = Vector2(80,70)
		button.shape = shape
		var label := _label(spec[0],17)
		label.position = Vector2(8,23)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(label)
		touch_layer.add_child(button)

func _draw() -> void:
	for rect in platforms:
		draw_rect(rect,Color("263e38"))
		draw_rect(Rect2(rect.position,Vector2(rect.size.x,8)),Color("68836a"))
		draw_line(rect.position+Vector2(0,12),rect.position+Vector2(rect.size.x,12),Color("9caa73"),2)
		for i in int(rect.size.x/45):
			var x: float = rect.position.x+i*45+15
			draw_line(Vector2(x,rect.position.y+18),Vector2(x+13,rect.position.y+40),Color("344d43"),2)
			if i % 2 == 0:
				draw_line(Vector2(x,rect.position.y),Vector2(x-7,rect.position.y-12),Color("7e986c"),2)
	for light_seed in seeds:
		var p := light_seed+Vector2(0,sin(clock*3+light_seed.x)*5)
		draw_circle(p,18,Color(1,0.73,0.3,0.07))
		draw_circle(p,10,Color(1,0.73,0.3,0.15))
		draw_colored_polygon(PackedVector2Array([p+Vector2(0,-9),p+Vector2(5,0),p+Vector2(0,9),p+Vector2(-5,0)]),Color("f4cb7b"))
	# Lantern checkpoint, background trail markers and the old arch.
	for x in [180,1510,2720]:
		draw_line(Vector2(x,620),Vector2(x,470),Color("5d6550"),8)
		draw_line(Vector2(x,470),Vector2(x+35,470),Color("5d6550"),6)
		var lp := Vector2(x+31,500)
		draw_circle(lp,42,Color(1,0.7,0.25,0.05))
		draw_rect(Rect2(lp-Vector2(8,14),Vector2(16,28)),Color("e6b863") if x!=1510 or checkpoint_active else Color("6c796b"))
		draw_rect(Rect2(lp-Vector2(10,17),Vector2(20,34)),Color("777455"),false,3)
	draw_string(font,Vector2(70,445),"BRACKENREACH  ←",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("a5af8c"))
	draw_string(font,Vector2(1430,450),"RESTING LANTERN",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("a5af8c"))
	for x in [3250,3410]:
		draw_rect(Rect2(x,410,42,210),Color("51685d"))
		draw_rect(Rect2(x-7,403,56,22),Color("82937b"))
		draw_line(Vector2(x+20,445),Vector2(x+20,550),Color("a0b387"),3)
	draw_arc(Vector2(3350,425),80,PI,TAU,24,Color("728673"),32,true)
	draw_circle(Vector2(3350,467),10,Color("e4c482"))
	draw_string(font,Vector2(3245,360),"THE OLD ARCH",HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("d3c396"))
	if is_instance_valid(player):
		var mote := player.position+Vector2(-48,-45+sin(clock*3)*9)
		draw_circle(mote,22,Color(0.8,0.85,0.4,0.07))
		draw_circle(mote,9,Color("92ad6d"))
		draw_circle(mote+Vector2(4,-3),3,Color("fff0aa"))
