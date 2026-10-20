# Chapter 1 — The Forgotten Trail

Chapter 1 is implemented as a connected playable route from Brackenreach to the first Golden Fragment. The prologue's eastern exit opens `scenes/levels/chapter01_forgotten_trail.tscn` directly. F5 starts the full game from the prologue; open that Chapter 1 scene and press F6 to start its own title screen. `scenes/main/main.tscn` remains the earlier trail regression scene.

## Playthrough

1. Inspect the old trail marker, cross two introductory root gaps and encounter two Thornlings using the generated Rootling artwork. Lower ledges soften missed jumps.
2. Optionally climb the ruined watchpost ledges to collect the trail token. It never gates progress.
3. Inspect the ancient arch. Activate the labelled rune stones in order **I, II, III, II, III**, matching Mote's three-slow/two-quick gesture. Incorrect input resets the sequence without damage. A correct-next-rune pulse appears after a delay or mistake; a complete visual sequence appears after a longer delay or repeated mistakes. Sound and precise timing are not required.
4. Cross the revealed translucent root platforms, enter the temple and inspect the damaged relief.
5. Kindle the checkpoint before entering the Hollow Sentinel chamber. Proximity activates it; interaction also opens its story text.
6. Defeat the Sentinel, collect the Golden Fragment and view the skippable orchard memory. Follow the eastern passage to the chapter completion panel and its replay button.

The revealed root crossing stays stable once solved. This deliberately adapts the plan's temporary crossing so a player can read the clue, use touch controls and retry jumps without racing a timer. The solved puzzle survives checkpoint retries.

## Encounter and recovery

Tavi has five lives, displayed as hearts, and a 100-point health bar for the current life. Enemy hits reduce the bar; a depleted bar costs one life and refills for the next. Rootling hits deal25 health damage, Sentinel swipes40 and waves55. The Hollow Sentinel has 24 health and takes one damage per successful sword swing. Its wake is protected from damage; a slow, facing-locked wind-up precedes its forward attack. At half health it transitions to alternating root waves with a visibly marked safe pocket. Wave warnings lock their safe area before the strike, and a wave can damage Tavi only once. Low-health attacks slow down. The defeated Sentinel kneels and stops being a sword target.

The temple checkpoint restores all lives and the health bar. Death resets the uncompleted boss encounter and opens its entry for a quick retry; the solved bridge and optional token survive. Earlier section recovery points reduce backtracking after falls. Story and checkpoint progress last for the current session; they are not written to a permanent save. Restart chapter or Replay Chapter 1 resets the puzzle, token, fragment and boss and returns to the chapter title.

The chapter now also includes three connected jungle side areas: High Canopy, Flooded Rootways and Lantern Grove, with optional discoveries and return shortcuts. See [expansion design and references](chapter01-expansion-design.md). The chapter title offers replay of the prologue, whose exit flows directly back into Chapter1.

Move with A/D or arrows, jump with Space, attack with J/X and interact with E. Controller and on-screen buttons use the same input actions. Dialogue stops movement and attacks and can be advanced or skipped. Escape/Start opens pause, with restart and the inherited Sound & comfort settings. Music, effects, ambience and reduced-effect preferences persist locally. Pause freezes the encounter and presentation.

## Generated assets and presentation

Selected generated Forgotten Trail and root-temple environment exports supply the foreground, landmarks, props and two sets of four native parallax planes. Props are cropped to their visible silhouette and anchored to the collision floor; neighbouring atlas images are excluded from rune and temple exports. The forest-to-temple transition blends the background sets. Mote intentionally hovers.

The Sentinel uses selected generated wake, idle, movement, wind-up, slam, swipe, phase transition and kneeling defeat frames. Prepared variants are not automatically part of its active animation set. Generated Tavi, Mote, Rootling and prologue UI assets are reused. The fragment, optional token, boss health frame and orchard memory use generated exports. Region music, ambience, attack cues, puzzle/checkpoint sounds and effects are integrated with conservative levels.

Runtime exports live under `assets/runtime/chapter01/`; unchanged originals stay in `assets/production/`, excluded from Godot imports. Preparation scripts preserve source/output hashes and mechanical crop records in runtime manifests. See [integration record](chapter01-asset-integration.json) and [asset provenance](asset-licenses.md). Runtime integration does not approve an entire production pack or grant final art/audio release approval.

## Validation and review

The chapter suite contains 42 automated checks covering direct launch, physics traversal of both introductory gaps and the revealed crossing, optional discovery, actual interaction-button input, visual puzzle hints, gentle mistakes, checkpoint recovery, boss phases and damage fairness, pause, reward gating, memory, completion and full restart. The existing prologue/trail/parallax suites contribute 55 regression checks. All 144 source-project checks pass, including the expanded health, enemy and exploration suites. See [the current validation report](prologue-validation.txt) and [expansion details](chapter01-expansion-design.md). Exported-pack results are saved [separately](prologue-pack-validation.txt). Headless runs retain host log/keychain warnings and inherited prologue/parallax exit cleanup warnings; these are recorded in the logs. No script errors or missing runtime resources were reported. First-player duration remains unmeasured.

Rendered forest, watchpost, runes, crossing, temple, Sentinel, root wave, memory and completion views are available in this directory. Examples: [forest](chapter01-forest-preview.png), [rune crossing](chapter01-crossing-preview.png), [Sentinel](chapter01-sentinel-preview.png), [root wave](chapter01-rootwave-preview.png), [memory](chapter01-memory-preview.png), [completion](chapter01-complete-preview.png).

## Remaining release gates

- Install matching Godot export templates, create standalone Windows/Android builds and run them on their target platforms. A content PCK is not a standalone executable.
- Test on a physical Android device and Windows machine: simultaneous touch actions, gamepad navigation, safe areas, performance and memory.
- Obtain human listening and final art/animation approval, including balances on headphones and phone speakers.
- Run a first-player accessibility, boss balance, narrative and pacing playtest. The plan's 8–12 minute combined target remains unmeasured.
- Add engine/distribution notices, platform credentials and signing when shipping executable builds.
