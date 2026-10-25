# Chapter 3 available audio preparation

The existing phase09 library contains34 code-synthesized procedural prototypes, not supplied recordings or final sound design. All metadata entries were compared with production bible §14, and only four direct matches were selected. Original files remain unchanged, and runtime copies are byte-identical:

| Chapter cue | Existing source | Native reusable scene |
|---|---|---|
| C3-AUD-001 cavern ambience | AUD-AMB-004 cave drips, long reverb and low cavern air | `scenes/audio/chapter_03/c3_audio_cavern_ambience.tscn` |
| C3-AUD-005 fragment pickup | AUD-SFX-011 rising collectible bell | `scenes/audio/chapter_03/c3_audio_fragment_pickup.tscn` |
| C3-AUD-006 chest open | AUD-SFX-010 creak/latch/sparkle chord | `scenes/audio/chapter_03/c3_audio_chest_open.tscn` |
| C3-AUD-008 rune gate rumble | AUD-SFX-014 heavy stone slide/thunks | `scenes/audio/chapter_03/c3_audio_rune_gate_rumble.tscn` |

Files are categorized under `audio/chapter_03/ambience/` and `audio/chapter_03/interactions/`. The cavern cue is a30-second Ogg loop, with native import looping enabled. Interaction cues are original WAV one-shots of0.9,2.4 and1.8seconds. Their native players are editable AudioStreamPlayer2D nodes, and ambience is non-positional AudioStreamPlayer. Autoplay is disabled. Place positional cues at the actual interacting prop; invoke their existing native `play()` method at the authored event.

The native review at `scenes/audio/chapter_03/c3_audio_review.tscn` has four playback buttons and Stop All. It temporarily installs `resources/chapter_03/audio/review_bus_layout.tres`, using the project's existing Effects/Ambience/Music names. It restores the prior global layout on exit. Neither project.godot nor campaign audio controllers were modified. Serialized review gains leave headroom: Master−6dB, ambience−8dB and effects−6dB at each player. These are review defaults, not an approved scene mix.

Both headless and actual graphical native Godot tests pass: stream import/types, one-shot start/stop, the Ogg's actual30-second loop boundary, player/bus routing, bus-gain changes, Stop All and restoration of original bus names/gains/layout. Actual native playback testing exits cleanly. Run `Godot --path . --script res://tools/validate_c3_audio.gd` to repeat. Native technical playback does not establish that the sound was auditioned by ear or approved on headphones/speakers.

`audio-asset-preparation.json` records official IDs, unchanged source/runtime hashes, native resource/import paths, source measurement provenance, native QA and all16 remaining absent cues. Original metadata reports integrated loudness−28LUFS for ambience,−15.42 for the chest and−19.42 for the gate; pickup LUFS was not measured. These values were inherited from existing prototype measurements, not newly measured or treated as the final mix. Original source metadata says no assets were auditioned by ear.

Dedicated waterfall, lantern crackle, crystal/beam hums, lock reject, splash, underwater routing/muffling, drain/switch machinery and chapter-specific combat/boss/completion cues remain absent. Wetland ambience containing frogs/insects, unrelated music and generic attack roars were not relabeled as those missing cues. No new audio was synthesized. Checklist/registry changes remain coordinated through the primary agent; final listening/mix/gameplay approval is pending.

A final regression exposed intermittent audio playback/resource references at shutdown. The review now explicitly stops players and releases their streams before restoring the original bus layout. The validator releases its scene references and allows120ms for audio-thread cleanup. Five follow-up runs (verbose headless, graphical and three independent verbose repeats) have no warnings/errors/object/resource leaks. Failed checks now accumulate and exit1, with a10-second watchdog; a deliberately wrong expected gain in a temporary test copy verified exit1 without a hang. Audio files and native sound data were unchanged.
