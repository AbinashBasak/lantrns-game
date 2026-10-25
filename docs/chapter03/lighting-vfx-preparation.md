# Chapter 3 lighting and water preparation

The user-designated root production bible controls IDs and layout. Sources come from the unchanged local ZIP archive. No browser recovery or new image generation was used.

The actual waterfall in image107 is now a caption-free genuine-alpha crop in `art/vfx/chapter_03/C3-TILE-020_waterfall_stream.png`. The native `scenes/vfx/chapter_03/c3_waterfall_stream.tscn` uses top-center origin, a restrained water shader, and the existing authored mist emitter. It has no collision and can serve C3-BG-003 in a distant parallax layer. This is one static painted waterfall with shader motion, not an invented recovered frame animation.

C3-BG-011 uses the grayscale middle panel of image153 as an intensity input. The colored panel's checkerboard is baked into RGB and was excluded. The exported file is explicitly named caustic intensity; it is neither a recovered RGBA base, a normal map nor verified depth data. The shader samples mirrored UVs to avoid value discontinuities because the original is not proven seamless. The low-alpha additive overlay must stay inside water bounds; actual water-region art review remains required.

The supplied shrine guide is followed: architecture, optional maps, artwork, particles and actual illumination stay separate. The combined shrine infographics contain clipped extremities, panel separators or captions. They remain source references; no claim is made that they are independently aligned, clean production textures. Existing native shrine idle/dormant/activation timelines, PointLight2D and particles are retained.

Native editable resources now include waterfall mist, bubbles, water splash, fragment pickup, lantern sparks, crystal motes, shrine light, lantern light, crystal light and checkpoint light. One-shot particle resources expose `trigger()`; all new water and particle components expose `set_reduced_effects(bool)`. No flame sheet, crystal-shatter sheet or missing boss attack art was fabricated.

`resources/chapter_03/lighting/light_budget.tscn` provides a section-level manager for the native lantern/crystal/checkpoint light group: up to 16 visible lights, two nearest shadowed lights, 180px viewport margin and 5Hz culling. Reduced effects freezes native flicker, disables shadows and suppresses particles/texture motion while retaining state cues. Shrine/actor lights must be included in the final section's total budget when integrated; the manager's 16-lamp cap is not a total-scene performance guarantee. No target-hardware frame-rate profile is claimed.

Open `scenes/vfx/chapter_03/c3_effects_review.tscn` for the combined resource review. Godot 4.7.2 imports and the meaningful native tests pass. The graphical Compatibility-renderer on/off captures hold ambient, artwork, animation time and CanvasLayer labels fixed. The JSON handoff contains the changed-pixel count, unchanged-title check, source/message mappings, crop dimensions, file hashes and native resource roles.

The captures are `lighting-vfx-preparation-on.png` and `lighting-vfx-preparation-off.png`. They verify real nearby painted artwork responds to the PointLight2D. This resource review does not approve an actual Chapter 3 section, collision, gameplay or final production art. Existing master checkboxes remain unchanged; the primary agent coordinates registry/checklist updates.

Reproduce texture crops with `python tools/prepare_c3_vfx.py` in an environment with Pillow. That script preserves QA results when the derived output hashes remain identical; changed outputs require a fresh review. Validate native commands with `Godot --headless --path . --script res://tools/validate_c3_vfx.gd`; run the graphical comparison with `Godot --path . --script res://tools/capture_c3_vfx.gd`.
