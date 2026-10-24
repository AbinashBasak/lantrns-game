extends "res://scripts/systems/prologue.gd"
## Chapter 2 uses existing environment exports and the illustrated LATE-001 guardian.
const Orchard = preload("res://scripts/systems/chapter02_environment.gd")
const RootPlatform = preload("res://scripts/props/moving_root_platform.gd")
const Guardian = preload("res://scripts/enemies/mossjaw.gd")
const OrchardAudio = preload("res://scripts/presentation/chapter01_presentation.gd")
const Jungle = preload("res://scripts/systems/chapter02_jungle.gd")
const OrchardEnemy = preload("res://scripts/enemies/orchard_enemy.gd")
const OrchardRewards = preload("res://scripts/systems/chapter02_rewards.gd")
const ChapterHUD = preload("res://scripts/ui/chapter02_hud.gd")
const ChapterTitle = preload("res://scripts/ui/chapter02_title.gd")
const OrchardLighting = preload("res://scripts/presentation/chapter02_lighting.gd")
const JUNGLE_ENTRANCES := [650.0,2550.0,3650.0,4750.0]
const JUNGLE_RETURNS := [850.0,2750.0,3850.0,4900.0]
const BINDINGS := [Vector2(1500, 450), Vector2(3300, 620), Vector2(4300, 620)]
var combat_feedback: Node
var memory: Control
var chapter_number := 2
var jungle_area := -1
var jungle_rooms: Array = []
var jungle_cleared: Array[bool] = [false,false,false,false]
var jungle_label: Label
var mission_text := ""
var rewards: Node2D
var feedback: Label
var feedback_time := 0.0
var lighting: Node2D
var orchard_enemies: Array = []
var family_recorded := false
var bindings_freed: Array[bool] = [false, false, false]
var boss_active := false
var boss_defeated := false
var fragment_collected := false
var carving_read := false
var environment: Node2D
var boss: CharacterBody2D
var grove_enemies: Array = [[], [], []]
var moving_roots: Array[AnimatableBody2D] = []
var orchard_gate: CollisionShape2D
var arena_entry: CollisionShape2D
var arena_exit: CollisionShape2D
var boss_label: Label
var guidance: Label
var guidance_text := ""
var guidance_time := 0.0
var completion_backdrop: ColorRect
var intro_seen := false
var boss_intro_seen := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_inputs()
	font = ThemeDB.fallback_font
	dialogue_data = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/chapter02.json"))
	platforms.assign([Rect2(0,620,1900,420),Rect2(2500,620,1900,420),Rect2(4700,620,2900,420),Rect2(1150,535,170,24),Rect2(1390,450,190,24),Rect2(2840,535,180,24),Rect2(3000,450,180,24),Rect2(3180,365,180,24),Rect2(5480,515,180,24),Rect2(5920,475,180,24),Rect2(6460,515,180,24)])
	for rect in platforms: _make_solid(rect)
	_make_solid(Rect2(-40,-200,40,1300))
	_make_solid(Rect2(7600,-200,40,1300))
	orchard_gate = _make_solid(Rect2(5020,0,36,620))
	arena_entry = _make_solid(Rect2(5180,0,24,620))
	arena_entry.disabled = true
	arena_exit = _make_solid(Rect2(6830,0,24,620))
	for spec in [[Vector2(1900,585),Vector2(380,0),190.0],[Vector2(4400,580),Vector2(150,0),170.0]]:
		var moving := RootPlatform.new()
		moving.origin = spec[0]
		moving.travel = spec[1]
		moving.width = spec[2]
		add_child(moving)
		moving_roots.append(moving)
	environment = Orchard.new()
	environment.game = self
	environment.platforms = platforms
	environment.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(environment)
	player = PlayerScene.instantiate()
	player.z_index = 4
	player.position = Vector2(160,590)
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	checkpoint = player.position
	player.health_changed.connect(func(_value: int): _update_hud())
	player.died.connect(_respawn)
	camera = Camera2D.new()
	camera.position = Vector2(0,-245)
	camera.limit_left = 0
	camera.limit_right = 7600
	camera.limit_top = -150
	camera.limit_bottom = 850
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	mote = Mote.new()
	mote.z_index = 6
	mote.target = player
	mote.rescued = true
	mote.was_rescued = true
	mote.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(mote)
	mote.position = player.position + Vector2(-58,-85)
	presentation = OrchardAudio.new()
	presentation.game = self
	presentation.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(presentation)
	player.action_event.connect(presentation.cue)
	player.action_event.connect(_player_combat_feedback)
	boss = Guardian.new()
	boss.position = Vector2(6200,620)
	boss.player = player
	boss.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(boss)
	boss.defeated.connect(_guardian_freed)
	boss.combat_feedback.connect(_combat_feedback)
	_build_ui()
	var root: Control = objective.get_parent()
	rewards = OrchardRewards.new()
	rewards.game = self
	rewards.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(rewards)
	_spawn_grove_enemies()
	_spawn_orchard_enemies()
	dialogue_box = _panel(root,Rect2(150,285,980,300))
	var dialogue_column := VBoxContainer.new()
	dialogue_box.add_child(dialogue_column)
	dialogue_label = _label("",21)
	dialogue_label.custom_minimum_size = Vector2(780,80)
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_column.add_child(dialogue_label)
	dialogue_column.add_child(_button("Continue   E / Y / Enter",_advance_dialogue))
	dialogue_box.hide()
	var column := menu.get_child(0)
	column.get_child(2).text = "The Guardian of Briarwake\nCross the orchard. Unbind the living roots."
	column.get_child(3).text = "Begin Chapter 2    ↵"
	column.get_child(4).text = "Chapter 2 · The Guardian of Briarwake"
	root.get_node("ChapterLabel").text = "02   /   BRIARWAKE ORCHARD"
	var victory := victory_panel.get_child(0)
	victory.get_child(0).text = "BRIARWAKE — COMPLETE"
	victory.get_child(1).text = "A guardian freed.\nThe first true Anchor fragment."
	victory.get_child(2).text = "Sable's warning points toward Glasswater Fen.\nChapter 3 is still to come."
	victory.get_child(3).text = "Replay Chapter 2"
	victory_panel.size = Vector2(760,480)
	victory_panel.position = Vector2(260,110)
	_build_settings()
	PrologueSkin.apply(self)
	var completion_style := victory_panel.get_theme_stylebox("panel").duplicate() as StyleBox
	completion_style.content_margin_top = 62
	completion_style.content_margin_left = 62
	completion_style.content_margin_right = 62
	completion_style.content_margin_bottom = 62
	victory_panel.add_theme_stylebox_override("panel",completion_style)
	completion_backdrop = ColorRect.new()
	completion_backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	completion_backdrop.color = Color(0.01,0.025,0.02,0.0)
	completion_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(completion_backdrop)
	root.move_child(completion_backdrop,victory_panel.get_index())
	completion_backdrop.hide()
	pause_panel.get_child(0).get_child(2).text = "Restart Chapter 2"
	guidance = _label("",18,Color("ffe5a3"))
	guidance.position = Vector2(34,157)
	guidance.size = Vector2(720,65)
	guidance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(guidance)
	boss_label = _label("",18,Color("ffe5a3"))
	boss_label.position = Vector2(380,225)
	boss_label.size = Vector2(720,72)
	boss_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(boss_label)
	for label in [guidance,boss_label]:
		label.add_theme_color_override("font_shadow_color",Color("081719"))
		label.add_theme_constant_override("shadow_outline_size",6)
	# The shared skin preserves all five hearts and the existing vitality artwork.
	hint.position = Vector2(34,122)
	hint.size = Vector2(820,40)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	jungle_label = _label("",16)
	feedback = _label("",16)
	root.add_child(jungle_label)
	root.add_child(feedback)
	for i in 4:
		var room := Jungle.new()
		room.area_index = i
		room.game = self
		add_child(room)
		room.solved.connect(_jungle_solved)
		room.exited.connect(_leave_jungle)
		jungle_rooms.append(room)
	lighting = OrchardLighting.new()
	lighting.game = self
	add_child(lighting)
	memory = Control.new()
	memory.name = "OrchardMemory"
	root.add_child(memory)
	for file in ["orchard_background","orchard_trees"]:
		var picture := TextureRect.new()
		picture.texture = load("res://assets/runtime/chapter01/story/"+file+".png")
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		memory.add_child(picture)
	memory.hide()
	var memory_popup := Node.new()
	memory_popup.set_script(load("res://scripts/ui/memory_popup.gd"))
	memory_popup.install(self)
	combat_feedback = load("res://scripts/presentation/combat_feedback.gd").new()
	combat_feedback.game = self
	add_child(combat_feedback)
	ChapterHUD.apply(self)
	ChapterTitle.apply(self)
	var completion_popup := Control.new()
	completion_popup.set_script(load("res://scripts/ui/chapter_complete_popup.gd"))
	completion_popup.install(self)
	for label in [boss_label,guidance,jungle_label,feedback]: label.self_modulate.a = 0
	_update_hud()
	get_tree().paused = true
	if get_tree().has_meta("from_chapter01"):
		get_tree().remove_meta("from_chapter01")
		_begin()

