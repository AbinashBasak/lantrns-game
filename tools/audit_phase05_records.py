"""Validate Phase05 prototypes, artifact paths, hashes and64px tile exports."""
from pathlib import Path
import json,hashlib
from PIL import Image
ROOT=Path(__file__).resolve().parents[1];PHASE=ROOT/'assets/production/phase_05_reusable_terrain_and_tile_sets';errors=[];packs=[];checked_files={}
def walk(obj,aid):
 if isinstance(obj,dict):
  p=obj.get('path');sha=obj.get('sha256')
  if p and sha and Path(p).is_file():
   actual=checked_files.setdefault(p,hashlib.sha256(Path(p).read_bytes()).hexdigest())
   if actual!=sha:errors.append(f'{aid}: hash mismatch {Path(p).name}')
  for v in obj.values():walk(v,aid)
 elif isinstance(obj,list):
  for v in obj:walk(v,aid)
 elif isinstance(obj,str) and obj.startswith(str(ROOT)):
  if not Path(obj).exists():errors.append(f'{aid}: missing local path {obj}')
for folder in sorted(PHASE.glob('TILE-*')):
 p=folder/'metadata.json';aid=folder.name
 if not p.exists():errors.append(f'{aid}: missing metadata');continue
 r=json.loads(p.read_text());walk(r,aid)
 if not r.get('requested_deliverables_saved_and_reviewed'):errors.append(f'{aid}: prototype review incomplete')
 if r.get('production_approved'):errors.append(f'{aid}: unexpected production approval')
 tile_count=0;paths=[]
 for d in r.get('deliverables',[]):
  src=Path(d['path']);im=Image.open(src)
  if d.get('transparent_background') and ('A' not in im.getbands() or im.getchannel('A').getextrema()[0]!=0):errors.append(f'{aid}: transparent source lacks clear alpha')
  roles=d.get('roles',[]);count=d.get('frame_count',len(roles))
  if len(roles)!=count:errors.append(f'{aid}: role/count mismatch')
 for f in sorted((folder/'exports').glob('*.png')):
  with Image.open(f) as im:
   im.verify()
  with Image.open(f) as im:
   if im.size==(64,64):tile_count+=1
  paths.append(str(f))
 if not tile_count:errors.append(f'{aid}: no64px exports')
 packs.append({'id':aid,'title':r.get('title'),'reviewed':r.get('requested_deliverables_saved_and_reviewed',False),'tile_count':tile_count,'exported_png_count':len(paths),'metadata':str(p),'stage':r.get('stage'),'production_approved':False})
report={'packs':packs,'pack_count':len(packs),'tile_count':sum(p['tile_count'] for p in packs),'exported_png_count':sum(p['exported_png_count'] for p in packs),'hashed_records':len(checked_files),'errors':errors}
(ROOT/'docs/phase05-validation.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n');print(json.dumps(report,indent=2));raise SystemExit(bool(errors))
