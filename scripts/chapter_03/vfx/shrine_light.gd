extends Node2D
## Commands only: all visual nodes and animation tracks are authored in the scene.
@export var reduced_effects := false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var activating := false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	set_reduced_effects(reduced_effects)

func activate() -> void:
	if activating:
		return
	if reduced_effects:
		set_idle()
		return
	activating = true
	animation_player.play(&"activation")

func set_dormant() -> void:
	activating = false
	animation_player.play(&"dormant")
	animation_player.advance(0)

func set_idle() -> void:
	activating = false
	animation_player.play(&"idle")
	animation_player.advance(0)
	if reduced_effects:
		animation_player.pause()
		$Sparks.emitting = false
		$ActivationBurst.emitting = false

func set_reduced_effects(enabled: bool) -> void:
	reduced_effects = enabled
	set_idle()

func _on_animation_finished(clip: StringName) -> void:
	if clip == &"activation":
		set_idle()
