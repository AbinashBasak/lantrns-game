# Chapter 1: mandatory jungle route and Sentinel revival

The player health bar now uses the generated gold/teal UI-008 frame, textured red fill and numeric health, matching the life hearts and boss interface.

## Required exploration route

The three jungle areas are now required parts of the journey. Walking to the canopy entrance at650, flooded roots at4250 and lantern grove at5800 automatically moves Tavi into the corresponding area. Each is4,600pixels wide, with additional upper routes and seven enemy patrols. The main trail has five Rootling encounters. Together this adds26 regular enemy encounters across the chapter.

Every jungle exit is physically sealed until its puzzle is solved. High Canopy uses lanterns in order I,III,II. Flooded Rootways requires opening the inlet then the drain, visibly lowering the water. Lantern Grove requires Moon,Leaf,Sun. Each puzzle supplies nearby instructions, visible progress and safe resets. Once solved, walking through the far exit returns Tavi beyond that jungle's entrance on the main trail. All three routes must be completed before the Sentinel encounter starts. Elevated map/note/seed discoveries remain bonus exploration. Puzzle completion and route progress survive checkpoint recovery during the session; replay resets the journey.

## Sentinel fight

The guardian chooses attacks based on distance and encounter cadence: nearby swipes, a direction-locked charge to close distance, aimed root eruptions and a broad root wave with visible safe ground. Root shapes grow and retract with highlighted joints rather than appearing as static warning strokes. Attack positions and facing lock during telegraphs, allowing a dodge; recoveries remain opportunities to strike. Damage immunity covers wake, transition, collapse and rejuvenation.

The first24-health depletion triggers collapse, followed by a rejuvenation animation using existing generated collapse/wake/transition poses. The guardian then returns with24health and a berserk HUD label. Berserk mode increases movement and attack frequency, shortens recovery, adds a second eruption zone and raises damage. Base swipe/wave/charge/eruption damage is36/45/42/44; berserk damage is52/65/60/62. A single attack cannot repeatedly hit during its active window. Only the second depletion opens the arena and grants victory. A checkpoint retry resets both boss lives and the revival.

## Rewards

Enemy defeat awards100trail points; the main rune puzzle awards300; each jungle seal awards400. Floating point text and gold particles animate the reward. Stable encounter keys prevent repeatedly farming points by checkpoint resets. Points and collected rewards last for the current session.

Final Sentinel defeat awards1,000points and reveals a generated treasure chest. Opening the chest animates its closed/unlatched/open states and grants500points, a health-bar refill and the Rootward Charm, doubling sword damage from1to2. The chest is one-shot and must be opened before collecting the Golden Fragment. Existing sources remain unchanged; see [chest source/runtime hashes](chapter01-rewards-assets.json).

## Review

All203 source-project checks pass. Automated checks cover required auto-transitions, sealed/open puzzle gates, actual jumps across terrain gaps, enemy counts, one-time point awards, boss revival immunity/full health, berserk damage, final-only victory and the chest reward. Gameplay and exported-pack results are in [validation](prologue-validation.txt) and [pack validation](prologue-pack-validation.txt). Rendered views are reviewed separately. Human balance/pacing, listening approval and physical-device performance remain pending; this does not assert a shipping release.

The rebuilt content pack also passes the prologue, chapter, parallax, health, enemy, required-jungle, boss-revival and rewards suites from an empty project directory. All483 runtime source/output hash records verify. Host logging/keychain and exit cleanup warnings remain visible in the validation logs; no script errors or missing runtime resources were reported.

## Parallax and grounding correction

The main trail and jungle use restrained depth rates of0.05/0.12/0.24/0.45. Jungle layers now follow Camera2D's actual smoothed screen center, with continuous offsets and viewport-based tile coverage; the previous modulo reset and player-position tracking caused abrupt motion. Vertical depth motion is reduced during jumps. This follows the camera-relative depth model described in the [Godot parallax documentation](https://docs.godotengine.org/en/stable/tutorials/2d/2d_parallax.html).

Visible alpha bounds now anchor runtime props to their requested contact point without modifying the saved source images. Foliage footprints snap onto supported terrain rather than spanning gaps, and the temple relief rests on the floor. All251 source-project checks pass, including48 new checks for depth rates, wrap continuity, vertical drift, transparent padding and foliage support across all three jungles. [Motion preview](chapter01-jungle-parallax-preview.gif).

## Real-time lighting and reference popup

See [lighting and popup implementation](dynamic-lighting-and-popup.md). Runtime lights now supplement painted shading across the village, forest, temple and jungles; the completion popup uses the supplied gold/teal crystal-and-parchment reference.
