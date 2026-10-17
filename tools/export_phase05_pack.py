"""Export selected Phase05 tile prototypes without changing generated originals."""
from pathlib import Path
from PIL import Image,ImageDraw
import sys,json,hashlib,datetime

def record(path):
 p=Path(path);im=Image.open(p)
 return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size,'dimensions':list(im.size),'mode':im.mode,'alpha_extrema':list(im.getchannel('A').getextrema()) if 'A' in im.getbands() else None}

def checker(im,size=(768,768),dark=False):
 im=im.copy().convert('RGBA');im.thumbnail(size);bg=Image.new('RGBA',im.size,'#242d32' if dark else '#eeeeee');dr=ImageDraw.Draw(bg)
 for y in range(0,im.height,24):
  for x in range(0,im.width,24):
   if (x//24+y//24)%2:dr.rectangle((x,y,x+23,y+23),fill='#3c484d' if dark else '#cfcfcf')
 bg.alpha_composite(im);return bg.convert('RGB')

manifest=Path(sys.argv[1]);records=json.loads(manifest.read_text())
for rec in records:
 aid=rec['id'];folder=Path(rec['folder']);exports=folder/'exports';previews=folder/'previews';exports.mkdir(exist_ok=True);previews.mkdir(exist_ok=True)
 for d in rec['deliverables']:
  src=Path(d['path']);im=Image.open(src).convert('RGBA');d['source_file']=record(src);d['source_message_id']=None;d['provenance']='unchanged built-in image_gen output; not downloaded source-chat original'
  assert im.getchannel('A').getextrema()[0]==0,f'No clear alpha {aid}'
  cols,rows=d['cols'],d['rows'];assert d['frame_count']==len(d['roles'])==cols*rows
  frames=[];sheet=Image.new('RGBA',(cols*64,rows*64));d['source_crop_boundaries']=[];d['export_paths']=[]
  for i in range(d['frame_count']):
   x,y=i%cols,i//cols;box=[round(x*im.width/cols),round(y*im.height/rows),round((x+1)*im.width/cols),round((y+1)*im.height/rows)];d['source_crop_boundaries'].append(box)
   tile=im.crop(box).resize((64,64),Image.Resampling.LANCZOS);path=exports/f'{aid}_{d["slug"]}_{i:02d}.png';tile.save(path);d['export_paths'].append(str(path));sheet.alpha_composite(tile,(x*64,y*64));frames.append(tile)
  path=exports/f'{aid}_{d["slug"]}_sheet.png';sheet.save(path);d['export_paths'].append(str(path));d['export_files']=[dict(record(p),provenance='derived source-cell crop and resize') for p in d['export_paths']];d['export_cell_dimensions']=[64,64];d['pivot_px']=[32,32];d['timing']=None;d['loop']=False
  d['preview_paths']=[]
  for dark in [False,True]:
   path=previews/f'{aid}_source_checker_{"dark" if dark else "light"}.jpg';checker(im,dark=dark).save(path,quality=90);d['preview_paths'].append(str(path))
  path=previews/f'{aid}_export_contact.png';checker(sheet.resize((sheet.width*3,sheet.height*3),Image.Resampling.NEAREST)).save(path);d['preview_paths'].append(str(path))
  # A deterministic diagnostic assembly, never a claim of seam approval.
  if aid=='TILE-015':
   layout=[[0,1,1,1,1,2],[6,4,5,4,5,7],[10,4,5,4,5,11]];assembly=Image.new('RGBA',(384,192))
   for y,row in enumerate(layout):
    for x,index in enumerate(row):assembly.alpha_composite(frames[index],(x*64,y*64))
  elif aid=='TILE-017':
   assembly=Image.new('RGBA',sheet.size);colors=['#4e4830','#4e4830','#414e56','#302c29']
   for i,tile in enumerate(frames):
    x,y=i%cols,i//cols;assembly.paste(Image.new('RGBA',(64,64),colors[y]),(x*64,y*64));assembly.alpha_composite(tile,(x*64,y*64))
  else:
   assembly=Image.new('RGBA',sheet.size)
   for i,tile in enumerate(frames):
    x,y=i%cols,i//cols;assembly.paste(Image.new('RGBA',(64,64),['#4e5633','#505e62','#403a2d'][y%3]),(x*64,y*64));assembly.alpha_composite(tile,(x*64,y*64))
  path=previews/f'{aid}_assembly_diagnostic.png';checker(assembly.resize((assembly.width*2,assembly.height*2),Image.Resampling.NEAREST)).save(path);d['preview_paths'].append(str(path));d['preview_path']=d['preview_paths'][0]
 rec['asset_id']=aid;rec['generation_tool']='built-in image_gen';rec['production_approved']=False;rec['runtime_integrated']=False;rec['last_updated']=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat();rec['stage']='reviewed generated tile prototypes and64px exports; seam cleanup and engine validation pending'
 rec['requested_deliverables_saved_and_reviewed']=True
 rec['review_notes']=rec.get('review_notes',[])+['Static modules only; no water physics, animation, collision, autotile or Godot scene integration implied.','Assembly previews are diagnostics. Native64px joins, edge alpha, material matching and collision readability need manual cleanup and runtime validation before production approval.']
 rec['all_source_files']=[record(p) for p in sorted((folder/'source_images').glob('*.png'))]
 (folder/'metadata.json').write_text(json.dumps(rec,indent=2,ensure_ascii=False)+'\n');(exports/f'{aid}_generation_prompts.json').write_text(json.dumps([{'slug':d['slug'],'prompt':d['prompt'],'reference_images':d.get('reference_images',[])} for d in rec['deliverables']],indent=2,ensure_ascii=False)+'\n')
 print(aid,len(frames),'64px tiles exported')
manifest.write_text(json.dumps(records,indent=2,ensure_ascii=False)+'\n')
