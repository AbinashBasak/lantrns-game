extends Node2D

func _on_activate_pressed() -> void:
	$ShrineLight.activate()

func _on_dormant_pressed() -> void:
	$ShrineLight.set_dormant()

func _on_idle_pressed() -> void:
	$ShrineLight.set_idle()

func _on_light_toggled(enabled: bool) -> void:
	$ShrineLight/PointLight2D.visible = enabled

func _on_reduced_toggled(enabled: bool) -> void:
	$ShrineLight.set_reduced_effects(enabled)
