#!/usr/bin/env python3
"""Reproducible Chapter 3 source sorting and conservative export candidates. Run with uv run --with pillow."""
from pathlib import Path
from PIL import Image, ImageDraw
import json, hashlib
ROOT=Path(__file__).resolve().parents[1]
ARCH=ROOT/'assets/production/source_archives/chat_export_6add021c'
SOURCE=ROOT/'art/source/chapter_03/environment'
OUT=ROOT/'art/environment/chapter_03'
DOC=ROOT/'docs/chapter03'
source_meta=json.loads((ARCH/'metadata.json').read_text())
images={int(Path(m['path']).name[6:9]):m for m in source_meta['members'] if Path(m['path']).name.startswith('image-')}
SOURCE.mkdir(parents=True,exist_ok=True);(SOURCE/'.gdignore').write_text('')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p):return str(p.relative_to(ROOT))
# Source numbers refer to untouched ZIP members, not the assistant's unreliable generated IDs.
# Official association is based on visual subject in bible inventory sections 10.1–10.4.
entries=[
(76,'C3-BG-002','distant_submerged_ruins','backgrounds'),
(79,'C3-BG-002','distant_submerged_ruins_variant','backgrounds'),
(90,'C3-BG-004','crystal_cavern_silhouettes','backgrounds'),
(115,'C3-PROP-009','temple_arch_ruined_a','props'),(116,'C3-PROP-009','temple_arch_ruined_b','props'),
(117,'C3-PROP-007','ancient_stone_pillar_a','props'),(118,'C3-PROP-007','ancient_stone_pillar_b','props'),(119,'C3-PROP-007','ancient_stone_pillar_c','props'),
(120,'C3-PROP-013','temple_guardian_statue_a','props'),(121,'C3-PROP-013','temple_guardian_statue_b','props'),
(122,'C3-PROP-009','temple_arch_ornate_a','props'),(123,'C3-PROP-009','temple_arch_ruined_c','props'),(124,'C3-PROP-009','temple_arch_ornate_b','props'),(125,'C3-PROP-009','temple_arch_ornate_c','props'),
(126,'C3-PROP-009','temple_arch_ornate_large','props'),(127,'C3-PROP-009','temple_arch_ornate_d','props'),
(128,'C3-TILE-007','temple_platform_ornate_a','platforms'),(129,'C3-PROP-008','broken_pillar_arch_a','props'),(130,'C3-PROP-007','ancient_stone_pillar_d','props'),
(131,'C3-TILE-011','stone_stairs','platforms'),(132,'C3-PROP-008','broken_pillar_arch_b','props'),(133,'C3-PROP-008','broken_pillar_arch_c','props'),
(135,'C3-PROP-027','floating_stone_platform_candidate','platforms'),(136,'C3-TILE-008','rope_bridge_complete_reference','platforms'),
(137,'C3-DEC-003','hanging_vines_large','props'),(138,'C3-PROP-008','broken_arch_buttress_a','props'),(139,'C3-PROP-008','broken_arch_buttress_b','props'),(140,'C3-PROP-008','broken_pillar_short','props'),
(141,'C3-PROP-004','wall_mounted_lantern_unlit','props'),(142,'C3-TILE-012','temple_wall_relief','tiles'),(143,'C3-TILE-007','temple_stone_inlay','tiles'),
(144,'C3-TILE-007','temple_platform_ornate_b','platforms'),(146,'C3-PROP-008','broken_ruin_corner','props'),(147,'C3-PROP-009','temple_arch_lintel','props'),
(148,'C3-TILE-007','temple_platform_ornate_c','platforms'),(149,'C3-TILE-007','temple_corbel_ornate','platforms'),(150,'C3-PROP-023','mirror_pedestal_candidate','props')]
records=[]
def export(n,aid,name,category,box=None):
 m=images[n];src=Path(m['path']);im=Image.open(src).convert('RGBA'); full=im.size
 if box is None:
  if n in (76,79,90,126):box=(0,0,*full)
  else:box=(0,0,540 if n==136 else 510,880)
 im=im.crop(box); method='unchanged native alpha crop'
 if n not in (76,79,90,120):
  # Generated checkerboard is opaque RGB. Remove near-neutral bright pixels only.
  # This is explicit alpha reconstruction, never described as an original transparent export.
  px=im.load()
  for y in range(im.height):
   for x in range(im.width):
    r,g,b,a=px[x,y]
    if min(r,g,b)>125 and max(r,g,b)-min(r,g,b)<25:px[x,y]=(r,g,b,0)
  method='derived alpha: neutral bright checker key (min RGB >125; channel spread <25); no resize'
 # Rubble crops share a sheet: discard detached neighboring fragments below 1800 px.
 removed_components=0
 if n in (145,151):
  alpha=im.getchannel('A'); data=bytearray(alpha.tobytes()); w,h=im.size; seen=bytearray(w*h)
  for seed in range(w*h):
   if seen[seed] or data[seed]==0:continue
   seen[seed]=1; stack=[seed]; component=[]
   while stack:
    k=stack.pop();component.append(k);x=k%w;y=k//w
    for nx,ny in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
     if 0<=nx<w and 0<=ny<h:
      q=ny*w+nx
      if not seen[q] and data[q]:seen[q]=1;stack.append(q)
   if len(component)<(1800 if n==145 else 80):
    removed_components+=1
    for q in component:data[q]=0
  im.putalpha(Image.frombytes('L',(w,h),bytes(data)))
  method+='; detached source debris removed (threshold 1800 px for rubble, 80 px for mixed pedestal sheet)'
 bounds=im.getchannel('A').getbbox()
 if not bounds:raise ValueError(name)
 im=im.crop(bounds)
 folder=OUT/category;folder.mkdir(parents=True,exist_ok=True)
 dest=folder/(aid.lower().replace('-','_')+'_'+name+'.png');im.save(dest)
 a=im.getchannel('A');count=sum(a.histogram()[:255]);opaque=a.histogram()[255]
 role='distant backdrop' if category=='backgrounds' else 'solid modular art candidate' if category in ('tiles','platforms') else 'scenery / prop'
 record=dict(asset_id=aid,source_index=n,source=rel(src),source_sha256=sha(src),source_message_id=m.get('source_message_id'),requested_ids=m.get('requested_asset_ids'),source_dimensions=full,removed_neighbor_components=removed_components,source_crop=list(box),content_trim=list(bounds),export=rel(dest),export_sha256=sha(dest),dimensions=im.size,visible_bounds=a.getbbox(),transparent_background=True,transparent_pixel_count=a.histogram()[0],nonopaque_pixel_count=count,opaque_pixel_count=opaque,pivot=[im.width/2,im.height],pivot_role='bottom-center',animation_frames=1,fps=0,z_index=-60 if category=='backgrounds' else -2,receives_light=category!='backgrounds',casts_shadow='author simple polygon separately for solid props',emits_light=False,collision='none for backgrounds/decoration; manual authored shape for platforms',import_filter='linear',compression='lossless',method=method,purpose=role,stage='alpha/crop prepared; native review gallery; final approval pending',approved=False,limitations=[])
 if 'derived' in method:record['limitations'].append('Neutral-key cleanup may remove bright neutral paint; silhouette edge review needed. No painted checker remains opaque under the exact key criterion.')
 if n in (131,136):record['limitations'].append('Perspective artwork; not a complete modular tile/end-cap kit or verified side-view collision surface.')
 if n in (135,150,151):record['limitations'].append('Official-ID association is a candidate by subject; no motion/puzzle state delivered.')
 if category in ('tiles','platforms'):record['limitations'].append('Seams and gameplay collision are not approved; not substituted for missing TILE001/002/003 terrain.')
 if bounds[0]==0 or bounds[1]==0 or bounds[2]==box[2]-box[0] or bounds[3]==box[3]-box[1]:record['limitations'].append('Visible content touches a source crop boundary; inspect source for clipping before use.')
 records.append(record)
 # Keep same-canvas guide crops separate and explicitly reference-only. Not normal maps.
 if n not in (76,79,90,126,145,151):
  for suffix,x1,x2 in [('depth_reference',512,1024),('mask_reference',1024,1536)]:
   d=SOURCE/'guide_panels';d.mkdir(parents=True,exist_ok=True)
   p=d/(aid.lower().replace('-','_')+f'_{n}_{suffix}.png');Image.open(src).crop((x1,0,x2,880)).save(p)
   record.setdefault('guide_panels',[]).append(dict(path=rel(p),sha256=sha(p),role=suffix,usable_as_normal_map=False,alignment_verified=False))
