# Lanterns Underroot --- Chapter 3 Production Bible

## The Sunken Temple \| Godot 4 \| 2D Side-Scrolling Platformer

**Document purpose:** This is the master implementation and
asset-generation plan for Chapter 3. It defines the level journey,
screen-by-screen walkthrough, scene structure, asset inventory, sprite
transparency requirements, depth/parallax, lighting, visual effects,
enemy actions, chests, puzzles, audio hooks, and an ordered
asset-generation backlog. Generate assets one item at a time using the
IDs in this document.

**Working assumptions** - Engine: Godot 4.x, 2D renderer. - Camera:
side-scrolling, horizontal-first, with vertical exploration in selected
rooms. - Art direction: painterly fantasy platformer; deep teal/blue
shadows, warm amber lanterns, cyan crystals, mossy stone, ancient temple
gold. - Player and companion are separate animated sprites. The chapter
background is not one flattened image. - Resolution reference: 1920×1080
concept framing. Design for 16:9 and test at 1280×720 and common
windowed sizes. - Coordinate convention: X increases right; Y increases
down. Godot `z_index` increases toward the foreground. - All scale,
speed, damage, and timing values below are starting values for
playtesting, not final balance.

------------------------------------------------------------------------

# 1. Production rules

## 1.1 Non-negotiable asset rules

1.  **Do not use a single complete level illustration as the playable
    level.** Use it as a visual target only. The playable world must be
    assembled from modular tiles, props, platforms, enemies, hazards,
    and parallax layers.
2.  **Transparent sprites:** all standalone gameplay objects and
    foreground elements must be PNG or WebP with true alpha
    transparency. Do not include a checkerboard in the actual image.
3.  **No baked-in labels:** no text, UI labels, control prompts, arrows,
    or debug markers in gameplay assets unless the item is specifically
    a UI asset.
4.  **Consistent scale:** define one world scale before generation.
    Starting guide: 32 px per tile, terrain tiles 64×64 or 96×64 where
    needed, player height about 64--96 px, common enemy height 48--80
    px. These are relative guides; adjust to the current project and
    keep all assets consistent.
5.  **Pivot/origin:** characters and enemies should be bottom-center
    anchored; terrain tiles use top-left grid alignment; doors and large
    props use bottom-center; VFX use a clearly documented origin.
6.  **Sprite sheets:** request evenly spaced frames with no overlaps, no
    shadows cut off, no frame labels, and a transparent background.
    Prefer one animation per sheet. Use separate files for large/complex
    animation sets.
7.  **Separate state art only when it visibly differs.** For lanterns,
    make an unlit base sprite and a flame/glow effect; do not duplicate
    the entire post for every lighting state.
8.  **Do not bake dynamic light halos into the main sprite.** Small
    painted highlights are fine, but the actual emitted light should be
    created in Godot.
9.  **Gameplay readability beats decoration.** The top edge of solid
    platforms must be readable; hazards must contrast with safe
    surfaces; foreground foliage must not hide the player or
    interactable objects.
10. **Use a consistent palette:** shadow teal `#09242B`, deep blue
    `#103A50`, stone `#33434A`, moss `#557A3D`, leaf green `#8FB94C`,
    lantern amber `#FFB642`, magic cyan `#35D9FF`, rare shrine gold
    `#F4C86A`, danger red `#F45B48`.

## 1.2 Asset file naming

Use lowercase snake_case with a stable ID prefix: -
`C3_ENV_001_cavern_back_far.png` - `C3_TILE_001_stone_grass_top.png` -
`C3_PROP_001_lantern_post_base.png` -
`C3_VFX_001_lantern_flame_loop.png` -
`C3_ENM_001_drowned_sentinel_idle.png` -
`C3_UI_001_boss_health_frame.png`

Store source files and exported/import-ready files separately: -
`art/source/` --- layered originals and working files. -
`art/export/chapter_03/` --- game-ready PNG/WebP. - `scenes/chapter_03/`
--- Godot scenes. - `resources/chapter_03/` --- resources, animations,
materials, data. - `audio/chapter_03/` --- chapter-specific sound. -
`docs/` --- this document and implementation notes.

## 1.3 Required metadata for every generated asset

Record the following in a tracking sheet: - Asset ID and filename -
Purpose / scene(s) used in - Canvas size and visible-content bounds -
Transparent background: yes/no - Pivot/origin - Animation frame count
and FPS, if animated - Suggested `z_index` layer - Whether it receives
light, casts shadows, or emits light - Collision shape needed (none /
rectangle / polygon / custom) - Import filter and compression - Status:
not started / generated / cleanup needed / imported / integrated / QA
passed

------------------------------------------------------------------------

# 2. Chapter 3 overview

## Chapter title

**Chapter 3 --- The Sunken Temple**

## Narrative premise

The player follows a trail of golden fragments beneath the forest into
an ancient temple flooded by a subterranean lake. The temple's
water-control mechanism has failed, opening paths that were once
submerged. The player explores crystal caverns and flooded archives,
restores drainage machinery, crosses broken bridges, solves the shrine's
light-and-water puzzle, defeats the Guardian of the Seal, and reaches
the Sunken Seal chamber.

## Core player goals

1.  Enter the sunken ruins.
2.  Collect Golden Fragments and temple keys.
3.  Explore both above-water and underwater routes.
4.  Activate the drainage mechanism to reveal new paths.
5.  Discover at least one optional secret route.
6.  Open treasure chests and a locked relic chest.
7.  Activate the Ancient Shrine.
8.  Defeat the Guardian Hall mini-boss.
9.  Solve the final temple seal puzzle.
10. Defeat the Sunken Guardian and complete the chapter.

## Recommended chapter structure

Use eight distinct playable sections. Each section should be its own
Godot scene so it can be built, tested, streamed, and revisited
independently.

  -----------------------------------------------------------------------
  ID                Section           Gameplay focus    Exit condition
  ----------------- ----------------- ----------------- -----------------
  C3-S01            Entrance Ruins    Movement, combat  Open rune gate
                                      refresh, first    
                                      chest             

  C3-S02            Crystal Caverns   Vertical          Acquire Temple
                                      platforms,        Key
                                      crystal hazards   

  C3-S03            Flooded Archives  Swimming,         Find Drainage
                                      underwater        Sigil
                                      routes, moving    
                                      platforms         

  C3-S04            Drainage          Switch puzzle,    Drain lower
                    Mechanism         water level       chamber
                                      changes           

  C3-S05            Sunken Bridges    Multi-path        Cross broken
                                      traversal, secret bridge
                                      passage           

  C3-S06            Ancient Shrine    Light beam /      Activate shrine
                                      mirror puzzle,    
                                      locked relic      
                                      chest             

  C3-S07            Guardian Hall     Combat arena,     Obtain Guardian
                                      mini-boss,        Key
                                      checkpoint        

  C3-S08            Temple Core       Final             Defeat Sunken
                                      platforming, seal Guardian
                                      puzzle, boss      
                                      fight             
  -----------------------------------------------------------------------

## Suggested progression rewards

-   12--16 ordinary chests across the chapter, including optional-route
    rewards.
-   8--12 Golden Fragments or equivalent collectible pickups.
-   2 temple keys: Temple Key and Guardian Key.
-   1 Drainage Sigil.
-   1 optional relic chest with a meaningful upgrade or lore reward.
-   2 checkpoints before the final boss.
-   1 secret room with a high-value reward.
-   1 mini-boss and 1 final boss.

These are design targets, not mandatory counts. Adjust to match chapter
length and pacing.

------------------------------------------------------------------------

# 3. Full journey and screen-by-screen walkthrough

Each "screen" below means a camera-sized gameplay beat, not necessarily
one separate Godot scene. Several screens can be grouped into one
section scene. Keep exits and entrances connected with explicit markers.

## C3-S01 --- Entrance Ruins

### Screen 01: Ruined approach

**Purpose:** establish the new environment and show the route ahead. -
Visuals: dark cave mouth, broken stone steps, roots, shallow water, a
few cyan crystals, distant waterfall in the background. - Player path:
ground-level route from left to right. - Props: two unlit lantern posts,
broken pillars, one decorative statue. - Enemies: one low-threat Temple
Mite or no enemy on the first pass. - Collectibles: one visible Golden
Fragment on a short raised ledge. - Chest: `C3_CHEST_01` ordinary chest
on the main route. - Lighting: cool ambient tint; one warm light near
the entrance. - Exit: stone arch to Screen 02. - QA: player silhouette
remains visible against the dark cave; the fragment is reachable without
damage.

### Screen 02: Rune gate tutorial

-   Visuals: ancient door with a glowing rune socket, two floor
    platforms, water below.
-   Interaction: examine the gate; UI says a fragment or key is needed.
-   Puzzle: collect the nearby fragment and interact with the gate.
-   Chest: optional small chest `C3_CHEST_02` on a short side ledge.
-   Effects: rune socket idle pulse; door activation burst after valid
    interaction.
-   Exit: gate opens into the Crystal Caverns.
-   QA: interaction prompt appears only in range; the gate cannot be
    activated repeatedly after opening.

