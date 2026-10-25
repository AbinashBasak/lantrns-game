class_name C3InteractionController
extends Node
## One input owner, one closest valid interactable, one prompt channel.
signal prompt_changed(text: String, target: Node2D)
signal interacted(stable_id: String)
@export var player_path: NodePath
@export var interaction_radius := 110.0
@export var target_group: StringName = &"c3_interactables"
@export var input_action: StringName = &"interact"
var current_target: Node2D
var _prompt := ""

func _process(_delta: float) -> void:
	refresh_target()

func _unhandled_input(event: InputEvent) -> void:
	if InputMap.has_action(input_action) and event.is_action_pressed(input_action) and not event.is_echo():
		if interact_nearest(): get_viewport().set_input_as_handled()

func get_player() -> Node2D:
	if not player_path.is_empty(): return get_node_or_null(player_path) as Node2D
	return get_tree().get_first_node_in_group("player") as Node2D

func find_nearest(player: Node2D, candidates: Array) -> Node2D:
	if not is_instance_valid(player): return null
	var nearest: Node2D
	var nearest_distance := interaction_radius * interaction_radius
	var nearest_key := ""
	for candidate in candidates:
		if not is_instance_valid(candidate) or not candidate is Node2D or candidate.is_queued_for_deletion(): continue
		if not candidate.is_inside_tree() or not candidate.is_visible_in_tree(): continue
		var complete := true
		for method in [&"can_interact", &"interact", &"get_prompt_text", &"get_persistent_state_key"]:
			if not candidate.has_method(method): complete = false
		if not complete: continue
		var key: String = candidate.get_persistent_state_key()
		if not C3ChapterState.valid_id(key) or not candidate.can_interact(player): continue
		var distance: float = player.global_position.distance_squared_to(candidate.global_position)
		if distance < nearest_distance or (is_equal_approx(distance, nearest_distance) and (nearest == null or key < nearest_key)):
			nearest = candidate
			nearest_distance = distance
			nearest_key = key
	return nearest

func refresh_target() -> void:
	var selected := find_nearest(get_player(), get_tree().get_nodes_in_group(target_group))
	var text: String = selected.get_prompt_text() if selected != null else ""
	if selected != current_target or text != _prompt:
		current_target = selected
		_prompt = text
		prompt_changed.emit(text, selected)

func interact_nearest() -> bool:
	refresh_target()
	if not is_instance_valid(current_target): return false
	var player := get_player()
	if not current_target.can_interact(player): return false
	var key: String = current_target.get_persistent_state_key()
	current_target.interact(player)
	interacted.emit(key)
	refresh_target()
	return true
