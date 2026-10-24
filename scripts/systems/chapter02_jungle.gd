extends Node2D
## Mandatory, illustrated Briarwake expeditions. Parent owns camera and travel.
const Decor = preload("res://scripts/systems/reference_jungle_decor.gd")
const SceneArt = preload("res://scripts/editor/scene_art.gd")
const FallbackEnemy = preload("res://scenes/enemies/thornling.tscn")
const ORCHARD = preload("res://assets/runtime/chapter01/story/orchard_background.png")
const FRAGMENT = preload("res://assets/runtime/chapter01/story/fragment.png")
const RUIN = preload("res://assets/runtime/chapter01/environment/ENV-03_interactive_props_03.png")
const COLUMN = preload("res://assets/runtime/chapter01/environment/ENV-03_decorative_props_01.png")
const WIDTH := 4800.0
const GATE_X := 4210.0
const EXIT_X := 4630.0
const NAMES := ["THE ORCHARD WATERWAYS", "THE FIREFLY CANOPY", "THE ANCIENT SEED VAULT", "THE SUNKEN ROOT GROTTO"]
const ORDERS := [[0, 1, 2], [0, 2, 1], [0, 1, 2], [2, 0, 1]]
const LABELS := [["INLET", "SLUICE", "DRAIN"], ["I", "II", "III"], ["LEAF", "MOON", "SUN"], ["ROOT", "POOL", "AMBER"]]
const INSTRUCTIONS := ["Restore irrigation: Inlet → Sluice → Drain", "Light the old lanterns: I → III → II", "Wake the seed vault: Leaf → Moon → Sun", "Follow the amber chain: Amber → Root → Pool"]
signal solved(index: int)
signal exited(index: int)
@export_range(0, 3) var area_index := 0
var game: Node
var active := false
var completed := false
var enemies: Array = []
var discovered := false
var progress := 0
var clock := 0.0
var exit_sent := false
var exit_armed := false
var underground_background: Texture2D
var damage_cooldown := 0.0
var background_layer: Node2D
var gate_collision: CollisionShape2D
var decor = Decor.new()
var lanterns: Array[Dictionary] = []
var terrain_rects: Array[Rect2] = []

func _ready() -> void:
	position = Vector2(11000 + area_index * 6000, 0)
	process_mode = Node.PROCESS_MODE_PAUSABLE
	decor.load_assets()
	if area_index >= 2:
		var path: String = "res://assets/runtime/chapter02/environment/" + ["LATE-001_underground_background.png", "LATE-001_grotto_background.png"][area_index-2]
		if ResourceLoader.exists(path): underground_background = load(path)
	terrain_rects = _terrain()
	_build()
	visible = false
	set_process(false)

func _terrain() -> Array[Rect2]:
	var result: Array[Rect2] = []
	# Main-route gaps are 140–160px, below Tavi's 200+px running jump.
	var gaps: Array = [[Vector2(850, 990), Vector2(1780, 1930)], [Vector2(1100, 1250), Vector2(2240, 2400)], [Vector2(750, 900), Vector2(1970, 2120)], [Vector2(850, 1000), Vector2(2010, 2170)]][area_index]
	var left := 0.0
	for gap: Vector2 in gaps:
		result.append(Rect2(left, 620, gap.x-left, 500))
		# Catch ledges make failed jumps recoverable; flooded ledges remain hazardous.
		result.append(Rect2(gap.x-10, 738, gap.y-gap.x+20, 28))
		left = gap.y
	result.append(Rect2(left, 620, WIDTH-left, 500))
	# Two linked canopy traversals add optional exploration above the main path.
	for x in [460.0, 2530.0]:
		result.append(Rect2(x, 525, 190, 28))
		result.append(Rect2(x+240, 438, 200, 28))
		result.append(Rect2(x+500, 350, 260, 28))
		result.append(Rect2(x+870, 350, 260, 28))
		result.append(Rect2(x+1210, 438, 200, 28))
		result.append(Rect2(x+1470, 525, 180, 28))
	return result

func _solid(rect: Rect2, one_way := false) -> CollisionShape2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	collision.one_way_collision = one_way
	body.add_child(collision)
	add_child(body)
	return collision

