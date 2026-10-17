"""Render layout proposal previews from separate textures and editable labels."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont,ImageOps
import json
ROOT=Path(__file__).resolve().parents[1];PHASE=ROOT/'assets/production/phase_08_user_interface';menu=PHASE/'menus_and_screens';font_title='/System/Library/Fonts/Supplemental/Georgia Bold.ttf';font_body='/System/Library/Fonts/Supplemental/Arial Bold.ttf'
button=None;bp=menu/'UI-018/metadata.json'
if bp.exists():
 b=json.loads(bp.read_text())
 for d in b.get('deliverables',[]):
  paths=d.get('export_paths',[])
  if not paths:paths=[f['path'] for f in d.get('frames',[]) if isinstance(f,dict)]
  if paths:
   button=Image.open(paths[0]).convert('RGBA');bbox=button.getchannel('A').point(lambda a:255 if a>8 else 0).getbbox()
   if bbox:button=button.crop(bbox)
   break
for aid in ['UI-021','UI-022','UI-023']:
 folder=menu/aid;mp=folder/'metadata.json';meta=json.loads(mp.read_text());lp=Path(meta['layout_spec']);layout=json.loads(lp.read_text())
 if aid in ['UI-022','UI-023']:
  for n in layout['nodes']:
   if n['type']=='Label' and n.get('text'):n['rect_norm']=[.26,.34,.48,.07]
   elif n['type']=='Label':n['rect_norm']=[.28,.43,.44,.09]
  buttons=[n for n in layout['nodes'] if n['type']=='Button']
  for n,y in zip(buttons,[.51,.64]):n['rect_norm']=[.35,y,.30,.105]
  lp.write_text(json.dumps(layout,indent=2,ensure_ascii=False)+'\n')
 W,H=1280,720;canvas=Image.new('RGBA',(W,H),'#0b1b23');draw=ImageDraw.Draw(canvas)
 for n in layout['nodes']:
  x,y,w,h=[round(v*s) for v,s in zip(n['rect_norm'],[W,H,W,H])]
  if n['type']=='TextureRect':
   im=Image.open(n['texture']).convert('RGBA')
   if n.get('scaling')=='cover':im=ImageOps.fit(im,(w,h),Image.Resampling.LANCZOS);canvas.alpha_composite(im,(x,y))
   else:im.thumbnail((w,h),Image.Resampling.LANCZOS);canvas.alpha_composite(im,(x+(w-im.width)//2,y+(h-im.height)//2))
  elif n['type']=='Label' and n.get('text'):
   draw=ImageDraw.Draw(canvas);font=ImageFont.truetype(font_title if aid!='UI-021' else font_body,40 if aid!='UI-021' else 24);draw.text((x+w//2,y+h//2),n['text'],font=font,anchor='mm',fill='#f6e8bd',stroke_width=1,stroke_fill='#13242a')
  elif n['type']=='ProgressBar':
   draw=ImageDraw.Draw(canvas);draw.rounded_rectangle((x,y,x+w,y+h),radius=max(2,h//2),fill='#132c33',outline='#b49968',width=1);draw.rounded_rectangle((x+2,y+2,x+round(w*.62),y+h-2),radius=max(2,h//2),fill='#d6b46a')
  elif n['type']=='Button':
   if button:
    im=button.copy();ratio=min(w/im.width,h/im.height);im=im.resize((round(im.width*ratio),round(im.height*ratio)),Image.Resampling.LANCZOS);canvas.alpha_composite(im,(x+(w-im.width)//2,y+(h-im.height)//2))
   else:
    draw=ImageDraw.Draw(canvas);draw.rounded_rectangle((x,y,x+w,y+h),radius=8,fill='#203943',outline='#af9661',width=2)
   draw=ImageDraw.Draw(canvas);draw.text((x+w//2,y+h//2),n['text'],font=ImageFont.truetype(font_body,22),anchor='mm',fill='#f4e7bf')
 p=folder/'previews'/f'{aid}_assembled_layout_preview.png';canvas.convert('RGB').save(p);meta['assembled_preview']=str(p);meta['preview_provenance']='data-layout render using separate artwork and text, not an image_gen source';meta['preview_button_asset']='UI-018' if button else 'neutral vector placeholder until UI-018 reviewed';mp.write_text(json.dumps(meta,indent=2,ensure_ascii=False)+'\n');print(aid,'layout preview rendered')
