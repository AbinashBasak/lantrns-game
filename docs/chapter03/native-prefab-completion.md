# Native reusable prop and projectile prefabs

Three independently editable PackedScenes now exist:

- `scenes/props/chapter_03/c3_ruined_arch_mapped.tscn` — C3-PROP-008 source138, bottom-center origin, supplied-map CanvasTexture. No inferred collision or occluder fills the opening; no nonexistent lamp was added.
- `scenes/props/chapter_03/c3_wall_relief_mapped.tscn` — C3-TILE-012 source142 wall relief, bottom-center origin, supplied-map CanvasTexture. This decorative relief does not claim to complete the collision tile atlas.
- `scenes/vfx/chapter_03/c3_crystal_wisp_bolt.tscn` — C3-ENM-PRJ-001, separate visible Sprite2D and actual cyan PointLight2D anchored to its bright leading core. The optional explicitly authored 24px attack circle is independently editable and disabled, with monitoring/collision masks off. No movement, damage, targeting or lifetime behavior was invented.

The native depth review now instances the actual reusable arch and wall prefabs. `scenes/vfx/chapter_03/c3_native_prefabs_review.tscn` adds the actual bolt prefab and retains the editable native moving-light AnimationPlayer. The review has three actual point lights and zero shadow lights. Final gameplay integration must include projectile lights in its overall budget alongside the existing section light-budget component.

Native validation passes for PackedScene loading, named node paths, material channels, bottom-center placement, absence of inferred architecture collision/emission and projectile light following its source. The actual graphical five-state map comparison was rerun after prefab promotion, with unchanged UI. The combined prefab screenshot was inspected and the graphical log exits cleanly.

All paths, recursive dependency hashes, map comparison metrics and unresolved integration limits are recorded in `native-prefab-completion.json`. Bump normals remain explicit derivatives of supplied grayscale height, using Godot X+,Y+,Z+ conventions; the unaltered sources and registration limits remain documented in `lighting-vfx-preparation-depth.json`. No final production approval or master checklist change is implied.
