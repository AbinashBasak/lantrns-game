"""Export the generated supporting-cast atlas into two foot-pivot sprites."""
from pathlib import Path
from PIL import Image
import shutil,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
PACK=ROOT/'assets/production/phase_04_environment_packs/ENV-01'
GEN=Path('/Users/abinashbasak/.codex/generated_images/01a148b8-ed25-74c2-ab57-d51d66483b40')
files=['exec-3d04739f-79c1-4218-bded-43e206166cad.png','exec-908cbfaa-8a6a-4f01-a29d-e7a37fb283b2.png']
for i,f in enumerate(files):
 dest=PACK/'source_images'/f'ENV-01_supporting_cast_generation_{i+1:02d}.png'
 if not dest.exists():shutil.copy2(GEN/f,dest)
source=PACK/'source_images/ENV-01_supporting_cast_generation_02.png'
im=Image.open(source).convert('RGBA')
out=ROOT/'assets/runtime/prologue/environment'
records=[]
for idx,name in enumerate(['rusk','villager']):
 part=im.crop((idx*im.width//2,0,(idx+1)*im.width//2,im.height))
 bounds=part.getchannel('A').point(lambda a: 255 if a >= 128 else 0).getbbox();part=part.crop(bounds)
 path=PACK/'exports'/f'ENV-01_{name}_idle.png';part.save(path)
 runtime=out/path.name;shutil.copy2(path,runtime)
 records.append(dict(asset_id='ENV-01',name=name,source=str(source.relative_to(ROOT)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),export=str(path.relative_to(ROOT)),runtime='res://'+str(runtime.relative_to(ROOT)),sha256=hashlib.sha256(runtime.read_bytes()).hexdigest(),dimensions=list(part.size),pivot_px=[part.width/2,part.height],crop_in_atlas=[bounds[0]+idx*im.width//2,bounds[1],bounds[2]+idx*im.width//2,bounds[3]],provenance='imagegen source atlas; mechanical alpha-bounds crop, no repaint'))
(out/'npc_manifest.json').write_text(json.dumps({'asset_id':'ENV-01','generation_tool':'built-in image_gen','records':records},indent=2)+'\n')
print([(r['name'],r['dimensions']) for r in records])
