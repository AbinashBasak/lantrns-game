extends Node2D
## Three mandatory jungle journeys. All decoration reuses reviewed ENV-02/03 runtime exports.
const ReferenceDecor = preload("res://scripts/systems/reference_jungle_decor.gd")
var reference_decor = ReferenceDecor.new()
const ART := "res://assets/runtime/chapter01/environment/"
const PARALLAX_RATES := [0.05,0.12,0.24,0.45]
const BACKGROUND_TILE_WIDTH := 1800.0
const WIDTH := 4600
const SPACING := 5600
const EXIT_X := 4380.0
const GATE_X := 4000.0
const ENTRANCES := [650.0,4250.0,5800.0]
const MAIN_EXITS := [850.0,4500.0,6100.0]
signal puzzle_solved(index: int)
const NAMES := ["THE HIGH CANOPY", "FLOODED ROOTWAYS", "THE LANTERN GROVE"]
const PLATFORMS := [
	[Rect2(0,620,900,400),Rect2(1050,620,780,400),Rect2(1980,620,2620,400),Rect2(500,520,180,28),Rect2(740,430,200,28),Rect2(1000,350,330,28),Rect2(1470,350,300,28),Rect2(1850,430,200,28),Rect2(2110,520,180,28),Rect2(880,735,210,25),Rect2(1810,735,200,25)],
	[Rect2(0,620,700,400),Rect2(860,620,630,400),Rect2(1650,620,650,400),Rect2(2460,620,2140,400),Rect2(520,525,180,28),Rect2(750,445,200,28),Rect2(1010,365,260,28),Rect2(1380,365,250,28),Rect2(1740,445,200,28),Rect2(2100,525,200,28),Rect2(680,735,200,25),Rect2(1470,735,200,25),Rect2(2280,735,200,25)],
	[Rect2(0,620,4600,400),Rect2(650,520,200,28),Rect2(900,435,220,28),Rect2(1190,350,300,28),Rect2(1630,350,300,28),Rect2(2020,435,220,28),Rect2(2290,520,200,28)]
]
var puzzle_cleared := false
var puzzle_progress := 0
var puzzle_message := ""
var gate: StaticBody2D
var area_index := 0
var active := false
var discovered := false
var textures: Dictionary = {}
var prop_regions: Dictionary = {}
var clock := 0.0
func _ready() -> void:
	reference_decor.load_assets()
	for key in ["ENV-02_distant_background","ENV-02_midground","ENV-02_foreground","ENV-02_decorative_props_00","ENV-02_decorative_props_01","ENV-02_decorative_props_04","ENV-02_decorative_props_05","ENV-02_interactive_props_03","ENV-03_decorative_props_01","ENV-03_interactive_props_03","TILE-001_surface_strip","TILE-002_soil_fill"]:
		textures[key] = load(ART+key+".png")
		if "_props_" in key:
			prop_regions[key] = visible_region(textures[key].get_image())
	for rect in terrain():
		var body := StaticBody2D.new()
		body.position = rect.get_center()
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		var collision := CollisionShape2D.new()
		collision.shape = shape
		collision.one_way_collision = rect.size.y < 50
		body.add_child(collision)
		add_child(body)
	gate = StaticBody2D.new()
	gate.position = Vector2(GATE_X,150)
	var gate_shape := RectangleShape2D.new()
	gate_shape.size = Vector2(40,1000)
	var gate_collision := CollisionShape2D.new()
	gate_collision.shape = gate_shape
	gate.add_child(gate_collision)
	add_child(gate)
	visible = false
func _process(delta: float) -> void:
	if not active: return
	clock += delta
	queue_redraw()
static func visible_region(image: Image) -> Rect2:
	var low := Vector2i(image.get_width(),image.get_height())
	var high := Vector2i(-1,-1)
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x,y).a < 0.125: continue
			low = Vector2i(mini(low.x,x),mini(low.y,y))
			high = Vector2i(maxi(high.x,x),maxi(high.y,y))
	return Rect2(low,high-low+Vector2i.ONE) if high.x >= 0 else Rect2(Vector2.ZERO,image.get_size())

