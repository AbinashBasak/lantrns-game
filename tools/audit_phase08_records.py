"""Validate Phase08 artwork, editable SVGs, layouts, exports and hashes."""
from pathlib import Path
from PIL import Image
import json,hashlib,xml.etree.ElementTree as ET
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
 if a['phase']!='08':continue
 aid=a['asset_id'];folder=Path(a['folder']);mp=folder/'metadata.json'
 if not mp.exists():errors.append(f'{aid}: missing metadata');continue
 r=json.loads(mp.read_text());walk(r,aid);components=0;expected_min=0
 if not r.get('requested_deliverables_saved_and_reviewed'):errors.append(f'{aid}: review incomplete')
 if r.get('production_approved') or r.get('runtime_integrated'):errors.append(f'{aid}: unexpected production/runtime claim')
 for d in r.get('deliverables',[]):
  p=Path(d['path']);n=d.get('frame_count',len(d.get('roles',[])) or 1);components+=n;expected_min+=n
  if p.suffix.lower()=='.svg':
   xml=ET.parse(p).getroot()
   if not xml.tag.endswith('svg'):errors.append(f'{aid}: invalid SVG root')
  else:
   im=Image.open(p)
   if d.get('transparent_background') and ('A' not in im.getbands() or im.getchannel('A').getextrema()[0]!=0):errors.append(f'{aid}: no clear alpha')
  if d.get('roles') and len(d['roles'])!=n:errors.append(f'{aid}: role/count mismatch')
 files=list((folder/'exports').glob('*.png'));svgs=list((folder/'exports').glob('*.svg'))
 for f in files:
  with Image.open(f) as im:im.verify()
 for f in svgs:ET.parse(f)
 if len(files)<expected_min:errors.append(f'{aid}: incomplete PNG exports {len(files)}/{expected_min}')
 layouts=list((folder/'exports').glob('*layout*.json'))
 for p in layouts:
  layout=json.loads(p.read_text())
  for n in layout.get('nodes',[]):
   rect=n.get('rect_norm')
   if rect and (len(rect)!=4 or min(rect)<0 or rect[0]+rect[2]>1.0001 or rect[1]+rect[3]>1.0001):errors.append(f'{aid}: layout rect outside canvas')
 if aid in ['UI-019','UI-020','UI-021','UI-022','UI-023'] and not layouts and not r.get('layout_spec'):errors.append(f'{aid}: missing separate data layout')
 packs.append({'id':aid,'title':a['title'],'subsection':a['subsection'],'reviewed':r.get('requested_deliverables_saved_and_reviewed',False),'component_count':components,'exported_png_count':len(files),'exported_svg_count':len(svgs),'metadata':str(mp),'stage':r.get('stage'),'production_approved':False,'runtime_integrated':False})
report={'packs':packs,'pack_count':len(packs),'component_count':sum(p['component_count'] for p in packs),'exported_png_count':sum(p['exported_png_count'] for p in packs),'exported_svg_count':sum(p['exported_svg_count'] for p in packs),'hashed_records':len(hashes),'errors':errors};(ROOT/'docs/phase08-validation.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='packs'},indent=2));raise SystemExit(bool(errors))
