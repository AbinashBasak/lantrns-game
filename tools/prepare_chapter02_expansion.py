"""Archive unchanged generated originals and mechanically export isolated sprites/layers."""
from pathlib import Path
from PIL import Image,ImageDraw
import hashlib,json,shutil
import numpy as np
from scipy.ndimage import label,find_objects,binary_dilation
ROOT=Path(__file__).resolve().parents[1]
LIB=ROOT/'assets/production/phase_10_later_campaign_specific_assets/LATE-001'
RUN=ROOT/'assets/runtime/chapter02'
GEN=Path('/Users/abinashbasak/.codex/generated_images/01a16a57-3876-7010-9dfd-afd93830a6f5')
SPECS={
 'mossjaw_attacks':'exec-6d058035-a5c1-47be-9216-8113f8f54012.png',
 'underground_background':'exec-f64386d1-d08a-43fa-b683-d3ea48a38a4e.png',
 'thornrunner':'exec-8bde58a6-beed-4af9-855a-1ad875c44422.png',
 'sporespitter':'exec-e3a706c6-3757-4d9b-be7c-67a227e1aba4.png',
 'lantern_moth':'exec-5972377e-6f2a-4d39-ae00-91233b52b83a.png',
 'grotto_background':'exec-155ef9d1-92b4-4df3-be2e-7819b9a27b1b.png',
 'boss_fx':'exec-586190bb-c48a-4afc-b25b-c7fc94e38b26.png'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rec(p):
 im=Image.open(p);return {'path':str(p),'sha256':sha(p),'dimensions':list(im.size),'mode':im.mode}
def extract(im,expected):
 a=np.array(im.convert('RGBA'));labs,n=label(a[:,:,3]>100);objects=find_objects(labs)
 parts=[]
 for i,sl in enumerate(objects):
  if sl and (labs[sl]==i+1).sum()>3000:parts.append((i+1,sl))
 assert len(parts)==expected,(len(parts),expected)
 # Explicit contact-sheet row grouping, then left to right, independent of limb poses.
 rows=3 if expected==9 else (2 if expected==4 else 1)
 parts.sort(key=lambda p:(int((p[1][0].start+p[1][0].stop)/2)//round(im.height/rows),p[1][1].start))
 for ident,sl in parts:
  box=[max(0,sl[1].start-4),max(0,sl[0].start-4),min(im.width,sl[1].stop+4),min(im.height,sl[0].stop+4)]
  x0,y0,x1,y1=box;region=a[y0:y1,x0:x1].copy()
  # Keep the selected connected silhouette plus its original antialiasing fringe.
  # Original source is untouched. Disconnected particles/neighboring poses are excluded.
  keep=binary_dilation(labs[y0:y1,x0:x1]==ident,iterations=3)
  region[:,:,3]=np.where(keep,region[:,:,3],0)
  yield Image.fromarray(region),box

def prepare():
 for sub in ['source_images','exports','previews']:(LIB/sub).mkdir(parents=True,exist_ok=True)
 sources={};exports=[];runtime=[]
 for slug,name in SPECS.items():
  target=LIB/'source_images'/f'LATE-001_{slug}_generation_01.png';shutil.copy2(GEN/name,target)
  sources[slug]=rec(target)|{'generation_path':str(GEN/name),'provenance':'unchanged built-in image_gen output; not a downloaded original'}
 def save(im,stem,folder,derivation):
  export=LIB/'exports'/f'LATE-001_{stem}.png';im.save(export)
  out=RUN/folder/export.name;out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(export,out)
  exports.append(rec(export)|{'derivation':derivation});runtime.append(rec(out)|{'source_export':str(export)})
  return 'res://'+out.relative_to(ROOT).as_posix()
 for slug in ['underground_background','grotto_background']:
  # No resampling/recolouring: full native-size generated layer.
  im=Image.open(sources[slug]['path']);save(im,slug,'environment',{'source':sources[slug]['path'],'crop':None,'resize':None})
 for slug in ['thornrunner','sporespitter','lantern_moth']:
  im=Image.open(sources[slug]['path']).convert('RGBA');paths=[]
  for i,(pose,box) in enumerate(extract(im,4)):
   factor=0.7;pose=pose.resize((round(pose.width*factor),round(pose.height*factor)),Image.Resampling.LANCZOS)
   canvas=Image.new('RGBA',(512,512));canvas.paste(pose,((512-pose.width)//2,460-pose.height))
   paths.append(save(canvas,f'{slug}_{i:02d}','enemies/'+slug,{'source':sources[slug]['path'],'component_bbox':box,'native_resample_scale':factor,'foot_pivot':[256,460],'alpha_cleanup':'connected silhouette and3px antialias fringe; disconnected surrounding particles excluded'}))
  anim={}
  for clip,ids,ms,loop in [('idle',[0],400,True),('move',[0,1],180,True),('attack',[1,2,3],160,False),('hurt',[3],220,False),('defeat',[3],350,False)]:
   if slug=='lantern_moth' and clip=='idle':ids=[0,1];ms=180
   anim[clip]={'frames':[{'path':paths[i]} for i in ids],'durations_ms':[ms]*len(ids),'loop':loop}
  (RUN/'enemies'/slug/'manifest.json').write_text(json.dumps({'identity':slug,'provenance':'Generated four-pose set, mechanically separated/aligned. Two-pose locomotion; staged attack uses preparation/strike/recovery. Held hurt/defeat pose, not a full death animation.','animations':anim},indent=2)+'\n')
 im=Image.open(sources['mossjaw_attacks']['path']).convert('RGBA');attack_paths=[]
 for i,(pose,box) in enumerate(extract(im,9)):
  canvas=Image.new('RGBA',(560,560));canvas.paste(pose,((560-pose.width)//2,520-pose.height))
  attack_paths.append(save(canvas,f'mossjaw_attack_{i:02d}','mossjaw',{'source':sources['mossjaw_attacks']['path'],'component_bbox':box,'foot_pivot':[280,520],'alpha_cleanup':'connected silhouette plus3px original fringe; neighboring bodies excluded'}))
 manifest_path=RUN/'mossjaw/manifest.json';manifest=json.loads(manifest_path.read_text())
 for row,clip in enumerate(['claw','eruption','volley']):
  paths=attack_paths[row*3:row*3+3];manifest['animations'][clip]={'frames':[{'path':p} for p in paths],'durations_ms':[180,180,240],'loop':False,'pivot_px':[280,520]}
 manifest['provenance']+=' Added nine dedicated poses for three new attack clips; original six-pose sources/frames preserved.'
 manifest_path.write_text(json.dumps(manifest,indent=2)+'\n')
 im=Image.open(sources['boss_fx']['path']).convert('RGBA')
 for slug,(pose,box) in zip(['root_spike','seed_pod'],extract(im,2)):
  save(pose,slug,'mossjaw',{'source':sources['boss_fx']['path'],'component_bbox':box,'alpha_cleanup':'connected silhouette plus3px original fringe'})
 for slug,source in sources.items():
  im=Image.open(source['path']).convert('RGBA');im.thumbnail((1000,1000))
  checker=Image.new('RGB',im.size);d=ImageDraw.Draw(checker)
  for y in range(0,im.height,24):
   for x in range(0,im.width,24):d.rectangle((x,y,x+23,y+23),fill=(70,85,80) if (x//24+y//24)%2 else (115,130,125))
  checker.paste(im,(0,0),im.getchannel('A'));checker.save(LIB/'previews'/f'LATE-001_{slug}_review.jpg')
 meta={'asset_id':'LATE-001','stage':'Chapter2 expansion generated and runtime integrated; final art/animation approval pending','release_approved':False,'source_message_ids':None,'prompt_file':str(LIB/'LATE-001_expansion_prompts.json'),'sources':sources,'exports':exports,'runtime_files':runtime,'review_notes':['Three new enemy identities with four poses each.','Two distinct full-resolution underground backgrounds; no small thumbnail enlargement.','Nine dedicated Mossjaw claw/eruption/volley poses; original generations preserved.','Generated cutout root/seed gameplay hazards; no vector placeholder.','Mechanical connected-component sprite separation, alpha-fringe preservation, shared foot alignment and explicit downsampling only.']}
 (LIB/'LATE-001_expansion_metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
 print('Saved',len(sources),'unchanged sources,',len(exports),'derived exports and',len(runtime),'runtime files')
if __name__=='__main__':prepare()
