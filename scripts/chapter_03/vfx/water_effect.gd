extends Node2D
## Effect commands only; artwork/material/particles remain editable scene resources.
@export var reduced_effects: bool = false
@export var flowing: bool = true

func _ready() -> void:
	set_reduced_effects(reduced_effects)

func set_reduced_effects(enabled: bool) -> void:
	reduced_effects = enabled
	var sprite: Sprite2D = $Artwork
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()
		(sprite.material as ShaderMaterial).set_shader_parameter("motion", 0.0 if enabled or not flowing else 1.0)
	if has_node("Mist/Particles"):
		$Mist/Particles.emitting = flowing and not enabled

func set_flowing(enabled: bool) -> void:
	flowing = enabled
	visible = enabled
	set_reduced_effects(reduced_effects)
