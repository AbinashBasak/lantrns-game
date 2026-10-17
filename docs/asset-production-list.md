# Lanterns Underroot — Complete Game Asset Production List

We'll build an original, production-ready 2D illustrated asset library for *Lanterns Underroot*, designed for Godot and playable on Android, iOS, and PC.

We'll generate the assets **one at a time**, approve each design, and then prepare it for use in the game. The concept-art board we generated earlier will serve only as visual inspiration; we won't use it directly as a game asset.

## 1. Production rules

Before creating individual assets, we'll follow these rules so everything looks like it belongs in the same game.

<box border radius="xl" padding={3} gap={3}>
  <row align="start" gap={3}>
    <AsyncImage query="original hand painted 2D fantasy platformer art style mossy stone ruins warm golden magical lantern teal blue forest atmospheric illustrated game art" aspectRatio="4:3" maxWidth="112px"/>
    <box flex="1" gap={1}>
      **Visual style**

      Hand-painted 2D illustrations, clear silhouettes, atmospheric backgrounds, warm lantern light, cool forest shadows, and consistent character proportions.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="isolated fantasy adventurer character turnaround front side back views blue hair red scarf leather tunic short sword clean game character concept sheet plain white background" aspectRatio="4:3" maxWidth="112px"/>
    <box flex="1" gap={1}>
      **Character consistency**

      Each character gets a model sheet first. All animations must retain the same face, clothes, equipment, proportions, and color palette.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="2D fantasy platformer modular mossy stone platforms grass edges root platforms separated individual game asset pieces transparent background" aspectRatio="4:3" maxWidth="112px"/>
    <box flex="1" gap={1}>
      **Game-ready files**

      Characters and props will be isolated PNGs with transparent backgrounds. Backgrounds will be separate layers, and animation sheets will use fixed frame sizes and documented frame order.
    </box>
  </row>
</box>

### Technical conventions

| Asset type | Starting specification |
|---|---|
| World tile size | 64 × 64 Godot units |
| Character animation frame | Standardized 192 × 192 or larger cells as needed |
| Environment backgrounds | Separate wide layers, generally 2048 px or wider |
| Character sprites | Transparent PNG |
| Props and effects | Transparent PNG |
| Animated sprites | Consistent frame dimensions, with a frame-order manifest |
| UI | Individual icons and scalable UI components |
| Naming | Stable asset IDs and descriptive filenames |

These are starting targets. We'll validate actual dimensions, pivots, cropping, and export settings as each asset is produced. Generated art may need cropping, transparency cleanup, and alignment before it's genuinely ready for Godot.

---

# 2. Complete asset inventory

This inventory covers the entire planned campaign, with the prototype assets clearly prioritized.

## Batch 00 — Art foundation

<badge color="success">Required first</badge>

| ID | Asset |
|---|---|
| ART-001 | Final visual style guide |
| ART-002 | Color palette and lighting reference |
| ART-003 | Character proportion and scale sheet |
| ART-004 | Environment material reference: soil, grass, stone, roots, wood |
| ART-005 | Magic, rune, glow, and particle style reference |
| ART-006 | Character and environment rendering consistency guide |

The mood board already created is a preliminary reference, not a replacement for these production specifications.

## Batch 01 — Main character: Tavi

<AsyncImage query="original fantasy action platformer young blue haired path runner red scarf short brown tunic leather boots small sword illustrated game character full body concept design" aspectRatio="4:3" width="100%" maxHeight={260} fit="contain"/>

### Character design

- [ ] TAVI-001 — Approved character model sheet: front, side, back and three-quarter views
- [ ] TAVI-002 — Color and material reference
- [ ] TAVI-003 — Sword design
- [ ] TAVI-004 — Standard sprite scale and pivot reference

### Core animations

- [ ] TAVI-010 — Idle
- [ ] TAVI-011 — Run
- [ ] TAVI-012 — Jump start
- [ ] TAVI-013 — Rising jump
- [ ] TAVI-014 — Falling
- [ ] TAVI-015 — Landing
- [ ] TAVI-016 — Sword attack
- [ ] TAVI-017 — Hurt reaction
- [ ] TAVI-018 — Death
- [ ] TAVI-019 — Interact with object
- [ ] TAVI-020 — Activate rune with sword
- [ ] TAVI-021 — Lantern reveal ability

