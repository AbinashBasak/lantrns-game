# Chapter 3 completion audit — 2026-10-25

The root `lanterns_underroot_chapter_3_production_bible.md` and `docs/lanterns_underroot_chapter_3_production_bible.md` are byte-identical (SHA256 `403707c2bdbef1906b87b126ee6a89c99f5c06f7316f57840ccc6f25f083d158`). This audit read the master Downloads checklist, registry, memory, intake, all supplied-image review records and all 80 source-image titles. It visually inspected the locked map. No checklist approval is changed.

## Exact gameplay contract

| Section / beat | Mandatory progression and interactions | Optional content / encounter |
|---|---|---|
| S01 / 01 | Ground approach → raised fragment → stone arch; first main-route chest `C3_CHEST_01` | One low-threat Mite or no enemy; two unlit posts, statue |
| S01 / 02 | Examine rune gate; nearby fragment unlocks it once → S02 | Side-ledge `C3_CHEST_02`; pulse/burst native effects |
| S02 / 03 | Three ascending platforms → ladder/vine; safe lower crystal-spike telegraph | Horizontal Wisp; fragment above main path; high `C3_CHEST_03` |
| S02 / 04 | Crystal switch calls endpoint-stopping lift; upper arch → S03; Temple Key acquired before exit | One Wisp OR turret; breakable crystal wall → `C3_CHEST_04` |
| S03 / 05 | Shallow swim with safe surface return → submerged arch; land/underwater Keeper patrol | Two fragments, submerged shelf `C3_CHEST_05` |
| S03 / 06 | Two moving platforms over safe swim water; telegraphed jet; Drainage Sigil before exit → S04 | First-lift side platform `C3_CHEST_06`; aquatic enemy optional |
| S04 / 07 | A/B/C discoverable ordered switches drain chamber; passage opens persistently | Sentinel; revealed `C3_CHEST_07`; animated gears/waterline |
| S04 / 08 | Low tunnel / underwater pocket → S05; warned falling debris | Cracked wall → `C3_SECRET_01` / `C3_CHEST_08` |
| S05 / 09 | Broken rope-bridge span crossed via jump OR lower moving platform; upper route rejoins lower route | Mites OR Wisp; two upper fragments / `C3_CHEST_09` |
| S05 / 10 | Hidden arch behind waterfall → S06, readable collision edges | `C3_SECRET_02`, elite Mite and `C3_CHEST_10` |
| S06 / 11 | Short combat → raised switch/console explains light redirection | Two Mites OR one Wisp; `C3_CHEST_11` |
| S06 / 12 | Three discrete/resettable rotatable mirrors route source through three receivers; solve → gate S07 | Unlock relic `C3_CHEST_12`; reward must be defined |
| S07 / 13 | Safe `C3_CHECKPOINT_02`; inspect sealed arena door | Elite Sentinel; `C3_CHEST_13` outside arena |
| S07 / 14 | Guardian Knight shielded advance → slam/shockwave → recovery; below 50% double-slam + summon OR projectile; defeat grants Guardian Key → S08 | Broad floor, two safe platforms and hazard lane; victory `C3_CHEST_14` |
| S08 / 15 | Two vertical sequences; Guardian Key + required fragments open final seal; safe `C3_CHECKPOINT_03` | Difficult side-route `C3_CHEST_15` and optional final fragment |
| S08 / 16 | Sunken Guardian: sweep/dash/bubbles; below 70% columns/flood pulses; below 35% seal beam/faster combos; recovery exposes core; defeat grants Sunken Seal | Wide arena, two side ledges, safe landings; no overlapping unavoidable attacks |
| S08 / 17 | Victory → seal/settling-water animation → save → completion overlay → hub / Chapter 4 | Chest/completion counts |

All objects share `can_interact(player)`, `interact(player)`, `get_prompt_text()`, `get_persistent_state_key()`. Save stable chest/pickup/key/switch/water/gate/puzzle/checkpoint/boss/completion IDs. Section exits pass destination spawn IDs and preserve current hearts/vitality; no entry trigger loops. HUD remains CanvasLayer and retains current health art. Physical water must be Area2D with explicit swim state, not just a tinted texture.

## Map and traversal coordinates

