# Chapters 1 and 2 polish — 24 October 2026

This pass improves the existing artwork and encounters without replacing the health HUD, changing combat damage/timing, or generating new production assets.

## Chapter 1

- Region music and ambience crossfade over 1.2 seconds using outgoing and incoming voices. Unchanged ambience continues playing across boss/reward transitions.
- Activated puzzle glyphs illuminate their surroundings. The temple checkpoint gains a softly faded, camera-culled warm light.
- Sentinel impacts and player damage use the same bounded camera feedback system as Chapter 2. Feedback clears during dialogue, pause, respawn, completion and reduced effects.
- Forest enemies visibly compress/lean during anticipation, extend on the strike, and settle during recovery. Filling warning arcs communicate time until release; seed trails clarify projectile direction.
- Projectile updates tolerate synchronous encounter resets and check swept movement against the player.

## Chapter 2

- Root bindings cast warm localized light, fading to soft teal when restored.
- Hanging lanterns gently sway with their actual flame/light origins moving together; sparse embers stay near the sources.
- Fragment illumination waits for the chest opening that reveals the fragment.
- Enemy warning arcs and facing markers clarify locked attack direction and release timing.
- Reduced effects suppresses decorative lantern motion, embers, seal pulses and fragment bob. Essential warning cues remain visible.

## Validation

Godot 4.7.2, compatibility renderer on Apple M3 Pro.

- Chapter 1 campaign suite: passed, zero failures.
- Chapter 2 expansion suite: 151 checks, zero failures.
- Chapter 2 combat regression: 52 checks passed.
- Enemy suite: 11 checks passed.
- Lighting suite: 21 checks passed.
- New shared chapter feedback lifecycle regression: eight checks passed, including bounded shake, settling, dialogue and reduced effects.
- Focused audio-transition and Chapter 2 atmosphere checks passed.
- Actual graphical frames reviewed: [Chapter 1](chapter01_forgotten_trail-polish.png), [Chapter 2](chapter02_briarwake-polish.png).
- Whitespace validation passed.

The existing Chapter 1 baseline test already emitted shutdown resource/RID leak warnings; these remain in test/capture shutdown output. Sandboxed headless runs also emit a macOS certificate warning. No gameplay assertion failures or script errors were observed. Screenshots verify palette and placement; a full human playthrough and performance profiling remain outside these automated checks.
