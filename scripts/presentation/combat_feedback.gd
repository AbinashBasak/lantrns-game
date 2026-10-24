extends Node
## Bounded world-camera impacts. Pause, dialogue and reduced effects clear offsets.
var game: Node
var trauma := 0.0
var elapsed := 0.0
var last_kind := ""
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
func pulse(kind: String, strength: float) -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.camera): return
	if game.get_tree().paused or game.presentation.reduced_effects or not game.player.active:
		clear()
		return
	last_kind = kind
	trauma = minf(1.0,maxf(trauma,clampf(strength,0.0,1.0)))
func clear() -> void:
	trauma = 0.0
	if is_instance_valid(game) and is_instance_valid(game.camera): game.camera.offset = Vector2.ZERO
func _process(delta: float) -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.camera): return
	if game.get_tree().paused or game.presentation.reduced_effects or not game.player.active or game.completed:
		clear()
		return
	elapsed += delta
	trauma = maxf(0.0,trauma-delta*3.4)
	var amount := trauma*trauma
	game.camera.offset = Vector2(sin(elapsed*79.0+0.6)*7.0,cos(elapsed*93.0)*4.5)*amount
func _exit_tree() -> void:
	clear()