## C3-S02 --- Crystal Caverns

### Screen 03: Crystal shelf

-   Visuals: tall blue crystal formations, narrow mossy ledges, distant
    cavern silhouettes.
-   Traversal: jump across three ascending platforms.
-   Hazard: crystal spikes on one lower ledge; telegraph with a subtle
    glow before activation.
-   Enemy: Crystal Wisp, floating in a predictable horizontal patrol.
-   Collectibles: one fragment above the main path.
-   Chest: `C3_CHEST_03` visible on a high ledge; requires a short
    optional jump route.
-   Lighting: cyan emissive crystal surfaces plus restrained local
    PointLight2D nodes.
-   Exit: ladder/vine climb to Screen 04.
-   QA: each jump has a safe landing; don't place the collectible
    directly over an unavoidable hazard.

### Screen 04: Crystal lift

-   Visuals: vertical shaft, suspended platform, glowing crystal
    clusters, stone columns.
-   Traversal: moving platform lifts player to the upper path.
-   Mechanism: activate a crystal switch to call the lift.
-   Enemy: one Crystal Wisp or a stationary crystal turret; don't use
    both on the first pass.
-   Chest: `C3_CHEST_04` behind a breakable crystal wall.
-   Effects: lift hum, crystal sparkle, debris burst when wall breaks.
-   Exit: upper arch to Flooded Archives.
-   QA: platform stops at both endpoints, carries the player, and cannot
    trap them in the shaft.

## C3-S03 --- Flooded Archives

### Screen 05: Archive landing

-   Visuals: submerged library ruins, stone shelves, floating debris,
    fish silhouettes, waterline across the middle.
-   Traversal: ground path with a shallow swim section.
-   Enemy: Drowned Archive Keeper, slow patrol on land and reduced-speed
    movement underwater.
-   Collectibles: two fragments, one on a submerged shelf.
-   Chest: `C3_CHEST_05` partially submerged; interaction works only
    when the player is close enough.
-   Lighting: blue-green underwater tint, caustic overlay, bubbles.
-   Exit: submerged arch into Screen 06.
-   QA: underwater movement and jump rules are communicated; the player
    can return to the surface safely.

### Screen 06: Moving archive platforms

-   Visuals: floating stone slabs, columns, water jets and a distant
    broken bridge.
-   Traversal: ride two moving platforms over water.
-   Hazard: periodic water jet; use a clear wind-up/telegraph before
    damage.
-   Chest: `C3_CHEST_06` on a side platform reachable after riding the
    first lift.
-   Enemy: optional small aquatic enemy, only if the screen is not
    already too busy.
-   Exit: Drainage Mechanism.
-   QA: falling into water is either safe swimming or a clear reset
    hazard---do not mix rules unpredictably.

## C3-S04 --- Drainage Mechanism

### Screen 07: Gear chamber

-   Visuals: enormous stone gears, bronze mechanisms, sluice gates,
    shallow water and amber lamps.
-   Puzzle: activate three switches in a discoverable order to lower the
    water level.
-   Interactables: `C3_SWITCH_A`, `C3_SWITCH_B`, `C3_SWITCH_C`; one may
    be behind a short traversal challenge.
-   Chest: `C3_CHEST_07` appears after the water level drops.
-   Enemy: one Drowned Sentinel that patrols the safe walkway.
-   Effects: gears rotate; waterline transitions; gate rumbles; droplets
    and mist increase while draining.
-   Exit: a previously submerged passage opens.
-   QA: show the player which switches have activated; puzzle state
    persists after death or leaving the room if intended.

### Screen 08: Lower drain tunnel

-   Visuals: low stone tunnel, pipes, roots, dripping water, a narrow
    crawl-like passage.
-   Traversal: short low-ceiling route and one underwater pocket.
-   Secret: breakable wall reveals `C3_SECRET_01`.
-   Chest: `C3_CHEST_08` inside the secret room; reward should justify
    exploration.
-   Hazard: falling stone debris with a clear warning.
-   Exit: Sunken Bridges.
-   QA: secret wall must be hinted by cracks, different coloration, or
    sound; don't make it indistinguishable from ordinary stone.

## C3-S05 --- Sunken Bridges

### Screen 09: Broken bridge crossing

-   Visuals: rope bridge over a luminous lake, waterfall behind, ruined
    arches.
-   Traversal: bridge sections with a missing span; jump or use a moving
    platform below.
-   Enemy: Temple Mite group or one ranged Wisp.
-   Collectibles: two fragments along the optional upper route.
-   Chest: `C3_CHEST_09` near the far end of the upper route.
-   Effects: bridge ropes sway subtly; water splashes below.
-   Exit: lower bridge to Screen 10.
-   QA: the optional route must reconnect to the main path; avoid
    soft-locking the player on the upper platform.

### Screen 10: Hidden bridge passage

-   Visuals: hidden arch behind waterfall, narrow ledges, dim gold
    runes.
-   Secret route: enter behind the waterfall to find `C3_SECRET_02`.
-   Chest: `C3_CHEST_10` contains a rare upgrade, lore item, or extra
    fragments.
-   Enemy: one elite Temple Mite guarding the reward.
-   Lighting: darker ambient environment; warm lantern near the reward;
    cyan water rim light.
-   Exit: Ancient Shrine.
-   QA: waterfall concealment must not hide collision edges; secret
    entrance has a readable clue.

## C3-S06 --- Ancient Shrine

### Screen 11: Shrine forecourt

-   Visuals: tall temple doors, statues, reflective pool, golden rune
    floor, hanging lanterns.
-   Traversal: short combat encounter and a raised switch platform.
-   Enemy: two Temple Mites or one Wisp, scaled to the player's upgrade
    level.
-   Chest: `C3_CHEST_11` main-route chest.
-   Interactable: shrine console explains that light must be redirected.
-   Exit: shrine puzzle room.
-   QA: keep foreground statues from obscuring the player or enemy
    attacks.

### Screen 12: Light-and-mirror puzzle

-   Visuals: three rotatable mirrors, one beam source, rune receivers,
    optional side ledges.
-   Puzzle: rotate mirrors to direct a beam through three receivers.
-   Interactables: `C3_MIRROR_A`, `C3_MIRROR_B`, `C3_MIRROR_C`,
    `C3_BEAM_SOURCE`, `C3_RUNE_RECEIVER`.
-   Chest: `C3_CHEST_12`, locked relic chest. Unlocks only when the
    puzzle is solved.
-   Reward: relic upgrade or permanent bonus; define it before asset
    generation.
-   Effects: visible beam, receiver glow, particles when aligned, short
    shrine activation burst.
-   Exit: Ancient Shrine gate opens to Guardian Hall.
-   QA: beam direction is visually clear; each mirror has discrete
    states; puzzle can be reset.

## C3-S07 --- Guardian Hall

### Screen 13: Guardian approach and checkpoint

-   Visuals: giant statues, long hall, amber braziers, cracked floor,
    seal door.
-   Checkpoint: `C3_CHECKPOINT_02` before the boss arena.
-   Chest: `C3_CHEST_13` near the checkpoint; don't put it inside the
    boss arena.
-   Enemy: elite Drowned Sentinel.
-   Interaction: activate checkpoint and inspect sealed door.
-   Exit: arena entrance.
-   QA: checkpoint respawns player safely and preserves collected
    permanent items.

### Screen 14: Hall mini-boss

-   Boss: `C3_BOSS_01_GUARDIAN_KNIGHT`, an armored drowned temple
    guardian.
-   Arena: broad flat floor with two safe platforms and one hazard lane.
-   Phases:
    1.  Slow shielded advance.
    2.  Overhead slam with ground shockwave.
    3.  Short recovery window.
    4.  At 50% health, faster double-slam and a summon or projectile.
-   Reward: Guardian Key.
-   Chest: `C3_CHEST_14` appears after victory.
-   Effects: weapon trails, ground dust, hit sparks, shockwave ring,
    death dissolve.
-   QA: every heavy attack has a readable wind-up; recovery window is
    long enough to counterattack.

## C3-S08 --- Temple Core

### Screen 15: Final seal approach

-   Visuals: immense central seal, floating stone fragments, waterfalls
    descending into a dark pool, gold light from the temple core.
-   Traversal: two vertical platforming sequences; one optional ledge
    with a final fragment.
-   Chest: `C3_CHEST_15` optional chest on a difficult side route.
-   Puzzle: insert Guardian Key and place the required Golden Fragments.
-   Checkpoint: `C3_CHECKPOINT_03` immediately before the boss gate.
-   Exit: boss arena.
-   QA: all required objectives are checked before opening the final
    gate; optional content never blocks completion.

### Screen 16: Sunken Guardian boss arena

-   Boss: `C3_BOSS_02_SUNKEN_GUARDIAN`, ancient aquatic guardian with
    stone armor and cyan-gold energy.
-   Arena: large readable platform, two side ledges, water below, safe
    landing zones.
