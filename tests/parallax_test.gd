extends SceneTree
var game: Node
var failures := 0
func _initialize() -> void:
	call_deferred("run")
func check(ok: bool, text: String) -> void:
	if ok: print("PASS: ", text)
	else:
		failures += 1
		push_error(text)
func settle(x: float) -> void:
	game.player.position = Vector2(x, 620)
	game.camera.reset_smoothing()
	for i in 8: await process_frame
func positions() -> Array[float]:
	var values: Array[float] = []
	for layer in game.parallax.layers:
		values.append(layer.get_child(0).get_global_transform_with_canvas().origin.x)
	return values
func run() -> void:
	game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	game.player.active = false
	await settle(900)
	var before := positions()
	await settle(1100)
	var after := positions()
	check(game.parallax.layers.size() == 4, "Four independent native parallax planes are present")
	for i in 4:
		var layer: Parallax2D = game.parallax.layers[i]
		var expected := -200.0 * layer.scroll_scale.x
		check(absf(after[i] - before[i] - expected) < 2, "%s plane moves at %.2f camera speed" % [layer.name, layer.scroll_scale.x])
	check(game.village.get_platforms()[0].position.y == 620, "Visual grounding retains the collision floor")
	for key in ["interact0", "interact1", "interact2", "rusk", "villager"]:
		check(game.village.prop_regions.has(key), "%s uses a visible-bounds foot anchor" % key)
	paused = false
	game.queue_free()
	game = null
	for i in 4: await process_frame
	print("PARALLAX TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)
