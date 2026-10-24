# Chapter 2 combat and recovery fixes — 2026-10-24

This update supersedes the earlier rear-only damage and mandatory rescue-after-zero-health descriptions.

## What changed

- **Zero health ends the fight.** Mossjaw stops immediately, clears roots/projectiles, leaves the enemy targeting group, emits victory once and unlocks the existing reward chest. The story treats this as freeing the guardian. The column/binding route remains an optional earlier finish at low health; it is never required after the bar is empty.
- **The visible body is a valid target.** Tavi's sword now intersects world-space enemy hurt bounds. Mossjaw can be hit from either side and at the upper body while jumping, instead of requiring the sword to reach its feet/origin. One swing still hits a target once, and short impact protection prevents accidental repeated contacts. Other Chapter 1 enemies retain their original targeting behavior unless they explicitly expose body bounds.
- **Seven readable boss moves.** Charge, claw combo, aimed root eruption, aimed seed volley and root sweep are joined by a marked leap slam and a returning double rush. The leap locks a reachable marker, clears raised arena platforms and lands on the advertised ground position. Real arena validation measured 3.6px landing error.
- **Attack feedback and animation timing.** Existing illustrated anticipation, strike and recovery frames now align with each move's active timing. Boss anticipation compresses into the launch; rush/charge have stride motion; leap/landing have stretch/impact motion. Short world-camera impacts are bounded to 7px horizontally and4.5px vertically, decay quickly and clear during pause, dialogue, respawn or reduced-effects mode. HUD elements remain in the CanvasLayer. Tavi draws in front of large enemies so close sword attacks stay visible.
- **Every new enemy has an actual strike.** Thornrunner closes within a reachable lunge; Lantern Moth can reach its warned dive target and recovers at sword height; Sporespitter shows preparation, firing and recovery poses. The spitter and boss volley solve ballistic velocities toward the locked player body position, including elevated targets. Shots do not home after release, so moving after the warning can evade them.
- **Projectile resets are safe.** A projectile hit may synchronously kill Tavi and reset the encounter. Updates now detach their active batch and use reset epochs, so clearing projectiles in a death callback cannot leave stale array indexes or freed sprites in the ongoing loop. The saved GDScript compiles without the indentation error in the reported screenshot.
- **Changing areas no longer heals.** All four jungle entries/exits and the orchard checkpoint preserve current hearts and vitality. Actual death/respawn and the explicitly opened reward chest still restore health. Points, puzzle progress and sword upgrades retain their existing recovery behavior.

## Review and validation

`tests/chapter02_combat_fix_test.gd` adds52 checks using the real chapter, real sword/physics hits, fatal multi-projectile callbacks, enemy strike poses and trajectories, seven boss warnings, actual arena landing, every room handoff, and camera effect limits/reduced-effects/pause behavior.

The updated orchard suite passes41 checks, expansion151, Chapter 1 regression44, and shared health/combat13: **301 checks passed**, no script errors. Host/Godot shutdown resource cleanup warnings remain separately visible in saved logs.

`tests/chapter02_combat_capture.gd` records real rendered attack motion with an invulnerable stationary review target. Seven attack starts and three species are staged independently; this is an animation/feedback review, not a claim of first-player balance testing. Native screenshots, an animation preview and capture notes are in `docs/chapter02-combat-review/`.

No new character artwork was generated or substituted in this repair. Existing illustrated game assets and their archived source files remain unchanged. Human encounter balance and final animation polish remain playtest work.
