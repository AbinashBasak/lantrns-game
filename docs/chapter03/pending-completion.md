# Pending-work completion pass — 2026-10-25

This pass follows the root Chapter 3 production bible and preserves original source files and existing checkboxes. [Organized asset index](organized-asset-index.md) now covers 52 asset records and 294 archived prepared-output copies.

| Finding | Work completed | Evidence |
|---|---|---|
| Enemy graphs only had Start-to-idle edges | Added 74 editable native transitions across 40 prepared states. Tested real `travel()` routes, frame advancement, looping, one-shot returns and six cross-action routes. Partial families remain partial. | [Animation validation](animation-asset-preparation-validation.json) |
| Four collectible loops needed the same native travel check | Tested `travel()`, frame advancement and loop continuity for all four delivered unlit families. | [Collectible validation](collectible-asset-preparation-validation.json) |
| Mapped artwork existed only in a material demonstration | Added reusable bottom-anchored arch and wall prefabs with CanvasTextures. The actual prefab instances now appear in the light-response review. | [Prefab record](native-prefab-completion.json) |
| Wisp bolt was an isolated PNG | Added a native editable scene with separate artwork, source-anchored PointLight2D and an explicitly authored inactive attack area. No unrequested damage or movement is inferred. | [Prefab review](native-prefab-completion.md) |
| Chapter terrain prerequisites were unavailable in the ZIP | Recovered existing high-resolution orthographic mossy-rock source pixels from reusable TILE-004. Prepared eight top/middle/underside variants, external TileSet and a 60-cell TileMapLayer with separately authored collision. All 14 collision rays passed. | [Terrain records](terrain-handoff.json), [actual native render](terrain-native-review.png) |
| Available audio cues were not organized for Chapter 3 | Copied four fitting existing procedural prototypes unchanged: cavern ambience, fragment pickup, chest open and stone gate. Added native reusable players and an independent audio review. | [Audio records](audio-asset-preparation.json) |
| Audio validator printed PASS but leaked playback resources at shutdown | Fixed player/stream teardown before restoring the original bus layout. Added counted failures, nonzero failure exits and watchdog. Repeat native runs exit without leaks; an injected failed check exits 1. | [Final aggregate validation](pending-completion-validation.json) |

## External editor connection blocker

Native app discovery still fails with `Sky Computer Use native pipe startup failed`. It was retried after resetting the tool runtime and again after the user reconnected Computer Use. The returned app inventory remains empty. The app's current diagnostic log also contains `browser-use native pipe rejected socket peer reason=untrusted-process-ancestry`; this is evidence of a connection trust issue, but it does not by itself prove the cause of the separate Sky startup failure.

No desktop clicks, timeline operations or inspector edits are claimed. The tool exposes no repair/restart operation for this protected service. Its supported native API cannot attach to Godot while startup fails. There is no project-file fix for that connection failure. A fresh ChatGPT desktop/local Work session is the next troubleshooting step to try, not a verified remedy.

[Official setup documentation](https://developers.openai.com/training/walkthroughs/using-your-computer-and-browser) describes Work locally, Computer Use access and the macOS permissions. The user already tried reconnecting; repeated permission requests are not a substitute for resolving the service/session issue.

## Remaining source and approval gates

- Terrain is technically usable in the documented alternating mirrored sequence. Mirrored repetition and inherited mortar bands are visible; full corner/sidewall coverage, arbitrary-depth transitions and final Chapter 3 material acceptance remain open. Individual seamless tiles are not claimed.
- Keeper and Warden source designs do not match their canonical ground/staff behavior. Missing enemy/player actions and merged poses cannot be manufactured by renaming existing clips.
- Golden Fragment originals have painted checkerboards. Drainage Sigil, Guardian Key and Sunken Seal lack separate clean unlit bases. Matching rune-door states are absent.
- Generated grayscale maps have documented registration limits. The supplied-map derivatives are bump normals and bitmap-driven specular inputs, not claimed authored tangent-space normal maps or calibrated roughness.
- Four chapter audio cues are available; sixteen are absent. Playback, looping, bus routing and teardown are verified. Listening and final mix acceptance are not claimed.
- These are asset/resource reviews. The eight chapter section scaffolds have not become completed playable levels; campaign placement, missing combat behaviors, final scene approval and target-device profiling remain separate work.

The master checklist and project copy match, and pre-existing checkboxes remain unchanged. New asset records remain unchecked where their requested full deliverable or final scene approval is not established.
