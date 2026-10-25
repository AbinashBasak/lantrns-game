extends Node2D
## Attach origin to the actual flame; native AnimationPlayer owns the light flicker.
@export var reduced_effects: bool = false
@export var enabled: bool = true
@export_range(0.0, 3.6) var flicker_phase: float = 0.0
func _ready() -> void:
	add_to_group(&"c3_budgeted_lights")
	set_reduced_effects(reduced_effects)
	if not reduced_effects:
		$AnimationPlayer.seek(fposmod(flicker_phase + global_position.x * 0.007, 3.6), true)
func set_reduced_effects(value: bool) -> void:
	reduced_effects = value
	if value:
		$AnimationPlayer.pause()
		$PointLight2D.energy = 0.88
		$PointLight2D.shadow_enabled = false
	else:
		$AnimationPlayer.play(&"gentle_flicker")
	$PointLight2D.visible = enabled

func set_enabled(value: bool) -> void:
	enabled = value
	$PointLight2D.visible = value