func _make_solid(rect: Rect2) -> CollisionShape2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	body.process_mode = Node.PROCESS_MODE_PAUSABLE
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	body.add_child(collision)
	add_child(body)
	return collision

func _spawn_grove_enemies() -> void:
	for i in 3:
		if bindings_freed[i]: continue
		for enemy in grove_enemies[i]:
			if is_instance_valid(enemy):
				enemy.remove_from_group("enemies")
				enemy.queue_free()
		grove_enemies[i] = []
		var encounter := 0
		for x in [[1260.0],[3100.0],[4100.0,4350.0]][i]:
			var enemy := EnemyScene.instantiate()
			enemy.position = Vector2(x,620)
			enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
			add_child(enemy)
			grove_enemies[i].append(enemy)
			rewards.watch_enemy(enemy,"grove_%d_%d" % [i,encounter])
			encounter += 1

func _begin() -> void:
	super._begin()
	if not intro_seen:
		intro_seen = true
		_show_dialogue("intro")

func _process(delta: float) -> void:
	if not started:
		if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("jump"): _begin()
		return
	if Input.is_action_just_pressed("restart"):
		_restart()
		return
	if Input.is_action_just_pressed("pause") and not completed:
		if settings_panel.visible:
			settings_panel.hide()
			pause_panel.show()
		else: _toggle_pause()
	if get_tree().paused: return
	if not dialogue_lines.is_empty():
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("start"): _advance_dialogue()
		return
	clock += delta
	feedback_time = maxf(0.0,feedback_time-delta)
	guidance_time = maxf(0,guidance_time-delta)
	guidance.modulate.a = minf(1,guidance_time/0.4)
	mote.active = player.active
	mote.signaling = jungle_area < 0 and bindings_freed.count(true) == 3 and not carving_read
	if jungle_area >= 0:
		var room = jungle_rooms[jungle_area]
		room.process_room(delta)
		var nearby_room := _nearby_interaction()
		hint.text = nearby_room[1]
		if Input.is_action_just_pressed("interact") and nearby_room[0] != "": interact_at(nearby_room[0])
		_update_hud()
		return
	for i in 4:
		if not jungle_cleared[i] and player.position.x >= JUNGLE_ENTRANCES[i]:
			_enter_jungle(i)
			_update_hud()
			return
	if player.position.x > 2600 and checkpoint.x < 2500: checkpoint = Vector2(2600,590)
	if player.position.x > 4750 and not checkpoint_active:
		checkpoint_active = true
		checkpoint = Vector2(4850,590)
		_notice("Orchard checkpoint kindled. Freed groves stay free after a retry.")
	if player.position.x > 5280 and not boss_active and not boss_defeated and carving_read and jungle_cleared.count(true)==4:
		_start_guardian()
	var nearby := _nearby_interaction()
	hint.text = nearby[1]
	if Input.is_action_just_pressed("interact") and nearby[0] != "": interact_at(nearby[0])
	if player.position.x > 1650 and player.position.x < 2500: _notice("Wait for the moving root. Jump aboard, ride, then jump to the far bank.")
	_update_hud()

