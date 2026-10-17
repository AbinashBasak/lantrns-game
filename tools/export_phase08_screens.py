"""Export layered UI screen textures and data layouts; no game integration."""
from pathlib import Path
from PIL import Image,ImageDraw
import json,sys,hashlib,shutil

def info(p):
 p=Path(p);im=Image.open(p);return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'dimensions':list(im.size),'mode':im.mode,'alpha_extrema':list(im.getchannel('A').getextrema()) if 'A' in im.getbands() else None}
def checker(im):
 im=im.copy().convert('RGBA');im.thumbnail((900,600));bg=Image.new('RGBA',im.size,'#eeeeee');dr=ImageDraw.Draw(bg)
 for y in range(0,im.height,24):
  for x in range(0,im.width,24):
   if (x//24+y//24)%2:dr.rectangle((x,y,x+23,y+23),fill='#cccccc')
 bg.alpha_composite(im);return bg.convert('RGB')
manifest=Path(sys.argv[1]);rs=json.loads(manifest.read_text())
for r in rs:
 aid=r['id'];folder=Path(r['folder']);out=folder/'exports';prev=folder/'previews';out.mkdir(exist_ok=True);prev.mkdir(exist_ok=True)
 for d in r['deliverables']:
  im=Image.open(d['path']);d['source_file']=info(d['path']);d['source_message_id']=None;d['provenance']='unchanged built-in image_gen output generated in Codex';d['export_paths']=[];d['preview_paths']=[]
  if d['transparent_background']:assert 'A' in im.getbands() and im.getchannel('A').getextrema()[0]==0
  if d['export_mode']=='image':
   p=out/f'{aid}_{d["slug"]}.png';shutil.copy2(d['path'],p);d['export_paths'].append(str(p))
   if aid=='UI-021':
    target=16/9;w,h=im.size
    if w/h>target:neww=round(h*target);box=[(w-neww)//2,0,(w+neww)//2,h]
    else:newh=round(w/target);box=[0,(h-newh)//2,w,(h+newh)//2]
    p=out/'UI-021_loading_background_1920x1080_cover.png';im.crop(box).resize((1920,1080),Image.Resampling.LANCZOS).save(p);d['export_paths'].append(str(p));d['cover_crop_source_box']=box;d['cover_export_provenance']='derived center cover crop/resample, not native generated resolution'
   else:d['scaling_policy']='preserve full panel aspect; no approved nine-slice for integral lantern crest';d['content_safe_rect_normalized']=[.13,.29,.74,.51]
  else:
   cols,rows=d['cols'],d['rows'];sheet=Image.new('RGBA',(cols*128,rows*128));d['source_crop_boundaries']=[]
   for i in range(d['frame_count']):
    x,y=i%cols,i//cols;box=[round(x*im.width/cols),round(y*im.height/rows),round((x+1)*im.width/cols),round((y+1)*im.height/rows)];p=out/f'{aid}_{d["slug"]}_{i:02d}.png';frame=im.crop(box).convert('RGBA').resize((128,128),Image.Resampling.LANCZOS);frame.save(p);sheet.alpha_composite(frame,(x*128,y*128));d['source_crop_boundaries'].append(box);d['export_paths'].append(str(p))
   p=out/f'{aid}_{d["slug"]}_sheet.png';sheet.save(p);d['export_paths'].append(str(p));d['export_cell_dimensions']=[128,128];d['pivot_px']=[64,64]
   p=prev/f'{aid}_legibility_32px.png';checker(sheet.resize((cols*32,rows*32),Image.Resampling.LANCZOS)).save(p);d['preview_paths'].append(str(p))
  d['export_files']=[dict(info(p),provenance='derived export; native image copy or documented crop/resample') for p in d['export_paths']];p=prev/f'{aid}_source_checker.jpg';checker(im).save(p,quality=90);d['preview_paths'].append(str(p));d['preview_path']=str(p)
  layout={'asset_id':aid,'design_canvas':[1920,1080],'text_overlays_deferred':True,'runtime_integrated':False,'layout_type':'editable control/layout proposal, not a Godot scene','nodes':[]}
  if aid=='UI-021':layout['nodes']=[{'type':'TextureRect','texture':d['export_paths'][-1],'rect_norm':[0,0,1,1],'scaling':'cover'},{'type':'Label','text':'Loading…','rect_norm':[.25,.78,.5,.07],'align':'center'},{'type':'ProgressBar','value_source':'runtime_loading_progress','rect_norm':[.25,.87,.5,.018],'colors':{'track':'#142c34','fill':'#d8b673'}},{'type':'Label','text_source':'runtime_tip','rect_norm':[.15,.92,.7,.04],'align':'center'}]
  elif aid in ['UI-022','UI-023']:
   layout['nodes']=[{'type':'TextureRect','texture':d['export_paths'][0],'rect_norm':[.12,.12,.76,.76],'scaling':'contain'},{'type':'Label','text':'Game Over' if aid=='UI-022' else 'Level Complete','rect_norm':[.26,.36,.48,.09],'align':'center'},{'type':'Label','text_source':'runtime_result_summary','rect_norm':[.28,.48,.44,.12],'align':'center'},{'type':'Button','asset_ref':'UI-018','text':'Retry' if aid=='UI-022' else 'Continue','rect_norm':[.31,.63,.38,.075]},{'type':'Button','asset_ref':'UI-018','text':'Main Menu','rect_norm':[.31,.73,.38,.075]}]
  elif aid=='UI-024':layout={'asset_id':aid,'text_overlays_deferred':True,'states':dict(zip(d['roles'],['','Saving…','Saved','Could not save'])),'suggested_icon_sizes_px':[32,48,64],'screen_reader_labels_required':True,'timing':None,'runtime_integrated':False}
  p=out/f'{aid}_layout.json';p.write_text(json.dumps(layout,indent=2,ensure_ascii=False)+'\n');r['layout_spec']=str(p)
 r.update({'asset_id':aid,'generation_tool':'built-in image_gen','stage':'reviewed UI texture/component prototypes and separate data layout; Godot implementation pending','requested_deliverables_saved_and_reviewed':True,'production_approved':False,'runtime_integrated':False,'text_overlays_deferred':True});r['review_notes']=r.get('review_notes',[])+['Labels/buttons/progress and state behaviors are separate data controls; source artwork contains no baked interface text.','Aspect-preserving layout, focus navigation, contrast, touch target sizes, accessibility and localization require Godot implementation/testing.']
 (folder/'metadata.json').write_text(json.dumps(r,indent=2,ensure_ascii=False)+'\n');(out/f'{aid}_generation_prompts.json').write_text(json.dumps([{'prompt':d['prompt'],'reference_images':d.get('reference_images',[])} for d in r['deliverables']],indent=2,ensure_ascii=False)+'\n');print(aid,'textures/components and layout exported')
manifest.write_text(json.dumps(rs,indent=2,ensure_ascii=False)+'\n')
