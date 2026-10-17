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
  - Saved folder: [TAVI-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010)
  - Image: [TAVI-010_idle_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/TAVI-010_idle_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/previews/TAVI-010_idle_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-010/metadata.json)
- [x] TAVI-011 — Run
  - Saved folder: [TAVI-011](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011)
  - Image: [TAVI-011_run_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/TAVI-011_run_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/previews/TAVI-011_run_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-011/metadata.json)
- [x] TAVI-012 — Jump start
  - Saved folder: [TAVI-012](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012)
  - Image: [TAVI-012_jump_start_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/TAVI-012_jump_start_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/previews/TAVI-012_jump_start_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-012/metadata.json)
- [x] TAVI-013 — Rising jump
  - Saved folder: [TAVI-013](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013)
  - Image: [TAVI-013_jump_rise_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/TAVI-013_jump_rise_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/previews/TAVI-013_jump_rise_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-013/metadata.json)
- [x] TAVI-014 — Falling
  - Saved folder: [TAVI-014](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014)
  - Image: [TAVI-014_jump_fall_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/TAVI-014_jump_fall_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/previews/TAVI-014_jump_fall_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-014/metadata.json)
- [x] TAVI-015 — Landing
  - Saved folder: [TAVI-015](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015)
  - Image: [TAVI-015_landing_source_sheet.png](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/TAVI-015_landing_source_sheet.png) · [animation preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/previews/TAVI-015_landing_preview.gif)
  - File record: [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_01_main_character_tavi/core_animations/TAVI-015/metadata.json)
- [x] TAVI-016 — Sword attack
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
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/exports/MOTE-002_idle_hover_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/previews/MOTE-002_idle_hover_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-002/previews/MOTE-002_idle_hover_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-003 — Follow Tavi
  - Stage: six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.
  - Saved folder: [MOTE-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/exports/MOTE-003_follow_tavi_prototype_pack.zip) · [contact sheet](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/previews/MOTE-003_follow_tavi_contact_sheet.jpg) · [GIF preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_02_companion_mote/MOTE-003/previews/MOTE-003_follow_tavi_preview.gif)
  - Exports: 6 separate 512 × 512 RGBA frames; prompts, provenance, hashes and review notes recorded.
