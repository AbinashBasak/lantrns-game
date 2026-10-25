"""Coordinate Chapter 3 prepared-asset provenance, registry and checklist updates."""
import collections
import hashlib
import json
import re
import shutil
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'assets/production/chapter_03_sunken_temple'
DOC = ROOT / 'docs/chapter03'
MASTER = Path('/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md')
COPY = ROOT / 'docs/lanterns_underroot_master_asset_checklist.md'
REG = ROOT / 'assets/production/asset_registry.json'


def read(p):
    return json.loads(Path(p).read_text())


def write(p, data):
    Path(p).parent.mkdir(parents=True, exist_ok=True)
    Path(p).write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n')


def real(p):
    p = Path(str(p).removeprefix('res://'))
    return p if p.is_absolute() else ROOT / p


def hashed(p):
    p = real(p)
    assert p.is_file(), p
    return dict(path=str(p), sha256=hashlib.sha256(p.read_bytes()).hexdigest(), bytes=p.stat().st_size)


def keep_copy(source, target):
    source, target = real(source), Path(target)
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists():
        assert target.read_bytes() == source.read_bytes(), target
    else:
        shutil.copy2(source, target)
    return hashed(target)


def main():
    master = MASTER.read_text() if MASTER.exists() else COPY.read_text()
    original_checks = re.findall(r'^.*\[[ xX]\].*$', master, re.M)
    registry = read(REG)
    existing = {a['asset_id']: a for a in registry['assets']}
    animation = read(DOC / 'animation-asset-preparation-handoff.json')
    environment = read(DOC / 'environment-asset-preparation.json')
    effects = read(DOC / 'lighting-vfx-preparation.json')
    depth = read(DOC / 'lighting-vfx-preparation-depth.json')
    collectibles = read(DOC / 'collectible-asset-preparation-handoff.json')
    archive = read(ROOT / 'assets/production/source_archives/chat_export_6add021c/metadata.json')
    archive_by_hash = {r['sha256']: r for r in archive['image_records']}
    groups = collections.defaultdict(lambda: dict(sources=[], prepared=[], native_resources=[], blockers=[]))
    names = {a['asset_id']: a['title'] for a in registry['assets']}
    names.update({'C3-ENM-005':'Temple Eel','C3-ENM-006':'Shrine Warden',
                  'C3-ENM-007':'Guardian Knight mini-boss','C3-ENM-008':'Sunken Guardian boss',
                  'C3-ENM-PRJ-001':'Crystal Wisp bolt',
                  'C3-BG-002':'Distant submerged ruins','C3-BG-003':'Distant waterfall layer',
                  'C3-BG-004':'Crystal cavern silhouettes','C3-BG-011':'Water caustics texture',
                  'C3-DEC-003':'Hanging vines long','C3-DEC-008':'Small rock clusters',
                  'C3-PROP-004':'Wall-mounted lantern','C3-PROP-007':'Ancient stone pillar',
                  'C3-PROP-008':'Broken pillar set / broken architecture candidates',
                  'C3-PROP-009':'Temple arch','C3-PROP-013':'Temple statue',
                  'C3-PROP-023':'Mirror pedestal candidate','C3-PROP-027':'Floating stone platform candidate',
                  'C3-TILE-007':'Ancient temple floor candidate','C3-TILE-008':'Bridge plank reference',
                  'C3-TILE-011':'Stone stairs segment','C3-TILE-012':'Wall collision tile atlas candidate',
                  'C3-TILE-020':'Waterfall collision-free visual strip'})
    native_roles = effects['native_role_mappings']
    native_names = {'C3-VFX-002':'Lantern sparks','C3-VFX-003':'Crystal pulse / motes resource',
                    'C3-VFX-005':'Golden Fragment pickup effect','C3-VFX-008':'Water splash',
                    'C3-VFX-009':'Underwater bubbles','C3-VFX-010':'Waterfall mist'}
    names.update(native_names)
    names.update({'C3-AUD-001':'Cavern ambience', 'C3-AUD-005':'Fragment pickup',
                  'C3-AUD-006':'Chest open', 'C3-AUD-008':'Rune gate rumble',
                  'C3-TILE-001':'Mossy stone platform top', 'C3-TILE-002':'Stone platform middle',
                  'C3-TILE-003':'Stone platform underside'})
    for actor in animation['assets']:
        aid = actor['asset_id']; groups[aid]['blockers'] += actor.get('missing_or_blocked', [])
        for key in ('native_spriteframes', 'native_review_scene', 'native_render_capture'):
            if actor.get(key): groups[aid]['native_resources'].append(actor[key])
    for clip in animation['clips']:
        g = groups[clip['asset_id']]
        g['sources'].append(clip['source_path'])
        g['prepared'].append(dict(kind='animation', details=clip,
                                 output_paths=[r['path'] for r in clip['exports']],
                                 preview=clip['preview_path']))
    for item in animation['standalone_projectiles']:
        g = groups[item['asset_id']]; g['sources'].append(item['source_path'])
        g['prepared'].append(dict(kind='projectile', details=item, output_paths=[item['path']]))
    for item in environment['exports']:
        g = groups[item['asset_id']]; g['sources'].append(item['source'])
        g['prepared'].append(dict(kind='environment', details=item, output_paths=[item['export']]))
    for item in effects['outputs']:
        for aid in item['official_ids']:
            g = groups[aid]; g['sources'].append(item['source_path'])
            g['prepared'].append(dict(kind='effect_texture', details=item, output_paths=[item['output_path']]))
    for aid, path in native_roles.items():
        if aid.startswith('C3-LIGHT-'):
            continue  # Scene roles stay in the catalog, not new asset inventory IDs.
        groups[aid]['native_resources'].append(path)
    for item in depth['assets']:
        g = groups[item['official_id']]
        paths = [item['derived_normal_path'], item['canvas_texture']]
        paths += [m['output'] for m in item['maps']]
        g['prepared'].append(dict(kind='depth_bitmap_material', details=item, output_paths=paths))
        g['native_resources'].append(depth['resource_scene'])
    for item in collectibles['assets']:
        aid = item['asset_id']; names[aid] = item['title']
        g = groups[aid]; g['sources'] += [s['path'] for s in item['sources']]
        g['blockers'] += item.get('blockers', [])
        g['prepared'].append(dict(kind='collectible', details=item,
                                 output_paths=[r['path'] if isinstance(r, dict) else r
                                               for r in item.get('runtime_exports', [])]))
        for key in ('native_spriteframes','native_review_scene','native_render_capture'):
            if item.get(key): g['native_resources'].append(item[key])
    for aid in ('C3-CHR-001','C3-CHR-002','C3-CHEST-ASSET-001','C3-REF-002'):
        if aid not in existing: continue
        prior = read(existing[aid]['metadata']); g = groups[aid]
        g['sources'] += [s['path'] for s in prior.get('sources', [])]
        if prior.get('review_scene'): g['native_resources'].append(prior['review_scene'])
        g['blockers'].append(prior.get('notes', 'Source design, scale and clean export approval remain pending.'))
    for excluded in animation['excluded_sources']:
        source = archive_by_hash.get(excluded.get('sha256'), {})
        for aid in source.get('requested_asset_ids', []):
            if aid in groups:
                groups[aid]['sources'].append(excluded['source_path'])
                groups[aid]['blockers'].append(excluded['reason'])
    prefab_path=DOC/'native-prefab-completion.json'
    if prefab_path.exists():
        for item in read(prefab_path)['assets']:
            groups[item['official_id']]['native_resources'].append(item['native_path'])
            groups[item['official_id']]['prepared'].append(dict(
                kind='reusable_native_prefab', details=item, output_paths=[]))
    audio_path=DOC/'audio-asset-preparation.json'
    if audio_path.exists():
        for item in read(audio_path)['assets']:
            g=groups[item['official_id']]
            g['sources'].append(item['source_path'])
            g['native_resources'].append(item['native_path'])
            g['prepared'].append(dict(kind='audio', details=item, output_paths=[item['runtime_path']]))
    terrain_path=DOC/'terrain-handoff.json'
    if terrain_path.exists():
        terrain=read(terrain_path)
        for item in terrain.get('exports',[]):
            g=groups[item['asset_id']]
            g['sources'].append(item['source'])
            g['prepared'].append(dict(kind='terrain', details=item, output_paths=[item['export']]))
            g['native_resources'] += terrain.get('native_resources',[])
            g['native_resources'] += [terrain[k] for k in ('native_scene','native_tileset') if terrain.get(k)]
    catalog = []
    for aid, group in sorted(groups.items()):
        cat = ('enemies' if aid.startswith('C3-ENM-') else
               'collectibles' if aid.startswith('C3-ITM-') else
               'backgrounds' if aid.startswith('C3-BG-') else
               'terrain' if aid.startswith('C3-TILE-') else
               'foliage' if aid.startswith('C3-DEC-') else
               'vfx' if aid.startswith('C3-VFX-') else
               'audio' if aid.startswith('C3-AUD-') else 'props')
        folder = Path(existing[aid]['folder']) if aid in existing else LIB / cat / aid
        for sub in ('source_images','exports','previews'):
            (folder/sub).mkdir(parents=True, exist_ok=True)
        mp = folder/'metadata.json'
        metadata = read(mp) if mp.exists() else dict(asset_id=aid, title=names.get(aid, aid), sources=[])
        metadata.setdefault('sources', [])
        source_records = []
        for source in dict.fromkeys(group['sources']):
            src = real(source); h = hashed(src)
            old = next((s for s in metadata['sources'] if s.get('sha256') == h['sha256']), None)
            if old and Path(old['path']).exists():
                source_records.append(old); continue
            source_subfolder='source_audio' if cat=='audio' else 'source_images'
            rec = keep_copy(src, folder/source_subfolder/f'{aid}_organized_{src.name}')
            source = archive_by_hash.get(rec['sha256'], {})
            rec.update(provenance='unchanged supplied original; organized by verified subject/role',
                       archive_original_path=str(src), source_message_id=source.get('source_message_id'),
                       source_requested_ids=source.get('requested_asset_ids', []),
                       generated_subject_title=source.get('generated_subject_title'),
                       production_approved=False)
            if src.suffix.lower() == '.png':
                with Image.open(src) as im: rec['dimensions'] = list(im.size)
            metadata['sources'].append(rec); source_records.append(rec)
        exports = []
        for i, prepared in enumerate(group['prepared']):
            for path in prepared['output_paths']:
                source = real(path)
                target = folder/'exports'/'organized_v1'/f'{aid}_{i:02}_{source.name}'
                rec = keep_copy(source, target)
                rec.update(runtime_review_path=str(source), kind=prepared['kind'])
                exports.append(rec)
            if prepared.get('preview'):
                source = real(prepared['preview'])
                keep_copy(source, folder/'previews'/'organized_v1'/f'{aid}_{i:02}_{source.name}')
        natives = [hashed(p) for p in dict.fromkeys(group['native_resources'])]
        stage = ('prepared exports and editable native resources; final art/gameplay approval pending'
                 if exports or natives else 'sources organized; clean deliverables blocked; see metadata')
        metadata.update(stage=stage, production_approved=False,
                        governing_bible=str(ROOT/'lanterns_underroot_chapter_3_production_bible.md'),
                        organized_v1=dict(prepared=group['prepared'], exports=exports, native_resources=natives,
                                          missing_or_blocked=group['blockers'],
                                          actual_scene_scope='isolated native review; not campaign section approval',
                                          editor_ui_inspection='blocked: native app-control pipe unavailable'))
        write(mp, metadata)
        entry = existing.get(aid)
        if entry is None:
            entry = dict(asset_id=aid, title=names.get(aid, aid), phase='C3', subsection=cat, checked=False)
            registry['assets'].append(entry)
        entry.update(folder=str(folder), metadata=str(mp), source_count=len(metadata['sources']),
                     stage=stage, exports_folder=str(folder/'exports'), previews_folder=str(folder/'previews'),
                     production_approved=False)
        if source_records and (exports or natives):
            primary_key='primary_audio' if cat=='audio' else 'primary_image'
            entry.setdefault(primary_key, source_records[0]['path'])
        catalog.append(dict(asset_id=aid, title=entry['title'], metadata=str(mp), folder=str(folder),
                            prepared_outputs=len(exports), native_resources=[r['path'] for r in natives],
                            blockers=group['blockers'], stage=stage, production_approved=False))
    catalog_path = ROOT/'resources/chapter_03/asset_catalog.json'
    write(catalog_path, dict(governing_bible=str(ROOT/'lanterns_underroot_chapter_3_production_bible.md'),
                            assets=catalog, native_light_roles=native_roles,
                            approval_policy='Bible section17; imported diagnostic assets are not final approval',
                            production_approved=False))
    registry.update(asset_count=len(registry['assets']), checked_count=sum(a.get('checked',False) for a in registry['assets']),
                    last_updated='2026-10-25', chapter_03_organized_catalog=str(catalog_path))
    write(REG, registry)
    report = DOC/'organized-asset-index.md'
    lines = ['# Chapter 3 organized asset index', '',
             'The user-designated root production bible governs this workspace. Sources remain unchanged; '
             'derived outputs are in category art folders, and their archive copies/recipes are under registered asset IDs. '
             'Native AnimationPlayer/AnimationTree, PointLight2D, CanvasTexture and particle nodes remain editable.', '',
             f'[Complete catalog]({catalog_path}) · [Depth/bitmap light proof]({DOC/"lighting-vfx-preparation-depth.md"}) · '
             f'[Pending-work completion]({DOC/"pending-completion.md"})', '',
             'Editor UI operation could not be verified because the native app-control pipe failed. '
             'Native Godot import, resource checks, playback/state tests and graphical renders were run. '
             'Final gameplay-section, collision, mobile performance and art approval remain pending.', '',
             '| ID | Saved outputs | Native resources | Stage |', '|---|---:|---:|---|']
    lines += [f'| [{r["asset_id"]}]({r["metadata"]}) | {r["prepared_outputs"]} | {len(r["native_resources"])} | {r["stage"]} |' for r in catalog]
    lines += ['', '## Remaining gates', '',
              'Native mossy top/middle/underside candidates now have constrained mirrored joins and separate collision review. '
              'Their material/repetition approval, corners, arbitrary-height transitions and autoterrain peering remain open. '
              'Matching rune-door states, missing character/enemy actions and clean isolated art for blocked collectible '
              'families remain source dependencies. Four fitting existing audio prototypes are prepared; the other sixteen '
              'chapter cues are absent. Perspective prop boards and flattened scene concepts remain references. '
              'Direct editor UI work remains blocked by the native app-control connection.']
    report.write_text('\n'.join(lines)+'\n')
    marker='<!-- c3-organized-v1:start -->'; end='<!-- c3-organized-v1:end -->'
    block = [marker, '## Chapter 3 organized available assets — 2026-10-25', '',
             f'[{len(catalog)} registered asset records, exports and native resources]({report}). '
             'Animation graphs use Godot AnimationPlayer/AnimationTree; light/material reviews use native PointLight2D '
             'and supplied depth/bitmap-derived materials. Earlier sources and generations are preserved. '
             'Technical review does not mark missing source actions, art cleanup or final campaign approval complete.', '']
    new_ids = set(groups)-set(existing)
    block += [f'- [ ] {r["asset_id"]} — {r["title"]}\n  - [Saved metadata and stage]({r["metadata"]})' for r in catalog if r['asset_id'] in new_ids]
    block += ['', end]
    text='\n'.join(block)
    if marker in master:
        # Keep previously introduced unchecked inventory entries on reruns.
        old=re.search(re.escape(marker)+r'.*?'+re.escape(end),master,re.S).group()
        old_entries=re.findall(r'(?m)^- \[.\] C3-[^\n]+(?:\n  - [^\n]+)?',old)
        if old_entries: text=text.replace('\n\n'+end, '\n'+ '\n'.join(old_entries)+'\n\n'+end)
        master=re.sub(re.escape(marker)+r'.*?'+re.escape(end),lambda _:text,master,flags=re.S)
    else: master=master.rstrip()+'\n\n'+text+'\n'
    for line in original_checks:
        assert line in master, 'Existing checkbox was removed: '+line
    if MASTER.exists(): MASTER.write_text(master)
    COPY.write_text(master)
    for r in catalog:
        assert Path(r['metadata']).is_file()
        for n in r['native_resources']: assert Path(n).is_file()
    assert not MASTER.exists() or MASTER.read_bytes()==COPY.read_bytes()
    print(json.dumps(dict(registered_records=len(catalog), new_ids=len(new_ids),
                          organized_export_copies=sum(r['prepared_outputs'] for r in catalog),
                          report=str(report)),indent=2))


if __name__=='__main__': main()