### Future movement and combat animations

- [ ] TAVI-022 — Dodge or dash
- [ ] TAVI-023 — Second sword combo
- [ ] TAVI-024 — Charged attack
- [ ] TAVI-025 — Climbing
- [ ] TAVI-026 — Opening chest
- [ ] TAVI-027 — Victory
- [ ] TAVI-028 — Knockback and recovery

**Priority:** Model sheet, idle, run, jump, fall, land, sword attack, and hurt. The remaining animations can wait.

## Batch 02 — Companion: Mote

<AsyncImage query="original cute fantasy forest spirit creature tiny floating glowing ivory seed body cyan blue eyes tiny leaf ears soft magical glow illustrated game character isolated plain background" aspectRatio="1:1" maxWidth="220px"/>

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

Mote's shape and glow need to remain recognizable at small mobile-screen sizes.

## Batch 03 — Chapter 1 enemies and boss

<box gap={3}>
  <row align="start" gap={3}>
    <AsyncImage query="original small mossy root monster enemy concept art four legs glowing amber eyes fantasy forest game character isolated" aspectRatio="1:1" maxWidth="108px"/>
    <box flex="1" gap={1}>
      **EN-001 — Rootling**

      Model sheet, idle, patrol, attack, hurt, defeat.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="original fantasy game enemy thornwing flying insect creature reddish wings thorn body glowing eyes illustrated concept art isolated" aspectRatio="1:1" maxWidth="108px"/>
    <box flex="1" gap={1}>
      **EN-002 — Thornwing**

      Model sheet, hover, fly, dive attack, hurt, defeat.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="original fantasy platformer enemy small mushroom creature red spotted cap mossy body spore attack illustrated character isolated" aspectRatio="1:1" maxWidth="108px"/>
    <box flex="1" gap={1}>
      **EN-003 — Sporeling**

      Model sheet, idle, move, spore attack, hurt, defeat.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="original heavy fantasy forest monster bark armor thick root limbs glowing blue core illustrated 2D platformer enemy isolated" aspectRatio="1:1" maxWidth="108px"/>
    <box flex="1" gap={1}>
      **EN-004 — Brambleguard**

      Model sheet, idle, walk, heavy attack, stagger, defeat.
    </box>
  </row>
</box>

### Chapter 1 boss: Hollow Sentinel

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

We'll treat the Hollow Sentinel as the prototype's boss, consistent with the current development plan.

## Batch 04 — Environment packs

The game needs reusable background layers and terrain rather than one flattened image per level.

<box gap={3}>
  <row align="start" gap={3}>
    <AsyncImage query="wide hand painted 2D fantasy village built around enormous hollow ancient tree wooden homes hanging lanterns bridge forest dusk game environment" aspectRatio="4:3" maxWidth="124px"/>
    <box flex="1" gap={1}>
      **ENV-01 — Brackenreach village**

      Prologue environment: village skyline, hollow tree, wooden bridges, lantern-lit homes, foreground foliage, and distant forest.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="wide side scrolling hand painted fantasy forest trail moss covered cliffs giant roots broken stone arches waterfalls platformer game background" aspectRatio="4:3" maxWidth="124px"/>
    <box flex="1" gap={1}>
      **ENV-02 — The Forgotten Trail**

      Chapter 1: deep forest, broken watchtower, cliff crossings, roots, bridges, and hidden paths.
    </box>
  </row>
  <divider color="subtle"/>
  <row align="start" gap={3}>
    <AsyncImage query="wide illustrated ancient underground forest temple blue glowing runes moss covered stone platforms roots golden magical light 2D game environment" aspectRatio="4:3" maxWidth="124px"/>
    <box flex="1" gap={1}>
      **ENV-03 — The Ancient Root-Temple**

      Chapter 1: stone corridors, rune arch, puzzle chamber, treasure alcove, boss arena, and the golden fragment.
    </box>
  </row>
</box>

### Remaining campaign environments

- [ ] ENV-04 — Briarwake orchard
- [ ] ENV-05 — Glasswater Fen
- [ ] ENV-06 — Bellows Gorge
- [ ] ENV-07 — Archive Beneath the Earth
- [ ] ENV-08 — Root Cathedral
- [ ] ENV-09 — Stillmere, the village frozen in time
- [ ] ENV-10 — The Quiet Crown's final arena
- [ ] ENV-11 — Brackenreach after the restoration

