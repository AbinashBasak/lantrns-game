# Lanterns Underroot

Godot 4.7.2 · GDScript · Illustrated 2D action-adventure · Initial playable setup

Open `project.godot` in Godot and press **F6** with `scenes/main/main.tscn` selected, or **F5** to run the project. Choose **Begin the trail** or press Enter.

The Forgotten Trail prototype includes Tavi and Mote, movement with coyote time and jump buffering, variable jump height, sword combat, four Thornlings, six light seeds, a healing lantern checkpoint, death/respawn, pause/restart, and an ending at the old arch. Gather at least three seeds and press E near the arch. The complete campaign, prologue cutscenes, boss, root-temple puzzle, audio, and persistent saves are future work.

| Action | Keyboard | Controller |
|---|---|---|
| Move | A / D or Left / Right | Left stick |
| Jump | Space / W / Up | A |
| Sword | J / X | X |
| Interact | E | Y |
| Pause | Escape | Start |
| Restart | R | Pause menu |

Mobile displays multitouch controls. To preview them on desktop, run Godot with `-- --touch`. Landscape viewport is 1280 × 720 with canvas scaling and the Compatibility renderer. Android and Windows builds still require the corresponding export templates, SDK configuration, and device testing.

## Files

- `scenes/main/main.tscn`: project entry point and prototype orchestration.
- `scenes/levels/underroot_01.tscn`: editable platform collisions and spawn marker.
- `scenes/player/player.tscn`: player physics and recovered Tavi animations.
- `scenes/enemies/thornling.tscn`: reusable patrolling enemy.
- `assets/characters/tavi/`: 60 transparent PNG frames, SpriteFrames, source manifests.
- `assets/references/`: reference images copied from Downloads.
- `docs/full-story.md`: the complete story from the shared chat.
- `docs/lanterns_underroot_chapters.md`: complete campaign chapter plan.
- `docs/lanterns_underroot_prologue_ch1_development_plan.md`: original first-slice development plan.
- `docs/lanterns_underroot_master_asset_checklist.md`: master checklist.
- `archive/shared-chat/`: source HTML, decoded data, transcript, file references, tool code, all 36 generated images, and 47 embedded reference images.
- `archive/rebuilt-assets/`: seven rebuilt ZIP packs, sheets, GIFs and contact sheets.
- `docs/asset-recovery.md`: original versus rebuilt asset provenance and limitations.
- `docs/mcp-setup.md`: the Godot MCP bridge used for creation and verification.

## Validation

Run `tools/test.command` or:

```sh
"/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot" --headless --path . --script res://tests/smoke_test.gd
```

`tests/capture_preview.tscn` renders title/gameplay screenshots into `docs/` for visual review. The verification MCP client stops this capture process after inspecting its debug output.

`tools/rebuild_animation_packs.py` regenerates the derived assets using Pillow, numpy and scipy. Original images are never overwritten. These derived frames are prototype art: the source sheets have inconsistent poses and some clipped scarf, sword and slash edges. Hurt reaction TAVI-017 was not successfully delivered in the source chat and is not presented as a finished animation here.
