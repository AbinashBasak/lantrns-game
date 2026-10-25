extends SceneTree

func _initialize() -> void:
    call_deferred("validate")

func validate() -> void:
    var packed := load("res://scenes/chapter_03/review/c3_player_animation_review.tscn") as PackedScene
    assert(packed != null)
    var review := packed.instantiate()
    root.add_child(review)
    await process_frame
    var tree: AnimationTree = review.get_node("AnimationTree")
    tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    tree.advance(0.01)
    var playback: AnimationNodeStateMachinePlayback = tree.get("parameters/playback")
    var sprite: Sprite2D = review.get_node("Player/Sprite2D")
    var player: AnimationPlayer = review.get_node("AnimationPlayer")
    assert(playback.get_current_node() == &"Idle")
    assert(review.get_meta("review_only") and not review.get_meta("production_approved"))
    assert(not sprite.centered and sprite.offset == Vector2(-160, -455))
    assert(review.get_node("Player").scale == Vector2.ONE)
    for clip_name in [&"Idle", &"Run"]:
        var clip := player.get_animation(clip_name)
        var count := 4 if clip_name == &"Idle" else 6
        assert(clip.loop_mode == Animation.LOOP_LINEAR)
        assert(clip.track_get_key_count(0) == count)
        for i in count:
            var atlas: AtlasTexture = clip.track_get_key_value(0, i)
            assert(atlas.atlas.get_size() == Vector2(1774, 887))
            assert(atlas.get_size() == Vector2(320, 455))
            assert(atlas.region.end.x <= 1774 and atlas.region.end.y <= 887)
            assert(atlas.margin.position.y + atlas.region.size.y == 455)
    review.preview_run()
    tree.advance(0.01)
    assert(playback.get_current_node() == &"Run")
    tree.advance(0.23)
    assert((sprite.texture as AtlasTexture).atlas.resource_path.ends_with("C3-CHR-002_run_review_source.png"))
    var before := playback.get_current_play_position()
    review.preview_run()
    assert(is_equal_approx(before, playback.get_current_play_position()))
    tree.advance(0.01)
    assert(playback.get_current_play_position() > before)
    review.preview_idle()
    tree.advance(0.01)
    assert(playback.get_current_node() == &"Idle")
    tree.advance(0.3)
    before = playback.get_current_play_position()
    review.preview_idle()
    review.request_state(&"Attack")
    assert(review.requested_state == &"Idle")
    assert(is_equal_approx(before, playback.get_current_play_position()))
    print("PASS: authored Idle↔Run graph, original source sizes, 4/6 selected regions, equal bottom-aligned atlas canvases, native scale, repeated press guard, rejected invalid state")
    review.queue_free()
    await process_frame
    quit(0)
