#!/usr/bin/env python3
"""Deterministic crops of supplied ZIP textures; never generate replacement artwork."""
from pathlib import Path
from PIL import Image
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
archive=ROOT/'assets/production/source_archives/chat_export_6add021c'
records=json.loads((archive/'metadata.json').read_text())['image_records']
outputs=[]
def crop(number,box,name,official,role,notes):
 r=next(r for r in records if f'image-{number:03}-' in r['path'])
 src=ROOT/'assets/production/source_archives/chat_export_6add021c/original_export'/r['zip_member']
 im=Image.open(src).crop(box)
 out=ROOT/'art/vfx/chapter_03'/name;im.save(out)
 outputs.append(dict(official_ids=official,role=role,source_path=str(src.relative_to(ROOT)),source_sha256=r['sha256'],source_message_id=r.get('source_message_id'),source_crop=list(box),output_path=str(out.relative_to(ROOT)),output_sha256=hashlib.sha256(out.read_bytes()).hexdigest(),dimensions=list(im.size),visible_bounds=im.convert('RGBA').getbbox(),alpha_extrema=im.getchannel('A').getextrema() if im.mode=='RGBA' else None,provenance='derived rectangular crop from unchanged ZIP source',notes=notes,production_approved=False))
crop(107,(2,0,505,815),'C3-TILE-020_waterfall_stream.png',['C3-TILE-020','C3-BG-003'],'transparent waterfall artwork','Caption/map panels excluded. Static illustrated stream animated by subtle native shader; not a recovered animation sheet. No collision. Top-center pivot.')
crop(153,(515,2,1025,856),'C3-BG-011_caustic_intensity.png',['C3-BG-011'],'grayscale caustic intensity shader input','Middle panel extracted; printed depth label is source terminology only. Not a normal map or a registered depth map. Source colored panel has baked checkerboard and is excluded. Pattern is not proven seamless; shader mirrors addressing to prevent value seams. Top-left origin.')
report=dict(governing_bible='lanterns_underroot_chapter_3_production_bible.md',source_zip='1.zip',outputs=outputs,source_guide='assets/production/source_archives/chat_export_6add021c/original_export/Continue Asset Generation [6add021c]/files/C3-BG-008-LGT-001_Godot_Setup_Guide.txt',lighting_budget=dict(active_visible_target=16,shadowed_target=2,offscreen_lights='disabled by scene manager at integration',reduced_effects='freeze shader motion; disable particles and shadows; retain light cues'),qa=dict(stage='technical preparation; runtime checks pending',final_production_approved=False),existing_native_components=['c3_lantern_light','c3_lantern_sparks','c3_crystal_motes','c3_waterfall_mist','c3_shrine_light'])
report_path = ROOT/'docs/chapter03/lighting-vfx-preparation.json'
if report_path.exists():
 previous = json.loads(report_path.read_text())
 if [x['output_sha256'] for x in previous.get('outputs', [])] == [x['output_sha256'] for x in outputs]:
  for key in ['qa', 'native_resource_files', 'native_role_mappings']:
   if key in previous: report[key] = previous[key]
report_path.write_text(json.dumps(report,indent=2)+'\n')
