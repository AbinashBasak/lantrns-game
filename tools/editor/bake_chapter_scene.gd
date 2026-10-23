extends SceneTree
## One-time migration utility. Normal scene loading preserves authored node edits.
func _initialize() -> void:
	call_deferred("_bake")

func own_all(node: Node, scene: Node) -> void:
	for child in node.get_children():
		child.owner = scene
		own_all(child,scene)

func body(parent: Node, label: String, bounds: Rect2, disabled := false) -> StaticBody2D:
	var result := StaticBody2D.new()
	result.name = label
	result.position = bounds.get_center()
	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	collision.shape = RectangleShape2D.new()
	collision.shape.size = bounds.size
	collision.disabled = disabled
	result.add_child(collision)
	parent.add_child(result)
	return result

func _bake() -> void:
	var chapter = load("res://scripts/systems/chapter01.gd")
	var scene := Node2D.new()
	scene.name = "Chapter01ForgottenTrail"
	root.add_child(scene)
	var terrain := Node2D.new()
	terrain.name = "Terrain"
	scene.add_child(terrain)
	for i in chapter.BASE_PLATFORMS.size():
		body(terrain,"Platform%02d" % (i+1),chapter.BASE_PLATFORMS[i])
	var gates := Node2D.new()
	gates.name = "Gates"
	scene.add_child(gates)
	body(gates,"PuzzleGate",Rect2(3270,180,30,440))
	body(gates,"ArenaEntry",Rect2(6500,180,25,440),true)
	body(gates,"ArenaExit",Rect2(8140,180,30,440))
	var environment = load("res://scripts/systems/chapter01_environment.gd").new()
	environment.name = "Environment"
	environment.process_mode = Node.PROCESS_MODE_DISABLED
	scene.add_child(environment)
	environment.build_static_art()
	environment.process_mode = Node.PROCESS_MODE_PAUSABLE
	var spawn := Marker2D.new()
	spawn.name = "PlayerSpawn"
	spawn.position = Vector2(150,590)
	scene.add_child(spawn)
	var player = load("res://scenes/player/player.tscn").instantiate()
	player.name = "Player"
	player.position = spawn.position
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	scene.add_child(player)
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = Vector2(0,-260)
	camera.limit_left = 0
	camera.limit_right = 9000
	camera.limit_top = 0
	camera.limit_bottom = 800
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	var enemies := Node2D.new()
	enemies.name = "TrailEnemies"
	scene.add_child(enemies)
	for x in [1300,2400,4100,4800,5600]:
		var enemy = load("res://scenes/enemies/thornling.tscn").instantiate()
		enemy.name = "Thornling%d" % x
		enemy.position = Vector2(x,600)
		enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
		enemies.add_child(enemy)
	var boss = load("res://scenes/enemies/hollow_sentinel.tscn").instantiate()
	boss.name = "HollowSentinel"
	boss.position = Vector2(7350,620)
	boss.process_mode = Node.PROCESS_MODE_PAUSABLE
	scene.add_child(boss)
	var rooms := Node2D.new()
	rooms.name = "JungleRooms"
	scene.add_child(rooms)
	for i in 3:
		var room = load("res://scenes/levels/jungle_%d.tscn" % i).instantiate()
		room.name = ["HighCanopy","FloodedRootways","LanternGrove"][i]
		room.position = Vector2(10000+i*5600,0)
		room.z_index = -1
		room.process_mode = Node.PROCESS_MODE_PAUSABLE
		rooms.add_child(room)
	own_all(scene,scene)
	scene.set_script(chapter)
	var packed := PackedScene.new()
	var error := packed.pack(scene)
	if error == OK: error = ResourceSaver.save(packed,"res://scenes/levels/chapter01_forgotten_trail.tscn")
	print("Chapter scene saved: ",error_string(error))
	scene.free()
	quit(error)