Each environment pack will contain background layers, foreground layers, a tileset, environmental props, interactive objects, and location-specific visual effects.

## Batch 05 — Reusable terrain and tile sets

These assets are used to assemble actual levels in Godot.

- [ ] TILE-001 — Grass-topped ground tiles
- [ ] TILE-002 — Dirt and soil tiles
- [ ] TILE-003 — Stone platform tiles
- [ ] TILE-004 — Moss-covered rock tiles
- [ ] TILE-005 — Root platforms
- [ ] TILE-006 — Wood platforms and bridges
- [ ] TILE-007 — Left, right, top, bottom and corner edge variants
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

We will make these modular and seamless wherever necessary so you can build many levels without redrawing every section.

## Batch 06 — Props and interactive objects

### Village and forest props

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
- [ ] PROP-011 — Bush, flowers and mushrooms
- [ ] PROP-012 — Small tree and root clusters
- [ ] PROP-013 — Broken cart and abandoned equipment
- [ ] PROP-014 — Treasure chest

### Gameplay objects

- [ ] OBJ-001 — Checkpoint lantern
- [ ] OBJ-002 — Gold fragment collectible
- [ ] OBJ-003 — Rune switch
- [ ] OBJ-004 — Rune-activated door
- [ ] OBJ-005 — Hidden-platform rune marker
- [ ] OBJ-006 — Moving platform
- [ ] OBJ-007 — Falling platform
- [ ] OBJ-008 — Thorn hazard
- [ ] OBJ-009 — Spike hazard
- [ ] OBJ-010 — Breakable object
- [ ] OBJ-011 — Temple seal
- [ ] OBJ-012 — Level exit portal or doorway

Gameplay objects with moving parts will need animation and collision setup in addition to art.

## Batch 07 — Visual effects

- [ ] FX-001 — Sword swing trail
- [ ] FX-002 — Sword impact sparks
- [ ] FX-003 — Enemy hit flash
- [ ] FX-004 — Enemy defeat particles
- [ ] FX-005 — Dust from running
- [ ] FX-006 — Jump take-off puff
- [ ] FX-007 — Landing dust
- [ ] FX-008 — Falling debris
- [ ] FX-009 — Lantern light pulse
- [ ] FX-010 — Mote glow
- [ ] FX-011 — Rune activation
- [ ] FX-012 — Hidden platform reveal
- [ ] FX-013 — Collectible pickup
- [ ] FX-014 — Checkpoint activation
- [ ] FX-015 — Boss ground impact
- [ ] FX-016 — Boss core energy
- [ ] FX-017 — Boss phase transition
- [ ] FX-018 — Death and respawn effects
- [ ] FX-019 — Water ripples and splashes
- [ ] FX-020 — Magic projectile

## Batch 08 — User interface

We should assemble most screens inside Godot rather than generating complete screen designs as flat images.

### Main interface

- [ ] UI-001 — Heart or health indicators
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

### Menus and screens

- [ ] UI-016 — Main menu background
- [ ] UI-017 — Game logo
- [ ] UI-018 — Main menu buttons
- [ ] UI-019 — Pause menu
- [ ] UI-020 — Settings screen
- [ ] UI-021 — Level-loading screen
- [ ] UI-022 — Game-over panel
- [ ] UI-023 — Level-complete panel
- [ ] UI-024 — Save/checkpoint indicator
- [ ] UI-025 — Controller and keyboard prompts

## Batch 09 — Audio assets

Audio does not need image generation, but it is part of the complete production asset list.

**Sound effects:** running on grass, running on stone, jumping, landing, sword swing, sword impact, enemy attack, enemy defeat, player hurt, chest opening, collectible pickup, rune activation, checkpoint activation, door opening, boss attacks, boss damage, boss defeat, and UI selection.

**Ambient sounds:** Brackenreach night, village ambience, forest birds, wind in trees, cave drips, underground rumble, Glasswater Fen water, gorge bells, and the Quiet Crown's ambient soundscape.

**Music tracks:** main theme, village theme, forest exploration, temple exploration, boss battle, Stillmere, final boss, and ending theme.

We should use original or appropriately licensed sounds and music.

