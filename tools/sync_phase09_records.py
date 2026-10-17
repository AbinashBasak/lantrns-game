"""Sync reviewed Phase09 audio records into the registry, checklist copy, index and progress file."""
from pathlib import Path
import json, re, datetime, sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_phase09_audio import ROOT, PHASE, CANON, canon, SUBDIR

COPY = ROOT / 'docs/lanterns_underroot_master_asset_checklist.md'
rp = ROOT / 'assets/production/asset_registry.json'
text, reg = COPY.read_text(), json.loads(rp.read_text())
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5, minutes=30))).isoformat()
rows, links = [], []


def real(c):
    return Path(str(ROOT) + c[len(CANON):])


for a in reg['assets']:
    if a['phase'] != '09':
        continue
    aid = a['asset_id']
    folder = PHASE / SUBDIR[aid.split('-')[1]] / aid
    meta = json.loads((folder / 'metadata.json').read_text())
    done = bool(meta.get('requested_deliverables_saved_and_reviewed'))
    d = meta['deliverables'][0]
    a.update({'checked': done, 'production_approved': False, 'stage': meta['stage'], 'exports_folder': canon(folder / 'exports'), 'previews_folder': canon(folder / 'previews'),
              'primary_audio': d['path'], 'primary_image': d['preview_path'], 'metadata': canon(folder / 'metadata.json'), 'file_count': len(d['files'])})
    block = (f'  <!-- phase09-record:{aid}:start -->\n  - Production stage: {a["stage"]}. Final production approval pending.\n'
             f'  - Saved folder: [{aid}]({a["folder"]}) · [metadata]({a["metadata"]}) · [exports]({a["exports_folder"]}) · [previews]({a["previews_folder"]})\n'
             f'  - Selected audio: [{Path(d["path"]).name}]({d["path"]}) · [spectrogram]({d["preview_path"]})\n  <!-- phase09-record:{aid}:end -->')
    links += [folder, folder / 'metadata.json', folder / 'exports', folder / 'previews', real(d['path']), real(d['preview_path'])]
    text = re.sub(rf'\n  <!-- phase09-record:{aid}:start -->.*?<!-- phase09-record:{aid}:end -->', '', text, flags=re.S)
    text = re.sub(rf'^- \[([ xX])\] {aid} — ([^\n]+)', lambda m: f'- [{"x" if done else " "}] {aid} — {m[2]}\n{block}', text, flags=re.M)
    f0 = d['files'][0]
    rows.append({'id': aid, 'title': a['title'], 'group': a['subsection'], 'files': len(d['files']), 'duration_s': f0['duration_s'], 'loop': d['loop'],
                 'lufs_integrated': f0['lufs_integrated'], 'peak_dbfs': f0['peak_dbfs'], 'reviewed_prototype_complete': done, 'metadata': a['metadata'], 'stage': a['stage']})
count = sum(r['reviewed_prototype_complete'] for r in rows)
summary = (f'\n<!-- phase09-summary:start -->\n**Reviewed procedural prototypes: {count}/34.** [Asset index]({CANON}/assets/production/phase_09_audio_asset_inventory/PHASE09_index.md). '
           'Checked items record saved audio exports with level, loudness, clipping and loop-seam measurements and a spectrogram preview, not final production approval. '
           'Audio is synthesized from code (tools/audiolib.py, aud_sfx.py, aud_amb.py, aud_music.py), was not auditioned by ear, and music tracks are placeholder-grade. '
           'Listening review, mix balance and runtime integration remain separate. No ZIP files or runtime integration added.\n<!-- phase09-summary:end -->\n')
text = re.sub(r'\n<!-- phase09-summary:start -->.*?<!-- phase09-summary:end -->\n', '', text, flags=re.S)
text = text.replace('# Phase 09 — Audio Asset Inventory\n', '# Phase 09 — Audio Asset Inventory\n' + summary)
COPY.write_text(text)
reg['checked_count'] = sum(bool(a.get('checked')) for a in reg['assets'])
reg['last_updated'] = now
rp.write_text(json.dumps(reg, indent=2, ensure_ascii=False) + '\n')
(PHASE / 'PHASE09_progress.json').write_text(json.dumps({'last_updated': now, 'reviewed_packs': count, 'expected': 34, 'production_approved': False, 'auditioned_by_ear': False, 'packs': rows}, indent=2, ensure_ascii=False) + '\n')
lines = ['# Phase 09 — Audio prototypes\n',
         f'**{count}/34 procedural prototypes · {sum(r["files"] for r in rows)} audio files.** Synthesized from code with numpy and scipy and encoded as Ogg Vorbis (sound effects also as 16-bit 44.1 kHz WAV); no recorded material, sample library or music model was used. '
         'Levels, loudness, clipping, DC offset and loop seams were measured and each asset has a spectrogram, but nothing was auditioned by ear. Music is placeholder-grade. '
         'Loudness targets: ambience -28 LUFS, music -20 LUFS, sound effects peak -1.5 dBFS. Loops are seamless; enable loop on import. Rerun `tools/generate_phase09_audio.py` to regenerate.\n']
for grp in ('Sound effects', 'Ambient soundscapes', 'Music'):
    lines += [f'## {grp}\n', '| Asset | Files | Length | Loop | LUFS | Peak dBFS | Saved records |', '|---|---:|---:|---|---:|---:|---|']
    for r in rows:
        if r['group'] == grp:
            a = next(x for x in reg['assets'] if x['asset_id'] == r['id'])
            lufs = '—' if r['lufs_integrated'] is None else r['lufs_integrated']
            lines.append(f'| {r["id"]} — {r["title"]} | {r["files"]} | {r["duration_s"]} s | {"yes" if r["loop"] else "no"} | {lufs} | {r["peak_dbfs"]} | [metadata]({a["metadata"]}) · [exports]({a["exports_folder"]}) · [previews]({a["previews_folder"]}) |')
    lines.append('')
(PHASE / 'PHASE09_index.md').write_text('\n'.join(lines) + '\n')
missing = [str(p) for p in links if not p.exists()]
assert not missing, missing
print(f'{count}/34 reviewed prototypes; {len(links)} saved links validated')
