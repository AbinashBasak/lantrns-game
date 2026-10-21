extends "res://scripts/systems/prologue.gd"
## The connected first chapter. UI/dialogue/input preferences are shared with the opening.
const ChapterEnvironment = preload("res://scripts/systems/chapter01_environment.gd")
const ChapterPresentation = preload("res://scripts/presentation/chapter01_presentation.gd")
const SentinelScene = preload("res://scenes/enemies/hollow_sentinel.tscn")
const JungleArea = preload("res://scripts/systems/chapter01_jungle.gd")
const STORY_ART := "res://assets/runtime/chapter01/story/"
const BASE_PLATFORMS: Array[Rect2] = [Rect2(0,620,900,300),Rect2(1060,620,640,300),Rect2(1900,620,1400,300),Rect2(3900,620,5100,300),Rect2(880,740,220,28),Rect2(1680,740,240,28),Rect2(2040,535,170,25),Rect2(2240,450,180,25),Rect2(6600,530,170,25),Rect2(7890,530,170,25)]
const BRIDGE_PLATFORMS: Array[Rect2] = [Rect2(3320,610,150,28),Rect2(3510,560,150,28),Rect2(3710,610,150,28)]
const RUNE_ORDER: Array[int] = [0,1,2,1,2]
var rewards: Node2D
var jungle_cleared: Array[int] = []
var jungle_rooms: Array[Node2D] = []
var jungle_area := -1
var jungle_return := Vector2.ZERO
var jungle_discoveries: Array[int] = []
var jungle_enemies: Array[Node] = []
var jungle_label: Label
var environment: Node2D
var boss: CharacterBody2D
var bridge_open := false
var boss_active := false
var boss_defeated := false
var fragment_collected := false
var fragment_effect_time := 0.0
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
	_build_jungle_rooms()
	rewards = Node2D.new()
	rewards.set_script(load("res://scripts/systems/chapter01_rewards.gd"))
	rewards.game = self
	rewards.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(rewards)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != boss: rewards.watch_enemy(enemy,"trail:%d" % int(enemy.position.x))
	boss.phase_changed.connect(_on_boss_phase)
	_build_settings()
	PrologueSkin.apply(self)
	var completion_popup := Control.new()
	completion_popup.set_script(load("res://scripts/ui/chapter_complete_popup.gd"))
	completion_popup.install(self)
	var memory_popup := Node.new()
	memory_popup.name = "MemoryPopup"
	memory_popup.set_script(load("res://scripts/ui/memory_popup.gd"))
	memory_popup.install(self)
	load("res://scripts/ui/encounter_hud.gd").apply(self)
	load("res://scripts/ui/reward_scene_hud.gd").apply(self)
	pause_panel.get_child(0).get_child(2).text = "Restart chapter"
	var prologue_button := _button("Replay the prologue",_replay_prologue)
	menu.get_child(0).add_child(prologue_button)
	_update_hud()
	get_tree().paused = true
	if get_tree().has_meta("from_prologue") or get_tree().has_meta("from_exact_title"):
		get_tree().remove_meta("from_prologue")
		get_tree().remove_meta("from_exact_title")
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
		var title_menu := objective.get_parent().get_node_or_null("ExactTitleMenu")
		if title_menu: title_menu.activate_primary()
		else: _begin()
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
	fragment_effect_time = maxf(0.0,fragment_effect_time-delta)
	if not dialogue_lines.is_empty():
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("start"): _advance_dialogue()
		return
	if jungle_area >= 0:
		_process_jungle(delta)
		return
	mote.active = player.active
	mote.signaling = player.position.x > 2740 and player.position.x < 3300 and not bridge_open
	feedback_time = maxf(0,feedback_time-delta)
	feedback.visible = feedback_time > 0
	for index in 3:
		if not jungle_cleared.has(index) and (index == 0 or jungle_cleared.has(index-1)) and player.position.x >= JungleArea.ENTRANCES[index]:
			_enter_jungle(index)
			return
	if not token_collected and player.position.distance_to(Vector2(2320,420)) < 55:
		token_collected = true
		presentation.cue("pickup",player.position)
		_notice("Hidden trail token found — optional discovery")
	if not checkpoint_active and player.position.distance_to(Vector2(6100,620)) < 80: _activate_checkpoint()
	if not checkpoint_active:
		if player.position.x > 4800: checkpoint = Vector2(4800,590)
		elif player.position.x > 4000 and bridge_open: checkpoint = Vector2(4100,590)
		elif player.position.x > 2000: checkpoint = Vector2(2600,590)
	if player.position.x > 6650 and jungle_cleared.size() == 3 and not boss_active and not boss_defeated: _start_boss()
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
	if false:
		for entry in [["jungle_0",650.0,"Explore the high canopy"],["jungle_1",4250.0,"Descend into the flooded roots"],["jungle_2",5800.0,"Find the hidden lantern grove"]]: locations.append(entry)
	if rewards and rewards.chest_available and not rewards.chest_opened: locations.append(["chest",7780.0,"Open the Sentinel reward chest"])
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
	if id.begins_with("jungle_"):
		_enter_jungle(int(id.get_slice("_",1)))
		return
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
		"chest": rewards.open_chest()
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
	if rewards: rewards.award("trail_runes",300,Vector2(3220,570),"RUNE CROSSING SOLVED")
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
	player.restore_vitality()
	presentation.cue("checkpoint",Vector2(6100,590))
	_notice("Root-temple checkpoint kindled")