func _notice(value: String) -> void:
	if value == guidance_text: return
	guidance_text = value
	guidance.text = value
	guidance_time = 5.0
	if is_instance_valid(feedback):
		feedback.text = value
		feedback_time = 5.0

func _nearby_interaction() -> Array:
	if jungle_area >= 0: return jungle_rooms[jungle_area].nearby_interaction()
	if is_instance_valid(rewards) and rewards.chest_available and not rewards.chest_opened and player.position.distance_to(Vector2(6570,620)) < 110:
		return ["chest","E / Y   Open Mossjaw’s reward chest"]
	for i in 3:
		if not bindings_freed[i] and jungle_cleared[i] and player.position.distance_to(BINDINGS[i]) < 105:
			return ["binding_%d" % i,"E / Y   Cut grove binding %d" % (i+1)]
	for entry in [["carving",Vector2(4890,620),"Listen to the voice in the bark"],["family",Vector2(3270,365),"Read the family carving"],["fragment",Vector2(6720,620),"Recover the Anchor fragment"],["exit",Vector2(7310,620),"Follow Sable's warning"]]:
		if entry[0] == "fragment" and (not boss_defeated or fragment_collected or not rewards.chest_opened): continue
		if player.position.distance_to(entry[1]) < 105: return [entry[0],"E / Y   " + entry[2]]
	if boss_active and boss.state == "recover":
		if not boss.binding_exposed and boss.health <= 9 and absf(player.position.x-6410) < 110 and absf(player.position.y-620) < 85:
			return ["column","E / Y   Break the column · optional rescue"]
		if boss.binding_exposed and player.position.distance_to(boss.position) < 160:
			return ["guardian_binding","E / Y   Cut an exposed binding"]
	return ["",""]

