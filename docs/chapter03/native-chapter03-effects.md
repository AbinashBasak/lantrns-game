# Chapter 3 native lighting and effects

The native systems review is an isolated scene, not playable Chapter 3 or final asset approval:
`res://scenes/chapter_03/review/c3_native_systems_review.tscn`.
Run it with F6. Use **Preview opening** for the chest animation and native gold burst. The side columns continuously preview the three particle rigs. Their 2× showcase scale makes small sparks/motes easier to inspect without changing reusable emitter defaults.

## Editor-visible resources

- `scenes/chapter_03/lighting/c3_lantern_light.tscn`: PointLight2D using shared radial GradientTexture2D, warm amber, restrained 0.85–0.93 energy AnimationPlayer loop, shadow mask and receiver mask 1. Instance at an actual flame; offset animation start per placed lantern. The review places this light at the actual chest mouth as an illumination demonstration; no lantern artwork is invented.
- `scenes/chapter_03/vfx/c3_lantern_sparks.tscn`: seven warm CPUParticles2D, 1.2-second lifetime, small native radial texture.
- `scenes/chapter_03/vfx/c3_crystal_motes.tscn`: ten cyan CPUParticles2D, 2.8-second lifetime, local drifting emitter.
- `scenes/chapter_03/vfx/c3_waterfall_mist.tscn`: 22 soft low-alpha CPUParticles2D, 2-second lifetime, wider upward mist emitter.
- `scenes/chapter_03/review/c3_chest_animation_review.tscn`: authored OpeningGoldParticles (18 native particles, 0.8-second lifetime), emission keyed in the Opening AnimationPlayer clip (0.25–0.65 seconds), existing MouthLight energy keys, and a simple LightOccluder2D polygon inside the opaque chest base. AnimationTree discrete property mode permits particle emission events. Open/Closed stop emission; existing particles finish their lifetimes.

No scripts draw effects or construct these nodes at runtime. Particle textures are native GradientTexture2D resources, not generated artwork. The chest source still contains painted glow, disclosed in its review notice; that source limitation is not removed or relabeled as native lighting. Crystal/waterfall/lantern source props are not fabricated from the emitter previews. Reduced-effects behavior is documented on the reusable lamp rig; no new settings system is introduced here.

## Verification

Godot 4.7.2, Compatibility renderer on Apple M3 Pro. Headless native-effects test passed: Opening state emits native particles, the light track has positive energy, reset stops emission, base occluder and all reusable scenes load. Advance simulation in frame-sized steps when checking discrete events.

Real-render proof captured the same frozen chest viewport with only MouthLight.enabled toggled: **42,707 changed pixels, zero changed UI pixels**. Hiding only the native particles changed another **150 pixels**, establishing visible native particle rendering independently of the supplied painted glow. Ambient stayed white (`ffffffff`). Files: `native-chest-light-on.png`, `native-chest-light-off.png`, `native-effects-render-proof.json`. `native-systems-review.png` is the combined visual review. Shadows have editor-authored polygons and configured masks; this comparison proves illumination, not a chapter-wide shadow budget or gameplay integration.

Checks: `tests/chapter03_native_effects_test.gd`, `tests/capture_c3_native_effects.gd`, `tests/capture_c3_native_systems.gd`. Headless sandbox logs cannot write Godot user log/certificate access, but scene/test checks pass; graphical captures were run with approved native app access.
