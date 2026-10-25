#!/usr/bin/env python3
"""Organize supplied C3 collectibles; exact-pixel unlit bases stay separate from light.

Requires Pillow, NumPy, SciPy. Source requested IDs are not trusted as visual
identity: mislabeled keys/hearts/crystals are mapped to their actual bible IDs.
No RGB checkerboard keying, glow subtraction, depth-to-normal conversion, or
invented pickup poses. Unusable attempts remain archived with explicit blockers.
"""
from pathlib import Path
import json
import shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy.ndimage import label, find_objects, distance_transform_edt
import prepare_c3_animations as native

ROOT=Path(__file__).resolve().parents[1]
ART=ROOT/'art/environment/chapter_03/collectibles'
RES=ROOT/'resources/chapter_03/animations/collectibles'
SCENES=ROOT/'scenes/props/chapter_03/review'
LIB=ROOT/'assets/production/chapter_03_sunken_temple/collectibles'
DOCS=ROOT/'docs/chapter03'
SOURCE=ROOT/'assets/production/source_archives/chat_export_6add021c/metadata.json'
TITLES={1:'Golden Fragment',2:'Temple Key',3:'Drainage Sigil',4:'Guardian Key',5:'Sunken Seal',6:'Health pickup',7:'Lore tablet',8:'Relic shard'}
# Per-pose source bands exclude labels/dividers and choose intact unlit bodies.
RECIPES={
 2:dict(image=66,regions=[(0,540,207,1000),(207,540,394,1000),(394,540,578,1000),(578,540,774,1000)],note='Requested Lore tablet; actual Temple Key. First four intact unlit lower-row keys only. Fifth key disintegrates and is not idle.'),
 6:dict(image=57,regions=[(0,570,210,915),(210,570,407,915),(407,570,593,915),(593,570,798,915)],note='Requested Lore tablet; actual heart-vine health pickup. First four intact lower-row bodies only. Fifth starts the red-fragment burst and is excluded; disconnected leaves and later dissolve fragments remain source-only.'),
 7:dict(image=69,regions=[(0,405,256,644),(256,405,512,644),(512,405,768,644),(768,405,1024,644),(1024,405,1280,644),(1280,380,1536,644)],note='Six unlit middle-row tablets. Printed title/frame labels, depth row, lit row and disconnected flying debris excluded. Sixth pose uses an earlier top bound to preserve its raised leaves.'),
 8:dict(image=72,regions=[(0,382,256,630),(256,382,512,630),(512,350,768,630),(768,350,1024,630),(1024,350,1280,630),(1280,350,1536,630)],note='Six unlit middle-row relic-shard bodies. Per-cell upper bounds remove the printed row title while preserving later tilted tips. No depth map is presented as normal data.'),
}
BLOCKED={
 1:dict(images=[50,64],reason='Golden-crystal originals are RGB with a painted checkerboard. Alpha/antialias background colors cannot be recovered without inferred pixels; no clean base export is claimed.'),
 3:dict(images=[52],reason='Only combined glowing sigil/burst artwork. No matching unlit base or isolated overlay; subtracting the glow would infer missing body pixels.'),
 4:dict(images=[53],reason='Only combined glowing Guardian Key/burst artwork. No clean base independent of halo or standalone effect.'),
 5:dict(images=[54],reason='Only combined Sunken Seal glow/activation artwork. No unlit base or standalone overlay delivered.'),
}


def isolate(path,region):
    source=Image.open(path).convert('RGBA')
    crop=source.crop(region)
    arr=np.array(crop)
    labs,_=label(arr[:,:,3]>32)
    sizes=np.bincount(labs.ravel());sizes[0]=0
    chosen=int(sizes.argmax())
    assert sizes[chosen]>2500, (path,region,'no substantial isolated base')
    core=labs==chosen
    distance=distance_transform_edt(~core)
    arr[distance>2]=0
    pose=Image.fromarray(arr)
    box=pose.getbbox()
    assert box is not None
    absolute=[region[0]+box[0],region[1]+box[1],region[0]+box[2],region[1]+box[3]]
    return pose.crop(box),absolute


