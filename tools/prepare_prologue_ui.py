"""Create deterministic runtime derivatives from reviewed UI exports; leave archive untouched."""
from pathlib import Path
from PIL import Image
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'assets/production/phase_08_user_interface'
OUT=ROOT/'assets/runtime/prologue/ui'
OUT.mkdir(parents=True,exist_ok=True)
specs={
'health_full':('UI-001','UI-001_00_full.png',(40,40)),
'health_empty':('UI-001','UI-001_02_empty.png',(40,40)),
'objective':('UI-004','UI-004_01_active.png',None),
'prompt':('UI-005','UI-005_02_bubble_filled.png',None),
'interact':('UI-005','UI-005_00_keycap_neutral.png',(80,80)),
'dialogue':('UI-009','UI-009_dialogue_panel.png',None),
'pause_icon':('UI-011','UI-011_normal_128.png',(56,56)),
'title_background':('UI-016','UI-016_component_01.png',(1280,720)),
'logo':('UI-017','UI-017_component_01.png',(520,250)),
'panel':('UI-019','UI-019_component_01.png',None),
}
for state,num in [('normal',1),('hover',2),('pressed',3),('disabled',4)]: specs['button_'+state]=('UI-018',f'UI-018_component_0{num}.png',None)
for side in ['left','right']:
 for state in ['rest','pressed']: specs[f'{side}_{state}']=('UI-013',f'UI-013_{side}_{state}_128.png',(80,80))
for name,aid in [('jump','UI-014'),('attack','UI-015')]:
 for state in ['normal','pressed']: specs[f'{name}_{state}']=(aid,f'{aid}_{state}_128.png',(80,80))
records=[]
for name,(aid,filename,size) in specs.items():
 path=next(SRC.glob(f'*/{aid}/exports/{filename}'))
 # Read provenance before deriving runtime copies.
 meta=json.loads((path.parent.parent/'metadata.json').read_text())
 im=Image.open(path).convert('RGBA')
 bbox=im.getchannel('A').getbbox()
 if name!='title_background' and bbox: im=im.crop(bbox)
 if size:
  im.thumbnail(size,Image.Resampling.LANCZOS)
  canvas=Image.new('RGBA',size)
  canvas.alpha_composite(im,((size[0]-im.width)//2,(size[1]-im.height)//2))
  im=canvas
 out=OUT/(name+'.png');im.save(out)
 records.append({'asset_id':aid,'source':str(path.relative_to(ROOT)),'source_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'source_metadata':str((path.parent.parent/'metadata.json').relative_to(ROOT)),'output':str(out.relative_to(ROOT)),'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'dimensions':list(im.size),'derivation':'alpha bounds trimmed; aspect-preserving LANCZOS fit and transparent padding when sized','archive_stage':meta.get('stage',meta.get('production_stage','prototype'))})
(OUT/'manifest.json').write_text(json.dumps({'purpose':'Prologue runtime UI integration; original generated exports retained unchanged','assets':records},indent=2)+'\n')
print(f'Prepared {len(records)} generated UI runtime exports')
