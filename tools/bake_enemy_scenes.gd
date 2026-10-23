extends SceneTree
const Generated = preload("res://scripts/companions/generated_animation.gd")
func _initialize() -> void:
	for spec in [
		["thornling","res://assets/runtime/prologue/characters/rootling/manifest.json",Vector2(0.18,0.18)],
		["hollow_sentinel","res://assets/runtime/chapter01/boss/manifest.json",Vector2(-0.4,0.4)],
	]:
		var frames: SpriteFrames = Generated.frames_from_manifest(spec[1])
		var frames_path: String = "res://scenes/enemies/"+spec[0]+"_frames.tres"
		var result := ResourceSaver.save(frames,frames_path)
		assert(result == OK)
		var scene_path: String = "res://scenes/enemies/"+spec[0]+".tscn"
		var scene: Node = load(scene_path).instantiate()
		var sprite := scene.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
		if sprite == null:
			sprite = AnimatedSprite2D.new()
			sprite.name = "AnimatedSprite2D"
			scene.add_child(sprite)
			sprite.owner = scene
		sprite.sprite_frames = load(frames_path)
		sprite.centered = false
		sprite.offset = Vector2(-256,-480)
		sprite.scale = spec[2]
		sprite.animation = "idle"
		sprite.frame = 0
		sprite.autoplay = "idle" if spec[0] == "thornling" else ""
		var packed := PackedScene.new()
		assert(packed.pack(scene) == OK)
		assert(ResourceSaver.save(packed,scene_path) == OK)
		print("Baked editor-visible enemy: ",spec[0])
		scene.free()
	quit()
