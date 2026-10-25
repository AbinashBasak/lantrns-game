class_name C3SectionTransition
extends Area2D
## Explicit authored exits carry a spawn ID and a shared chapter-state Resource.
signal transition_failed(reason: String)
@export var enabled := true
@export var destination_scene: PackedScene
@export var destination_spawn_id := ""
@export var chapter_state: Resource
@export var arrival_guard_seconds := 0.2
var _transitioning := false
static var _pending: Dictionary = {}

func _ready() -> void:
	add_to_group("c3_section_exits")
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	# A timer alone is insufficient: the arrival body must leave ALL exits first.
	for player in get_tree().get_nodes_in_group("player"):
		if not player.get_meta("c3_arrival_blocked", false): continue
		if Time.get_ticks_msec() < int(player.get_meta("c3_arrival_guard_until", 0)): continue
		var overlapping := false
		for exit: Area2D in get_tree().get_nodes_in_group("c3_section_exits"):
			if exit.overlaps_body(player): overlapping = true
		if not overlapping: player.set_meta("c3_arrival_blocked", false)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): request_transition(body)

func validate_destination() -> String:
	if destination_scene == null: return "Exit has no destination scene."
	if not C3ChapterState.valid_id(destination_spawn_id): return "Exit has no valid destination spawn ID."
	var destination := destination_scene.instantiate()
	var marker := find_spawn(destination, destination_spawn_id)
	var player := find_player(destination)
	var reason := ""
	if marker == null: reason = "Destination is missing Marker2D spawn ID: " + destination_spawn_id
	elif player == null: reason = "Destination has no player with health and vitality."
	destination.free()
	return reason

func request_transition(player: Node2D) -> bool:
	if not enabled or _transitioning or not _pending.is_empty() or player.get_meta("c3_arrival_blocked", false): return false
	var reason := validate_destination()
	if not reason.is_empty():
		transition_failed.emit(reason)
		return false
	if not _has_property(player, &"health") or not _has_property(player, &"vitality"):
		transition_failed.emit("Transition player is missing health or vitality.")
		return false
	var state: Resource = chapter_state
	if state == null and get_tree().current_scene != null:
		state = get_tree().current_scene.get_meta("chapter3_state", null)
	if state == null:
		transition_failed.emit("Exit requires the shared Chapter 3 state Resource.")
		return false
	if not state is C3ChapterState:
		transition_failed.emit("Exit chapter_state must be C3ChapterState.")
		return false
	if int(player.get("health")) <= 0 or (_has_property(player, &"active") and not player.get("active")): return false
	_transitioning = true
	var snapshot := capture_player(player)
	state.player_health = snapshot.health
	state.player_vitality = snapshot.vitality
	if snapshot.has("inventory"): state.inventory = snapshot.inventory.duplicate(true)
	_pending = {"state": state, "player": snapshot, "spawn_id": destination_spawn_id, "guard_seconds": arrival_guard_seconds}
	if _has_property(player, &"active"): player.set("active", false)
	if player is CharacterBody2D: player.velocity = Vector2.ZERO
	call_deferred("_fade_and_swap", player)
	return true

func _fade_and_swap(player: Node2D) -> void:
	var animation: AnimationPlayer = get_node_or_null("FadeAnimationPlayer")
	if animation != null:
		animation.play(&"fade_out")
		await animation.animation_finished
	var tree := get_tree()
	tree.scene_changed.connect(_on_scene_changed.bind(tree), CONNECT_ONE_SHOT)
	var error := tree.change_scene_to_packed(destination_scene)
	if error != OK:
		tree.scene_changed.disconnect(_on_scene_changed.bind(tree))
		_pending.clear()
		_transitioning = false
		if is_instance_valid(player) and _has_property(player, &"active"): player.set("active", true)
		if animation != null: animation.play(&"fade_in")
		transition_failed.emit("Could not change section: " + error_string(error))

static func _on_scene_changed(tree: SceneTree) -> void:
	apply_pending_handoff(tree.current_scene)

static func apply_pending_handoff(scene: Node) -> bool:
	if _pending.is_empty() or not is_instance_valid(scene): return false
	var spawn := find_spawn(scene, _pending.spawn_id)
	var player := find_player(scene)
	if spawn == null or player == null: return false
	var state: Resource = _pending.state
	scene.set_meta("chapter3_state", state)
	# Native scene nodes restore themselves through one shared entry contract.
	for node in _descendants(scene):
		if _has_property(node, &"chapter_state"): node.set("chapter_state", state)
		if node.has_method("restore_chapter_state"): node.restore_chapter_state(state)
	apply_player_snapshot(player, _pending.player)
	player.global_position = spawn.global_position
	player.set_meta("c3_arrival_blocked", true)
	player.set_meta("c3_arrival_guard_until", Time.get_ticks_msec() + int(float(_pending.guard_seconds) * 1000))
	for node in _descendants(scene):
		if node is C3SectionTransition:
			var fade: AnimationPlayer = node.get_node_or_null("FadeAnimationPlayer")
			if fade != null:
				fade.play(&"fade_in")
				break
	_pending.clear()
	return true

static func capture_player(player: Node) -> Dictionary:
	var result := {"health": int(player.get("health")), "vitality": int(player.get("vitality"))}
	if _has_property(player, &"inventory") and player.get("inventory") is Dictionary:
		result.inventory = player.get("inventory").duplicate(true)
	return result

static func apply_player_snapshot(player: Node2D, snapshot: Dictionary) -> void:
	player.set("health", int(snapshot.health))
	player.set("vitality", int(snapshot.vitality))
	if snapshot.has("inventory") and _has_property(player, &"inventory"):
		player.set("inventory", snapshot.inventory.duplicate(true))
	if player is CharacterBody2D: player.velocity = Vector2.ZERO
	if _has_property(player, &"active"): player.set("active", true)
	if player.has_signal("health_changed"): player.emit_signal("health_changed", int(snapshot.health))
	if player.has_signal("vitality_changed"):
		var maximum := int(player.get("MAX_VITALITY")) if _has_property(player, &"MAX_VITALITY") else 100
		player.emit_signal("vitality_changed", int(snapshot.vitality), maximum)

static func find_spawn(scene: Node, id: String) -> Marker2D:
	for node in _descendants(scene):
		if node is Marker2D and String(node.get_meta("spawn_id", node.name)) == id: return node
	return null

static func find_player(scene: Node) -> Node2D:
	for node in _descendants(scene):
		if node is Node2D and _has_property(node, &"health") and _has_property(node, &"vitality"): return node
	return null

static func _has_property(object: Object, property: StringName) -> bool:
	for item: Dictionary in object.get_property_list():
		if item.name == property: return true
	return false

static func _descendants(node: Node) -> Array[Node]:
	var result: Array[Node] = [node]
	for child in node.get_children(): result.append_array(_descendants(child))
	return result
