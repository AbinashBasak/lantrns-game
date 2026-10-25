# Native Godot animation, lighting and effects

The shared gameplay actors now contain editor-authored animation resources. Gameplay scripts choose states and trigger events; Godot's AnimationTree and AnimationPlayer own visual frame progression.

## Inspect the actual gameplay actors

1. Open `scenes/player/player.tscn` in Godot.
2. Select **AnimationTree** to see the state graph in the bottom panel. It is active. Select **AnimationPlayer** to inspect the frame and sword-light tracks.
3. Expand **Effects** for **JumpDust**, **LandingDust**, **SwordHit** (`CPUParticles2D`) and **SwordLight** (`PointLight2D`). The attack clip keys the light's energy during the strike window.
4. Run the existing campaign and move, jump, land and attack. These are the shared player scene's effects, so they also apply to existing level instances.

The player graph uses the seven animation families currently exported for the live character. A second attack state preserves the existing combo timing using the same attack artwork. Missing clean hurt/death exports have not been fabricated from unrelated reference sheets.

Open `scenes/enemies/thornling.tscn` or `scenes/enemies/hollow_sentinel.tscn`, select **AnimationTree**, then enter **States**. Their native graphs use their existing animation artwork and expose a speed control. **ImpactDust** is an authored particle emitter.

## Inspect the Chapter 3 systems

Open `scenes/chapter_03/review/c3_native_systems_review.tscn` and press **F6**. Use **Preview opening** to see the chest's AnimationTree transition, keyed native mouth light and gold burst. The side emitters demonstrate lantern sparks, crystal motes and waterfall mist.

Editable reusable scenes live in `scenes/chapter_03/lighting/` and `scenes/chapter_03/vfx/`. CPU particles work with this project's Compatibility renderer. Lights, occluders, particles, gradients and flicker clips are saved as native Godot nodes/resources.

The eight Chapter 3 section scenes are still empty layout scaffolds. This systems review does not complete the locked level, approve the reference artwork, or replace missing standalone terrain and background exports. Place the reusable rigs at actual source props when those sections are authored.

Detailed verification: [runtime player](chapter03/runtime-player-native-animation.md), [enemies](native-enemy-animation.md), and [Chapter 3 effects](chapter03/native-chapter03-effects.md). The actual Chapter 1 capture now exits cleanly with no errors, warnings or leaks; see [shutdown correction](shutdown-fix.md).

The Sentinel now has native authored warning/root/revival effects with no controller drawing. The separate shrine light review is `scenes/chapter_03/review/c3_shrine_light_review.tscn`. Chapter 3 [progression components](chapter03/progression-systems.md) and a physics-driven native moving-platform prefab are available for authored section integration; these do not populate the eight unfinished levels.
