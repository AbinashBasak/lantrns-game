"""Rebuild prototype animation assets from the archived original generated sheets.
Requires Pillow, numpy, scipy. Does not alter archived originals.
These are recovered-source derivatives, not the original downloadable ZIP bytes.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageOps
from scipy import ndimage
import numpy as np
import json, zipfile, hashlib
ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'archive/shared-chat/images'
OUT = ROOT / 'assets/characters/tavi'
PREVIEWS = ROOT / 'archive/rebuilt-assets'
OUT.mkdir(parents=True, exist_ok=True)
PREVIEWS.mkdir(parents=True, exist_ok=True)
# Asset name, source ID prefix, columns, vertical character band, animation FPS, loop.
SPECS = [
 ('idle','56fc',8,(160,625),7,True),
 ('run','8e54',12,(145,452),12,True),
 ('jump_start','c220',8,(100,478),12,False),
 ('jump_rise','df08',8,(110,453),10,False),
 ('jump_fall','bf74',8,(110,470),10,False),
 ('landing','23d8',8,(110,447),14,False),
 ('attack_1','ded4',8,(110,437),21,False),
]
all_specs=[]
for animation,prefix,cols,(y0,y1),fps,loop in SPECS:
 source = next(SOURCES.glob('00000000-'+prefix+'*.png'))
 original=Image.open(source)
 im=original.convert('RGBA')
 # One source (jump rise) is RGB with a near-black matte. Only remove dark
 # pixels connected to the canvas edge; preserve interior outlines and clothes.
 if original.mode!='RGBA':
  arr=np.asarray(im).copy()
  dark=np.max(arr[:,:,:3],axis=2)<38
  seed=np.zeros(dark.shape,dtype=bool)
  seed[0,:]=dark[0,:];seed[-1,:]=dark[-1,:]
  seed[:,0]=dark[:,0];seed[:,-1]=dark[:,-1]
  background=ndimage.binary_propagation(seed,mask=dark)
  arr[:,:,3][background]=0
  im=Image.fromarray(arr)
 crops=[]; boxes=[]
 for col in range(cols):
  left=round(col*im.width/cols);right=round((col+1)*im.width/cols)
  top = max(5,y0-col*20) if animation == "jump_rise" else y0
  cell=im.crop((left,top,right,y1))
  arr=np.asarray(cell).copy(); mask=arr[:,:,3]>40
  labels,count=ndimage.label(mask)
  sizes=np.bincount(labels.ravel());sizes[0]=0
  if not count: raise ValueError(f'Empty frame: {animation} {col}')
  # Remove small disconnected number plaques, dust and annotation fragments.
  largest=int(np.argmax(sizes));keep=labels==largest
  keep=ndimage.binary_dilation(keep,iterations=2)
  arr[:,:,3][~keep]=0
  cell=Image.fromarray(arr)
  bbox=cell.getbbox()
  if bbox is None:raise ValueError('Empty frame')
  crops.append(cell.crop(bbox));boxes.append([left+bbox[0],top+bbox[1],left+bbox[2],top+bbox[3]])
 # Use one scale per animation; preserve differences between poses.
 scale=min(400/max(c.height for c in crops),300/max(c.width for c in crops))
 frames=[];dest=OUT/animation;dest.mkdir(exist_ok=True)
 for i,crop in enumerate(crops):
  crop=crop.resize((max(1,round(crop.width*scale)),max(1,round(crop.height*scale))),Image.Resampling.LANCZOS)
  frame=Image.new('RGBA',(320,448))
  frame.alpha_composite(crop,((320-crop.width)//2,432-crop.height))
  frame.save(dest/f'frame_{i+1:02d}.png')
  frames.append(frame)
 sheet=Image.new('RGBA',(320*cols,448))
 for i,frame in enumerate(frames):sheet.alpha_composite(frame,(320*i,0))
 sheet_path=PREVIEWS/f'tavi_{animation}_spritesheet.png';sheet.save(sheet_path)
 preview=[]
 for frame in frames:
  bg=Image.new('RGBA',frame.size,'#202d30');bg.alpha_composite(frame)
  preview.append(bg.convert('RGB').resize((160,224)))
 gif=PREVIEWS/f'tavi_{animation}_preview.gif'
 preview[0].save(gif,save_all=True,append_images=preview[1:],duration=round(1000/fps),loop=0)
 contact=Image.new('RGB',(160*cols,246),'#202d30');d=ImageDraw.Draw(contact)
 for i,frame in enumerate(preview):contact.paste(frame,(i*160,0));d.text((i*160+8,229),f'{animation} {i+1}',fill='white')
 contact_path=PREVIEWS/f'tavi_{animation}_contact_sheet.jpg';contact.save(contact_path,quality=92)
 manifest={'animation':animation,'fps':fps,'loop':loop,'frame_count':cols,'frame_size':[320,448],'source':str(source.relative_to(ROOT)),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'source_rects':boxes,'status':'rebuilt prototype derivative; review animation consistency and cropped scarf/sword edges before release'}
 (dest/'manifest.json').write_text(json.dumps(manifest,indent=2))
 pack=PREVIEWS/f'tavi_{animation}_asset_pack.zip'
 with zipfile.ZipFile(pack,'w',zipfile.ZIP_DEFLATED) as z:
  for path in sorted(dest.iterdir()):z.write(path,path.name)
  for path in [sheet_path,gif,contact_path]:z.write(path,path.name)
 all_specs.append(manifest)
 print(animation,cols,'frames')
(OUT/'animations.json').write_text(json.dumps(all_specs,indent=2))
print('Rebuilt',sum(x['frame_count'] for x in all_specs),'frames in',len(all_specs),'animation packs')
