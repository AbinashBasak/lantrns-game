extends Node2D
# Code-native placeholder environment. No reference boards are used as game textures.
var clock: float = 0.0

func _process(delta: float) -> void:
	clock += delta
	queue_redraw()

func _draw() -> void:
	var cam := get_viewport().get_camera_2d()
	var offset := cam.global_position.x - 640 if cam else 0.0
	# Camera-relative parallax layers.
	for layer in 3:
		var spacing: float = 195.0 + layer * 125.0
		var parallax: float = 0.14 + layer * 0.19
		var tint := [Color("102b32"),Color("153b3d"),Color("1b4945")][layer] as Color
		for i in range(-3,26):
			var x: float = i * spacing + offset * (1.0-parallax)
			var width: float = 32 + layer*11 + fmod(absf(sin(i*17.0))*90,40)
			draw_colored_polygon(PackedVector2Array([Vector2(x-width,800),Vector2(x-width*0.4,260),Vector2(x-width*0.8,-100),Vector2(x+width*0.4,-100),Vector2(x+width,800)]),tint)
			draw_line(Vector2(x,260),Vector2(x-110,100),tint,width*0.5)
			draw_line(Vector2(x+2,180),Vector2(x+130,35),tint,width*0.4)
			for leaf in 3:
				draw_circle(Vector2(x-70+leaf*72,40+sin(i*3.0+leaf)*50),105+layer*18,tint)
	for i in 38:
		var x := fmod(i*137.0+clock*(8+i%3),3700)
		var y := 170+fmod(i*79.0,360)+sin(clock+i)*18
		draw_circle(Vector2(x,y),2,Color(0.95,0.75,0.4,0.3+sin(clock*2+i)*0.2))
