# Native shrine light — 2026-10-25

Reusable effect: `scenes/chapter_03/vfx/c3_shrine_light.tscn`.
Run `scenes/chapter_03/review/c3_shrine_light_review.tscn` with F6 for idle, activation, dormant, light on/off and reduced-effects controls.

This implements the native effect described by bible §6 and the local `C3-BG-008-LGT-001_Godot_Setup_Guide.txt`. Its editable nodes are gradient-texture core and glow sprites, two Line2D rings, twelve Line2D rays, a real PointLight2D, continuous CPUParticles2D sparks, a separate one-shot activation burst and AnimationPlayer timelines. Compatibility rendering uses CPU particles. No runtime node construction, scripted drawing, raster regeneration, fake heatmap or depth/normal map is used.

`idle` gently pulses light energy and core scale, `activation` briefly brightens/expands the effect and emits a burst before returning to idle, and `dormant` extinguishes the light and particles while preserving a faint readable outline. Reduced effects freezes idle and stops both particle emitters. The small script only selects authored clips and applies the explicit reduced-effects command; the containing gameplay system should call `set_reduced_effects()` when settings change.

Place the effect origin at the shrine source/emblem. Keep its architecture and collision separate. The effect is a native gradient/vector treatment, not the still-missing illustrated shrine emblem or architectural art. The review places existing chest source art beside it strictly as a real light receiver. This is not a replacement shrine or playable section. No production approval/checklist state is inferred.

Validation passed in Godot 4.7.2: resource load, dormant light/particles, idle, activation burst track, repeat guard, peak energy, idle return and reduced effects. Actual Compatibility rendering on Apple M3 Pro produced [light on](native-shrine-light-on.png) and [light off](native-shrine-light-off.png). With the same frozen animation time, ambient and hidden particles, all 22,785 changed pixels are in the painted chest receiver; top and bottom UI regions are pixel-identical. The visible core/rings/rays are unchanged, isolating real light response from decorative glow. [Proof data](native-shrine-light-proof.json). The capture exited without reported resource leaks.

Checks: `tests/chapter03_shrine_light_test.gd`; reproducible render: `tests/capture_c3_shrine_light.gd`.
