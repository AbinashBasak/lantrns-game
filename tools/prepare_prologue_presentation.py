"""Copy the selected generated audio/FX into importable runtime assets."""
from pathlib import Path
import json,hashlib,shutil
ROOT=Path(__file__).resolve().parents[1]
r=json.loads((ROOT/'assets/production/asset_registry.json').read_text())
lookup={a['asset_id']:a for a in r['assets']}
base=ROOT/'assets/runtime/prologue/presentation';base.mkdir(parents=True,exist_ok=True)
audio_ids={'village_music':'AUD-MUS-002','night':'AUD-AMB-001','village_ambience':'AUD-AMB-002','rumble':'AUD-AMB-005','step':'AUD-SFX-001','jump':'AUD-SFX-003','land':'AUD-SFX-004','swing':'AUD-SFX-005','impact':'AUD-SFX-006','enemy_attack':'AUD-SFX-007','enemy_defeat':'AUD-SFX-008','hurt':'AUD-SFX-009','rescue':'AUD-SFX-011','hearth':'AUD-SFX-012','cart':'AUD-SFX-014','ui':'AUD-SFX-018'}
records=[]; audio={};animations={}
def copy(src,asset):
 dest=base/src.name;shutil.copy2(src,dest)
 sha=hashlib.sha256(src.read_bytes()).hexdigest()
 records.append(dict(asset_id=asset,source=str(src.relative_to(ROOT)),runtime='res://'+str(dest.relative_to(ROOT)),source_sha256=sha,runtime_sha256=sha))
 return 'res://'+str(dest.relative_to(ROOT))
for key,aid in audio_ids.items():
 m=json.loads(Path(lookup[aid]['metadata']).read_text());clip=m['deliverables'][0]['files'][0]
 audio[key]={'path':copy(Path(clip['ogg_path']),aid),'loop':clip.get('loop',False),'asset_id':aid}
for aid,key in [('FX-001','swing'),('FX-006','jump'),('FX-007','land'),('FX-008','debris'),('FX-009','lantern'),('FX-018','respawn')]:
 m=json.loads(Path(lookup[aid]['metadata']).read_text());d=m['deliverables'][0]
 paths=[Path(p) for p in d['export_paths'] if p.endswith('.png') and not p.endswith('_sheet.png')]
 fps=d['timing']['fps']
 animations[key]={'frames':[{'path':copy(p,aid)} for p in paths],'durations_ms':[1000/fps]*len(paths),'loop':d.get('loop',False),'pivot_px':d['pivot_px'],'asset_id':aid}
(base/'manifest.json').write_text(json.dumps(dict(audio=audio,animations=animations,records=records),indent=2)+'\n')
print(len(audio),'audio clips;',len(animations),'FX clips;',len(records),'runtime files')
