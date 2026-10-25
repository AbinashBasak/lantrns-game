# Chapter 3 progression and section handoff

These native components implement production-bible §13.2–13.4 without adding a chapter layout or inventing collection/relic totals. They are reusable integration components; no autoload or main-scene selection is changed here.

## Shared state Resource

Create one `C3ChapterState` Resource for the run and pass that same Resource to section exits and props. `chapter_state.gd` exports separate stable-ID maps for opened chests, fragments, keys, switches, unlocked doors, solved puzzles, defeated bosses, water level states, mirror states and inventory, plus checkpoint ID, health/vitality and chapter completion. IDs accept letters/digits and `_.:-`, begin with a letter/digit, and reject node paths. Mirror orientations and inventory quantities are nonnegative integers; water states are named content states, without a guessed number of levels/orientations.

Use `set_flag(category, id)` / `has_flag(category, id)` for boolean maps. Props implement `restore_chapter_state(state)` to apply saved visuals/physics on entry, and use their content ID rather than scene-tree location. The transition coordinator calls this hook after assigning the shared Resource.

`save_atomic(path)` serializes schema version 1 plus a SHA-256 integrity check, flushes a temporary file in the same directory, then atomically renames it over the save. Invalid snapshots and failed writes leave the previous save intact. The parent directory must already exist. `load_save(path)` validates the entire document before mutating the live Resource; malformed, oversized, wrong-version and corrupt files return an error. The checksum detects corruption; it is not an anti-cheat signature.

Chapter completion uses `complete_after_victory(final_boss_stable_id, save_path)`. It requires that boss's explicit defeat flag and a successful save, rolling the completion flag back on save failure. The actual final boss content ID and any collection/relic requirements belong to the authored chapter rules; this component invents none.

## One interaction owner

Add a Node with `interaction_controller.gd` beside the player/HUD and connect `prompt_changed(text, target)` to the existing guidance/prompt UI. Assign `player_path`, or let it use the player group. Props join `c3_interactables` and implement all four methods:

- `can_interact(player) -> bool`
- `interact(player) -> void`
- `get_prompt_text() -> String`
- `get_persistent_state_key() -> String`

The coordinator selects the closest valid visible target within its exported radius, breaks equal-distance ties by stable ID, and rechecks eligibility on interaction. Consumed/freed/out-of-range props clear or change the prompt immediately. Its exported input action defaults to `interact`; the project input action must be configured by the integration owner. Individual props do not own their own input loop.

## Explicit section exits

Instance `scenes/chapter_03/core/section_exit.tscn`. Its Area2D collision shape, CanvasLayer fade and fade-in/out AnimationPlayer tracks are editable in Godot. The reusable scene starts disabled until its destination is configured.

Set `destination_scene`, `destination_spawn_id` and `chapter_state`, then enable it. The destination must contain the normal player and a Marker2D whose name or `spawn_id` metadata matches the exported ID. Validation rejects missing scenes, markers and players before fading or disabling the source player. This implementation passes a spawn ID rather than an absolute map coordinate.

An accepted handoff snapshots health/vitality and any player inventory dictionary, retains shared chapter inventory, freezes the departing player, fades, and defers the scene swap. On entry it assigns the same state Resource, calls prop restoration hooks, restores health/vitality and HUD signals, places the player at the Marker2D, and fades in. It does not heal on same-chapter transitions. Failed swaps restore source input and fade back in.

Arrival exits are blocked for a brief grace period AND until the player leaves every overlapping exit. Merely waiting inside an exit cannot create a return loop. The state Resource is also available on the destination scene as `chapter3_state` metadata. A destination should include a section-exit component so the normal arrival-overlap guard is maintained.

## Validation

`tests/chapter03_progression_test.gd` exercises every state category through an actual file reload, failed/malformed data isolation, completion failure/success, nearest eligible interaction, invalid destinations, an actual deferred fade/scene swap using the existing player scene, 3 hearts/41 vitality continuity, shared inventory and arrival blocking until the player exits the Area2D. Temporary saves live under `/tmp` so the test can run inside the workspace sandbox. Godot 4.7.2 headless passed; the environment emits its existing macOS certificate/log-directory warnings.
