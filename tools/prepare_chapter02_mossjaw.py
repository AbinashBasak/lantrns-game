"""Mechanically split the generated six-pose Mossjaw sheet; preserve both originals."""
from pathlib import Path
from PIL import Image
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
LIB=ROOT/'assets/production/phase_10_later_campaign_specific_assets/LATE-001'
OUT=ROOT/'assets/runtime/chapter02/mossjaw'
GEN=Path('/Users/abinashbasak/.codex/generated_images/01a16a57-3876-7010-9dfd-afd93830a6f5')
SOURCES=['exec-bb0f52c1-4b1c-4401-999e-f6f877f6f833.png','exec-825bc4e7-3d61-4c8f-a559-85ff3731e276.png']
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def record(p):
 im=Image.open(p)
 return {'path':str(p),'sha256':sha(p),'dimensions':list(im.size),'mode':im.mode,'alpha_extrema':list(im.getchannel('A').getextrema())}
def prepare():
 for sub in ['source_images','exports','previews']: (LIB/sub).mkdir(parents=True,exist_ok=True)
 OUT.mkdir(parents=True,exist_ok=True)
 sources=[]
 for i,name in enumerate(SOURCES,1):
  dest=LIB/'source_images'/f'LATE-001_mossjaw_generation_{i:02d}.png'
  shutil.copy2(GEN/name,dest);sources.append(record(dest))
 im=Image.open(sources[-1]['path']).convert('RGBA')
 names=['idle','windup','charge_a','charge_b','recover','defeat'];frames=[]
 for i,name in enumerate(names):
  y=i//2*512
  split=530 if i//2==1 else 512
  x=0 if i%2==0 else split
  right=split if i%2==0 else 1024
  cell=im.crop((x,y,right,y+512))
  # Align actual opaque feet to a common baseline. No recolour, alpha removal or AI reconstruction.
  mask=cell.getchannel('A').point(lambda a:255 if a>=64 else 0)
  bbox=mask.getbbox()
  assert bbox and bbox[0]>0 and bbox[2]<cell.width, (name,bbox)
  canvas=Image.new('RGBA',(560,560),(0,0,0,0))
  shift=520-bbox[3]
  canvas.paste(cell,((560-cell.width)//2,shift))
  export=LIB/'exports'/f'LATE-001_mossjaw_{name}.png';canvas.save(export)
  runtime=OUT/export.name;shutil.copy2(export,runtime)
  frames.append({'pose':name,'source_cell':[x,y,right,y+512],'source_visible_bbox_alpha64':bbox,'vertical_alignment_shift':shift,'file':record(export),'runtime':record(runtime)})
 clips={'idle':([0],500,True),'windup':([1],500,False),'charge':([2,3],140,True),'slam':([1,4],140,False),'recover':([4],500,True),'defeat':([5],500,False)}
 manifest={'identity':'Mossjaw — Chapter 2 orchard guardian','provenance':'New built-in image_gen output, mechanically split and feet-aligned. Six illustrated poses; charge has two distinct stride frames. Single-pose idle/recovery are held, not claimed full animations. Slam reuses anticipation and bowed recovery; bespoke slam animation remains pending.','animations':{}}
 for clip,(ids,ms,loop) in clips.items():
  manifest['animations'][clip]={'frames':[{'path':'res://'+Path(frames[i]['runtime']['path']).relative_to(ROOT).as_posix(),'sha256':frames[i]['runtime']['sha256']} for i in ids],'durations_ms':[ms]*len(ids),'loop':loop,'pivot_px':[280,520]}
 (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
 # Contact sheet on a neutral checker demonstrates real alpha; original RGB beneath alpha is preserved.
 preview=Image.new('RGB',im.size)
 from PIL import ImageDraw
 d=ImageDraw.Draw(preview)
 for y in range(0,im.height,32):
  for x in range(0,im.width,32):d.rectangle((x,y,x+31,y+31),fill=(80,90,85) if (x//32+y//32)%2 else (120,130,125))
 preview.paste(im,(0,0),im.getchannel('A')); preview.save(LIB/'previews/LATE-001_mossjaw_alpha_review.jpg')
 metadata={'asset_id':'LATE-001','title':'Briarwake orchard pack, Mossjaw, and root-stone','stage':'Mossjaw six-pose sprite set generated and integrated; full LATE-001 pack incomplete','release_approved':False,'source_message_ids':None,'source_provenance':'Unchanged built-in image_gen outputs; not downloaded originals. Generation01 archived as rejected crowded layout. Generation02 selected after visual review.','source_images':sources,'frames':frames,'animation_timing':manifest['animations'],'runtime_manifest':str(OUT/'manifest.json'),'review_notes':['Matches established illustrated bark/moss/amber palette; no vector stand-in.','New character design requires final user art approval.','Pose set and two-frame run are not a full production animation pack.','No checklist completion inferred for the broader LATE-001 bundle.']}
 (LIB/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
 print('Prepared six Mossjaw poses with provenance and hashes')
if __name__=='__main__':prepare()
