from PIL import Image, ImageDraw, ImageFont
src='/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/archive/shared-chat/images/00000000-65d0-8208-99f4-c4e3c147aca5.png'
out='/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/archive/rebuilt-assets/lanterns_underroot_art004_material_reference.png'
im=Image.open(src).convert('RGB')
regions = [
    ('GRASS / FOLIAGE', (24, 850, 121, 954), 'Leafy green surface'),
    ('SOIL / DIRT',     (135, 850, 231, 954), 'Earth and soil'),
    ('STONE',           (245, 850, 341, 954), 'Stone and moss'),
    ('ROOT BARK',       (355, 850, 451, 954), 'Twisted root bark'),
    ('WOOD GRAIN',      (465, 850, 561, 954), 'Aged wooden planks'),
]
W,H=1600,560
bg=(15,24,30); panel=(25,39,46); line=(83,94,96); cream=(242,230,203); muted=(178,187,183)
canvas=Image.new('RGB',(W,H),bg); d=ImageDraw.Draw(canvas)
font_path='/System/Library/Fonts/Supplemental/Arial.ttf'; bold_path='/System/Library/Fonts/Supplemental/Arial Bold.ttf'
try:
    title=ImageFont.truetype(bold_path,32); subtitle=ImageFont.truetype(font_path,18); label=ImageFont.truetype(bold_path,18); small=ImageFont.truetype(font_path,15)
except: title=subtitle=label=small=ImageFont.load_default()
d.text((44,24),'LANTERNS UNDERROOT',font=title,fill=cream)
d.text((44,65),'ART-004  |  ENVIRONMENT MATERIAL REFERENCE',font=subtitle,fill=muted)
d.line((44,101,W-44,101),fill=line,width=2)
d.text((44,116),'Five core materials only — these are visual references, not finished game tiles.',font=subtitle,fill=muted)
margin=42; gap=18; card_w=(W-2*margin-4*gap)//5; card_y=156; card_h=354
for i,(name,box,desc) in enumerate(regions):
    x=margin+i*(card_w+gap)
    d.rounded_rectangle((x,card_y,x+card_w,card_y+card_h),radius=14,fill=panel,outline=line,width=2)
    crop=im.crop(box)
    sw=220; sh=220
    crop=crop.resize((sw,sh),Image.Resampling.LANCZOS)
    ix=x+(card_w-sw)//2; iy=card_y+18
    canvas.paste(crop,(ix,iy))
    d.text((x+14,iy+sh+20),name,font=label,fill=cream)
    d.text((x+14,iy+sh+50),desc,font=small,fill=muted)
d.text((44,527),'Next step after approval: create individual seamless textures and modular terrain tiles from these material references.',font=small,fill=muted)
canvas.save(out)
print(out)