-   Phase 1: slow trident sweep, short dash, summon bubbles.
-   Phase 2 at 70% health: flood pulses and falling water columns.
-   Phase 3 at 35% health: seal beam, faster combos, exposed core after
    heavy attacks.
-   Weak point: glowing chest/core exposed during recovery.
-   Reward: final Golden Fragment / Sunken Seal.
-   Effects: water columns, beam telegraphs, shockwaves, core pulse,
    screen shake used sparingly.
-   Completion: boss defeat, seal animation, short narrative beat,
    chapter-complete UI.
-   QA: no unavoidable damage during transitions; boss can be defeated
    using the standard move set; restart restores boss state correctly.

### Screen 17: Aftermath and exit

-   Visuals: boss arena calms, water settles, core glow dims, temple
    doors open.
-   Reward: chapter-complete summary, optional completion count and
    chest count.
-   Interaction: continue to Chapter 4 or return to hub.
-   QA: don't show the chapter-complete overlay until the victory state
    and save operation are complete.

------------------------------------------------------------------------

# 4. Godot scene architecture

## 4.1 Suggested folder structure

``` text
res://
  art/
    characters/
    enemies/
    environment/
      chapter_03/
        backgrounds/
        tiles/
        platforms/
        props/
        doors/
        chests/
    vfx/
    ui/
  audio/
    chapter_03/
  scenes/
    player/
    enemies/
    props/
    interactables/
    vfx/
    chapter_03/
      c3_s01_entrance_ruins.tscn
      c3_s02_crystal_caverns.tscn
      c3_s03_flooded_archives.tscn
      c3_s04_drainage_mechanism.tscn
      c3_s05_sunken_bridges.tscn
      c3_s06_ancient_shrine.tscn
      c3_s07_guardian_hall.tscn
      c3_s08_temple_core.tscn
  scripts/
    chapter_03/
  resources/
    chapter_03/
  docs/
```

## 4.2 Reusable section scene tree

``` text
C3_S01_EntranceRuins (Node2D)
├── Environment
│   ├── BackgroundFar (Parallax2D)
│   ├── BackgroundMid (Parallax2D)
│   ├── BackgroundNear (Parallax2D)
│   ├── TileMapLayer_Background
│   ├── TileMapLayer_Solid
│   ├── TileMapLayer_Deco
│   └── ForegroundOverlay (Node2D)
├── Lighting
│   ├── CanvasModulate
│   ├── LanternLights (Node2D)
│   ├── CrystalLights (Node2D)
│   └── LightOccluders (Node2D)
├── Gameplay
│   ├── PlayerSpawn (Marker2D)
│   ├── Enemies (Node2D)
│   ├── Interactables (Node2D)
│   ├── Chests (Node2D)
│   ├── Collectibles (Node2D)
│   ├── Hazards (Node2D)
│   ├── Checkpoints (Node2D)
│   └── ExitTrigger (Area2D)
├── VFX
│   ├── AmbientParticles
│   └── OneShotEffects
├── CameraBounds (Node2D)
└── WorldTriggers (Node2D)
```

Godot 4 supports `Parallax2D` and `TileMapLayer` in current versions. If
the project is on an earlier Godot 4 minor version, check the exact node
names and APIs for that version before building scenes.

## 4.3 Reusable object scenes

Create reusable scenes for: - `LanternPost.tscn` - `Chest.tscn` -
`RuneDoor.tscn` - `CheckpointLantern.tscn` - `CrystalCluster.tscn` -
`MovingPlatform.tscn` - `WaterVolume.tscn` - `BreakableWall.tscn` -
`PressureSwitch.tscn` - `MirrorPuzzlePiece.tscn` -
`CollectibleFragment.tscn` - `EnemyBase.tscn` -
`BossHealthController.tscn`

Each reusable object should expose editable properties rather than
requiring scene-specific script changes: `is_active`, `is_locked`,
`loot_id`, `activation_id`, `patrol_distance`, `light_enabled`,
`persistent_state_key`.

------------------------------------------------------------------------

# 5. Layering, depth, transparency, and parallax

## 5.1 Recommended visual layers

Use these as a starting order. Adjust `z_index` if your player must
appear behind a foreground object.

  ----------------------------------------------------------------------------
  Layer ID      Content        Suggested z_index Parallax       Transparency
                                                 behavior       
  ------------- -------------- ----------------- -------------- --------------
  L00           Far cave                    -100 0.05--0.12     Opaque art or
                silhouette /                                    alpha PNG
                distant ruins                                   

  L01           Distant water,               -80 0.10--0.18     Alpha overlays
                waterfalls,                                     where needed
                haze                                            

  L02           Far                          -60 0.15--0.25     Alpha PNG or
                architecture                                    tile layer
                and pillars                                     

  L03           Midground                    -40 0.25--0.40     Alpha PNG
                roots, arches,                                  
                ruins                                           

  L04           Main solid                     0 1.00           Tile atlas;
                terrain and                                     collision
                platforms                                       separate

  L05           Props behind                   5 1.00           Alpha PNG
                player                                          

  L06           Player and                    10 1.00           Alpha PNG
                enemies                                         sprite frames

  L07           Foreground                    20 1.00           Alpha PNG;
                props / arch                                    must not
                edges                                           obscure
                                                                gameplay

  L08           Particles and                 25 1.00           Alpha sprite /
                world VFX                                       GPU particles

  L09           World-space                   30 1.00           Alpha PNG or
                interaction                                     vector UI
                markers                                         

  L10           HUD / pause /        CanvasLayer Screen-fixed   UI textures
                dialogue UI                                     with alpha
  ----------------------------------------------------------------------------

`z_index` is only one part of ordering; parent-child ordering,
`y_sort_enabled`, CanvasLayer, and `z_as_relative` can affect results.
Keep the number of ordering rules small and document exceptions.

## 5.2 Parallax guide

-   Far cave wall: `Parallax2D` scroll scale around `(0.06, 0.06)`.
-   Distant ruins: `(0.12, 0.12)`.
-   Midground arches and waterfalls: `(0.22, 0.22)`.
-   Near roots and large pillars: `(0.38, 0.38)`.
-   Gameplay terrain and props: normal camera movement `(1, 1)`.
-   Foreground leaves: `(1.08, 1.08)` only if subtle foreground drift
    improves depth.
-   Avoid moving HUD elements with parallax.
-   For vertical camera motion, test parallax values carefully; overly
    strong vertical parallax can make platforms appear to drift.

## 5.3 Transparent export checklist

For each isolated sprite: - Canvas tightly frames the object but leaves
room for glow/animation if needed. - Background is truly transparent
(alpha channel), not a painted checkerboard. - No white matte or colored
fringe around the silhouette. - No crop on leaves, particles, light
rays, weapon tips, or shadows. - No labels, captions, grid, borders, or
neighboring sprites. - For animated sheets, all frames have identical
canvas dimensions and consistent pivot. - Export a clean base sprite
separately from glow, shadow, and VFX if those need independent control.

------------------------------------------------------------------------

# 6. Lighting plan for Godot 4

## 6.1 Overall approach

Use a hybrid approach: - Paint material detail and small highlights into
assets. - Use `CanvasModulate` for the scene's ambient tint. - Use
`PointLight2D` for lanterns, crystals, shrine sources, and selected
magic. - Use `LightOccluder2D` polygons for foreground rocks, large
pillars, and major architecture that should cast shadows. - Use
emissive-looking artwork or a separate glow sprite for small objects
that do not need to illuminate nearby surfaces. - Add subtle
`GPUParticles2D` or `CPUParticles2D` for sparks, motes, bubbles, mist,
and dust. - Use a shader or overlay for water caustics, not a large
number of individual lights. - Add `CanvasLayer` UI effects separately
so world lighting does not darken the HUD.

## 6.2 Starting lighting values

Values are illustrative and need tuning against the actual art and
renderer.

  --------------------------------------------------------------------------------------
  Light ID                 Placement        Starting color Energy /       Notes
                                                           texture        
  ------------------------ ---------------- -------------- -------------- --------------
  C3-LIGHT-AMB-01          Whole section    Deep teal-blue Tint around    Don't make the
                           via                             `#6E91A2` /    game
                           CanvasModulate                  tune by eye    unreadably
                                                                          dark

  C3-LIGHT-LANTERN-01      Each active      Warm amber     Energy         Flicker
                           lantern          `#FFB84D`      0.7--1.2       subtly, not
                                                                          rapidly

  C3-LIGHT-CRYSTAL-01      Large cyan       Cyan `#39D8FF` Energy         Keep radius
                           crystal                         0.4--0.9       local

  C3-LIGHT-SHRINE-01       Shrine / rune    Gold `#FFD46B` Energy         Pulse on
                           door                            1.0--1.6       puzzle state

  C3-LIGHT-BOSS-01         Boss core        Cyan-gold      Energy 0.6     Synchronize
                                                           idle, higher   with boss
                                                           during attack  animation

  C3-LIGHT-CHECKPOINT-01   Checkpoint       Amber-gold     Energy         Brighter after
                           lantern                         0.8--1.2       activation
  --------------------------------------------------------------------------------------

