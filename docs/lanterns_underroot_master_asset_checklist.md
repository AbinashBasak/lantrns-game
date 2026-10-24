# Lanterns Underroot — Master Game Asset Checklist

**Project:** Lanterns Underroot  
**Genre:** Original 2D illustrated fantasy action-adventure platformer  
**Engine:** Godot  
**Platforms:** Android, iOS, Windows, macOS, Linux (as applicable)  
**Purpose:** Master inventory for producing game assets one by one.

## Saved asset locations

- **Master checklist:** `/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md`
- **Project copy:** `/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/lanterns_underroot_master_asset_checklist.md`
- **Asset library:** `/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production`
- **Path registry:** [asset_registry.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/asset_registry.json)
- **Source chat:** https://chatgpt.com/share/6ad136a4-4cc8-83ee-9742-05bc90e2a1dc
- **Last organized:** 2026-10-17

The 14 existing checked asset IDs have saved folders below. Original generations are kept in `source_images/`; reconstructed images and animation exports are labeled in each folder's `metadata.json`. An existing check means the item was checked in this inventory, not that final production approval has been established.

When generating a new asset, save it under its phase/subsection/asset-ID folder, record its image and export paths in this document and `asset_registry.json`, and update the project copy. Keep earlier versions and record the production stage. Leave unchecked items unchanged until their requested deliverable has been saved and reviewed.

## Production conventions

- [ ] Establish and approve one original visual style before producing final assets.
- [ ] Keep character designs, proportions, palettes, materials, and lighting consistent.
- [ ] Use isolated transparent PNGs for characters, props, effects, and icons where appropriate.
- [ ] Keep environments separated into background, midground, playable terrain, and foreground layers.
- [ ] Make animation frames consistent in canvas size, pivot, scale, and order.
- [ ] Record asset IDs, source files, export files, frame rate, dimensions, and licensing/source notes.
- [ ] Treat concept art and mood boards as references—not as production sprite sheets.
- [ ] Test assets in Godot before marking them production-ready.

## Recommended starting technical targets

These are initial targets and should be validated in-engine as production begins.

- World tile size: 64 × 64 Godot units.
- Character animation cells: standardize around 192 × 192 pixels or larger where needed.
- Environment backgrounds: separate wide layers, often 2048 pixels or wider.
- Format: PNG for raster art; transparent backgrounds for isolated sprites.
- Animation sheets: fixed cell dimensions with documented frame order and timing.
- Naming example: `TAVI-010_idle_sheet.png`, `ENV-02_forest_midground.png`.

---

# Phase 00 — Art Foundation

- [x] ART-001 — Final visual style guide
  - Saved folder: [ART-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-001)
  - Image: [ART-001_final_visual_style_guide.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-001/ART-001_final_visual_style_guide.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-001/metadata.json)
- [x] ART-002 — Color palette and lighting reference
  - Saved folder: [ART-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-002)
  - Image: [ART-002_color_palette_and_lighting.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-002/ART-002_color_palette_and_lighting.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-002/metadata.json)
- [x] ART-003 — Character proportion and scale sheet
  - Saved folder: [ART-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-003)
  - Image: [ART-003_character_proportion_and_scale.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-003/ART-003_character_proportion_and_scale.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-003/metadata.json)
- [x] ART-004 — Environment material reference: soil, grass, stone, roots, wood
  - Saved folder: [ART-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-004)
  - Image: [ART-004_environment_material_reference.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-004/ART-004_environment_material_reference.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-004/metadata.json)
- [x] ART-005 — Magic, rune, glow, and particle style reference
  - Saved folder: [ART-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-005)
  - Image: [ART-005_magic_rune_glow_particle_reference.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-005/ART-005_magic_rune_glow_particle_reference.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-005/metadata.json)
- [x] ART-006 — Character and environment rendering consistency guide
  - Saved folder: [ART-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-006)
  - Image: [ART-006_rendering_consistency_guide.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-006/ART-006_rendering_consistency_guide.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_00_art_foundation/ART-006/metadata.json)

# Phase 01 — Main Character: Tavi

## Character design

- [x] TAVI-001 — Approved character model sheet: front, side, back, and three-quarter views
  - Saved folder: [TAVI-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/character_design/TAVI-001)
  - Image: [TAVI-001_character_turnaround.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/character_design/TAVI-001/TAVI-001_character_turnaround.png)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/character_design/TAVI-001/metadata.json)
- [ ] TAVI-002 — Character color and material reference
- [ ] TAVI-003 — Sword design sheet
- [ ] TAVI-004 — Sprite scale, pivot, and collision reference

## Core animations — prototype priority

- [x] TAVI-010 — Idle
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010)
  - Image: [TAVI-010_idle_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/TAVI-010_idle_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/previews/TAVI-010_idle_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/metadata.json)
- [x] TAVI-011 — Run
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011)
  - Image: [TAVI-011_run_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/TAVI-011_run_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/previews/TAVI-011_run_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/metadata.json)
- [x] TAVI-012 — Jump start
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012)
  - Image: [TAVI-012_jump_start_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/TAVI-012_jump_start_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/previews/TAVI-012_jump_start_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/metadata.json)
- [x] TAVI-013 — Rising jump
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013)
  - Image: [TAVI-013_jump_rise_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/TAVI-013_jump_rise_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/previews/TAVI-013_jump_rise_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/metadata.json)
- [x] TAVI-014 — Falling
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014)
  - Image: [TAVI-014_jump_fall_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/TAVI-014_jump_fall_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/previews/TAVI-014_jump_fall_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/metadata.json)
- [x] TAVI-015 — Landing
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015)
  - Image: [TAVI-015_landing_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/TAVI-015_landing_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/previews/TAVI-015_landing_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/metadata.json)
- [x] TAVI-016 — Sword attack
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Saved folder: [TAVI-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-016)
  - Image: [TAVI-016_sword_attack_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-016/TAVI-016_sword_attack_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-016/previews/TAVI-016_sword_attack_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-016/metadata.json)
- [x] TAVI-017 — Hurt reaction
  - Saved folder: [TAVI-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-017)
  - Downloaded pack: [original ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-017/exports/TAVI-017_downloaded_hurt_asset_pack.zip) · [sprite strip](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-017/exports/TAVI-017_hurt_spritesheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-017/previews/TAVI-017_hurt_preview.gif)
  - Animation: 8 frames, 512 × 768 pixels per frame, suggested 8 FPS, non-looping.
  - Recovery stage: original ZIP and 7 hurt-reference images saved and reviewed; 8 transparent frames and silhouettes archived. Prototype needs model/color/alpha cleanup; not production approved.
  - Recovery record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-017/metadata.json) · [inspection report](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/project-chat-recovery-2026-10-16.md)
- [x] TAVI-018 — Death
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-018/exports/TAVI-018_death_prototype_pack.zip) · [6-pose contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-018/previews/TAVI-018_death_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-018/previews/TAVI-018_death_preview.gif)
  - Exports: six separate 1024 × 768 RGBA frames and matching silhouette references; non-looping timing recorded in the manifest.
  - Stage: six-pose death prototype generated and reviewed; halo, continuity and alignment cleanup pending; not production approved.
  - Saved folder: [TAVI-018](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-018) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-018/metadata.json)
- [x] TAVI-019 — Interact with object
  - Stage: six-pose interaction prototype generated and reviewed; continuity and in-engine review pending; not production approved.
  - Saved folder: [TAVI-019](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-019) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-019/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-019/exports/TAVI-019_interact_prototype_pack.zip) · [6-pose contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-019/previews/TAVI-019_interact_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-019/previews/TAVI-019_interact_preview.gif)
  - Exports: six separate 1024 × 768 RGBA frames and matching silhouette references; non-looping timing recorded in the manifest.
- [x] TAVI-020 — Activate rune with sword
  - Stage: six-pose rune_activation prototype generated and reviewed; continuity and in-engine review pending; not production approved.
  - Saved folder: [TAVI-020](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-020) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-020/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-020/exports/TAVI-020_rune_activation_prototype_pack.zip) · [6-pose contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-020/previews/TAVI-020_rune_activation_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-020/previews/TAVI-020_rune_activation_preview.gif)
  - Exports: six separate 1024 × 768 RGBA frames and matching silhouette references; non-looping timing recorded in the manifest.
- [x] TAVI-021 — Lantern reveal ability
  - Stage: six-pose lantern_reveal prototype generated and reviewed; continuity and in-engine review pending; not production approved.
  - Saved folder: [TAVI-021](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-021) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-021/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-021/exports/TAVI-021_lantern_reveal_prototype_pack.zip) · [6-pose contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-021/previews/TAVI-021_lantern_reveal_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-021/previews/TAVI-021_lantern_reveal_preview.gif)
  - Exports: six separate 1024 × 768 RGBA frames and matching silhouette references; non-looping timing recorded in the manifest.

## Later movement and combat animations

- [x] TAVI-022 — Dodge or dash
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-022](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-022) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-022/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-022/exports/TAVI-022_dash_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-022/previews/TAVI-022_dash_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-022/previews/TAVI-022_dash_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-023 — Second sword combo
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-023](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-023) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-023/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-023/exports/TAVI-023_second_sword_combo_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-023/previews/TAVI-023_second_sword_combo_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-023/previews/TAVI-023_second_sword_combo_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-024 — Charged attack
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-024](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-024) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-024/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-024/exports/TAVI-024_charged_attack_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-024/previews/TAVI-024_charged_attack_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-024/previews/TAVI-024_charged_attack_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-025 — Climbing
  - Stage: six-frame climbing study generated and reviewed; alternating-limb continuity and camera correction pending; not production approved.
  - Saved folder: [TAVI-025](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-025) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-025/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-025/exports/TAVI-025_climbing_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-025/previews/TAVI-025_climbing_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-025/previews/TAVI-025_climbing_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-026 — Opening chest
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-026](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-026) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-026/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-026/exports/TAVI-026_opening_chest_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-026/previews/TAVI-026_opening_chest_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-026/previews/TAVI-026_opening_chest_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-027 — Victory
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-027](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-027) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-027/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-027/exports/TAVI-027_victory_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-027/previews/TAVI-027_victory_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-027/previews/TAVI-027_victory_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.
- [x] TAVI-028 — Knockback and recovery
  - Stage: six-frame animation prototype generated and visually reviewed; cleanup and in-engine review pending; not production approved.
  - Saved folder: [TAVI-028](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-028) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-028/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-028/exports/TAVI-028_knockback_recovery_prototype_pack.zip) · [6-frame contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-028/previews/TAVI-028_knockback_recovery_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/later_movement_and_combat/TAVI-028/previews/TAVI-028_knockback_recovery_preview.gif)
  - Exports: six 512 × 512 RGBA frames, strips and silhouette references; timing and review notes recorded in manifest.

