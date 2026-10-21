extends SceneTree
const Jungle = preload("res://scripts/systems/chapter01_jungle.gd")
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, text: String) -> void:
	checks += 1
	print(("PASS: " if ok else "FAIL: ")+text)
	if not ok: failures += 1
func run() -> void:
	for layer in 4:
		var rate: float = Jungle.PARALLAX_RATES[layer]
		var start := Vector2(2000,360)
		var finish := start+Vector2(200,0)
		var movement := (Jungle.parallax_origin(finish,layer)-finish)-(Jungle.parallax_origin(start,layer)-start)
		check(absf(movement.x+200*rate)<0.01,"Jungle layer%d has restrained %.2f camera speed" % [layer,rate])
		var boundary := Vector2(1800/(1-rate),360)
		var before := Jungle.parallax_origin(boundary-Vector2.ONE*0.001,layer)
		var after := Jungle.parallax_origin(boundary+Vector2.ONE*0.001,layer)
		check(after.distance_to(before)<0.004,"Layer%d crosses former wrap boundary without a position jump" % layer)
		var jump := Jungle.parallax_origin(start+Vector2(0,-150),layer)-Jungle.parallax_origin(start,layer)-Vector2(0,-150)
		check(absf(jump.y)<18,"Layer%d restrains vertical background drift during jumps" % layer)
	for index in 3:
		var room := Node2D.new()
		room.set_script(Jungle)
		room.area_index = index
		root.add_child(room)
		await process_frame
		for x in [360,570,1180,1780,2390,2670,3070,3490,3840,4250]:
			var rect: Rect2 = room.prop_rect("ENV-02_decorative_props_05",Vector2(x,624),Vector2(100,60))
			var supported := false
			for floor_rect in room.terrain():
				if absf(floor_rect.position.y-620)<1 and rect.position.x>=floor_rect.position.x and rect.end.x<=floor_rect.end.x: supported=true
			check(supported and absf(rect.end.y-624)<0.01,"Room%d foliage%d contacts solid terrain" % [index,x])
		room.queue_free()
		await process_frame
	var environment := Node2D.new()
	environment.set_script(load("res://scripts/systems/chapter01_environment.gd"))
	root.add_child(environment)
	await process_frame
	for key in ["ENV-02_decorative_props_00","ENV-02_decorative_props_04"]:
		check(environment.prop_regions[key].end.y < environment.textures[key].get_height(),"Main-trail%s ignores transparent bottom padding" % key)
	for layer in environment.forest_layers:
		check(layer.scroll_scale.x <= 0.45,"Main trail parallax speed matches restrained jungle profile")
	environment.queue_free()
	for i in 4: await process_frame
	print("JUNGLE VISUAL CHECKS: ",checks," FAILURES: ",failures)
	quit(1 if failures else 0)
