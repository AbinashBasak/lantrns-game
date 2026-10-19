"""Copy selected Hollow Sentinel exports; retain archived source generations unchanged."""
from pathlib import Path
import hashlib
import json
import shutil
ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'assets/production/phase_03_enemies_and_chapter_1_boss/hollow_sentinel_boss'
OUT = ROOT / 'assets/runtime/chapter01/boss'
SPECS = {'idle': ('BOSS-002', 'idle'), 'move': ('BOSS-003', 'walk_reposition_profile_corrected'), 'windup': ('BOSS-004', 'attack_windup'), 'slam': ('BOSS-005', 'ground_slam'), 'swipe': ('BOSS-006', 'arm_swipe'), 'hurt': ('BOSS-008', 'stagger_damage'), 'transition': ('BOSS-009', 'phase_transition'), 'defeat': ('BOSS-010', 'defeat'), 'wake': ('BOSS-011', 'awakening')}
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def prepare():
    OUT.mkdir(parents=True, exist_ok=True)
    pack = {'identity': 'Hollow Sentinel — Chapter 1 temple guardian; not Chapter 2 Mossjaw', 'provenance': 'Unmodified selected generated prototype exports copied from production archive; production approval not inferred.', 'animations': {}}
    for animation, (aid, clip_name) in SPECS.items():
        meta = LIB / aid / 'metadata.json'
        data = json.loads(meta.read_text())
        clip = next(c for c in data['clips'] if c['clip'] == clip_name)
        frames = []
        for raw in clip['frames']:
            source = Path(raw)
            if not source.is_file():
                source = ROOT / raw.split('/lantrns-game/', 1)[1]
            destination = OUT / source.name
            shutil.copy2(source, destination)
            frames.append({'path': 'res://' + destination.relative_to(ROOT).as_posix(), 'source': source.relative_to(ROOT).as_posix(), 'sha256': sha(destination), 'source_sha256': sha(source)})
        pack['animations'][animation] = {'asset_id': aid, 'source_metadata': meta.relative_to(ROOT).as_posix(), 'frames': frames, 'durations_ms': clip['frame_durations_ms'], 'loop': clip['loop'], 'pivot_px': clip.get('pivot_px', [256, 480])}
    (OUT / 'manifest.json').write_text(json.dumps(pack, indent=2) + '\n')
    print(f"Prepared {sum(len(c['frames']) for c in pack['animations'].values())} generated Sentinel frames")
if __name__ == '__main__':
    prepare()