# Phase 02 — Companion: Mote

Review exports: [Phase 02 index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE_phase02_index.md) · [All prototype packs](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE_phase02_prototype_bundle.zip). Generated proposals; production approval remains pending.

- [x] MOTE-001 — Character model sheet
  - Stage: model-sheet proposal generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-001) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-001/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-001/exports/MOTE-001_model_sheet_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-001/previews/MOTE-001_model_sheet_contact_sheet.jpg)
  - Exports: 4 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-002 — Idle hover
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/exports/MOTE-002_idle_hover_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/previews/MOTE-002_idle_hover_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/previews/MOTE-002_idle_hover_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-003 — Follow Tavi
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/exports/MOTE-003_follow_tavi_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/previews/MOTE-003_follow_tavi_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/previews/MOTE-003_follow_tavi_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-004 — Alert reaction
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-004) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-004/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-004/exports/MOTE-004_alert_reaction_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-004/previews/MOTE-004_alert_reaction_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-004/previews/MOTE-004_alert_reaction_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-005 — Rune interaction
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-005) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-005/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-005/exports/MOTE-005_rune_interaction_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-005/previews/MOTE-005_rune_interaction_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-005/previews/MOTE-005_rune_interaction_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-006 — Glow pulse
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-006) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-006/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-006/exports/MOTE-006_glow_pulse_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-006/previews/MOTE-006_glow_pulse_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-006/previews/MOTE-006_glow_pulse_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-007 — Celebrate discovery
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-007) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-007/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-007/exports/MOTE-007_celebrate_discovery_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-007/previews/MOTE-007_celebrate_discovery_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-007/previews/MOTE-007_celebrate_discovery_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-008 — Disappear and reappear
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-008) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-008/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-008/exports/MOTE-008_disappear_reappear_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-008/previews/MOTE-008_disappear_reappear_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-008/previews/MOTE-008_disappear_reappear_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-009 — Companion light effect
  - Stage: light-effect prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-009) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-009/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-009/exports/MOTE-009_companion_light_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-009/previews/MOTE-009_companion_light_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-009/previews/MOTE-009_companion_light_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-010 — Story-specific reactions
  - Stage: story reaction keypose study generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-010) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-010/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-010/exports/MOTE-010_story_reactions_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-010/previews/MOTE-010_story_reactions_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-010/previews/MOTE-010_story_reactions_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.

# Phase 03 — Enemies and Chapter 1 Boss

Review exports: [Phase 03 index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/PHASE03_index.md) · [Complete prototype bundle](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/PHASE03_prototype_bundle.zip). Generated proposals; cleanup and production approval remain pending.

## Enemies

- [x] EN-001 — Rootling model sheet
  - Stage: model proposal generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-001) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-001/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-001/exports/EN-001_prototype_pack.zip) · [model preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-001/previews/EN-001_model_contact_sheet.jpg)
  - Exports: 4 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-002 — Rootling idle animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/exports/EN-002_prototype_pack.zip) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/previews/EN-002_idle_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-003 — Rootling patrol or movement animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/exports/EN-003_prototype_pack.zip) · [patrol preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/previews/EN-003_patrol_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-004 — Rootling attack animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/exports/EN-004_prototype_pack.zip) · [attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/previews/EN-004_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-005 — Rootling hurt animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/exports/EN-005_prototype_pack.zip) · [hurt preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/previews/EN-005_hurt_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-006 — Rootling defeat animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-006) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-006/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-006/exports/EN-006_prototype_pack.zip) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-006/previews/EN-006_defeat_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-007 — Thornwing model sheet
  - Stage: model proposal generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-007) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-007/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-007/exports/EN-007_prototype_pack.zip) · [model preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-007/previews/EN-007_model_contact_sheet.jpg)
  - Exports: 4 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-008 — Thornwing hover and fly animations
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-008) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-008/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-008/exports/EN-008_prototype_pack.zip) · [hover preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-008/previews/EN-008_hover_contact_sheet.jpg) · [fly preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-008/previews/EN-008_fly_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [ ] EN-009 — Thornwing dive attack
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-009) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-009/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-009/exports/EN-009_prototype_pack.zip) · [dive_attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-009/previews/EN-009_dive_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-010 — Thornwing hurt and defeat animations
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-010) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-010/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-010/exports/EN-010_prototype_pack.zip) · [hurt preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-010/previews/EN-010_hurt_contact_sheet.jpg) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-010/previews/EN-010_defeat_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-011 — Sporeling model sheet
  - Stage: model proposal generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-011) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-011/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-011/exports/EN-011_prototype_pack.zip) · [model_sheet preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-011/previews/EN-011_model_sheet_contact_sheet.jpg)
  - Exports: 4 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [ ] EN-012 — Sporeling idle and movement animations
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-012) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-012/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-012/exports/EN-012_prototype_pack.zip) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-012/previews/EN-012_idle_contact_sheet.jpg) · [movement preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-012/previews/EN-012_movement_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-013 — Sporeling spore attack
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-013) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-013/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-013/exports/EN-013_prototype_pack.zip) · [spore_attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-013/previews/EN-013_spore_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-014 — Sporeling hurt and defeat animations
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-014) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-014/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-014/exports/EN-014_prototype_pack.zip) · [hurt preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-014/previews/EN-014_hurt_contact_sheet.jpg) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-014/previews/EN-014_defeat_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-015 — Brambleguard model sheet
  - Stage: model proposal generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-015) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-015/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-015/exports/EN-015_prototype_pack.zip) · [model_sheet preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-015/previews/EN-015_model_sheet_contact_sheet.jpg)
  - Exports: 4 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-016 — Brambleguard walk and idle animations
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-016) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-016/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-016/exports/EN-016_prototype_pack.zip) · [walk preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-016/previews/EN-016_walk_contact_sheet.jpg) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-016/previews/EN-016_idle_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-017 — Brambleguard heavy attack
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-017) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-017/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-017/exports/EN-017_prototype_pack.zip) · [heavy_attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-017/previews/EN-017_heavy_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-018 — Brambleguard stagger, hurt, and defeat animations
  - Stage: animation prototype generated and visually reviewed; 3 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-018](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018/exports/EN-018_prototype_pack.zip) · [stagger preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018/previews/EN-018_stagger_contact_sheet.jpg) · [hurt preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018/previews/EN-018_hurt_contact_sheet.jpg) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-018/previews/EN-018_defeat_contact_sheet.jpg)
  - Exports: 18 RGBA frames/views across 3 separate clip/view set(s); timing, prompts, provenance and hashes recorded.

## Hollow Sentinel boss

- [x] BOSS-001 — Final boss design sheet
  - Stage: model proposal generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-001) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-001/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-001/exports/BOSS-001_prototype_pack.zip) · [model preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-001/previews/BOSS-001_model_contact_sheet.jpg)
  - Exports: 4 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-002 — Idle animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/exports/BOSS-002_prototype_pack.zip) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/previews/BOSS-002_idle_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-003 — Walking and repositioning
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/exports/BOSS-003_prototype_pack.zip) · [walk_reposition_profile_corrected preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/previews/BOSS-003_walk_reposition_profile_corrected_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-004 — Attack wind-up
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/exports/BOSS-004_prototype_pack.zip) · [attack_windup preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/previews/BOSS-004_attack_windup_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-005 — Ground slam
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/exports/BOSS-005_prototype_pack.zip) · [ground_slam preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/previews/BOSS-005_ground_slam_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-006 — Arm swipe
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-006) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-006/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-006/exports/BOSS-006_prototype_pack.zip) · [arm_swipe preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-006/previews/BOSS-006_arm_swipe_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-007 — Ranged core attack
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-007) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-007/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-007/exports/BOSS-007_prototype_pack.zip) · [ranged_core_attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-007/previews/BOSS-007_ranged_core_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-008 — Stagger and damage reaction
  - Chapter 1 runtime: Selected frames prepared for Chapter 1, currently unused by the encounter; production approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/exports/BOSS-008_prototype_pack.zip) · [stagger_damage preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/previews/BOSS-008_stagger_damage_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-009 — Phase transition
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/exports/BOSS-009_prototype_pack.zip) · [phase_transition preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/previews/BOSS-009_phase_transition_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-010 — Defeat animation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/exports/BOSS-010_prototype_pack.zip) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/previews/BOSS-010_defeat_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-011 — Boss arena entrance and awakening effects
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Stage: animation prototype generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-011) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-011/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-011/exports/BOSS-011_prototype_pack.zip) · [awakening preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-011/previews/BOSS-011_awakening_contact_sheet.jpg) · [awakening_fx preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-011/previews/BOSS-011_awakening_fx_contact_sheet.jpg)
  - Exports: 12 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-012 — Boss health bar icon and UI portrait
  - Stage: UI proposal generated and visually reviewed; 2 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-012) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-012/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-012/exports/BOSS-012_prototype_pack.zip) · [health_icon preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-012/previews/BOSS-012_health_icon_contact_sheet.jpg) · [ui_portrait preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-012/previews/BOSS-012_ui_portrait_contact_sheet.jpg)
  - Exports: 2 RGBA frames/views across 2 separate clip/view set(s); timing, prompts, provenance and hashes recorded.

# Phase 04 — Environment Packs

Generation batch: **11/11 prototype packs, 88/88 source types saved and reviewed**, with 496 exported image files. [Pack index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/PHASE04_index.md). The environment pack checkboxes below record completed, reviewed prototype deliverables. Production cleanup and Godot testing remain; these checks do not imply final production approval.

- [x] ENV-01 — Brackenreach village (prologue)
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase04-record:ENV-01:start -->
  - Production stage: prototype sources and exports reviewed. Final production approval pending.
  - Saved folder: [ENV-01](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-01_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_lighting_reference_original.png)
  - Distant background: [ENV-01_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_distant_background_original.png)
  - Midground: [ENV-01_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_midground_original.png)
  - Terrain atlas: [ENV-01_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_terrain_atlas_original.png)
  - Foreground: [ENV-01_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_foreground_original.png)
  - Decorative props: [ENV-01_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_decorative_props_original.png)
  - Interactive props: [ENV-01_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_interactive_props_original.png)
  - Location fx: [ENV-01_location_fx_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-01/source_images/ENV-01_location_fx_original_v2.png)
  <!-- phase04-record:ENV-01:end -->
