from pathlib import Path
import json,hashlib,shutil
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
base=ROOT/'assets/runtime/chapter01/story';base.mkdir(parents=True,exist_ok=True)
registry=json.loads((ROOT/'assets/production/asset_registry.json').read_text())
assets={a['asset_id']:a for a in registry['assets']}
rows=[]
for aid,pattern,name in [('OBJ-002','OBJ-002_state_01.png','fragment'),('UI-003','UI-003_00*.png','token'),('UI-008','*boss_frame*.png','boss_frame'),('UI-008','*boss_fill*.png','boss_fill'),('UI-008','*boss_track*.png','boss_track'),('ENV-04','ENV-04_distant_background.png','orchard_background'),('ENV-04','ENV-04_midground.png','orchard_trees')]:
 source=next((Path(assets[aid]['folder'])/'exports').glob(pattern))
 out=base/(name+'.png')
 im=Image.open(source).convert('RGBA');bounds=None
 if not name.startswith('orchard'):
  bounds=im.getchannel('A').point(lambda x:255 if x>40 else 0).getbbox();im=im.crop(bounds)
 im.save(out)
 rows.append(dict(asset_id=aid,source=str(source.relative_to(ROOT)),runtime=str(out.relative_to(ROOT)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),runtime_sha256=hashlib.sha256(out.read_bytes()).hexdigest(),crop=list(bounds) if bounds else None,dimensions=list(im.size)))
(base/'manifest.json').write_text(json.dumps({'files':rows},indent=2)+'\n')
print(len(rows),'story runtime exports')
