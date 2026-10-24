# Current combat behavior

[Combat and recovery fixes](chapter02-combat-fixes.md) supersede the original five-pattern/rear-only damage and post-zero rescue rules below. Mossjaw now has seven moves, body-wide damage, definitive zero-health victory and safer projectiles. Area handoffs/checkpoint activation preserve current health.

# Chapter 2 — Briarwake expansion

The Chapter 1 completion panel connects to Chapter 2 through **Continue to Briarwake**. It transfers trail points and the sword's Rootward Charm into the orchard. Chapter 2's updated title uses the latest title artwork with correctly labeled chapter actions. Replay Chapter 1 returns to the earlier chapter; restarting Chapter 2 resets its own session rewards while retaining its imported campaign starting state.

## Journey and missions

The main orchard is 7,600 world pixels wide. Four required, separately saved 4,800px expedition scenes add 19,200px, making 26,800px of authored main-route and expedition space before optional upper paths. This is a scope measurement, not a playtime claim. First-player duration remains unmeasured.

1. **Orchard Waterways** — enter from the western orchard, restore the Inlet → Sluice → Drain sequence, cross irrigation gaps, and recover an optional keeper's map above the path.
2. **Firefly Canopy** — follow elevated roots and light lanterns I → III → II, with a hidden memory on the upper route.
3. **Ancient Seed Vault** — descend into the newly generated underground root cavern, recover the seed record, and open Leaf → Moon → Sun.
4. **Sunken Root Grotto** — explore the newly generated flooded cavern, recover the drowned keeper's journal, and follow Amber → Root → Pool.
5. The first three restored routes unlock their corresponding grove binding. Cut all three and finish the grotto to hear the voice in the bark and enter Mossjaw's sanctuary.
6. Free Mossjaw, open its reward chest, recover the first true Anchor fragment, and follow Sable's warning toward Glasswater Fen. Chapter 3 remains future work.

Each expedition has seven enemy encounters, a physically sealed puzzle exit, two linked elevated routes, safe sequence resets, an optional discovery and a room-entry recovery point. The main orchard adds six variant patrols and retains its four grove enemies: 38 regular encounter placements in total. Enemies have local movement bounds and do not blindly patrol into ravines. Solved seals, freed bindings, discoveries and points survive checkpoint recovery. Restart resets Chapter 2's own progress.

## Generated enemy variants

Three actual illustrated species replace generic stand-ins:

- **Thornrunner:** a bark-and-moss runner with a visible wind-up and short lunging melee attack.
- **Sporespitter:** a mushroom creature that throws an arcing amber seed projectile after preparing its spore sack.
- **Lantern Moth:** a hovering leaf-winged enemy that locks a diving target and recovers low enough for Tavi's sword.

Each new species has four generated poses. Locomotion/attacks use short pose sequences; hurt and defeat currently hold a dedicated recovery pose. These are initial animation sets, not claims of finished full production animation. The unchanged generated sheets are archived alongside the derived runtime frames.

## Mossjaw encounter

The real textured boss health bar displays current strength out of 32. Mossjaw now cycles five distinct, telegraphed patterns: direction-locked charge, aimed root eruption, traveling root sweep, arcing seed volley, and a close claw combo. Targets lock during warnings; dialogue and pause freeze attacks and projectiles. Recovery permits attacks from behind. Three health phases increase the encounter's activity without removing the readable recovery windows.

Nine newly generated poses add separate three-frame claw, eruption and volley clips. Actual generated root-spike and seed-pod cutouts render the hazards. The earlier idle/charge/recovery/release poses and original sources are preserved. The original short slam and final release remain candidates for further animation polish.

At strength 9 or below, break the nearby column three times during recovery, then cut the three exposed bindings during safe recovery windows. Depleting strength alone cannot kill the guardian or skip the rescue. Losing to Mossjaw restores its encounter, column and binding state for a checkpoint retry.

## Chapter 1 presentation and rewards

The top-left objective, mission list, feedback, five-second guidance, points panel and keyboard keycaps use Chapter 1's actual nine-slice textures and typography. Duplicate event guidance is suppressed. The existing five-heart frame and vitality bar are preserved. The Anchor memory also reuses Chapter 1’s illustrated botanical popup with live text and Continue input. The initial and completion screens reuse the latest title and crystal/parchment completion art with live Chapter 2 labels.

Enemy defeats award 100 points, expedition puzzles 500, grove bindings 250, and final guardian rescue 1,200. Discoveries provide bonus points. Stable encounter/reward keys prevent checkpoint farming. Mossjaw's chest uses the existing closed/unlatched/open/looted animation, grants 500 points and the Orchard Charm, restores lives/vitality, and increases sword damage by one up to three. The chest is required before the Anchor fragment. Campaign starting points and sword strength transfer from Chapter 1; progress remains session-only.

World lighting follows the project's Godot lighting skill: genuine lamp-source anchors, player/Mote lights, source-gated reward lights, neutral ambient multiplication, actor/terrain occluders, nearest-two shadowed lamps, reduced-effects support and offscreen culling. The HUD stays in its CanvasLayer. No invisible portal emitter or arbitrary blue region filter is added.

## Sources, review and validation

All seven new imagegen outputs are saved unchanged in `assets/production/phase_10_later_campaign_specific_assets/LATE-001/source_images/`. Production exports, checkerboard previews, component crops, alpha cleanup, foot alignment, animation timing, source/runtime hashes and complete prompts are recorded in `LATE-001_expansion_metadata.json` and `LATE-001_expansion_prompts.json`. The broader LATE-001 checkbox remains unchanged and final human art approval is separate from integration.

- `tests/chapter02_expansion_test.gd`: 137 checks for the connected campaign, actual generated textures, mandatory routes, puzzles, real jumps/carrying, recovery, anti-farming rewards, health bar, five boss patterns and rescue/chest/fragment completion.
- `tests/chapter02_test.gd`: original 40-check orchard/combat regression suite, isolated from the added mandatory expeditions.
- Chapter 1 and completion-popup regression suites also pass.
- `tests/chapter02_expansion_capture.gd`: 16 staged runtime screenshots plus identical frozen lighting on/off/difference images. Staged captures show rendering; gameplay behavior is tested separately.

Capture index and lighting evidence are under `docs/chapter02-expansion/`. Headless test logs retain host log/keychain warnings and inherited Godot cleanup warnings at shutdown; no script errors or missing generated resources are accepted. Human balance, first-player pacing, final animation approval, Windows/Android exports and physical-device controls/performance remain unverified.