- [x] ENV-02 — The Forgotten Trail (Chapter 1)
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase04-record:ENV-02:start -->
  - Production stage: prototype sources and exports reviewed. Final production approval pending.
  - Saved folder: [ENV-02](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-02_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_lighting_reference_original.png)
  - Distant background: [ENV-02_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_distant_background_original.png)
  - Midground: [ENV-02_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_midground_original.png)
  - Terrain atlas: [ENV-02_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_terrain_atlas_original.png)
  - Foreground: [ENV-02_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_foreground_original.png)
  - Decorative props: [ENV-02_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_decorative_props_original.png)
  - Interactive props: [ENV-02_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_interactive_props_original.png)
  - Location fx: [ENV-02_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-02/source_images/ENV-02_location_fx_original.png)
  <!-- phase04-record:ENV-02:end -->
- [x] ENV-03 — The Ancient Root-Temple (Chapter 1)
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase04-record:ENV-03:start -->
  - Production stage: prototype sources and exports reviewed. Final production approval pending.
  - Saved folder: [ENV-03](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-03_lighting_reference_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_lighting_reference_original_v2.png)
  - Distant background: [ENV-03_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_distant_background_original.png)
  - Midground: [ENV-03_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_midground_original.png)
  - Terrain atlas: [ENV-03_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_terrain_atlas_original.png)
  - Foreground: [ENV-03_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_foreground_original.png)
  - Decorative props: [ENV-03_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_decorative_props_original.png)
  - Interactive props: [ENV-03_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_interactive_props_original.png)
  - Location fx: [ENV-03_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-03/source_images/ENV-03_location_fx_original.png)
  <!-- phase04-record:ENV-03:end -->
- [x] ENV-04 — Briarwake orchard
  - Chapter 1 runtime: Two selected layers used for the Golden Fragment memory illustration only; playable orchard level and full-pack approval remain separate. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase04-record:ENV-04:start -->
  - Production stage: prototype sources and exports visually reviewed; tile cleanup and runtime validation pending. Final production approval pending.
  - Saved folder: [ENV-04](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-04_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_lighting_reference_original.png)
  - Distant background: [ENV-04_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_distant_background_original.png)
  - Midground: [ENV-04_midground_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_midground_original_v2.png)
  - Terrain atlas: [ENV-04_terrain_atlas_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_terrain_atlas_original_v2.png)
  - Foreground: [ENV-04_foreground_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_foreground_original_v2.png)
  - Decorative props: [ENV-04_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_decorative_props_original.png)
  - Interactive props: [ENV-04_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_interactive_props_original.png)
  - Location fx: [ENV-04_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-04/source_images/ENV-04_location_fx_original.png)
  <!-- phase04-record:ENV-04:end -->
- [x] ENV-05 — Glasswater Fen
  <!-- phase04-record:ENV-05:start -->
  - Production stage: generated prototype set saved and reviewed. Final production approval pending.
  - Saved folder: [ENV-05](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-05_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_lighting_reference_original.png)
  - Distant background: [ENV-05_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_distant_background_original.png)
  - Midground: [ENV-05_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_midground_original.png)
  - Terrain atlas: [ENV-05_terrain_atlas_fixed_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_terrain_atlas_fixed_original.png)
  - Foreground: [ENV-05_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_foreground_original.png)
  - Decorative props: [ENV-05_decorative_props_alpha_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_decorative_props_alpha_v2.png)
  - Interactive props: [ENV-05_interactive_props_alpha_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_interactive_props_alpha_v2.png)
  - Location fx: [ENV-05_location_fx_alpha_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-05/source_images/ENV-05_location_fx_alpha_v2.png)
  <!-- phase04-record:ENV-05:end -->
- [x] ENV-06 — Bellows Gorge
  <!-- phase04-record:ENV-06:start -->
  - Production stage: generated prototype set saved and reviewed. Final production approval pending.
  - Saved folder: [ENV-06](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-06_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_lighting_reference_original.png)
  - Distant background: [ENV-06_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_distant_background_original.png)
  - Midground: [ENV-06_midground_fixed_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_midground_fixed_original.png)
  - Terrain atlas: [ENV-06_terrain_atlas_fixed_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_terrain_atlas_fixed_original.png)
  - Foreground: [ENV-06_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_foreground_original.png)
  - Decorative props: [ENV-06_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_decorative_props_original.png)
  - Interactive props: [ENV-06_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_interactive_props_original.png)
  - Location fx: [ENV-06_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-06/source_images/ENV-06_location_fx_original.png)
  <!-- phase04-record:ENV-06:end -->
- [x] ENV-07 — Archive Beneath the Earth
  <!-- phase04-record:ENV-07:start -->
  - Production stage: generated prototype set saved and reviewed. Final production approval pending.
  - Saved folder: [ENV-07](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-07_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_lighting_reference_original.png)
  - Distant background: [ENV-07_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_distant_background_original.png)
  - Midground: [ENV-07_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_midground_original.png)
  - Terrain atlas: [ENV-07_terrain_atlas_fixed_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_terrain_atlas_fixed_original.png)
  - Foreground: [ENV-07_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_foreground_original.png)
  - Decorative props: [ENV-07_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_decorative_props_original.png)
  - Interactive props: [ENV-07_interactive_props_fixed_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_interactive_props_fixed_original.png)
  - Location fx: [ENV-07_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-07/source_images/ENV-07_location_fx_original.png)
  <!-- phase04-record:ENV-07:end -->
- [x] ENV-08 — Root Cathedral
  <!-- phase04-record:ENV-08:start -->
  - Production stage: prototype sources and exports reviewed. Final production approval pending.
  - Saved folder: [ENV-08](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-08_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_lighting_reference_original.png)
  - Distant background: [ENV-08_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_distant_background_original.png)
  - Midground: [ENV-08_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_midground_original.png)
  - Terrain atlas: [ENV-08_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_terrain_atlas_original.png)
  - Foreground: [ENV-08_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_foreground_original.png)
  - Decorative props: [ENV-08_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_decorative_props_original.png)
  - Interactive props: [ENV-08_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_interactive_props_original.png)
  - Location fx: [ENV-08_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-08/source_images/ENV-08_location_fx_original.png)
  <!-- phase04-record:ENV-08:end -->
- [x] ENV-09 — Stillmere, the village frozen in time
  <!-- phase04-record:ENV-09:start -->
  - Production stage: generated prototype reviewed exports pending production. Final production approval pending.
  - Saved folder: [ENV-09](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-09_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_lighting_reference_original.png)
  - Distant background: [ENV-09_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_distant_background_original.png)
  - Midground: [ENV-09_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_midground_original.png)
  - Terrain atlas: [ENV-09_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_terrain_atlas_original.png)
  - Foreground: [ENV-09_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_foreground_original.png)
  - Decorative props: [ENV-09_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_decorative_props_original.png)
  - Interactive props: [ENV-09_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_interactive_props_original.png)
  - Location fx: [ENV-09_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-09/source_images/ENV-09_location_fx_original.png)
  <!-- phase04-record:ENV-09:end -->
- [x] ENV-10 — The Quiet Crown's final arena
  <!-- phase04-record:ENV-10:start -->
  - Production stage: generated prototype reviewed exports pending production. Final production approval pending.
  - Saved folder: [ENV-10](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-10_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_lighting_reference_original.png)
  - Distant background: [ENV-10_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_distant_background_original.png)
  - Midground: [ENV-10_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_midground_original.png)
  - Terrain atlas: [ENV-10_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_terrain_atlas_original.png)
  - Foreground: [ENV-10_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_foreground_original.png)
  - Decorative props: [ENV-10_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_decorative_props_original.png)
  - Interactive props: [ENV-10_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_interactive_props_original.png)
  - Location fx: [ENV-10_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-10/source_images/ENV-10_location_fx_original.png)
  <!-- phase04-record:ENV-10:end -->
- [x] ENV-11 — Brackenreach after the restoration
  <!-- phase04-record:ENV-11:start -->
  - Production stage: generated prototype reviewed exports pending production. Final production approval pending.
  - Saved folder: [ENV-11](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11) · 8/8 source deliverables saved · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/metadata.json)
  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.
  - Lighting reference: [ENV-11_lighting_reference_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_lighting_reference_original.png)
  - Distant background: [ENV-11_distant_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_distant_background_original.png)
  - Midground: [ENV-11_midground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_midground_original.png)
  - Terrain atlas: [ENV-11_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_terrain_atlas_original.png)
  - Foreground: [ENV-11_foreground_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_foreground_original.png)
  - Decorative props: [ENV-11_decorative_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_decorative_props_original.png)
  - Interactive props: [ENV-11_interactive_props_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_interactive_props_original.png)
  - Location fx: [ENV-11_location_fx_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_04_environment_packs/ENV-11/source_images/ENV-11_location_fx_original.png)
  <!-- phase04-record:ENV-11:end -->

Each environment pack should include, as needed:

- [x] Distant background layer(s)
- [x] Midground layer(s)
- [ ] Playable terrain and tileset
- [x] Foreground layer(s)
- [x] Decorative props
- [x] Interactive props
- [x] Location-specific visual effects
- [x] Lighting and color reference

Verified across all 11 packs: seven categories have reviewed prototype sources and exports. Terrain atlases are also saved and exported, but **playable terrain** remains pending tile-seam cleanup, collision setup, and Godot validation. These checks record prototype asset delivery, not final production approval.

# Phase 05 — Reusable Terrain and Tile Sets

<!-- phase05-summary:start -->
**Reviewed prototype packs: 17/17.** [Asset and prompt index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/PHASE05_index.md). Checked items record saved and reviewed tile prototypes, not final production approval. Sources, 64 px exports, prompts, crop maps and assembly previews are recorded per item. Tile seam cleanup, collision/autotile setup and Godot validation remain separate. No ZIP files or runtime integration added.
<!-- phase05-summary:end -->

- [x] TILE-001 — Grass-topped ground tiles
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase05-record:TILE-001:start -->
  - Production stage: reviewed prototype sources and 64px exports. Final production approval pending.
  - Saved folder: [TILE-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/previews)
  - Selected source: [TILE-001_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/source_images/TILE-001_terrain_atlas_original.png)
  <!-- phase05-record:TILE-001:end -->
- [x] TILE-002 — Dirt and soil tiles
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase05-record:TILE-002:start -->
  - Production stage: reviewed prototype sources and 64px exports. Final production approval pending.
  - Saved folder: [TILE-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002/previews)
  - Selected source: [TILE-002_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002/source_images/TILE-002_terrain_atlas_original.png)
  <!-- phase05-record:TILE-002:end -->
