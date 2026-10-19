# Prologue implementation and release checklist

The normal project launch opens `scenes/levels/prologue_brackenreach.tscn`.

The playable opening now uses the generated Brackenreach village layers, lanterns, Hearthlight states, cart, beam, bridge and terrain; generated Tavi, Mote and Rootling sprites; generated menus, dialogue, health and touch controls; and generated music, ambience, combat sounds and effects. Rusk and the cart-tender were added as supporting ENV-01 sprites with preserved source atlases. The Thornling gameplay name currently uses the library's Rootling artwork.

Runtime exports live in `assets/runtime/prologue/`. Original generations remain in `assets/production/`, excluded from Godot imports and release packs. See [source/runtime manifest](prologue-asset-integration.json) for copied files, exact hashes, source records and prepared-only variants. Selected runtime integration does not approve every asset in an environment pack.

## Playthrough

1. Move and jump over the village obstacle. Optionally speak to the villager, inspect the trail sign and check the mapbook.
2. Inspect the Hearthlight, then continue right to move the handcart at the outer bridge.
3. Return to the square. The Hearthlight failure briefly takes control; interact skips it. It causes no player damage.
4. Move the fallen beam at the hollow tree. Mote is rescued and joins Tavi.
5. Retrieve the practice blade and defeat two Thornlings, introduced one at a time with visible attack warnings.
6. Speak to Rusk for the worn trail-warden sword and mapbook, then enter the Forgotten Trail at the eastern exit.

The practice blade resolves the development plan's first fight preceding Rusk's sword handoff. Mote communicates through motion and a visible three-slow/two-quick tap pattern, with no human dialogue.

## Controls and recovery

Move with A/D, arrows or left stick; jump with Space/controller A; attack with J/X/controller X; interact and advance dialogue with E/controller Y, Enter or the Continue button. Touch controls use the same input actions. Enter, Space or controller Start/A begins from the title. Escape/Start pauses; R restarts the current level.

Pause → Sound & comfort provides separate music/effects/ambience levels and reduced flashes, camera shake and particle effects. Preferences persist locally; story progress remains session-based. Dialogue disables movement and attacks. Pause freezes gameplay, dialogue progression, cinematic time, audio and animated effects. Combat defeat resets both tutorial enemies and restores five hearts at the nearby checkpoint. Restart resets the opening's story events.

## Completed implementation checks

- [x] Village errand, single-use Hearthlight event, rescue, sequential fight and Rusk send-off.
- [x] Generated village, terrain, bridge, props and supporting character sprites integrated.
- [x] Terrain padding removed; continuous grass surface aligned to collision y620; plain soil beneath.
- [x] Mirrored far-background export removes negative-width rendering gaps.
- [x] Generated Mote idle/follow/alert/rescue and Rootling combat animation timings and pivots.
- [x] Generated title, buttons, dialogue, health, pause and touch visuals with live text.
- [x] Generated music/ambience/SFX, independent volume buses and persisted preferences.
- [x] Generated jump/landing/swing/debris/respawn and enemy impact/defeat effects.
- [x] Reduced-effect preference covers player and enemy particles, flashes and camera shake.
- [x] 31 prologue checks, 13 existing trail regression checks and 11 parallax/grounding checks pass in Godot4.7.2.
- [x] 200 runtime source/output hash records validated across 52 integrated asset IDs and prepared variants.
- [x] Rendered title, village, darkened village, dialogue, combat, pause, settings and touch layout inspected on macOS.
- [x] Windows/Android export configurations exclude production sources, docs, tests and tools; include JSON dialogue/animation manifests.
- [x] A game-content PCK exports without the production library and runs the prologue progression checks from an empty project directory.

## Remaining release gates

- [ ] Install matching Godot export templates; create and run standalone Windows and Android builds. Templates are absent on this machine; the validated PCK is a content pack, not a standalone executable.
- [ ] Test the complete opening on a physical Android device and Windows machine, including simultaneous touch input/gamepad navigation, safe areas, performance and memory.
- [ ] Human listening approval and music/SFX balancing on headphones and phone speakers. Existing procedural audio is integrated with conservative levels; no final composition approval is inferred.
- [ ] First-player pacing, narrative comprehension and accessibility playtest. Target remains3–4 minutes; no measured first-player duration is claimed.
- [ ] Final art direction and animation cleanup approval. Supporting NPCs currently use static idle sprites, not full talking animations.
- [ ] Add required engine/distribution notices and signing credentials when shipping executable builds.

The eastern exit now opens the implemented [Chapter 1 — The Forgotten Trail](chapter01-implementation.md), including the rune crossing, root-temple, Hollow Sentinel and Golden Fragment. The earlier `scenes/main/main.tscn` trail prototype remains available for regression tests.

## Reproducible checks

Run `python3 tools/validate_prologue.py` for bounded script/regression tests plus runtime source/hash validation. Test output is saved to [prologue-validation.txt](prologue-validation.txt). Preparation scripts in `tools/prepare_prologue_*.py` reproduce runtime copies and mechanical atlas exports without replacing original sources.

`export_presets.cfg` defines Windows and Android targets. `--export-pack "Windows Prologue" builds/validation/prologue.pck` builds the content pack independently of executable export templates. Native exports still require the matching templates and platform tooling.

## Village layout and parallax revision — 2026-10-18

The background now uses four native `Parallax2D` planes: sky0.12×, forest horizon0.28×, distant village0.42×, and near canopy1.12×. Each layer repeats at its displayed width. Soft alpha fades avoid cut edges in the horizon and canopy; local houses, roots, poles and interactables remain at world speed1×. A moving-camera test verifies actual screen displacement over200 camera pixels, not only configured rates.

The foreground is organized into a cottage lane, communal Hearthlight square, supply bridge, damaged-root rescue area, and Rusk's warden cottages with a forest threshold. Generated roofing, doors, shutters, timber, crates, flowers and roots communicate each place's role. Festival pennants and lamps are supported by poles in the square rather than distributed randomly. Closed house doors/shutters are decorative; only prompted story objects are interactive.

Grounded props use cropped visible alpha bounds and preserve their proportions. The grass graphic begins at616 so its opaque turf meets collision height620. Tavi/Rootling foot pivots already matched collision, so no animation-origin shifts were required. Mote intentionally hovers. The tutorial obstacle's visible face also matches its collision top575. Legacy trail pickups/checkpoint drawings are suppressed in the prologue. Dialogue separates Tavi and NPCs when their silhouettes overlap.

Research references: [Godot's native parallax tutorial](https://docs.godotengine.org/en/stable/tutorials/2d/2d_parallax.html) explains independent scroll scales and correctly sized repeats. [Jonathon Wilson's level-design guidance](https://www.gamedeveloper.com/design/level-design-tricks-of-the-trade) informed landmark, lighting and signpost choices. These are design/implementation references; no web artwork was imported.

See [moving-camera preview](prologue-parallax-preview.gif), [cottage lane](prologue-lane-preview.png), [square](prologue-village-preview.png) and [warden area](prologue-warden-preview.png).
