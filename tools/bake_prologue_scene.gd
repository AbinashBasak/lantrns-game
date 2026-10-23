extends SceneTree
## Explicit authoring utility: regenerates the initial prologue scene from source layout.
## Normal editor/runtime loads reuse the saved nodes and never regenerate them.
func _initialize() -> void:
	call_deferred("_bake")

func _own(node: Node, scene: Node) -> void:
	for child in node.get_children():
		child.owner = scene
		_own(child, scene)

func _bake() -> void:
	var scene := Node2D.new()
	scene.name = "PrologueBrackenreach"
	root.add_child(scene)
	var village := Node2D.new()
	village.name = "Village"
	village.set_script(load("res://scripts/systems/prologue_village.gd"))
	village.process_mode = Node.PROCESS_MODE_DISABLED
	scene.add_child(village)
	village.bake_static_art()
	village.bake_story_art()
	village.process_mode = Node.PROCESS_MODE_PAUSABLE
	var parallax := Node2D.new()
	parallax.name = "Parallax"
	parallax.set_script(load("res://scripts/systems/prologue_parallax.gd"))
	parallax.process_mode = Node.PROCESS_MODE_PAUSABLE
	scene.add_child(parallax)
	var spawn := Marker2D.new()
	spawn.name = "PlayerSpawn"
	spawn.position = Vector2(150,590)
	scene.add_child(spawn)
	var player: Node2D = load("res://scenes/player/player.tscn").instantiate()
	player.name = "Player"
	player.position = spawn.position
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	scene.add_child(player)
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = Vector2(0,-205)
	camera.limit_left = 0
	camera.limit_right = 4400
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	_own(scene, scene)
	scene.set_script(load("res://scripts/systems/prologue.gd"))
	var packed := PackedScene.new()
	var result := packed.pack(scene)
	if result == OK:
		result = ResourceSaver.save(packed,"res://scenes/levels/prologue_brackenreach.tscn")
	print("Prologue bake result: ",result)
	scene.free()
	quit(result)