For `PointLight2D`, use a soft radial texture with transparent edges.
Avoid a hard-edged white circle. Tune `texture_scale`, energy, color,
and shadow filter in the editor. Prefer a small number of purposeful
lights over dozens of overlapping lights.

## 6.3 Where shadows are needed

-   Large cave columns and foreground arches.
-   The underside of solid platforms where a shadow helps separation.
-   Large statues, boss architecture, and the main shrine.
-   Selected foreground roots.
-   Avoid adding occluders to every leaf, tiny crystal, or decorative
    pebble; too many shadow polygons can hurt performance and create
    visual noise.

## 6.4 Flicker behavior

Lantern flicker should be subtle: - Energy varies within roughly ±5--10%
of its baseline. - Use slow, smooth noise or a short tween, not random
high-frequency flashing. - Add an occasional small spark particle. - Do
not flicker all lanterns in sync. - Provide a quality setting to reduce
dynamic lights and particles on weaker devices.

## 6.5 Water lighting

-   Base water surface: painted/animated texture.
-   Caustics: slowly scrolling semi-transparent texture or shader.
-   Reflections: stylized overlay; do not attempt physically exact
    reflections for every object.
-   Underwater tint: a color overlay or shader applied to the water
    volume / underwater region.
-   Bubbles: low-count particles near vents and underwater enemies.
-   Waterfall mist: soft alpha particles near the bottom of the fall.
-   Keep collision and water visuals separate; the visual waterfall
    sprite must not define collision by itself.

## 6.6 Performance targets

-   Start with 8--16 active dynamic lights visible at once; profile
    before increasing.
-   Reuse light textures and materials.
-   Use particles sparingly and cap amount.
-   Prefer tile atlases for repeating terrain.
-   Avoid full-screen transparent effects stacked many times.
-   Test on the actual target hardware; performance depends on
    resolution, renderer, light textures, occluders, and particles.

------------------------------------------------------------------------

# 7. Visual effects catalogue

  ----------------------------------------------------------------------------
  VFX ID         Effect         Trigger        Asset /          Lifetime
                                               implementation   
  -------------- -------------- -------------- ---------------- --------------
  C3-VFX-001     Lantern flame  Active lantern Animated flame   Loop
                 loop                          sprite +         
                                               PointLight2D     

  C3-VFX-002     Lantern sparks Random /       GPUParticles2D   0.5--1.5 s
                                activation     or sprite burst  

  C3-VFX-003     Crystal pulse  Idle crystal   Shader / glow    Loop
                                               overlay          

  C3-VFX-004     Crystal        Breakable      Sprite           0.4--0.8 s
                 shatter        crystal        fragments +      
                                destroyed      particles        

  C3-VFX-005     Golden         Collectible    Gold flash +     0.5 s
                 Fragment       acquired       particles +      
                 pickup                        sound            

  C3-VFX-006     Chest open     Chest opened   Gold particles + 0.6--1.0 s
                 burst                         lid motion       

  C3-VFX-007     Rune door      Gate unlocked  Rune pulse +     1.0--2.0 s
                 activation                    particles +      
                                               light tween      

  C3-VFX-008     Water splash   Enter/exit     Splash sprite /  0.3--0.8 s
                                water          particles        

  C3-VFX-009     Underwater     Water vents /  Small bubble     Loop
                 bubbles        movement       particles        

  C3-VFX-010     Waterfall mist Near waterfall Soft low-alpha   Loop
                                base           particles        

  C3-VFX-011     Water jet      Before hazard  Blue ripple /    0.6--1.0 s
                 telegraph                     expanding ring   

  C3-VFX-012     Water jet      Hazard active  Water column     0.5--1.2 s
                 burst                         animation        

  C3-VFX-013     Switch         Switch pressed Gold flash /     0.4 s
                 activation                    rune ring        

  C3-VFX-014     Gear           Drain puzzle   Dust, gear       1.0--2.5 s
                 activation     solved         sparks, rumble   

  C3-VFX-015     Moving         Platform moves Optional small   Loop
                 platform trail                droplets / dust  

  C3-VFX-016     Mirror beam    Puzzle beam    Line/beam shader While active
                                enabled        or stretched     
                                               sprite           

  C3-VFX-017     Mirror         Beam hits      Gold ring /      0.5 s
                 alignment      receiver       spark burst      
                 burst                                          

  C3-VFX-018     Enemy hit      Enemy takes    White/cyan tint  0.08--0.15 s
                 flash          damage         flash            

  C3-VFX-019     Enemy defeat   Enemy dies     Particles /      0.3--0.8 s
                                               dissolve         

  C3-VFX-020     Sword slash    Player attack  Animated         0.15--0.35 s
                                               transparent      
                                               sprite           

  C3-VFX-021     Boss shockwave Heavy boss     Ground wave      0.4--0.7 s
                                attack         sprite           

  C3-VFX-022     Boss core      Exposed core   Glow sprite +    1--2 s
                 pulse                         light tween      

  C3-VFX-023     Boss beam      Boss aims beam Thin guide       0.6--1.0 s
                 telegraph                     line + warning   
                                               sound            

  C3-VFX-024     Boss water     Boss attack    Water column /   0.6--1.2 s
                 column                        splash           

  C3-VFX-025     Checkpoint     Player         Gold flare +     0.8--1.5 s
                 activation     interacts      particles        

  C3-VFX-026     Chapter        Boss defeated  Seal burst /     2--4 s
                 completion                    fade             
  ----------------------------------------------------------------------------

------------------------------------------------------------------------

# 8. Enemy roster and actions

All enemies should have readable silhouettes, clear telegraphs, and
animation states separated from VFX. Enemy sprites need true
transparency and consistent pivots.

## C3-ENM-001 --- Temple Mite

-   Role: basic ground enemy.
-   Size: small; approximately half the player's height.
-   Actions: `idle`, `walk`, `turn`, `notice`, `hop_attack`, `hurt`,
    `knockback`, `death`.
-   Behavior: short patrol; hops toward player after a brief tell;
    recovers after landing.
-   Attacks: contact damage or short hop.
-   Weakness: vulnerable during landing recovery.
-   VFX: small dust puff on hop and hit spark on damage.
-   Animation request: 6--8 idle frames, 6 walk, 4 hop, 3 hurt, 5 death.
-   Suggested scene: `TempleMite.tscn` with `CharacterBody2D`,
    `AnimatedSprite2D`, `CollisionShape2D`, detection `Area2D`, attack
    `Area2D`.

## C3-ENM-002 --- Crystal Wisp

-   Role: floating ranged enemy.
-   Actions: `hover`, `patrol`, `aim`, `charge`, `projectile`, `hurt`,
    `death`.
-   Behavior: floats between points; charges a cyan projectile; pauses
    after firing.
-   Attacks: slow crystal bolt with visible travel path.
-   Weakness: vulnerable while charging / after shot.
-   VFX: core pulse, projectile trail, small death burst.
-   Animation request: 6 hover frames, 4 charge, 3 fire, 3 hurt, 6
    death.
-   Collision: small body collision; separate projectile hitbox.

## C3-ENM-003 --- Drowned Archive Keeper

-   Role: mid-tier melee enemy for flooded areas.
-   Actions: `idle`, `walk`, `swim`, `turn`, `windup`, `swing`,
    `recover`, `hurt`, `death`.
-   Behavior: patrols shelves; moves more slowly underwater; telegraphs
    a wide swing.
-   Attacks: short-range staff or blade swing.
-   Weakness: long recovery after miss.
-   VFX: water bubbles underwater; muted gold hit spark.
-   Animation request: 5 idle, 6 walk, 6 swim, 4 windup, 5 swing, 3
    recovery, 3 hurt, 6 death.

## C3-ENM-004 --- Drowned Sentinel

-   Role: heavy armored guard.
-   Actions: `idle`, `patrol`, `notice`, `shield`, `windup`, `slam`,
    `shockwave`, `recover`, `hurt`, `death`.
-   Behavior: slow patrol; blocks frontal attacks while shield is
    raised; slam creates a ground wave.
-   Attacks: shield bash and overhead slam.
-   Weakness: punish after a missed slam; jump over low shockwave.
-   VFX: dust, stone chips, shockwave ring.
-   Animation request: 5 idle, 6 walk, 4 shield, 4 windup, 6 slam, 4
    recovery, 3 hurt, 8 death.

## C3-ENM-005 --- Temple Eel

-   Role: underwater ambush enemy.
-   Actions: `idle_swim`, `patrol`, `hide`, `telegraph`, `lunge`,
    `retreat`, `hurt`, `death`.
-   Behavior: hides in a rock gap; shows a ripple before lunging.
-   Attacks: fast straight lunge; retreats after a miss.
-   Weakness: vulnerable after lunge.
-   VFX: bubbles, water streak, splash.
-   Animation request: 6 swim, 4 telegraph, 5 lunge, 4 retreat, 3 hurt,
    6 death.
-   Collision: separate hurtbox and lunge hitbox.

