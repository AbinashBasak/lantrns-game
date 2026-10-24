# Current Chapter 2 behavior

[The expanded adventure](chapter02-expansion.md) supersedes the initial first-pass route and animation descriptions below. Four mandatory jungle missions, generated underground scenes/enemy variants, five boss patterns, updated Chapter 1 UI, points, chest rewards and campaign transfer are now integrated.

# Chapter 2 — The Guardian of Briarwake

Chapter 1's completion popup now offers **Continue to Briarwake**, alongside its existing replay action. Continue opens the orchard and its skippable introduction directly. To start independently, open `scenes/levels/chapter02_briarwake.tscn` in Godot and press F6.

## Playable route

- Cross the orchard's two moving-root gaps. Root platforms carry Tavi through normal physics and freeze during pause.
- Climb to the first grove binding, cross to the second, then release the small enemy grove around the third. E cuts a nearby binding, releasing its enemies. Remote interactions cannot bypass traversal.
- Explore the optional high family carving. At the heartroot checkpoint, all lives and vitality restore. Freed groves and story progress survive death.
- Listen to the voice in the bark after freeing all three groves. The orchard gate opens and the guardian arena becomes accessible.
- Dodge Mossjaw's direction-locked charge and jump its root sweep. Strike from behind during recovery. At half strength, press E beside the cracked column during recovery three times to expose the back bindings. Approach Mossjaw during recovery and press E for each of the three final cuts. Depleting strength alone never frees the guardian.
- Recover the first true Anchor fragment and its short orchard memory, then follow the eastern route for Sable's warning and the Chapter 2 completion screen. Chapter 3 remains future work.

Death resets the unfinished guardian encounter, including column and binding cuts, while preserving the groves and voice memory. Restart resets the full chapter and returns to its title. All progress is session-only.

## Art and interface

The orchard reuses genuine ENV-04 distant/midground artwork already integrated for the Chapter 1 memory, plus existing illustrated terrain, vine platforms, foliage, root seals, column/rubble, lanterns, fragment, Tavi, Mote, Thornlings, UI and audio. No polygon character or dummy scenery remains. Original orchard colors are preserved; edge alpha blending softens the repeated midground planes without recoloring. The original five-heart/vitality HUD remains intact. Changed guidance occupies the upper-left stack for five seconds; repeated text does not reset it.

The user authorized creating missing Mossjaw art on 2026-10-24. Built-in image_gen produced a new hand-painted bark-and-moss guardian. Both unchanged generations are archived under **LATE-001/source_images**. Generation 1 was rejected for crowded frame boundaries. Generation 2 supplies six isolated illustrated poses. Frames are mechanically cropped and aligned to a shared foot baseline, without recoloring or reconstructing the character. The manifest documents two distinct charge strides, held idle/recovery poses and a provisional slam sequence that reuses existing poses. A bespoke smooth slam and fuller idle/hurt/release animations remain unfinished; this is not represented as a finished production animation pack or final user art approval.

- Production records: `assets/production/phase_10_later_campaign_specific_assets/LATE-001/metadata.json`
- Full generation prompts: `assets/production/phase_10_later_campaign_specific_assets/LATE-001/LATE-001_generation_prompts.json`
- Runtime frames and timing: `assets/runtime/chapter02/mossjaw/manifest.json`
- Preparation and source hashes: `tools/prepare_chapter02_mossjaw.py`

The broad LATE-001 checklist item stays unchecked. Existing ENV-04 and earlier checkboxes are preserved.

## Verification and limits

`tests/chapter02_test.gd` checks title, movement and ledges, physical moving-root carrying and both crossings, actual interaction input, anti-skip proximity, guidance timing, grove release, checkpoint preservation, guardian damage gates, column and final cuts, defeat recovery, fragment gating, completion, restart, and Chapter 1 continuation. `tests/chapter02_capture.gd` saves seven real rendered previews here.

Chapter 1, prologue and completion-popup regression suites also pass. Test processes still report inherited Godot resource cleanup warnings at exit; no script parse/runtime errors are accepted. Windows/Android exports, physical touch/gamepad devices, first-player duration, encounter balance, final animation polish and human art/audio approval remain unverified.
