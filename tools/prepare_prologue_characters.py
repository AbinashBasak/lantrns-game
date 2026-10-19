"""Copy archived generated frame exports without modifying source pixels."""
from pathlib import Path
import json, shutil, hashlib
ROOT=Path(__file__).resolve().parents[1]
LIB=ROOT/'assets/production'
OUT=ROOT/'assets/runtime/prologue'
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save_pack(name, specs, category):
 out=OUT/category/name;out.mkdir(parents=True,exist_ok=True); result={'animations':{},'provenance':'Unmodified generated export frames; sources preserved in production archive.'}
 for anim,aid in specs.items():
  meta=next(LIB.rglob(aid+'/metadata.json'));m=json.loads(meta.read_text())
  if aid.startswith('MOTE'):
   clip=json.loads((meta.parent/'exports'/f'{aid}_manifest.json').read_text())
  else: clip=m['clips'][0]
  frames=[]
  for raw in clip['frames']:
   src=Path(raw); dst=out/src.name;shutil.copy2(src,dst)
   frames.append({'path':'res://'+str(dst.relative_to(ROOT)),'source':str(src.relative_to(ROOT)), 'sha256':digest(dst),'source_sha256':digest(src)})
  result['animations'][anim]={'asset_id':aid,'frames':frames,'durations_ms':clip['frame_durations_ms'],'loop':clip.get('loop',False),'pivot_px':clip.get('pivot_px',[256,256])}
 (out/'manifest.json').write_text(json.dumps(result,indent=2)+'\n')
save_pack('mote',{'idle':'MOTE-002','follow':'MOTE-003','alert':'MOTE-004','rescue':'MOTE-007'},'characters')
save_pack('rootling',{'idle':'EN-002','move':'EN-003','attack':'EN-004','hurt':'EN-005','defeat':'EN-006'},'characters')
for aid in ['FX-002','FX-003','FX-004']:
 folder=next(LIB.rglob(aid+'/metadata.json')).parent
 desc=next((folder/'exports').glob('*frames.json')); info=json.loads(desc.read_text());out=OUT/'effects'/aid;out.mkdir(parents=True,exist_ok=True)
 frames=[]
 for src in sorted((folder/'exports').glob(aid+'*.png')):
  if '_sheet' in src.name:continue
  dst=out/src.name;shutil.copy2(src,dst);frames.append({'path':'res://'+str(dst.relative_to(ROOT)),'source':str(src.relative_to(ROOT)),'sha256':digest(dst),'source_sha256':digest(src)})
 (out/'manifest.json').write_text(json.dumps({'animations':{'main':{'asset_id':aid,'frames':frames,'durations_ms':[1000/info['fps']]*len(frames),'loop':False,'pivot_px':info['pivot_px']}}},indent=2)+'\n')
