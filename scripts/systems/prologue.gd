extends "res://scripts/systems/main.gd"
## Session-based opening; the existing trail remains a separate playable scene.
const Mote = preload("res://scripts/companions/prologue_mote.gd")
const PrologueSkin = preload("res://scripts/ui/prologue_skin.gd")
const Presentation = preload("res://scripts/presentation/prologue_presentation.gd")
const VillageParallax = preload("res://scripts/systems/prologue_parallax.gd")
const Village = preload("res://scripts/systems/prologue_village.gd")
enum Beat { FESTIVAL, CART, RETURN, FAILURE, RESCUE, COMBAT, RUSK, EXIT }
var beat: Beat = Beat.FESTIVAL
var village: Node2D
var parallax: Node2D
var dialogue_data: Dictionary
var dialogue_lines: Array = []
var dialogue_index := 0
var dialogue_box: PanelContainer
var dialogue_label: Label
var dialogue_done: Callable
var failure_flash: ColorRect
var failure_time := 0.0
var failure_count := 0
var rescued := false
var mote: Node2D
var presentation: Node2D
var settings_panel: PanelContainer
var defeated_count := 0
var encounter_enemy: Node2D
var moved_once := false
var jumped_once := false
var story_checkpoint := Vector2(150, 590)
var camera: Camera2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_inputs()
	font = ThemeDB.fallback_font
	dialogue_data = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/prologue.json"))
	village = Node2D.new()
	village.set_script(Village)
	village.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(village)
	parallax = Node2D.new()
	parallax.set_script(VillageParallax)
	parallax.village = village
	parallax.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(parallax)
	player = PlayerScene.instantiate()
	player.position = story_checkpoint
	player.attack_enabled = false
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	player.health_changed.connect(func(_value: int): _update_hud())
	player.died.connect(_respawn)
	mote = Node2D.new()
	mote.set_script(Mote)
	mote.target = player
	mote.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(mote)
	mote.hide()
	presentation = Node2D.new()
	presentation.set_script(Presentation)
	presentation.game = self
	presentation.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(presentation)
	player.action_event.connect(presentation.cue)
	camera = Camera2D.new()
	camera.position = Vector2(0, -205)
	camera.limit_left = 0
	camera.limit_right = 4400
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	_build_ui()
	failure_flash = ColorRect.new()
	failure_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	failure_flash.color = Color(1, 1, 0.92, 0)
	failure_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	objective.get_parent().add_child(failure_flash)
	# Reuse input-accessible menus while presenting the opening's own text.
	var column := menu.get_child(0)
	column.get_child(2).text = "Lantern Wake in Brackenreach.\nOne ordinary errand before the light goes out."
	column.get_child(3).text = "Begin the prologue    ↵"
	column.get_child(4).text = "Prologue · The Night the Light Went Out"
	var controls := objective.get_parent().get_child(3)
	controls.text = "A D / ← →  Move     SPACE  Jump     J  Sword     E / Y  Interact & advance     ESC  Pause"
	objective.get_parent().get_child(2).text = "00   /   BRACKENREACH"
	dialogue_box = _panel(objective.get_parent(), Rect2(200, 370, 880, 185))
	var lines := VBoxContainer.new()
	dialogue_box.add_child(lines)
	dialogue_label = _label("", 22)
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.custom_minimum_size = Vector2(800, 85)
	lines.add_child(dialogue_label)
	var continue_button := _button("Continue   E / Y / Enter", _advance_dialogue)
	continue_button.focus_mode = Control.FOCUS_NONE
	lines.add_child(continue_button)
	dialogue_box.hide()
	_build_settings()
	PrologueSkin.apply(self)
	_update_hud()
	get_tree().paused = true
	if get_tree().has_meta("replay_from_title"):
		get_tree().remove_meta("replay_from_title")
		_begin()