The locked map is a 1942×809 illustrated topology board with eight unequal panels, not a world-coordinate diagram. It establishes routes: S01 ground/short upper loop; S02 ascending shelves/lift plus water lower route; S03 above/below-water routes and lifts; S04 switches → lower drained exit; S05 rejoining upper/lower bridges and waterfall secret; S06 vertical shrine/lifts; S07 approach → arena; S08 vertical seal approach → boss → aftermath. Exact world coordinates cannot honestly be read from its pixels. Terrain must be authored against actual player metrics and the topology, then traversed in-engine.

Current player speed330, jump 680, gravity 1600 gives an ideal full-hold apex144.5 units and same-height flight0.85 s / horizontal280.5 units (instant-speed theoretical bound). Acceleration2300 reduces real distance; early release reduces jump height. Suggested first-pass safe geometry is <=96 unit rises and <=160–192 unit open gaps, landings>=96 units; these are audit recommendations, not locked authored coordinates or bible mandates. All mandatory routes must be verified with actual controller. A scaffold is not traversal proof.

## Available originals versus production deliverables

- 34 supplied PNGs:32 new originals+2 duplicates. All already archived unchanged. Supplied hero14 includes actions but painted checkerboard RGB; run19 is alpha but overlapping/clipped poses. Existing shared runtime player scene remains the coherent current campaign actor; blue C3 revision requires proper clean exports.
- Chest source `assets/production/chapter_03_sunken_temple/chests/C3-CHEST-ASSET-001/source_images/C3-CHEST-ASSET-001_opening_msg_261_000000006bf082088cf88cc37cce9e7a.png`; review runtime copy `art/export/chapter_03/review/C3-CHEST-ASSET-001_opening_review_source.png` and native chest review scene. Six isolated opening crops exist; base includes painted glow and needs production review.
- Mite originals under `assets/production/chapter_03_sunken_temple/enemies/C3-ENM-001/source_images/`:idle281,walk289,attack298,hurt304,death313 plus attached variants. Idle variant differs; walk has painted checkerboard, attack is slam while bible requires hop. Do not rename slam as hop.
- Wisp `C3-ENM-002/source_images/`:hover319,attack325,hurt334,death339. Selected alpha cleanup/frame pivot/effect separation pending.
- Keeper `C3-ENM-003/source_images/`:idle347,glide353,attack359,hurt365,death371. Floating mage art conflicts with bible melee/swim behavior; do not add unrequested flight/spells.
- Sentinel `C3-ENM-004/source_images/`:idle377,walk384,attack393,hurt399. Attack RGB opaque; defeat/shield/recovery families absent.
- No standalone `C3-BG-*`, `C3-TILE-*`, `C3-PROP-*`, `C3-ARCH-*`, `C3-ENM-005/006/007/008` or final boss art exists in registry or runtime/export inventory. All 80 chat image titles were checked: environment entries are concept/map/atlas/scale boards, then heroes/chests/Mites/Wisp/Keeper/Sentinel. No missing source image can be presumed modular terrain or bosses.
- Previous-chapter runtime stone/forest tiles, forestbackgrounds and HollowSentinel/Mossjaw art exist; these are unrelated chapter designs and are not Chapter3 substitutions. Reference board miniature tiles or flattened maps cannot be enlarged into finished C3 terrain.
- Native reusable lights, particles, radial light texture, editable actor state graphs and Godot shaders do not depend on new raster art and can be completed now. They do not supply missing architectural illustrations or attack poses.

Additional local guide `/Users/abinashbasak/Downloads/C3-BG-008-LGT-001_Godot_Setup_Guide.txt` describes S06 golden ShrineVFX separately from architecture: independent core/rays/particles, PointLight2D and AnimationPlayer. It explicitly says a combined infographic is reference only and heat/depthmaps are not normal maps. No corresponding standalone PNGs were found.

## Decisions still not encoded by the references

1. Locked map prints 31 chests while bible specifies 15 planned instances; preserve bible's stable 15 IDs without claiming copied map counts.
2. Locked map shrinelegend says final key, whereas bible assigns Guardian Key to hall mini-boss; follow bible's explicit progression unless user changes it.
3. Temple Key exact S02 pickup and Drainage Sigil exact S03 pickup positions are unspecified; choose readable main route placement during validated authoring and document it.
4. Three-switch order, mirror discrete orientations, shrine relic reward and final fragment requirement are unspecified. Expose as editable configuration, avoid silently hardcoding invented locked values.
5. Missing environment/boss art is a production dependency. Completing native common mechanics and remaining old campaign warning/teardown fixes is authorized useful work. Finished C3 levels cannot truthfully be claimed until this dependency is resolved.