## C3-ENM-006 --- Shrine Warden

-   Role: elite enemy protecting the shrine.
-   Actions: `idle`, `patrol`, `raise_staff`, `beam`, `summon`, `hurt`,
    `stagger`, `death`.
-   Behavior: keeps distance; fires a slow, telegraphed beam; summons a
    small hazard only on a cooldown.
-   Attacks: beam sweep and a short summon.
-   Weakness: attack after the beam ends.
-   VFX: golden rune circle, beam, particles.
-   Animation request: 5 idle, 5 walk, 4 aim, 6 beam, 6 summon, 3 hurt,
    4 stagger, 8 death.

## C3-ENM-007 --- Guardian Knight (mini-boss)

-   Role: large armored melee boss in Guardian Hall.
-   Actions: `intro`, `idle`, `walk`, `shield_raise`, `slam_windup`,
    `slam`, `shockwave`, `stagger`, `phase_change`, `hurt`, `defeat`.
-   Phases: shielded advance; slam/recovery loop; faster double slam
    below 50% health.
-   Weak point: exposed after heavy attacks.
-   Required telegraph: weapon raised and floor glow before slam.
-   VFX: dust, ground crack, shockwave, core flash.
-   Animation request: 6 idle, 8 walk, 5 shield, 5 windup, 7 slam, 4
    recovery, 5 phase change, 4 hurt, 10 defeat.
-   Boss UI: health bar and phase state.

## C3-ENM-008 --- Sunken Guardian (final boss)

-   Role: final chapter boss.
-   Visual: large ancient aquatic guardian with stone armor, cyan-gold
    core, water-worn ornamentation.
-   Actions: `intro`, `idle`, `walk_or_float`, `trident_sweep_windup`,
    `trident_sweep`, `dash_windup`, `dash`, `bubble_summon`,
    `water_column_telegraph`, `water_column_attack`,
    `seal_beam_telegraph`, `seal_beam`, `core_exposed`, `stagger`,
    `phase_change`, `hurt`, `defeat`.
-   Phase 1: sweep, dash, bubbles.
-   Phase 2 at 70%: water columns and arena hazard pulses.
-   Phase 3 at 35%: faster combos and seal beam; core exposure after
    attacks.
-   Required readability: each attack uses a unique pose and clear
    warning effect; avoid attacks overlapping without safe space.
-   Animation request: separate sheets by animation family; do not try
    to fit the entire boss into one crowded sheet.
-   VFX: core glow, beam telegraph, water columns, shockwave, bubbles,
    defeat burst.
-   Boss UI: dedicated health bar, phase indicator, no clutter over the
    player.

## Enemy global animation and collision rules

-   Separate `hurtbox` from `attack_hitbox`.
-   Use animation events or explicit state timing for hitboxes; don't
    rely on the sprite's visual edge.
-   Avoid damage during the first frames of a telegraph.
-   Provide at least one punish window for every enemy attack cycle.
-   Boss damage must be disabled during intro, phase transitions, and
    defeat.
-   If enemies can enter water, specify swim animations and underwater
    speed separately.
-   Avoid background details that resemble enemy projectiles or attack
    telegraphs.

------------------------------------------------------------------------

# 9. Chests, loot, keys, and collectibles

## 9.1 Chest types

1.  **C3-CHEST-01 --- Common wooden chest:** bronze/gold trim, standard
    reward.
2.  **C3-CHEST-02 --- Submerged chest:** water stains, bubbles when
    opened.
3.  **C3-CHEST-03 --- Crystal chest:** crystal growths, cyan accent;
    optional route reward.
4.  **C3-CHEST-04 --- Locked relic chest:** ornate temple-gold trim;
    requires shrine puzzle or key.
5.  **C3-CHEST-05 --- Secret chest:** partially concealed behind
    waterfall or breakable wall.
6.  **C3-CHEST-06 --- Boss reward chest:** appears after Guardian Knight
    defeat.
7.  **C3-CHEST-07 --- Final reward chest:** optional post-boss reward;
    only include if the ending pacing supports it.

## 9.2 Chest states required

Every chest needs: - `closed` - `opening` - `open` - optional
`locked_idle` - optional `locked_reject` - optional `submerged_idle` -
optional `mimic_warning` only if a mimic mechanic is approved

Keep the chest base sprite separate from its sparkle/glow. The lid
should animate without the entire base shifting. Use a bottom-center
pivot or a hinge pivot for the lid.

## 9.3 Proposed chest placements

  --------------------------------------------------------------------------
  Chest ID       Screen         Route          Condition      Suggested
                                                              reward
  -------------- -------------- -------------- -------------- --------------
  C3-CHEST-01    S01-01         Main           Interact       Coins / common
                                                              resource

  C3-CHEST-02    S01-02         Optional       Short side     Golden
                                               ledge          Fragment

  C3-CHEST-03    S02-03         Optional upper Platforming    Upgrade
                                route                         material

  C3-CHEST-04    S02-04         Secret         Break crystal  Rare resource
                                               wall           

  C3-CHEST-05    S03-05         Main           Reach          Coins /
                                               submerged      fragment
                                               shelf          

  C3-CHEST-06    S03-06         Optional       Moving         Upgrade
                                               platform       material

  C3-CHEST-07    S04-07         Main, revealed Drain water    Temple Key
                                                              clue / reward

  C3-CHEST-08    S04-08         Secret         Break hidden   Rare relic
                                               wall           

  C3-CHEST-09    S05-09         Optional upper Jump route     Golden
                                route                         Fragment

  C3-CHEST-10    S05-10         Secret         Enter behind   Rare upgrade
                                               waterfall      

  C3-CHEST-11    S06-11         Main           Interact       Coins /
                                                              healing item

  C3-CHEST-12    S06-12         Puzzle reward  Solve mirrors  Relic upgrade

  C3-CHEST-13    S07-13         Main           Near           Healing /
                                               checkpoint     resource

  C3-CHEST-14    S07-14         Boss reward    Defeat         Guardian Key /
                                               mini-boss      bonus

  C3-CHEST-15    S08-15         Optional       Difficult side High-value
                                               route          reward
  --------------------------------------------------------------------------

The table contains 15 planned chest instances. These can reuse 3--5
chest visual variants; don't generate 15 entirely different chest
artworks.

## 9.4 Other interactables and collectibles

-   `C3-ITM-001` Golden Fragment: main chapter collectible.
-   `C3-ITM-002` Temple Key: opens the first major sealed gate.
-   `C3-ITM-003` Drainage Sigil: activates drainage machinery.
-   `C3-ITM-004` Guardian Key: earned from the mini-boss.
-   `C3-ITM-005` Sunken Seal: final chapter reward.
-   `C3-ITM-006` Health pickup: small glowing herb/orb.
-   `C3-ITM-007` Lore tablet: optional narrative.
-   `C3-ITM-008` Relic shard: optional upgrade currency.

## 9.5 Interaction behavior

-   Show an interaction prompt only when the player is in range and the
    object can currently be used.
-   Locked chest response should state the missing requirement in UI,
    not burn a large in-world label into the art.
-   Opened chest state should persist if the player leaves and returns.
-   Loot should spawn with a small upward bounce and then settle;
    auto-collect only if that is the game's established convention.
-   Use one standard interaction interface across chest, door, switch,
    checkpoint, shrine, and lore tablet.

------------------------------------------------------------------------

# 10. Environment asset inventory

The following is the generation backlog. Generate one item at a time,
then approve it before generating dependent variations. "Transparent"
refers to the export background, not the empty areas inside an object.

## 10.1 Backgrounds and parallax

  -----------------------------------------------------------------------
  ID                Asset             Output            Use
                                      requirements      
  ----------------- ----------------- ----------------- -----------------
  C3-BG-001         Far cavern        Wide 16:9 or      All sections
                    panorama          tileable strip;   
                                      no gameplay       
                                      objects           

  C3-BG-002         Distant submerged Transparent alpha S03, S08
                    ruins             layer             

  C3-BG-003         Distant waterfall Alpha overlay,    S01, S03, S05
                    layer             waterfall         
                                      separated from    
                                      rock              

  C3-BG-004         Crystal cavern    Alpha layer, no   S02
                    silhouettes       foreground        
                                      platform          

  C3-BG-005         Archive           Alpha layer,      S03
                    background        shelves and       
                                      arches            

  C3-BG-006         Gear chamber back Alpha layer, wall S04
                    wall              gears as separate 
                                      props where       
                                      animated          

  C3-BG-007         Shrine back wall  Alpha layer,      S06
                                      central door and  
                                      statues           

  C3-BG-008         Guardian hall     Alpha layer, tall S07
                    backdrop          statues and       
                                      torches           

  C3-BG-009         Temple core       Alpha layer,      S08
                    backdrop          giant seal and    
                                      distant columns   

  C3-BG-010         Underwater haze   Seamless alpha    S03, S08
                    overlay           texture or shader 
                                      input             

  C3-BG-011         Water caustics    Seamless          Water zones
                    texture           transparent       
                                      texture           

  C3-BG-012         Foreground        Alpha, large      Multiple sections
                    root/arch         elements isolated 
                    silhouettes                         
  -----------------------------------------------------------------------