func interact_at(id: String) -> void:
	if completed or not dialogue_lines.is_empty(): return
	# Resolve proximity again: scripted or repeated interactions cannot bypass the route.
	if _nearby_interaction()[0] != id: return
	if jungle_area >= 0:
		jungle_rooms[jungle_area].interact_at(id)
		return
	if id == "chest":
		rewards.open_chest()
	elif id.begins_with("binding_"):
		var index := int(id.get_slice("_",1))
		if not jungle_cleared[index]: return
		bindings_freed[index] = true
		rewards.award("binding_%d" % index,250,BINDINGS[index],"GROVE BINDING FREED")
		for enemy in grove_enemies[index]:
			if is_instance_valid(enemy):
				enemy.remove_from_group("enemies")
				enemy.queue_free()
		presentation.cue("rune",BINDINGS[index])
		_show_dialogue("binding")
	elif id == "carving":
		if bindings_freed.count(true) < 3 or jungle_cleared.count(true) < 4: _show_dialogue("carving_locked")
		else:
			carving_read = true
			orchard_gate.set_deferred("disabled",true)
			_show_dialogue("voice")
	elif id == "family":
		family_recorded = true
		rewards.award("family_record",200,Vector2(3270,365),"ORCHARD FAMILY RECORD")
		_show_dialogue("family")
	elif id == "column": boss.strike_column()
	elif id == "guardian_binding": boss.cut_binding()
	elif id == "fragment":
		fragment_collected = true
		presentation.cue("fragment",player.position)
		memory.show()
		_show_dialogue("memory",func(): memory.hide())
	elif id == "exit":
		if fragment_collected: _show_dialogue("sable",_complete_chapter)
		else: _show_dialogue("exit_locked")

