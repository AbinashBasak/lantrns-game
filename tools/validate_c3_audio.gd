extends SceneTree
var failures: int = 0
var deadline_ms: int = 0
func _initialize() -> void:
	deadline_ms = Time.get_ticks_msec() + 10000
	call_deferred("run")
func _process(_delta: float) -> bool:
	if Time.get_ticks_msec() > deadline_ms:
		printerr("FAIL Chapter3 audio validation exceeded10-second timeout")
		quit(1)
	return false
func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL " + message)
func run() -> void:
	var original_names: Array[StringName] = []
	var original_gains: Array[float] = []
	for i: int in AudioServer.bus_count:
		original_names.append(AudioServer.get_bus_name(i))
		original_gains.append(AudioServer.get_bus_volume_db(i))
	var packed: PackedScene = load("res://scenes/audio/chapter_03/c3_audio_review.tscn")
	if packed == null:
		printerr("FAIL native audio review PackedScene could not load")
		quit(1)
		return
	var scene: Node2D = packed.instantiate()
	packed = null
	root.add_child(scene)
	await process_frame
	check(AudioServer.get_bus_index(&"Effects") >= 0, "Effects bus must exist")
	check(AudioServer.get_bus_index(&"Ambience") >= 0, "Ambience bus must exist")
	check(is_equal_approx(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master")), -6.0), "Master review headroom must be -6dB")
	var ambience: AudioStreamPlayer = scene.get_node("Players/CavernAmbience")
	check(ambience.stream is AudioStreamOggVorbis, "Cavern stream must import as Ogg")
	if ambience.stream is AudioStreamOggVorbis:
		check(ambience.stream.loop, "Cavern loop import must be enabled")
		check(is_equal_approx(ambience.stream.get_length(), 30.0), "Cavern duration must be30 seconds")
		ambience.play(29.95)
		await create_timer(0.24).timeout
		check(ambience.playing, "Cavern must remain playing across loop boundary")
		check(ambience.get_playback_position() < 1.0, "Cavern loop must wrap to beginning")
	for name: String in ["FragmentPickup", "ChestOpen", "RuneGateRumble"]:
		var player: AudioStreamPlayer2D = scene.get_node("Players/" + name)
		check(player.bus == &"Effects", name + " must route through Effects")
		check(player.stream is AudioStreamWAV, name + " must import as WAV")
		if player.stream is AudioStreamWAV:
			check(player.stream.loop_mode == AudioStreamWAV.LOOP_DISABLED, name + " must be a one-shot")
		check(is_equal_approx(player.volume_db, -6.0), name + " must retain -6dB review gain")
		player.play()
		await physics_frame
		await process_frame
		check(player.playing, name + " must start native playback")
		player.stop()
		check(not player.playing, name + " must stop native playback")
	var effects: int = AudioServer.get_bus_index(&"Effects")
	if effects >= 0:
		AudioServer.set_bus_volume_db(effects, -12.0)
		check(is_equal_approx(AudioServer.get_bus_volume_db(effects), -12.0), "Effects bus gain set/get must work")
	scene.stop_all()
	check(not ambience.playing, "Stop All must stop ambience")
	ambience = null
	scene.queue_free()
	scene = null
	# Let the audio thread release stopped playback voices before process teardown.
	await create_timer(0.12).timeout
	await process_frame
	check(AudioServer.bus_count == original_names.size(), "Original bus count must restore")
	for i: int in mini(original_names.size(), AudioServer.bus_count):
		check(AudioServer.get_bus_name(i) == original_names[i], "Original bus name must restore")
		check(is_equal_approx(AudioServer.get_bus_volume_db(i), original_gains[i]), "Original bus gain must restore")
	if failures == 0:
		print("PASS Chapter3 native audio streams/play/stop, actual Ogg loop boundary, WAV one-shots, bus gain routing and original layout restoration")
	else:
		printerr("FAIL Chapter3 native audio: %d checks failed" % failures)
	quit(0 if failures == 0 else 1)
