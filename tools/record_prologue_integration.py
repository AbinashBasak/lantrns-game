"""Record runtime integration without treating subset validation as full production approval."""
from pathlib import Path
import json,datetime,re,hashlib
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
REG=ROOT/'assets/production/asset_registry.json'
r=json.loads(REG.read_text());lookup={a['asset_id']:a for a in r['assets']}
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat()
records=[]
def walk(obj,aid=None):
 if isinstance(obj,dict):
  aid=obj.get('asset_id',aid)
  target=obj.get('runtime',obj.get('output',obj.get('path')))
  if aid and target and obj.get('source') and ('assets/runtime/' in target):
   path=target[6:] if target.startswith('res://') else target
   records.append(dict(asset_id=aid,path=path,source=obj['source'],source_sha256=obj.get('source_sha256'),sha256=obj.get('runtime_sha256',obj.get('sha256'))))
  for value in obj.values():walk(value,aid)
 elif isinstance(obj,list):
  for value in obj:walk(value,aid)
for file in (ROOT/'assets/runtime/prologue').rglob('*manifest.json'):walk(json.loads(file.read_text()))
unique={rec['path']:rec for rec in records};records=list(unique.values())
unused={'UI-004','UI-005','FX-003','AUD-SFX-012'}
ids=sorted({rec['asset_id'] for rec in records}-unused)
index=dict(updated=now,scene='res://scenes/levels/prologue_brackenreach.tscn',scope='Prologue selected runtime exports, visually reviewed macOS/Godot4.7.2; full-pack and device approval remain separate',integrated_asset_ids=ids,prepared_only_asset_ids=sorted(unused),files=records)
indexfile=ROOT/'docs/prologue-asset-integration.json';indexfile.write_text(json.dumps(index,indent=2)+'\n')
for aid in ids:
 a=lookup[aid];a['runtime_integrated']=True
 a.setdefault('archive_stage_before_runtime_integration',a.get('stage'))
 a['stage']='selected prologue runtime exports integrated and desktop-reviewed; full-pack and release/device approval pending'
 a['runtime_manifest']=str(indexfile)
 a['runtime_paths']=[str(ROOT/rec['path']) for rec in records if rec['asset_id']==aid]
 a['runtime_validation']={'scope':'selected prologue exports','engine':'Godot4.7.2','platform':'macOS','checked':now,'release_approved':False}
 metadata=Path(a['metadata']);m=json.loads(metadata.read_text())
 m['runtime_integrated']=True
 m.setdefault('archive_stage_before_runtime_integration',m.get('stage'))
 m['stage']='selected prologue exports integrated and desktop-reviewed; full-pack and release/device approval pending'
 m['runtime_integrations']=m.get('runtime_integrations',{})
 m['runtime_integrations']['prologue']={'manifest':str(indexfile),'paths':a['runtime_paths'],'validation':a['runtime_validation']}
 m['production_approved']=False
 m['last_updated']=now
 metadata.write_text(json.dumps(m,indent=2)+'\n')
# Supplemental supporting cast stays in ENV-01's existing folder, not a new unregistered ID.
envmeta=Path(lookup['ENV-01']['metadata']);m=json.loads(envmeta.read_text())
pack=envmeta.parent
sources=[]
for source in sorted((pack/'source_images').glob('ENV-01_supporting_cast_generation_*.png')):
 sources.append({'path':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'dimensions':list(Image.open(source).size),'provenance':'unchanged built-in image_gen output','selected':source.name.endswith('02.png')})
m['supplemental_supporting_cast']={'generation_tool':'built-in image_gen','prompt':'Two isolated village supporting NPCs matching Tavi hand-painted style: elderly Rusk in moss cloak with staff and practical female cart-tender in terracotta scarf/green apron. Second pass requests strict transparent cutout preserving silhouettes.','sources':sources,'exports':[str(pack/'exports'/f'ENV-01_{actor}_idle.png') for actor in ['rusk','villager']],'runtime_manifest':str(ROOT/'assets/runtime/prologue/environment/npc_manifest.json'),'review':'Sprites and alpha inspected; feet aligned and visually reviewed in prologue; static idle only, no animation claim.'}
envmeta.write_text(json.dumps(m,indent=2)+'\n')
r['last_updated']=now;REG.write_text(json.dumps(r,indent=2)+'\n')
master=Path('/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md')
text=master.read_text();lines=text.splitlines();out=[]
for line in lines:
 if line.startswith('  - Prologue runtime integration:'):continue
 out.append(line)
 match=re.match(r'- \[[ xX]\] ([A-Z]+(?:-[A-Z]+)?-\d+)\s',line)
 if match and match.group(1) in ids:
  out.append('  - Prologue runtime integration: selected exports imported and visually checked in Godot on macOS; full-pack/device production approval remains pending. [Runtime manifest]('+str(indexfile)+').')
summary='\n## Prologue runtime integration — 2026-10-18\n\nSelected generated village/terrain/bridge, Mote/Rootling animations, UI, FX and audio exports are integrated into the playable opening. Supporting Rusk/villager sprites were added to ENV-01. Original source images and existing checkboxes are preserved. See [implementation and release checklist]('+str(ROOT/'docs/prologue-implementation.md')+') and [source/runtime hashes]('+str(indexfile)+'). Device testing and audio listening approval remain pending; asset checks do not assert release approval.\n'
text='\n'.join(out)+'\n'
if '## Prologue runtime integration — 2026-10-18' not in text:text+=summary
(ROOT/'docs/lanterns_underroot_master_asset_checklist.md').write_text(text)
print(f'Recorded {len(ids)} integrated asset IDs, {len(records)} prepared runtime files. Project checklist ready for master synchronization.')