- [x] TILE-003 — Stone platform tiles
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase05-record:TILE-003:start -->
  - Production stage: reviewed prototype sources and 64px exports. Final production approval pending.
  - Saved folder: [TILE-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/previews)
  - Selected source: [TILE-003_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/source_images/TILE-003_terrain_atlas_original.png)
  <!-- phase05-record:TILE-003:end -->
- [x] TILE-004 — Moss-covered rock tiles
  <!-- phase05-record:TILE-004:start -->
  - Production stage: reviewed prototype sources and 64px exports. Final production approval pending.
  - Saved folder: [TILE-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004/previews)
  - Selected source: [TILE-004_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004/source_images/TILE-004_terrain_atlas_original.png)
  <!-- phase05-record:TILE-004:end -->
- [x] TILE-005 — Root platforms
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase05-record:TILE-005:start -->
  - Production stage: reviewed prototype sources and 64px exports. Final production approval pending.
  - Saved folder: [TILE-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005/previews)
  - Selected source: [TILE-005_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-005/source_images/TILE-005_terrain_atlas_original.png)
  <!-- phase05-record:TILE-005:end -->
- [x] TILE-006 — Wood platforms and bridges
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase05-record:TILE-006:start -->
  - Production stage: generated terrain prototype saved and reviewed. Final production approval pending.
  - Saved folder: [TILE-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006/previews)
  - Selected source: [TILE-006_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006/source_images/TILE-006_atlas_original.png)
  <!-- phase05-record:TILE-006:end -->
- [x] TILE-007 — Edge and corner variants
  <!-- phase05-record:TILE-007:start -->
  - Production stage: generated terrain prototype saved and reviewed. Final production approval pending.
  - Saved folder: [TILE-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-007/previews)
  - Selected source: [TILE-007_atlas_v2_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-007/source_images/TILE-007_atlas_v2_original.png)
  <!-- phase05-record:TILE-007:end -->
- [x] TILE-008 — Slopes and uneven terrain
  <!-- phase05-record:TILE-008:start -->
  - Production stage: generated terrain prototype saved and reviewed. Final production approval pending.
  - Saved folder: [TILE-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-008/previews)
  - Selected source: [TILE-008_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-008/source_images/TILE-008_atlas_original.png)
  <!-- phase05-record:TILE-008:end -->
- [x] TILE-009 — One-way platforms
  <!-- phase05-record:TILE-009:start -->
  - Production stage: generated terrain prototype saved and reviewed. Final production approval pending.
  - Saved folder: [TILE-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-009/previews)
  - Selected source: [TILE-009_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-009/source_images/TILE-009_atlas_original.png)
  <!-- phase05-record:TILE-009:end -->
- [x] TILE-010 — Broken platforms
  <!-- phase05-record:TILE-010:start -->
  - Production stage: generated terrain prototype saved and reviewed. Final production approval pending.
  - Saved folder: [TILE-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-010/previews)
  - Selected source: [TILE-010_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-010/source_images/TILE-010_atlas_original.png)
  <!-- phase05-record:TILE-010:end -->
- [x] TILE-011 — Hanging platforms
  <!-- phase05-record:TILE-011:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [TILE-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-011/previews)
  - Selected source: [TILE-011_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-011/source_images/TILE-011_terrain_atlas_original.png)
  <!-- phase05-record:TILE-011:end -->
- [x] TILE-012 — Temple wall tiles
  <!-- phase05-record:TILE-012:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [TILE-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-012/previews)
  - Selected source: [TILE-012_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-012/source_images/TILE-012_terrain_atlas_original.png)
  <!-- phase05-record:TILE-012:end -->
- [x] TILE-013 — Temple floor and ceiling tiles
  <!-- phase05-record:TILE-013:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [TILE-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-013) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-013/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-013/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-013/previews)
  - Selected source: [TILE-013_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-013/source_images/TILE-013_terrain_atlas_original.png)
  <!-- phase05-record:TILE-013:end -->
- [x] TILE-014 — Rune-embedded stone tiles
  <!-- phase05-record:TILE-014:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [TILE-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-014) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-014/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-014/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-014/previews)
  - Selected source: [TILE-014_terrain_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-014/source_images/TILE-014_terrain_atlas_original.png)
  <!-- phase05-record:TILE-014:end -->
- [x] TILE-015 — Water edges and river tiles
  <!-- phase05-record:TILE-015:start -->
  - Production stage: reviewed generated tile prototypes and64px exports; seam cleanup and engine validation pending. Final production approval pending.
  - Saved folder: [TILE-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-015) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-015/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-015/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-015/previews)
  - Selected source: [TILE-015_river_water_atlas_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-015/source_images/TILE-015_river_water_atlas_original_v2.png)
  <!-- phase05-record:TILE-015:end -->
- [x] TILE-016 — Decorative foliage and rock overlays
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase05-record:TILE-016:start -->
  - Production stage: reviewed generated tile prototypes and64px exports; seam cleanup and engine validation pending. Final production approval pending.
  - Saved folder: [TILE-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016/previews)
  - Selected source: [TILE-016_foliage_rock_overlays_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-016/source_images/TILE-016_foliage_rock_overlays_original.png)
  <!-- phase05-record:TILE-016:end -->
- [x] TILE-017 — Tile transition edges for blending environments
  <!-- phase05-record:TILE-017:start -->
  - Production stage: reviewed generated tile prototypes and64px exports; seam cleanup and engine validation pending. Final production approval pending.
  - Saved folder: [TILE-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-017) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-017/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-017/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-017/previews)
  - Selected source: [TILE-017_terrain_transition_overlays_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-017/source_images/TILE-017_terrain_transition_overlays_original.png)
  <!-- phase05-record:TILE-017:end -->

# Phase 06 — Props and Interactive Objects

<!-- phase06-summary:start -->
**Reviewed prototype packs: 26/26.** [Asset and prompt index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/PHASE06_index.md). Checked items record saved and reviewed prop/object art prototypes, not final production approval. Sources, state/module exports, prompts, crop maps and checker previews are recorded per item. State/pivot registration, modular joins, collision and gameplay behavior require separate Godot validation. No ZIP files or runtime integration added.
<!-- phase06-summary:end -->

## Village and forest props

- [x] PROP-001 — Wooden lantern
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase06-record:PROP-001:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001/previews)
  - Selected source: [PROP-001_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-001/source_images/PROP-001_prop_states_original.png)
  <!-- phase06-record:PROP-001:end -->
- [x] PROP-002 — Hanging lantern
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase06-record:PROP-002:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002/previews)
  - Selected source: [PROP-002_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-002/source_images/PROP-002_prop_states_original.png)
  <!-- phase06-record:PROP-002:end -->
- [x] PROP-003 — Wooden signpost
  <!-- phase06-record:PROP-003:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-003/previews)
  - Selected source: [PROP-003_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-003/source_images/PROP-003_prop_states_original.png)
  <!-- phase06-record:PROP-003:end -->
- [x] PROP-004 — Wooden crate
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-004:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-004/previews)
  - Selected source: [PROP-004_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-004/source_images/PROP-004_prop_states_original.png)
  <!-- phase06-record:PROP-004:end -->
- [x] PROP-005 — Barrel
  <!-- phase06-record:PROP-005:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-005/previews)
  - Selected source: [PROP-005_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-005/source_images/PROP-005_prop_states_original.png)
  <!-- phase06-record:PROP-005:end -->
- [x] PROP-006 — Rope bridge
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-006:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006/previews)
  - Selected source: [PROP-006_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006/source_images/PROP-006_prop_states_original.png)
  <!-- phase06-record:PROP-006:end -->
- [x] PROP-007 — Wooden ladder
  <!-- phase06-record:PROP-007:start -->
  - Production stage: reviewed prototype source and fixed cell exports. Final production approval pending.
  - Saved folder: [PROP-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-007/previews)
  - Selected source: [PROP-007_prop_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-007/source_images/PROP-007_prop_states_original.png)
  <!-- phase06-record:PROP-007:end -->
- [x] PROP-008 — Rope and chain
  <!-- phase06-record:PROP-008:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-008/previews)
  - Selected source: [PROP-008_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-008/source_images/PROP-008_sheet_original.png)
  <!-- phase06-record:PROP-008:end -->
- [x] PROP-009 — Wooden door
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-009:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-009/previews)
  - Selected source: [PROP-009_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-009/source_images/PROP-009_sheet_original.png)
  <!-- phase06-record:PROP-009:end -->
- [x] PROP-010 — Village window and roof components
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-010:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-010/previews)
  - Selected source: [PROP-010_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-010/source_images/PROP-010_sheet_original.png)
  <!-- phase06-record:PROP-010:end -->
- [x] PROP-011 — Bushes, flowers, and mushrooms
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-011:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011/previews)
  - Selected source: [PROP-011_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-011/source_images/PROP-011_sheet_original.png)
  <!-- phase06-record:PROP-011:end -->
- [x] PROP-012 — Small tree and root clusters
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase06-record:PROP-012:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012/previews)
  - Selected source: [PROP-012_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-012/source_images/PROP-012_sheet_original.png)
  <!-- phase06-record:PROP-012:end -->
- [x] PROP-013 — Broken cart and abandoned equipment
  <!-- phase06-record:PROP-013:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013/previews)
  - Selected source: [PROP-013_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013/source_images/PROP-013_sheet_original.png)
  - Selected source: [PROP-013_complete_cart_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-013/source_images/PROP-013_complete_cart_original.png)
  <!-- phase06-record:PROP-013:end -->
- [x] PROP-014 — Treasure chest
  <!-- phase06-record:PROP-014:start -->
  - Production stage: generated prop prototype saved and reviewed. Final production approval pending.
  - Saved folder: [PROP-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-014) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-014/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-014/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-014/previews)
  - Selected source: [PROP-014_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-014/source_images/PROP-014_sheet_original.png)
  <!-- phase06-record:PROP-014:end -->

## Gameplay objects

- [x] OBJ-001 — Checkpoint lantern
  <!-- phase06-record:OBJ-001:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-001/previews)
  - Selected source: [OBJ-001_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-001/source_images/OBJ-001_state_atlas_original.png)
  <!-- phase06-record:OBJ-001:end -->
- [x] OBJ-002 — Gold fragment collectible
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase06-record:OBJ-002:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-002/previews)
  - Selected source: [OBJ-002_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-002/source_images/OBJ-002_state_atlas_original.png)
  <!-- phase06-record:OBJ-002:end -->
