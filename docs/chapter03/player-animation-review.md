# Chapter 3 player animation source review

This is a review fixture, not a production player or a playable Chapter 3 integration. It preserves the supplied blue-haired design; the campaign player is unchanged. No attack, movement mechanic, art cleanup, synthesized pose or additional gameplay has been inferred.

Open `res://scenes/chapter_03/review/c3_player_animation_review.tscn` in Godot and use Run Current Scene. The scene contains an editable Sprite2D, AnimationPlayer clip library, active AnimationTree with Start→Idle and Idle↔Run states, and native UI. The small controller only requests state travel and updates the status label. Pressing the current state again does not restart its clip. No scene nodes are constructed at runtime.

## Sources and regions

Both review copies are byte-identical 1774×887 RGBA PNGs. Full original file paths and SHA-256 hashes are recorded in `player-animation-review.json`.

- Idle: C3-CHR-001, archived shared-chat message 202. Six source poses; four interior review regions selected. Regions `(x,y,width,height)`: `(300,270,277,455)`, `(577,270,285,455)`, `(862,270,285,455)`, `(1147,270,292,455)`. Four keys at 6 FPS, loop duration 0.666667 seconds.
- Run: C3-CHR-002, supplied attachment 19 `a75b6832-236e-4ed8-93f0-a0522d6907e3.png`. Strong probable match to source-chat message 205 by dimensions, byte length and visual subject; this is not a verified original hash match. Eight source poses; first and last edge poses excluded. Six interior review regions: `(235,330,235,340)`, `(460,330,220,340)`, `(676,330,224,340)`, `(900,330,222,340)`, `(1122,330,208,340)`, `(1330,330,220,340)`. Six keys at 10 FPS, loop duration 0.6 seconds.

AtlasTexture regions retain original pixels. Margins create equal 320×455 virtual canvases with a bottom-center `(160,455)` pivot. Sprite offset is `(-160,-455)`, with 1:1 scale. No upscaling or image transformation is used. These are padded crop baselines; varying source foot positions and scale still produce visible jitter.

## Actual quality limitations

These are **not six clean run frames or four clean idle exports**. The source capes touch/overlap adjacent poses and low-alpha ghost pixels occur in nominally transparent areas. Rectangular extraction cannot fully isolate those silhouettes. The idle preview has a neighboring boot fragment at its left and a truncated right boot in some poses. Run regions preserve each selected head but may truncate cape/limb extremities or include neighboring fragments. No alpha masking or pixel cleanup has been applied. Further production-quality isolation or replacement exports are still required; there is no production approval.

The visible painted lantern glow remains source artwork, not dynamic scene lighting. No light emitter or generated lighting overlay has been added, and the review makes no native-lighting validation claim.

## Verification

Godot 4.7.2 official mono headless test `res://tests/chapter03_player_animation_review_test.gd` passes: scene loads, source dimensions and original atlas paths match, both clips loop with the real selected key counts, canvas sizes and bottom alignment are stable, no actor upscaling occurs, Idle↔Run travel works, repeated requests preserve playback time, and invalid attack requests are ignored.

Native OpenGL/Metal captures were rendered and inspected at `player-animation-review.png` and `player-animation-review-run.png`. The Run capture was advanced separately after entering its state, and its atlas source is checked by the test. Both show the known source defects rather than hiding them. `res://tests/capture_c3_player_review.gd` reproduces those captures using the authored scene.

The Godot node/resource checker reported zero errors and one pre-existing orphan UI-006 import-settings warning. Headless Godot prints the macOS certificate-access diagnostic in this restricted environment; the test itself exits successfully.
