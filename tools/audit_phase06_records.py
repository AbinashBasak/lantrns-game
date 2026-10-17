"""Read-only validation of Phase06 art records and derived exports."""
from pathlib import Path
from PIL import Image
import hashlib,json
ROOT=Path(__file__).resolve().parents[1];reg=json.loads((ROOT/'assets/production/asset_registry.json').read_text());errors=[];packs=[];hashes={}
def walk(x,aid):
 if isinstance(x,dict):
  p=x.get('path');sha=x.get('sha256')
  if p and sha and Path(p).is_file():
   if p not in hashes:hashes[p]=hashlib.sha256(Path(p).read_bytes()).hexdigest()
   if hashes[p]!=sha:errors.append(f'{aid}: hash mismatch {Path(p).name}')
  for v in x.values():walk(v,aid)
 elif isinstance(x,list):
  for v in x:walk(v,aid)
 elif isinstance(x,str) and x.startswith(str(ROOT)) and not Path(x).exists():errors.append(f'{aid}: missing path {x}')
for a in reg['assets']:
 if a['phase']!='06':continue
 aid=a['asset_id'];folder=Path(a['folder']);mp=folder/'metadata.json'
 if not mp.exists():errors.append(f'{aid}: missing metadata');continue
 r=json.loads(mp.read_text());walk(r,aid);count=0
 if not r.get('requested_deliverables_saved_and_reviewed'):errors.append(f'{aid}: review incomplete')
 if r.get('production_approved') or r.get('runtime_integrated'):errors.append(f'{aid}: unexpected production/runtime claim')
 for d in r.get('deliverables',[]):
  p=Path(d['path']);im=Image.open(p)
  if d.get('transparent_background') and ('A' not in im.getbands() or im.getchannel('A').getextrema()[0]!=0):errors.append(f'{aid}: no clear alpha')
  n=d.get('frame_count',len(d.get('roles',[])));count+=n
  if len(d.get('roles',[]))!=n:errors.append(f'{aid}: role/count mismatch')
  if d.get('timing') is not None:errors.append(f'{aid}: unexpected animation timing on static art')
 files=list((folder/'exports').glob('*.png'))
 for f in files:
  with Image.open(f) as im:im.verify()
 if len(files)<count+len(r.get('deliverables',[])):errors.append(f'{aid}: incomplete sprite/sheet exports')
 packs.append({'id':aid,'title':a['title'],'subsection':a['subsection'],'reviewed':r.get('requested_deliverables_saved_and_reviewed',False),'sprite_count':count,'exported_png_count':len(files),'metadata':str(mp),'stage':r.get('stage'),'production_approved':False,'runtime_integrated':False})
report={'packs':packs,'pack_count':len(packs),'sprite_count':sum(p['sprite_count'] for p in packs),'exported_png_count':sum(p['exported_png_count'] for p in packs),'hashed_records':len(hashes),'errors':errors};(ROOT/'docs/phase06-validation.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='packs'},indent=2));raise SystemExit(bool(errors))
