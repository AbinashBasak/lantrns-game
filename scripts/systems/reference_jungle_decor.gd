extends RefCounted
## Modular cutouts from the supplied reference. Color.WHITE preserves the provided palette.
const ART := "res://assets/runtime/chapter01/reference_jungle/"
const KEYS := ["ENV-02_background", "ENV-02_treehouse", "ENV-02_tree_arch", "ENV-02_waterfall", "OBJ-004_root_seal", "PROP-002_lantern_hanging", "PROP-002_lantern_small", "PROP-001_lantern_post", "TILE-001_ground", "TILE-003_platform", "TILE-005_vine_platform", "TILE-016_fern", "PROP-011_fern", "PROP-011_bush", "PROP-011_mushroom", "PROP-012_stump", "PROP-011_hanging_vine", "PROP-011_leaf_cluster", "PROP-011_lush_fern"]
var textures: Dictionary = {}
var ground_color := Color.WHITE

func load_assets() -> void:
	for key in KEYS:
		var path: String = ART + key + ".png"
		if ResourceLoader.exists(path): textures[key] = load(path)
	# The atlas thumbnail is a reference, never a full-screen texture.
	if textures.has("ENV-02_background") and textures["ENV-02_background"].get_width()<1200:
		textures["ENV-02_background"]=load("res://assets/runtime/chapter01/environment/ENV-02_distant_background.png")
	if textures.has("TILE-001_ground"):
		var ground: Texture2D=textures["TILE-001_ground"]
		ground_color=ground.get_image().get_pixel(ground.get_width()/2,ground.get_height()/2)

func available() -> bool:
	return textures.has("ENV-02_background")

func image(target: Node2D, key: String, rect: Rect2, tint := Color.WHITE) -> void:
	if textures.has(key): target.draw_texture_rect(textures[key], rect, false, tint)

func prop_rect(key: String, foot: Vector2, bounds: Vector2) -> Rect2:
	if not textures.has(key): return Rect2(foot, Vector2.ZERO)
	var size: Vector2 = textures[key].get_size()
	size *= minf(1.0,minf(bounds.x / size.x, bounds.y / size.y))
	return Rect2(foot - Vector2(size.x * 0.5, size.y), size)

func prop(target: Node2D, key: String, foot: Vector2, bounds: Vector2) -> void:
	image(target, key, prop_rect(key, foot, bounds))

func draw_background(target: Node2D, center: Vector2, variant: int) -> void:
	var origin := Vector2(center.x * 0.90, -180 + (center.y-360)*0.975)
	var background: Texture2D = textures["ENV-02_background"]
	var tile_width := 1000.0*background.get_width()/background.get_height()
	for tile in range(int(floor((center.x-origin.x-800)/tile_width))-1,int(floor((center.x-origin.x-800)/tile_width))+4):
		var at := origin + Vector2(tile*tile_width,0)
		target.draw_set_transform(at + Vector2(tile_width if posmod(tile,2) else 0,0),0,Vector2(-1 if posmod(tile,2) else 1,1))
		image(target,"ENV-02_background",Rect2(0,0,tile_width+1,1000))
		target.draw_set_transform(Vector2.ZERO)
	# Only light canopy pieces use parallax. Architecture is rooted to authored
	# terrain below, so camera motion cannot detach its base from the ground.
	var mid_origin := Vector2(center.x*0.76, (center.y-360)*0.94)
	for x in range(-1200,6000,1100):
		prop(target,"PROP-011_hanging_vine",mid_origin+Vector2(x+1040,155),Vector2(56,240))
		prop(target,"PROP-011_leaf_cluster",mid_origin+Vector2(x+230,130),Vector2(130,85))

func architecture_layout(platforms: Array) -> Array[Dictionary]:
	var result: Array[Dictionary]=[]
	for rect: Rect2 in platforms:
		if rect.position.y!=620 or rect.size.x<500: continue
		var count := maxi(1,int(rect.size.x/1150))
		for i in count:
			var x := rect.position.x+rect.size.x*(i+0.5)/count
			# Both feet and the complete support silhouette stay above solid ground.
			var key := "ENV-02_treehouse" if posmod(int(x/500),2)==0 else "ENV-02_tree_arch"
			var width := minf(500,rect.size.x-70)
			result.append({"key":key,"foot":Vector2(x,rect.position.y+12),"bounds":Vector2(width,650)})
	return result

func draw_architecture(target: Node2D, platforms: Array) -> void:
	for item in architecture_layout(platforms): prop(target,item.key,item.foot,item.bounds)
	# Cascades occupy the real gaps behind terrain, continuing below the screen.
	var floors: Array[Rect2]=[]
	for rect: Rect2 in platforms:
		if rect.position.y==620: floors.append(rect)
	for i in range(floors.size()-1):
		var gap_start := floors[i].end.x
		var gap_end := floors[i+1].position.x
		if gap_end-gap_start>75:
			prop(target,"ENV-02_waterfall",Vector2((gap_start+gap_end)*0.5,1020),Vector2(300,580))

