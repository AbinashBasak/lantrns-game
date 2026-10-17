# Lanterns Underroot
## Prologue + Chapter 1: Development-Ready Level Plan

**Document purpose:** Turn the opening of the story into a buildable 2D illustrated action-adventure prototype for Godot.

**Target platforms:** Android and Windows PC first; architecture should remain portable to iOS, macOS, and Linux.

**Visual direction:** Hand-painted 2D environments, readable silhouettes, warm amber lantern light against cool forest greens and blue shadows.

**Prototype target:** Approximately 8–12 minutes on a first playthrough. Keep the main route shorter during early tests; optional discoveries can extend it.

**Engine assumption:** Godot 4.x stable, GDScript. Confirm the installed stable version when implementation starts and keep the project pinned to it for the prototype.

---

# 1. Prototype goals

The first build must prove five things before the project expands:

1. Running, jumping, landing, and camera movement feel reliable on PC and mobile.
2. Sword combat is understandable and satisfying even with placeholder art.
3. The world communicates story through environment and short interactions, not long exposition scenes.
4. One small puzzle can be understood without a tutorial wall of text.
5. The player can finish the slice, receive the first Golden Fragment, and understand why the journey continues.

## Out of scope for this slice

Do not build a full inventory, equipment screen, skill tree, multiple weapons, shops, quest log, dialogue-choice system, procedural levels, cloud saves, crafting, or a large open world. Keep the story-critical mapbook as a simple UI page or a lightweight collectible log if needed.

## Narrative guardrails

- Tavi is an ordinary path-runner, not a chosen one or a hidden royal heir.
- Mote communicates using taps and gestures. It does not speak human dialogue.
- The Hearthlight protects Brackenreach by holding nearby paths still, but this truth is not fully explained yet.
- Chapter 1 should create questions; it must not reveal the full history of Stillmere or the Quiet Crown.
- The first chapter’s guardian is a **Hollow Sentinel**, a small temple warden. It is not the Mossjaw boss from Chapter 2.

---

# 2. Opening sequence: Prologue — The Night the Light Went Out

## Purpose

Introduce the village, Tavi’s practical personality, Mote’s unusual tapping pattern, the Hearthlight failure, and the first reason to leave home. The sequence should move quickly from peaceful exploration to a dangerous, changed world.

**Target duration:** 3–4 minutes, including the first small combat encounter.

## Sequence overview

| Beat | Location | Player activity | Narrative purpose | Estimated time |
|---|---|---|---|---:|
| P1 | Brackenreach lane | Move, jump over a low obstacle, talk to one villager | Establish normal life and controls | 30–45 sec |
| P2 | Lantern Wake square | Walk around the festival and inspect the Hearthlight | Show the village’s dependence on the lantern | 30 sec |
| P3 | Outer bridge | Help a villager and return toward the square | Give Tavi a practical, helpful motivation | 20–30 sec |
| P4 | Village square | Short non-interactive event: Hearthlight fails | Inciting incident | 20–30 sec |
| P5 | Fallen beam by the hollow tree | Free Mote and avoid a simple hazard | Introduce companion and rhythm | 30–45 sec |
| P6 | Broken village lane | Defeat two Thornlings | Teach attack, damage, and recovery | 45–60 sec |
| P7 | Elder’s shelter | Speak to Rusk and receive the worn sword/mapbook | Establish the goal and launch the journey | 45–60 sec |

## P1 — Brackenreach lane

**Environment:** A safe horizontal path through the lower village. Use a hollow-tree trunk, hanging lanterns, wooden walkways, cloth banners, and layered forest silhouettes. Keep the background decorative; no jump should be required before the player has control.

**Gameplay:**
- Spawn Tavi on a broad, flat platform.
- Show a compact control hint: “Move” and “Jump”. Hide each hint after the action is performed once.
- Place one small gap or raised log that teaches jumping without punishing failure.
- Place a signpost that can be inspected but is optional.

**Optional villager interaction:**

**Villager:** “The eastern trail changed again. It used to curve beside the birch tree.”

**Tavi:** “I marked it yesterday. I’ll check the markers when the festival is over.”

This establishes Tavi’s habit of mapping routes. Keep the dialogue skippable and display it in short lines.

## P2 — Lantern Wake square

The player can walk around the square and inspect two objects:

- **Hearthlight:** “The villagers say its glow keeps the old paths from changing.”
- **Tavi’s mapbook:** “A map is useful only while someone checks the trail.”

