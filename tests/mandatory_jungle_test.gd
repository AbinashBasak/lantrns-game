extends SceneTree
const Jungle = preload("res://scripts/systems/chapter01_jungle.gd")
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if ok: print("PASS: ", message)
	else:
		failures+=1
		push_error(message)
func frames(count: int) -> void:
	for i in count: await physics_frame
func run() -> void:
	for action in ["move_left","move_right","jump","attack","interact"]:
		if not InputMap.has_action(action): InputMap.add_action(action)
	for index in 3:
		var room := Node2D.new()
		room.set_script(Jungle)
		room.area_index=index
		root.add_child(room)
		room.active=true
		var player=load("res://scenes/player/player.tscn").instantiate()
		root.add_child(player)
		player.active=true
		await frames(2)
		check(room.terrain().any(func(rect): return rect.end.x==Jungle.WIDTH),"Jungle %d expands to 4600 pixels" % index)
		check(room.enemy_spawns(index).size()>=7,"Jungle %d has seven authored patrol locations" % index)
		# Walk into the sealed gate using actual CharacterBody2D physics.
		player.position=Vector2(3910,620)
		Input.action_press("move_right")
		await frames(30)
		Input.action_release("move_right")
		check(player.position.x<4000,"Jungle %d root seal physically blocks the exit" % index)
		var spots: Array=room.puzzle_positions()
		var order: Array=[[0,2,1],[0,1],[2,0,1]][index]
		var wrong: int=(order[0]+1)%spots.size()
		room.interact_at(spots[wrong])
		check(room.puzzle_progress==0 and not room.puzzle_cleared,"Jungle %d wrong sequence safely resets" % index)
		for chosen in order: room.interact_at(spots[chosen])
		check(room.puzzle_cleared and room.gate.collision_layer==0,"Jungle %d distinct puzzle opens physical root seal" % index)
		player.position=Vector2(3910,620)
		Input.action_press("move_right")
		await frames(40)
		Input.action_release("move_right")
		check(player.position.x>4000 and player.is_on_floor(),"Jungle %d unlocked exit crosses on real ground" % index)
		# All existing gaps remain within the regular jump distance.
		for pair in [[820,1050],[1640,1900]] if index==0 else ([[640,860],[1425,1650],[2230,2460]] if index==1 else []):
			var start: float=pair[0]
			# Launch close to each actual platform edge, never inside the void.
			if index==0: start=850 if pair[1]==1050 else 1780
			player.position=Vector2(start,620)
			player.velocity=Vector2.ZERO
			await frames(4)
			Input.action_press("move_right")
			Input.action_press("jump")
			await frames(48)
			Input.action_release("jump")
			Input.action_release("move_right")
			await frames(35)
			check(player.position.x>=float(pair[1]) and player.position.y<700,"Jungle %d authored gap reaches safe terrain" % index)
		player.queue_free()
		room.queue_free()
		await frames(2)
	quit(1 if failures else 0)
