# TAVI-017 — Hurt Reaction (Prototype Asset Pack)

## Files
- `frames/` — eight individually exported RGBA PNG frames, 512×768 each.
- `silhouettes/` — matching black silhouettes, one per frame, with alpha transparency.
- `tavi_017_hurt_spritesheet.png` — full-resolution horizontal sprite strip, 4096×768.
- `tavi_017_hurt_silhouette_sheet.png` — downsized contact strip for quick reference.
- `tavi_017_hurt_silhouette_sheet_full.png` — full-resolution silhouette strip, 4096×768.
- `tavi_017_hurt_preview.gif` — preview animation on a light background.
- `manifest.json` — frame names and metadata.

## Godot setup
Create a `SpriteFrames` animation named `hurt`; import the eight files from `frames/` in numeric order, set playback to about 8 FPS, and disable looping. After the final frame, transition back to `idle` or `run`. Trigger this animation from the player's hit-stun state.

## Important quality note
This is a prototype extraction from a generated reference board, not final production art. The image generator drifted from Tavi's approved model sheet; hair and clothing colors were adjusted toward the intended blue-hair / cream-tunic palette, but some costume and edge details remain inconsistent. Inspect every frame in Godot and redraw/clean before a release build. The silhouettes are derived from each frame's alpha mask.
