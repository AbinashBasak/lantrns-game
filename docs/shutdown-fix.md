# Level shutdown correction — 2026-10-25

The actual Chapter 1 scene now closes without leaked CanvasItems, physics RIDs, objects, or resources. This fixes scene ownership rather than suppressing diagnostics.

## Cause and correction

`chapter01_forgotten_trail.tscn` instanced reusable actor and jungle scenes while also declaring full copies of their existing children with `type=`. Instantiation replaced inherited children and left the originals orphaned. The reproduced baseline leaked 1,336 CanvasItems and 1,706 objects. Seven actor sprite/collider pairs and the three complete jungle Background/Terrain/StaticArt subtrees appeared in Godot's orphan-node report.

Removed redundant inherited child definitions from the level. The reusable jungle scenes retain the same authored artwork, terrain, foliage and props; the level retains each room's placement, visibility and process settings. The copied jungle properties matched the reusable scenes before removal. Six accidentally serialized runtime gate nodes were also removed; each jungle controller still creates its intended gate once. The large text reduction removes duplicated serialization, not environment assets or authored rooms.

The player, Thornlings and Sentinel now inherit their actual shared sprite/collider nodes without stale animation/autoplay overrides. The player's level-specific Camera2D is retained. Removed the equivalent duplicate sprite/collider in the prologue.

Chapter and prologue presentation teardown now explicitly stops audio and releases streams. Chapter presentation also kills its crossfade tween. This removes the remaining twelve Ogg playback objects when quitting during playback.

## Verification

- `tests/level_lifecycle_test.gd`: loads, begins, and frees the complete Prologue, Chapter 1 and Chapter 2 trees; zero added orphan nodes, inherited player AnimationTree present, no duplicate player sprite.
- Godot 4.7.2 graphical Compatibility render using `tests/capture_player_native_runtime.gd`: native player attack at 0.18 seconds, light on/off captures saved; process exits 0 with **no warnings or errors and no resource/RID/object leaks**.
- Inspected `docs/chapter03/runtime-player-native-attack.png`: Chapter 1 art, player, companion, terrain and unchanged hearts/vitality HUD render correctly.
- Project scene/resource reference checker: 0 errors, 0 warnings across 883 files.

Headless execution inside the filesystem sandbox prints macOS certificate/log-directory access errors; these are unrelated to scene lifecycle. The graphical verification runs outside that sandbox and reports none.
