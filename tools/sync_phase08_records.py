"""Update reviewed Phase08 prototype records and propose a synchronized master."""
from pathlib import Path
import json,re,datetime
ROOT=Path(__file__).resolve().parents[1];LIB=ROOT/'assets/production';PHASE=LIB/'phase_08_user_interface';MASTER=Path('/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md');COPY=ROOT/'docs/lanterns_underroot_master_asset_checklist.md'
text=MASTER.read_text() if MASTER.exists() else COPY.read_text();rp=LIB/'asset_registry.json';reg=json.loads(rp.read_text());now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat();rows=[];links=[]
original_checks={aid:v.lower()=='x' for v,aid in re.findall(r'^- \[([ xX])\] ([A-Z]+-[0-9]+) —',text,re.M)}
for a in reg['assets']:
 aid=a['asset_id']
 if aid in original_checks:a['checked']=original_checks[aid]
 if a['phase']!='08':continue
 folder=Path(a['folder']);folder.mkdir(parents=True,exist_ok=True);mp=folder/'metadata.json';sources=list((folder/'source_images').glob('*.png'));meta=json.loads(mp.read_text()) if mp.exists() else {};done=bool(meta.get('requested_deliverables_saved_and_reviewed'))
 a.update({'checked':a.get('checked',False) or done,'source_count':len(sources),'production_approved':False,'stage':meta.get('stage','generation pending'),'exports_folder':str(folder/'exports'),'previews_folder':str(folder/'previews')})
 selected=list(dict.fromkeys([Path(d['path']) for d in meta.get('deliverables',[]) if d.get('path')]+[Path(f['source_path']) for d in meta.get('deliverables',[]) for f in d.get('frames',[]) if isinstance(f,dict) and f.get('source_path')]))
 assert all(p.is_file() for p in selected),aid
 if selected:a['primary_image']=str(selected[0])
 if mp.exists():a['metadata']=str(mp)
 block=f'  <!-- phase08-record:{aid}:start -->\n  - Production stage: {a["stage"].replace("_"," ")}. Final production approval pending.\n  - Saved folder: [{aid}]({folder})'
 links.append(folder)
 if mp.exists():block+=f' · [metadata]({mp}) · [exports]({folder/"exports"}) · [previews]({folder/"previews"})';links += [mp,folder/'exports',folder/'previews']
 block+='\n'
 for p in selected:block+=f'  - Selected source: [{p.name}]({p})\n';links.append(p)
 block+=f'  <!-- phase08-record:{aid}:end -->'
 text=re.sub(rf'\n  <!-- phase08-record:{aid}:start -->.*?<!-- phase08-record:{aid}:end -->','',text,flags=re.S)
 text=re.sub(rf'^- \[([ xX])\] {aid} — ([^\n]+)',lambda m:f'- [{"x" if a["checked"] else m[1]}] {aid} — {m[2]}\n{block}',text,flags=re.M)
 rows.append({'id':aid,'title':a['title'],'source_count':len(sources),'reviewed_prototype_complete':done,'metadata':str(mp) if mp.exists() else None,'stage':a['stage']})
count=sum(x['reviewed_prototype_complete'] for x in rows);index=PHASE/'PHASE08_index.md';index_link=f' [Asset and prompt index]({index}).' if index.exists() else '';summary=f'\n<!-- phase08-summary:start -->\n**Reviewed prototype packs: {count}/25.**{index_link} Checked items record saved and reviewed UI art/component prototypes, not final production approval. Sources, state/module exports, prompts, crop maps and checker previews are recorded per item. Responsive layout, focus/input navigation, text/localization, accessibility and Godot integration require separate validation. No ZIP files or runtime integration added.\n<!-- phase08-summary:end -->\n'
text=re.sub(r'\n<!-- phase08-summary:start -->.*?<!-- phase08-summary:end -->\n','',text,flags=re.S);text=text.replace('# Phase 08 — User Interface\n','# Phase 08 — User Interface\n'+summary)
COPY.write_text(text);Path('/tmp/lanterns_underroot_master_asset_checklist.updated.md').write_text(text)
reg['checked_count']=sum(bool(a.get('checked')) for a in reg['assets']);reg['last_updated']=now;rp.write_text(json.dumps(reg,indent=2,ensure_ascii=False)+'\n')
PHASE.mkdir(exist_ok=True);(PHASE/'PHASE08_progress.json').write_text(json.dumps({'last_updated':now,'reviewed_packs':count,'expected':25,'production_approved':False,'packs':rows},indent=2,ensure_ascii=False)+'\n')
assert all(p.exists() for p in links),[str(p) for p in links if not p.exists()]
print(f'{count}/25 reviewed prototype packs; {len(links)} saved links validated')
