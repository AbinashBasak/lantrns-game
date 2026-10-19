extends SceneTree
var game: Node
func _initialize() -> void:
	call_deferred("run")
func settle(at: float) -> void:
	game.player.position = Vector2(at, 620)
	game.player.velocity = Vector2.ZERO
	game.camera.reset_smoothing()
	for i in 8: await process_frame
	await RenderingServer.frame_post_draw
func run() -> void:
	game = load("res://scenes/levels/prologue_brackenreach.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game._begin()
	game.moved_once = true
	game.jumped_once = true
	game.player.active = false
	game.player.visual.play("idle")
	await settle(1040)
	root.get_texture().get_image().save_png("res://docs/prologue-village-preview.png")
	await settle(3700)
	root.get_texture().get_image().save_png("res://docs/prologue-warden-preview.png")
	await settle(650)
	root.get_texture().get_image().save_png("res://docs/prologue-lane-preview.png")
	DirAccess.make_dir_recursive_absolute("/tmp/lanterns-parallax-frames")
	game.player.active = false
	game.player.visual.play("idle")
	# Sweep smoothly across the same architecture to reveal independently moving planes.
	for i in 32:
		await settle(850 + i * 21)
		root.get_texture().get_image().save_png("/tmp/lanterns-parallax-frames/frame_%03d.png" % i)
	quit()
