extends CharacterBody2D
signal defeated
@export var patrol_distance: float = 115.0
var origin: Vector2
var direction: float = -1.0
var health: int = 2
var flash: float = 0.0
var clock: float = 0.0

func _ready() -> void:
	origin = position
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	clock += delta
	flash = maxf(0.0, flash-delta)
	if absf(position.x-origin.x) > patrol_distance or is_on_wall():
		direction *= -1
	velocity.x = direction * 58 if flash <= 0 else velocity.x * 0.88
	velocity.y += 1600 * delta
	move_and_slide()
	for player in get_tree().get_nodes_in_group("player"):
		if player.active and position.distance_to(player.position) < 43:
			player.take_damage(1, signf(player.position.x-position.x))
	queue_redraw()

func take_damage(amount: int, hit_direction: float) -> void:
	health -= amount
	flash = 0.2
	velocity.x = hit_direction * 230
	if health <= 0:
		remove_from_group("enemies")
		defeated.emit()
		queue_free()

func _draw() -> void:
	var color := Color("a1ac68") if flash <= 0 else Color("fff0be")
	draw_circle(Vector2(0,-19),21,Color("3f5341"))
	for i in 7:
		var angle := PI + i * PI / 6
		var p := Vector2(0,-19)+Vector2.from_angle(angle)*18
		draw_colored_polygon(PackedVector2Array([p+Vector2(-5,4),p+Vector2.from_angle(angle)*15,p+Vector2(5,4)]),color)
	draw_circle(Vector2(0,-18),15,color)
	draw_line(Vector2(-10,-5),Vector2(-16+sin(clock*6)*3,0),Color("6c6846"),6)
	draw_line(Vector2(10,-5),Vector2(16-sin(clock*6)*3,0),Color("6c6846"),6)
	draw_circle(Vector2(-7,-21),3,Color("ffcb72"))
	draw_circle(Vector2(7,-21),3,Color("ffcb72"))
