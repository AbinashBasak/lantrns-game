"""Bounded integration checks; script errors fail even if Godot exits with code zero."""
from pathlib import Path
import os,subprocess,sys
root=Path(__file__).resolve().parents[1]
godot=os.getenv('GODOT_BIN','/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot')
subprocess.run([sys.executable,str(root/'tools/validate_prologue_assets.py')],check=True)
logs=[]
for script,marker in [('prologue_test.gd','PROLOGUE TEST: PASS'),('smoke_test.gd','SMOKE TEST: PASS'),('parallax_test.gd','PARALLAX TEST: PASS'),('chapter01_test.gd','CHAPTER 1 TEST: PASS')]:
 result=subprocess.run([godot,'--headless','--path',str(root),'--script','res://tests/'+script],capture_output=True,text=True,timeout=45)
 log=result.stdout+result.stderr;logs.append(log)
 print('\n'.join(line for line in result.stdout.splitlines() if line.startswith(('PASS:', 'PROLOGUE TEST:', 'SMOKE TEST:', 'PARALLAX TEST:', 'CHAPTER 1 TEST:'))))
 if result.returncode or marker not in log or 'SCRIPT ERROR:' in log or 'Failed loading resource:' in log:
  print(log,file=sys.stderr);sys.exit(1)
(root/'docs/prologue-validation.txt').write_text('\n'.join(logs))
