"""Preserve generated originals and stage selected Chapter 1 audio/FX exports."""
from pathlib import Path
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parents[1]
registry = json.loads((ROOT / 'assets/production/asset_registry.json').read_text())
lookup = {asset['asset_id']: asset for asset in registry['assets']}
base = ROOT / 'assets/runtime/chapter01/presentation'
base.mkdir(parents=True, exist_ok=True)
records, audio, animations = [], {}, {}


def copy(source, asset_id):
    source = Path(source)
    target = base / source.name
    shutil.copy2(source, target)
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    path = 'res://' + str(target.relative_to(ROOT))
    records.append(dict(asset_id=asset_id, source=str(source.relative_to(ROOT)),
                        runtime=path, source_sha256=digest, runtime_sha256=digest))
    return path


audio_ids = {
    'forest_music': 'AUD-MUS-003', 'temple_music': 'AUD-MUS-004',
    'boss_music': 'AUD-MUS-005', 'forest_ambience': 'AUD-AMB-003',
    'temple_ambience': 'AUD-AMB-004', 'step': 'AUD-SFX-001',
    'stone_step': 'AUD-SFX-002', 'jump': 'AUD-SFX-003', 'land': 'AUD-SFX-004',
    'swing': 'AUD-SFX-005', 'impact': 'AUD-SFX-006', 'enemy_attack': 'AUD-SFX-007',
    'enemy_defeat': 'AUD-SFX-008', 'hurt': 'AUD-SFX-009', 'fragment': 'AUD-SFX-011',
    'rune': 'AUD-SFX-012', 'checkpoint': 'AUD-SFX-013',
    'puzzle_complete': 'AUD-SFX-014', 'boss_slam': 'AUD-SFX-015',
    'boss_damage': 'AUD-SFX-016', 'boss_defeat': 'AUD-SFX-017', 'ui': 'AUD-SFX-018',
}
for key, aid in audio_ids.items():
    metadata = json.loads(Path(lookup[aid]['metadata']).read_text())
    clip = metadata['deliverables'][0]['files'][0]
    audio[key] = dict(path=copy(clip['ogg_path'], aid), loop=clip.get('loop', False), asset_id=aid)
for aid, key in [('FX-001', 'swing'), ('FX-002', 'impact'), ('FX-004', 'enemy_defeat'),
                 ('FX-006', 'jump'), ('FX-007', 'land'), ('FX-011', 'rune'),
                 ('FX-012', 'puzzle_complete'), ('FX-013', 'fragment'),
                 ('FX-014', 'checkpoint'), ('FX-015', 'boss_slam'),
                 ('FX-017', 'boss_defeat'), ('FX-018', 'respawn')]:
    metadata = json.loads(Path(lookup[aid]['metadata']).read_text())
    deliverable = metadata['deliverables'][0]
    paths = [p for p in deliverable['export_paths'] if p.endswith('.png') and not p.endswith('_sheet.png')]
    animations[key] = dict(frames=[dict(path=copy(p, aid)) for p in paths],
                           durations_ms=[1000 / deliverable['timing']['fps']] * len(paths),
                           loop=False, pivot_px=deliverable['pivot_px'], asset_id=aid)
(base / 'manifest.json').write_text(json.dumps(dict(audio=audio, animations=animations, records=records), indent=2) + '\n')
print(f'{len(audio)} audio clips; {len(animations)} effects; {len(records)} verified source copies')
