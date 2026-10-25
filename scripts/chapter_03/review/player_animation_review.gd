extends Node2D
## Controls the authored review graph only; no campaign actor or scene construction.
@onready var playback: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var status: Label = $ReviewUI/Panel/Controls/Status
var requested_state: StringName = &"Idle"

func preview_idle() -> void:
    request_state(&"Idle")

func preview_run() -> void:
    request_state(&"Run")

func request_state(state: StringName) -> void:
    if state not in [&"Idle", &"Run"] or state == requested_state:
        return
    requested_state = state
    playback.travel(state)
    status.text = "Idle · 4 interior poses from 6-pose source · 6 FPS" if state == &"Idle" else "Run · 6 interior cells from 8-pose source · 10 FPS"
