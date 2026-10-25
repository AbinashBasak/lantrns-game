extends SceneTree
## Native scene/resource verification plus graphical captures. No gameplay approval.

var failures: Array[String] = []
var results: Array[Dictionary] = []

func _initialize() -> void:
	call_deferred("_run")

func _check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)
		push_error(message)

func _advance(tree: AnimationTree, seconds: float) -> void:
	var remaining := seconds
	while remaining > 0.00001:
		var dt := minf(remaining, 0.02)
		tree.advance(dt)
		remaining -= dt

func _route(graph: AnimationNodeStateMachine, source: StringName, target: StringName) -> PackedStringArray:
	var queue: Array = [[source]]
	var seen: Dictionary = {}
	while not queue.is_empty():
		var path: Array = queue.pop_front()
		var current: StringName = path[-1]
		if current == target:
			return PackedStringArray(path)
		if seen.has(current):
			continue
		seen[current] = true
		for index: int in graph.get_transition_count():
			if graph.get_transition_from(index) != current or graph.get_transition(index).advance_mode == AnimationNodeStateMachineTransition.ADVANCE_MODE_DISABLED:
				continue
			var next: Array = path.duplicate()
			next.append(graph.get_transition_to(index))
			queue.append(next)
	return PackedStringArray()

func _run() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/chapter03/animation-asset-preparation-handoff.json"))
	root.size = Vector2i(1280, 720)
	for asset: Dictionary in data.assets:
		if not asset.has("native_review_scene"):
			continue
		var scene_path: String = "res://" + asset.native_review_scene
		var packed: PackedScene = load(scene_path)
		_check(packed != null, "Scene loads: " + scene_path)
		if packed == null:
			continue
		var instance: Node = packed.instantiate()
		root.add_child(instance)
		await process_frame
		var player: AnimationPlayer = instance.get_node("Actor/AnimationPlayer")
		var sprite: AnimatedSprite2D = instance.get_node("Actor/Sprite")
		var tree: AnimationTree = instance.get_node("Actor/AnimationTree")
		tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
		tree.active = false
		var tested: Array[String] = []
		var scene_clips: Array[Dictionary] = []
		for clip: Dictionary in data.clips:
			if clip.asset_id != asset.asset_id:
				continue
			scene_clips.append(clip)
			var action: StringName = StringName(clip.action)
			_check(sprite.sprite_frames.has_animation(action), "SpriteFrames has " + String(action))
			_check(sprite.sprite_frames.get_frame_count(action) == int(clip.recovered_frames), "Exact recovered count: " + String(action))
			player.play(action)
			player.seek(0.0, true)
			_check(sprite.animation == action and sprite.frame == 0, "Native timeline selects " + String(action))
			player.seek((float(clip.recovered_frames) - 0.25) / float(clip.fps), true)
			_check(sprite.frame == int(clip.recovered_frames) - 1, "Native timeline reaches final frame: " + String(action))
			tested.append(String(action))
		# Begin from the scene's authored Start transition. No per-action .start()
		# or fallback teleport may hide an absent graph path.
		tree.active = true
		var playback: AnimationNodeStateMachinePlayback = tree.get("parameters/playback")
		_advance(tree, 0.04)
		var hub := StringName(scene_clips[0].action)
		_check(playback.get_current_node() == hub, "Authored Start reaches review hub: " + String(asset.asset_id))
		var travel_results: Array[Dictionary] = []
		for clip: Dictionary in scene_clips:
			var action := StringName(clip.action)
			# travel requests are deferred and direct paths are consumed in the
			# same mixer step. Inspect the actual enabled graph as well as
			# observing the result, so teleport fallback cannot pass this test.
			var path := _route(tree.tree_root, playback.get_current_node(), action)
			_check(not path.is_empty(), "Actual enabled graph route exists: " + String(action))
			playback.travel(action)
			_advance(tree, 0.04)
			_check(playback.get_current_node() == action and sprite.animation == action, "Travel reaches source action: " + String(action))
			var initial_frame := sprite.frame
			_advance(tree, 1.0 / float(clip.fps) + 0.005)
			if int(clip.recovered_frames) > 1:
				_check(sprite.frame > initial_frame, "Native travel playback advances frames: " + String(action))
			var progressed_frame := sprite.frame
			if bool(clip.loop):
				_advance(tree, float(clip.recovered_frames) / float(clip.fps) + 0.02)
				_check(playback.get_current_node() == action, "Locomotion loop holds until travel: " + String(action))
				playback.travel(hub)
				_advance(tree, 0.02)
			else:
				_advance(tree, float(clip.recovered_frames) / float(clip.fps) + 0.04)
			_check(playback.get_current_node() == hub, "Action returns to hub: " + String(action))
			travel_results.append({"action": action, "graph_path": path,
				"first_frame": initial_frame, "progressed_frame": progressed_frame,
				"returns_to_hub": true, "partial_source": String(action).ends_with("_partial")})
		# Verify the hub also provides a path between two different non-hub
		# actions, including a wait-until-end return from a one-shot.
		var cross_action: Dictionary = {}
		if scene_clips.size() > 2:
			var first: Dictionary = scene_clips[1]
			var last: Dictionary = scene_clips[-1]
			playback.travel(StringName(first.action))
			_advance(tree, 0.04)
			var path := _route(tree.tree_root, playback.get_current_node(), StringName(last.action))
			playback.travel(StringName(last.action))
			_check(path.size() >= 3, "Cross-action travel uses hub graph: " + String(asset.asset_id))
			_advance(tree, 0.06 if bool(first.loop) else float(first.recovered_frames) / float(first.fps) + 0.02)
			_check(playback.get_current_node() == StringName(last.action), "Cross-action target reached: " + String(asset.asset_id))
			cross_action = {"from": first.action, "to": last.action, "path": path, "reached": playback.get_current_node()}
			_advance(tree, float(last.recovered_frames) / float(last.fps) + 0.04)
		tree.active = false
		var selected: StringName = &"idle"
		if not player.has_animation(selected):
			selected = StringName(tested[0])
		player.play(selected)
		player.seek(0.0, true)
		player.pause()
		await process_frame
		await RenderingServer.frame_post_draw
		var capture_path := "res://docs/chapter03/animation-asset-preparation-" + String(asset.asset_id).to_lower() + "-native.png"
		if DisplayServer.get_name() != "headless":
			var image: Image = root.get_texture().get_image()
			_check(image.save_png(capture_path) == OK, "Native render saved: " + capture_path)
		results.append({"asset_id": asset.asset_id, "scene": scene_path,
			"native_actions_verified": tested, "capture": capture_path,
			"travel_and_progression": travel_results, "cross_action_travel": cross_action,
			"production_approved": false})
		instance.queue_free()
		await process_frame
	var report := {"godot_version": Engine.get_version_info().string,
		"renderer": DisplayServer.get_name(), "results": results,
		"failures": failures, "status": "passed" if failures.is_empty() else "failed",
		"scope": "Native import/counts/timelines plus actual travel paths, engine frame progression, locomotion loop hold, one-shot/partial return and cross-action travel through authored AnimationTree graphs; actual diagnostic scene renders. No missing art/gameplay approval."}
	var file := FileAccess.open("res://docs/chapter03/animation-asset-preparation-validation.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t") + "\n")
	file.close()
	print("C3 enemy animation review: ", results.size(), " scenes, ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
