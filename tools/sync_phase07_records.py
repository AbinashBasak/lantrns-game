"""Sync reviewed Phase07 effect records into the registry, checklist copy, index and progress file."""
from pathlib import Path
import json, re, datetime, sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_phase07_fx import ROOT, PHASE, CANON, canon

COPY = ROOT / 'docs/lanterns_underroot_master_asset_checklist.md'
rp = ROOT / 'assets/production/asset_registry.json'
text, reg = COPY.read_text(), json.loads(rp.read_text())
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5, minutes=30))).isoformat()
rows, links = [], []
for a in reg['assets']:
    if a['phase'] != '07':
        continue
    aid = a['asset_id']
    folder = PHASE / aid
    meta = json.loads((folder / 'metadata.json').read_text())
    done = bool(meta.get('requested_deliverables_saved_and_reviewed'))
    d = meta['deliverables'][0]
    a.update({'checked': done, 'source_count': len(list((folder / 'source_images').glob('*.png'))), 'production_approved': False, 'stage': meta['stage'],
              'exports_folder': canon(folder / 'exports'), 'previews_folder': canon(folder / 'previews'), 'primary_image': d['path'], 'metadata': canon(folder / 'metadata.json')})
    block = (f'  <!-- phase07-record:{aid}:start -->\n  - Production stage: {a["stage"]}. Final production approval pending.\n'
             f'  - Saved folder: [{aid}]({a["folder"]}) · [metadata]({a["metadata"]}) · [exports]({a["exports_folder"]}) · [previews]({a["previews_folder"]})\n'
             f'  - Selected source: [{Path(d["path"]).name}]({d["path"]})\n  <!-- phase07-record:{aid}:end -->')
    links += [folder, folder / 'metadata.json', folder / 'exports', folder / 'previews', Path(str(ROOT) + d['path'][len(CANON):])]
    text = re.sub(rf'\n  <!-- phase07-record:{aid}:start -->.*?<!-- phase07-record:{aid}:end -->', '', text, flags=re.S)
    text = re.sub(rf'^- \[([ xX])\] {aid} — ([^\n]+)', lambda m: f'- [{"x" if done else " "}] {aid} — {m[2]}\n{block}', text, flags=re.M)
    rows.append({'id': aid, 'title': a['title'], 'frames': d['frame_count'], 'cell': d['export_cell_dimensions'], 'fps': d['timing']['fps'], 'loop': d['loop'],
                 'reviewed_prototype_complete': done, 'metadata': a['metadata'], 'stage': a['stage']})
count = sum(r['reviewed_prototype_complete'] for r in rows)
summary = (f'\n<!-- phase07-summary:start -->\n**Reviewed procedural prototypes: {count}/20.** [Asset index]({CANON}/assets/production/phase_07_visual_effects/PHASE07_index.md). '
           'Checked items record saved and reviewed effect frame sheets, not final production approval. Each item has per-frame PNGs, a sheet, a frames.json with cell size, fps, loop and pivot, light/dark contact previews and an animated GIF. '
           'Effects are procedural (tools/fx_effects.py), not generated art. In-engine timing, blend modes, color review and runtime integration remain separate. No ZIP files or runtime integration added.\n<!-- phase07-summary:end -->\n')
text = re.sub(r'\n<!-- phase07-summary:start -->.*?<!-- phase07-summary:end -->\n', '', text, flags=re.S)
text = text.replace('# Phase 07 — Visual Effects\n', '# Phase 07 — Visual Effects\n' + summary)
COPY.write_text(text)
reg['checked_count'] = sum(bool(a.get('checked')) for a in reg['assets'])
reg['last_updated'] = now
rp.write_text(json.dumps(reg, indent=2, ensure_ascii=False) + '\n')
(PHASE / 'PHASE07_progress.json').write_text(json.dumps({'last_updated': now, 'reviewed_packs': count, 'expected': 20, 'production_approved': False, 'packs': rows}, indent=2, ensure_ascii=False) + '\n')
lines = [f'# Phase 07 — Visual effect prototypes\n',
         f'**{count}/20 procedural prototypes · {sum(r["frames"] for r in rows)} frames.** Rendered by `tools/fx_effects.py` with Pillow and numpy using the ART-002 VFX palette; no generative image model was used. '
         'All renders are deterministic. The checklist records prototype delivery only: color/timing review, additive-blend setup, sprite-frame import and Godot integration remain pending. Originals are never overwritten; rerun `tools/generate_phase07_fx.py` to regenerate.\n',
         '| Asset | Frames | Cell | FPS | Loop | Saved records |', '|---|---:|---|---:|---|---|']
for r, a in zip(rows, [x for x in reg['assets'] if x['phase'] == '07']):
    lines.append(f'| {r["id"]} — {r["title"]} | {r["frames"]} | {r["cell"][0]} × {r["cell"][1]} | {r["fps"]} | {"yes" if r["loop"] else "no"} | [metadata]({a["metadata"]}) · [exports]({a["exports_folder"]}) · [previews]({a["previews_folder"]}) |')
(PHASE / 'PHASE07_index.md').write_text('\n'.join(lines) + '\n')
missing = [str(p) for p in links if not p.exists()]
assert not missing, missing
print(f'{count}/20 reviewed prototypes; {len(links)} saved links validated')
