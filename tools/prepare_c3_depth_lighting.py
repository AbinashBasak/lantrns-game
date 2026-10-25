#!/usr/bin/env python3
"""Register supplied triptych height/bitmap panels and derive diagnostic bump normals."""
from pathlib import Path
from PIL import Image, ImageFilter
import json,hashlib,numpy as np
ROOT=Path(__file__).resolve().parents[1]
rows=json.loads((ROOT/'docs/chapter03/environment-asset-preparation.json').read_text())['exports']
outdir=ROOT/'art/vfx/chapter_03/derived_normals';outdir.mkdir(exist_ok=True,parents=True)
records=[]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for idx in [138,142]:
 row=next(x for x in rows if x.get('source_index')==idx)
 diffuse=Image.open(ROOT/row['export']).convert('RGBA');alpha=np.array(diffuse)[:,:,3];support=alpha>128
 tag=row['asset_id']+f'_source{idx}'
 maps={};registration=[]
 for guide in row['guide_panels']:
  source=ROOT/guide['path'];raw=np.array(Image.open(source).convert('L'))
  # Exclude panel seams at outer border; retain unchanged source separately.
  raw[:,:12]=0;raw[:,-12:]=0;raw[:12,:]=0;raw[-12:,:]=0
  bounds=Image.fromarray(np.uint8(raw>30)*255).getbbox()
  aligned=Image.fromarray(raw).crop(bounds).resize(diffuse.size,Image.Resampling.LANCZOS)
  a=np.array(aligned);map_support=a>30;iou=float((map_support&support).sum()/(map_support|support).sum())
  assert iou>0.85, f'{tag} {guide["role"]}: registration insufficient'
  role='height' if guide['role']=='depth_reference' else 'bitmap'
  dest=outdir/f'{tag}_{role}_registered.png';aligned.save(dest);maps[role]=aligned
  registration.append(dict(source=guide['path'],source_sha256=sha(source),source_panel_crop=bounds,transform='axis-aligned silhouette bounding-box scale to exported diffuse canvas',target_dimensions=diffuse.size,silhouette_iou=iou,threshold=30,output=str(dest.relative_to(ROOT)),output_sha256=sha(dest)))
 # Smooth supplied grayscale height to suppress image noise, derive unit normals.
 height=np.array(maps['height'].filter(ImageFilter.GaussianBlur(1.5)),dtype=float)/255
 dy,dx=np.gradient(height);strength=8.0
 normal=np.stack((-dx*strength,dy*strength,np.ones_like(dx)),axis=-1)
 normal/=np.linalg.norm(normal,axis=-1,keepdims=True)
 # Godot 2D tangent Y+ points upward, hence green stores +dheight/dy.
 normal=np.uint8(np.clip((normal*.5+.5)*255,0,255))
 interior=np.array(Image.fromarray(alpha).filter(ImageFilter.MinFilter(9)))>200
 normal[~interior]=[128,128,255]
 normal_path=outdir/f'{tag}_bump_normal_derived.png';Image.fromarray(normal).save(normal_path)
 canvas=ROOT/f'resources/chapter_03/lighting/{tag}_canvas_texture.tres'
 canvas.write_text(f'''[gd_resource type="CanvasTexture" load_steps=4 format=3]\n\n[ext_resource type="Texture2D" path="res://{row['export']}" id="1_diffuse"]\n[ext_resource type="Texture2D" path="res://{normal_path.relative_to(ROOT)}" id="2_normal"]\n[ext_resource type="Texture2D" path="res://{registration[1]['output']}" id="3_bitmap"]\n\n[resource]\ndiffuse_texture = ExtResource("1_diffuse")\nnormal_texture = ExtResource("2_normal")\nspecular_texture = ExtResource("3_bitmap")\nspecular_color = Color(0.18, 0.18, 0.18, 1)\nspecular_shininess = 0.22\ntexture_filter = 2\n''')
 records.append(dict(official_id=row['asset_id'],source_index=idx,diffuse_path=row['export'],diffuse_sha256=sha(ROOT/row['export']),dimensions=diffuse.size,maps=registration,derived_normal_path=str(normal_path.relative_to(ROOT)),derived_normal_sha256=sha(normal_path),method='supplied grayscale height -> Gaussian blur radius1.5px -> central gradients -> normalize(-8*dx,+8*dy,1); RGB=(n+1)/2; 4px alpha-edge exclusion resets normal flat',normal_convention='Godot X+, Y+, Z+; green positive for increasing raster height slope downward',bitmap_use='Registered supplied bitmap as restrained specular mask; source is a tonal guide, not physically authored roughness',canvas_texture=str(canvas.relative_to(ROOT)),canvas_texture_sha256=sha(canvas),registration_limitations='Silhouette registration only; grayscale panels are generated tonal interpretations. Internal feature correspondence requires actual art review; no nonrigid warping.',production_approved=False))
report=dict(assets=records,source_policy='Unaltered source/guide files preserved. Aligned maps and bump normals are explicitly derived diagnostic files, not authored normal maps.',qa_status='native graphical verification pending',production_approved=False)
(ROOT/'docs/chapter03/lighting-vfx-preparation-depth.json').write_text(json.dumps(report,indent=2)+'\n')
