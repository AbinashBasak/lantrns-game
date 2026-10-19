#!/usr/bin/env python3
"""Prepare selected existing generated exports; originals remain untouched."""
from pathlib import Path
from PIL import Image
import hashlib, json, shutil
import numpy as np
from scipy import ndimage

# Reviewed atlas cells with neighboring-cell fragments at their sides.
CLEAN_COMPONENT = {
    "ENV-02_interactive_props_01.png", "ENV-02_interactive_props_04.png",
    "ENV-03_decorative_props_01.png", "ENV-03_decorative_props_04.png",
    "ENV-03_decorative_props_06.png", "ENV-03_decorative_props_07.png",
    "ENV-03_interactive_props_01.png", "ENV-03_interactive_props_04.png",
}
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/runtime/chapter01/environment'
OUT.mkdir(parents=True, exist_ok=True)
records = []
def save(source, name=None, crop=False):
    source = ROOT / source
    target = OUT / (name or source.name)
    bounds = None
    if crop:
        im = Image.open(source).convert('RGBA')
        bounds = im.getchannel('A').getbbox()
        if source.name in CLEAN_COMPONENT:
            labels, count = ndimage.label(np.asarray(im)[:, :, 3] > 64)
            areas = np.bincount(labels.ravel())
            areas[0] = 0
            largest = int(areas.argmax())
            region = ndimage.find_objects(labels)[largest - 1]
            bounds = (region[1].start, region[0].start, region[1].stop, region[0].stop)
        if bounds: im = im.crop(bounds)
        im.save(target)
    else: shutil.copy2(source, target)
    with Image.open(target) as im: dimensions = list(im.size)
    records.append({'source':str(source.relative_to(ROOT)), 'runtime':str(target.relative_to(ROOT)), 'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(), 'sha256':hashlib.sha256(target.read_bytes()).hexdigest(), 'dimensions':dimensions, 'alpha_crop':bounds, 'crop_method':'largest_connected_alpha_component_threshold64' if source.name in CLEAN_COMPONENT else ('alpha_bounds' if crop else 'unchanged'), 'derived':bool(crop)})
for asset in ('ENV-02','ENV-03'):
    base = f'assets/production/phase_04_environment_packs/{asset}/exports/'
    for layer in ('distant_background','midground','foreground'):
        save(base+f'{asset}_{layer}.png')
    for category,count in [('decorative_props',8),('interactive_props',6)]:
        for i in range(count): save(base+f'{asset}_{category}_{i:02d}.png',crop=True)
for name in ('TILE-001_surface_strip.png','TILE-002_soil_fill.png'):
    save('assets/runtime/prologue/environment/'+name)
base='assets/production/phase_05_reusable_terrain_and_tile_sets/TILE-003/exports/'
for name in ('TILE-003_01_top_middle.png','TILE-003_05_opaque_interior.png','TILE-003_03_isolated_block.png'):
    save(base+name,crop=True)
(OUT/'manifest.json').write_text(json.dumps({'purpose':'Chapter 1 selected runtime derivatives from archived generated exports','production_approved':False,'files':records},indent=2)+'\n')
print(f'Prepared {len(records)} runtime files')
