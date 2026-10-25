# Chapter 3 recovered enemy animation preparation

Prepared from the user ZIP and previously recovered originals under the designated production bible. This is an organization and native review pass; no new art, replacement mechanics, generation approval or chapter completion is claimed.

40 diagnostic clips contain 191 isolated full-resolution poses across six enemy review scenes. Every frame has a source hash/message mapping, source bounds, exact recovered count, FPS and shared per-enemy canvas/pivot in [the handoff](animation-asset-preparation-handoff.json). Ground actors use bottom-center; Wisp and Eel use center pivots. The native reviews use editable SpriteFrames, AnimationPlayer clips and active AnimationTree state machines.

## Prepared families

| ID | Native review families (actual frames) |
| --- | --- |
| C3-ENM-001 | `walk` 6, `death` 6, `hurt` 6 |
| C3-ENM-002 | `hover` 6, `charge` 3, `projectile_body_partial` 2 |
| C3-ENM-004 | `idle` 5, `walk` 6, `shield` 4, `windup` 4, `slam_partial` 4, `recover` 4, `hurt` 3, `death` 8 |
| C3-ENM-005 | `idle_swim` 6, `hide` 6, `telegraph` 4, `lunge_partial` 3, `retreat` 4 |
| C3-ENM-007 | `idle` 6, `intro` 6, `walk_partial` 4, `shield_raise` 5, `slam_windup` 5, `recover` 4, `hurt` 4, `stagger_partial` 3, `defeat_partial` 3 |
| C3-ENM-008 | `idle` 6, `intro` 5, `dash_windup` 5, `dash_partial` 6, `bubble_summon` 6, `water_column_telegraph_partial` 4, `seal_beam_telegraph` 6, `seal_beam_partial` 4, `core_exposed` 6, `phase_change` 6, `hurt` 6, `defeat_partial` 1 |
| C3-ENM-003 | No canonical exports: source design/mechanics conflict |
| C3-ENM-006 | No canonical exports: source design/mechanics conflict |

## Source and cleanup decisions

Original PNGs remain unchanged in their registered `source_images/` folders. Derived archival frames and previews are in each enemy ID's `exports/native_animation_review_v1/` and `previews/native_animation_review_v1/`; imported review copies are under `art/enemies/chapter_03/`. Filenames keep the official asset ID. Earlier generations remain preserved.

Extraction labels alpha >16 connected components, retains each chosen component with its native two-pixel antialias fringe and pads it to one common enemy canvas. RGB and retained alpha pixels are unchanged. This removes faint canvas noise from the pivot calculation; disconnected particles stay in the unchanged source, and are not claimed as separated VFX. No source is resized or repainted. Ground poses are centered and placed on a common bottom baseline; floating poses use a common center pivot.

Many generated frames touch. Their merged regions are excluded rather than falsely sliced into complete poses; affected clips use `_partial` names. Source-component maps identify every exclusion. A partial animation is a diagnostic fragment, not a usable complete combat action. Independent sheets also vary in body scale/shape, which remains explicit QA work. Attached energy arcs, rings, columns and dissolve highlights require body/effect separation before gameplay use. No baked halo is converted into a Godot light.

The Sentinel crab/serpent outputs were explicitly rejected and remain source attempts. Jellyfish images 016–023 do not deliver the bible's staff-bearing ground Shrine Warden; the previous Keeper glide/cast sheets do not deliver its ground/swim/melee families. Mite slam is not relabeled as hop. Opaque checkerboard and black-fill sheets remain unapproved originals. Image 045 explicitly requests a generic noncanonical enemy and is not treated as Sunken Guardian or a new official ID.

Boss source sheets deliver different counts and mixes from their prompts: intro has five visible poses; core exposure and hurt each have six. Actual delivered counts, not requested counts, are recorded. The Knight labeled sheet's upper row is stagger; only three isolated lower-row death poses are recoverable without cutting overlapping bodies.

## Native verification

Godot 4.7.2 imported all native PNGs and loaded all six scenes. [Validation](animation-asset-preparation-validation.json) checks the 40 exact SpriteFrames counts, AnimationPlayer first/final frame selection, and AnimationTree native travel, frame progression and action returns. Six actual graphical captures were rendered and inspected. The technical checks pass; gameplay silhouettes, cross-sheet identity/scale, source clipping, attached VFX, missing families and combat timings remain pending. Production approval stays false.

Open any `scenes/enemies/chapter_03/review/c3_enm_*_animation_review.tscn`. The tree starts a native default state. Disable AnimationTree when manually scrubbing AnimationPlayer; select any action clip in the editor. Review scenes have no inferred collision or attack damage. The partial clips must not be installed as completed combat attacks.

Reproduce exports with Python plus Pillow, NumPy and SciPy: `python tools/prepare_c3_animations.py`. Validate/render with: `Godot --path . --resolution 1280x720 --script scenes/enemies/chapter_03/review/c3_enemy_review_validation.gd`.

## Remaining source gaps

- **C3-ENM-001**: clean matching idle; turn; notice; hop_attack; knockback.
- **C3-ENM-002**: patrol; aim; clean complete projectile body sequence; clean hurt; clean death.
- **C3-ENM-004**: notice; clean complete slam; separate shockwave.
- **C3-ENM-005**: hurt; death; clean complete lunge; separate lunge trail.
- **C3-ENM-007**: clean complete walk; clean slam; phase_change; clean complete stagger; clean complete defeat; separate shockwave.
- **C3-ENM-008**: walk_or_float; trident_sweep_windup; trident_sweep; clean dash; water_column_attack; clean seal_beam; stagger; clean complete defeat; separate attack/projectile effects.
- **C3-ENM-003**: walk; swim; windup; swing; recover; death; existing glide/cast artwork conflicts with bible.
- **C3-ENM-006**: all canonical staff-bearing Warden families; continuation is a jellyfish substitution.

A genuinely isolated Crystal Wisp bolt is also recovered as **C3-ENM-PRJ-001**: 398×221 source pixels with center pivot, no resize. See `standalone_projectiles` in the handoff. It is a static review texture; native projectile/light/hitbox integration remains pending.

## Native graph usability correction

The earlier Start-only graphs could select actions by direct state start but had no travel path between actions. The six review graphs now contain **74 editable native transitions** connecting all 40 supplied action states. The first supplied looping action is the hub; enabled manual edges lead to every available action. Locomotion loops stay active until requested travel; one-shot and `_partial` clips return to the hub only at their existing clip end. No missing action or source frame is invented.

Updated graphical engine validation uses `AnimationNodeStateMachinePlayback.travel()`, never per-action `.start()`. It inspects actual enabled resource graph routes to prevent fallback teleport from hiding a missing edge, verifies 0→1 frame progression for multiframe clips, holds loop states, checks one-shot/partial returns, and tests six non-hub → hub → non-hub paths. All 40 states and six cross-action routes pass. Godot processes travel requests on mixer evaluation; tests allow that evaluation rather than inspecting an immediately pending request. The single-pose defeat fragment stays one pose.