func _process(delta: float) -> void:
	if not started and (Input.is_action_just_pressed("start") or Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("jump")):
		var title_menu := objective.get_parent().get_node_or_null("ExactTitleMenu")
		if title_menu: title_menu.activate_primary()
		else: _begin()
		return
	if Input.is_action_just_pressed("restart") and started:
		_restart()
		return
	if Input.is_action_just_pressed("pause") and started:
		if settings_panel.visible:
			settings_panel.hide()
			pause_panel.show()
		else:
			_toggle_pause()
	if get_tree().paused:
		return
	clock += delta
	if not dialogue_lines.is_empty():
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("start"):
			_advance_dialogue()
		queue_redraw()
		return
	if beat == Beat.FAILURE:
		failure_time += delta
		var flash_alpha := 0.0
		for flash_at in [0.8, 1.6]:
			flash_alpha = maxf(flash_alpha, maxf(0.0, 1.0 - absf(failure_time - flash_at) / 0.18) * 0.45)
		failure_flash.color.a = 0 if presentation.reduced_effects else flash_alpha
		camera.offset = Vector2(sin(failure_time * 44.0) * 4.0, 0) if failure_time > 2.0 and failure_time < 4.0 and not presentation.reduced_effects else Vector2.ZERO
		village.hearth_failed = failure_time >= 3.0
		hint.text = "The Hearthlight is failing…  E / Y to continue"
		if failure_time >= 6.0 or Input.is_action_just_pressed("interact"):
			_finish_failure()
		return
	if beat == Beat.RETURN and absf(player.position.x - 1200.0) < 100:
		_start_failure()
		return
	moved_once = moved_once or absf(player.velocity.x) > 30
	jumped_once = jumped_once or player.velocity.y < -100
	mote.active = player.active
	mote.rescued = rescued
	var interaction := _nearby_interaction()
	hint.text = interaction[1]
	if not moved_once:
		hint.text = "A D / ← → / left stick to move"
	elif not jumped_once and player.position.x < 620:
		hint.text = "SPACE / A / JUMP to cross the low log"
	if Input.is_action_just_pressed("interact") and interaction[0] != "":
		interact_at(interaction[0])
	_update_hud()
	queue_redraw()

func _nearby_interaction() -> Array:
	var locations := [["sign", 850.0, "Read the trail sign"], ["mapbook", 1400.0, "Check the mapbook"], ["villager", 650.0, "Talk to the villager"], ["hearth", 1200.0, "Inspect the Hearthlight"], ["cart", 1750.0, "Move the handcart"], ["beam", 2450.0, "Move the fallen beam"], ["rusk", 3700.0, "Speak to Rusk"], ["exit", 4200.0, "Enter the Forgotten Trail"]]
	for entry in locations:
		if entry[0] == "beam" and beat != Beat.RESCUE:
			continue
		if entry[0] == "cart" and beat != Beat.CART:
			continue
		if absf(player.position.x - entry[1]) < 105 and absf(player.position.y - 620) < 100:
			return [entry[0], "E / Y   " + entry[2]]
	return ["", ""]

func interact_at(id: String) -> void:
	if not dialogue_lines.is_empty() or beat == Beat.FAILURE:
		return
	match id:
		"villager": _show_dialogue("villager")
		"sign": _show_dialogue("sign")
		"mapbook": _show_dialogue("mapbook")
		"hearth":
			if beat == Beat.FESTIVAL:
				_show_dialogue("hearth", func(): beat = Beat.CART)
			elif beat == Beat.RETURN:
				_start_failure()
			else:
				_show_dialogue("hearth" if beat < Beat.FAILURE else "failure")
		"cart":
			if beat == Beat.CART:
				village.move_cart()
				presentation.cue("cart", Vector2(1750, 620))
				beat = Beat.RETURN
				_show_dialogue("cart")
		"beam":
			if beat == Beat.RESCUE:
				village.beam_moved = true
				rescued = true
				mote.rescued = true
				presentation.cue("rescue", Vector2(2450, 620))
				_show_dialogue("rescue", func(): _show_dialogue("weapon", _start_combat))
		"rusk":
			if beat == Beat.RUSK:
				_show_dialogue("rusk", func(): beat = Beat.EXIT)
			elif beat != Beat.EXIT:
				_show_dialogue("exit_locked")
		"exit":
			if beat == Beat.EXIT:
				get_tree().paused = false
				get_tree().set_meta("from_prologue", true)
				get_tree().change_scene_to_file("res://scenes/levels/chapter01_forgotten_trail.tscn")
			else:
				_show_dialogue("exit_locked")

func _show_dialogue(key: String, on_done: Callable = Callable()) -> void:
	# Keep speakers side by side if Tavi has walked into a non-solid NPC.
	if key in ["villager", "rusk"]:
		var speaker_x: float = 650.0 if key == "villager" else 3700.0
		if absf(player.position.x - speaker_x) < 55:
			player.position.x = speaker_x - 65 if player.position.x <= speaker_x else speaker_x + 65
			player.facing = signf(speaker_x - player.position.x)
			player.visual.flip_h = player.facing < 0
			player.visual.play("idle")
	dialogue_lines = dialogue_data.get(key, []).duplicate()
	dialogue_index = 0
	hint.text = ""
	dialogue_done = on_done
	player.active = false
	mote.active = false
	player.velocity = Vector2.ZERO
	player.attack_time = 0
	dialogue_box.show()
	dialogue_label.text = dialogue_lines[0] if not dialogue_lines.is_empty() else ""

