"""Bounded integration checks; script errors fail even if Godot exits with code zero."""
from pathlib import Path
import os,subprocess,sys
root=Path(__file__).resolve().parents[1]
godot=os.getenv('GODOT_BIN','/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot')
subprocess.run([sys.executable,str(root/'tools/validate_prologue_assets.py')],check=True)
logs=[]
for script,marker in [('prologue_test.gd','PROLOGUE TEST: PASS'),('smoke_test.gd','SMOKE TEST: PASS'),('parallax_test.gd','PARALLAX TEST: PASS'),('chapter01_test.gd','CHAPTER 1 TEST: PASS'),('health_combat_test.gd','Health combat: 13 checks; 0 failures'),('new_enemy_test.gd','New enemy checks: 11'),('jungle_exploration_test.gd','JUNGLE FAILURES: 0'),('mandatory_jungle_test.gd','PASS:'),('hollow_sentinel_rage_test.gd','PASS:'),('chapter01_rewards_test.gd','REWARD FAILURES: 0'),('jungle_visual_test.gd','JUNGLE VISUAL CHECKS: 48 FAILURES: 0'),('completion_popup_test.gd','COMPLETION POPUP: 8 checks; 0 failures'),('lighting_test.gd','PASS:'),('memory_popup_test.gd','MEMORY_POPUP_TESTS: 12/12 passed'),('encounter_hud_test.gd','ENCOUNTER_HUD_TESTS: 12/12 passed'),('exact_title_menu_test.gd','EXACT_TITLE_MENU_TESTS: 13/13 passed'),('botanical_dialogue_test.gd','BOTANICAL_DIALOGUE_TESTS: 17/17 passed'),('title_lighting_test.gd','TITLE_LIGHTING_TESTS: 10/10 passed'),('chapter01_reward_animation_test.gd','REWARD ANIMATION FAILURES: 0 CHECKS: 9'),('reward_lighting_test.gd','REWARD LIGHTING: 13/13 checks passed'),('reward_scene_hud_test.gd','REWARD_SCENE_HUD_TESTS: 11/11 passed')]:
 result=subprocess.run([godot,'--headless','--path',str(root),'--script','res://tests/'+script],capture_output=True,text=True,timeout=45)
 log=result.stdout+result.stderr;logs.append(log)
 print('\n'.join(line for line in result.stdout.splitlines() if line.startswith(('PASS:', 'PROLOGUE TEST:', 'SMOKE TEST:', 'PARALLAX TEST:', 'CHAPTER 1 TEST:', 'PASS ', 'Health combat:', 'New enemy checks:', 'JUNGLE FAILURES:'))))
 if result.returncode or marker not in log or 'SCRIPT ERROR:' in log or 'Failed loading resource:' in log:
  print(log,file=sys.stderr);sys.exit(1)
(root/'docs/prologue-validation.txt').write_text('\n'.join(logs))