func supported_foot(foot: Vector2, width: float) -> Vector2:
	var result := foot
	var nearest := INF
	for rect in terrain():
		if absf(rect.position.y-foot.y)>8 or rect.size.x < width+8: continue
		var x := clampf(foot.x,rect.position.x+width/2+4,rect.end.x-width/2-4)
		var distance := absf(x-foot.x)
		if distance < nearest:
			nearest = distance
			result = Vector2(x,foot.y)
	return result

func prop_rect(key: String, foot: Vector2, bounds: Vector2) -> Rect2:
	var region: Rect2 = prop_regions.get(key,Rect2(Vector2.ZERO,textures[key].get_size()))
	var size := region.size*minf(bounds.x/region.size.x,bounds.y/region.size.y)
	var anchor := supported_foot(foot,size.x)
	return Rect2(anchor-Vector2(size.x/2,size.y),size)

func prop(key: String, foot: Vector2, bounds: Vector2, tint := Color.WHITE) -> void:
	var texture: Texture2D = textures[key]
	var region: Rect2 = prop_regions.get(key,Rect2(Vector2.ZERO,texture.get_size()))
	draw_texture_rect_region(texture,prop_rect(key,foot,bounds),region,tint)

static func parallax_origin(camera_center: Vector2, layer: int) -> Vector2:
	var rate: float = PARALLAX_RATES[layer]
	return Vector2(camera_center.x*(1.0-rate),-230+(camera_center.y-360)*(1.0-rate*0.25))

