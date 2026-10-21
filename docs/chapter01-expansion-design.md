# Current behavior

The [mandatory route and Sentinel revival update](chapter01-combat-route-update.md) supersedes the optional-route and single-life boss descriptions below. Current tests and reward behavior are documented there.

# Chapter 1 exploration and combat expansion

The prologue remains the opening of the same journey. F5 starts Brackenreach and its eastern exit continues directly into Chapter 1. The chapter title also offers replay of the prologue.

## Exploration references

Team Cherry describes exploration with hidden shortcuts and treasures in its [Forgotten Crossroads tour](https://www.teamcherry.com.au/blog/the-forgotten-crossroads-a-hollow-knight-tour). The official [Hollow Knight site](https://www.hollowknight.com/) describes an interconnected world with discoveries away from the main path. [Ori's official site](https://www.orithegame.com/) describes a varied world built around platforming, new foes and painted scenery.

Our design inference is to add distinct routes with landmarks, optional discoveries and shortcuts, instead of increasing the length of an unchanged corridor. No artwork or maps from these games were copied.

## Health and attack feedback

The five hearts represent lives. Each life has 100 health shown in a green bar. Hits consume health before a life; a depleted bar costs one heart, refills for the next life and grants a brief invulnerability period. The final depleted bar triggers checkpoint recovery. Oversized attacks cost at most one life per hit. Checkpoints refill health. Enemy telegraphs provide a chance to move away before the damaging attack.

Rootling attacks deal 25, Sentinel swipes 40 and root waves 55 health damage. Generated sword frames play through anticipation, strike and recovery, with buffered follow-up input. Existing animation sources are preserved.

## New areas

- High Canopy: an elevated platform route branching from the early trail.
- Flooded Rootways: a lower route among water and stepping stones.
- Lantern Grove: a climb and shrine discovery near the temple approach.

The areas return to the Forgotten Trail and retain the chapter's rune puzzle, checkpoint, Sentinel and Golden Fragment. Discoveries are optional; the original route remains available. Progress is session-based. First-player duration, target-device performance and final animation/audio approval still require playtesting.

## Verification

All 144 source-project checks pass: 97 existing gameplay/regression checks, 13 health/combo checks, 11 new-enemy checks and 23 exploration checks. Tests include normal movement through the canopy climb and upper gap, a flooded floor gap, damage values, life depletion, encounter recovery and discovery persistence. Runtime asset validation verifies 479 source/output hash pairs. Human pacing and physical-device testing remain pending.

[Full test log](prologue-validation.txt) · [Canopy preview](chapter01-jungle-0-preview.png) · [Flooded roots preview](chapter01-jungle-1-preview.png) · [Grove preview](chapter01-jungle-2-preview.png)

The exported 65,889,404-byte content pack also passes the prologue, chapter, parallax, health, enemy and exploration suites from an empty project directory. Production sources remain excluded. Existing host log/keychain and inherited exit-cleanup warnings are retained in the [pack log](prologue-pack-validation.txt); no script errors or missing runtime resources were reported.