Do not introduce the full lore here. The festival should feel warm, ordinary, and lived-in. Use a small number of animated props rather than trying to animate every villager.

## P3 — Outer bridge

A villager calls Tavi back after a handcart blocks a narrow bridge. The player walks to the cart and interacts to move it. This is a tiny optional-feeling task, but keep it on the required route so the player learns the interact button.

**Villager:** “Thank you. You always know where a path ought to lead.”

**Tavi:** “Only because I keep checking.”

The line quietly foreshadows that the old paths are about to become unreliable.

## P4 — The Hearthlight fails

When Tavi returns to the square, temporarily take movement control and play a short sequence:

1. Ambient village sound fades.
2. Birds stop calling; hanging leaves and cloth become still.
3. Hearthlight shifts from warm gold to harsh white and flickers twice.
4. A deep pulse shakes the screen gently; a few floorboards crack.
5. The light goes out. Roots force their way through the square and distant paths visibly rearrange.
6. Control returns to the player.

**Important production note:** Keep the event under 25 seconds. Use camera framing, layered sound, a brief white-light shader, particles, and a few animated props. Avoid a long cinematic that requires bespoke animation.

The event should not cause player damage. This is a story beat, not a surprise death.

## P5 — Mote beneath the beam

A fallen beam blocks a small path toward the hollow tree. Behind it is a root-creature struggling to get free.

**Interaction prompt:** “Move the beam”. Tavi moves it in a short animation. Mote slips out and taps the ground:

**SFX rhythm:** three slow taps, a pause, two quick taps.

Mote then walks several steps toward a cracked patch of ground and looks back. Do not make Mote explain the plot. Its behavior should make the player curious.

For the prototype, Mote can be a simple animated companion that follows at a fixed distance, pauses near interaction points, and occasionally taps. Advanced companion AI is not required.

## P6 — First combat: two Thornlings

Two small Thornlings emerge from a damaged root bed in a wide, safe lane. Introduce only one enemy at a time at first:

1. The first Thornling approaches slowly and makes a clearly telegraphed short-range attack.
2. A brief hint appears: “Attack”.
3. The second arrives after the first has taken damage or been defeated.

The player can retreat. Do not lock the player in an arena during this first fight.

**Thornling behavior:**
- Idle until Tavi enters detection range.
- Approach at walking speed.
- Pause and telegraph before attacking.
- Attack once, then recover briefly.
- Take knockback and flash or play an impact animation when hit.
- Disappear or collapse into a small burst of leaves when defeated.

The encounter should communicate that some creatures are dangerous without implying they are a coordinated invading army.

## P7 — Rusk and the journey

Rusk shelters near the village’s old storage alcove. A few background villagers are visible but should not require dialogue systems.

**Rusk:** “The paths beyond the village are moving. If the Anchors fail, we may lose every safe road around Brackenreach.”

**Tavi:** “Then tell me where to start.”

**Rusk:** “Find the old trail-warden’s sword. Follow the markings to the first root-temple. Bring back whatever still answers the light.”

Rusk gives Tavi a worn sword and a mapbook. He does not tell Tavi the full truth because he does not know it.

**Tavi:** “And if the old stories are wrong?”

**Rusk:** “Then come back with something better than a story.”

This is the transition into Chapter 1. The objective appears: **Reach the Forgotten Trail**.

---

# 3. Chapter 1 — The Forgotten Trail

## Chapter purpose

Teach the core movement-and-combat loop, introduce environmental storytelling, give the player one small secret to discover, and end with a memorable temple encounter and the first Golden Fragment.

**Target duration:** 5–8 minutes. The complete prologue plus chapter should fit inside a short first-session prototype.

## Chapter objectives

### Main objectives
1. Reach the old trail marker.
2. Cross the broken route.
3. Investigate the ancient stone arch.
4. Find the root-temple entrance.
5. Defeat the Hollow Sentinel.
6. Collect the first Golden Fragment.

### Optional objective
- Find the hidden trail token behind the ruined watchpost.

The optional objective rewards curiosity but must not block progress.

## Level flow

Build this as one connected level scene with several camera regions or soft boundaries. Use a clear main route and a small number of alternate ledges.

```text
[Village Exit]
     |
     v
[A. Old Trail Marker] ---- [Optional: Watchpost Token]
     |
     v
[B. Broken Roots: Jump Tutorial]
     |
     v
[C. Thornling Encounter]
     |
     v
[D. Ancient Arch: Rune Puzzle]
     |
     v
[E. Root-Temple Entrance]
     |
     v
[F. Sentinel Chamber + Checkpoint]
     |
     v
[G. Hollow Sentinel Encounter]
     |
     v
[Golden Fragment + Chapter End]
```