func _start_boss() -> void:
	if jungle_cleared.size() < 3: return
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

func _on_boss_phase(phase: String) -> void:
	boss_ui.get_child(0).text = "HOLLOW SENTINEL · " + phase.to_upper()
	if phase == "rejuvenating": _notice("The roots restore the Sentinel — brace for its berserk return!")
	elif phase == "berserk": _notice("BERSERK · Faster attacks and stronger strikes")

func _on_boss_health(value: int, maximum: int) -> void:
	if is_instance_valid(boss_health):
		boss_health.max_value = maximum
		boss_health.value = value

func _on_boss_defeated() -> void:
	boss_active = false
	boss_defeated = true
	rewards.chest_available = true
	rewards.award("sentinel_final",1000,boss.position,"SENTINEL OVERCOME")
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
	if not rewards.chest_opened:
		_notice("Open the Sentinel chest before taking the fragment.")
		return
	fragment_collected = true
	fragment_effect_time = 1.1
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
	for x in [1300,2400,4100,4800,5600]:
		var enemy := EnemyScene.instantiate()
		enemy.position = Vector2(x,600)
		enemy.health = 3
		enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(enemy)
		if rewards: rewards.watch_enemy(enemy,"trail:%d" % int(x))

func _respawn() -> void:
	if jungle_area >= 0:
		player.reset_at(Vector2(10150+jungle_area*JungleArea.SPACING,590))
		for enemy in jungle_enemies:
			if is_instance_valid(enemy): enemy.reset_encounter()
		camera.reset_smoothing()
		return
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
	if boss_defeated: text = "Open the Sentinel chest · Collect the Golden Fragment"
	if fragment_collected: text = "Follow the new passage toward Briarwake"
	objective.text = "CHAPTER 1  /  " + text + ("   ·   Trail token found" if token_collected else "")
	if is_instance_valid(rune_clue):
		rune_clue.visible = started and not get_tree().paused and mote.signaling and dialogue_lines.is_empty()
		var reveal := puzzle_time > 28 or rune_attempts >= 2
		rune_clue.text = ("I → II → III   ·   II → III" if reveal else "Three slow taps  ·  pause  ·  two quick taps") + "    [%d / 5]" % rune_progress

func _draw() -> void:
	if not started or jungle_area >= 0: return
	if not token_collected and token_icon:
		draw_texture_rect(token_icon,Rect2(2304,400+sin(clock*3)*4,32,32),false)
	var reduced: bool = presentation.reduced_effects
	var bob := 0.0 if reduced else sin(clock*2)*6.0
	var center := Vector2(7950,475+bob)
	if boss_defeated and not fragment_collected and fragment_icon:
		if not reduced:
			for ring in 2:
				var trail := PackedVector2Array()
				for i in 25:
					var phase := clock*1.25+ring*PI+float(i)/24.0*PI*1.35
					trail.append(center+Vector2(cos(phase)*45,sin(phase)*15+ring*18-9).rotated(-0.35))
				draw_polyline(trail,Color(1,0.73,0.2,0.65),1.6,true)
			for i in 9:
				var age := fposmod(clock*0.35+i*0.37,1.0)
				var at := center+Vector2(sin(i*2.4+clock*0.5)*42,35-age*120)
				_reward_spark(at,1.6+sin(age*PI),sin(age*PI)*0.7)
		draw_texture_rect(fragment_icon,Rect2(Vector2(7922,440+bob),Vector2(56,70)),false)
	if fragment_effect_time > 0 and not reduced:
		var progress := 1.0-fragment_effect_time/1.1
		draw_arc(Vector2(7950,475),25+progress*95,0,TAU,48,Color(1,0.8,0.3,(1-progress)*0.7),2,true)
		for i in 12:
			_reward_spark(Vector2(7950,475)+Vector2.from_angle(i*TAU/12.0)*(20+progress*100),2.5,(1-progress)*0.8)
	if fragment_collected and not reduced:
		for i in 5:
			var rise := fposmod(clock*0.2+i*0.21,1.0)
			_reward_spark(Vector2(8600+sin(i*2.0+clock*0.6)*29,615-rise*130),1.5,sin(rise*PI)*0.45)

func _reward_spark(at: Vector2, radius: float, alpha: float) -> void:
	var tint := Color(1,0.84,0.39,alpha)
	draw_line(at-Vector2(radius*1.5,0),at+Vector2(radius*1.5,0),tint,1.1,true)
	draw_line(at-Vector2(0,radius*2),at+Vector2(0,radius*2),tint,1.1,true)

func _replay_prologue() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/prologue_brackenreach.tscn")

