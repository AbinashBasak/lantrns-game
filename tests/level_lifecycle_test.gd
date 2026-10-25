extends SceneTree
## Exercise complete level trees, including their inherited scenes and active audio.
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	for path in [
		"res://scenes/levels/prologue_brackenreach.tscn",
		"res://scenes/levels/chapter01_forgotten_trail.tscn",
		"res://scenes/levels/chapter02_briarwake.tscn",
	]:
		var orphan_before := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
		var game = load(path).instantiate()
		root.add_child(game)
		current_scene = game
		await process_frame
		if game.has_method("_begin"):
			game._begin()
		for i in 12:
			await process_frame
		if game.has_node("Player"):
			var player: Node = game.get_node("Player")
			check(player.has_node("AnimationTree"), path + " inherits native player graph")
			check(not player.has_node("AnimatedSprite2D2"), path + " has no duplicate player artwork")
		paused = false
		current_scene = null
		game.queue_free()
		for i in 5:
			await process_frame
		check(not is_instance_valid(game), path + " freed its level root")
		var orphan_after := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
		check(orphan_after == orphan_before, "%s orphan nodes: %d → %d" % [path, orphan_before, orphan_after])
	if failures == 0:
		print("PASS: Prologue, Chapter 1 and Chapter 2 free complete scene trees without orphan nodes")
	quit(1 if failures else 0)

func check(passed: bool, message: String) -> void:
	if not passed:
		failures += 1
		push_error(message)
