extends Node2D
## Generated audio and effects, mixed through independent persisted audio controls.
const MANIFEST := "res://assets/runtime/prologue/presentation/manifest.json"
const Generated = preload("res://scripts/companions/generated_animation.gd")
var game: Node
var clips: Dictionary
var music: AudioStreamPlayer
var ambience: AudioStreamPlayer
var voices: Array[AudioStreamPlayer] = []
var voice_index := 0
var reduced_effects := false
var music_level := 0.65
var effects_level := 0.75
var ambient_level := 0.55
var lantern: AnimatedSprite2D
var settings: ConfigFile

func _ready() -> void:
	add_to_group("prologue_presentation")
	clips = JSON.parse_string(FileAccess.get_file_as_string(MANIFEST))
	settings = ConfigFile.new()
	settings.load("user://preferences.cfg")
	music_level = float(settings.get_value("audio", "music", music_level))
	effects_level = float(settings.get_value("audio", "effects", effects_level))
	ambient_level = float(settings.get_value("audio", "ambience", ambient_level))
	reduced_effects = bool(settings.get_value("display", "reduced_effects", false))
	for spec in [["Music", music_level], ["Effects", effects_level], ["Ambience", ambient_level]]:
		if AudioServer.get_bus_index(spec[0]) < 0:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count - 1, spec[0])
		set_volume(spec[0], spec[1], false)
	music = _voice("Music")
	ambience = _voice("Ambience")
	for i in 8: voices.append(_voice("Effects"))
	_loop(music, "village_music", -8)
	_loop(ambience, "village_ambience", -12)
	lantern = AnimatedSprite2D.new()
	lantern.sprite_frames = Generated.frames_from_manifest(MANIFEST)
	lantern.centered = false
	lantern.offset = Vector2(-128, -128)
	lantern.scale = Vector2.ONE * 0.8
	lantern.position = Vector2(1200, 520)
	lantern.z_index = 4
	add_child(lantern)
	lantern.play("lantern")

func _voice(bus: String) -> AudioStreamPlayer:
	var voice := AudioStreamPlayer.new()
	voice.bus = bus
	add_child(voice)
	return voice

func set_volume(bus: String, value: float, persist := true) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(maxf(value, 0.001)))
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value <= 0.001)
	settings.set_value("audio", {"Music":"music", "Effects":"effects", "Ambience":"ambience"}[bus], value)
	if persist: settings.save("user://preferences.cfg")

func set_reduced_effects(value: bool) -> void:
	reduced_effects = value
	settings.set_value("display", "reduced_effects", value)
	settings.save("user://preferences.cfg")

func _loop(voice: AudioStreamPlayer, key: String, db: float) -> void:
	voice.stream = load(clips.audio[key].path)
	voice.stream.loop = true
	voice.volume_db = db
	voice.play()

func begin() -> void:
	cue("ui", Vector2.ZERO)

func fail_hearth() -> void:
	lantern.hide()
	var fade := create_tween()
	fade.tween_property(music, "volume_db", -50.0, 1.2)
	fade.parallel().tween_property(ambience, "volume_db", -45.0, 1.2)
	fade.tween_callback(func():
		music.stop()
		_loop(ambience, "night", -15)
		cue("rumble", Vector2(1200, 620))
	)

func cue(key: String, at: Vector2) -> void:
	# Repetitive running recordings are intentionally silent; keep movement visuals.
	if key not in ["step", "stone_step"] and clips.audio.has(key):
		var voice := voices[voice_index % voices.size()]
		voice_index += 1
		voice.stream = load(clips.audio[key].path)
		# The same rumble recording is looped ambience in the archive, a brief event here.
		voice.stream = voice.stream.duplicate()
		voice.stream.loop = false
		voice.volume_db = -15.0 if key in ["step", "ui", "rumble"] else -10.0
		voice.play()
	if reduced_effects or not clips.animations.has(key): return
	var effect: Dictionary = clips.animations[key]
	Generated.one_shot(self, at, MANIFEST, key, 0.65 if key == "swing" else 0.8, Vector2(effect.pivot_px[0], effect.pivot_px[1]), game.player.facing if key == "swing" else 1)

func _process(_delta: float) -> void:
	if not is_instance_valid(game): return
	lantern.visible = game.beat < game.Beat.FAILURE and not reduced_effects

func _exit_tree() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null
