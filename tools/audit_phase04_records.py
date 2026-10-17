"""Read-only validation of generated Phase 04 source/export records."""
from pathlib import Path
import hashlib,json
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
base=ROOT/'assets/production/phase_04_environment_packs'
report={'packs':[],'errors':[]}
for folder in sorted(base.glob('ENV-*')):
 p=folder/'metadata.json'
 if not p.exists():report['errors'].append(f'{folder.name}: missing metadata');continue
 r=json.loads(p.read_text());row={'id':folder.name,'deliverables':len(r.get('deliverables',[])),'export_count':0,'source_review_complete':r.get('requested_deliverables_saved_and_reviewed',False),'production_approved':r.get('production_approved',False)}
 if row['deliverables']!=8:report['errors'].append(f'{folder.name}: expected8types')
 for d in r.get('deliverables',[]):
  path=Path(d['path'])
  if not path.exists():report['errors'].append(f'{folder.name}: missing source {path}');continue
  im=Image.open(path);expected=d.get('sha256') or d.get('source_file',{}).get('sha256') or d.get('source_info',{}).get('sha256')
  if expected and hashlib.sha256(path.read_bytes()).hexdigest()!=expected:report['errors'].append(f'{folder.name}: source hash mismatch {path.name}')
  if d.get('transparent_background') and ('A' not in im.getbands() or im.getchannel('A').getextrema()[0]!=0):report['errors'].append(f'{folder.name}: no clear alpha {path.name}')
  if d.get('export_mode')=='atlas' and len(d.get('roles',[]))!=d['frame_count']:report['errors'].append(f'{folder.name}: roles/count mismatch {d["slug"]}')
  export_paths=list(d.get('export_paths',[]))
  if not export_paths:
   export_paths=[f['path'] for f in d.get('frames',[])]
   if d.get('export_path'):export_paths.append(d['export_path'])
   if d.get('normalized_sheet'):export_paths.append(d['normalized_sheet']['path'])
  if not export_paths:report['errors'].append(f'{folder.name}: no exports {d["slug"]}')
  for export in export_paths:
   f=Path(export);row['export_count']+=1
   if not f.is_file():report['errors'].append(f'{folder.name}: missing export {f.name}')
   else:
    with Image.open(f) as e:e.verify()
  hash_records=list(d.get('export_files',[]))+list(d.get('frames',[]))
  if d.get('export_info'):hash_records.append(d['export_info'])
  if d.get('normalized_sheet'):hash_records.append(d['normalized_sheet'])
  for e in hash_records:
   f=Path(e['path'])
   if f.exists() and e.get('sha256') and hashlib.sha256(f.read_bytes()).hexdigest()!=e['sha256']:report['errors'].append(f'{folder.name}: export hash mismatch {f.name}')
  preview=d.get('preview_path')
  if preview and not Path(preview).is_file():report['errors'].append(f'{folder.name}: missing preview {preview}')
 report['packs'].append(row)
report['source_types']=sum(r['deliverables'] for r in report['packs']);report['exports']=sum(r['export_count'] for r in report['packs'])
(ROOT/'docs/phase04-validation.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
raise SystemExit(bool(report['errors']))
