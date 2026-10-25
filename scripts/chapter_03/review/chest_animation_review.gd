extends Node2D
## Isolated asset review controls. Animation data and state transitions live in the scene.

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var preview_button: Button = $ReviewUI/Panel/Controls/Buttons/Preview
@onready var status_label: Label = $ReviewUI/Panel/Controls/Status

var opening_requested := false
var last_state: StringName = &""

func _ready() -> void:
	get_viewport().size_changed.connect(_layout_review)
	_layout_review()
	reset_review()

func _layout_review() -> void:
	var viewport_size := get_viewport_rect().size
	$Chest.position = Vector2(viewport_size.x * 0.5, viewport_size.y - 170.0)

func preview_opening() -> void:
	if opening_requested or playback.get_current_node() != &"Closed":
		return
	opening_requested = true
	preview_button.disabled = true
	playback.travel(&"Opening")

func reset_review() -> void:
	opening_requested = false
	playback.start(&"Closed", true)
	animation_tree.advance(0.0)
	preview_button.disabled = false
	last_state = &""
	_update_status()

func _process(_delta: float) -> void:
	_update_status()

func _update_status() -> void:
	var state := playback.get_current_node()
	if state == last_state:
		return
	last_state = state
	status_label.text = "%s · six frames at 8 FPS" % state