- [x] OBJ-003 — Rune switch
  <!-- phase06-record:OBJ-003:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-003/previews)
  - Selected source: [OBJ-003_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-003/source_images/OBJ-003_state_atlas_original.png)
  <!-- phase06-record:OBJ-003:end -->
- [x] OBJ-004 — Rune-activated door
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase06-record:OBJ-004:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004/previews)
  - Selected source: [OBJ-004_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-004/source_images/OBJ-004_state_atlas_original.png)
  <!-- phase06-record:OBJ-004:end -->
- [x] OBJ-005 — Hidden-platform rune marker
  <!-- phase06-record:OBJ-005:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-005/previews)
  - Selected source: [OBJ-005_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-005/source_images/OBJ-005_state_atlas_original.png)
  <!-- phase06-record:OBJ-005:end -->
- [x] OBJ-006 — Moving platform art
  <!-- phase06-record:OBJ-006:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [OBJ-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-006/previews)
  - Selected source: [OBJ-006_state_atlas_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-006/source_images/OBJ-006_state_atlas_original.png)
  <!-- phase06-record:OBJ-006:end -->
- [x] OBJ-007 — Falling platform art
  <!-- phase06-record:OBJ-007:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-007/previews)
  - Selected source: [OBJ-007_falling_platform_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-007/source_images/OBJ-007_falling_platform_states_original.png)
  <!-- phase06-record:OBJ-007:end -->
- [x] OBJ-008 — Thorn hazard
  <!-- phase06-record:OBJ-008:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-008/previews)
  - Selected source: [OBJ-008_thorn_hazard_modules_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-008/source_images/OBJ-008_thorn_hazard_modules_original.png)
  <!-- phase06-record:OBJ-008:end -->
- [x] OBJ-009 — Spike hazard
  <!-- phase06-record:OBJ-009:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-009/previews)
  - Selected source: [OBJ-009_spike_hazard_modules_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-009/source_images/OBJ-009_spike_hazard_modules_original.png)
  <!-- phase06-record:OBJ-009:end -->
- [x] OBJ-010 — Breakable object
  <!-- phase06-record:OBJ-010:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-010/previews)
  - Selected source: [OBJ-010_breakable_vessel_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-010/source_images/OBJ-010_breakable_vessel_states_original.png)
  <!-- phase06-record:OBJ-010:end -->
- [x] OBJ-011 — Temple seal
  <!-- phase06-record:OBJ-011:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-011/previews)
  - Selected source: [OBJ-011_temple_seal_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-011/source_images/OBJ-011_temple_seal_states_original.png)
  <!-- phase06-record:OBJ-011:end -->
- [x] OBJ-012 — Level exit doorway or portal
  <!-- phase06-record:OBJ-012:start -->
  - Production stage: reviewed generated object art and state/module exports; registration and gameplay integration pending. Final production approval pending.
  - Saved folder: [OBJ-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-012/previews)
  - Selected source: [OBJ-012_exit_doorway_states_original_v2.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_06_props_and_interactive_objects/gameplay_objects/OBJ-012/source_images/OBJ-012_exit_doorway_states_original_v2.png)
  <!-- phase06-record:OBJ-012:end -->

# Phase 07 — Visual Effects

<!-- phase07-summary:start -->
**Reviewed procedural prototypes: 20/20.** [Asset index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/PHASE07_index.md). Checked items record saved and reviewed effect frame sheets, not final production approval. Each item has per-frame PNGs, a sheet, a frames.json with cell size, fps, loop and pivot, light/dark contact previews and an animated GIF. Effects are procedural (tools/fx_effects.py), not generated art. In-engine timing, blend modes, color review and runtime integration remain separate. No ZIP files or runtime integration added.
<!-- phase07-summary:end -->

- [x] FX-001 — Sword swing trail
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-001:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-001/previews)
  - Selected source: [FX-001_sword_swing_trail_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-001/source_images/FX-001_sword_swing_trail_procedural_sheet.png)
  <!-- phase07-record:FX-001:end -->
- [x] FX-002 — Sword impact sparks
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-002:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-002/previews)
  - Selected source: [FX-002_sword_impact_sparks_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-002/source_images/FX-002_sword_impact_sparks_procedural_sheet.png)
  <!-- phase07-record:FX-002:end -->
- [x] FX-003 — Enemy hit flash
  <!-- phase07-record:FX-003:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-003/previews)
  - Selected source: [FX-003_enemy_hit_flash_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-003/source_images/FX-003_enemy_hit_flash_procedural_sheet.png)
  <!-- phase07-record:FX-003:end -->
- [x] FX-004 — Enemy defeat particles
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-004:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-004/previews)
  - Selected source: [FX-004_enemy_defeat_particles_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-004/source_images/FX-004_enemy_defeat_particles_procedural_sheet.png)
  <!-- phase07-record:FX-004:end -->
- [x] FX-005 — Running dust
  <!-- phase07-record:FX-005:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-005/previews)
  - Selected source: [FX-005_running_dust_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-005/source_images/FX-005_running_dust_procedural_sheet.png)
  <!-- phase07-record:FX-005:end -->
- [x] FX-006 — Jump take-off puff
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-006:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-006/previews)
  - Selected source: [FX-006_jump_takeoff_puff_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-006/source_images/FX-006_jump_takeoff_puff_procedural_sheet.png)
  <!-- phase07-record:FX-006:end -->
- [x] FX-007 — Landing dust
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-007:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-007/previews)
  - Selected source: [FX-007_landing_dust_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-007/source_images/FX-007_landing_dust_procedural_sheet.png)
  <!-- phase07-record:FX-007:end -->
- [x] FX-008 — Falling debris
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-008:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-008/previews)
  - Selected source: [FX-008_falling_debris_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-008/source_images/FX-008_falling_debris_procedural_sheet.png)
  <!-- phase07-record:FX-008:end -->
- [x] FX-009 — Lantern light pulse
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-009:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-009/previews)
  - Selected source: [FX-009_lantern_light_pulse_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-009/source_images/FX-009_lantern_light_pulse_procedural_sheet.png)
  <!-- phase07-record:FX-009:end -->
- [x] FX-010 — Mote glow
  <!-- phase07-record:FX-010:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-010/previews)
  - Selected source: [FX-010_mote_glow_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-010/source_images/FX-010_mote_glow_procedural_sheet.png)
  <!-- phase07-record:FX-010:end -->
- [x] FX-011 — Rune activation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-011:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-011/previews)
  - Selected source: [FX-011_rune_activation_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-011/source_images/FX-011_rune_activation_procedural_sheet.png)
  <!-- phase07-record:FX-011:end -->
- [x] FX-012 — Hidden-platform reveal
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-012:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-012/previews)
  - Selected source: [FX-012_hidden_platform_reveal_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-012/source_images/FX-012_hidden_platform_reveal_procedural_sheet.png)
  <!-- phase07-record:FX-012:end -->
- [x] FX-013 — Collectible pickup
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-013:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-013) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-013/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-013/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-013/previews)
  - Selected source: [FX-013_collectible_pickup_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-013/source_images/FX-013_collectible_pickup_procedural_sheet.png)
  <!-- phase07-record:FX-013:end -->
- [x] FX-014 — Checkpoint activation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-014:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-014) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-014/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-014/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-014/previews)
  - Selected source: [FX-014_checkpoint_activation_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-014/source_images/FX-014_checkpoint_activation_procedural_sheet.png)
  <!-- phase07-record:FX-014:end -->
- [x] FX-015 — Boss ground impact
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-015:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-015) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-015/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-015/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-015/previews)
  - Selected source: [FX-015_boss_ground_impact_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-015/source_images/FX-015_boss_ground_impact_procedural_sheet.png)
  <!-- phase07-record:FX-015:end -->
- [x] FX-016 — Boss core energy
  <!-- phase07-record:FX-016:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-016) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-016/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-016/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-016/previews)
  - Selected source: [FX-016_boss_core_energy_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-016/source_images/FX-016_boss_core_energy_procedural_sheet.png)
  <!-- phase07-record:FX-016:end -->
- [x] FX-017 — Boss phase transition
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase07-record:FX-017:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-017) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-017/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-017/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-017/previews)
  - Selected source: [FX-017_boss_phase_transition_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-017/source_images/FX-017_boss_phase_transition_procedural_sheet.png)
  <!-- phase07-record:FX-017:end -->
- [x] FX-018 — Death and respawn effects
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase07-record:FX-018:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-018](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-018) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-018/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-018/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-018/previews)
  - Selected source: [FX-018_death_respawn_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-018/source_images/FX-018_death_respawn_procedural_sheet.png)
  <!-- phase07-record:FX-018:end -->
- [x] FX-019 — Water ripples and splashes
  <!-- phase07-record:FX-019:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-019](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-019) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-019/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-019/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-019/previews)
  - Selected source: [FX-019_water_ripples_splashes_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-019/source_images/FX-019_water_ripples_splashes_procedural_sheet.png)
  <!-- phase07-record:FX-019:end -->
- [x] FX-020 — Magic projectile
  <!-- phase07-record:FX-020:start -->
  - Production stage: procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending. Final production approval pending.
  - Saved folder: [FX-020](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-020) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-020/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-020/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-020/previews)
  - Selected source: [FX-020_magic_projectile_procedural_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_07_visual_effects/FX-020/source_images/FX-020_magic_projectile_procedural_sheet.png)
  <!-- phase07-record:FX-020:end -->

# Phase 08 — User Interface

<!-- phase08-summary:start -->
**Reviewed prototype packs: 25/25.** [Asset and prompt index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/PHASE08_index.md). Checked items record saved and reviewed UI art/component prototypes, not final production approval. Sources, state/module exports, prompts, crop maps and checker previews are recorded per item. Responsive layout, focus/input navigation, text/localization, accessibility and Godot integration require separate validation. No ZIP files or runtime integration added.
<!-- phase08-summary:end -->

## HUD elements

- [x] UI-001 — Health indicators
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-001:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-001/previews)
  - Selected source: [UI-001_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-001/source_images/UI-001_ui_components_original.png)
  <!-- phase08-record:UI-001:end -->
- [x] UI-002 — Health bar frame
  <!-- phase08-record:UI-002:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-002/previews)
  - Selected source: [UI-002_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-002/source_images/UI-002_ui_components_original.png)
  <!-- phase08-record:UI-002:end -->
- [x] UI-003 — Collectible icon
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase08-record:UI-003:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-003/previews)
  - Selected source: [UI-003_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-003/source_images/UI-003_ui_components_original.png)
  <!-- phase08-record:UI-003:end -->
