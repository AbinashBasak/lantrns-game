#!/usr/bin/env python3
"""Crop real orthographic rock pixels into a conservative Chapter3 reusable terrain candidate.
uv run --with pillow python tools/prepare_c3_terrain.py
No texture painting, recolor or enlargement. Mirrors are explicitly derived arrangements.
"""
from pathlib import Path
from PIL import Image,ImageChops,ImageStat
import json,hashlib,subprocess
R=Path(__file__).resolve().parents[1]
A=R/'art/environment/chapter_03/tiles/terrain_candidates';A.mkdir(parents=True,exist_ok=True)
RES=R/'resources/chapter_03/terrain';RES.mkdir(parents=True,exist_ok=True)
D=R/'docs/chapter03';SC=R/'scenes/chapter_03/review'
GODOT='/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot'
P=R/'assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-004/source_images/TILE-004_terrain_atlas_original.png'
source=Image.open(P).convert('RGBA')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p):return str(p.relative_to(R))
roles=[('C3-TILE-001','mossy_stone_top',(340,128,596,384)),('C3-TILE-002','stone_middle',(340,384,596,640)),('C3-TILE-003','stone_underside',(340,640,596,896))]
records=[];frames=[]
for aid,name,rect in roles:
 im=source.crop(rect)
 variants=[('native',im),('mirror_x',im.transpose(Image.Transpose.FLIP_LEFT_RIGHT))]
 if aid=='C3-TILE-002':variants += [('mirror_y',im.transpose(Image.Transpose.FLIP_TOP_BOTTOM)),('mirror_xy',im.transpose(Image.Transpose.ROTATE_180))]
 for variant,img in variants:
  path=A/(aid.lower().replace('-','_')+'_'+name+'_'+variant+'.png');img.save(path);frames.append(img)
  records.append(dict(asset_id=aid,export=rel(path),export_sha256=sha(path),dimensions=list(img.size),source=rel(P),source_sha256=sha(P),source_crop=rect,operation='unchanged native crop' if variant=='native' else variant,alpha_bounds=img.getchannel('A').getbbox(),pivot=[0,0],world_units_per_tile=64,native_pixels_per_tile=256,world_scale=.25,filter='linear',compression='lossless',receives_light=True,emits_light=False,casts_shadows='separate simple authored terrain occluder if needed',animation_frames=1,fps=0,approved=False,stage='native TileSet seam/collision review candidate',limitations=['Generic reusable mossy blue-gray rock material; not a newly authored ornate Chapter3 terrain pack','Mirrored repetition is visible; no seamless-authored-art claim','Vertical sequence top, odd number of alternating middle/middle-Y rows, underside preserves source joins; arbitrary transitions not approved']))
atlas=Image.new('RGBA',(256*len(frames),256));
for i,im in enumerate(frames):
 atlas.paste(im,(i*256,0));records[i]['atlas_coords']=[i,0];records[i]['source_alpha_preserved']=True
