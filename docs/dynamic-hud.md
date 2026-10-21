# Dynamic fantasy HUD

The gold and deep teal kit is used for live points, objectives, notices, reward captions and chest interaction. Separate crystal and leaf images sit beside real text. The player hearts, vitality bar and pause control retain their earlier presentation. Existing menu and story artwork remains separately managed.

The reusable panel is a compact 192×96 texture with 32px fixed corner regions. Godot nine-slices it at render time, stretching the middle and edges around content rather than scaling an entire screenshot. Nine individual region exports are archived alongside the atlas. PanelContainer, HBoxContainer and VBoxContainer measure content. Points widen for additional digits; objectives and notices wrap and grow vertically; notices move below the measured objective. Reward captions and input buttons use the same skin. The player health design is preserved: the original five hearts, simple life frame, vine health-bar artwork, placement and numeric styling.

Sources, user references, crop provenance, sizes and SHA-256 hashes are preserved in UI-004 metadata and the shared runtime manifest. Earlier generations and checkboxes are preserved. Generated frame and medallion used the built-in image_gen tool; exact prompts are recorded in source session, normalized production prompts in metadata.

Validation: 21 dynamic content/layout checks, 12 encounter HUD checks, 11 reward HUD checks. Native Godot rendering visually reviewed at 1280×720. Narrow panel bounds stress-tested at 800px; viewport scaling uses the project canvas stretch configuration. Full device and final art approval remain pending.

Gameplay guidance now appears as a wrapped notice below the top-left objective and feedback stack. A changed instruction displays for five seconds, fading over the final 0.6 seconds. Rewriting the same instruction each frame does not restart its timer. Empty text clears it, and pauses/dialogue suspend its timer. The original center-screen hint is suppressed; controller input and chest prompt suppression remain unchanged.

Scope correction: restored the pre-update player hearts and health bar exactly; the reusable new skin applies to content panels, points and reward prompts. The restoration is covered by regression assertions and native Godot visual review.
