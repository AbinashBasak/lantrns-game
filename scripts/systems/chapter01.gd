extends "res://scripts/systems/prologue.gd"
## The connected first chapter. UI/dialogue/input preferences are shared with the opening.
const ChapterEnvironment = preload("res://scripts/systems/chapter01_environment.gd")
const ChapterPresentation = preload("res://scripts/presentation/chapter01_presentation.gd")
const SentinelScene = preload("res://scenes/enemies/hollow_sentinel.tscn")
const STORY_ART := "res://assets/runtime/chapter01/story/"
const BASE_PLATFORMS: Array[Rect2] = [Rect2(0,620,900,300),Rect2(1060,620,640,300),Rect2(1900,620,1400,300),Rect2(3900,620,5100,300),Rect2(880,740,220,28),Rect2(1680,740,240,28),Rect2(2040,535,170,25),Rect2(2240,450,180,25),Rect2(6600,530,170,25),Rect2(7890,530,170,25)]
const BRIDGE_PLATFORMS: Array[Rect2] = [Rect2(3320,610,150,28),Rect2(3510,560,150,28),Rect2(3710,610,150,28)]
const RUNE_ORDER: Array[int] = [0,1,2,1,2]
var environment: Node2D
var boss: CharacterBody2D
var bridge_open := false
var boss_active := false
var boss_defeated := false
var fragment_collected := false
var token_collected := false
var chapter_begun := false
var marker_read := false
var rune_progress := 0
var rune_attempts := 0
var puzzle_time := 0.0
var puzzle_gate: CollisionShape2D
var arena_entry: CollisionShape2D
var arena_exit: CollisionShape2D
var boss_ui: Control
var boss_health: TextureProgressBar
var rune_clue: Label
var feedback: Label
var feedback_time := 0.0
var memory: Control
var token_icon: Texture2D
var fragment_icon: Texture2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_inputs()
	font = ThemeDB.fallback_font
	dialogue_data = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/chapter01.json"))
	checkpoint = Vector2(150,590)
	environment = Node2D.new()
	environment.set_script(ChapterEnvironment)
	environment.platforms = BASE_PLATFORMS.duplicate()
	environment.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(environment)
	for rect in BASE_PLATFORMS: _make_platform(rect)
	puzzle_gate = _make_platform(Rect2(3270,180,30,440))
	arena_entry = _make_platform(Rect2(6500,180,25,440))
	arena_entry.disabled = true
	arena_exit = _make_platform(Rect2(8140,180,30,440))
	player = PlayerScene.instantiate()
	player.position = checkpoint
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	player.health_changed.connect(func(_value: int): _update_hud())
	player.died.connect(_respawn)
	camera = Camera2D.new()
	camera.position = Vector2(0,-260)
	camera.limit_left = 0
	camera.limit_right = 9000
	camera.limit_top = 0
	camera.limit_bottom = 800
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	mote = Node2D.new()
	mote.set_script(Mote)
	mote.target = player
	mote.rescued = true
	mote.was_rescued = true
	mote.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(mote)
	mote.position = player.position + Vector2(-58,-85)
	presentation = Node2D.new()
	presentation.set_script(ChapterPresentation)
	presentation.game = self
	presentation.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(presentation)
	player.action_event.connect(presentation.cue)
	_reset_trail_enemies()
	boss = SentinelScene.instantiate()
	boss.position = Vector2(7350,620)
	boss.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(boss)
	boss.health_changed.connect(_on_boss_health)
	boss.defeated.connect(_on_boss_defeated)
	token_icon = load(STORY_ART + "token.png")
	fragment_icon = load(STORY_ART + "fragment.png")
	_build_ui()
	var column := menu.get_child(0)
	column.get_child(2).text = "The Forgotten Trail\nFollow the markings to the first root-temple."
	column.get_child(3).text = "Begin Chapter 1    ↵"
	column.get_child(4).text = "Chapter 1 · The Forgotten Trail"
	objective.get_parent().get_node("ChapterLabel").text = "01   /   THE FORGOTTEN TRAIL"
	var victory := victory_panel.get_child(0)
	victory.get_child(0).text = "THE FORGOTTEN TRAIL — COMPLETE"
	victory.get_child(1).text = "First Golden Fragment recovered"
	victory.get_child(2).text = "The sword remembers an orchard.\nA newly opened passage leads toward Briarwake."
	victory.get_child(3).text = "Replay Chapter 1"
	_build_chapter_ui()
	_build_settings()
	PrologueSkin.apply(self)
	var completion_style := victory_panel.get_theme_stylebox("panel").duplicate()
	completion_style.content_margin_left = 70
	completion_style.content_margin_right = 70
	completion_style.content_margin_top = 65
	completion_style.content_margin_bottom = 55
	victory_panel.add_theme_stylebox_override("panel",completion_style)
	victory_panel.position = Vector2(260,150)
	victory_panel.size = Vector2(760,440)
	victory_panel.get_child(0).get_child(1).add_theme_font_size_override("font_size",26)
	pause_panel.get_child(0).get_child(2).text = "Restart chapter"
	_update_hud()
	get_tree().paused = true
	if get_tree().has_meta("from_prologue"):
		get_tree().remove_meta("from_prologue")
		_begin()

