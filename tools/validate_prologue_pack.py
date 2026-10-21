"""Run progression from the exported pack in an otherwise empty project directory."""
from pathlib import Path
import subprocess,tempfile,os
ROOT=Path(__file__).resolve().parents[1]
godot=os.getenv('GODOT_BIN','/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot')
pack=ROOT/'builds/validation/prologue.pck'
with tempfile.TemporaryDirectory(prefix='lanterns-pack-') as folder:
 source=(ROOT/'tests/prologue_test.gd').read_text()
 source=source.replace('func run() -> void:', 'func run() -> void:\n\tcheck(not FileAccess.file_exists("res://assets/production/asset_registry.json"), "Release pack excludes production archive")\n\tcheck(FileAccess.file_exists("res://data/dialogue/prologue.json"), "Release pack includes keyed dialogue")')
 script=Path(folder)/'pack_test.gd';script.write_text(source)
 result=subprocess.run([godot,'--headless','--path',folder,'--main-pack',str(pack),'--script',str(script)],capture_output=True,text=True,timeout=45)
 log=result.stdout+result.stderr
 (ROOT/'docs/prologue-pack-validation.txt').write_text(log)
 assert result.returncode==0 and 'PROLOGUE TEST: PASS' in log and 'SCRIPT ERROR:' not in log,log
 assert 'Failed loading resource:' not in log,log
 print('PASS: exported content pack runs all31 prologue checks plus2 package boundary checks from an empty directory')
 script.write_text((ROOT/'tests/parallax_test.gd').read_text())
 parallax=subprocess.run([godot,'--headless','--path',folder,'--main-pack',str(pack),'--script',str(script)],capture_output=True,text=True,timeout=45)
 plog=parallax.stdout+parallax.stderr
 assert parallax.returncode==0 and 'PARALLAX TEST: PASS' in plog and 'SCRIPT ERROR:' not in plog,plog
 (ROOT/'docs/prologue-pack-validation.txt').write_text(log+'\n'+plog)
 print('PASS: all11 parallax/grounding checks also pass in exported pack')
 print('Pack bytes:',pack.stat().st_size)
 if 'leaked at exit' in log:print('Exit cleanup warning remains; see validation log')

 script.write_text((ROOT/'tests/chapter01_test.gd').read_text())
 chapter=subprocess.run([godot,'--headless','--path',folder,'--main-pack',str(pack),'--script',str(script)],capture_output=True,text=True,timeout=45)
 clog=chapter.stdout+chapter.stderr
 assert chapter.returncode==0 and 'CHAPTER 1 TEST: PASS' in clog and 'SCRIPT ERROR:' not in clog,clog
 assert 'Failed loading resource:' not in clog,clog
 (ROOT/'docs/prologue-pack-validation.txt').write_text(log+'\n'+plog+'\n'+clog)
 print('PASS: all44 Chapter1 checks also pass in exported pack')

 extra_logs=[]
 for filename,marker in [('health_combat_test.gd','Health combat: 13 checks; 0 failures'),('new_enemy_test.gd','New enemy checks: 11'),('jungle_exploration_test.gd','JUNGLE FAILURES: 0'),('mandatory_jungle_test.gd','PASS:'),('hollow_sentinel_rage_test.gd','PASS:'),('chapter01_rewards_test.gd','REWARD FAILURES: 0'),('jungle_visual_test.gd','JUNGLE VISUAL CHECKS: 48 FAILURES: 0'),('completion_popup_test.gd','COMPLETION POPUP: 8 checks; 0 failures'),('lighting_test.gd','PASS:'),('memory_popup_test.gd','MEMORY_POPUP_TESTS: 12/12 passed'),('encounter_hud_test.gd','ENCOUNTER_HUD_TESTS: 12/12 passed'),('exact_title_menu_test.gd','EXACT_TITLE_MENU_TESTS: 13/13 passed'),('botanical_dialogue_test.gd','BOTANICAL_DIALOGUE_TESTS: 17/17 passed'),('title_lighting_test.gd','TITLE_LIGHTING_TESTS: 10/10 passed'),('chapter01_reward_animation_test.gd','REWARD ANIMATION FAILURES: 0 CHECKS: 9'),('reward_lighting_test.gd','REWARD LIGHTING: 13/13 checks passed'),('reward_scene_hud_test.gd','REWARD_SCENE_HUD_TESTS: 11/11 passed')]:
  script.write_text((ROOT/'tests'/filename).read_text())
  run=subprocess.run([godot,'--headless','--path',folder,'--main-pack',str(pack),'--script',str(script)],capture_output=True,text=True,timeout=60)
  output=run.stdout+run.stderr
  assert run.returncode==0 and marker in output and 'SCRIPT ERROR:' not in output and 'Failed loading resource:' not in output,output
  extra_logs.append(output)
  print('PASS: exported pack '+filename)
 (ROOT/'docs/prologue-pack-validation.txt').write_text('\n'.join([log,plog,clog]+extra_logs))
