# Sentinel encounter style and lighting

The encounter HUD follows the supplied reference: a generated gold-and-vine Sentinel portrait frame, separate dark nameplate and live red health fill; a serif objective card and botanical notice; and framed hearts and trail points. The boss title, phase, health, points, objectives and feedback remain driven by game state. HUD panels hide during menus, dialogue, pause and chapter completion. Text and health are rendered separately from artwork. The new frame's source and alpha-cropped runtime export are recorded under UI-008; earlier bar exports remain available.

Temple art tint is warmer, with cooler recesses for depth. Real PointLight2D emitters align to measured lantern positions on the temple background, following each sprite's actual parallax and mirrored transform. Paired narrow and broad gradients provide a warm flame core and soft falloff. Offscreen lights are culled, no more than two local lights cast shadows, and reduced-effects mode removes flicker and flash. Revival and root attacks add restrained warm pulses around the boss. The HUD stays on its separate unlit canvas. Lighting remains a runtime system, supplementing the artwork's painted shading.

Validation covers live health proportions and phase titles, portrait sizing, objective/notice/point updates, menu/pause visibility, lantern alignment under parallax/mirroring, bounded visible lights and boss-state pulses. Native render review caught and corrected the imported portrait's source-size minimum; tests now explicitly constrain its display width. Source hashes and master checklist are maintained separately from final physical-device/art approval.

[Native encounter preview](chapter01-encounter-style-preview.png) · [Full checks](prologue-validation.txt) · [Exported pack](prologue-pack-validation.txt)

All304 source-project checks and the exported-pack suites pass. All486 runtime source/output hash records verify. Native images confirm the intended portrait size, text spacing and live fill. Host log/keychain and existing exit-cleanup warnings remain in validation logs; no script errors or missing runtime resources were reported.
