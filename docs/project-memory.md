# Lanterns Underroot working memory

Updated 2026-10-21. This file stores user decisions and validated lighting/asset practices for future work.

## User art and interface decisions

- Use the supplied lush forest reference: crisp illustrated foliage, emerald/yellow-green leaves, deep teal tree shadows, turquoise waterfalls and warm golden lanterns. Preserve source colors; do not introduce arbitrary region color filters or make the whole game muddy/dark.
- New UI work is scoped to points, content/objective/feedback lists, the transient guidance card and supplied keyboard keycaps. Keep the existing player heart list and health bar artwork, size, placement and number styling. Those were explicitly restored at the user's request.
- Gameplay guidance belongs in the upper-left HUD stack, not the center of the screen. Show a changed instruction for five seconds with a short fade; a controller rewriting the same instruction each frame must not restart it.
- UI frames use nine-slice textures and real dynamic text; icons and inputs are separate assets. Do not bake gameplay text into screenshot-sized panels.
- The small asset-sheet background thumbnail must never be enlarged as fullscreen art. Use native high-resolution replacements, preserve aspect ratio, and keep cutout assets at or below useful native pixel density.
- Treehouses/arches need visible support: complete roots on actual terrain or structurally attached to an authored tree/branch. No floating houses, visibly cut-off rectangular bases, or decoration that implies an unreachable gameplay platform.
- Keep foliage dense and natural without covering Tavi's silhouette, hazards or landing surfaces. Repeat modular plants, not entire flattened game screens. Level gaps and jumps must be verified against actual player speed, jump impulse and gravity.

## Lighting knowledge

Personal skill installed at `/Users/abinashbasak/.codex/skills/godot-2d-lighting/SKILL.md`; read its focused reference notes for future lighting work.

- CanvasModulate sets multiplied ambient color; it is not ambient occlusion. For already vibrant painted art use modest neutral shading, not automatic navy tinting.
- Use actual PointLight2D nodes anchored to visible flame/source coordinates. Move the emitter node with its source; changing texture offset alone does not move shadow origins.
- Share `assets/runtime/shared/lighting/soft_radial.tres`. Additive falloff uses white center and black outer RGB; keep lighting separate from artwork and UI.
- Receiver mask (`range_item_cull_mask` / `CanvasItem.light_mask`) differs from shadow-caster mask (`shadow_item_cull_mask` / `occluder_light_mask`). Keep solid terrain/actor occluders simple and do not block traversable openings.
- DirectionalLight2D ignores per-item receive masks and casts infinite shadows; use deliberately rather than as a default. CanvasLayer isolation protects HUD colors.
- Use only the nearest limited number of shadowed lamps (current recommendation two), disable offscreen sources, and suppress flicker/shadows in reduced-effects mode.
- CanvasTexture can combine matching diffuse/normal textures; Godot expects X+, Y+, Z+ normals. Do not claim a diffuse recolor is a normal map or invent surface relief just to enable the feature.
- Validate real rendering with an identical frozen scene with PointLight2D nodes on/off, while leaving ambient and HUD fixed. Logic-only tests cannot establish visual light response.

Official research references:

- https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html
- https://docs.godotengine.org/en/stable/classes/class_light2d.html
- https://docs.godotengine.org/en/stable/classes/class_canvastexture.html
- https://docs.godotengine.org/en/stable/classes/class_directionallight2d.html

## Archive and verification

Follow the root AGENTS.md asset workflow. Preserve source images unchanged and older generations, use existing registered asset-ID folders, label crops/alpha cleanup/generated replacements separately, record source hashes and runtime dimensions, and coordinate checklist/registry writes through the primary agent. The master checklist and project copy must match. Existing checkboxes and final approval flags are separate from runtime integration.