func _start_guardian() -> void:
	if jungle_area >= 0 or jungle_cleared.count(true) < 4 or bindings_freed.count(true) < 3 or not carving_read: return
	boss_active = true
	arena_entry.set_deferred("disabled",false)
	camera.limit_left = 5200
	camera.limit_right = 6840
	presentation.set_region("boss")
	if not boss_intro_seen:
		boss_intro_seen = true
		_show_dialogue("guardian",func(): boss.activate())
	else: boss.activate()

func _guardian_freed() -> void:
	boss_active = false
	boss_defeated = true
	rewards.chest_available = true
	rewards.award("mossjaw_freed",1200,boss.position,"MOSSJAW FREED")
	arena_entry.set_deferred("disabled",true)
	arena_exit.set_deferred("disabled",true)
	camera.limit_left = 0
	camera.limit_right = 7600
	presentation.set_region("reward")
	_show_dialogue("freed")

func _respawn() -> void:
	if is_instance_valid(combat_feedback): combat_feedback.clear()
	if jungle_area >= 0:
		var room = jungle_rooms[jungle_area]
		player.reset_at(room.entry_point())
		rewards.preserve_checkpoint()
		room.reset_enemies()
		_set_jungle_camera(jungle_area)
		mote.position = player.position+Vector2(-58,-85)
		camera.reset_smoothing()
		_notice("Jungle checkpoint rekindled · Solved seals, discoveries and points are kept.")
		return
	player.reset_at(checkpoint)
	rewards.preserve_checkpoint()
	if not boss_defeated:
		boss_active = false
		boss.reset_encounter()
		arena_entry.set_deferred("disabled",true)
		camera.limit_left = 0
		camera.limit_right = 7600
		presentation.set_region("forest")
	_spawn_grove_enemies()
	_spawn_orchard_enemies()
	camera.reset_smoothing()

func _complete_chapter() -> void:
	completed = true
	get_tree().set_meta("chapter2_result", {"points":rewards.points,"attack_damage":player.attack_damage,"jungles":jungle_cleared.duplicate(),"guardian_freed":boss_defeated,"fragment_collected":fragment_collected})
	player.active = false
	mote.active = false
	guidance.hide()
	boss_label.hide()
	completion_backdrop.show()
	victory_panel.show()
	victory_panel.get_child(0).get_child(3).grab_focus()
	get_tree().paused = true

func _update_hud() -> void:
	if not is_instance_valid(hud): return
	hud.text = "TAVI    " + "♥ ".repeat(player.health) + "♡ ".repeat(5-player.health)
	var task := "Explore four jungle routes and free the three grove bindings"
	mission_text = "Jungles restored %d / 4 · Grove bindings %d / 3" % [jungle_cleared.count(true),bindings_freed.count(true)]
	if jungle_area >= 0:
		var room = jungle_rooms[jungle_area]
		task = room.INSTRUCTIONS[jungle_area] if not room.completed else "The seal is open · Follow the eastern path"
		jungle_label.text = room.NAMES[jungle_area]
		mission_text = "Seal sequence %d / 3 · %s" % [room.progress,"Discovery recorded" if room.discovered else "Hidden record above the roots"]
	else:
		jungle_label.text = ""
		if bindings_freed.count(true) == 3 and jungle_cleared.count(true) == 4: task = "Follow Mote to the voice in the bark"
		if carving_read: task = "Defeat Mossjaw · Strike its body from either side and dodge the warnings"
		if boss_defeated: task = "Open Mossjaw’s reward chest" if not rewards.chest_opened else "Recover the first true Anchor fragment"
		if fragment_collected: task = "Follow the path toward Glasswater Fen →"
	objective.text = "BRIARWAKE  /  " + task
	if not is_instance_valid(boss_label): return
	boss_label.visible = boss_active
	if boss_active:
		boss_label.text = "MOSSJAW   %d / %d   ·   %s" % [boss.health,boss.max_health,boss.state.replace("_"," ").to_upper()]
		if boss.binding_exposed:
			boss_label.text += "\nBindings freed: %d / 3 · E beside Mossjaw during recovery" % boss.freed_bindings
		elif boss.health <= 9: boss_label.text += "\nBreak column during recovery: %d / 3" % boss.column_hits
		else: boss_label.text += "\nStrike any part of its body · Dodge the marked attacks."