func _make_platform(rect: Rect2) -> CollisionShape2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	body.add_child(collision)
	add_child(body)
	return collision

func _build_chapter_ui() -> void:
	var root: Control = objective.get_parent()
	dialogue_box = _panel(root,Rect2(150,285,980,300))
	var column := VBoxContainer.new()
	dialogue_box.add_child(column)
	dialogue_label = _label("",21)
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.custom_minimum_size = Vector2(780,80)
	column.add_child(dialogue_label)
	var next := _button("Continue   E / Y / Enter",_advance_dialogue)
	next.focus_mode = Control.FOCUS_NONE
	column.add_child(next)
	dialogue_box.hide()
	rune_clue = _label("",18,Color("f2d392"))
	rune_clue.position = Vector2(34,115)
	rune_clue.size = Vector2(1050,70)
	rune_clue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(rune_clue)
	feedback = _label("",18,Color("d1e0b0"))
	feedback.position = Vector2(34,175)
	root.add_child(feedback)
	boss_ui = Control.new()
	boss_ui.position = Vector2(340,112)
	root.add_child(boss_ui)
	boss_ui.add_child(_label("HOLLOW SENTINEL",17,Color("ead19b")))
	boss_health = TextureProgressBar.new()
	boss_health.position = Vector2(0,25)
	boss_health.size = Vector2(600,42)
	boss_health.texture_under = load(STORY_ART + "boss_track.png")
	boss_health.texture_progress = load(STORY_ART + "boss_fill.png")
	boss_health.nine_patch_stretch = true
	boss_health.stretch_margin_left = 20
	boss_health.stretch_margin_right = 20
	boss_health.max_value = 24
	boss_health.value = 24
	boss_ui.add_child(boss_health)
	var frame := TextureRect.new()
	frame.texture = load(STORY_ART + "boss_frame.png")
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.position = Vector2(-8,18)
	frame.size = Vector2(616,56)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boss_ui.add_child(frame)
	boss_ui.hide()
	memory = Control.new()
	memory.position = Vector2(390,100)
	root.add_child(memory)
	for image in ["orchard_background","orchard_trees"]:
		var picture := TextureRect.new()
		picture.texture = load(STORY_ART + image + ".png")
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.size = Vector2(500,190)
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		memory.add_child(picture)
	memory.hide()

func _show_dialogue(key: String, on_done: Callable = Callable()) -> void:
	super._show_dialogue(key,on_done)
	if is_instance_valid(feedback):
		feedback_time = 0
		feedback.hide()
	if is_instance_valid(rune_clue): rune_clue.hide()
	_update_hud()

func _begin() -> void:
	super._begin()
	if not chapter_begun:
		chapter_begun = true
		_show_dialogue("intro")