func _build() -> void:
	background_layer = Node2D.new()
	background_layer.name = "DistantForest"
	background_layer.z_index = -30
	add_child(background_layer)
	background_layer.draw.connect(_draw_background)
	var scenery := Node2D.new()
	scenery.name = "RootedJungleArt"
	scenery.z_index = -5
	add_child(scenery)
	for rect in terrain_rects:
		_solid(rect, rect.size.y < 50)
		decor.build_terrain(scenery, rect)
	decor.build_foliage(scenery, terrain_rects)
	decor.build_lanterns(scenery, terrain_rects, WIDTH)
	if area_index < 2:
		decor.build_architecture(scenery, terrain_rects)
	else:
		for x in [300.0, 1450.0, 2580.0, 3810.0, 4550.0]:
			var size := COLUMN.get_size()
			size *= minf(1.0, minf(130.0/size.x, 220.0/size.y))
			SceneArt.image(scenery, COLUMN, Rect2(Vector2(x-size.x/2,620-size.y),size))
	_solid(Rect2(-40, -500, 40, 1700))
	_solid(Rect2(WIDTH, -500, 40, 1700))
	gate_collision = _solid(Rect2(GATE_X-18, -500, 36, 1120))
	SceneArt.text(scenery, Vector2(160, 400), NAMES[area_index], Color("ffe3a0"), 23)
	decor.building_nodes = true
	for x in [680.0, 2720.0]:
		decor.prop(scenery,"PROP-011_hanging_vine",Vector2(x+55,240),Vector2(70,240))
		decor.prop(scenery,"PROP-011_leaf_cluster",Vector2(x,200),Vector2(170,100))
	decor.building_nodes = false

func entry_point() -> Vector2:
	return global_position + Vector2(160, 590)

func exit_point() -> Vector2:
	return global_position + Vector2(EXIT_X, 590)

func enter() -> void:
	active = true
	visible = true
	exit_sent = false
	exit_armed = false
	background_layer.queue_redraw()
	reset_enemies()
	queue_redraw()

func leave() -> void:
	active = false
	visible = false
	for enemy in enemies:
		if is_instance_valid(enemy): enemy.process_mode = Node.PROCESS_MODE_DISABLED

func reset_enemies() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.remove_from_group("enemies")
			enemy.queue_free()
	enemies.clear()
	if not active: return
	var spawn_points: Array = [[350.0, 1190.0, 1570.0, 2140.0, 2650.0, 3730.0, 4430.0], [350.0, 850.0, 1450.0, 1860.0, 2600.0, 3770.0, 4460.0], [340.0, 1120.0, 1570.0, 2320.0, 2740.0, 3750.0, 4450.0], [340.0, 1200.0, 1640.0, 2350.0, 2740.0, 3750.0, 4450.0]][area_index]
	for i in spawn_points.size():
		var enemy: CharacterBody2D
		if ResourceLoader.exists("res://scripts/enemies/orchard_enemy.gd"):
			var enemy_script: Script = load("res://scripts/enemies/orchard_enemy.gd")
			enemy = enemy_script.new()
			enemy.set("variant", (i+area_index)%3)
		else:
			enemy = FallbackEnemy.instantiate()
		enemy.position = Vector2(spawn_points[i], 620)
		add_child(enemy)
		enemies.append(enemy)
		if is_instance_valid(game) and game.get("rewards") != null:
			game.rewards.watch_enemy(enemy,"briarwake_jungle_%d_%d" % [area_index,i])

func puzzle_positions() -> Array[Vector2]:
	return [Vector2(3000,620), Vector2(3260,620), Vector2(3520,620)]

func discovery_point() -> Vector2:
	return Vector2(1450,310)

func nearby_interaction() -> Array:
	if not active or not is_instance_valid(game) or game.player == null: return ["", ""]
	var local: Vector2 = to_local(game.player.global_position)
	if not discovered and local.distance_to(discovery_point()) < 105:
		return ["jungle_discovery_%d" % area_index,"E / Y   Recover " + ["the orchard keeper's map", "a lost firefly memory", "the ancient seed record", "the drowned keeper's journal"][area_index]]
	if not completed:
		var spots := puzzle_positions()
		for i in spots.size():
			if local.distance_to(spots[i]) < 110:
				return ["jungle_%d_control_%d" % [area_index,i],"E / Y   " + ("Light lantern " if area_index==1 else "Activate ") + LABELS[area_index][i] + " · " + INSTRUCTIONS[area_index]]
	return ["", ""]

func interact_at(id: String) -> void:
	if id.is_empty() or nearby_interaction()[0] != id: return
	if id.begins_with("jungle_discovery_"):
		discovered = true
		_award("discovery",250,discovery_point(),"JUNGLE DISCOVERY")
		_notice(["Keeper's map recovered · Irrigation runs from inlet to drain.","Firefly memory recovered · The carved order is I, III, II.","Seed record recovered · Leaf drinks moonlight before greeting the sun.","Drowned keeper's journal · The amber chain begins at Amber, winds through Root, and ends in Pool."][area_index])
		return
	var chosen := int(id.get_slice("_",3))
	if chosen != ORDERS[area_index][progress]:
		progress = 0
		_notice("The seal resets · " + INSTRUCTIONS[area_index])
	else:
		progress += 1
		_notice("The jungle answers · %d / 3" % progress)
		if progress == 3:
			completed = true
			gate_collision.set_deferred("disabled",true)
			_award("puzzle",500,Vector2(3520,620),"JUNGLE RESTORED")
			_notice(["Irrigation restored · The flood recedes. Follow the eastern path.","Firefly lanterns restored · The canopy passage opens.","Ancient seed vault awakened · The living roots release the path.","Grotto sluices restored · Fresh water returns to Briarwake. The last underground passage opens."][area_index])
			solved.emit(area_index)
	queue_redraw()