for e in entries:export(*e)
# Mixed rubble sheet: native-size individual subjects, not enlarged atlas thumbnails.
for i,box in enumerate([(0,0,295,540),(295,160,740,550),(740,160,1210,555),(1210,0,1536,555),(0,550,295,805),(295,550,610,805),(610,550,900,805),(900,550,1250,805),(1250,550,1536,815)]):
 export(145,'C3-PROP-008',f'ruin_rubble_{i+1:02d}','props',box)
# Small rubble clusters remain at native dimensions: no reference thumbnail enlargement.
rock_edges=[0,195,325,440,575,715,830,940,1135,1275,1365,1536]
for i in range(len(rock_edges)-1):
 export(145,'C3-DEC-008',f'small_rock_cluster_{i+1:02d}','props',(rock_edges[i],820,rock_edges[i+1],970))
export(151,'C3-PROP-023','small_pedestal_candidate','props',(4,4,284,687))
export(151,'C3-PROP-023','small_altar_support_candidate','props',(865,4,1164,687))
# Record every environmental attempt and subject correction, including blocked/reference-only originals.
selection={n:aid for n,aid,*_ in entries}; selection[145]='C3-PROP-008 / C3-DEC-008'; selection[151]='C3-PROP-023 candidate'
audit=[]
for n in range(74,154):
 m=images[n];selected=n in selection
 if n in (80,81,82,83,84,85,86,87,88,92,107,109,110,112,134):status='waterfall; delegated VFX export inventory'
 elif 95<=n<=108:status='shrine emblem/light maps; delegated VFX inventory'
 elif n in (152,153):status='caustics; official C3-BG-011; delegated VFX inventory'
 elif selected:status='export candidate prepared'
 else:status='reference only: flattened scene, checkerboard, mixed atlas, or duplicate; no production sprite inferred'
 audit.append(dict(source_index=n,source=rel(Path(m['path'])),sha256=m['sha256'],source_message_id=m.get('source_message_id'),requested_ids=m.get('requested_asset_ids'),verified_official_id=selection.get(n),status=status))