## Suggested level proportions

Use proportions rather than hard-coded pixels until the character scale and camera zoom are chosen.

- Village exit and trail marker: 10% of the route.
- Basic platforming: 20%.
- Combat and recovery space: 15%.
- Rune puzzle and arch: 15%.
- Temple approach: 10%.
- Checkpoint and boss chamber: 20%.
- Reward and exit: 10%.

Keep each main path visually legible. Decorative background ledges should not look reachable if they are only artwork.

---

# 4. Chapter 1 encounter-by-encounter plan

## A. The old trail marker

**Purpose:** Transition from the village’s warmth into a forest that no longer obeys its map.

**Visuals:** The first signpost points toward Brackenreach, but the trail beyond it appears to twist around an exposed root. Add one broken route marker and a stone engraved with an unfamiliar symbol.

**Player actions:** Walk, jump a simple gap, inspect the marker.

**Environmental line:**

> “Trail marker 12. The path should continue east. The ground disagrees.”

This can appear as a short mapbook note after interaction. No journal UI is needed if implementation time is tight; a text popup is sufficient.

**Exit condition:** Player reaches the first raised root platform.

## B. Broken Roots — platforming tutorial

**Purpose:** Teach jumping over gaps and landing on stable platforms.

**Layout:**
- One wide starting platform.
- One low gap that can be crossed with a normal jump.
- A wider gap with a lower safe ledge beneath it.
- A short climb using two or three root platforms.
- One optional elevated ledge holding the trail token.

Never make a required jump depend on pixel-perfect movement during the tutorial. The player should have space to build momentum and see where they will land.

**Failure recovery:** If the player falls, respawn at a nearby stable ledge or at the start of this segment. Do not send the player back to the village for a minor platforming mistake.

**Design test:** On mobile, a player should be able to make the required jumps while using virtual controls without covering the landing area with their thumb.

## C. Thornling encounter

Place one Thornling on a broad platform with no pit directly behind the player. After the player understands its attack, place a second Thornling on the far side of the next safe platform.

**Optional enemy line through environmental storytelling:** The Thornling pauses near a cracked root before attacking. This is a tiny animation cue suggesting it is distressed rather than malicious.

**Combat tuning starting point — placeholders only:**
- Player health: 5 hearts or 100 health points; choose one representation and use it consistently.
- Player sword: 1 clear hit to a weak basic enemy should make progress visible; roughly 3–4 hits to defeat a standard Thornling is a reasonable first tuning pass.
- Enemy attack: Telegraph for long enough that a new player can react. Start around 0.6–0.9 seconds, then tune through playtesting.
- Damage feedback: brief hit flash, light knockback, distinct sound, and health UI feedback.

These values are starting hypotheses, not final balance. Test with keyboard and touch controls.

## D. Ancient arch — the first environmental puzzle

**Story purpose:** Show that the damaged sword responds to ancient markings and that the forest contains mechanisms older than the village’s traditions.

**Visual setup:** A stone arch spans a gap. Three rune stones sit near the base. The arch’s central path looks empty, but faint light can be seen passing through it when Mote taps.

**Puzzle sequence:**
1. Player inspects the three rune stones.
2. Mote taps the ground beside them in a rhythm: three slow taps, pause, two quick taps.
3. The player activates the stones in that rhythm.
4. The arch reveals a temporary series of translucent root platforms.
5. The player crosses while the platforms remain visible.

**Hint ladder:**
- First hint: Mote looks toward the first rune.
- Second hint after a short delay: the correct rune pulses gently.
- Final hint if the player repeatedly fails: display the rhythm using simple dots or a brief icon sequence.

Do not require the player to memorize audio alone. Include visual timing cues, particularly for players playing without sound.

**Incorrect input:** Reset the sequence gently. Do not damage the player or spawn enemies as punishment.

**Completion feedback:** The sword glows amber for a moment; the arch opens, and Tavi records the clue: “The sword knows this place.”

## E. The root-temple entrance

The forest gives way to stonework that appears to have grown around a living root rather than being built around an ordinary tree.

**Environmental storytelling:**
- Carvings show four stones surrounding a central lantern.
- In a damaged panel, figures seem to be holding roots in place.
- The final part of the panel has been deliberately scraped away.

