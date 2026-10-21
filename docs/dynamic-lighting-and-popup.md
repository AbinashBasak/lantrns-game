# Real-time world lighting and completion popup

Godot PointLight2D emitters now illuminate the village, Forgotten Trail, root-temple, boss arena and all three jungle routes. A CanvasModulate node blends each area's ambient palette. Tavi and Mote carry moving lights; local landmark lights have gentle variation, and the Sentinel's light changes colour in berserk mode and reacts to attacks/rejuvenation. The village Hearthlight failure reduces its actual light and ambient visibility.

Terrain LightOccluder2D geometry casts shadows, and Tavi's moving silhouette receives a separate shadow mask so landmark lights cast a moving character shadow. At most two local lights cast shadows at once; distant emitters are hidden. Real-time lights supplement the existing painted shading in the source art. HUD and popup canvases retain their colours. Pause freezes lighting animation; reduced-effects mode disables pulsation/flashes and raises ambient visibility.

The chapter-complete popup follows the supplied reference: a generated text-free gold/teal botanical frame, parchment ribbon, golden crystal crest, blue pennants and gold button. Heading, reward message and Replay action remain live Godot UI. The panel fades/scales in while the game is paused, dims the background and supports keyboard/controller focus and mouse/touch activation. A screen-blur experiment was removed after a native renderer crash; the tested version uses a plain translucent backdrop. See [runtime popup preview](chapter01-popup-runtime-preview.png) and [completion view](chapter01-complete-preview.png).

The generated UI-023 source, versioned export and runtime copy are recorded in its metadata and runtime manifest. Earlier images and checklist boxes are preserved. Runtime implementation is verified separately from final art/device release approval. System serif fonts use platform fallbacks.

Validation covers actual moving light nodes, ambient transitions, occluders, bounded shadow count, all jungle regions, village light failure, HUD isolation, reduced-effects/pause behaviour, popup layout/animation and an actual Replay mouse click. Full results are in [gameplay validation](prologue-validation.txt) and [exported-pack validation](prologue-pack-validation.txt). Physical Android/Windows performance and human lighting/balance review remain pending.

All275 source-project checks pass. The popup was rendered in Godot and its Replay action was exercised with actual pointer input.

[Real-time lighting motion preview](realtime-lighting-preview.gif). The rebuilt content pack passes the gameplay, popup and lighting suites from an empty project directory. All484 runtime source/output hash records verify. Host log/keychain and inherited exit-cleanup warnings remain in the logs; no script errors or missing runtime resources were reported.

## Reference memory popup

The Golden Fragment memory now uses the second supplied UI reference. A separate generated UI-009 botanical frame holds the existing ENV-04 orchard layers in a transparent upper window, with live serif dialogue on parchment and a dark-green Continue button. E/Y/Enter advance once; mouse and touch use the same dialogue callback. Pausing hides the memory overlay so pause controls remain available; resuming restores it. The three memory lines, story reward and completion flow remain connected. See [runtime memory preview](chapter01-memory-preview.png). Source and runtime hashes are preserved in the UI-009 metadata and [runtime manifest](../assets/runtime/chapter01/ui/manifest.json). Twelve focused interaction/layout checks pass; final device/art approval remains pending.

The memory-popup update passes all287 source-project checks and the exported content-pack suites. Independent parallel reviews verified native layout/input behavior, asset hashes and master/project checklist synchronization. All485 runtime source/output records verify.
