extends SceneTree
const Jungle = preload("res://scripts/systems/chapter01_jungle.gd")
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)
func run() -> void:
	for index in 3:
		var room := Node2D.new()
		room.set_script(Jungle)
		room.area_index=index
		room.position=Vector2(10000+index*5600,0)
		root.add_child(room)
		await process_frame
		room.active=true
		check(room.reference_decor.available(),"Reference art loaded in jungle %d" % index)
		for item in room.reference_decor.foliage_layout(room.terrain()):
			var rect: Rect2=room.reference_decor.prop_rect(item.key,item.foot,item.bounds)
			var supported := false
			for floor_rect: Rect2 in room.terrain():
				if absf(rect.end.y-floor_rect.position.y-2)<0.01 and rect.position.x>=floor_rect.position.x and rect.end.x<=floor_rect.end.x: supported=true
			check(supported,"Reference foliage remains on its authored collision surface")
		for item in room.reference_decor.architecture_layout(room.terrain()):
			var art_rect: Rect2=room.reference_decor.prop_rect(item.key,item.foot,item.bounds)
			var supported := false
			for floor_rect: Rect2 in room.terrain():
				if floor_rect.position.y==620 and art_rect.position.x>=floor_rect.position.x and art_rect.end.x<=floor_rect.end.x and absf(art_rect.end.y-floor_rect.position.y-12)<0.01: supported=true
			check(supported,"Complete architecture base remains rooted to solid ground")
		check(all_platforms_reachable(room.terrain()),"Every jungle %d platform is reachable with the real jump envelope" % index)
		for spawn in Jungle.enemy_spawns(index):
			check(has_support(room.terrain(),Vector2(spawn[0],620)),"Enemy patrol begins on an existing floor")
		for spot in room.puzzle_positions(): check(has_support(room.terrain(),spot),"Puzzle interaction stands on reachable ground")
		var before: Array=room.get_reference_light_anchors()
		check(before.size()>4,"Room has independent runtime light anchors")
		for anchor in before:
			check(anchor.world_position.x>=room.position.x,"Light anchor tracks room world offset")
		var order: Array=[[0,2,1],[0,1],[2,0,1]][index]
		for chosen in order: room.interact_at(room.puzzle_positions()[chosen])
		check(room.puzzle_cleared and room.gate.collision_layer==0,"Solving each seal opens the actual route")
		check(room.get_reference_light_anchors().size()==before.size()-1,"Opened seal removes its closed-door glow")
		room.active=false
		check(room.get_reference_light_anchors().is_empty(),"Inactive rooms do not emit lights")
		room.queue_free()
		await process_frame
	var chapter=load("res://scripts/systems/chapter01.gd")
	check(all_platforms_reachable(chapter.BASE_PLATFORMS+chapter.BRIDGE_PLATFORMS),"Main trail and unlocked bridge are reachable with actual movement values")
	print("REFERENCE JUNGLE CHECKS: ",checks," FAILURES: ",failures)
	quit(1 if failures else 0)

func has_support(platforms: Array, foot: Vector2) -> bool:
	for rect: Rect2 in platforms:
		if absf(rect.position.y-foot.y)<0.01 and foot.x>=rect.position.x+12 and foot.x<=rect.end.x-12: return true
	return false

func all_platforms_reachable(platforms: Array) -> bool:
	# Read the actual controller's defaults so movement changes invalidate this audit.
	var player=load("res://scripts/player/player_controller.gd").new()
	var speed: float=player.speed
	var jump: float=player.jump_speed
	var gravity: float=player.gravity
	player.free()
	var reached: Array[int]=[0]
	var changed := true
	while changed:
		changed=false
		for source in reached.duplicate():
			var a: Rect2=platforms[source]
			for i in platforms.size():
				if reached.has(i): continue
				var b: Rect2=platforms[i]
				var discriminant := jump*jump+2*gravity*(b.position.y-a.position.y)
				if discriminant<0: continue
				var flight := (jump+sqrt(discriminant))/gravity
				var gap := maxf(0,maxf(b.position.x-a.end.x,a.position.x-b.end.x))
				# Reserve landing and takeoff margin plus acceleration distance.
				if gap+42<speed*flight-24:
					reached.append(i)
					changed=true
	return reached.size()==platforms.size()