**Optional inspect text:**

> “These people are holding something back. Or holding something still.”

This line should prompt a question rather than explain the truth.

**Audio:** Reduce birds and wind. Introduce a low, slow pulse that subtly grows louder near the temple chamber.

## F. Checkpoint room

Before the final encounter, the player enters a small chamber with a dormant root-mark on the wall and a broad stone platform.

**Checkpoint interaction:** Tavi touches the mark; it glows softly and creates a save point. The player can restart from here after defeat.

For the prototype, checkpoint persistence only needs to last for the current session unless saving progress becomes a defined requirement. However, the checkpoint state and respawn behavior should be implemented separately from the UI.

Place no collectible that requires defeating the boss again after a checkpoint reload.

## G. Boss: Hollow Sentinel

**Role in story:** An old temple guardian whose purpose is to protect the root-temple from intrusion. It is not the main villain and should not be killed as an act of revenge. The encounter tests the player’s new skills and hints that the temple’s old defenses are malfunctioning.

**Arena:** A single screen or a screen and a half wide, with a flat combat floor and two low platforms at the edges. Avoid deep pits. The player should be able to focus on attack patterns rather than difficult traversal during this first boss.

**Appearance:** A compact stone-and-root figure with a cracked chest plate and a dim amber core. Its silhouette must remain distinguishable from the background. Use warm light for its core and cool shadows for its stone body.

### Attack pattern

**Phase 1 — Wake:**
- The Sentinel rises from a kneeling pose.
- It performs a slow forward swing with a clear wind-up.
- The player can jump over the attack or retreat.
- After missing, the Sentinel pauses briefly, allowing the player to attack.

**Phase 2 — Root sweep:**
- At roughly half health, the Sentinel raises one arm.
- Roots emerge from the floor after a visible ground warning.
- The player moves to a safe part of the arena, then attacks during the recovery window.

**Finisher — Exposed core:**
- At low health, the Sentinel’s core flickers, and its attacks become slower rather than simply faster.
- The player lands the final hits.
- The Sentinel kneels and lowers its weapon. It disassembles into roots and stone fragments rather than exploding violently.

### Fairness requirements

- Every attack has a readable visual tell.
- Do not launch an attack while the player is still recovering from an unavoidable hit.
- Provide a short invulnerability window after the player takes damage to prevent rapid repeated hits.
- The Sentinel should not track the player instantly during an attack.
- If the player dies, respawn them at the checkpoint outside the boss chamber and let them re-enter quickly.

### Starting tuning values

Use relative tuning before committing to exact health values:
- The boss should take approximately 20–35 successful sword hits in an early prototype, depending on how many attack opportunities each cycle creates.
- A typical telegraphed attack should remove a manageable portion of player health, not defeat a full-health player in one hit.
- The first successful clear should plausibly occur within 1–3 attempts for a player who understands the controls.

These are playtest targets, not strict balance requirements.

## H. First Golden Fragment

When the Sentinel falls, the chamber becomes quiet. Its amber core rises from the broken shell and transforms into a small golden fragment.

Tavi approaches it. The sword markings glow; a short memory appears above the floor.

**Memory image:** A bright orchard filled with blossoms. Travellers gather beneath the trees while the paths between them remain open. The memory fades before Tavi can see who created it.

**Tavi:** “This was never a weapon.”

**Mote:** Three slow taps. A pause. Two quick taps.

**Tavi:** “You’ve heard this before, haven’t you?”

Mote looks toward a newly visible passage but does not answer.

**Mapbook entry:** “First fragment recovered. The temple reacted to the sword. A fixed road may not be the same thing as a safe road.”

The player receives the **First Golden Fragment**. For the prototype, it can be a simple quest item represented by an icon; no inventory grid is required.

The passage opens toward deeper forest. Show a brief glimpse of twisted orchard trees in the distance, establishing the next destination: **Briarwake**.

**Chapter-end title:** “The Forgotten Trail — Complete”.

---

# 5. Dialogue and delivery rules

Keep dialogue short and attached to player actions. Each line should do at least one of the following: reveal character, explain an immediate interaction, create a question, or reward discovery.

- Make all dialogue skippable.
- Avoid long text over active combat.
- Use a maximum of 1–3 short lines per interaction during the prototype.
- When a clue is important to completing a puzzle, show a visual hint in addition to dialogue.
- Do not add dialogue choices yet; they add scope without helping prove the core game loop.
- Keep subtitles visible long enough to read on a phone screen.