- [x] UI-004 — Objective banner
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase08-record:UI-004:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/previews)
  - Selected source: [UI-004_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/source_images/UI-004_ui_components_original.png)
  <!-- phase08-record:UI-004:end -->
- [x] UI-005 — Interaction prompt
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase08-record:UI-005:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-005/previews)
  - Selected source: [UI-005_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-005/source_images/UI-005_ui_components_original.png)
  <!-- phase08-record:UI-005:end -->
- [x] UI-006 — Checkpoint icon
  <!-- phase08-record:UI-006:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-006/previews)
  - Selected source: [UI-006_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-006/source_images/UI-006_ui_components_original.png)
  <!-- phase08-record:UI-006:end -->
- [x] UI-007 — Treasure indicator
  <!-- phase08-record:UI-007:start -->
  - Production stage: reviewed prototype components and fixed cell exports. Final production approval pending.
  - Saved folder: [UI-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-007/previews)
  - Selected source: [UI-007_ui_components_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-007/source_images/UI-007_ui_components_original.png)
  <!-- phase08-record:UI-007:end -->
- [x] UI-008 — Boss health bar
  - Encounter HUD revision (2026-10-20): text-free Sentinel portrait frame with separate live title/health overlays. Unchanged [source](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/source_images/UI-008_sentinel_portrait_bar_generation_02.png), mechanical alpha-cropped [export](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/exports/UI-008_sentinel_portrait_frame_02.png), [runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/manifest.json). Prior generations preserved; runtime/device and final production approval remain separate.
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase08-record:UI-008:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/previews)
  - Selected source: [UI-008_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-008/source_images/UI-008_sheet_original.png)
  <!-- phase08-record:UI-008:end -->
- [x] UI-009 — Dialogue panel
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-009:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/previews)
  - Selected source: [UI-009_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/source_images/UI-009_sheet_original.png)
  - Memory popup reference update (2026-10-20): [generation 02](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/source_images/UI-009_memory_popup_generation_02.png) · [frame export](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/exports/UI-009_memory_popup_frame_02.png) · [runtime popup](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/UI-009_memory_popup.png) · [manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/manifest.json). Original generation preserved; unchanged generated frame has a transparent image window and separate runtime text/buttons. Runtime layout review in progress; final production approval remains pending.
  <!-- phase08-record:UI-009:end -->
  <!-- botanical-dialogue-generation03:start -->
  - Botanical dialogue frame generation 03: unchanged generated source 2172 × 724; mechanical alpha-bounds export 2145 × 688. [Source](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/source_images/UI-009_botanical_dialogue_generation_03.png) · [Runtime](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/UI-009_botanical_dialogue.png) · [Metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-009/metadata.json). Shared popup frame with live engine text/nameplate/Continue control; runtime review and final production approval remain separate. Earlier assets and checkboxes preserved.
  <!-- botanical-dialogue-generation03:end -->
- [x] UI-010 — Dialogue portrait frames
  <!-- phase08-record:UI-010:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-010/previews)
  - Selected source: [UI-010_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-010/source_images/UI-010_sheet_original.png)
  <!-- phase08-record:UI-010:end -->
- [x] UI-011 — Pause icon
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-011:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-011/previews)
  - Selected source: [UI-011_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-011/source_images/UI-011_sheet_original.png)
  <!-- phase08-record:UI-011:end -->
- [x] UI-012 — Settings icon
  <!-- phase08-record:UI-012:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-012/previews)
  - Selected source: [UI-012_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-012/source_images/UI-012_sheet_original.png)
  <!-- phase08-record:UI-012:end -->
- [x] UI-013 — Touch movement controls
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-013:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-013) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-013/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-013/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-013/previews)
  - Selected source: [UI-013_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-013/source_images/UI-013_sheet_original.png)
  <!-- phase08-record:UI-013:end -->
- [x] UI-014 — Touch jump button
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-014:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-014) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-014/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-014/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-014/previews)
  - Selected source: [UI-014_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-014/source_images/UI-014_sheet_original.png)
  <!-- phase08-record:UI-014:end -->
- [x] UI-015 — Touch attack button
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-015:start -->
  - Production stage: generated ui prototype saved and reviewed. Final production approval pending.
  - Saved folder: [UI-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-015) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-015/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-015/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-015/previews)
  - Selected source: [UI-015_sheet_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-015/source_images/UI-015_sheet_original.png)
  <!-- phase08-record:UI-015:end -->

## Menus and screens

- [x] UI-016 — Main menu background
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-016:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [UI-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016/previews)
  - Selected source: [UI-016_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016/source_images/UI-016_original.png)
  <!-- phase08-record:UI-016:end -->
  <!-- exact-title-menu-reference:start -->
  - Exact title menu: user-supplied artwork preserved unchanged at 1672 × 941; interactive Godot overlay integration pending runtime review. [Source](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-016/source_images/UI-016_user_title_reference_02.png) · [Runtime](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/UI-016_exact_title_menu.png) · [Manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/manifest.json). Existing generated sources and checkboxes are preserved; no final production/release approval implied.
  <!-- exact-title-menu-reference:end -->
- [x] UI-017 — Game logo
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-017:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [UI-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-017) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-017/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-017/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-017/previews)
  - Selected source: [UI-017_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-017/source_images/UI-017_original.png)
  <!-- phase08-record:UI-017:end -->
- [x] UI-018 — Main menu buttons
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-018:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [UI-018](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-018) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-018/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-018/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-018/previews)
  - Selected source: [UI-018_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-018/source_images/UI-018_original.png)
  <!-- phase08-record:UI-018:end -->
- [x] UI-019 — Pause menu
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase08-record:UI-019:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [UI-019](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-019) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-019/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-019/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-019/previews)
  - Selected source: [UI-019_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-019/source_images/UI-019_original.png)
  <!-- phase08-record:UI-019:end -->
- [x] UI-020 — Settings screen
  <!-- phase08-record:UI-020:start -->
  - Production stage: generated prototype reviewed exported. Final production approval pending.
  - Saved folder: [UI-020](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-020) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-020/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-020/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-020/previews)
  - Selected source: [UI-020_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-020/source_images/UI-020_original.png)
  <!-- phase08-record:UI-020:end -->
- [x] UI-021 — Loading screen
  <!-- phase08-record:UI-021:start -->
  - Production stage: reviewed UI texture/component prototypes and separate data layout; Godot implementation pending. Final production approval pending.
  - Saved folder: [UI-021](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-021) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-021/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-021/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-021/previews)
  - Selected source: [UI-021_loading_background_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-021/source_images/UI-021_loading_background_original.png)
  <!-- phase08-record:UI-021:end -->
- [x] UI-022 — Game-over panel
  <!-- phase08-record:UI-022:start -->
  - Production stage: reviewed UI texture/component prototypes and separate data layout; Godot implementation pending. Final production approval pending.
  - Saved folder: [UI-022](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-022) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-022/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-022/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-022/previews)
  - Selected source: [UI-022_game_over_panel_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-022/source_images/UI-022_game_over_panel_original.png)
  <!-- phase08-record:UI-022:end -->
- [x] UI-023 — Level-complete panel
  <!-- phase08-record:UI-023:start -->
  - Production stage: reviewed UI texture/component prototypes and separate data layout; Godot implementation pending. Final production approval pending.
  - Saved folder: [UI-023](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023/previews)
  - Selected source: [UI-023_level_complete_panel_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023/source_images/UI-023_level_complete_panel_original.png)
  - Chapter 1 reference update: [generation 02](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-023/source_images/UI-023_completion_reference_generation_02.png) · [runtime popup](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/UI-023_completion_popup.png) · [manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/ui/manifest.json). Original generation preserved; exported without resizing; text and controls are separate Godot overlays. Runtime review in progress; final production approval remains pending.
  <!-- phase08-record:UI-023:end -->
- [x] UI-024 — Save/checkpoint indicator
  <!-- phase08-record:UI-024:start -->
  - Production stage: reviewed UI texture/component prototypes and separate data layout; Godot implementation pending. Final production approval pending.
  - Saved folder: [UI-024](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-024) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-024/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-024/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-024/previews)
  - Selected source: [UI-024_save_indicator_states_original.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-024/source_images/UI-024_save_indicator_states_original.png)
  <!-- phase08-record:UI-024:end -->
- [x] UI-025 — Controller and keyboard prompts
  - Reference jungle revision: source-preserving modules and high-resolution runtime exports; reviewed in Godot, final approval pending. [Revision metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025/metadata.json) · [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/reference_jungle/manifest.json).
  <!-- phase08-record:UI-025:start -->
  - Production stage: reviewed editable input glyphs, raster exports and current-binding map. Final production approval pending.
  - Saved folder: [UI-025](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025/previews)
  - Selected source: [UI-025_prompt_atlas.svg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/menus_and_screens/UI-025/source_images/UI-025_prompt_atlas.svg)
  <!-- phase08-record:UI-025:end -->

# Phase 09 — Audio Asset Inventory

<!-- phase09-summary:start -->
**Reviewed procedural prototypes: 34/34.** [Asset index](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/PHASE09_index.md). Checked items record saved audio exports with level, loudness, clipping and loop-seam measurements and a spectrogram preview, not final production approval. Audio is synthesized from code (tools/audiolib.py, aud_sfx.py, aud_amb.py, aud_music.py), was not auditioned by ear, and music tracks are placeholder-grade. Listening review, mix balance and runtime integration remain separate. No ZIP files or runtime integration added.
<!-- phase09-summary:end -->

## Sound effects

- [x] AUD-SFX-001 — Running on grass
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-001:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001/previews)
  - Selected audio: [AUD-SFX-001_running_on_grass_step_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001/exports/AUD-SFX-001_running_on_grass_step_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-001/previews/AUD-SFX-001_spectrogram.png)
  <!-- phase09-record:AUD-SFX-001:end -->
- [x] AUD-SFX-002 — Running on stone
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-002:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002/previews)
  - Selected audio: [AUD-SFX-002_running_on_stone_step_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002/exports/AUD-SFX-002_running_on_stone_step_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-002/previews/AUD-SFX-002_spectrogram.png)
  <!-- phase09-record:AUD-SFX-002:end -->
- [x] AUD-SFX-003 — Jump
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-003:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003/previews)
  - Selected audio: [AUD-SFX-003_jump.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003/exports/AUD-SFX-003_jump.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-003/previews/AUD-SFX-003_spectrogram.png)
  <!-- phase09-record:AUD-SFX-003:end -->
