extends Node2D
## Three authored side rooms. All decoration reuses reviewed ENV-02/03 runtime exports.
const ART := "res://assets/runtime/chapter01/environment/"
const NAMES := ["THE HIGH CANOPY", "FLOODED ROOTWAYS", "THE LANTERN GROVE"]
const PLATFORMS := [
	[Rect2(0,620,900,400),Rect2(1050,620,780,400),Rect2(1980,620,1020,400),Rect2(500,520,180,28),Rect2(740,430,200,28),Rect2(1000,350,330,28),Rect2(1470,350,300,28),Rect2(1850,430,200,28),Rect2(2110,520,180,28),Rect2(880,735,210,25),Rect2(1810,735,200,25)],
	[Rect2(0,620,700,400),Rect2(860,620,630,400),Rect2(1650,620,650,400),Rect2(2460,620,540,400),Rect2(520,525,180,28),Rect2(750,445,200,28),Rect2(1010,365,260,28),Rect2(1380,365,250,28),Rect2(1740,445,200,28),Rect2(2100,525,200,28),Rect2(680,735,200,25),Rect2(1470,735,200,25),Rect2(2280,735,200,25)],
	[Rect2(0,620,3000,400),Rect2(650,520,200,28),Rect2(900,435,220,28),Rect2(1190,350,300,28),Rect2(1630,350,300,28),Rect2(2020,435,220,28),Rect2(2290,520,200,28)]
]
var area_index := 0
var active := false
var discovered := false
var textures: Dictionary = {}
var clock := 0.0
func _ready() -> void:
	for key in ["ENV-02_distant_background","ENV-02_midground","ENV-02_foreground","ENV-02_decorative_props_00","ENV-02_decorative_props_01","ENV-02_decorative_props_04","ENV-02_decorative_props_05","ENV-02_interactive_props_03","ENV-03_decorative_props_01","ENV-03_interactive_props_03","TILE-001_surface_strip","TILE-002_soil_fill"]:
		textures[key] = load(ART+key+".png")
	for rect in PLATFORMS[area_index]:
		var body := StaticBody2D.new()
		body.position = rect.get_center()
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		var collision := CollisionShape2D.new()
		collision.shape = shape
		collision.one_way_collision = rect.size.y < 50
		body.add_child(collision)
		add_child(body)
	visible = false
func _process(delta: float) -> void:
	if not active: return
	clock += delta
	queue_redraw()
func prop(key: String, foot: Vector2, bounds: Vector2, tint := Color.WHITE) -> void:
	var texture: Texture2D = textures[key]
	var size := texture.get_size()*minf(bounds.x/texture.get_width(),bounds.y/texture.get_height())
	draw_texture_rect(texture,Rect2(foot-Vector2(size.x/2,size.y),size),false,tint)
func _draw() -> void:
	if not active or textures.is_empty(): return
	var cam := get_viewport().get_camera_2d()
	var cx := cam.global_position.x-global_position.x if cam else 0.0
	var tones := [Color("8fb7a0"),Color("78aeb8"),Color("c3bb83")]
	# Four camera-relative planes move at independent rates; room origins never affect parallax.
	for layer in 4:
		var key: String = ["ENV-02_distant_background","ENV-02_distant_background","ENV-02_midground","ENV-02_foreground"][layer]
		var speed: float = [0.12,0.3,0.55,0.82][layer]
		var offset := fmod(cx*(1.0-speed),1800.0)
		for tile in range(-2,4):
			var tint: Color = tones[area_index]
			tint.a = [1.0,0.22,0.5,0.28][layer]
			draw_texture_rect(textures[key],Rect2(tile*1800+offset,-230,1801,1000),false,tint)
	if area_index == 1:
		draw_rect(Rect2(0,690,3000,180),Color(0.12,0.35,0.39,0.7))
		for x in range(0,3000,75): draw_line(Vector2(x,708+sin(clock+x)*3),Vector2(x+40,708+sin(clock+x)*3),Color(0.53,0.8,0.75,0.45),2)
	for rect in PLATFORMS[area_index]:
		draw_rect(rect,Color("25372b"))
		for x in range(int(rect.position.x),int(rect.end.x),64):
			draw_texture_rect(textures["TILE-001_surface_strip"],Rect2(x,rect.position.y-3,minf(65,rect.end.x-x),36),false)
			if rect.size.y > 40: draw_texture_rect(textures["TILE-002_soil_fill"],Rect2(x,rect.position.y+30,minf(65,rect.end.x-x),rect.size.y-30),false)
	for x in [360,570,1180,1780,2390,2670]: prop("ENV-02_decorative_props_05",Vector2(x,624),Vector2(100,60))
	for x in [50,2880]: prop("ENV-02_interactive_props_03",Vector2(x,620),Vector2(150,215))
	for entry in [[160,"RETURN TO TRAIL"],[2850,"NEXT JUNGLE PATH"]]:
		draw_string(ThemeDB.fallback_font,Vector2(entry[0]-75,460),entry[1],HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ffe2a1"))
	if discovered:
		prop("ENV-02_decorative_props_00",Vector2(2620,620),Vector2(80,125))
		draw_string(ThemeDB.fallback_font,Vector2(2540,470),"TRAIL SHORTCUT",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ffe2a1"))
	if area_index == 0:
		prop("ENV-02_decorative_props_01",Vector2(1550,350),Vector2(230,280))
	elif area_index == 1:
		for x in [420,1830,2580]: prop("ENV-03_decorative_props_01",Vector2(x,620),Vector2(110,270),Color("8ab4ae"))
	else:
		prop("ENV-03_interactive_props_03",Vector2(1550,620),Vector2(230,270))
		for x in [500,950,2100,2550]: prop("ENV-02_decorative_props_04",Vector2(x,620),Vector2(100,95))
	var discovery := Vector2(1560,285) if area_index != 1 else Vector2(1510,305)
	if not discovered:
		draw_circle(discovery,14+sin(clock*3)*3,Color(1,0.8,0.35,0.3))
		draw_circle(discovery,7,Color("ffe2a1"))
		draw_string(ThemeDB.fallback_font,discovery+Vector2(-65,-24),["CANOPY MAP","ROOTKEEPER NOTE","GROVE SEED"][area_index],HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("ffe2a1"))