func _process(delta: float) -> void:
	if not started and (Input.is_action_just_pressed("start") or Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("jump")):
		_begin()
		return
	if Input.is_action_just_pressed("restart") and started:
		_restart()
		return
	if Input.is_action_just_pressed("pause") and started and not completed:
		if settings_panel.visible:
			settings_panel.hide()
			pause_panel.show()
		else: _toggle_pause()
	if get_tree().paused: return
	clock += delta
	if not dialogue_lines.is_empty():
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("start"): _advance_dialogue()
		return
	mote.active = player.active
	mote.signaling = player.position.x > 2740 and player.position.x < 3300 and not bridge_open
	feedback_time = maxf(0,feedback_time-delta)
	feedback.visible = feedback_time > 0
	if not token_collected and player.position.distance_to(Vector2(2320,420)) < 55:
		token_collected = true
		presentation.cue("pickup",player.position)
		_notice("Hidden trail token found — optional discovery")
	if not checkpoint_active and player.position.distance_to(Vector2(6100,620)) < 80: _activate_checkpoint()
	if not checkpoint_active:
		if player.position.x > 4800: checkpoint = Vector2(4800,590)
		elif player.position.x > 4000 and bridge_open: checkpoint = Vector2(4100,590)
		elif player.position.x > 2000: checkpoint = Vector2(2600,590)
	if player.position.x > 6650 and not boss_active and not boss_defeated: _start_boss()
	if not boss_active:
		presentation.set_region("reward" if boss_defeated else ("temple" if player.position.x > 4500 else "forest"))
	if mote.signaling:
		puzzle_time += delta
		environment.rune_hint = RUNE_ORDER[rune_progress] if puzzle_time > 12 or rune_attempts > 0 else -1
	else: environment.rune_hint = -1
	var interaction := _nearby_interaction()
	hint.text = interaction[1]
	if Input.is_action_just_pressed("interact") and interaction[0] != "": interact_at(interaction[0])
	_update_hud()
	queue_redraw()

func _nearby_interaction() -> Array:
	var best := ""
	var prompt := ""
	var distance := 110.0
	var locations := [["marker",300.0,"Inspect the old trail marker"],["watchpost",2300.0,"Inspect the watchpost"],["arch",3220.0,"Listen to the ancient arch"],["relief",5300.0,"Inspect the carved relief"],["checkpoint",6100.0,"Touch the checkpoint mark"],["fragment",7950.0,"Collect the Golden Fragment"],["exit",8600.0,"Follow the passage to Briarwake"]]
	if not bridge_open:
		for i in 3: locations.append(["rune_%d" % i,2860.0+i*140,"Activate rune %s" % ["I","II","III"][i]])
	for entry in locations:
		if entry[0] == "fragment" and (not boss_defeated or fragment_collected): continue
		var d := absf(player.position.x-float(entry[1]))
		if d < distance and (absf(player.position.y-620) < 100 or (entry[0] == "watchpost" and player.position.y > 400 and player.position.y < 750)):
			distance = d
			best = entry[0]
			prompt = "E / Y   " + entry[2]
	return [best,prompt]

func interact_at(id: String) -> void:
	if not dialogue_lines.is_empty() or completed: return
	if id.begins_with("rune_"):
		activate_rune(int(id.get_slice("_",1)))
		return
	match id:
		"marker":
			marker_read = true
			_show_dialogue("marker")
		"watchpost": _show_dialogue("watchpost")
		"arch": _show_dialogue("arch" if not bridge_open else "bridge")
		"relief": _show_dialogue("relief")
		"checkpoint":
			_activate_checkpoint()
			_show_dialogue("checkpoint")
		"fragment": _collect_fragment()
		"exit":
			if fragment_collected: _show_dialogue("journal",_complete_chapter)
			else: _show_dialogue("exit_locked")

func activate_rune(index: int) -> void:
	if bridge_open or index < 0 or index > 2: return
	if index == RUNE_ORDER[rune_progress]:
		rune_progress += 1
		presentation.cue("rune",Vector2(2860+index*140,580))
		if rune_progress == RUNE_ORDER.size():
			_open_bridge()
	else:
		rune_progress = 0
		rune_attempts += 1
		_notice("The stones settle. Try again — no harm done.")
	environment.rune_progress = rune_progress

func _open_bridge() -> void:
	bridge_open = true
	environment.bridge_open = true
	puzzle_gate.set_deferred("disabled",true)
	for rect in BRIDGE_PLATFORMS: _make_platform(rect)
	presentation.cue("puzzle_complete",Vector2(3220,570))
	_show_dialogue("bridge")