## Text and localization readiness

Store dialogue in resources or a simple keyed data file rather than hard-coding every line directly into level scripts. This makes future editing and localization easier, but avoid building a complex narrative framework now.

---

# 6. Art and audio asset checklist

## Minimum art set

### Character and enemies
- Tavi: idle, run, jump/rise, fall, land, sword attack, hurt, death/knockdown, interact.
- Mote: idle, move, tap, follow, react to puzzle, hide or retreat.
- Thornling: idle, move, telegraph, attack, hurt, defeat.
- Hollow Sentinel: wake, idle, forward swing, root sweep, recovery, hurt, defeat.

### Environment
- Brackenreach: modular floor, wooden bridge, hollow tree, 2–3 background layers, hanging lanterns, a few looping ambient props.
- Forgotten Trail: ground tiles, stone blocks, roots, vines, log platforms, trail marker, watchpost, arch, rune stones.
- Root-temple: walls, floor, carved panels, checkpoint mark, boss arena pieces, fragment pedestal.
- Effects: dust, jump puff, sword trail, impact burst, leaves, glowing rune, amber fragment glow.

## Minimum audio set
- Village ambience and forest ambience.
- Music for the calm village and a restrained exploration theme.
- Hearthlight failure pulse and root movement.
- Jump, land, sword swing, sword impact, player damage, enemy telegraph, enemy defeat.
- Rune activation and puzzle completion.
- Checkpoint activation, boss wake, boss attacks, boss defeat, fragment reveal.

Use original or properly licensed assets. Record the source and license of each external asset in `docs/asset-licenses.md`.

---

# 7. Godot implementation blueprint

## Scene suggestions

```text
scenes/
├── main/
│   └── main.tscn
├── levels/
│   ├── prologue_brackenreach.tscn
│   └── chapter_01_forgotten_trail.tscn
├── player/
│   └── player.tscn
├── companions/
│   └── mote.tscn
├── enemies/
│   ├── thornling.tscn
│   └── hollow_sentinel.tscn
├── interactables/
│   ├── interactable_base.tscn
│   ├── checkpoint.tscn
│   ├── rune_stone.tscn
│   └── golden_fragment.tscn
└── ui/
    ├── hud.tscn
    ├── dialogue_box.tscn
    ├── touch_controls.tscn
    └── pause_menu.tscn
```

## Suggested player node tree

```text
Player (CharacterBody2D)
├── CollisionShape2D
├── AnimatedSprite2D
├── AnimationPlayer
├── SwordHitbox (Area2D)
│   └── CollisionShape2D
├── Hurtbox (Area2D)
│   └── CollisionShape2D
└── Camera2D
```

## Responsibilities

- **Player controller:** movement, jump, facing direction, input, attack request.
- **Combat component or script:** attack window, target detection, damage calls, knockback.
- **Health component:** health, invulnerability timer, hurt/death signals.
- **Enemy controller:** idle, detect, telegraph, attack, recovery, hurt, defeated.
- **Interaction system:** detect nearby interactables and show the interaction prompt.
- **Checkpoint manager:** save the latest active checkpoint and respawn position.
- **Level state:** objectives, one-shot triggers, boss completion and exit unlock.
- **Dialogue display:** receive lines and show skippable text.
- **Input layer:** map keyboard/touch/gamepad actions into the same named actions.

Use Godot signals for events such as `health_changed`, `died`, `checkpoint_activated`, `puzzle_completed`, `enemy_defeated`, and `fragment_collected`.

## Input actions

Define these in Input Map from the start:

- `move_left`
- `move_right`
- `jump`
- `attack`
- `interact`
- `pause`

Keyboard and touchscreen controls should call the same actions. Do not duplicate player movement logic for mobile.

## Collision-layer planning

Choose and document layers before adding many objects. A simple starting scheme:

- World geometry
- Player body
- Enemy body
- Player attack hitbox
- Enemy attack hitbox
- Interactables / trigger areas
- Collectibles

Ensure a sword hitbox can detect enemy hurtboxes without colliding with world geometry unless that behavior is explicitly desired.

---

# 8. Save, restart, and failure handling

For the prototype, keep state deliberately simple:

- Before the temple checkpoint: a fall or defeat restarts at the beginning of the relevant section.
- After activating the checkpoint: a defeat respawns Tavi at the checkpoint with a defined amount of health.
- Collecting the First Golden Fragment marks the chapter objective as complete.
- Restarting the level must reset enemy positions, puzzle state, pickups, and one-shot cutscene triggers consistently.
- Pausing must stop gameplay simulation, not only display a menu over a still-active boss.

