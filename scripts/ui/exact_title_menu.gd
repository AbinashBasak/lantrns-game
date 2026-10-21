extends Control
## The user's reference is retained pixel-for-pixel; only the hit targets are added.
const ART := "res://assets/runtime/chapter01/ui/UI-016_exact_title_menu.png"
var game: Node
var background: TextureRect
var primary: Button
var replay: Button
var transition_pending := false
static func apply(target: Node, backdrop: TextureRect) -> void:
	var menu: Control = load("res://scripts/ui/exact_title_menu.gd").new()
	menu.name = "ExactTitleMenu"
	menu.game = target
	menu.background = backdrop
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	target.objective.get_parent().add_child(menu)
	menu.install()
func install() -> void:
	position = Vector2.ZERO
	size = Vector2(1280,720)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.texture = load(ART)
	background.light_mask = 2
	background.position = Vector2.ZERO
	background.size = Vector2(1280,720)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	game.menu.get_child(0).hide()
	game.menu.add_theme_stylebox_override("panel",StyleBoxEmpty.new())
	game.menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	primary = _target("BeginChapter",Rect2(110,420,490,71),activate_primary)
	primary.tooltip_text = "Begin Chapter 1"
	replay = _target("ReplayPrologue",Rect2(171,579,368,46),activate_replay)
	replay.tooltip_text = "Replay the prologue"
	var lighting := Node2D.new()
	lighting.set_script(load("res://scripts/ui/title_menu_lighting.gd"))
	lighting.game = game
	lighting.backdrop = background
	get_parent().add_child(lighting)
	get_parent().move_child(lighting,get_index())
func _target(title: String, rect: Rect2, action: Callable) -> Button:
	var button := Button.new()
	button.name = title
	button.position = rect.position
	button.size = rect.size
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:
		button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	button.pressed.connect(action)
	add_child(button)
	return button
func activate_primary() -> void:
	if transition_pending: return
	transition_pending = true
	if "jungle_area" in game:
		game._begin()
	else:
		get_tree().paused = false
		get_tree().set_meta("from_exact_title",true)
		get_tree().change_scene_to_file("res://scenes/levels/chapter01_forgotten_trail.tscn")
func activate_replay() -> void:
	if transition_pending: return
	transition_pending = true
	if "jungle_area" in game:
		get_tree().paused = false
		get_tree().set_meta("replay_from_title",true)
		get_tree().change_scene_to_file("res://scenes/levels/prologue_brackenreach.tscn")
	else: game._begin()
func _process(_delta: float) -> void:
	visible = game.menu.visible