## Batch 10 — Later campaign-specific assets

These won't be produced for the prototype, but they're included in the master inventory.

| Chapter | Unique art and characters |
|---|---|
| Briarwake | Orchard foliage, Mossjaw, orchard root-stone |
| Glasswater Fen | Water reflections, Borrowed Faces, Glass Stag |
| Bellows Gorge | Cliff architecture, giant bells, Bellows Titan, Sable |
| Underground Archive | Forgotten documents, ancient machinery, buried village |
| Root Cathedral | Living root architecture, Keeper mechanisms, Sable's combat effects |
| Stillmere | Frozen villagers, memory effects, Quiet Crown forms |
| Epilogue | Restored village, new forest paths, changed lantern |

Each chapter will receive its own environment pack, major character assets, enemies, props, effects, music, and required UI.

## Batch 11 — Release assets

These are only required when we're preparing for external testing or release.

- [ ] RELEASE-001 — App icon
- [ ] RELEASE-002 — PC game capsule image
- [ ] RELEASE-003 — Store screenshots
- [ ] RELEASE-004 — Promotional key art
- [ ] RELEASE-005 — Loading-screen illustrations
- [ ] RELEASE-006 — Credits screen
- [ ] RELEASE-007 — Accessibility and control icon set

---

# 3. The actual generation order

We'll avoid creating hundreds of assets before we know whether the character and art style work in the game.

<box border radius="xl" padding={3} gap={3}>
  <row align="center" gap={3}>
    <box background="surface" border radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">01</title>
    </box>
    <box flex="1" gap={1}>
      **Tavi model sheet**
      <text color="secondary" size="sm">Lock character appearance before generating animation frames.</text>
    </box>
    <badge color="success">First</badge>
  </row>
  <divider color="subtle"/>
  <row align="center" gap={3}>
    <box background="surface-secondary" radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">02</title>
    </box>
    <box flex="1" gap={1}>
      **Tavi core animations**
      <text color="secondary" size="sm">Idle, run, jump, fall, land, sword attack and hurt.</text>
    </box>
  </row>
  <divider color="subtle"/>
  <row align="center" gap={3}>
    <box background="surface-secondary" radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">03</title>
    </box>
    <box flex="1" gap={1}>
      **Mote model sheet and animations**
      <text color="secondary" size="sm">Establish the companion design and key reactions.</text>
    </box>
  </row>
  <divider color="subtle"/>
  <row align="center" gap={3}>
    <box background="surface-secondary" radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">04</title>
    </box>
    <box flex="1" gap={1}>
      **First environment tileset**
      <text color="secondary" size="sm">Create reusable ground, platforms, roots and terrain transitions.</text>
    </box>
  </row>
  <divider color="subtle"/>
  <row align="center" gap={3}>
    <box background="surface-secondary" radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">05</title>
    </box>
    <box flex="1" gap={1}>
      **Enemies and Hollow Sentinel**
      <text color="secondary" size="sm">Build a minimum enemy roster and the prototype boss.</text>
    </box>
  </row>
  <divider color="subtle"/>
  <row align="center" gap={3}>
    <box background="surface-secondary" radius="md" padding={2} align="center" minWidth="60px">
      <title size="lg">06</title>
    </box>
    <box flex="1" gap={1}>
      **Level props, UI and effects**
      <text color="secondary" size="sm">Complete the playable environment and improve feedback.</text>
    </box>
  </row>
</box>

## 4. How we'll approve each asset

Every asset will go through four stages:

1. **Design:** Generate the initial original concept.
2. **Approval:** Check visual consistency, silhouette, readability and whether it fits the story.
3. **Production preparation:** Isolate the asset, clean the background, standardize dimensions and prepare animation frames if applicable.
4. **Integration:** Import it into Godot and verify scale, pivot, animation timing and collisions where relevant.

We will not treat a concept sheet as a complete sprite sheet. For example, Tavi's model sheet establishes the design; separate approved animation sheets provide the frames used by the game.

## Let's begin with asset 1

The first asset should be **TAVI-001 — the final character model sheet**. It will establish the definitive version of Tavi before we generate any animations, so all later assets can match it.

Once that design is approved, we can proceed to Tavi's idle animation, then running, jumping, falling, landing, and sword combat.