func _build_jungle_rooms() -> void:
	for i in 3:
		var room := Node2D.new()
		room.set_script(JungleArea)
		room.area_index = i
		room.z_index = -1
		room.position = Vector2(10000+i*JungleArea.SPACING,0)
		room.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(room)
		jungle_rooms.append(room)
		room.puzzle_solved.connect(_on_jungle_puzzle)
	jungle_label = _label("",18,Color("f4d68c"))
	jungle_label.position = Vector2(34,145)
	jungle_label.size = Vector2(1150,60)
	objective.get_parent().add_child(jungle_label)
	jungle_label.hide()

func _enter_jungle(index: int) -> void:
	if index < 0 or index > 2 or boss_active: return
	if jungle_area < 0: jungle_return = player.position
	if jungle_area >= 0:
		jungle_rooms[jungle_area].active = false
		jungle_rooms[jungle_area].hide()
	jungle_area = index
	environment.hide()
	for layer in environment.forest_layers + environment.temple_layers: layer.hide()
	jungle_rooms[index].active = true
	jungle_rooms[index].show()
	camera.limit_left = 10000+index*JungleArea.SPACING
	camera.limit_right = camera.limit_left+JungleArea.WIDTH
	camera.limit_bottom = 830
	player.position = Vector2(camera.limit_left+160,590)
	player.velocity = Vector2.ZERO
	mote.position = player.position+Vector2(-58,-85)
	camera.reset_smoothing()
	_spawn_jungle_enemies(index)
	jungle_label.show()
	feedback.position.y = 205
	_notice("Follow the jungle path · Solve its seal to continue the journey")
	presentation.set_region("forest")

func _spawn_jungle_enemies(index: int) -> void:
	for enemy in jungle_enemies:
		if is_instance_valid(enemy): enemy.queue_free()
	jungle_enemies.clear()
	var path := "res://scripts/enemies/jungle_enemy.gd"
	if not ResourceLoader.exists(path): return
	for spot in JungleArea.enemy_spawns(index):
		var enemy := CharacterBody2D.new()
		enemy.set_script(load(path))
		enemy.variant = spot[1]
		enemy.position = Vector2(10000+index*JungleArea.SPACING+spot[0],610)
		enemy.patrol_min = enemy.position.x-100
		enemy.patrol_max = enemy.position.x+100
		enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(enemy)
		jungle_enemies.append(enemy)
		rewards.watch_enemy(enemy,"jungle:%d:%d" % [index,int(spot[0])])

func _on_jungle_puzzle(index: int) -> void:
	rewards.award("jungle_puzzle:%d" % index,400,player.position,"JUNGLE SEAL SOLVED")
	presentation.cue("puzzle_complete",player.position)
	_notice("The jungle seal opens · +400 trail points")

func _leave_jungle(_shortcut := false) -> void:
	if jungle_area < 0 or not jungle_rooms[jungle_area].puzzle_cleared: return
	var old := jungle_area
	if not jungle_cleared.has(old): jungle_cleared.append(old)
	jungle_rooms[old].active = false
	jungle_rooms[old].hide()
	jungle_area = -1
	for enemy in jungle_enemies:
		if is_instance_valid(enemy): enemy.queue_free()
	jungle_enemies.clear()
	environment.show()
	for layer in environment.forest_layers + environment.temple_layers: layer.show()
	camera.limit_left = 0
	camera.limit_right = 9000
	camera.limit_bottom = 800
	player.position = Vector2(JungleArea.MAIN_EXITS[old],590)
	player.velocity = Vector2.ZERO
	mote.position = player.position+Vector2(-58,-85)
	camera.reset_smoothing()
	jungle_label.hide()
	feedback.position.y = 175
	hint.text = ""
	_notice("Jungle route complete · %d / 3 seals passed" % jungle_cleared.size())

func _process_jungle(delta: float) -> void:
	mote.active = player.active
	mote.signaling = false
	feedback_time = maxf(0,feedback_time-delta)
	feedback.visible = feedback_time > 0
	var local := player.position-Vector2(10000+jungle_area*JungleArea.SPACING,0)
	var discovery := Vector2(1560,285) if jungle_area != 1 else Vector2(1510,305)
	if not jungle_discoveries.has(jungle_area) and local.distance_to(discovery) < 75:
		jungle_discoveries.append(jungle_area)
		jungle_rooms[jungle_area].discovered = true
		presentation.cue("pickup",player.position)
		_notice(["Canopy map: a route links the flooded roots to the lantern grove.","Rootkeeper note: the temple bells once guided travellers through these waters.","A dormant lantern seed. The grove remembers the orchard."][jungle_area])
	objective.text = "CHAPTER 1  /  " + JungleArea.NAMES[jungle_area]
	jungle_label.text = "Jungle memories %d / 3 · Solve the seal ahead to continue" % jungle_discoveries.size()
	hint.text = jungle_rooms[jungle_area].puzzle_hint(local)
	if Input.is_action_just_pressed("interact"):
		var message: String = jungle_rooms[jungle_area].interact_at(local)
		if not message.is_empty(): _notice(message)
	if local.x > JungleArea.EXIT_X and jungle_rooms[jungle_area].puzzle_cleared:
		_leave_jungle()
	if local.y > 900: _respawn()
	queue_redraw()
