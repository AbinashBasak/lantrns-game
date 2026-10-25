extends AnimatableBody2D
## Artwork is assigned in the editor; the native animation owns platform motion.
@export var starts_active := false
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if starts_active:
		set_active(true)

func set_active(value: bool) -> void:
	if value:
		if animator.current_animation != &"travel":
			animator.play(&"travel")
		else:
			animator.play()
	else:
		animator.pause()

func reset_to_lower_stop() -> void:
	animator.play(&"travel")
	animator.seek(0.0, true)
	animator.pause()