func _activate_checkpoint() -> void:
	if checkpoint_active: return
	checkpoint_active = true
	checkpoint = Vector2(6100,590)
	environment.checkpoint_active = true
	player.health = 5
	player.health_changed.emit(5)
	presentation.cue("checkpoint",Vector2(6100,590))
	_notice("Root-temple checkpoint kindled")

func _start_boss() -> void:
	_activate_checkpoint()
	boss_active = true
	environment.boss_active = true
	arena_entry.set_deferred("disabled",false)
	camera.limit_left = 6460
	camera.limit_right = 8180
	feedback_time = 0
	feedback.hide()
	presentation.set_region("boss")
	boss.activate(player)
	boss_ui.show()

func _on_boss_health(value: int, maximum: int) -> void:
	if is_instance_valid(boss_health):
		boss_health.max_value = maximum
		boss_health.value = value

func _on_boss_defeated() -> void:
	boss_active = false
	boss_defeated = true
	environment.boss_active = false
	environment.boss_defeated = true
	arena_entry.set_deferred("disabled",true)
	arena_exit.set_deferred("disabled",true)
	camera.limit_left = 0
	camera.limit_right = 9000
	boss_ui.hide()
	presentation.set_region("reward")
	call_deferred("_show_dialogue","boss_defeat")

func _collect_fragment() -> void:
	if not boss_defeated or fragment_collected: return
	fragment_collected = true
	environment.fragment_collected = true
	presentation.cue("fragment",Vector2(7950,540))
	memory.show()
	_show_dialogue("fragment",func(): memory.hide())

func _complete_chapter() -> void:
	completed = true
	player.active = false
	mote.active = false
	victory_panel.show()
	get_tree().paused = true

func _reset_trail_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != boss:
			enemy.remove_from_group("enemies")
			enemy.queue_free()
	for x in [1300,2400]:
		var enemy := EnemyScene.instantiate()
		enemy.position = Vector2(x,600)
		enemy.health = 3
		enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(enemy)

func _respawn() -> void:
	player.reset_at(checkpoint)
	if not boss_defeated:
		boss_active = false
		environment.boss_active = false
		boss.reset_encounter()
		arena_entry.set_deferred("disabled",true)
		boss_ui.hide()
		camera.limit_left = 0
		camera.limit_right = 9000
	_reset_trail_enemies()
	camera.reset_smoothing()

func _notice(text: String) -> void:
	feedback.text = text
	feedback_time = 3.0

func _update_hud() -> void:
	if not is_instance_valid(hud): return
	hud.text = "TAVI    " + "♥ ".repeat(player.health) + "♡ ".repeat(5-player.health)
	var text := "Follow the old trail marker · Cross the broken roots"
	if player.position.x > 1900: text = "Investigate the ancient arch · Listen to Mote"
	if bridge_open: text = "Reach the root-temple · Inspect the carvings"
	if checkpoint_active: text = "Enter the Sentinel chamber"
	if boss_active: text = "Hollow Sentinel · Watch the wind-up, strike during recovery"
	if boss_defeated: text = "Collect the First Golden Fragment"
	if fragment_collected: text = "Follow the new passage toward Briarwake"
	objective.text = "CHAPTER 1  /  " + text + ("   ·   Trail token found" if token_collected else "")
	if is_instance_valid(rune_clue):
		rune_clue.visible = started and not get_tree().paused and mote.signaling and dialogue_lines.is_empty()
		var reveal := puzzle_time > 28 or rune_attempts >= 2
		rune_clue.text = ("I → II → III   ·   II → III" if reveal else "Three slow taps  ·  pause  ·  two quick taps") + "    [%d / 5]" % rune_progress

func _draw() -> void:
	if not started: return
	if not token_collected and token_icon:
		draw_texture_rect(token_icon,Rect2(2304,400+sin(clock*3)*4,32,32),false)
	if boss_defeated and not fragment_collected and fragment_icon:
		draw_texture_rect(fragment_icon,Rect2(7922,440+sin(clock*2)*6,56,70),false)
