"""Verify source/runtime manifests and export exclusions; exits nonzero on drift."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parents[1]
checks=[];seen=set()
def path(value):
 if value.startswith('res://'):return ROOT/value[6:]
 p=Path(value);return p if p.is_absolute() else ROOT/p

def walk(obj,asset=None):
 if isinstance(obj,dict):
  aid=obj.get('asset_id',asset)
  src=obj.get('source');dst=obj.get('runtime',obj.get('output',obj.get('path')))
  if src and dst and isinstance(src,str) and isinstance(dst,str):
   a,b=path(src),path(dst)
   if 'assets/runtime/' in str(b) and b.suffix in ['.png','.ogg']:
    if str(b) not in seen:
     seen.add(str(b));assert a.is_file(),str(a);assert b.is_file(),str(b)
     sa=hashlib.sha256(a.read_bytes()).hexdigest();sb=hashlib.sha256(b.read_bytes()).hexdigest()
     assert sa==obj['source_sha256'],f'source drift {a}'
     assert sb==obj.get('runtime_sha256',obj.get('sha256')),f'runtime drift {b}'
     checks.append((aid,str(b.relative_to(ROOT))))
  for value in obj.values():walk(value,aid)
 elif isinstance(obj,list):
  for value in obj:walk(value,asset)
for manifest in (ROOT/'assets/runtime').rglob('*manifest.json'):
 walk(json.loads(manifest.read_text()))
assert len(checks)>100, len(checks)
for a,p in checks:
 assert (ROOT/p).stat().st_size<10_000_000,p
presets=(ROOT/'export_presets.cfg').read_text()
assert 'assets/production/*' in presets and 'include_filter="*.json"' in presets
print(f'PASS: {len(checks)} runtime source/hash records; release filters exclude production archive and include dialogue/animation JSON')