func _advance_dialogue() -> void:
	if dialogue_lines.is_empty() or get_tree().paused:
		return
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		dialogue_label.text = dialogue_lines[dialogue_index]
		return
	dialogue_lines.clear()
	dialogue_box.hide()
	player.active = true
	mote.active = true
	presentation.cue("ui", Vector2.ZERO)
	var callback := dialogue_done
	dialogue_done = Callable()
	if callback.is_valid(): callback.call()
	_update_hud()

func _start_failure() -> void:
	beat = Beat.FAILURE
	failure_count += 1
	failure_time = 0
	presentation.fail_hearth()
	player.active = false
	mote.active = false
	player.velocity = Vector2.ZERO
	player.attack_time = 0

func _finish_failure() -> void:
	village.hearth_failed = true
	failure_flash.color.a = 0
	camera.offset = Vector2.ZERO
	mote.show()
	mote.active = true
	presentation.cue("debris", Vector2(2450, 610))
	beat = Beat.RESCUE
	story_checkpoint = Vector2(2180, 590)
	player.active = true
	_show_dialogue("failure")

func _start_combat() -> void:
	beat = Beat.COMBAT
	story_checkpoint = Vector2(2650, 590)
	player.attack_enabled = true
	_spawn_prologue_enemy(2910)

func _spawn_prologue_enemy(x: float) -> void:
	encounter_enemy = EnemyScene.instantiate()
	encounter_enemy.position = Vector2(x, 600)
	encounter_enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(encounter_enemy)
	encounter_enemy.defeated.connect(_enemy_defeated)

func _enemy_defeated() -> void:
	defeated_count += 1
	if defeated_count == 1:
		call_deferred("_spawn_prologue_enemy", 3220.0)
	elif defeated_count == 2:
		beat = Beat.RUSK
		story_checkpoint = Vector2(3450, 590)
		call_deferred("_show_dialogue", "combat_done")

func _respawn() -> void:
	player.reset_at(story_checkpoint)
	if beat == Beat.COMBAT:
		# Restart this small encounter consistently after defeat.
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.remove_from_group("enemies")
			enemy.queue_free()
		defeated_count = 0
		call_deferred("_spawn_prologue_enemy", 2910.0)

func _toggle_pause() -> void:
	super._toggle_pause()
	if get_tree().paused:
		pause_panel.get_child(0).get_child(1).grab_focus()
	if is_instance_valid(dialogue_box):
		dialogue_box.visible = not get_tree().paused and not dialogue_lines.is_empty()

func _update_hud() -> void:
	if not is_instance_valid(hud): return
	hud.text = "TAVI    " + "♥ ".repeat(player.health) + "♡ ".repeat(5 - player.health)
	var objectives := ["Visit the Hearthlight in the village square", "Help move the handcart at the outer bridge", "Return to the Hearthlight", "The Night the Light Went Out", "Free the creature beneath the fallen beam", "Protect the village · J / X / SWORD to attack", "Speak to Rusk at the old shelter", "Reach the Forgotten Trail →"]
	objective.text = "PROLOGUE  /  " + objectives[beat]

func _begin() -> void:
	super._begin()
	presentation.begin()

func _build_settings() -> void:
	settings_panel = _panel(objective.get_parent(), Rect2(370, 145, 540, 440))
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	settings_panel.add_child(column)
	column.add_child(_label("Sound & comfort", 28))
	for spec in [["Music", presentation.music_level], ["Effects", presentation.effects_level], ["Ambience", presentation.ambient_level]]:
		column.add_child(_label(spec[0], 18))
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = 1
		slider.step = 0.05
		slider.value = spec[1]
		slider.custom_minimum_size = Vector2(420, 26)
		slider.value_changed.connect(func(value: float): presentation.set_volume(spec[0], value))
		column.add_child(slider)
	var reduced := CheckButton.new()
	reduced.text = "Reduce flashes, camera shake & effects"
	reduced.button_pressed = presentation.reduced_effects
	reduced.toggled.connect(presentation.set_reduced_effects)
	column.add_child(reduced)
	column.add_child(_button("Back", func(): settings_panel.hide(); pause_panel.show()))
	settings_panel.hide()
	pause_panel.get_child(0).add_child(_button("Sound & comfort", func(): pause_panel.hide(); settings_panel.show()))

func _draw() -> void:
	# The opening owns its presentation; do not inherit trail pickups/checkpoint drawings.
	pass
