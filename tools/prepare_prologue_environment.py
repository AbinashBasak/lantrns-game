"""Copy selected reviewed generated exports into the Godot runtime, preserving originals."""
from pathlib import Path
import json, hashlib, shutil
from PIL import Image
root=Path(__file__).resolve().parents[1]
out=root/'assets/runtime/prologue/environment';out.mkdir(parents=True,exist_ok=True)
env=root/'assets/production/phase_04_environment_packs/ENV-01/exports'
files=[env/f'ENV-01_{s}.png' for s in ['distant_background','midground','foreground']]
files += [env/f'ENV-01_decorative_props_{i:02}.png' for i in [0,1,2,3,5,6,7]]
files += [env/f'ENV-01_interactive_props_{i:02}.png' for i in range(6)]
files += [root/'assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/exports'/f'TILE-001_{s}.png' for s in ['01_top_middle','05_opaque_interior','03_isolated_block']]
rows=[]
for source in files:
 target=out/source.name
 crop=None
 if 'decorative_props' in source.name or 'interactive_props' in source.name:
  im=Image.open(source).convert('RGBA')
  crop=im.getchannel('A').point(lambda value: 255 if value > 64 else 0).getbbox()
  im.crop(crop).save(target)
 else:shutil.copy2(source,target)
 rows.append(dict(asset_id=source.name.split('_')[0],source=str(source.relative_to(root)),runtime=str(target.relative_to(root)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),runtime_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),operation='visible-alpha crop for foot anchoring' if crop else 'unchanged copy of reviewed generated production export',source_crop=list(crop) if crop else None))
# Mechanically isolate reviewed bridge components; trim only transparent/near-transparent margins.
bridge=root/'assets/production/phase_06_props_and_interactive_objects/village_and_forest_props/PROP-006/exports'
for name in ['00_left_entry','01_middle_repeat','02_right_entry']:
 source=bridge/f'PROP-006_{name}.png'
 original=Image.open(source).convert('RGBA')
 bounds=original.getchannel('A').point(lambda value: 255 if value > 40 else 0).getbbox()
 target=out/source.name
 original.crop(bounds).save(target)
 rows.append(dict(asset_id='PROP-006',source=str(source.relative_to(root)),runtime=str(target.relative_to(root)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),runtime_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),operation='alpha-bounds crop of generated individual bridge export; original unchanged',source_crop=list(bounds),dimensions=list(Image.open(target).size)))
# Runtime strips remove atlas padding and isolate a plain soil interior.
derivatives=[
 (root/'assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-006/exports/TILE-006_plank_repeat.png','TILE-006_timbers.png',(3,27,61,39),'crop'),
 (env/'ENV-01_distant_background.png','ENV-01_distant_background_mirrored.png',None,'mirror'),
 (root/'assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-001/exports/TILE-001_01_top_middle.png','TILE-001_surface_strip.png',(8,30,62,63),'crop'),
 (root/'assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-002/exports/TILE-002_05_opaque_interior.png','TILE-002_soil_fill.png',(10,12,58,55),'crop'),
]
for source,name,crop,operation in derivatives:
 im=Image.open(source).convert('RGBA')
 im=im.transpose(Image.Transpose.FLIP_LEFT_RIGHT) if operation=='mirror' else im.crop(crop)
 target=out/name; im.save(target)
 rows.append(dict(asset_id=source.name.split('_')[0],source=str(source.relative_to(root)),runtime=str(target.relative_to(root)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),runtime_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),operation=operation,source_crop=list(crop) if crop else None,dimensions=list(im.size)))
# Selected village construction modules and natural district landmarks.
props=root/'assets/production/phase_06_props_and_interactive_objects/village_and_forest_props'
selection={
 'PROP-004':['00_intact'],
 'PROP-009':['closed_unlatched'],
 'PROP-010':['roof_left_eave','roof_repeat','roof_right_eave','window_closed','window_round'],
 'PROP-011':['bush_low','bush_round','flower_white','mixed_ground_plants'],
 'PROP-012':['root_arch','root_stump','small_bare_tree','sapling_leafy'],
}
for asset_id,names in selection.items():
 for name in names:
  source=props/asset_id/'exports'/f'{asset_id}_{name}.png'
  original=Image.open(source).convert('RGBA')
  bounds=original.getchannel('A').point(lambda value: 255 if value > 40 else 0).getbbox()
  target=out/source.name; original.crop(bounds).save(target)
  rows.append(dict(asset_id=asset_id,source=str(source.relative_to(root)),runtime=str(target.relative_to(root)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),runtime_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),operation='alpha-bounds crop of generated village construction module; original unchanged',source_crop=list(bounds),dimensions=list(Image.open(target).size)))
(out/'manifest.json').write_text(json.dumps(dict(files=rows,notes=['Runtime stage integration; no source sheet or lighting concept used as scenery.','ENV01 architecture is a separately generated transparent midground layer.','Dedicated NPC source/export provenance is retained in npc_manifest.json separately.']),indent=2)+'\n')
