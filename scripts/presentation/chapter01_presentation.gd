extends Node2D
## Chapter 1 generated audio and effects; preferences match the prologue controls.
const MANIFEST := "res://assets/runtime/chapter01/presentation/manifest.json"
const Generated = preload("res://scripts/companions/generated_animation.gd")
var game: Node
var clips: Dictionary
var music: AudioStreamPlayer
var ambience: AudioStreamPlayer
var music_outgoing: AudioStreamPlayer
var ambience_outgoing: AudioStreamPlayer
var voices: Array[AudioStreamPlayer] = []
var voice_index := 0
var reduced_effects := false
var music_level := 0.65
var effects_level := 0.75
var ambient_level := 0.55
var settings: ConfigFile
var region := ""
var region_tween: Tween

func _ready() -> void:
	add_to_group("prologue_presentation")
	add_to_group("chapter_presentation")
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
	music_outgoing = _voice("Music")
	ambience_outgoing = _voice("Ambience")
	for i in 10: voices.append(_voice("Effects"))
	set_region("forest")

func _voice(bus: String) -> AudioStreamPlayer:
	var voice := AudioStreamPlayer.new()
	voice.bus = bus
	add_child(voice)
	return voice

func set_volume(bus: String, value: float, persist := true) -> void:
	value = clampf(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(maxf(value, 0.001)))
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value <= 0.001)
	match bus:
		"Music": music_level = value
		"Effects": effects_level = value
		"Ambience": ambient_level = value
	settings.set_value("audio", {"Music":"music", "Effects":"effects", "Ambience":"ambience"}[bus], value)
	if persist: settings.save("user://preferences.cfg")

func set_reduced_effects(value: bool) -> void:
	reduced_effects = value
	settings.set_value("display", "reduced_effects", value)
	settings.save("user://preferences.cfg")

func _loop(voice: AudioStreamPlayer, key: String, db: float) -> void:
	voice.stream = load(clips.audio[key].path).duplicate()
	voice.stream.loop = true
	voice.volume_db = db
	voice.set_meta("clip_key", key)
	voice.play()

func begin() -> void:
	cue("ui", Vector2.ZERO)

func set_region(value: String) -> void:
	if value == region or value not in ["forest", "temple", "boss", "reward"]: return
	region = value
	if is_instance_valid(region_tween): region_tween.kill()
	# Reward deliberately returns to the quiet temple score instead of a victory replacement.
	var track := {"forest":"forest_music", "temple":"temple_music", "boss":"boss_music", "reward":"temple_music"}
	region_tween = create_tween().set_parallel(true)
	# Two voices carry the outgoing sound across a boundary. Keep an unchanged
	# ambience playing through the fight and reward, instead of restarting its loop.
	if music.get_meta("clip_key", "") != track[value]:
		var previous_music := music
		music = music_outgoing
		music_outgoing = previous_music
		_loop(music, track[value], -60.0)
	var ambient_key := "forest_ambience" if value == "forest" else "temple_ambience"
	if ambience.get_meta("clip_key", "") != ambient_key:
		var previous_ambience := ambience
		ambience = ambience_outgoing
		ambience_outgoing = previous_ambience
		_loop(ambience, ambient_key, -60.0)
	region_tween.tween_property(music_outgoing, "volume_db", -60.0, 1.2)
	region_tween.tween_property(ambience_outgoing, "volume_db", -60.0, 1.2)
	region_tween.tween_property(music, "volume_db", -13.0 if value == "reward" else -9.0, 1.2)
	region_tween.tween_property(ambience, "volume_db", -17.0 if value == "boss" else -12.0, 1.2)
	region_tween.chain().tween_callback(_finish_region_fade)

func _finish_region_fade() -> void:
	music_outgoing.stop()
	ambience_outgoing.stop()

func cue(key: String, at: Vector2) -> void:
	var alias := {"seed":"fragment", "pickup":"fragment", "rune_activate":"rune", "boss_hit":"boss_damage", "boss_land":"boss_slam"}
	key = alias.get(key, key)
	if key == "boss_slam" and is_instance_valid(game) and "combat_feedback" in game and is_instance_valid(game.combat_feedback):
		game.combat_feedback.pulse("sentinel_slam", 0.5)
	# Repetitive running recordings are intentionally silent; keep movement visuals.
	if key not in ["step", "stone_step"] and clips.audio.has(key):
		var voice := voices[voice_index % voices.size()]
		voice_index += 1
		voice.stream = load(clips.audio[key].path).duplicate()
		voice.stream.loop = false
		voice.volume_db = -17.0 if key in ["step", "stone_step", "ui"] else -10.0
		voice.play()
	if reduced_effects or not clips.animations.has(key): return
	var effect: Dictionary = clips.animations[key]
	var facing := 1
	if key == "swing" and is_instance_valid(game) and is_instance_valid(game.player):
		facing = game.player.facing
	Generated.one_shot(self, at, MANIFEST, key, 0.65 if key == "swing" else 0.8, Vector2(effect.pivot_px[0], effect.pivot_px[1]), facing)

func _exit_tree() -> void:
	if is_instance_valid(region_tween):
		region_tween.kill()
	# Release active mixer playbacks before a level replacement or application exit.
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null
