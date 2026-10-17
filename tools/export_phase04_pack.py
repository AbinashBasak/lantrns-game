"""Export a reviewed Phase 04 prototype manifest; never modifies original images."""
from pathlib import Path
import sys,json,hashlib,shutil,datetime
from PIL import Image,ImageDraw

def file_record(p):
 p=Path(p);im=Image.open(p)
 return {'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'dimensions':list(im.size),'mode':im.mode,'alpha_extrema':list(im.getchannel('A').getextrema()) if 'A' in im.getbands() else None}

def checker(im, size=(768,512)):
 im=im.copy().convert('RGBA');im.thumbnail(size)
 bg=Image.new('RGBA',im.size,'#d2d2d2');dr=ImageDraw.Draw(bg)
 for y in range(0,im.height,24):
  for x in range(0,im.width,24):
   if (x//24+y//24)%2:dr.rectangle((x,y,x+23,y+23),fill='#eeeeee')
 bg.alpha_composite(im);return bg.convert('RGB')

manifest=Path(sys.argv[1]);records=json.loads(manifest.read_text())
for rec in records:
 aid=rec['id'];root=Path(rec['folder']);out=root/'exports';prev=root/'previews';out.mkdir(exist_ok=True);prev.mkdir(exist_ok=True)
 for d in rec['deliverables']:
  p=Path(d['path']);im=Image.open(p);d['source_file']=file_record(p)
  if d['transparent_background']:assert 'A' in im.getbands() and im.getchannel('A').getextrema()[0]==0,p
  for extra in d.get('additional_sources',[]):extra['source_file']=file_record(extra['path'])
  slug=d['slug'];d['export_paths']=[];d['source_crop_boundaries']=[]
  if d['export_mode']=='image':
   dest=out/f'{aid}_{slug}.png';shutil.copy2(p,dest);d['export_paths']=[str(dest)]
  else:
   cols,rows=d['cols'],d['rows'];cell=64 if slug=='terrain_atlas' else 256
   sheet=Image.new('RGBA',(cols*cell,rows*cell));frames=[]
   for i in range(d['frame_count']):
    x,y=i%cols,i//cols;box=[round(x*im.width/cols),round(y*im.height/rows),round((x+1)*im.width/cols),round((y+1)*im.height/rows)]
    frame=im.crop(box).convert('RGBA').resize((cell,cell),Image.Resampling.LANCZOS)
    dest=out/f'{aid}_{slug}_{i:02d}.png';frame.save(dest);d['export_paths'].append(str(dest));d['source_crop_boundaries'].append(box);frames.append(frame);sheet.alpha_composite(frame,(x*cell,y*cell))
   dest=out/f'{aid}_{slug}_sheet.png';sheet.save(dest);d['export_paths'].append(str(dest));d['export_cell_size']=cell
   if slug=='location_fx':
    review_frames=[checker(f,(256,256)) for f in frames];gif=prev/f'{aid}_{slug}_preview.gif';review_frames[0].save(gif,save_all=True,append_images=review_frames[1:],duration=d.get('timing') or [100]*len(frames),disposal=2);d['animation_preview']=str(gif)
  d['export_files']=[dict(file_record(p),provenance='derived crop/resize from unchanged source' if d['export_mode']=='atlas' else 'unchanged source copy') for p in d['export_paths']]
  preview=prev/f'{aid}_{slug}_review.jpg';checker(im).save(preview,quality=90);d['preview_path']=str(preview)
  d['export_review_note']='Prototype extraction. Source crop geometry recorded; tile joins, pivots, timings and scale need in-engine testing.'
 rec['asset_id']=aid;rec['last_updated']=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=5,minutes=30))).isoformat();rec['stage']='prototype sources and exports visually reviewed; tile cleanup and runtime validation pending';rec['requested_deliverables_saved_and_reviewed']=len(rec['deliverables'])==8;rec['production_approved']=False
 rec['review_notes']=['All eight requested image types saved and reviewed as generated prototypes. Source alpha reviewed over checkerboard; raw RGB under transparent pixels is not a visible backdrop.','Terrain source regenerated to regular four-by-four material grid. Seam matching, collision alignment and slopes remain unapproved until cleanup/testing.','Environment proposals and FX timing are provisional; no runtime assets or scene integrations changed.']
 (root/'metadata.json').write_text(json.dumps(rec,indent=2,ensure_ascii=False)+'\n')
 (out/f'{aid}_generation_prompts.json').write_text(json.dumps([{'slug':d['slug'],'prompt':d['prompt'],'reference_images':d.get('reference_images',[]),'generation_tool':'built-in image_gen'} for d in rec['deliverables']],indent=2,ensure_ascii=False)+'\n')
 (out/f'{aid}_README.md').write_text(f'# {aid} — {rec["title"]}\n\nGenerated prototype pack. See ../metadata.json for original sources, prompts, hashes, source crops, export paths, roles and timing. Lighting reference is a full-scene reference only; the background, midground and foreground are separate files. Atlas cells are row-major. Terrain uses 64px cells; other atlas cells use 256px. No runtime integration or final production approval. No ZIP required.\n')
 print(aid,len(rec['deliverables']),'sources',sum(len(d['export_paths']) for d in rec['deliverables']),'image exports')
manifest.write_text(json.dumps(records,indent=2,ensure_ascii=False)+'\n')
