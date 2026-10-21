extends SceneTree
var game: Node
func _initialize() -> void: call_deferred("run")
func shot(label: String) -> void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/reward-"+label+"-preview.png")
func run() -> void:
 game = load("res://scenes/levels/chapter01_forgotten_trail.tscn").instantiate()
 root.add_child(game)
 current_scene = game
 await process_frame
 game._begin()
 game.jungle_cleared.assign([0,1,2])
 for i in 20:
  if not game.dialogue_lines.is_empty(): game._advance_dialogue()
 game.player.position = Vector2(7660,620)
 game.player.active = false
 game.player.visual.visible = true
 game.player.visual.play("idle")
 game.mote.position = Vector2(7600,535)
 game.boss_defeated = true
 game.environment.boss_defeated = true
 game.boss.set_physics_process(false)
 game.boss._set_state("defeated",0)
 game.rewards.chest_available = true
 game.rewards.points = 1300
 game.camera.reset_smoothing()
 for i in 30: await process_frame
 await shot("closed")
 game.rewards.open_chest()
 await create_timer(1.1).timeout
 await shot("opening")
 await create_timer(1.1).timeout
 await shot("reveal")
 await create_timer(2.0).timeout
 await shot("looted")
 quit()
