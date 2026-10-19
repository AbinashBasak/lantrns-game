@static_unload
extends RefCounted
static var cached_frames: Dictionary = {}

static func frames_from_manifest(path: String) -> SpriteFrames:
	if cached_frames.has(path):
		return cached_frames[path]
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var result := SpriteFrames.new()
	result.remove_animation("default")
	for key in manifest.animations:
		var clip: Dictionary = manifest.animations[key]
		result.add_animation(key)
		result.set_animation_loop(key, clip.loop)
		result.set_animation_speed(key, 1.0)
		for i in clip.frames.size():
			result.add_frame(key, load(clip.frames[i].path), float(clip.durations_ms[i]) / 1000.0)
	cached_frames[path] = result
	return result

static func one_shot(parent: Node, at: Vector2, pack: String, clip: String, size: float, pivot: Vector2, facing: float = 1.0) -> void:
	var sprite := AnimatedSprite2D.new()
	sprite.process_mode = Node.PROCESS_MODE_PAUSABLE
	sprite.sprite_frames = frames_from_manifest(pack)
	sprite.centered = false
	sprite.offset = -pivot
	sprite.scale = Vector2(size * facing, size)
	sprite.z_index = 8
	parent.add_child(sprite)
	sprite.global_position = at
	sprite.animation_finished.connect(sprite.queue_free)
	sprite.play(clip)