## 10.2 Terrain, tiles, and platforms

  -----------------------------------------------------------------------
  ID                Asset             Output            Use
                                      requirements      
  ----------------- ----------------- ----------------- -----------------
  C3-TILE-001       Mossy stone       Tileable; crisp   Main terrain
                    platform top      walkable top edge 

  C3-TILE-002       Stone platform    Tileable side     Main terrain
                    middle            fill, no top      
                                      grass             

  C3-TILE-003       Stone platform    Tileable          Floating
                    underside         underside         platforms

  C3-TILE-004       Broken platform   Left/right        S01, S05
                    ends              variants          

  C3-TILE-005       Crystal cavern    Moss + cyan       S02
                    platform          crystal accents,  
                                      tileable          

  C3-TILE-006       Submerged stone   Dark wet stone,   S03
                    platform          tileable          

  C3-TILE-007       Ancient temple    Gold inlay,       S06--S08
                    floor             tileable          

  C3-TILE-008       Bridge plank      Repeatable        S01, S05
                    segment           segment           

  C3-TILE-009       Rope bridge left  Separate left end S01, S05
                    cap                                 

  C3-TILE-010       Rope bridge right Separate right    S01, S05
                    cap               end               

  C3-TILE-011       Stone stairs      Modular rise      S06, S08
                    segment                             

  C3-TILE-012       Wall collision    Visual atlas with All sections
                    tile atlas        matching grid     

  C3-TILE-013       Water surface     Tileable,         S03, S04, S08
                    strip             animated variants 

  C3-TILE-014       Deep water body   Repeatable or     S03, S08
                                      shader-based      

  C3-TILE-015       Crystal spike     Separate visual   S02
                    hazard            and collision     

  C3-TILE-016       Temple spike /    Separate visual   S06, S07
                    floor trap        and collision     

  C3-TILE-017       Breakable crystal Modular wall      S02, S04
                    wall              segment           

  C3-TILE-018       Cracked secret    Modular segment   S04, S05
                    wall                                

  C3-TILE-019       Decorative stone  Tile atlas        All sections
                    edge / corner set                   

  C3-TILE-020       Waterfall         Alpha sprite,     Multiple sections
                    collision-free    top/mid/bottom    
                    visual strip      pieces            
  -----------------------------------------------------------------------

## 10.3 Architecture and props

  -----------------------------------------------------------------------
  ID                Asset             Transparency /    Use
                                      states            
  ----------------- ----------------- ----------------- -----------------
  C3-PROP-001       Lantern post base Transparent; no   All
                                      baked halo        

  C3-PROP-002       Lantern flame     Transparent       All
                    animation         sprite sheet,     
                                      6--10 frames      

  C3-PROP-003       Lantern glass     Transparent       All
                    glow overlay      radial / glass    
                                      overlay           

  C3-PROP-004       Wall-mounted      Transparent; base All
                    lantern           separate from     
                                      flame             

  C3-PROP-005       Crystal cluster   Transparent; no   S02, S03
                    small             large baked glow  

  C3-PROP-006       Crystal cluster   Transparent;      S02, S08
                    large             separate glow     
                                      overlay           

  C3-PROP-007       Ancient stone     Transparent; no   S01, S06
                    pillar            ground shadow     
                                      baked if dynamic  

  C3-PROP-008       Broken pillar set Transparent; 3    S01, S05
                                      variants          

  C3-PROP-009       Temple arch       Transparent,      S01, S06, S08
                                      left/right or     
                                      full arch         

  C3-PROP-010       Rune door closed  Transparent;      S01, S08
                                      front-facing      

  C3-PROP-011       Rune door open    Matching frame,   S01, S08
                                      door leaf open    

  C3-PROP-012       Rune door         Transparent       S01, S08
                    activation        animated rune     
                    overlay                             

  C3-PROP-013       Temple statue     Transparent; no   S06, S07
                                      label             

  C3-PROP-014       Bronze gear small Transparent;      S04
                                      separate center   
                                      axle              

  C3-PROP-015       Bronze gear large Transparent;      S04
                                      separate center   
                                      axle              

  C3-PROP-016       Sluice gate       Transparent;      S04
                                      closed/open       
                                      states            

  C3-PROP-017       Water wheel       Transparent;      S04
                                      rotating center   

  C3-PROP-018       Pipe / drain      Transparent;      S04
                    outlet            water separate    

  C3-PROP-019       Hanging chain /   Transparent,      S02, S04
                    hook              modular           

  C3-PROP-020       Wooden crate      Transparent;      S01, S03
                                      intact/broken     
                                      states            

  C3-PROP-021       Temple sign /     Transparent;      S03, S06
                    carved tablet     blank of readable 
                                      text              

  C3-PROP-022       Broken statue     Transparent;      S05--S08
                    fragments         several sizes     

  C3-PROP-023       Mirror pedestal   Transparent;      S06
                                      mirror separate   

  C3-PROP-024       Rotatable mirror  Transparent, 4    S06
                                      orientation       
                                      states or one     
                                      sprite rotated in 
                                      Godot             

  C3-PROP-025       Beam receiver     Transparent;      S06
                    rune              inactive/active   

  C3-PROP-026       Boss seal         Transparent or    S08
                    platform          tile-based        

  C3-PROP-027       Floating stone    Transparent,      S02, S08
                    platform          separate          
                                      collision         

  C3-PROP-028       Moving platform   Transparent;      S02, S03, S06
                    body              clean edges       

  C3-PROP-029       Ladder segment    Transparent,      S02--S08
                                      tileable          

  C3-PROP-030       Vine climb        Transparent,      S02, S05
                    segment           tileable          
  -----------------------------------------------------------------------

## 10.4 Foliage and small environment details

  -----------------------------------------------------------------------
  ID                Asset             Output            Use
                                      requirements      
  ----------------- ----------------- ----------------- -----------------
  C3-DEC-001        Small moss tuft   Transparent       Platform tops

  C3-DEC-002        Hanging vines     Transparent       Arches and ledges
                    short                               

  C3-DEC-003        Hanging vines     Transparent       Foreground /
                    long                                platforms

  C3-DEC-004        Blue              Transparent; no   S02, S03
                    bioluminescent    baked aura        
                    mushrooms                           

  C3-DEC-005        Teal aquatic      Transparent       Water edges
                    plants                              

  C3-DEC-006        Yellow-green fern Transparent       Safe ledges

  C3-DEC-007        Root bundle       Transparent       Background /
                                                        foreground

  C3-DEC-008        Small rock        Transparent       Ground dressing
                    clusters                            

  C3-DEC-009        Water plants      Transparent; 2--3 S03, S08
                                      variants          

  C3-DEC-010        Floating leaves   Transparent,      Water
                                      animated optional 

  C3-DEC-011        Coral-like        Transparent       S02, S08
                    crystal plants                      

  C3-DEC-012        Foreground dark   Transparent,      Scene edges
                    foliage frame     low-detail        
                                      silhouette        
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 11. Character, enemy, chest, and puzzle asset inventory

## 11.1 Player and companion

  -----------------------------------------------------------------------
  ID                Asset             Required actions  Transparency
                                      / frames          
  ----------------- ----------------- ----------------- -----------------
  C3-CHR-001        Player idle       6--8 frames       True alpha

  C3-CHR-002        Player run        8 frames          True alpha

  C3-CHR-003        Player jump       4--6 frames       True alpha

  C3-CHR-004        Player fall       3--4 frames       True alpha

  C3-CHR-005        Player land       3--4 frames       True alpha

  C3-CHR-006        Player sword      3 attacks, 4--6   True alpha
                    combo             frames each       

  C3-CHR-007        Player hurt /     3--5 frames       True alpha
                    knockback                           

  C3-CHR-008        Player swim       6--8 frames       True alpha

  C3-CHR-009        Player death /    6--10 frames      True alpha
                    respawn                             

  C3-CHR-010        Fairy idle /      6--8 frames       True alpha
                    hover                               

  C3-CHR-011        Fairy follow /    5--8 frames       True alpha
                    dash                                

  C3-CHR-012        Fairy interact /  4--6 frames       True alpha
                    point                               
  -----------------------------------------------------------------------

Use the existing approved player and fairy design as the reference. Do
not redesign them for Chapter 3 unless requested. Generate swim-specific
animations only if the game supports underwater movement.

## 11.2 Enemy sprite generation queue