func draw_terrain(target: Node2D, rect: Rect2) -> void:
	var floating := rect.size.y < 50
	var key := "TILE-005_vine_platform" if floating else "TILE-001_ground"
	if floating and int(rect.position.x/100)%2==0: key="TILE-003_platform"
	if not textures.has(key): return
	var tex: Texture2D = textures[key]
	if floating:
		# Preserve cutout silhouette. Tile center strips; retain natural left/right caps.
		var height := 89.0 if key=="TILE-005_vine_platform" else 58.0
		_draw_capped(target,tex,Rect2(rect.position-Vector2(0,8),Vector2(rect.size.x,height)),height)
	else:
		# Source modules have rounded alpha edges. Interior rock slices cover the
		# floor continuously; the grass silhouette is sampled only on the top row.
		target.draw_rect(rect,ground_color)
		var tile_width := 192.0
		for x in range(int(rect.position.x),int(rect.end.x),int(tile_width)):
			var width := minf(tile_width,rect.end.x-x)
			var source_width := (tex.get_width()-24)*width/tile_width
			target.draw_texture_rect_region(tex,Rect2(x,rect.position.y-8,width+0.5,110),Rect2(12,0,source_width,tex.get_height()-12))
			for y in range(int(rect.position.y+94),int(rect.end.y),72):
				var height := minf(73,rect.end.y-y)
				target.draw_texture_rect_region(tex,Rect2(x,y,width+0.5,height),Rect2(12,48,source_width,(tex.get_height()-60)*height/73))

func _draw_capped(target: Node2D, tex: Texture2D, dest: Rect2, height: float) -> void:
	var scale := height/tex.get_height()
	var cap := minf(32.0,dest.size.x*0.25)
	var source_cap := cap/scale
	target.draw_texture_rect_region(tex,Rect2(dest.position,Vector2(cap,height)),Rect2(0,0,source_cap,tex.get_height()))
	target.draw_texture_rect_region(tex,Rect2(dest.end.x-cap,dest.position.y,cap,height),Rect2(tex.get_width()-source_cap,0,source_cap,tex.get_height()))
	var center_width := maxf(1.0,(tex.get_width()-2*source_cap)*scale)
	var x := dest.position.x+cap
	while x < dest.end.x-cap-0.01:
		var width := minf(center_width,dest.end.x-cap-x)
		target.draw_texture_rect_region(tex,Rect2(x,dest.position.y,width,height),Rect2(source_cap,0,width/scale,tex.get_height()))
		x += width

func foliage_layout(platforms: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for rect: Rect2 in platforms:
		if rect.size.x < 100: continue
		for x in range(int(rect.position.x+42),int(rect.end.x-30),124):
			var index := posmod(int(x/83)+int(rect.position.y),7)
			var key: String = ["PROP-011_lush_fern","PROP-011_fern","PROP-011_lush_fern","PROP-011_mushroom","PROP-011_bush","PROP-011_lush_fern","PROP-011_leaf_cluster"][index]
			var width := minf(144.0 if rect.size.y>50 else 90.0,rect.size.x-12)
			var foot := Vector2(clampf(x,rect.position.x+width/2,rect.end.x-width/2),rect.position.y+2)
			result.append({"key":key,"foot":foot,"bounds":Vector2(width,44 if rect.size.y>50 else 30)})
	return result

func draw_foliage(target: Node2D, platforms: Array) -> void:
	for item in foliage_layout(platforms): prop(target,item.key,item.foot,item.bounds)

func lantern_layout(platforms: Array, width: float) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for x in range(320,int(width-150),680):
		for rect: Rect2 in platforms:
			if rect.position.y==620 and x>rect.position.x+70 and x<rect.end.x-70:
				var key := "PROP-001_lantern_post" if posmod(x/680,3)==0 else "PROP-002_lantern_hanging"
				var foot := Vector2(x,620 if key=="PROP-001_lantern_post" else 365)
				result.append({"key":key,"foot":foot,"bounds":Vector2(84,210 if key=="PROP-001_lantern_post" else 128)})
	return result

func lantern_flame(item: Dictionary) -> Vector2:
	var rect := prop_rect(item.key,item.foot,item.bounds)
	return rect.position+rect.size*Vector2(0.5,0.27 if item.key=="PROP-001_lantern_post" else 0.64)

func draw_lanterns(target: Node2D, platforms: Array, width: float) -> void:
	for item in lantern_layout(platforms,width): prop(target,item.key,item.foot,item.bounds)

func light_anchors(platforms: Array, width: float, offset: Vector2) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item in lantern_layout(platforms,width):
		var flame := lantern_flame(item)
		result.append({"world_position":offset+flame,"local_position":flame,"color":Color("ffc75a"),"energy":0.65,"radius":210.0,"active":true})
	for item in architecture_layout(platforms):
		if item.key!="ENV-02_treehouse": continue
		var house := prop_rect(item.key,item.foot,item.bounds)
		for uv: Vector2 in [Vector2(0.113,0.425),Vector2(0.591,0.467),Vector2(0.902,0.465)]:
			var flame := house.position+house.size*uv
			result.append({"world_position":offset+flame,"local_position":flame,"color":Color("ffc75a"),"energy":0.16,"radius":180.0,"active":true})
	return result

func draw_gate(target: Node2D, gate_x: float, opened: bool) -> void:
	if not opened:
		prop(target,"OBJ-004_root_seal",Vector2(gate_x,620),Vector2(168,240))
	else:
		# A small stump and foliage replace the closed door: the route is visibly open.
		prop(target,"PROP-012_stump",Vector2(gate_x-88,620),Vector2(68,78))
		prop(target,"PROP-011_fern",Vector2(gate_x+95,620),Vector2(72,52))