Do not add permanent save files until the session-based loop is stable. When saves are added, store versioned data so later changes to save structure do not break old test files.

---

# 9. Milestone plan

## Milestone 1 — Greybox movement
- Create one test floor and a few platforms.
- Tune acceleration, deceleration, jump height, gravity, and fall behavior.
- Add camera follow and edge handling.
- Validate keyboard and touch control responsiveness.

**Exit criteria:** The player can traverse a basic route repeatedly without unpredictable clipping or missed inputs.

## Milestone 2 — Combat loop
- Add a sword animation and time-limited hitbox.
- Add one Thornling with telegraphed behavior.
- Add health, hit feedback, invulnerability, and defeat handling.

**Exit criteria:** A new player can understand why a hit landed or missed.

## Milestone 3 — Prologue blockout
- Block out the village lane, Hearthlight square, beam event, combat lane, and Rusk’s shelter.
- Add simple trigger-based dialogue and the Hearthlight event.

**Exit criteria:** The prologue runs from spawn to the Forgotten Trail without a manual scene reset.

## Milestone 4 — Chapter 1 blockout
- Build the platforming route, enemy encounters, arch puzzle, checkpoint, boss arena, and fragment reward.
- Use colored shapes and temporary art only.

**Exit criteria:** The full prototype can be completed without missing content or developer intervention.

## Milestone 5 — First art pass
- Replace only the most visible placeholders: Tavi, Mote, the foreground tiles, the arch, Sentinel, and fragment.
- Add parallax and core sound cues.

**Exit criteria:** Screenshots and gameplay communicate a consistent art direction.

## Milestone 6 — Device testing and polish
- Test Android in landscape on at least one real device.
- Test Windows with keyboard; gamepad can be postponed unless it is a target requirement.
- Tune the touch-button layout and safe areas.
- Fix softlocks, pause bugs, checkpoint bugs, puzzle hint failures, and boss fairness issues.

**Exit criteria:** Another person can complete the prototype and explain the basic story premise without the developer narrating it.

---

# 10. QA checklist

## Movement and camera
- [ ] Player cannot pass through solid platforms.
- [ ] Required jumps are achievable with keyboard and touchscreen.
- [ ] Camera does not reveal unintended level boundaries.
- [ ] Falling triggers a valid recovery rather than a softlock.

## Combat
- [ ] Sword can hit each enemy only during its attack window.
- [ ] A single swing cannot damage the same enemy repeatedly without a new attack, unless intended.
- [ ] Enemies telegraph their attacks clearly.
- [ ] Player invulnerability prevents rapid chain damage.
- [ ] Boss defeat always advances the level state.

## Puzzle and story
- [ ] Rune puzzle can be solved with sound disabled.
- [ ] Hint ladder activates if the player is stuck.
- [ ] Dialogue can be skipped.
- [ ] Hearthlight event only plays once per intended session.
- [ ] Mote does not block doorways or required jumps.
- [ ] Fragment collection triggers the chapter completion state once.

## Mobile and PC
- [ ] Touch buttons work simultaneously when the game requires movement plus jump or attack.
- [ ] UI remains inside safe areas.
- [ ] Pause freezes enemies, projectiles, and timers.
- [ ] Window resizing does not break the HUD.
- [ ] The same level and enemy scripts run on both platforms.

## Narrative comprehension
- [ ] Test players understand that the Hearthlight has failed.
- [ ] They understand that Tavi is looking for a way to help the village.
- [ ] They notice the sword reacting to the ruins.
- [ ] They leave Chapter 1 curious about the Anchors and the forest, without requiring a full explanation of the Stillfall.

---

# 11. Definition of done

The Prologue + Chapter 1 prototype is ready for external playtesting when:

1. A new player can start the game, learn the controls, and reach the temple.
2. The player can complete the rune puzzle without verbal help from the developer.
3. The player can defeat the Hollow Sentinel using readable attack patterns.
4. The checkpoint, death, restart, and chapter-completion states work reliably.
5. The First Golden Fragment provides a clear reward and points toward Briarwake.
6. The level builds and runs on Windows and Android.
7. The experience can be completed in roughly 8–12 minutes on a first playthrough, with no known game-blocking bugs.

**Recommended immediate task:** Build only the greybox player controller and a short platform test room first. Do not draw final character sprites or build the complete village until movement and jumping feel right.