func _spawn_orchard_enemies() -> void:
	for enemy in orchard_enemies:
		if is_instance_valid(enemy):
			enemy.remove_from_group("enemies")
			enemy.queue_free()
	orchard_enemies.clear()
	if boss_defeated: return
	for i in 6:
		var enemy := OrchardEnemy.new()
		enemy.variant = i%3
		enemy.position = Vector2([420.0,1020.0,1650.0,2730.0,3590.0,4850.0][i],620)
		add_child(enemy)
		orchard_enemies.append(enemy)
		rewards.watch_enemy(enemy,"orchard_patrol_%d" % i)

func _set_jungle_camera(index: int) -> void:
	camera.limit_left = 11000+index*6000
	camera.limit_right = camera.limit_left+4800
	camera.limit_top = -150
	camera.limit_bottom = 850
	camera.reset_smoothing()

func _enter_jungle(index: int) -> void:
	if index < 0 or index >= jungle_rooms.size() or jungle_cleared[index]: return
	jungle_area = index
	var room = jungle_rooms[index]
	room.enter()
	player.position = room.entry_point()
	player.velocity = Vector2.ZERO
	checkpoint = player.position
	mote.position = player.position+Vector2(-58,-85)
	_set_jungle_camera(index)
	for enemy in orchard_enemies:
		if is_instance_valid(enemy): enemy.active = false
	_notice("Expedition checkpoint saved · Optional records wait on the upper route.")
	presentation.cue("checkpoint",player.position)

func _jungle_solved(index: int) -> void:
	# The room awards its own stable puzzle key. Completion requires walking out.
	_notice(jungle_rooms[index].NAMES[index] + " restored · Follow the eastern path back to Briarwake")

func _leave_jungle(index: int) -> void:
	if jungle_area != index or not jungle_rooms[index].completed: return
	jungle_cleared[index] = true
	jungle_rooms[index].leave()
	jungle_area = -1
	player.position = Vector2(JUNGLE_RETURNS[index],590)
	player.velocity = Vector2.ZERO
	checkpoint = player.position
	mote.position = player.position+Vector2(-58,-85)
	camera.limit_left = 0
	camera.limit_right = 7600
	camera.reset_smoothing()
	for enemy in orchard_enemies:
		if is_instance_valid(enemy): enemy.active = true
	_notice("Returned to Briarwake · Jungle %d / 4 restored · Checkpoint saved" % jungle_cleared.count(true))

func _replay_chapter01() -> void:
	get_tree().paused = false
	get_tree().remove_meta("campaign_progress")
	get_tree().set_meta("from_exact_title",true)
	get_tree().change_scene_to_file("res://scenes/levels/chapter01_forgotten_trail.tscn")

func _draw() -> void:
	pass

func _combat_feedback(kind: String, strength: float) -> void:
	if is_instance_valid(combat_feedback): combat_feedback.pulse(kind,strength)

func _player_combat_feedback(kind: String, _at: Vector2) -> void:
	if kind == "hurt": _combat_feedback("player_hurt",0.65)