- [x] AUD-SFX-004 — Landing
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-004:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004/previews)
  - Selected audio: [AUD-SFX-004_landing_soft.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004/exports/AUD-SFX-004_landing_soft.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-004/previews/AUD-SFX-004_spectrogram.png)
  <!-- phase09-record:AUD-SFX-004:end -->
- [x] AUD-SFX-005 — Sword swing
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-005:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005/previews)
  - Selected audio: [AUD-SFX-005_sword_swing_swing_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005/exports/AUD-SFX-005_sword_swing_swing_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-005/previews/AUD-SFX-005_spectrogram.png)
  <!-- phase09-record:AUD-SFX-005:end -->
- [x] AUD-SFX-006 — Sword impact
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-006:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006/previews)
  - Selected audio: [AUD-SFX-006_sword_impact_impact_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006/exports/AUD-SFX-006_sword_impact_impact_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-006/previews/AUD-SFX-006_spectrogram.png)
  <!-- phase09-record:AUD-SFX-006:end -->
- [x] AUD-SFX-007 — Enemy attack
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-007:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007/previews)
  - Selected audio: [AUD-SFX-007_enemy_attack_attack_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007/exports/AUD-SFX-007_enemy_attack_attack_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-007/previews/AUD-SFX-007_spectrogram.png)
  <!-- phase09-record:AUD-SFX-007:end -->
- [x] AUD-SFX-008 — Enemy defeat
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-008:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008/previews)
  - Selected audio: [AUD-SFX-008_enemy_defeat.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008/exports/AUD-SFX-008_enemy_defeat.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-008/previews/AUD-SFX-008_spectrogram.png)
  <!-- phase09-record:AUD-SFX-008:end -->
- [x] AUD-SFX-009 — Player hurt
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-009:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009/previews)
  - Selected audio: [AUD-SFX-009_player_hurt_hurt_1.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009/exports/AUD-SFX-009_player_hurt_hurt_1.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-009/previews/AUD-SFX-009_spectrogram.png)
  <!-- phase09-record:AUD-SFX-009:end -->
- [x] AUD-SFX-010 — Chest opening
  <!-- phase09-record:AUD-SFX-010:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010/previews)
  - Selected audio: [AUD-SFX-010_chest_opening.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010/exports/AUD-SFX-010_chest_opening.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-010/previews/AUD-SFX-010_spectrogram.png)
  <!-- phase09-record:AUD-SFX-010:end -->
- [x] AUD-SFX-011 — Collectible pickup
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-011:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011/previews)
  - Selected audio: [AUD-SFX-011_collectible_pickup.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011/exports/AUD-SFX-011_collectible_pickup.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-011/previews/AUD-SFX-011_spectrogram.png)
  <!-- phase09-record:AUD-SFX-011:end -->
- [x] AUD-SFX-012 — Rune activation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-012:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012/previews)
  - Selected audio: [AUD-SFX-012_rune_activation.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012/exports/AUD-SFX-012_rune_activation.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-012/previews/AUD-SFX-012_spectrogram.png)
  <!-- phase09-record:AUD-SFX-012:end -->
- [x] AUD-SFX-013 — Checkpoint activation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-013:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013/previews)
  - Selected audio: [AUD-SFX-013_checkpoint_activation.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013/exports/AUD-SFX-013_checkpoint_activation.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-013/previews/AUD-SFX-013_spectrogram.png)
  <!-- phase09-record:AUD-SFX-013:end -->
- [x] AUD-SFX-014 — Door opening
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-014:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014/previews)
  - Selected audio: [AUD-SFX-014_door_opening.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014/exports/AUD-SFX-014_door_opening.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-014/previews/AUD-SFX-014_spectrogram.png)
  <!-- phase09-record:AUD-SFX-014:end -->
- [x] AUD-SFX-015 — Boss attack set
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-015:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015/previews)
  - Selected audio: [AUD-SFX-015_boss_attack_set_slam.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015/exports/AUD-SFX-015_boss_attack_set_slam.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-015/previews/AUD-SFX-015_spectrogram.png)
  <!-- phase09-record:AUD-SFX-015:end -->
- [x] AUD-SFX-016 — Boss damage
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-016:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-016](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016/previews)
  - Selected audio: [AUD-SFX-016_boss_damage.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016/exports/AUD-SFX-016_boss_damage.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-016/previews/AUD-SFX-016_spectrogram.png)
  <!-- phase09-record:AUD-SFX-016:end -->
- [x] AUD-SFX-017 — Boss defeat
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-SFX-017:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-017](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017/previews)
  - Selected audio: [AUD-SFX-017_boss_defeat.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017/exports/AUD-SFX-017_boss_defeat.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-017/previews/AUD-SFX-017_spectrogram.png)
  <!-- phase09-record:AUD-SFX-017:end -->
- [x] AUD-SFX-018 — UI selection and confirmation
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-SFX-018:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-SFX-018](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018/previews)
  - Selected audio: [AUD-SFX-018_ui_selection_and_confirmation_select.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018/exports/AUD-SFX-018_ui_selection_and_confirmation_select.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/sound_effects/AUD-SFX-018/previews/AUD-SFX-018_spectrogram.png)
  <!-- phase09-record:AUD-SFX-018:end -->

## Ambient soundscapes

- [x] AUD-AMB-001 — Brackenreach night
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-AMB-001:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001/previews)
  - Selected audio: [AUD-AMB-001_brackenreach_night.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001/exports/AUD-AMB-001_brackenreach_night.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-001/previews/AUD-AMB-001_spectrogram.png)
  <!-- phase09-record:AUD-AMB-001:end -->
- [x] AUD-AMB-002 — Village ambience
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-AMB-002:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002/previews)
  - Selected audio: [AUD-AMB-002_village_ambience.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002/exports/AUD-AMB-002_village_ambience.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-002/previews/AUD-AMB-002_spectrogram.png)
  <!-- phase09-record:AUD-AMB-002:end -->
- [x] AUD-AMB-003 — Forest birds and wind
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-AMB-003:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003/previews)
  - Selected audio: [AUD-AMB-003_forest_birds_and_wind.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003/exports/AUD-AMB-003_forest_birds_and_wind.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-003/previews/AUD-AMB-003_spectrogram.png)
  <!-- phase09-record:AUD-AMB-003:end -->
- [x] AUD-AMB-004 — Cave drips
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-AMB-004:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004/previews)
  - Selected audio: [AUD-AMB-004_cave_drips.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004/exports/AUD-AMB-004_cave_drips.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-004/previews/AUD-AMB-004_spectrogram.png)
  <!-- phase09-record:AUD-AMB-004:end -->
- [x] AUD-AMB-005 — Underground rumble
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-AMB-005:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005/previews)
  - Selected audio: [AUD-AMB-005_underground_rumble.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005/exports/AUD-AMB-005_underground_rumble.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-005/previews/AUD-AMB-005_spectrogram.png)
  <!-- phase09-record:AUD-AMB-005:end -->
- [x] AUD-AMB-006 — Glasswater Fen water
  <!-- phase09-record:AUD-AMB-006:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006/previews)
  - Selected audio: [AUD-AMB-006_glasswater_fen_water.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006/exports/AUD-AMB-006_glasswater_fen_water.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-006/previews/AUD-AMB-006_spectrogram.png)
  <!-- phase09-record:AUD-AMB-006:end -->
- [x] AUD-AMB-007 — Bellows Gorge bells
  <!-- phase09-record:AUD-AMB-007:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007/previews)
  - Selected audio: [AUD-AMB-007_bellows_gorge_bells.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007/exports/AUD-AMB-007_bellows_gorge_bells.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-007/previews/AUD-AMB-007_spectrogram.png)
  <!-- phase09-record:AUD-AMB-007:end -->
- [x] AUD-AMB-008 — Quiet Crown ambience
  <!-- phase09-record:AUD-AMB-008:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-AMB-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008/previews)
  - Selected audio: [AUD-AMB-008_quiet_crown_ambience.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008/exports/AUD-AMB-008_quiet_crown_ambience.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/ambient_soundscapes/AUD-AMB-008/previews/AUD-AMB-008_spectrogram.png)
  <!-- phase09-record:AUD-AMB-008:end -->

## Music

- [x] AUD-MUS-001 — Main theme
  <!-- phase09-record:AUD-MUS-001:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001/previews)
  - Selected audio: [AUD-MUS-001_main_theme.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001/exports/AUD-MUS-001_main_theme.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-001/previews/AUD-MUS-001_spectrogram.png)
  <!-- phase09-record:AUD-MUS-001:end -->
- [x] AUD-MUS-002 — Village theme
  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json).
  <!-- phase09-record:AUD-MUS-002:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002/previews)
  - Selected audio: [AUD-MUS-002_village_theme.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002/exports/AUD-MUS-002_village_theme.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-002/previews/AUD-MUS-002_spectrogram.png)
  <!-- phase09-record:AUD-MUS-002:end -->
- [x] AUD-MUS-003 — Forest exploration
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-MUS-003:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003/previews)
  - Selected audio: [AUD-MUS-003_forest_exploration.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003/exports/AUD-MUS-003_forest_exploration.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-003/previews/AUD-MUS-003_spectrogram.png)
  <!-- phase09-record:AUD-MUS-003:end -->
- [x] AUD-MUS-004 — Temple exploration
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-MUS-004:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004/previews)
  - Selected audio: [AUD-MUS-004_temple_exploration.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004/exports/AUD-MUS-004_temple_exploration.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-004/previews/AUD-MUS-004_spectrogram.png)
  <!-- phase09-record:AUD-MUS-004:end -->
- [x] AUD-MUS-005 — Boss battle
  - Chapter 1 runtime: Selected exports integrated into Chapter 1; original sources preserved, full-pack/device/listening approval pending. [Source/runtime record](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json).
  <!-- phase09-record:AUD-MUS-005:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005/previews)
  - Selected audio: [AUD-MUS-005_boss_battle.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005/exports/AUD-MUS-005_boss_battle.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-005/previews/AUD-MUS-005_spectrogram.png)
  <!-- phase09-record:AUD-MUS-005:end -->
- [x] AUD-MUS-006 — Stillmere theme
  <!-- phase09-record:AUD-MUS-006:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-006](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006/previews)
  - Selected audio: [AUD-MUS-006_stillmere_theme.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006/exports/AUD-MUS-006_stillmere_theme.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-006/previews/AUD-MUS-006_spectrogram.png)
  <!-- phase09-record:AUD-MUS-006:end -->
