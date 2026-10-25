# Chapter 3 collectible asset preparation

All 24 exported item attempts (images 050–073) are preserved unchanged and grouped under their verified visible bible IDs. Four clean unlit base families provide **20 full-resolution frames**; all eight official item IDs are accounted for. Production approval remains false.

| Official ID | Result |
| --- | --- |
| C3-ITM-001 Golden Fragment | Golden-crystal originals are RGB with a painted checkerboard. Alpha/antialias background colors cannot be recovered without inferred pixels; no clean base export is claimed. |
| C3-ITM-002 Temple Key | 4 unlit idle frames; native SpriteFrames, AnimationPlayer and AnimationTree review |
| C3-ITM-003 Drainage Sigil | Only combined glowing sigil/burst artwork. No matching unlit base or isolated overlay; subtracting the glow would infer missing body pixels. |
| C3-ITM-004 Guardian Key | Only combined glowing Guardian Key/burst artwork. No clean base independent of halo or standalone effect. |
| C3-ITM-005 Sunken Seal | Only combined Sunken Seal glow/activation artwork. No unlit base or standalone overlay delivered. |
| C3-ITM-006 Health pickup | 4 unlit idle frames; native SpriteFrames, AnimationPlayer and AnimationTree review |
| C3-ITM-007 Lore tablet | 6 unlit idle frames; native SpriteFrames, AnimationPlayer and AnimationTree review |
| C3-ITM-008 Relic shard | 6 unlit idle frames; native SpriteFrames, AnimationPlayer and AnimationTree review |

## Identity and source rules

The source request is retained independently of visual identity. Images 057–063 and 065 deliver health hearts while requesting Lore Tablet; 064 delivers a golden crystal and 066–067 deliver Temple Keys under that same incorrect tablet request. These are grouped as C3-ITM-006, C3-ITM-001 and C3-ITM-002 respectively. The master bible controls official names; the generated title or source prompt does not create a new official ID.

Selected bases: Temple Key 066, first four lower-row poses; Health 057, first four intact lower-row poses; Lore Tablet 069, six middle-row bodies; Relic Shard 072, six middle-row bodies. The fifth Health pose starts a red-fragment burst and is excluded from idle. Its earlier diagnostic crop remains archived and is explicitly excluded in the handoff.

RGBA source sheets contain hidden background RGB gradients but near-zero background alpha. Per-cell bands remove printed headers, labels and depth rows; the largest alpha>32 body component and its existing two-pixel antialias fringe are retained. The actual source pixels are not resized, recolored, repainted or interpolated. Disconnected stones/leaves and faint canvas noise are excluded from the base. Each family has one common canvas and center pivot. Native linear-filtered imports use lossless PNG.

Golden Fragment 050/064 has an RGB painted checkerboard, including antialias mixtures. It remains source-only; no guessed alpha or gray color key is claimed as a clean deliverable. Drainage Sigil 052, Guardian Key 053 and Sunken Seal 054 include combined emitted glow/activation art without a matching unlit base. They remain archived review attempts, with no invented glow subtraction or clean base. Alternate lit/body/depth/pickup rows are also archived. A grayscale depth illustration is never presented as a valid normal map.

## Native light and animation review

Each prepared family has an editable SpriteFrames resource, AnimationPlayer frame timeline and an active AnimationTree. The review scene has a separate authored PointLight2D named `Actor/EmissionLight`, disabled by default. Its texture uses the existing shared radial falloff; enabling it changes real rendering without replacing the unlit base. No generated halo, pickup burst or source animation is substituted for a missing separated effect.

Godot 4.7.2 imported and rendered the four scenes without warnings/errors. Native tests verified the exact 4/4/6/6 frame counts, first/final AnimationPlayer frames and AnimationTree state selection. Eight identical scene captures (light off/on) were inspected; independent pixel comparison found 19,678 / 15,226 / 20,644 / 20,169 changed pixels respectively. The body, camera and labels remain identical between each pair. These are diagnostic light proofs, not gameplay-scale or art approval.

- [Complete source/export/recipe/pivot/timing handoff](collectible-asset-preparation-handoff.json)
- [Native validation](collectible-asset-preparation-validation.json)
- [Light pixel proof](collectible-asset-preparation-light-proof.json)

Archive originals are under each official `assets/production/chapter_03_sunken_temple/collectibles/C3-ITM-*/source_images/` folder. Derived archival frames/previews are in `exports/native_base_review_v1/` and `previews/native_base_review_v1/`. Imported review copies are in `art/environment/chapter_03/collectibles/`; native resources are in `resources/chapter_03/animations/collectibles/`. Open `scenes/props/chapter_03/review/c3_collectible_itm_*_review.tscn` to inspect the actual editable scene.

Reproduce with Python plus Pillow, NumPy and SciPy: `python tools/prepare_c3_collectibles.py`. Validate/render with `Godot --path . --resolution 1280x720 --script scenes/props/chapter_03/review/c3_collectible_review_validation.gd`.

Final blockers remain: missing separate pickup/activation VFX, cross-pose body/rune/volume continuity, source cleanup where identified, actual gameplay-scale light/collision tuning and final art review. No gameplay pickup Area2D or collision is inferred from the image bounds. Checklists and the shared registry are coordinated by the primary agent.

## Native graph follow-up

The four collectible families each have one delivered idle action. Their authored Start→idle graphs require no invented pickup/reveal state. Updated graphical validation calls native `travel("idle_unlit")`, verifies frame 0→1 progression and playback beyond one complete loop, and confirms the graph has only the supplied state route. All four pass. Separate light-off/on renders were regenerated and their pixel proof rechecked.
