extends Control
## Reward presentation follows the world chest; interaction remains controller-owned.
var game: Node
var chapter_banner: Control
var objective_text: Label
var chest_plaque: Control
var use_button: Button
var encounter: Control
var serif: SystemFont
var badge_active := false
var reward_active := false
var suppressed_hint := false
const Ornate = preload("res://scripts/ui/ornate_skin.gd")

static func apply(target: Node) -> void:
	var hud: Control = load("res://scripts/ui/reward_scene_hud.gd").new()
	hud.name = "RewardSceneHUD"
	hud.game = target
	hud.process_mode = Node.PROCESS_MODE_ALWAYS
	target.objective.get_parent().add_child(hud)
	hud._install()

func _install() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	encounter = get_parent().get_node_or_null("EncounterHUD")
	serif = Ornate.font()
	chapter_banner = _plaque(Vector2(25,104),Vector2(640,0))
	objective_text = _text(chapter_banner,"",Vector2(16,7),Vector2(610,28),15)
	chest_plaque = _plaque(Vector2.ZERO,Vector2(226,38))
	_text(chest_plaque,"SENTINEL’S CHEST",Vector2(12,7),Vector2(202,26),16).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	use_button = Button.new()
	use_button.name = "ChestUseButton"
	use_button.size = Vector2(102,37)
	use_button.text = "E  USE"
	use_button.add_theme_font_override("font",serif)
	use_button.add_theme_font_size_override("font_size",18)
	use_button.add_theme_color_override("font_color",Color("ffe6a3"))
	for state in ["normal","hover","pressed","focus"]:
		var style := Ornate.panel_style()
		style.modulate_color = Color("bce9cf") if state == "hover" else Color.WHITE
		use_button.add_theme_stylebox_override(state,style)
	use_button.pressed.connect(_use_chest)
	add_child(use_button)
	_process(0)

func _plaque(at: Vector2, bounds: Vector2) -> Control:
	var panel := PanelContainer.new()
	panel.position = at
	panel.size = bounds
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel",Ornate.panel_style())
	add_child(panel)
	return panel

func _text(parent: Control, content: String, at: Vector2, bounds: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.custom_minimum_size.x = bounds.x
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = content
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font",serif)
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("ffedb4"))
	label.add_theme_color_override("font_shadow_color",Color("051817"))
	label.add_theme_constant_override("shadow_offset_y",1)
	parent.add_child(label)
	return label

func _use_chest() -> void:
	if badge_active: game.interact_at("chest")

func objective_caption() -> String:
	if game.fragment_collected: return "◇  CHAPTER 1  /  Follow the new passage toward Briarwake"
	if game.rewards.chest_opened: return "◇  CHAPTER 1  /  Collect the Golden Fragment"
	return "◇  CHAPTER 1  /  Open the Sentinel chest · Collect the Golden Fragment"

func _process(_delta: float) -> void:
	if not is_instance_valid(game): return
	reward_active = game.boss_defeated and game.started and not game.menu.visible and not game.get_tree().paused and game.dialogue_lines.is_empty() and not game.memory.visible and not game.victory_panel.visible
	visible = reward_active
	if is_instance_valid(encounter):
		encounter.objective_panel.modulate.a = 0.0 if reward_active else 1.0
	objective_text.text = objective_caption()
	var width := get_viewport_rect().size.x
	objective_text.custom_minimum_size.x = minf(serif.get_string_size(objective_text.text,HORIZONTAL_ALIGNMENT_LEFT,-1,15).x,width-86)
	chapter_banner.size = Vector2(0,0)
	chest_plaque.size = Vector2(0,0)
	use_button.size = use_button.get_combined_minimum_size()
	var chest_visible: bool = reward_active and game.rewards.chest_available and not game.rewards.chest_opened
	chest_plaque.visible = chest_visible
	var projected: Vector2 = game.get_global_transform_with_canvas() * Vector2(7780,460)
	chest_plaque.visible = chest_visible and projected.x > -50 and projected.x < 1330
	chest_plaque.position = Vector2(clampf(projected.x-113,12,1042),clampf(projected.y,130,495))
	badge_active = chest_visible and absf(game.player.position.x-7780) < 135 and absf(game.player.position.y-620) < 100 and game.jungle_area < 0
	use_button.visible = badge_active
	var foot: Vector2 = game.get_global_transform_with_canvas() * Vector2(7780,592)
	use_button.position = Vector2(clampf(foot.x-51,12,1166),clampf(foot.y,170,580))
	if badge_active:
		game.hint.modulate.a = 0
		suppressed_hint = true
	elif suppressed_hint:
		game.hint.modulate.a = 1
		suppressed_hint = false