func _draw() -> void:
	if not active or textures.is_empty(): return
	var cam := get_viewport().get_camera_2d()
	var center := cam.get_screen_center_position()-global_position if cam else Vector2(640,360)
	if reference_decor.available():
		reference_decor.draw_background(self,center,area_index)
	else:
		draw_texture_rect(textures["ENV-02_distant_background"],Rect2(center.x-900,-230,1800,1000),false,Color.WHITE)

	reference_decor.draw_architecture(self,terrain())
	if area_index == 1:
		draw_rect(Rect2(0,738 if puzzle_cleared else 690,4600,180),Color(0.12,0.35,0.39,0.7))
		for x in range(0,4600,75): draw_line(Vector2(x,(756 if puzzle_cleared else 708)+sin(clock+x)*3),Vector2(x+40,(756 if puzzle_cleared else 708)+sin(clock+x)*3),Color(0.53,0.8,0.75,0.45),2)
	for rect in terrain():
		if reference_decor.available(): reference_decor.draw_terrain(self,rect)
		else:
			draw_texture_rect(textures["TILE-001_surface_strip"],Rect2(rect.position,Vector2(rect.size.x,36)),false)
	reference_decor.draw_foliage(self,terrain())
	reference_decor.draw_lanterns(self,terrain(),WIDTH)
	if discovered:
		prop("ENV-02_decorative_props_00",Vector2(2620,620),Vector2(80,125))
		draw_string(ThemeDB.fallback_font,Vector2(2540,470),"MEMORY RECORDED",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ffe2a1"))
	_draw_puzzle()
	var discovery := Vector2(1560,285) if area_index != 1 else Vector2(1510,305)
	if not discovered:
		draw_circle(discovery,14+sin(clock*3)*3,Color(1,0.8,0.35,0.3))
		draw_circle(discovery,7,Color("ffe2a1"))
		draw_string(ThemeDB.fallback_font,discovery+Vector2(-65,-24),["CANOPY MAP","ROOTKEEPER NOTE","GROVE SEED"][area_index],HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("ffe2a1"))


static func enemy_spawns(index: int) -> Array:
	# Every patrol has a solid floor; upper routes allow players to flank the guards.
	return [[350.0,"sporeling"],[1200.0,"sporeling"],[2100.0,"brambleguard"],[2660.0,"sporeling"],[3370.0,"brambleguard"],[3730.0,"sporeling"],[4260.0,"brambleguard"]]

func puzzle_positions() -> Array:
	if area_index == 0: return [Vector2(2820,620),Vector2(3060,620),Vector2(3300,620)]
	if area_index == 1: return [Vector2(2860,620),Vector2(3500,620)]
	return [Vector2(2800,620),Vector2(3070,620),Vector2(3340,620)]

func puzzle_hint(local: Vector2) -> String:
	if puzzle_cleared: return "The root seal is open — follow the path east."
	for spot in puzzle_positions():
		if absf(local.x-spot.x)<85 and absf(local.y-spot.y)<140:
			return ["E / Y  Light lantern · Follow the carved order I → III → II", "E / Y  Turn sluice · Open the upstream wheel, then the downstream wheel", "E / Y  Align shrine · Moon → Leaf → Sun"][area_index]
	if local.x>3650: return "Roots seal the exit. " + ["Light the lanterns I → III → II.","Turn upstream and downstream waterwheels.","Align the three shrine glyphs: Moon → Leaf → Sun."][area_index]
	return "Explore east through the jungle · Solve the root seal to continue"

func interact_at(local: Vector2) -> String:
	if puzzle_cleared: return ""
	var chosen := -1
	var spots := puzzle_positions()
	for i in spots.size():
		if absf(local.x-spots[i].x)<85 and absf(local.y-spots[i].y)<140: chosen=i
	if chosen<0: return ""
	var order: Array = [[0,2,1],[0,1],[2,0,1]][area_index]
	if chosen != order[puzzle_progress]:
		puzzle_progress=0
		puzzle_message="The roots rest. Try the carved sequence again."
	else:
		puzzle_progress+=1
		puzzle_message="The root seal answers · %d / %d" % [puzzle_progress,order.size()]
		if puzzle_progress==order.size():
			puzzle_cleared=true
			gate.collision_layer=0
			puzzle_message=["Canopy lanterns restored", "Floodwater diverted — root crossing secured", "Lantern shrine awakened"][area_index]
			puzzle_solved.emit(area_index)
	queue_redraw()
	return puzzle_message

func _draw_puzzle() -> void:
	var spots := puzzle_positions()
	var labels: Array = [["I","II","III"],["UPSTREAM","DOWNSTREAM"],["LEAF","SUN","MOON"]][area_index]
	for i in spots.size():
		var foot: Vector2=spots[i]
		if area_index==0:
			reference_decor.prop(self,"PROP-001_lantern_post",foot,Vector2(75,145))
		else:
			prop("ENV-03_interactive_props_03",foot,Vector2(110,145))
		var order: Array=[[0,2,1],[0,1],[2,0,1]][area_index]
		var lit := puzzle_cleared or order.slice(0,puzzle_progress).has(i)
		var marker := foot+Vector2(0,-151)
		draw_circle(marker,4,Color("ffe2a1") if lit else Color("4d6657"))
		draw_string(ThemeDB.fallback_font,foot+Vector2(-45,-165),labels[i],HORIZONTAL_ALIGNMENT_CENTER,90,16,Color("ffe2a1"))
	var inscription: String=["LANTERN SEAL · I → III → II","WATER SEAL · UPSTREAM → DOWNSTREAM","SHRINE SEAL · MOON → LEAF → SUN"][area_index]
	draw_string(ThemeDB.fallback_font,Vector2(2750,375),inscription,HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("ffe2a1"))
	reference_decor.draw_gate(self,GATE_X,puzzle_cleared)
	if not puzzle_cleared:
		draw_string(ThemeDB.fallback_font,Vector2(GATE_X-62,355),"ROOT SEAL",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("ffe2a1"))

func get_reference_light_anchors() -> Array[Dictionary]:
	var anchors: Array[Dictionary] = reference_decor.light_anchors(terrain(),WIDTH,global_position)
	if not active: return []
	var order: Array = [[0,2,1],[0,1],[2,0,1]][area_index]
	var spots := puzzle_positions()
	for i in spots.size():
		var flame: Vector2 = reference_decor.lantern_flame({"key":"PROP-001_lantern_post","foot":spots[i],"bounds":Vector2(75,145)}) if area_index==0 else spots[i]+Vector2(0,-95)
		anchors.append({"world_position":global_position+flame,"local_position":flame,"color":Color("ffc75a"),"energy":0.8,"radius":185.0,"active":puzzle_cleared or order.slice(0,puzzle_progress).has(i)})
	if not puzzle_cleared:
		anchors.append({"world_position":global_position+Vector2(GATE_X,480),"color":Color("ffc75a"),"energy":0.5,"radius":165.0,"active":true})
	return anchors

func terrain() -> Array:
	return PLATFORMS[area_index] + [Rect2(2700,520,190,28),Rect2(2940,435,220,28),Rect2(3220,350,260,28),Rect2(3570,435,220,28),Rect2(3820,520,160,28)]
