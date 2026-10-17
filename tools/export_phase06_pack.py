"""Crop reviewed prop/object atlas prototypes; retain unchanged generated sources."""
from pathlib import Path
from PIL import Image,ImageDraw
import sys,json,hashlib,datetime

def info(p):
 p=Path(p);im=Image.open(p);return {'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'dimensions':list(im.size),'mode':im.mode,'alpha_extrema':list(im.getchannel('A').getextrema()) if 'A' in im.getbands() else None}

def checker(im,dark=False):
 im=im.copy().convert('RGBA');im.thumbnail((768,768));bg=Image.new('RGBA',im.size,'#26333a' if dark else '#eeeeee');dr=ImageDraw.Draw(bg)
 for y in range(0,im.height,24):
  for x in range(0,im.width,24):
   if (x//24+y//24)%2:dr.rectangle((x,y,x+23,y+23),fill='#3b4b53' if dark else '#cfcfcf')
 bg.alpha_composite(im);return bg.convert('RGB')

manifest=Path(sys.argv[1]);records=json.loads(manifest.read_text())
for rec in records:
 aid=rec['id'];folder=Path(rec['folder']);out=folder/'exports';prev=folder/'previews';out.mkdir(exist_ok=True);prev.mkdir(exist_ok=True)
 for d in rec['deliverables']:
  im=Image.open(d['path']).convert('RGBA');d['source_file']=info(d['path']);assert im.getchannel('A').getextrema()[0]==0,aid
  d['source_message_id']=None;d['provenance']='unchanged built-in image_gen output generated in Codex; not downloaded source-chat original';d['timing']=None;d['loop']=False
  cols,rows=d['cols'],d['rows'];assert len(d['roles'])==d['frame_count']==cols*rows;cell=d.get('export_cell_size',256);sheet=Image.new('RGBA',(cols*cell,rows*cell));d['export_paths']=[];d['source_crop_boundaries']=[]
  for i in range(d['frame_count']):
   x,y=i%cols,i//cols;box=[round(x*im.width/cols),round(y*im.height/rows),round((x+1)*im.width/cols),round((y+1)*im.height/rows)];frame=im.crop(box).resize((cell,cell),Image.Resampling.LANCZOS);p=out/f'{aid}_{d["slug"]}_{i:02d}.png';frame.save(p);d['export_paths'].append(str(p));d['source_crop_boundaries'].append(box);sheet.alpha_composite(frame,(x*cell,y*cell))
  p=out/f'{aid}_{d["slug"]}_sheet.png';sheet.save(p);d['export_paths'].append(str(p));d['export_files']=[dict(info(p),provenance='derived source-cell crop/resize') for p in d['export_paths']]
  d['export_cell_dimensions']=[cell,cell];d['pivot_px']=[cell//2,round(cell*.875)]
  if aid=='OBJ-007':d['pivot_px']=[cell//2,round(cell*.35)]
  if aid in ['OBJ-008','OBJ-009']:d['pivot_px']=[cell//2,round(cell*.75)]
  if aid=='OBJ-011':d['pivot_px']=[cell//2,cell//2]
  d['pivot_status']='proposed registration anchor; manual state/module alignment and runtime test pending';d['preview_paths']=[]
  for dark in [False,True]:
   p=prev/f'{aid}_source_checker_{"dark" if dark else "light"}.jpg';checker(im,dark).save(p,quality=90);d['preview_paths'].append(str(p))
  p=prev/f'{aid}_export_contact.jpg';checker(sheet).save(p,quality=92);d['preview_paths'].append(str(p));d['preview_path']=d['preview_paths'][0]
 rec.update({'asset_id':aid,'generation_tool':'built-in image_gen','production_approved':False,'runtime_integrated':False,'requested_deliverables_saved_and_reviewed':True,'stage':'reviewed generated object art and state/module exports; registration and gameplay integration pending','last_updated':datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat()})
 rec['review_notes']=rec.get('review_notes',[])+['Static object state/module proposals. No complete animation, collision, hazard damage, portal transitions, falling logic or other gameplay behavior is implied.','Exact state geometry, pivots, scale and emission separation need final cleanup and Godot validation; rune motifs require design approval.']
 rec['all_source_files']=[info(p) for p in sorted((folder/'source_images').glob('*.png'))]
 (folder/'metadata.json').write_text(json.dumps(rec,indent=2,ensure_ascii=False)+'\n');(out/f'{aid}_generation_prompts.json').write_text(json.dumps([{'slug':d['slug'],'prompt':d['prompt'],'reference_images':d.get('reference_images',[])} for d in rec['deliverables']],indent=2,ensure_ascii=False)+'\n');print(aid,d['frame_count'],'sprites exported')
manifest.write_text(json.dumps(records,indent=2,ensure_ascii=False)+'\n')
