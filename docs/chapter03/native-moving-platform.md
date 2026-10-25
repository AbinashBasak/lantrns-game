# Native moving platform

`scenes/chapter_03/interactables/c3_moving_platform.tscn` is an editor-authored mechanism for the bible's lifts. Its root locates the lower stop; the Body is an AnimatableBody2D with collision and a matching LightOccluder2D. The AnimationPlayer uses physics processing and keys Body.position, with a pause at each endpoint. `set_active()` starts/pauses the native timeline; `reset_to_lower_stop()` resets it.

The default 192-unit travel and 128-unit top are component test settings, not a placement inferred from the locked map. Edit the position keys and geometry against the actual section route. Assign the required C3-PROP-028 texture in the Artwork Sprite2D before placing it in a finished section. No placeholder illustration or flattened reference thumbnail has been substituted.

`tests/chapter03_moving_platform_test.gd` passes both endpoint holds, full loop, pause/reset and translated root placement. A physical CharacterBody2D lands on the platform and is carried upward while staying on its surface. Actual section routing and appearance remain part of section integration.
