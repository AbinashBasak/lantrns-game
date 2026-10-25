extends Node2D
## Generic commands for authored CPU emitters; call trigger() for one-shot effects.
@export var reduced_effects: bool = false
@export var continuous: bool = true
func _ready() -> void:
	set_reduced_effects(reduced_effects)
func set_reduced_effects(enabled: bool) -> void:
	reduced_effects = enabled
	$Particles.emitting = continuous and not enabled
func trigger() -> void:
	if not reduced_effects:
		$Particles.restart()
		$Particles.emitting = true