For each enemy below, create separate sheets by animation family, using
a consistent canvas size and bottom-center pivot for ground enemies;
floating enemies use a center pivot.

  -----------------------------------------------------------------------
  ID                      Enemy                   Required animation
                                                  families
  ----------------------- ----------------------- -----------------------
  C3-ENM-001              Temple Mite             idle, walk, turn,
                                                  notice, hop attack,
                                                  hurt, knockback, death

  C3-ENM-002              Crystal Wisp            hover, patrol, aim,
                                                  charge, projectile,
                                                  hurt, death

  C3-ENM-003              Drowned Archive Keeper  idle, walk, swim,
                                                  windup, swing, recover,
                                                  hurt, death

  C3-ENM-004              Drowned Sentinel        idle, walk, shield,
                                                  windup, slam,
                                                  shockwave, recover,
                                                  hurt, death

  C3-ENM-005              Temple Eel              swim, hide, telegraph,
                                                  lunge, retreat, hurt,
                                                  death

  C3-ENM-006              Shrine Warden           idle, walk, aim, beam,
                                                  summon, hurt, stagger,
                                                  death

  C3-ENM-007              Guardian Knight         intro, idle, walk,
                                                  shield, slam,
                                                  shockwave, recover,
                                                  phase change, hurt,
                                                  defeat

  C3-ENM-008              Sunken Guardian         intro, idle, move,
                                                  sweep, dash, bubble
                                                  summon, water column,
                                                  seal beam, exposed
                                                  core, phase change,
                                                  hurt, defeat
  -----------------------------------------------------------------------

Also generate separate transparent sprites for: - `C3-ENM-PRJ-001`
Crystal Wisp bolt. - `C3-ENM-PRJ-002` Shrine Warden beam impact / orb. -
`C3-ENM-PRJ-003` Temple Eel lunge trail. - `C3-ENM-PRJ-004` Guardian
Knight ground shockwave. - `C3-ENM-PRJ-005` Sunken Guardian water
column. - `C3-ENM-PRJ-006` Sunken Guardian seal beam. - `C3-ENM-PRJ-007`
Boss bubble projectile.

## 11.3 Chest asset queue

  -----------------------------------------------------------------------
  ID                      Asset                   Required states
  ----------------------- ----------------------- -----------------------
  C3-CHEST-ASSET-001      Common chest            closed, opening, open

  C3-CHEST-ASSET-002      Submerged chest         closed, bubbles,
                                                  opening, open

  C3-CHEST-ASSET-003      Crystal chest           closed, opening, open

  C3-CHEST-ASSET-004      Locked relic chest      locked idle, reject,
                                                  unlock, opening, open

  C3-CHEST-ASSET-005      Boss reward chest       appear, closed,
                                                  opening, open

  C3-CHEST-ASSET-006      Chest loot sparkle      loop and burst

  C3-CHEST-ASSET-007      Loot pickup bundle      coins, fragment,
                                                  upgrade material
  -----------------------------------------------------------------------

Chest body and lid should be separate where practical. Keep the base
stable while the lid rotates or lifts. Do not bake a strong glow around
the chest; use a separate optional glow effect.

## 11.4 Interactable asset queue

  ID           Asset                   States / behavior
  ------------ ----------------------- ---------------------------------------
  C3-INT-001   Pressure switch         idle, pressed, active
  C3-INT-002   Wall lever              up, pull animation, down
  C3-INT-003   Drain wheel handle      idle, turning, locked
  C3-INT-004   Rune socket             empty, fragment inserted, active
  C3-INT-005   Checkpoint lantern      inactive, activation, active
  C3-INT-006   Temple key pickup       idle float, pickup burst
  C3-INT-007   Drainage Sigil pickup   idle float, pickup burst
  C3-INT-008   Guardian Key pickup     idle float, pickup burst
  C3-INT-009   Lore tablet             intact; optional glow marker separate
  C3-INT-010   Breakable wall          intact, cracking, destroyed
  C3-INT-011   Mirror beam source      inactive, active
  C3-INT-012   Rune receiver           inactive, charging, active
  C3-INT-013   Boss gate               closed, unlocking, open

------------------------------------------------------------------------

# 12. UI and screen-space assets

UI should live on a `CanvasLayer` and remain unaffected by world lights.
Reuse the existing game's HUD style.

  -----------------------------------------------------------------------
  ID                      UI asset                Requirements
  ----------------------- ----------------------- -----------------------
  C3-UI-001               Chapter 3 objective     Dark teal panel, gold
                          panel                   trim; text rendered in
                                                  Godot

  C3-UI-002               Health HUD              Existing shared HUD,
                                                  not chapter-specific if
                                                  reusable

  C3-UI-003               Golden Fragment counter Transparent icon,
                          icon                    readable at small size

  C3-UI-004               Temple Key icon         Transparent icon

  C3-UI-005               Interaction prompt      Reusable; text rendered
                          frame                   dynamically

  C3-UI-006               Chest reward toast      Small transparent frame
                                                  or reusable UI panel

  C3-UI-007               Puzzle status           Inactive/active states
                          indicators              

  C3-UI-008               Boss health bar frame   Separate frame and fill

  C3-UI-009               Boss phase marker       Small icon or rune

  C3-UI-010               Chapter completion      Text and buttons built
                          panel                   with UI controls

  C3-UI-011               Pause menu additions    Chapter name and
                                                  objective summary

  C3-UI-012               Map/secret marker icons Start, exit, chest,
                                                  checkpoint, key, boss
  -----------------------------------------------------------------------

Do not generate UI images containing the full text of labels. Generate
frames and icons separately; use Godot `Control` nodes and fonts for
readable, localizable text.

------------------------------------------------------------------------

# 13. Godot implementation notes

## 13.1 Collision and gameplay shapes

-   Use `TileMapLayer` / tile physics for stable terrain.
-   Use simple collision shapes for chests, doors, switches, and
    pickups.
-   Use custom polygons only for unusual silhouettes or large boss
    bodies.
-   Keep enemy attack areas separate from body collision.
-   Make water a dedicated `Area2D` or equivalent trigger with an
    explicit gameplay state.
-   Make hazards separate from their decorative sprites so collision can
    be tuned without changing art.
-   Don't infer collision from transparent PNG bounds.

## 13.2 Interactable interface

All interactables should support the same basic contract: -
`can_interact(player) -> bool` - `interact(player) -> void` -
`get_prompt_text() -> String` - `get_persistent_state_key() -> String`

The player's interaction system should query nearby interactables,
select the closest valid target, show the prompt, and call the
interaction method on the interact button. Avoid each prop implementing
a different input scheme.

## 13.3 Persistent state

Store chapter state in a central save system: - opened chest IDs -
collected fragments and keys - switch states - water level state -
unlocked doors - solved shrine puzzle - checkpoint ID - boss defeat
state - chapter completion flag

Use stable IDs, not node paths, for persistent progress. Node paths can
change during refactoring.

## 13.4 Section transitions

-   Use explicit exit `Area2D` nodes and destination spawn markers.
-   Fade the screen before swapping sections if the transition is not
    seamless.
-   Pass the destination spawn ID, not a hardcoded global coordinate.
-   Preserve player health and inventory as intended.
-   Restore saved puzzle/chest states on scene entry.
-   Avoid re-trigger loops when a player appears inside an exit area.

## 13.5 Camera

-   Use one `Camera2D` per gameplay scene or a shared camera controller.
-   Set camera limits based on section bounds.
-   Use smoothing conservatively; it should not obscure jump timing.
-   For vertical shafts, allow vertical camera travel before the player
    reaches the top edge.
-   During boss fights, constrain camera movement to the arena.
-   Keep HUD in `CanvasLayer`.

------------------------------------------------------------------------

# 14. Audio cue list

  ID           Cue                     Trigger
  ------------ ----------------------- ---------------------------
  C3-AUD-001   Cavern ambience         All sections, low volume
  C3-AUD-002   Waterfall loop          Near waterfalls
  C3-AUD-003   Lantern crackle         Active lantern
  C3-AUD-004   Crystal hum             Crystal cluster nearby
  C3-AUD-005   Fragment pickup         Collect Golden Fragment
  C3-AUD-006   Chest open              Chest opens
  C3-AUD-007   Locked chest reject     Invalid chest interaction
  C3-AUD-008   Rune gate rumble        Door opens
  C3-AUD-009   Water splash            Enter/exit water
  C3-AUD-010   Underwater muffling     Player underwater
  C3-AUD-011   Drain mechanism         Gear puzzle activation
  C3-AUD-012   Switch click            Switch activated
  C3-AUD-013   Mirror beam hum         Beam active
  C3-AUD-014   Enemy telegraph         Enemy attack wind-up
  C3-AUD-015   Enemy hit / defeat      Enemy combat events
  C3-AUD-016   Guardian Knight roar    Mini-boss intro
  C3-AUD-017   Sunken Guardian intro   Final boss intro
  C3-AUD-018   Boss phase change       Health threshold reached
  C3-AUD-019   Boss core exposed       Weak point opens
  C3-AUD-020   Chapter complete        Victory state

------------------------------------------------------------------------

# 15. Asset generation prompt standard

Use this template for each individual request:

> Create **\[ASSET ID + NAME\]** for *Lanterns Underroot*, a painterly
> 2D fantasy side-scrolling platformer. Match the approved Chapter 3 art
> direction: deep teal-blue shadows, mossy stone, cyan crystal accents,
> warm amber lanterns, gold temple details, clean readable silhouettes.
> Output one isolated asset on a truly transparent background, no
> checkerboard, no text, no labels, no border, no watermark, no extra
> objects. Canvas/aspect: **\[specification\]**. Pivot:
> **\[bottom-center / center / hinge / top-left\]**. Required states or
> frames: **\[list\]**. Keep the silhouette, proportions, palette, and
> outline weight consistent with the existing game assets. Do not bake
> dynamic glow, cast shadows, or background scenery into the base sprite
> unless explicitly requested.

For sprite sheets, add: - "All frames have identical dimensions." -
"Frames are evenly spaced in a clean grid." - "No frame overlaps or
cropped effects." - "No frame numbers or labels." - "Keep the pivot
consistent across every frame." - "Return one animation family only."

For environment pieces, add: - "Designed to tile or connect cleanly with
neighboring modules." - "Walkable top edge must be horizontal and
readable." - "Do not paint collision outlines." - "Keep decorative
overhangs separate from the collision surface."

------------------------------------------------------------------------

# 16. Ordered generation backlog

Generate and approve in this order so later assets can match the
established scale and style.

## Phase A --- Style and scale lock

-   [ ] C3-REF-001: Chapter 3 color and material reference
-   [ ] C3-REF-002: Player scale reference beside a 64 px tile
-   [ ] C3-REF-003: Ground/platform tile style reference
-   [ ] C3-REF-004: Enemy scale reference sheet
-   [ ] C3-REF-005: Lantern and crystal lighting reference

## Phase B --- Playable terrain foundation

-   [ ] C3-TILE-001: Mossy stone platform top
-   [ ] C3-TILE-002: Stone platform middle
-   [ ] C3-TILE-003: Platform underside
-   [ ] C3-TILE-004: Broken platform ends
-   [ ] C3-TILE-012: Wall collision tile atlas
-   [ ] C3-TILE-019: Stone edge/corner set
-   [ ] C3-TILE-013: Water surface strip
-   [ ] C3-TILE-014: Deep water body

## Phase C --- Environment depth

-   [ ] C3-BG-001: Far cavern panorama
-   [ ] C3-BG-002: Distant submerged ruins
-   [ ] C3-BG-003: Distant waterfall layer
-   [ ] C3-BG-010: Underwater haze overlay
-   [ ] C3-BG-011: Water caustics texture
-   [ ] C3-BG-012: Foreground root/arch silhouettes

## Phase D --- Core props

-   [ ] C3-PROP-001: Lantern post base
-   [ ] C3-PROP-002: Lantern flame animation
-   [ ] C3-PROP-003: Lantern glass glow overlay
-   [ ] C3-PROP-004: Wall-mounted lantern
-   [ ] C3-PROP-005: Small crystal cluster
-   [ ] C3-PROP-006: Large crystal cluster
-   [ ] C3-PROP-007: Ancient stone pillar
-   [ ] C3-PROP-009: Temple arch
-   [ ] C3-PROP-010: Rune door closed
-   [ ] C3-PROP-011: Rune door open
-   [ ] C3-PROP-012: Rune door activation overlay
-   [ ] C3-PROP-014: Small bronze gear
-   [ ] C3-PROP-015: Large bronze gear
-   [ ] C3-PROP-016: Sluice gate
-   [ ] C3-PROP-017: Water wheel
-   [ ] C3-PROP-023: Mirror pedestal
-   [ ] C3-PROP-024: Rotatable mirror
-   [ ] C3-PROP-025: Beam receiver rune

## Phase E --- Chests and collectibles

-   [ ] C3-CHEST-ASSET-001: Common chest states
-   [ ] C3-CHEST-ASSET-002: Submerged chest states
-   [ ] C3-CHEST-ASSET-003: Crystal chest states
-   [ ] C3-CHEST-ASSET-004: Locked relic chest states
-   [ ] C3-CHEST-ASSET-005: Boss reward chest states
-   [ ] C3-CHEST-ASSET-006: Chest sparkle
-   [ ] C3-ITM-001: Golden Fragment
-   [ ] C3-ITM-002: Temple Key
-   [ ] C3-ITM-003: Drainage Sigil
-   [ ] C3-ITM-004: Guardian Key
-   [ ] C3-ITM-005: Sunken Seal
-   [ ] C3-ITM-006: Health pickup
-   [ ] C3-ITM-007: Lore tablet
-   [ ] C3-ITM-008: Relic shard

## Phase F --- Character and enemy production

-   [ ] C3-CHR-008: Player swim animation (if required)
-   [ ] C3-CHR-010: Fairy idle/hover
-   [ ] C3-CHR-011: Fairy follow/dash
-   [ ] C3-ENM-001: Temple Mite
-   [ ] C3-ENM-002: Crystal Wisp
-   [ ] C3-ENM-003: Drowned Archive Keeper
-   [ ] C3-ENM-004: Drowned Sentinel
-   [ ] C3-ENM-005: Temple Eel
-   [ ] C3-ENM-006: Shrine Warden
-   [ ] C3-ENM-007: Guardian Knight mini-boss
-   [ ] C3-ENM-008: Sunken Guardian boss
-   [ ] C3-ENM-PRJ-001 through C3-ENM-PRJ-007: projectiles and attack
    effects

## Phase G --- VFX and lighting

-   [ ] C3-VFX-001: Lantern flame loop
-   [ ] C3-VFX-002: Lantern sparks
-   [ ] C3-VFX-003: Crystal pulse
-   [ ] C3-VFX-004: Crystal shatter
-   [ ] C3-VFX-005: Fragment pickup
-   [ ] C3-VFX-006: Chest open burst
-   [ ] C3-VFX-007: Rune door activation
-   [ ] C3-VFX-008: Water splash
-   [ ] C3-VFX-009: Underwater bubbles
-   [ ] C3-VFX-010: Waterfall mist
-   [ ] C3-VFX-011/012: Water jet telegraph and burst
-   [ ] C3-VFX-013/014: Switch and gear activation
-   [ ] C3-VFX-016/017: Mirror beam and alignment burst
-   [ ] C3-VFX-018/019: Enemy hit and defeat
-   [ ] C3-VFX-020: Sword slash
-   [ ] C3-VFX-021/022/023/024: Boss attacks and core pulse
-   [ ] C3-VFX-025: Checkpoint activation
-   [ ] C3-VFX-026: Chapter completion

## Phase H --- Screen-specific set dressing

-   [ ] C3-BG-004: Crystal cavern backdrop
-   [ ] C3-BG-005: Archive backdrop
-   [ ] C3-BG-006: Gear chamber backdrop
-   [ ] C3-BG-007: Shrine backdrop
-   [ ] C3-BG-008: Guardian hall backdrop
-   [ ] C3-BG-009: Temple core backdrop
-   [ ] C3-TILE-005 through C3-TILE-011: section-specific platforms and
    bridges
-   [ ] C3-DEC-001 through C3-DEC-012: foliage and decoration
-   [ ] C3-PROP-018 through C3-PROP-030: remaining props and traversal
    pieces

## Phase I --- UI, audio, integration, QA

-   [ ] C3-UI-001: Chapter objective panel
-   [ ] C3-UI-003 through C3-UI-012: icons, prompts, boss UI, completion
    panel
-   [ ] C3-AUD-001 through C3-AUD-020: sound cues
-   [ ] Integrate scene transitions and persistent state
-   [ ] Test lighting with all assets in a representative scene
-   [ ] Test collision, camera bounds, enemy telegraphs, and chest
    persistence
-   [ ] Profile rendering and particle count
-   [ ] Verify chapter completion and save/reload behavior

------------------------------------------------------------------------

# 17. Definition of done

An asset is approved only when: - It matches the style reference and
scale. - It has correct transparency and no checkerboard. - The
silhouette reads at gameplay scale. - No essential detail is clipped. -
It is named using its asset ID. - It has a documented pivot and layer. -
Its dynamic glow/shadow is separate where required. - It imports cleanly
into Godot. - It has been tested in an actual scene, not only viewed in
isolation.

A section is approved only when: - The main route can be completed from
entrance to exit. - All required jumps are reachable and all falls are
intentional. - Enemies have readable telegraphs and fair recovery
windows. - Chests, keys, switches, and collectibles work and persist
correctly. - The player cannot get soft-locked by a door, moving
platform, water state, or puzzle. - Lighting supports visibility and
does not obscure hazards. - The camera does not reveal unfinished
edges. - Performance remains acceptable on the target hardware. -
Reloading the section preserves the intended progression.

------------------------------------------------------------------------

# 18. First asset to generate

Start with **C3-REF-002 --- Player scale reference beside a 64 px
tile**, then generate **C3-TILE-001 --- Mossy stone platform top** and
**C3-TILE-002 --- Stone platform middle**. These establish scale, ground
readability, palette, and tile seams before we generate the larger
environment, props, enemies, chests, and VFX.

**Important:** image generation is iterative. Generate one listed item
at a time, inspect it against the style and scale rules, approve it, and
then use that approved image as a visual reference for related items. Do
not generate the entire inventory in a single image sheet if individual
production assets are required.
