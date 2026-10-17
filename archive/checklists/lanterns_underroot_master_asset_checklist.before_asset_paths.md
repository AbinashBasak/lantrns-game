# Lanterns Underroot — Master Game Asset Checklist

**Project:** Lanterns Underroot  
**Genre:** Original 2D illustrated fantasy action-adventure platformer  
**Engine:** Godot  
**Platforms:** Android, iOS, Windows, macOS, Linux (as applicable)  
**Purpose:** Master inventory for producing game assets one by one.

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
- [x] ART-002 — Color palette and lighting reference
- [x] ART-003 — Character proportion and scale sheet
- [x] ART-004 — Environment material reference: soil, grass, stone, roots, wood
- [x] ART-005 — Magic, rune, glow, and particle style reference
- [x] ART-006 — Character and environment rendering consistency guide

# Phase 01 — Main Character: Tavi

## Character design

- [x] TAVI-001 — Approved character model sheet: front, side, back, and three-quarter views
- [ ] TAVI-002 — Character color and material reference
- [ ] TAVI-003 — Sword design sheet
- [ ] TAVI-004 — Sprite scale, pivot, and collision reference

## Core animations — prototype priority

- [x] TAVI-010 — Idle
- [x] TAVI-011 — Run
- [x] TAVI-012 — Jump start
- [x] TAVI-013 — Rising jump
- [x] TAVI-014 — Falling
- [x] TAVI-015 — Landing
- [x] TAVI-016 — Sword attack
- [ ] TAVI-017 — Hurt reaction
- [ ] TAVI-018 — Death
- [ ] TAVI-019 — Interact with object
- [ ] TAVI-020 — Activate rune with sword
- [ ] TAVI-021 — Lantern reveal ability

## Later movement and combat animations

- [ ] TAVI-022 — Dodge or dash
- [ ] TAVI-023 — Second sword combo
- [ ] TAVI-024 — Charged attack
- [ ] TAVI-025 — Climbing
- [ ] TAVI-026 — Opening chest
- [ ] TAVI-027 — Victory
- [ ] TAVI-028 — Knockback and recovery

# Phase 02 — Companion: Mote

- [ ] MOTE-001 — Character model sheet
- [ ] MOTE-002 — Idle hover
- [ ] MOTE-003 — Follow Tavi
- [ ] MOTE-004 — Alert reaction
- [ ] MOTE-005 — Rune interaction
- [ ] MOTE-006 — Glow pulse
- [ ] MOTE-007 — Celebrate discovery
- [ ] MOTE-008 — Disappear and reappear
- [ ] MOTE-009 — Companion light effect
- [ ] MOTE-010 — Story-specific reactions

# Phase 03 — Enemies and Chapter 1 Boss

## Enemies

- [ ] EN-001 — Rootling model sheet
- [ ] EN-002 — Rootling idle animation
- [ ] EN-003 — Rootling patrol or movement animation
- [ ] EN-004 — Rootling attack animation
- [ ] EN-005 — Rootling hurt animation
- [ ] EN-006 — Rootling defeat animation
- [ ] EN-007 — Thornwing model sheet
- [ ] EN-008 — Thornwing hover and fly animations
- [ ] EN-009 — Thornwing dive attack
- [ ] EN-010 — Thornwing hurt and defeat animations
- [ ] EN-011 — Sporeling model sheet
- [ ] EN-012 — Sporeling idle and movement animations
- [ ] EN-013 — Sporeling spore attack
- [ ] EN-014 — Sporeling hurt and defeat animations
- [ ] EN-015 — Brambleguard model sheet
- [ ] EN-016 — Brambleguard walk and idle animations
- [ ] EN-017 — Brambleguard heavy attack
- [ ] EN-018 — Brambleguard stagger, hurt, and defeat animations

## Hollow Sentinel boss

- [ ] BOSS-001 — Final boss design sheet
- [ ] BOSS-002 — Idle animation
- [ ] BOSS-003 — Walking and repositioning
- [ ] BOSS-004 — Attack wind-up
- [ ] BOSS-005 — Ground slam
- [ ] BOSS-006 — Arm swipe
- [ ] BOSS-007 — Ranged core attack
- [ ] BOSS-008 — Stagger and damage reaction
- [ ] BOSS-009 — Phase transition
- [ ] BOSS-010 — Defeat animation
- [ ] BOSS-011 — Boss arena entrance and awakening effects
- [ ] BOSS-012 — Boss health bar icon and UI portrait

# Phase 04 — Environment Packs

- [ ] ENV-01 — Brackenreach village (prologue)
- [ ] ENV-02 — The Forgotten Trail (Chapter 1)
- [ ] ENV-03 — The Ancient Root-Temple (Chapter 1)
- [ ] ENV-04 — Briarwake orchard
- [ ] ENV-05 — Glasswater Fen
- [ ] ENV-06 — Bellows Gorge
- [ ] ENV-07 — Archive Beneath the Earth
- [ ] ENV-08 — Root Cathedral
- [ ] ENV-09 — Stillmere, the village frozen in time
- [ ] ENV-10 — The Quiet Crown's final arena
- [ ] ENV-11 — Brackenreach after the restoration

Each environment pack should include, as needed:

- [ ] Distant background layer(s)
- [ ] Midground layer(s)
- [ ] Playable terrain and tileset
- [ ] Foreground layer(s)
- [ ] Decorative props
- [ ] Interactive props
- [ ] Location-specific visual effects
- [ ] Lighting and color reference

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