- [x] AUD-MUS-007 — Final boss theme
  <!-- phase09-record:AUD-MUS-007:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-007](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007/previews)
  - Selected audio: [AUD-MUS-007_final_boss_theme.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007/exports/AUD-MUS-007_final_boss_theme.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-007/previews/AUD-MUS-007_spectrogram.png)
  <!-- phase09-record:AUD-MUS-007:end -->
- [x] AUD-MUS-008 — Ending theme
  <!-- phase09-record:AUD-MUS-008:start -->
  - Production stage: procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending. Final production approval pending.
  - Saved folder: [AUD-MUS-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008) · [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008/metadata.json) · [exports](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008/exports) · [previews](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008/previews)
  - Selected audio: [AUD-MUS-008_ending_theme.ogg](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008/exports/AUD-MUS-008_ending_theme.ogg) · [spectrogram](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_09_audio_asset_inventory/music/AUD-MUS-008/previews/AUD-MUS-008_spectrogram.png)
  <!-- phase09-record:AUD-MUS-008:end -->

# Phase 10 — Later Campaign-Specific Assets

- [ ] LATE-001 — Briarwake orchard pack, Mossjaw, and root-stone
  <!-- chapter02-LATE-001:start -->
  - Production stage (2026-10-24): illustrated Mossjaw six-pose set created with built-in image_gen and integrated into Chapter 2; full pack, full animation set and final art approval pending. Checkbox preserved.
  - Saved folder: [LATE-001](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/metadata.json) · [generation prompts](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/LATE-001_generation_prompts.json)
  - Sources: [generation 01, crowded layout archived](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/source_images/LATE-001_mossjaw_generation_01.png) · [generation 02, selected](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/source_images/LATE-001_mossjaw_generation_02.png) · [alpha review](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/previews/LATE-001_mossjaw_alpha_review.jpg)
  - Runtime: [frames and timing manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter02/mossjaw/manifest.json) · [chapter implementation and limitations](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-implementation.md) · [rendered guardian](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-mossjaw-preview.png)
  - Expansion (2026-10-24): three generated enemy variants, two underground background scenes, nine additional Mossjaw attack poses, root/seed hazards, four mandatory jungle missions and Chapter 1 presentation/rewards integrated. Full-pack approval remains pending.
  - Expansion records: [metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/LATE-001_expansion_metadata.json) · [prompts](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_10_later_campaign_specific_assets/LATE-001/LATE-001_expansion_prompts.json) · [implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-expansion.md) · [asset manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-expansion-assets.json) · [underground preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-expansion/03-jungle-3.png) · [boss HUD and attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter02-expansion/04-mossjaw-eruption.png)
  <!-- chapter02-LATE-001:end -->
- [ ] LATE-002 — Glasswater Fen reflections, Borrowed Faces, and Glass Stag
- [ ] LATE-003 — Bellows Gorge architecture, bells, Bellows Titan, and Sable
- [ ] LATE-004 — Underground Archive documents, machinery, and buried village
- [ ] LATE-005 — Root Cathedral living-root architecture and Keeper mechanisms
- [ ] LATE-006 — Stillmere frozen villagers and memory effects
- [ ] LATE-007 — Quiet Crown forms and final boss effects
- [ ] LATE-008 — Restored Brackenreach and newly opened forest paths

# Phase 11 — Release Assets

- [ ] RELEASE-001 — App icon
- [ ] RELEASE-002 — PC game capsule image
- [ ] RELEASE-003 — Store screenshots
- [ ] RELEASE-004 — Promotional key art
- [ ] RELEASE-005 — Loading-screen illustrations
- [ ] RELEASE-006 — Credits screen
- [ ] RELEASE-007 — Accessibility and control icon set

---

# Recommended Production Order

1. [ ] ART-001 to ART-006 — Art foundation
2. [ ] TAVI-001 to TAVI-004 — Approve Tavi's design and scale
3. [ ] TAVI-010 to TAVI-018 — Create core movement and combat animations
4. [ ] MOTE-001 to MOTE-006 — Companion design and initial animations
5. [ ] TILE-001 to TILE-006 — First reusable terrain set
6. [ ] ENV-02 — Forgotten Trail greybox art and background layers
7. [ ] EN-001 to EN-006 — Rootling
8. [ ] OBJ-001 to OBJ-005 — Checkpoint, collectible, and rune puzzle objects
9. [ ] ENV-03 — Ancient Root-Temple
10. [ ] BOSS-001 to BOSS-010 — Hollow Sentinel
11. [ ] FX-001 to FX-014 — Core gameplay visual effects
12. [ ] UI-001 to UI-015 — HUD and touch controls
13. [ ] ENV-01 — Brackenreach village and prologue details
14. [ ] Audio assets needed for the vertical slice
15. [ ] Remaining campaign, menus, polish, and release assets

# Asset Completion Record

For each item, record its production state:

- [ ] Not started
- [ ] Concept generated
- [ ] Design approved
- [ ] Cleaned and exported
- [ ] Imported into Godot
- [ ] Tested in game
- [ ] Final approved

**Rule:** An asset is not production-ready just because a concept image has been generated. It is production-ready only when the required files are clean, consistent, correctly exported, and tested in the game.

## Prologue runtime integration — 2026-10-18

Selected generated village/terrain/bridge, Mote/Rootling animations, UI, FX and audio exports are integrated into the playable opening. Supporting Rusk/villager sprites were added to ENV-01. Original source images and existing checkboxes are preserved. See [implementation and release checklist](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-implementation.md) and [source/runtime hashes](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/prologue-asset-integration.json). Device testing and audio listening approval remain pending; asset checks do not assert release approval.

## Chapter 1 runtime integration — 2026-10-18

The Forgotten Trail connects the forest route, optional watchpost token, visual rune sequence, permanent revealed crossing, root-temple checkpoint, Hollow Sentinel and Golden Fragment memory. Selected generated exports and existing Tavi/Mote/Rootling/UI assets are used in the playable chapter. Prepared unused variants are explicitly labeled; existing checkboxes are unchanged. See [source/runtime hashes](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-asset-integration.json) and [implementation and release checks](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-implementation.md). Physical-device, listening and release approval remain pending.

## Chapter 1 exploration enemy integration — 2026-10-20

Sporeling and Brambleguard exports EN-012, EN-013, EN-014, EN-016, EN-017 and EN-018 now have 60 runtime frames prepared for expanded jungle encounters, including idle/move/attack/hurt/defeat animations. Sources and runtime hashes were verified. Original images, existing asset stages and checkboxes remain unchanged; integration does not imply final production or physical-device approval. See [expansion source/runtime records](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-expansion-assets.json).

## Chapter 1 mandatory route and combat reward update — 2026-10-20

High Canopy, Flooded Rootways and Lantern Grove form the expanded mandatory jungle route, with route puzzles and automatic transitions. The Hollow Sentinel combat update adds revival and an aggressive second life; clearing the encounter unlocks a chest reward, alongside animated points for puzzles and enemy defeats. Selected existing PROP-014 chest states are mechanically cropped runtime derivatives; originals, existing checkboxes and production approvals are preserved. See [combat, route and validation notes](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-combat-route-update.md), [chest runtime manifest](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/chapter01/rewards/manifest.json) and [source/runtime hashes](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-rewards-assets.json). Physical-device and release approval remain separate.

## Real-time lighting and completion popup runtime review

The UI-023 reference-style completion popup is integrated with live text and Replay input. Real Godot lights, regional ambient changes and terrain/actor shadows now run across the village, forest, temple and jungles. All275 source-project checks pass; final device/art/performance approval remains pending. See [implementation and validation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/dynamic-lighting-and-popup.md). Existing asset checkboxes are preserved.

## Reference memory popup — runtime review

UI-009 generation02 is integrated with the ENV-04 orchard layers, live parchment dialogue and Continue input. Native Godot placement was visually reviewed;12 focused interaction/layout checks pass. Original generations and approval checkboxes are preserved. See [runtime preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-memory-preview.png) and [implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/dynamic-lighting-and-popup.md). Final device/art approval remains separate.

## Sentinel scene style — runtime review

The revised UI-008 portrait frame is integrated with live health and phase text. Serif objective, botanical notice, hearts and points panels accompany warmer lantern-aligned dynamic lighting. All304 source-project checks pass; final device/art approval remains separate. See [native scene preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/chapter01-encounter-style-preview.png) and [implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/encounter-style-and-lighting.md). Existing checkboxes and earlier exports are preserved.

## Exact title and botanical dialogue — runtime review

The supplied UI-016 title reference is used unchanged with live Begin Chapter1 and Replay controls and restrained runtime lantern lights. UI-009 generation03 styles regular dialogue with separate speaker/body text and Continue input; pause/settings typography and buttons are harmonized. Native placement and actual input were reviewed, and all344 source-project checks pass. Existing checkboxes, older artwork and final approval flags are preserved. See [title and dialogue implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/exact-title-and-botanical-dialogue.md).

## Modular live HUD — 2026-10-21

UI-004 generation02 now supplies a compact nine-slice gold/teal frame, nine archived corner/edge/center exports and a separate botanical notice medallion. Live points, objectives, notices, hearts, vitality and reward prompts use content-sized containers; UI-003 crystal and existing life/pause/health exports remain separate. Original references and generated sources are preserved. 44 focused checks pass and native Godot placement was visually reviewed. Existing checkboxes and final approval flags are preserved. [Metadata](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_08_user_interface/hud_elements/UI-004/metadata.json) · [Runtime assets](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/runtime/shared/ui) · [Preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/dynamic-hud-preview.png) · [Implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/dynamic-hud.md).

## HUD scope correction — 2026-10-21

The player heart list and health bar are restored to their prior artwork, sizing, position, and numeric styling. The modular panel update applies to content lists, points and reward prompts. Top-left guidance still auto-hides after five seconds. Existing asset originals and checkboxes remain unchanged.

## High-resolution reference jungle and real-time lighting — 2026-10-21

The main forest and all three jungle rooms now use source-palette modular vegetation, supported treehouses/arches, waterfalls and capped terrain. Five new high-resolution generations replace magnified thumbnail scenery; original sources and earlier exports are preserved. Original player health UI stays unchanged; supplied guidance and keycaps retain live text. Native on/off frames verify dynamic world illumination. The lighting skill is installed and project memory updated. Existing checkboxes and final approvals remain unchanged. [Implementation](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/reference-jungle-and-lighting.md) · [Preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/reference-jungle-0-preview.png) · [Lighting proof](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/reference-lighting-render-proof.json) · [Persistent memory](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/docs/project-memory.md).
