# Chapter 3 native Godot asset workspace

The root `lanterns_underroot_chapter_3_production_bible.md` governs this workspace. The archive is preserved separately from importable art. [Organized asset index](organized-asset-index.md) lists each registered item and its current stage.

## Editor entry points

| Work | Open scene/resource | Inspect |
|---|---|---|
| Supplied depth + bitmap lighting | `res://scenes/vfx/chapter_03/c3_depth_lighting_review.tscn` | `Arch`, `Wall`, their CanvasTexture resources, `LightSweep`, native `AnimationPlayer` |
| Waterfall, caustics and particles | `res://scenes/vfx/chapter_03/c3_effects_review.tscn` | Native PointLight2D and particle instances; separate water shader resources |
| Sentinel animation | `res://scenes/enemies/chapter_03/review/c3_enm_004_animation_review.tscn` | `Actor/AnimationPlayer`, `Actor/AnimationTree`, `Actor/Sprite` |
| Eel animation | `res://scenes/enemies/chapter_03/review/c3_enm_005_animation_review.tscn` | Same native clip/state/frames structure |
| Guardian Knight animation | `res://scenes/enemies/chapter_03/review/c3_enm_007_animation_review.tscn` | Available families, partial families explicitly named |
| Sunken Guardian animation | `res://scenes/enemies/chapter_03/review/c3_enm_008_animation_review.tscn` | Available families and source limitations |
| Temple Key | `res://scenes/props/chapter_03/review/c3_collectible_itm_002_review.tscn` | Unlit base animation and separate optional PointLight2D |
| Health, Lore Tablet, Relic Shard | Same folder, `c3_collectible_itm_006_review.tscn`, `007`, `008` | Unlit native animation families and independent lights |
| Existing blue-haired player source review | `res://scenes/chapter_03/review/c3_player_animation_review.tscn` | Existing Idle/Run source-region limitations |
| Existing common chest source review | `res://scenes/chapter_03/review/c3_chest_animation_review.tscn` | Closed/Opening/Open state graph and independent mouth light |
| Terrain joins and collision | `res://scenes/chapter_03/review/c3_terrain_seam_review.tscn` | External TileSet, 60-cell TileMapLayer and separately authored flat collision |
| Reusable mapped props and Wisp bolt | `res://scenes/vfx/chapter_03/c3_native_prefabs_review.tscn` | Real prefab instances; separate artwork, material, light and inactive attack area |
| Available audio cues | `res://scenes/audio/chapter_03/c3_audio_review.tscn` | Native players, loop settings and review-only bus layout |

Environment gallery scene names and their rendered counterparts are listed in [environment preparation](environment-asset-preparation.md). They use the actual prepared category art; they do not establish a playable section layout.

Select `AnimationPlayer` in the scene tree to inspect and scrub its keyframed clips in the Animation panel. Select `AnimationTree` to inspect the active state graph. `SpriteFrames` stores the isolated original-resolution poses; AnimationPlayer owns their frame selection. No custom code redraws or synthesizes the animation frames. Some partial states contain only the safely isolated subset and are explicitly labeled; they cannot stand in for missing full attacks or defeats.

The six enemy graphs now include 74 enabled native transitions for all 40 prepared states. Native `travel()` routes, frame advancement, looping, one-shot returns and cross-action paths were tested; validation no longer relies on directly starting an otherwise unreachable state. Returns in these diagnostic graphs are for review playback, not a new enemy combat implementation.

For the depth scene, Run Current Scene previews the authored native light sweep. The source height and bitmap guide panels are preserved in `art/source/chapter_03/environment/guide_panels/`. Registered derivatives and bump normals are in `art/vfx/chapter_03/derived_normals/`, and editable CanvasTextures are in `resources/chapter_03/lighting/`. CanvasTexture diffuse, normal and bitmap-driven specular channels are separate. Generated grayscale guides are not mislabeled as authored tangent-space normal maps. See [registration and native light proof](lighting-vfx-preparation-depth.md) for the actual limitations and comparisons.

## Folder ownership

- `assets/production/`: unchanged source archive, asset-ID provenance, export copies and previews; excluded from Godot imports.
- `art/source/chapter_03/`: guide panels and working source material; excluded from imports.
- `art/enemies/chapter_03/`: prepared enemy frames and isolated projectile art.
- `art/environment/chapter_03/`: backgrounds, tiles, platforms, props, doors, chests and collectibles.
- `art/vfx/chapter_03/`: effects textures and explicitly derived material maps.
- `resources/chapter_03/animations/`: native SpriteFrames; AnimationPlayer libraries/state graphs are serialized in their editable scenes.
- `resources/chapter_03/lighting/` and `vfx/`: CanvasTextures, light budget and water shaders.
- `scenes/enemies/chapter_03/review/`, `scenes/props/chapter_03/review/`, `scenes/vfx/chapter_03/`: native authored reviews and reusable light/VFX scenes.

## Verified scope

Godot import, native state/frame checks and graphical rendering passed. The supplied-map demonstration was compared with normals disabled, bitmap response disabled, lights disabled, and light position changed; HUD pixels stayed fixed. The folder migration and previous player/chest/mechanism checks were retained.

The native computer-control pipe failed, so direct clicking, inspector editing and timeline operation in the desktop editor could not be performed in this session. The native scenes and resources are prepared and rendered, but editor UI inspection is explicitly pending.

Final bible section17 approval remains pending for incomplete source families, proper section layouts, combat timing and target-device performance. The recovered mossy terrain uses native-resolution top/middle/underside crops with a constrained alternating mirrored sequence; 14 native collision rays pass. Visible mirrored repetition, corner pieces and arbitrary transitions still need art/terrain review. A perspective platform or flattened concept is not substituted for these modules.

Four matching existing procedural audio prototypes have unchanged-byte copies and native players. They still require listening and mix approval; sixteen chapter-specific cues are absent from the available library. The audio review restores the prior global bus layout and does not replace the campaign audio system.
