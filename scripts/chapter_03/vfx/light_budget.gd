extends Node
## Place one budget manager per section. Does not create or reposition light nodes.
@export_range(1, 16) var visible_light_limit: int = 16
@export_range(0, 2) var shadow_light_limit: int = 2
@export var reduced_effects: bool = false
var elapsed: float = 0.0
func _ready() -> void:
	update_budget()
func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= 0.2:
		elapsed = 0.0
		update_budget()
func update_budget() -> void:
	var viewport: Viewport = get_viewport()
	var world_rect: Rect2 = viewport.get_canvas_transform().affine_inverse() * viewport.get_visible_rect()
	var center: Vector2 = world_rect.get_center()
	var candidates: Array[Node] = []
	for lamp: Node in get_tree().get_nodes_in_group(&"c3_budgeted_lights"):
		if not lamp is Node2D or not lamp.has_node("PointLight2D"):
			continue
		if lamp.reduced_effects != reduced_effects:
			lamp.set_reduced_effects(reduced_effects)
		var light: PointLight2D = lamp.get_node("PointLight2D")
		light.visible = false
		light.shadow_enabled = false
		if lamp.enabled and world_rect.grow(180.0).has_point(lamp.global_position):
			candidates.append(lamp)
	candidates.sort_custom(func(a: Node2D, b: Node2D) -> bool: return a.global_position.distance_squared_to(center) < b.global_position.distance_squared_to(center))
	for index: int in mini(candidates.size(), visible_light_limit):
		var light: PointLight2D = candidates[index].get_node("PointLight2D")
		light.visible = true
		light.shadow_enabled = not reduced_effects and index < shadow_light_limit
