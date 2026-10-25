extends Node2D
## Standalone review installs its serialized layout temporarily, then restores it.
var previous_layout: AudioBusLayout
func _enter_tree() -> void:
	previous_layout = AudioServer.generate_bus_layout()
	AudioServer.set_bus_layout(load("res://resources/chapter_03/audio/review_bus_layout.tres"))
func _exit_tree() -> void:
	stop_all()
	# Release stream/playback references before the audio server shuts down.
	for player: Node in $Players.get_children():
		player.stream = null
	if previous_layout != null:
		AudioServer.set_bus_layout(previous_layout)
		previous_layout = null
func stop_all() -> void:
	for player: Node in $Players.get_children():
		player.stop()
func _on_ambience_pressed() -> void:
	$Players/CavernAmbience.play()
func _on_pickup_pressed() -> void:
	$Players/FragmentPickup.play()
func _on_chest_pressed() -> void:
	$Players/ChestOpen.play()
func _on_gate_pressed() -> void:
	$Players/RuneGateRumble.play()
