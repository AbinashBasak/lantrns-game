from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[1];PHASE=ROOT/'assets/production/phase_08_user_interface';report=json.loads((ROOT/'docs/phase08-validation.json').read_text());assert not report['errors'] and report['pack_count']==25 and all(p['reviewed'] for p in report['packs'])
lines=['# Phase 08 — User interface asset prototypes','',f'**25 reviewed packs · {report["component_count"]} primary components/states · {report["exported_png_count"]} PNG exports · {report["exported_svg_count"]} editable glyph SVGs.**','', 'Illustrated artwork uses built-in image_gen. UI-025 uses original editable vector geometry and exact text with deterministic raster exports; its prompt map matches the current keyboard/controller bindings. Source images, prompts/specifications, provenance, crop maps and hashes are recorded per pack. Earlier generations remain archived.','', 'Menus use separate artwork, labels and layout data. Assembled previews demonstrate composition and are separate from the reusable textures. Final slicing, responsive layout, font/localization, focus navigation, accessibility, touch hit areas and Godot implementation/testing remain pending. Production approval and runtime integration are false. No ZIPs added.','']
for group in ['HUD elements','Menus and screens']:
 lines+=['## '+group,'','| Asset | Components/states | Saved files |','|---|---:|---|']
 for p in report['packs']:
  if p['subsection']!=group:continue
  mp=Path(p['metadata']);folder=mp.parent;meta=json.loads(mp.read_text());links=f'[previews]({folder/"previews"}) · [exports]({folder/"exports"}) · [metadata and prompts]({mp})'
  layout=meta.get('layout_spec')
  if not layout:
   paths=list((folder/'exports').glob('*layout*.json'));layout=str(paths[0]) if paths else None
  if layout:assert Path(layout).is_file();links+=f' · [layout/bindings]({layout})'
  lines.append(f'| {p["id"]} — {p["title"]} | {p["component_count"]} | {links} |')
 lines+=['']
lines+=['[Validation report]('+str(ROOT/'docs/phase08-validation.json')+').',''];p=PHASE/'PHASE08_index.md';p.write_text('\n'.join(lines));links=re.findall(r'\]\((/[^)]+)\)',p.read_text());assert all(Path(x).exists() for x in links);print('Index saved;',len(links),'links verified')
