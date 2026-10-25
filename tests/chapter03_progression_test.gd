extends SceneTree

const StateResource = preload("res://scripts/chapter_03/core/chapter_state.gd")
const Interaction = preload("res://scripts/chapter_03/core/interaction_controller.gd")
const Transition = preload("res://scripts/chapter_03/core/section_transition.gd")
const SAVE_PATH := "/tmp/lantrns_c3_progression_test.json"

class Interactable extends Node2D:
	var allowed := true
	var used := false
	var stable_id := "C3-CHEST-TEST"
	func can_interact(_player: Node2D) -> bool: return allowed and not used
	func interact(_player: Node2D) -> void: used = true
	func get_prompt_text() -> String: return "Open chest"
	func get_persistent_state_key() -> String: return stable_id

func _initialize() -> void: call_deferred("validate")

func validate() -> void:
	var state := StateResource.new()
	for category in StateResource.FLAG_CATEGORIES:
		assert(state.set_flag(category, "C3-TEST-001"))
	assert(not state.set_flag(&"keys", "Gameplay/Key"))
	state.water_levels = {"C3-DRAIN-001": "lowered"}
	state.mirrors = {"C3-MIRROR-001": 2}
	state.inventory = {"C3-COIN": 12}
	state.checkpoint_id = "C3-CHECKPOINT-001"
	state.player_health = 3
	state.player_vitality = 41
	assert(state.save_atomic(SAVE_PATH) == OK)
	var restored := StateResource.new()
	assert(restored.load_save(SAVE_PATH) == OK)
	assert(restored.to_dictionary() == state.to_dictionary())
	assert(not FileAccess.file_exists(SAVE_PATH + ".tmp"))
	var previous := restored.to_dictionary()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string("{malformed")
	file.close()
	assert(restored.load_save(SAVE_PATH) == ERR_INVALID_DATA)
	assert(restored.to_dictionary() == previous)
	assert(state.save_atomic(SAVE_PATH) == OK)
	var invalid := state.to_dictionary()
	invalid.inventory = {"C3-COIN": -5}
	assert(restored.restore_dictionary(invalid) == ERR_INVALID_DATA)
	assert(restored.to_dictionary() == previous)
	var fresh := StateResource.new()
	assert(fresh.complete_after_victory("C3-BOSS-FINAL", SAVE_PATH) == ERR_UNAVAILABLE)
	assert(not fresh.chapter_completed)
	fresh.set_flag(&"defeated_bosses", "C3-BOSS-FINAL")
	assert(fresh.complete_after_victory("C3-BOSS-FINAL", "/tmp/missing_c3_test_directory/save.json") != OK)
	assert(not fresh.chapter_completed)
	assert(fresh.complete_after_victory("C3-BOSS-FINAL", SAVE_PATH) == OK)
	assert(restored.load_save(SAVE_PATH) == OK and restored.chapter_completed)
	print("PASS: all stable progress categories, atomic reload, malformed snapshot isolation, victory + durable-save completion")

	var stage := Node2D.new()
	root.add_child(stage)
	current_scene = stage
	var player = load("res://scenes/player/player.tscn").instantiate()
	stage.add_child(player)
	player.set_physics_process(false)
	player.health = 3
	player.vitality = 41
	var interaction := Interaction.new()
	stage.add_child(interaction)
	interaction.set_process(false)
	var blocked := Interactable.new()
	blocked.allowed = false
	blocked.position.x = 10
	stage.add_child(blocked)
	blocked.add_to_group("c3_interactables")
	var far := Interactable.new()
	far.position.x = 90
	far.stable_id = "C3-CHEST-FAR"
	stage.add_child(far)
	far.add_to_group("c3_interactables")
	var near := Interactable.new()
	near.position.x = 40
	stage.add_child(near)
	near.add_to_group("c3_interactables")
	assert(interaction.find_nearest(player, [blocked, far, near]) == near)
	assert(interaction.interact_nearest() and near.used and not blocked.used)
	assert(interaction.current_target == far)
	far.position.x = 111
	assert(not interaction.interact_nearest())
	print("PASS: uniform interaction selects nearest valid target and refreshes consumed/out-of-range prompts")

	# Pack a real player scene and Marker2D fixture, with no generated art/layout.
	var destination := Node2D.new()
	destination.name = "DestinationFixture"
	var destination_player = load("res://scenes/player/player.tscn").instantiate()
	destination.add_child(destination_player)
	destination_player.owner = destination
	var spawn := Marker2D.new()
	spawn.name = "EntranceFromS01"
	spawn.position = Vector2(320, 200)
	destination.add_child(spawn)
	spawn.owner = destination
	var arrival_exit = load("res://scenes/chapter_03/core/section_exit.tscn").instantiate()
	destination.add_child(arrival_exit)
	arrival_exit.owner = destination
	arrival_exit.position = spawn.position
	var packed := PackedScene.new()
	assert(packed.pack(destination) == OK)
	destination.free()
	var exit = load("res://scenes/chapter_03/core/section_exit.tscn").instantiate()
	stage.add_child(exit)
	exit.set_physics_process(false)
	exit.destination_scene = packed
	exit.chapter_state = state
	exit.destination_spawn_id = "missing"
	exit.enabled = true
	assert(not exit.validate_destination().is_empty())
	assert(not exit.request_transition(player) and player.active)
	exit.destination_spawn_id = "EntranceFromS01"
	assert(exit.validate_destination().is_empty())
	assert(exit.request_transition(player))
	assert(not exit.request_transition(player))
	await scene_changed
	await process_frame
	var next_player := Transition.find_player(current_scene)
	next_player.set_physics_process(false)
	assert(next_player.health == 3 and next_player.vitality == 41)
	assert(next_player.global_position.distance_to(Vector2(320, 200)) < 5)
	assert(current_scene.get_meta("chapter3_state") == state)
	assert(state.inventory == {"C3-COIN": 12})
	assert(next_player.get_meta("c3_arrival_blocked", false))
	var next_exit = current_scene.get_node("SectionExit")
	next_exit.enabled = true
	next_exit.destination_scene = packed
	next_exit.destination_spawn_id = "EntranceFromS01"
	assert(not next_exit.request_transition(next_player), "Arrival inside an exit must never trigger a return loop")
	await create_timer(0.25).timeout
	next_player.set_meta("c3_arrival_guard_until", 0)
	assert(next_exit.overlaps_body(next_player))
	assert(next_player.get_meta("c3_arrival_blocked", false), "Guard remains while overlapping, even after the timer")
	next_player.position.x += 400
	await create_timer(0.1).timeout
	next_exit._physics_process(0.0)
	assert(not next_player.get_meta("c3_arrival_blocked", true), "Guard releases after leaving every exit")
	print("PASS: validated marker handoff, deferred native fade/scene swap, health/vitality/inventory continuity and arrival loop guard")
	DirAccess.remove_absolute(SAVE_PATH)
	current_scene.queue_free()
	current_scene = null
	await process_frame
	quit()
