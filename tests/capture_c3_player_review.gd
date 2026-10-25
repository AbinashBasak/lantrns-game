extends SceneTree
func _initialize() -> void:
    call_deferred("capture")
func capture() -> void:
    var scene = load("res://scenes/chapter_03/review/c3_player_animation_review.tscn").instantiate()
    root.add_child(scene)
    await process_frame
    await process_frame
    var tree: AnimationTree = scene.get_node("AnimationTree")
    tree.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    tree.advance(0.01)
    await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png("res://docs/chapter03/player-animation-review.png")
    scene.preview_run()
    tree.advance(0.01)
    tree.advance(0.21)
    await process_frame
    await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png("res://docs/chapter03/player-animation-review-run.png")
    quit()