atlas_path=A/'c3_terrain_candidate_atlas.png';atlas.save(atlas_path)
# Numerical seam evidence compares actual boundary pixels; transparent regions are not silently filled.
def edge_mae(a,b):return [round(v,4) for v in ImageStat.Stat(ImageChops.difference(a,b)).mean]
seams={'horizontal_mirror_x_mae_rgba':edge_mae(frames[0].crop((255,0,256,256)),frames[1].crop((0,0,1,256))),'top_to_middle_mae_rgba':edge_mae(frames[0].crop((0,255,256,256)),frames[2].crop((0,0,256,1))),'middle_to_mirror_y_mae_rgba':edge_mae(frames[2].crop((0,255,256,256)),frames[4].crop((0,0,256,1))),'middle_to_underside_mae_rgba':edge_mae(frames[2].crop((0,255,256,256)),frames[6].crop((0,0,256,1)))}
# Save actual editable TileSet/TileMapLayer + separate authored flat collision in an offline bake.
subprocess.run([GODOT,'--headless','--path',str(R),'--editor','--import','--quit'],stdout=subprocess.DEVNULL,check=True)
gd='''extends SceneTree
func _initialize() -> void:
 var atlas := TileSetAtlasSource.new()
 atlas.texture = load("res://ATLAS")
 atlas.texture_region_size = Vector2i(256,256)
 for x: int in 8:
  atlas.create_tile(Vector2i(x,0))
 var tiles := TileSet.new()
 tiles.tile_size = Vector2i(256,256)
 tiles.add_source(atlas,0)
 ResourceSaver.save(tiles,"res://resources/chapter_03/terrain/c3_terrain_candidate_tileset.tres")
 tiles=load("res://resources/chapter_03/terrain/c3_terrain_candidate_tileset.tres")
 var scene := Node2D.new()
 scene.name="C3TerrainSeamReview"
 scene.set_meta("production_approved",false)
 var backdrop := Polygon2D.new()
 backdrop.name="NeutralBackdrop"
 backdrop.polygon=PackedVector2Array([Vector2(0,0),Vector2(1280,0),Vector2(1280,720),Vector2(0,720)])
 backdrop.color=Color("17353d")
 scene.add_child(backdrop);backdrop.owner=scene
 var layer := TileMapLayer.new()
 layer.name="AuthoredRockTiles"
 layer.tile_set=tiles
 layer.position=Vector2(80,180)
 layer.scale=Vector2(.25,.25)
 layer.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 for y: int in 5:
  for x: int in 12:
   var frame: int = (x%2)
   if y==4:frame+=6
   elif y==2:frame+=4
   elif y>0:frame+=2
   layer.set_cell(Vector2i(x,y),0,Vector2i(frame,0))
 scene.add_child(layer);layer.owner=scene
 var ground := StaticBody2D.new()
 ground.name="SeparateFlatCollision"
 ground.position=Vector2(464,190)
 scene.add_child(ground);ground.owner=scene
 var shape := CollisionShape2D.new()
 shape.name="WalkableSurface"
 var rect := RectangleShape2D.new()
 rect.size=Vector2(768,14)
 shape.shape=rect
 ground.add_child(shape);shape.owner=scene
 for i: int in 3:
  var label := Label.new()
  label.name="ReviewNote%d"%i
  label.position=Vector2(80,30+i*30)
  label.text=["Chapter 3 terrain candidate: existing high-resolution orthographic mossy rock", "12 columns: native crop / mirrored X. Middle rows alternate Y. No paint or enlargement.", "Separate flat collision at y=183. Technical review only; visual pattern approval pending."][i]
  scene.add_child(label);label.owner=scene
 var note := Label.new()
 note.name="Gate"
 note.position=Vector2(80,540)
 note.text="TILE001 top / TILE002 fill / TILE003 underside | 256 native pixels = 64 world units\\nOdd middle-row sequence retains original vertical source joins. No arbitrary autoterrain claims."
 scene.add_child(note);note.owner=scene
 var packed := PackedScene.new()
 packed.pack(scene)
 ResourceSaver.save(packed,"res://scenes/chapter_03/review/c3_terrain_seam_review.tscn")
 scene.free()
 print("C3 terrain: native TileSet and 60-cell TileMapLayer baked")
 quit()
'''.replace('ATLAS',rel(atlas_path))
bake=Path('/tmp/c3_terrain_bake.gd');bake.write_text(gd)
subprocess.run([GODOT,'--headless','--path',str(R),'--script',str(bake)],check=True)
report=dict(exports=records,atlas=dict(path=rel(atlas_path),sha256=sha(atlas_path)),source_scope='All phase05 originals and ENV03/05/07 terrain packs visually compared; ZIP115–151 architectural props examined; locked map and miniature reference images excluded.',seam_evidence=seams,native_tileset='resources/chapter_03/terrain/c3_terrain_candidate_tileset.tres',native_scene='scenes/chapter_03/review/c3_terrain_seam_review.tscn',native_resources=['resources/chapter_03/terrain/c3_terrain_candidate_tileset.tres','scenes/chapter_03/review/c3_terrain_seam_review.tscn'],approval=False,canonical_id_cautions=['Broken pillars/rubble remain PROP008 candidates. Partial wall/arch buttresses138/139/146 are broken architecture candidates, not proof of a clean three-piece broken-pillar set; complete temple arches belong PROP009.','Existing source-image124/125 in ZIP are ornate arches, not flat moss platform deliverables. They are not terrain replacements.'],remaining_gates=['Actual-render seam and collision review','Mirrored texture repetition acceptance','Approval of generic reusable rock material against Chapter3 target; color unchanged','Corners, sidewalls, alternative depth transitions and autoterrain peering not delivered'])
(D/'terrain-handoff.json').write_text(json.dumps(report,indent=2)+'\n')
(D/'terrain-handoff.md').write_text('''# Chapter 3 terrain recovery candidate\n\nRecovered real orthographic mossy blue-gray rock pixels from existing reusable TILE-004 original (1254×1254, genuine alpha). This is reusable material, not a forced perspective arch or enlarged atlas miniature. Eight 256×256 exports retain source pixels; three native crops provide moss top, middle and underside, with explicitly mirrored arrangements for repeated joins. The TileSet uses native 256px regions and a TileMapLayer scale of 0.25 (64 world units). No color changes, synthesized pixels or texture painting.\n\n`scenes/chapter_03/review/c3_terrain_seam_review.tscn` contains a native editable 60-cell TileMapLayer and separate flat collision. It is a seam/collision review, not campaign integration. The JSON records original hashes, crop rectangles, alpha bounds and measured seam differences. Mirrored repetition remains visible. Odd alternating middle-row sequences retain the original vertical joins; corners, arbitrary-depth transitions and autoterrain peering are not claimed.\n\nZIP images124/125 are ornate archways. They cannot supply the orthographic horizontal top/middle/underside prerequisite. Broken arch/wall buttresses138/139/146 are broken-architecture PROP008 candidates only; complete arches remain PROP009. No clean three-piece broken-pillar completion is inferred.\n''')
print(json.dumps({'exports':len(records),'seams':seams}))