def main():
    for p in [ART,RES,SCENES,LIB,DOCS]:p.mkdir(parents=True,exist_ok=True)
    archive=json.loads(SOURCE.read_text())
    records={int(Path(r['path']).name.split('-')[1]):r for r in archive['image_records'] if Path(r['path']).name.startswith('image-')}
    handoff={'schema':1,'kind':'Chapter3 supplied collectible base organization',
             'source_archive':native.rel(SOURCE),'governing_bible':'lanterns_underroot_chapter_3_production_bible.md',
             'production_approved':False,'assets':[],
             'policy':'Requested ID and verified visual identity remain distinct. Exact native pixels retained; labels, disconnected debris, faint alpha noise and other rows excluded. Base artwork never contains a copied light/burst layer. No reconstruction or resize.'}
    native.RES=RES;native.SCENES=SCENES
    for n,title in TITLES.items():
        aid=f'C3-ITM-{n:03}'
        folder=LIB/aid
        source_dir=folder/'source_images'
        source_dir.mkdir(parents=True,exist_ok=True)
        if n in BLOCKED:
            sources=[]
            for number in BLOCKED[n]['images']:
                r=records[number]
                original=source_dir/f'{aid}_archive_{Path(r["path"]).name}'
                shutil.copyfile(r['path'],original)
                sources.append(source_record(r,original,aid))
            handoff['assets'].append({'asset_id':aid,'title':title,'sources':sources,
              'stage':'source archive reviewed; no clean base export','blockers':[BLOCKED[n]['reason']],
              'runtime_exports':[],'production_approved':False})
            continue
        recipe=RECIPES[n];r=records[recipe['image']]
        original=source_dir/f'{aid}_archive_{Path(r["path"]).name}'
        shutil.copyfile(r['path'],original)
        frames=[isolate(original,tuple(region)) for region in recipe['regions']]
        width=max(f[0].width for f in frames)+24;height=max(f[0].height for f in frames)+24
        width+=width%2;height+=height%2
        pivot=[width//2,height//2]
        outdir=ART/aid.lower().replace('-','_')/'idle_unlit'
        outdir.mkdir(parents=True,exist_ok=True)
        archived_dir=folder/'exports/native_base_review_v1/idle_unlit'
        archived_dir.mkdir(parents=True,exist_ok=True)
        exports=[];archived=[]
        contact=Image.new('RGBA',(240*min(4,len(frames)),300*((len(frames)+3)//4)),(14,35,42,255))
        draw=ImageDraw.Draw(contact)
        for i,(pose,bounds) in enumerate(frames):
            canvas=Image.new('RGBA',(width,height))
            canvas.paste(pose,((width-pose.width)//2,(height-pose.height)//2))
            out=outdir/f'{aid}_idle_unlit_{i:02}.png';canvas.save(out)
            archive_out=archived_dir/out.name;shutil.copyfile(out,archive_out)
            exports.append({'path':native.rel(out),'sha256':native.sha(out),'dimensions':[width,height],
                            'visible_bounds':list(canvas.getbbox()),'source_crop_bounds':bounds})
            archived.append({'path':str(archive_out),'sha256':native.sha(archive_out)})
            thumb=canvas.copy();thumb.thumbnail((220,264))
            contact.alpha_composite(thumb,((i%4)*240+(240-thumb.width)//2,(i//4)*300+24))
            draw.text(((i%4)*240+8,(i//4)*300+4),f'{aid} unlit {i+1}',fill='white')
        preview=DOCS/f'collectible-asset-preparation-{aid.lower()}.png';contact.save(preview)
        archived_preview_dir=folder/'previews/native_base_review_v1';archived_preview_dir.mkdir(parents=True,exist_ok=True)
        archived_preview=archived_preview_dir/f'{aid}_unlit_preview.png';shutil.copyfile(preview,archived_preview)
        clip={'action':'idle_unlit','exports':exports,'loop':True,'fps':6}
        resource=native.write_spriteframes(aid,[clip])
        scene=native.write_scene(aid,[clip],resource,width,height,pivot)
        # Keep floating objects entirely visible and make source vs real light
        # separate editable nodes. This light is an authored review aid, not a
        # generated glow overlay, emission map, or gameplay integration.
        text=scene.read_text().replace('position = Vector2(640, 610)','position = Vector2(640, 410)')
        text=text.replace('load_steps=7','load_steps=8')
        at=text.index('\n[sub_resource')
        text=text[:at]+'\n[ext_resource type="Texture2D" path="res://assets/runtime/shared/lighting/soft_radial.tres" id="2_light"]\n'+text[at:]
        color='Color(1, 0.35, 0.18, 1)' if n==6 else 'Color(0.22, 0.85, 1, 1)'
        y=-height*0.23 if n==2 else 0
        text+='\n[node name="EmissionLight" type="PointLight2D" parent="Actor"]\n'
        text+=f'position = Vector2(0, {y})\nenabled = false\ncolor = {color}\nenergy = 0.35\ntexture = ExtResource("2_light")\ntexture_scale = 1.0\nshadow_enabled = false\n'
        text=text.replace('Source overlaps, attached VFX, clipping and missing actions remain pending. Not production approval.',
                          'Unlit base pixels only. Optional native EmissionLight is separate. Playback/identity and gameplay QA pending.')
        scene.write_text(text)
        named_scene=SCENES/f'c3_collectible_itm_{n:03}_review.tscn'
        scene.rename(named_scene)
        item={'asset_id':aid,'title':title,'sources':[source_record(r,original,aid)],
              'source_recipe':recipe,'normalization':'Alpha>32 largest connected body per explicit cell plus original two-pixel antialias fringe. Source RGB/retained alpha unchanged; no scale or repainted pixels. Common per-family canvas; center pivot. Detached stones/leaves/labels/depth rows and faint canvas noise excluded.',
              'runtime_exports':exports,'production_exports':archived,
              'frame_count':len(frames),'fps':6,'timing_status':'authored review idle playback; source chat does not prove production timing',
              'canvas_size':[width,height],'pivot':pivot,'pivot_type':'center','z_index':15,
              'receives_light':True,'casts_shadows':False,'emits_light':'separate native optional PointLight2D, disabled by default',
              'collision_shape':'none inferred from sprite; author pickup interaction Area2D separately',
              'import_filter':'linear','compression':'lossless',
              'native_spriteframes':native.rel(resource),'native_spriteframes_sha256':native.sha(resource),
              'native_review_scene':native.rel(named_scene),'native_review_scene_sha256':native.sha(named_scene),
              'preview_path':native.rel(preview),'production_preview_path':str(archived_preview),
              'stage':'native base review imported; actual gameplay and final approval pending',
              'production_approved':False,'blockers':['cross-pose identity/volume/tip stability requires visual approval','pickup burst/activation families and separated source overlays not delivered as clean independent assets','actual gameplay-scale/collision/light tuning pending']}
        handoff['assets'].append(item)
    # Account for every continuation item attempt, not only selected bases.
    # Preserve raw requests while grouping by verified visible bible identity.
    actual_by_image={50:1,51:2,52:3,53:4,54:5,55:6,56:6,
                     57:6,58:6,59:6,60:6,61:6,62:6,63:6,
                     64:1,65:6,66:2,67:2,68:7,69:7,70:7,71:8,72:8,73:8}
    selected={recipe['image'] for recipe in RECIPES.values()}
    handoff['source_review']=[]
    for number,actual in actual_by_image.items():
        r=records[number];aid=f'C3-ITM-{actual:03}'
        original=LIB/aid/'source_images'/f'{aid}_archive_{Path(r["path"]).name}'
        shutil.copyfile(r['path'],original)
        record=source_record(r,original,aid)
        record['review_result']='selected unlit base subset' if number in selected else (
             'RGB checkerboard; no invented alpha export' if r['mode']=='RGB' else
             'alternate/mixed lit-body, pickup, depth or reference attempt; source retained, not a separated production effect')
        handoff['source_review'].append(record)
        item=next(a for a in handoff['assets'] if a['asset_id']==aid)
        if not any(s['path']==str(original) for s in item['sources']):item['sources'].append(record)
    output=DOCS/'collectible-asset-preparation-handoff.json';output.write_text(json.dumps(handoff,indent=2)+'\n')
    print('Prepared four native base review families:',sum(a.get('frame_count',0) for a in handoff['assets']),'full-resolution frames; all eight official IDs accounted for')


def source_record(r,original,actual):
    return {'path':str(original),'sha256':native.sha(original),'archive_path':r['path'],
            'source_message_id':r.get('source_message_id'),'source_message_index':r.get('source_message_index'),
            'source_requested_ids':r.get('requested_asset_ids',[]),'source_official_requested_ids':r.get('official_requested_asset_ids',[]),
            'verified_actual_asset_id':actual,'generated_subject_title':r.get('generated_subject_title'),
            'dimensions':r['dimensions'],'mode':r['mode'],'provenance':'unchanged original bytes supplied in user ZIP',
            'requested_vs_actual_mismatch':actual not in r.get('official_requested_asset_ids',[])}


if __name__=='__main__':main()
