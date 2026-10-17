"""Synchronize Phase 04 saved-file progress without inferring production approval.
Run with --master PATH to write an approved master; default reads the designated
master and updates the project copy plus a proposed master in /tmp.
"""
from pathlib import Path
import argparse, datetime, hashlib, json, re
ROOT=Path(__file__).resolve().parents[1]
LIB=ROOT/'assets/production'
SLUGS=('lighting_reference','distant_background','midground','terrain_atlas','foreground','decorative_props','interactive_props','location_fx')
parser=argparse.ArgumentParser();parser.add_argument('--master',type=Path);args=parser.parse_args()
master=args.master or Path('/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md')
copy=ROOT/'docs/lanterns_underroot_master_asset_checklist.md'
text=master.read_text() if master.exists() else copy.read_text()
text=text.replace('**Last organized:** 2026-10-16','**Last organized:** 2026-10-17')
reg_path=LIB/'asset_registry.json';reg=json.loads(reg_path.read_text())
master_checks={aid:state.lower()=='x' for state,aid in re.findall(r'^- \[([ xX])\] ([A-Z]+-[0-9]+) —',text,re.M)}
for entry in reg['assets']:
 if entry['asset_id'] in master_checks:entry['checked']=master_checks[entry['asset_id']]
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat()
records={}
for group in 'abcde':
 p=Path(f'/tmp/phase04_generated_{group}.json')
 if p.exists():
  for record in json.loads(p.read_text()):records[record['id']]=record
rows=[];all_paths=[]
for a in reg['assets']:
 if a['phase']!='04':continue
 aid=a['asset_id'];folder=Path(a['folder']);meta_path=folder/'metadata.json'
 meta=json.loads(meta_path.read_text()) if meta_path.exists() else {}
 record=records.get(aid,{})
 files=list((folder/'source_images').glob('*.png'))
 selected={d['slug']:Path(d['path']) for d in (meta.get('deliverables') or record.get('deliverables',[])) if d.get('path') and Path(d['path']).is_file()}
 slugs={slug for slug in SLUGS if slug in selected or any(f.name.startswith(f'{aid}_{slug}_original') for f in files)}
 reviewed=bool(meta.get('requested_deliverables_saved_and_reviewed')) and len(slugs)==8
 # Preserve pre-existing user checks. New checks require explicit review evidence.
 existing_check=re.search(rf'^- \[([ xX])\] {aid} —',text,re.M)
 a['checked']=bool(existing_check and existing_check[1].lower()=='x') or bool(meta.get('production_approved'))
 a['source_count']=len(files);a['deliverables_saved']=len(slugs);a['deliverables_expected']=8
 a['production_approved']=False
 if meta_path.exists():
  a['exports_folder']=str(folder/'exports');a['previews_folder']=str(folder/'previews')
 a['stage']=meta.get('stage',f'{len(slugs)}/8 source deliverables saved; pack review and exports pending')
 if meta_path.exists():a['metadata']=str(meta_path)
 if files:a['primary_image']=str(next((f for f in files if 'lighting_reference' in f.name),files[0]))
 sources=[]
 for f in sorted(files):
  sources.append({'path':str(f),'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()})
  all_paths.append(str(f))
 record.update({'id':aid,'title':a['title'],'folder':str(folder),'saved_deliverable_slugs':sorted(slugs),'sources_on_disk':sources,'requested_deliverables_saved_and_reviewed':reviewed,'production_approved':False,'stage':a['stage']})
 rows.append(record)
 block=f'  <!-- phase04-record:{aid}:start -->\n  - Production stage: {a["stage"].replace('_',' ')}. Final production approval pending.\n  - Saved folder: [{aid}]({folder}) · {len(slugs)}/8 source deliverables saved'
 if meta_path.exists():block+=f' · [metadata.json]({meta_path})';all_paths.append(str(meta_path))
 block+='\n'
 if reviewed:block+='  - [x] Generated prototype pack: eight source types reviewed and exported; production cleanup/testing pending.\n'
 for slug in SLUGS:
  matches=sorted(f for f in files if f.name.startswith(f'{aid}_{slug}_original'))
  if matches or slug in selected:
   f=selected.get(slug) or matches[-1];block+=f'  - {slug.replace("_"," ").capitalize()}: [{f.name}]({f})\n'
 block+=f'  <!-- phase04-record:{aid}:end -->'
 text=re.sub(rf'\n  <!-- phase04-record:{aid}:start -->.*?<!-- phase04-record:{aid}:end -->','',text,flags=re.S)
 text=re.sub(rf'^- \[([ xX])\] {aid} — ([^\n]+)',lambda m:f'- [{"x" if a["checked"] else m[1]}] {aid} — {m[2]}\n{block}',text,flags=re.M)
reg['checked_count']=sum(bool(a.get('checked')) for a in reg['assets']);reg['last_updated']=now
reg_path.write_text(json.dumps(reg,indent=2,ensure_ascii=False)+'\n')
copy.write_text(text)
if args.master:master.write_text(text)
else:Path('/tmp/lanterns_underroot_master_asset_checklist.updated.md').write_text(text)
summary={'last_updated':now,'source_deliverables_saved':sum(len(r['saved_deliverable_slugs']) for r in rows),'expected':88,'packs_saved_and_reviewed':sum(r['requested_deliverables_saved_and_reviewed'] for r in rows),'production_approved':False,'packs':rows}
(LIB/'phase_04_environment_packs/PHASE04_progress.json').write_text(json.dumps(summary,indent=2,ensure_ascii=False)+'\n')
missing=[p for p in all_paths if not Path(p).is_file() and not Path(p).is_dir()]
assert not missing,missing
print(json.dumps({k:v for k,v in summary.items() if k!='packs'},indent=2));print('Validated',len(all_paths),'saved links')
