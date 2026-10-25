# Runtime player native animation integration

The shared playable player, `scenes/player/player.tscn`, now owns an active Godot AnimationTree and an AnimationPlayer library. This affects the existing campaign player's scene; it does not promote the Chapter 3 review crops into production art.

Open the player's **AnimationTree** node and select **AnimationTree** in the bottom panel to inspect the state graph. Open **AnimationPlayer** to inspect the editable clips and their frame/light keyframes. The preserved source animation families are idle, run, jump_start, jump_rise, jump_fall, landing, and attack_1. An attack_combo clip reuses the existing attack_1 artwork at the existing second-combo tempo of 0.48 seconds. It is not a new attack export.

AnimationPlayer tracks own AnimatedSprite2D.animation and frame. Autoplay is removed, and the controller stops inherited autoplay on ready. The gameplay controller supplies state travel/restarts and still owns movement, damage detection, attack buffering and the existing health/vitality rules. The prologue dialogue caller also requests native idle playback.

The player's **Effects** branch contains editable one-shot CPUParticles2D nodes JumpDust, LandingDust and SwordHit, plus a PointLight2D SwordLight. SwordLight's energy is keyed inside the attack clips from 0.12 to 0.30 seconds, aligned with the existing strike window. It follows the visible golden sword stroke and mirrors position on facing changes. No lantern was invented on this older runtime art. Native effects respect the existing reduced-effects preference.

Validation: `tests/player_native_animation_test.gd` checks every available family's frame progression through the tree without AnimatedSprite2D.play(), travel, combo timing, light timing/facing, particle emitter restart and reset. Existing health/combat checks pass 13/13. Resource reference checker reports zero errors and one preexisting stale UI leaf import warning.

`tests/capture_player_native_runtime.gd` renders the actual Chapter 1 level with the native attack pose and emitters. The two runtime-player-native PNGs here show its light on/off. Visual inspection confirms the existing player's golden slash is displayed in the actual scene. The initial capture exposed resource leaks. The level ownership and audio teardown have since been corrected; the actual graphical capture now exits cleanly with no errors, warnings or leaks. See `../shutdown-fix.md`.

No new clean Chapter 3 hurt/death/swim/climb exports were produced. Those supplied mixed boards remain subject to their recorded cleanup and approval status.