func _award(key: String, amount: int, at: Vector2, title: String) -> void:
	if is_instance_valid(game) and game.get("rewards") != null:
		game.rewards.award("briarwake_jungle_%d_%s" % [area_index,key], amount, to_global(at),title)

func _notice(message: String) -> void:
	if is_instance_valid(game) and game.has_method("_notice"): game._notice(message)

func process_room(delta: float) -> void:
	if not active: return
	clock += delta
	damage_cooldown = maxf(0.0, damage_cooldown-delta)
	if is_instance_valid(game) and game.player != null:
		var local: Vector2 = to_local(game.player.global_position)
		if area_index in [0, 3] and not completed and local.y > 695 and damage_cooldown <= 0:
			damage_cooldown = 1.3
			game.player.take_damage(15, -1.0)
			_notice("Flooded roots drain vitality · Jump back to the dry bank and restore irrigation.")
		if local.x < EXIT_X-70: exit_armed = true
		if completed and exit_armed and local.x >= EXIT_X and not exit_sent:
			exit_sent = true
			exited.emit(area_index)
	queue_redraw()
	background_layer.queue_redraw()

func _draw_background() -> void:
	if not active or not decor.available(): return
	var camera := get_viewport().get_camera_2d()
	var center := camera.get_screen_center_position()-global_position if camera else Vector2(640,360)
	# The high-resolution source remains at or below native density.
	var background: Texture2D = ORCHARD if area_index==0 else decor.textures["ENV-02_background"]
	if area_index >= 2:
		# Missing new art is left pending; never substitute a mismatched cave.
		if underground_background == null: return
		background = underground_background
	var height := minf(1000.0, background.get_height())
	var width := height * background.get_width()/background.get_height()
	var origin := Vector2(center.x*0.90,-180+(center.y-360)*0.975)
	for tile in range(-2,7):
		background_layer.draw_set_transform(origin+Vector2(tile*width+(width if posmod(tile,2) else 0),0),0,Vector2(-1 if posmod(tile,2) else 1,1))
		background_layer.draw_texture_rect(background,Rect2(0,0,width+1,height),false)
	background_layer.draw_set_transform(Vector2.ZERO)

func _draw() -> void:
	if not active or not decor.available(): return
	# Gameplay props sit above the grounded, separate scenery layer.
	if area_index in [0, 3]:
		var water_y := 820.0 if completed else 700.0
		for rect in terrain_rects:
			if rect.position.y != 738: continue
			draw_rect(Rect2(rect.position.x,water_y,rect.size.x,220),Color(0.13,0.62,0.63,0.55))
			for x in range(int(rect.position.x),int(rect.end.x),28):
				draw_line(Vector2(x,water_y+sin(clock*2+x)*2),Vector2(x+18,water_y+sin(clock*2+x)*2),Color("b8ede0"),1.5)
	var spots := puzzle_positions()
	for i in spots.size():
		if area_index==1:
			decor.prop(self,"PROP-001_lantern_post",spots[i],Vector2(80,175))
		else:
			var size := RUIN.get_size()
			size *= minf(1.0,minf(120.0/size.x,160.0/size.y))
			draw_texture_rect(RUIN,Rect2(spots[i]-Vector2(size.x/2,size.y),size),false)
		var lit: bool = completed or ORDERS[area_index].slice(0,progress).has(i)
		draw_circle(spots[i]+Vector2(0,-175),5,Color("ffe3a0") if lit else Color("426457"))
		draw_string(ThemeDB.fallback_font,spots[i]+Vector2(-50,-195),LABELS[area_index][i],HORIZONTAL_ALIGNMENT_CENTER,100,16,Color("ffe3a0"))
	decor.draw_gate(self,GATE_X,completed)
	if not discovered:
		var size := FRAGMENT.get_size()
		size *= minf(1.0,38.0/maxf(size.x,size.y))
		draw_texture_rect(FRAGMENT,Rect2(discovery_point()-size/2+Vector2(0,sin(clock*2)*4),size),false)
		draw_string(ThemeDB.fallback_font,discovery_point()+Vector2(-80,-38),["KEEPER'S MAP","FIREFLY MEMORY","SEED RECORD","KEEPER'S JOURNAL"][area_index],HORIZONTAL_ALIGNMENT_CENTER,160,15,Color("ffe3a0"))

func get_reference_light_anchors() -> Array[Dictionary]:
	if not active: return []
	var anchors: Array[Dictionary] = decor.light_anchors(terrain_rects,WIDTH,global_position)
	if area_index == 1:
		var spots := puzzle_positions()
		for i in spots.size():
			var flame := spots[i]+Vector2(0,-120)
			anchors.append({"world_position":to_global(flame),"local_position":flame,"color":Color("ffc75a"),"energy":0.7,"radius":185.0,"active":completed or ORDERS[area_index].slice(0,progress).has(i)})
	return anchors
