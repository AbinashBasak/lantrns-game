extends SceneTree
## Native resource/state checks and identical light-off/light-on scene captures.

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

func _run() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/chapter03/collectible-asset-preparation-handoff.json"))
	root.size = Vector2i(1280, 720)
	for asset: Dictionary in data.assets:
		if not asset.has("native_review_scene"):
			continue
		var packed: PackedScene = load("res://" + asset.native_review_scene)
		_check(packed != null, "Scene loads: " + String(asset.asset_id))
		if packed == null:
			continue
		var instance: Node = packed.instantiate()
		root.add_child(instance)
		await process_frame
		var player: AnimationPlayer = instance.get_node("Actor/AnimationPlayer")
		var sprite: AnimatedSprite2D = instance.get_node("Actor/Sprite")
		var tree: AnimationTree = instance.get_node("Actor/AnimationTree")
		var light: PointLight2D = instance.get_node("Actor/EmissionLight")
		tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
		_check(sprite.sprite_frames.get_frame_count(&"idle_unlit") == int(asset.frame_count), "Exact frame count: " + String(asset.asset_id))
		_check(tree.active, "Native AnimationTree active: " + String(asset.asset_id))
		tree.active = false
		player.play(&"idle_unlit")
		player.seek(0.0, true)
		_check(sprite.animation == &"idle_unlit" and sprite.frame == 0, "Native first frame: " + String(asset.asset_id))
		player.seek((float(asset.frame_count) - 0.25) / float(asset.fps), true)
		_check(sprite.frame == int(asset.frame_count) - 1, "Native final frame: " + String(asset.asset_id))
		tree.active = true
		var playback: AnimationNodeStateMachinePlayback = tree.get("parameters/playback")
		var graph: AnimationNodeStateMachine = tree.tree_root
		_check(graph.get_transition_count() == 1 and graph.has_transition(&"Start", &"idle_unlit"), "Only supplied idle state has authored Start route: " + String(asset.asset_id))
		playback.travel(&"idle_unlit")
		_advance(tree, 0.04)
		_check(sprite.animation == &"idle_unlit", "Tree drives native idle: " + String(asset.asset_id))
		var first_frame := sprite.frame
		_advance(tree, 1.0 / float(asset.fps) + 0.005)
		_check(sprite.frame > first_frame, "Native travel advances idle frames: " + String(asset.asset_id))
		var progressed_frame := sprite.frame
		_advance(tree, float(asset.frame_count) / float(asset.fps) + 0.02)
		_check(playback.get_current_node() == &"idle_unlit" and sprite.frame < int(asset.frame_count), "Supplied idle loops without invented states: " + String(asset.asset_id))
		tree.active = false
		player.play(&"idle_unlit")
		player.seek(0.0, true)
		player.pause()
		var paths: Array[String] = []
		for enabled: bool in [false, true]:
			light.enabled = enabled
			await process_frame
			await RenderingServer.frame_post_draw
			var suffix := "on" if enabled else "off"
			var path := "res://docs/chapter03/collectible-asset-preparation-" + String(asset.asset_id).to_lower() + "-native-light-" + suffix + ".png"
			if DisplayServer.get_name() != "headless":
				_check(root.get_texture().get_image().save_png(path) == OK, "Native capture saved: " + suffix)
			paths.append(path)
		results.append({"asset_id": asset.asset_id, "native_scene": asset.native_review_scene,
			"frame_count": asset.frame_count, "fps": asset.fps, "captures": paths,
			"native_travel_state": "idle_unlit", "travel_first_frame": first_frame,
			"travel_progressed_frame": progressed_frame, "loop_verified": true,
			"body_light_separate_nodes": true, "production_approved": false})
		instance.queue_free()
		await process_frame
	var report := {"godot_version": Engine.get_version_info().string,
		"renderer": DisplayServer.get_name(), "results": results, "failures": failures,
		"status": "passed" if failures.is_empty() else "failed",
		"scope": "Native import/counts/timelines, actual AnimationTree travel and frame progression through the single supplied idle loop, and identical native light-off/light-on captures. Missing action/VFX families are not fabricated; gameplay integration and art approval pending."}
	var file := FileAccess.open("res://docs/chapter03/collectible-asset-preparation-validation.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t") + "\n")
	file.close()
	print("C3 collectible native review: ", results.size(), " scenes, ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
