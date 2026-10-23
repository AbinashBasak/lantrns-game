extends SceneTree
## Rebuild the saved jungle scenes from the existing authored layout.
## Run only when intentionally replacing scene node edits with the source layout.
func _initialize() -> void:
	var jungle_script = load("res://scripts/systems/chapter01_jungle.gd")
	for index in 3:
		var room = jungle_script.new()
		room.name = ["HighCanopy", "FloodedRootways", "LanternGrove"][index]
		room.area_index = index
		room.build_editor_scene()
		var scene := PackedScene.new()
		var result := scene.pack(room)
		if result == OK:
			result = ResourceSaver.save(scene, "res://scenes/levels/jungle_%d.tscn" % index)
		room.free()
		if result != OK:
			push_error("Failed to save jungle room %d: %s" % [index, error_string(result)])
			quit(1)
			return
		print("Saved editable jungle room ", index)
	quit()
