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
 print('PASS: all42 Chapter1 checks also pass in exported pack')