manifest={'governing_bible':'lanterns_underroot_chapter_3_production_bible.md','source_archive':rel(ARCH/'metadata.json'),'policy':'No generation, enlargement, normal-map fabrication, checklist approval, or complete level illustration used as gameplay. Native export candidates only. Originals unchanged in archive.','exports':records,'source_audit':audit,'missing_or_blocked':['C3-TILE-001/002/003: no standalone seamless terrain top/middle/underside delivered by these sources','C3-BG-001: supplied panorama attempts are complete illustrated scenes with gameplay foreground; retained as references','C3-BG-005/006/007/008/009: wrong subjects or flattened scenery, not the required separable section layers','C3-PROP-010/011: no matching closed/open rune-door pair; wall-relief art is not a door','C3-BG-012: source requested this ID but depicts caustics; no foreground roots falsely approved','Depth/mask guide panels are not normal maps and do not establish valid relief or pixel alignment']}
DOC.mkdir(parents=True,exist_ok=True)
(DOC/'environment-asset-preparation.json').write_text(json.dumps(manifest,indent=2)+'\n')
# Contact gallery is only a preview, with flat contrasting backgrounds to reveal alpha problems.
for page in range((len(records)+7)//8):
 sheet=Image.new('RGB',(1280,760),'#17353d');draw=ImageDraw.Draw(sheet)
 for j,r in enumerate(records[page*8:page*8+8]):
  im=Image.open(ROOT/r['export']); im.thumbnail((300,315)); x=(j%4)*320+(320-im.width)//2;y=(j//4)*380+20
  sheet.paste(im,(x,y),im); draw.text(((j%4)*320+8,(j//4)*380+340),Path(r['export']).stem[:41],fill='white')
 sheet.save(DOC/f'environment-asset-preparation-{page+1:02d}.png')
# Native editable Sprite2D gallery pages, not a scripted assembled level.
review=ROOT/'scenes/chapter_03/review';review.mkdir(parents=True,exist_ok=True)
for page in range((len(records)+7)//8):
 lines=['[gd_scene load_steps=9 format=3]','']
 group=records[page*8:page*8+8]
 lines[0]=f'[gd_scene load_steps={len(group)+1} format=3]'
 for i,r in enumerate(group):lines.append(f'[ext_resource type="Texture2D" path="res://{r["export"]}" id="{i+1}"]')
 lines+=['','[node name="EnvironmentAssetReview" type="Node2D"]','texture_filter = 2','metadata/review_only = true','metadata/approved = false','', '[node name="ReviewBackground" type="Polygon2D" parent="."]','polygon = PackedVector2Array(0, 0, 1280, 0, 1280, 760, 0, 760)','color = Color(0.04, 0.12, 0.15, 1)']
 for i,r in enumerate(group):
  w,h=r['dimensions'];s=min(300/w,280/h,1)
  lines+=['',f'[node name="Asset{i+1}" type="Sprite2D" parent="."]',f'position = Vector2({160+(i%4)*320}, {305+(i//4)*350})',f'scale = Vector2({s}, {s})',f'texture = ExtResource("{i+1}")',f'offset = Vector2(0, {-h/2})',f'metadata/official_id = "{r["asset_id"]}"',f'metadata/source_index = {r["source_index"]}','',f'[node name="Label{i+1}" type="Label" parent="."]',f'offset_left = {8+(i%4)*320}.0',f'offset_top = {314+(i//4)*350}.0',f'text = "{r["asset_id"]} · source {r["source_index"]}\n{Path(r["export"]).stem[12:43]}"','theme_override_font_sizes/font_size = 14']
 (review/f'c3_environment_asset_review_{page+1:02d}.tscn').write_text('\n'.join(lines)+'\n')
(DOC/'environment-asset-preparation.md').write_text('''# Chapter 3 environment preparation\n\nExisting ZIP art is organized in bible order by verified subject, not unreliable requested IDs. All original files remain untouched in the production source archive. Detailed source, crop rectangles, alpha operations, dimensions, hashes, pivots, layers, lighting/collision roles and blockers are recorded in [the JSON handoff](environment-asset-preparation.json).\n\nImport candidates are under `art/environment/chapter_03/`. Open `scenes/chapter_03/review/c3_environment_asset_review_01.tscn` through `_08.tscn` for editable Sprite2D galleries. These galleries do not alter the campaign or approve art. Depth/mask panel crops live in `art/source/chapter_03/environment/guide_panels/` with `.gdignore`; they are reference images, not inferred normal maps.\n\nMost modular sheets use a painted checkerboard. Their base-panel exports have reconstructed alpha using an explicit bright-neutral key, with no enlargement. Review isolated edges and compare against the archived source before runtime placement. The statue120 and distant layer076/079/090 have native alpha. No complete level screenshot or atlas thumbnail is enlarged into playable scenery.\n\nThe set includes isolated ruined arches/pillars/statues, ornate ledges, a stair and rope-bridge candidate, wall reliefs, unlit hanging lamp, hanging vines and individual rubble. Perspective stairs/bridges need gameplay fitting; seamless mossy terrain top/middle/underside and matching rune-door states remain unfulfilled. Source claims of C3-BG-011 sub-IDs are remapped to official PROP/TILE/DEC IDs; caustics requested as BG012 belong to BG011 and are handled with VFX.\n''')
print(json.dumps({'exports':len(records),'sources_audited':len(audit),'pages':(len(records)+7)//8}))