- [x] MOTE-004 — Alert reaction
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
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/exports/EN-002_prototype_pack.zip) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-002/previews/EN-002_idle_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-003 — Rootling patrol or movement animation
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/exports/EN-003_prototype_pack.zip) · [patrol preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-003/previews/EN-003_patrol_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-004 — Rootling attack animation
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/exports/EN-004_prototype_pack.zip) · [attack preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-004/previews/EN-004_attack_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-005 — Rootling hurt animation
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [EN-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/exports/EN-005_prototype_pack.zip) · [hurt preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/enemies/EN-005/previews/EN-005_hurt_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] EN-006 — Rootling defeat animation
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
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-002](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/exports/BOSS-002_prototype_pack.zip) · [idle preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-002/previews/BOSS-002_idle_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-003 — Walking and repositioning
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-003](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/exports/BOSS-003_prototype_pack.zip) · [walk_reposition_profile_corrected preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-003/previews/BOSS-003_walk_reposition_profile_corrected_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-004 — Attack wind-up
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-004](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/exports/BOSS-004_prototype_pack.zip) · [attack_windup preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-004/previews/BOSS-004_attack_windup_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-005 — Ground slam
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-005](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/exports/BOSS-005_prototype_pack.zip) · [ground_slam preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-005/previews/BOSS-005_ground_slam_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-006 — Arm swipe
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
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-008](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/exports/BOSS-008_prototype_pack.zip) · [stagger_damage preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-008/previews/BOSS-008_stagger_damage_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-009 — Phase transition
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-009](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/exports/BOSS-009_prototype_pack.zip) · [phase_transition preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-009/previews/BOSS-009_phase_transition_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-010 — Defeat animation
  - Stage: animation prototype generated and visually reviewed; 1 deliverable clip/view set(s); cleanup and production approval pending.
  - Saved folder: [BOSS-010](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010) · [metadata.json](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/metadata.json)
  - Prototype pack: [ZIP](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/exports/BOSS-010_prototype_pack.zip) · [defeat preview](/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss/BOSS-010/previews/BOSS-010_defeat_contact_sheet.jpg)
  - Exports: 6 RGBA frames/views across 1 separate clip/view set(s); timing, prompts, provenance and hashes recorded.
- [x] BOSS-011 — Boss arena entrance and awakening effects
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

- [ ] TILE-001 — Grass-topped ground tiles
- [ ] TILE-002 — Dirt and soil tiles
- [ ] TILE-003 — Stone platform tiles
- [ ] TILE-004 — Moss-covered rock tiles
- [ ] TILE-005 — Root platforms
- [ ] TILE-006 — Wood platforms and bridges
- [ ] TILE-007 — Edge and corner variants
- [ ] TILE-008 — Slopes and uneven terrain
- [ ] TILE-009 — One-way platforms
- [ ] TILE-010 — Broken platforms
- [ ] TILE-011 — Hanging platforms
- [ ] TILE-012 — Temple wall tiles
- [ ] TILE-013 — Temple floor and ceiling tiles
- [ ] TILE-014 — Rune-embedded stone tiles
- [ ] TILE-015 — Water edges and river tiles
- [ ] TILE-016 — Decorative foliage and rock overlays
- [ ] TILE-017 — Tile transition edges for blending environments

# Phase 06 — Props and Interactive Objects

## Village and forest props

- [ ] PROP-001 — Wooden lantern
- [ ] PROP-002 — Hanging lantern
- [ ] PROP-003 — Wooden signpost
- [ ] PROP-004 — Wooden crate
- [ ] PROP-005 — Barrel
- [ ] PROP-006 — Rope bridge
- [ ] PROP-007 — Wooden ladder
- [ ] PROP-008 — Rope and chain
- [ ] PROP-009 — Wooden door
- [ ] PROP-010 — Village window and roof components
- [ ] PROP-011 — Bushes, flowers, and mushrooms
- [ ] PROP-012 — Small tree and root clusters
- [ ] PROP-013 — Broken cart and abandoned equipment
- [ ] PROP-014 — Treasure chest

## Gameplay objects

- [ ] OBJ-001 — Checkpoint lantern
- [ ] OBJ-002 — Gold fragment collectible
- [ ] OBJ-003 — Rune switch
- [ ] OBJ-004 — Rune-activated door
- [ ] OBJ-005 — Hidden-platform rune marker
- [ ] OBJ-006 — Moving platform art
- [ ] OBJ-007 — Falling platform art
- [ ] OBJ-008 — Thorn hazard
- [ ] OBJ-009 — Spike hazard
- [ ] OBJ-010 — Breakable object
- [ ] OBJ-011 — Temple seal
- [ ] OBJ-012 — Level exit doorway or portal

# Phase 07 — Visual Effects

- [ ] FX-001 — Sword swing trail
- [ ] FX-002 — Sword impact sparks
- [ ] FX-003 — Enemy hit flash
- [ ] FX-004 — Enemy defeat particles
- [ ] FX-005 — Running dust
- [ ] FX-006 — Jump take-off puff
- [ ] FX-007 — Landing dust
- [ ] FX-008 — Falling debris
- [ ] FX-009 — Lantern light pulse
- [ ] FX-010 — Mote glow
- [ ] FX-011 — Rune activation
- [ ] FX-012 — Hidden-platform reveal
- [ ] FX-013 — Collectible pickup
- [ ] FX-014 — Checkpoint activation
- [ ] FX-015 — Boss ground impact
- [ ] FX-016 — Boss core energy
- [ ] FX-017 — Boss phase transition
- [ ] FX-018 — Death and respawn effects
- [ ] FX-019 — Water ripples and splashes
- [ ] FX-020 — Magic projectile

# Phase 08 — User Interface

## HUD elements

- [ ] UI-001 — Health indicators
- [ ] UI-002 — Health bar frame
- [ ] UI-003 — Collectible icon
- [ ] UI-004 — Objective banner
- [ ] UI-005 — Interaction prompt
- [ ] UI-006 — Checkpoint icon
- [ ] UI-007 — Treasure indicator
- [ ] UI-008 — Boss health bar
- [ ] UI-009 — Dialogue panel
- [ ] UI-010 — Dialogue portrait frames
- [ ] UI-011 — Pause icon
- [ ] UI-012 — Settings icon
- [ ] UI-013 — Touch movement controls
- [ ] UI-014 — Touch jump button
- [ ] UI-015 — Touch attack button

## Menus and screens

- [ ] UI-016 — Main menu background
- [ ] UI-017 — Game logo
- [ ] UI-018 — Main menu buttons
- [ ] UI-019 — Pause menu
- [ ] UI-020 — Settings screen
- [ ] UI-021 — Loading screen
- [ ] UI-022 — Game-over panel
- [ ] UI-023 — Level-complete panel
- [ ] UI-024 — Save/checkpoint indicator
- [ ] UI-025 — Controller and keyboard prompts

# Phase 09 — Audio Asset Inventory

## Sound effects

- [ ] AUD-SFX-001 — Running on grass
- [ ] AUD-SFX-002 — Running on stone
- [ ] AUD-SFX-003 — Jump
- [ ] AUD-SFX-004 — Landing
- [ ] AUD-SFX-005 — Sword swing
- [ ] AUD-SFX-006 — Sword impact
- [ ] AUD-SFX-007 — Enemy attack
- [ ] AUD-SFX-008 — Enemy defeat
- [ ] AUD-SFX-009 — Player hurt
- [ ] AUD-SFX-010 — Chest opening
- [ ] AUD-SFX-011 — Collectible pickup
- [ ] AUD-SFX-012 — Rune activation
- [ ] AUD-SFX-013 — Checkpoint activation
- [ ] AUD-SFX-014 — Door opening
- [ ] AUD-SFX-015 — Boss attack set
- [ ] AUD-SFX-016 — Boss damage
- [ ] AUD-SFX-017 — Boss defeat
- [ ] AUD-SFX-018 — UI selection and confirmation

## Ambient soundscapes

- [ ] AUD-AMB-001 — Brackenreach night
- [ ] AUD-AMB-002 — Village ambience
- [ ] AUD-AMB-003 — Forest birds and wind
- [ ] AUD-AMB-004 — Cave drips
- [ ] AUD-AMB-005 — Underground rumble
- [ ] AUD-AMB-006 — Glasswater Fen water
- [ ] AUD-AMB-007 — Bellows Gorge bells
- [ ] AUD-AMB-008 — Quiet Crown ambience

## Music

- [ ] AUD-MUS-001 — Main theme
- [ ] AUD-MUS-002 — Village theme
- [ ] AUD-MUS-003 — Forest exploration
- [ ] AUD-MUS-004 — Temple exploration
- [ ] AUD-MUS-005 — Boss battle
- [ ] AUD-MUS-006 — Stillmere theme
- [ ] AUD-MUS-007 — Final boss theme
- [ ] AUD-MUS-008 — Ending theme

# Phase 10 — Later Campaign-Specific Assets

- [ ] LATE-001 — Briarwake orchard pack, Mossjaw, and root-stone
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
