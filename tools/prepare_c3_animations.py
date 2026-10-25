#!/usr/bin/env python3
"""Recover exact-alpha enemy poses for native Godot diagnostic review.

Requires Pillow, numpy, scipy. No art generation, resampling, background synthesis,
or fabricated intermediate frames. Review exports are deliberately not gameplay
approval: source overlaps, attached VFX, missing families and design drift remain
explicit in the JSON handoff. Run from any directory.
"""
from pathlib import Path
import hashlib
import json
import math
import shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy.ndimage import label, find_objects, distance_transform_edt

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / 'assets/production/source_archives/chat_export_6add021c/metadata.json'
DOCS = ROOT / 'docs/chapter03'
ART = ROOT / 'art/enemies/chapter_03'
RES = ROOT / 'resources/chapter_03/animations/enemies'
SCENES = ROOT / 'scenes/enemies/chapter_03/review'
LIBRARY = ROOT / 'assets/production/chapter_03_sunken_temple/enemies'


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rel(p):
    return str(Path(p).relative_to(ROOT))


def uri(p):
    return 'res://' + rel(p)


def components(path):
    im = Image.open(path).convert('RGBA')
    arr = np.array(im)
    labs, _ = label(arr[:, :, 3] > 16)
    sizes = np.bincount(labs.ravel())
    boxes = find_objects(labs)
    # The body must be substantial. Small detached particles are assigned to the
    # nearest substantial source component; no source pixels are repainted.
    found = []
    for k, sl in enumerate(boxes, 1):
        if sizes[k] >= 25000:
            found.append({'label': k, 'pixels': int(sizes[k]),
                          'box': [sl[1].start, sl[0].start, sl[1].stop, sl[0].stop]})
    seed = np.zeros(labs.shape, dtype=np.int32)
    for i, item in enumerate(found, 1):
        seed[labs == item['label']] = i
        item['cluster'] = i
    distance, nearest = distance_transform_edt(seed == 0, return_indices=True)
    assigned = seed[tuple(nearest)]
    return im, arr, found, assigned, distance


def spec(asset, action, image, row='all', expected=None, skip=(), note='', fps=8, loop=False):
    return dict(asset=asset, action=action, image=image, row=row,
                expected=expected, skip=list(skip), note=note, fps=fps, loop=loop)


# Counts below are visible delivered poses, not prompt claims. 'skip' removes
# merged components, indexed left-to-right within that row; they remain in the
# unchanged source and component map for manual cleanup.
SPECS = [
    spec(4,'idle',2,expected=5,loop=True,fps=6),
    spec(4,'walk',4,expected=6,loop=True),
    spec(4,'shield',5,expected=4),
    spec(4,'windup',6,expected=4),
    spec(4,'slam_partial',7,expected=6,skip=(3,),note='Impact and neighboring pose touch into one connected component; excluded. No isolated ground shockwave supplied.'),
    spec(4,'recover',8,expected=4),
    spec(4,'hurt',9,expected=3),
    spec(4,'death',10,expected=8,note='Eight source poses, top row then bottom row. Attached dissolve particles require separate VFX cleanup.'),
    spec(5,'idle_swim',11,expected=6,loop=True),
    spec(5,'hide',13,expected=6,note='Six visible burrowing stages. Disconnected gravel remains in source, not reconstructed as a separate effect.'),
    spec(5,'telegraph',15,expected=4,note='Attached cyan charge accents; no dynamic light halo is added.'),
    spec(5,'lunge_partial',12,expected=5,skip=(2,),note='Middle lunge and trail poses touch; excluded, leaving an incomplete diagnostic sequence.'),
    spec(5,'retreat',14,expected=4),
    spec(7,'intro',24,expected=6,note='Source includes attached water rings; cleanup needed before runtime use.'),
    spec(7,'idle',25,expected=6,loop=True,fps=6),
    spec(7,'walk_partial',29,expected=8,skip=(0,5),note='Two pairs of adjacent walk poses merge; four isolated middle poses recovered.'),
    spec(7,'shield_raise',26,expected=5,note='Shield glow is attached to body. Dynamic shield lighting remains separate.'),
    spec(7,'slam_windup',27,expected=5,note='Generated windup includes large sword arcs contrary to requested character-only art. Diagnostic only.'),
    spec(7,'recover',30,expected=4),
    spec(7,'hurt',31,expected=4),
    spec(7,'stagger_partial',33,expected=5,skip=(2,),note='Two central stagger poses touch; merged region excluded.'),
    spec(7,'defeat_partial',34,row='bottom',expected=8,skip=(3,),note='Source contradicts its prompt: top is five labeled stagger poses, bottom is eight death poses. Text and divider excluded; last five death poses merge. First three isolated death poses only.'),
    spec(8,'intro',35,row='top',expected=5,note='Five delivered intro poses rather than six requested. Attached effects; mixed sheet split by family.'),
    spec(8,'idle',35,row='bottom',expected=6,loop=True,fps=6),
    spec(8,'dash_windup',37,row='top',expected=5,note='Five delivered windup poses; supplemental source, no explicit prompt mapping. Rightmost pose reaches source edge.'),
    spec(8,'dash_partial',36,row='bottom',expected=6,note='Six delivered dash poses instead of five requested; trail is attached and rightmost pose reaches source edge.'),
    spec(8,'bubble_summon',38,row='top',expected=6,note='Six delivered poses rather than five requested. Detached bubbles remain in original; separate projectile art required.'),
    spec(8,'water_column_telegraph_partial',38,row='bottom',expected=6,skip=(3,),note='Source mixes warning with full water-column attack and two columns touch. Kept isolated body poses for diagnosis; no damaging column scene inferred.'),
    spec(8,'seal_beam_telegraph',39,row='top',expected=6,note='Six delivered poses rather than five requested. Attached charge accents remain cleanup work.'),
    spec(8,'seal_beam_partial',39,row='bottom',expected=6,skip=(4,),note='Beam-bearing final poses touch; omitted. Remaining four are diagnostic charge/aim poses only, no separated active beam.'),
    spec(8,'core_exposed',41,row='top',expected=6,note='Six delivered core poses instead of five requested.'),
    spec(8,'phase_change',41,row='bottom',expected=6,note='Attached rising water must be separated from body before gameplay approval.'),
    spec(8,'hurt',42,row='top',expected=6,note='Six delivered hurt poses rather than four requested.'),
    spec(8,'defeat_partial',42,row='bottom',expected=6,skip=(1,2),note='Six visible dissolve stages rather than ten requested. Touching dissolve regions omitted; incomplete defeat.'),
]

MISSING = {
    1: ['clean matching idle','turn','notice','hop_attack','knockback'],
    2: ['patrol','aim','clean complete projectile body sequence','clean hurt','clean death'],
    3: ['walk','swim','windup','swing','recover','death; existing glide/cast artwork conflicts with bible'],
    4: ['notice','clean complete slam','separate shockwave'],
    5: ['hurt','death','clean complete lunge','separate lunge trail'],
    6: ['all canonical staff-bearing Warden families; continuation is a jellyfish substitution'],
    7: ['clean complete walk','clean slam','phase_change','clean complete stagger','clean complete defeat','separate shockwave'],
    8: ['walk_or_float','trident_sweep_windup','trident_sweep','clean dash','water_column_attack','clean seal_beam','stagger','clean complete defeat','separate attack/projectile effects'],
}


def main():
    for p in [DOCS, ART, RES, SCENES]:
        p.mkdir(parents=True, exist_ok=True)
    archive = json.loads(ARCHIVE.read_text())
    originals = {int(Path(r['path']).name.split('-')[1]): r for r in archive['image_records'] if Path(r['path']).name.startswith('image-')}
    specs = list(SPECS)
    source_cache = {}
    # Earlier archive: use compatible mite ground poses and wisp hover only.
    # Opaque checkerboards/black fills and incompatible Keeper glide/cast stay
    # archived, not silently keyed out or relabeled as canonical actions.
    for asset, actions in [(1, ['walk','hurt','death']), (2, ['hover'])]:
        meta = json.loads((LIBRARY / f'C3-ENM-{asset:03}/metadata.json').read_text())
        for action in actions:
            source = next(r for r in meta['sources'] if r['action'] == action)
            key = f'old_{asset}_{action}'
            originals[key] = source
            specs.insert(0, spec(asset, action, key, expected=6,
                                 loop=action in ['walk','hover'],
                                 note='Earlier recovered original. Native review only; edge clipping and source design consistency remain unapproved.'))
    wisp_meta=json.loads((LIBRARY/'C3-ENM-002/metadata.json').read_text())
    originals['old_2_attack']=next(s for s in wisp_meta['sources'] if s['action']=='attack')
    specs.extend([
        spec(2,'charge','old_2_attack',expected=3,skip=(3,4,5),
             note='Three distinct source charge poses isolated from mixed attack strip. Separate bolt is exported independently.'),
        spec(2,'projectile_body_partial','old_2_attack',expected=2,skip=(0,1,2,4),
             note='Two source body fire/recover poses. Attached launch accents remain cleanup work; standalone bolt is independent.')])
    handoff = {'schema':1, 'kind':'deterministic derived enemy animation review exports',
               'governing_bible':rel(ROOT/'lanterns_underroot_chapter_3_production_bible.md'),
               'source_archive':rel(ARCHIVE), 'production_approved':False,
               'policy':'No generated art, resampling, reconstructed pixels, or invented action frames. Unchanged original sources remain in registered production folders.',
               'assets':[], 'clips':[], 'excluded_sources':[]}
    per_asset = {}
    for entry in specs:
        source = originals[entry['image']]
        path = source.get('registered_source_path', source['path'])
        if path not in source_cache:
            source_cache[path] = components(path)
        im, arr, comps, assigned, distance = source_cache[path]
        row = entry['row']
        candidates = list(comps)
        midpoint = im.height/2
        if row == 'top':
            candidates = [c for c in comps if (c['box'][1]+c['box'][3])/2 < midpoint]
        elif row == 'bottom':
            candidates = [c for c in comps if (c['box'][1]+c['box'][3])/2 > midpoint]
        if entry['image'] == 10:
            candidates.sort(key=lambda c: (int((c['box'][1]+c['box'][3])/2 > midpoint), c['box'][0]))
        else:
            candidates.sort(key=lambda c:c['box'][0])
        # Text/dividers on source 34 must never become art.
        candidates = [c for c in candidates if c['box'][3]-c['box'][1]>70]
        kept = [(i,c) for i,c in enumerate(candidates) if i not in entry['skip']]
        frames = []
        source_edges = []
        for i, c in kept:
            pix = np.array(arr, copy=True)
            # Keep the chosen opaque component and its native two-pixel
            # antialias fringe. Faint whole-canvas noise and disconnected
            # particles must not determine an actor's foot pivot. Their source
            # pixels remain unchanged in the original, not repainted as VFX.
            pix[(assigned != c['cluster']) | (distance > 2.0)] = 0
            pose = Image.fromarray(pix)
            box = pose.getbbox()
            if box is None:
                continue
            frames.append((pose.crop(box),box,i))
            source_edges.append(box[0]<=1 or box[1]<=1 or box[2]>=im.width-1 or box[3]>=im.height-1)
        if not frames:
            continue
        record = dict(entry)
        record.update(asset_id=f"C3-ENM-{entry['asset']:03}",
                      source_path=path, source_sha256=sha(path),
                      source_dimensions=list(im.size),
                      source_message_id=source.get('source_message_id'),
                      source_message_index=source.get('source_message_index'),
                      source_pointer=source.get('source_pointer'),
                      source_visual_poses=entry['expected'],
                      recovered_frames=len(frames),
                      full_family_recovered=len(frames)==entry['expected'] and not entry['action'].endswith('_partial'),
                      source_component_map=candidates,
                      source_component_indices=[f[2] for f in frames],
                      source_crop_bounds=[f[1] for f in frames],
                      touches_source_edge=any(source_edges),
                      production_approved=False,
                      stage='native diagnostic review; source cleanup and gameplay approval pending',
                      receives_light=True, casts_shadows=False, emits_light=False,
                      collision_shape='none in art review; gameplay body/hurtbox/attack areas must be authored separately',
                      z_index=10, import_filter='linear',compression='lossless',
                      timing_status='authored review playback only; combat timing not approved')
        record['_frames'] = frames
        per_asset.setdefault(entry['asset'],[]).append(record)
    for asset, clips in sorted(per_asset.items()):
        aid=f'C3-ENM-{asset:03}'
        clips.sort(key=lambda c: (0 if c['action'] in ['idle','idle_swim','hover','walk'] else 1))
        # One full-resolution canvas shared by every action of this enemy.
        width=max(f[0].width for c in clips for f in c['_frames'])+32
        height=max(f[0].height for c in clips for f in c['_frames'])+32
        width += width%2
        height += height%2
        floating=asset in (2,5)
        pivot=[width//2,height//2] if floating else [width//2,height-16]
        artdir=ART/aid.lower().replace('-','_')
        artdir.mkdir(parents=True,exist_ok=True)
        for c in clips:
            action=c['action']
            outdir=artdir/action
            outdir.mkdir(parents=True,exist_ok=True)
            paths=[]
            for j,(pose,box,compindex) in enumerate(c.pop('_frames')):
                canvas=Image.new('RGBA',(width,height))
                y=(height-pose.height)//2 if floating else height-16-pose.height
                canvas.paste(pose,((width-pose.width)//2,y))
                out=outdir/f'{aid}_{action}_{j:02}.png'
                canvas.save(out)
                paths.append({'path':rel(out),'sha256':sha(out),'dimensions':[width,height],
                              'visible_bounds':list(canvas.getbbox()),'source_crop_bounds':box,
                              'source_component_index':compindex})
            c.update(exports=paths,canvas_size=[width,height],pivot=pivot,
                     pivot_type='center' if floating else 'bottom_center',
                     normalization='Exact source RGBA pixels from the selected alpha>16 connected component plus its native two-pixel antialias fringe; disconnected particles and faint canvas noise excluded. Transparent padding only; no resize or painted pixels. Each isolated pose centered horizontally; shared bottom baseline for ground actors. Floating actors use center pivot.',
                     qa_pending=['identity/volume continuity across independent source sheets',
                                 'attached highlights and attack VFX separation',
                                 'playback timing and gameplay-scale silhouettes',
                                 'source clipping correction where flagged',
                                 'missing canonical families'])
            contact=Image.new('RGBA',(240*min(len(paths),4),270*math.ceil(len(paths)/4)),(19,38,44,255))
            draw=ImageDraw.Draw(contact)
            for j,p in enumerate(paths):
                thumb=Image.open(ROOT/p['path']);thumb.thumbnail((224,238))
                x=(j%4)*240+(240-thumb.width)//2;y=(j//4)*270+20
                contact.alpha_composite(thumb,(x,y));draw.text(((j%4)*240+8,(j//4)*270+4),f'{action} {j+1}',fill='white')
            preview=DOCS/f'animation-asset-preparation-{aid.lower()}-{action}.png'
            contact.save(preview);c['preview_path']=rel(preview)
            # Keep the production archive and the imported native review copy
            # distinct. Only this derived version is written; prior generations
            # and unchanged source_images are never replaced.
            production_dir=LIBRARY/aid/'exports/native_animation_review_v1'/action
            production_dir.mkdir(parents=True,exist_ok=True)
            archived=[]
            for exported in paths:
                archived_path=production_dir/Path(exported['path']).name
                shutil.copyfile(ROOT/exported['path'],archived_path)
                archived.append({'path':str(archived_path),'sha256':sha(archived_path),
                                 'runtime_review_copy':exported['path']})
            preview_dir=LIBRARY/aid/'previews/native_animation_review_v1'
            preview_dir.mkdir(parents=True,exist_ok=True)
            archived_preview=preview_dir/f'{aid}_{action}_review.png'
            shutil.copyfile(preview,archived_preview)
            c['production_exports']=archived
            c['production_preview_path']=str(archived_preview)
            handoff['clips'].append(c)
        frame_res=write_spriteframes(aid,clips)
        scene=write_scene(aid,clips,frame_res,width,height,pivot)
        handoff['assets'].append({'asset_id':aid,'native_spriteframes':rel(frame_res),
                                  'native_review_scene':rel(scene),'native_review_scene_sha256':sha(scene),
                                  'native_spriteframes_sha256':sha(frame_res),'canvas_size':[width,height],
                                  'pivot':pivot,'missing_or_blocked':MISSING[asset],
                                  'production_approved':False})
    for asset in (3,6):
        handoff['assets'].append({'asset_id':f'C3-ENM-{asset:03}',
                                  'missing_or_blocked':MISSING[asset],
                                  'stage':'sources retained; incompatible design/mechanics, no canonical runtime exports',
                                  'production_approved':False})
    for n in [1,3,16,17,18,19,20,21,22,23,28,32,40,43,44,45]:
        r=originals[n]
        reason=('explicitly rejected wrong subject' if n in [1,3] else
                'jellyfish substitution lacks canonical Warden staff/ground actions' if 16<=n<=23 else
                'all slam poses merge; no safe isolated complete frames' if n==28 else
                'opaque baked checkerboard; do not key out or invent alpha' if n in [32,40] else
                'chest source belongs to chest/collectible workflow' if n==43 else
                'optional or generic noncanonical action/concept; no canonical mechanic substituted')
        handoff['excluded_sources'].append({'source_path':r.get('registered_source_path',r['path']),
                                             'sha256':r['sha256'],'reason':reason,
                                             'source_message_id':r.get('source_message_id')})
    source=originals['old_2_attack']
    im,arr,comps,assigned,distance=source_cache[source['path']]
    bolt=sorted(comps,key=lambda c:c['box'][0])[4]
    pix=np.array(arr,copy=True)
    pix[(assigned!=bolt['cluster']) | (distance>2.0)]=0
    bolt_image=Image.fromarray(pix)
    bounds=bolt_image.getbbox()
    bolt_image=bolt_image.crop(bounds)
    bolt_dir=ART/'c3_enm_prj_001'
    bolt_dir.mkdir(exist_ok=True)
    bolt_path=bolt_dir/'C3-ENM-PRJ-001_crystal_wisp_bolt_review.png'
    bolt_image.save(bolt_path)
    archived_dir=LIBRARY/'C3-ENM-PRJ-001/exports/native_animation_review_v1'
    archived_dir.mkdir(parents=True,exist_ok=True)
    archived_bolt=archived_dir/bolt_path.name
    shutil.copyfile(bolt_path,archived_bolt)
    handoff['standalone_projectiles']=[{
        'asset_id':'C3-ENM-PRJ-001','path':rel(bolt_path),
        'sha256':sha(bolt_path),'production_export':str(archived_bolt),
        'source_path':source['path'],'source_sha256':sha(source['path']),
        'source_message_id':source.get('source_message_id'),
        'source_crop_bounds':bounds,'dimensions':list(bolt_image.size),
        'frame_count':1,'fps':None,'pivot_type':'center',
        'pivot':[bolt_image.width//2,bolt_image.height//2],
        'z_index':15,'receives_light':True,'casts_shadows':False,
        'emits_light':False,'collision_shape':'none inferred; explicit projectile hitbox required',
        'normalization':'Exact source RGBA pixels of the independent fifth component plus native antialias fringe. No resize.',
        'stage':'isolated review export; dynamic lighting, native projectile scene and gameplay QA pending',
        'production_approved':False}]
    output=DOCS/'animation-asset-preparation-handoff.json'
    output.write_text(json.dumps(handoff,indent=2)+'\n')
    print(f'{len(handoff["clips"])} diagnostic clips, {sum(c["recovered_frames"] for c in handoff["clips"])} exact-pixel poses, {len(per_asset)} native enemy reviews')


def write_spriteframes(aid,clips):
    lines=['[gd_resource type="SpriteFrames" load_steps=%d format=3]'%(1+sum(len(c['exports']) for c in clips)),'']
    k=0
    for c in clips:
        for p in c['exports']:
            k+=1
            lines.append(f'[ext_resource type="Texture2D" path="res://{p["path"]}" id="{k}"]')
    lines+=['','[resource]','animations = [']
    k=0
    for c in clips:
        frames=[]
        for _ in c['exports']:
            k+=1;frames.append('{"duration": 1.0, "texture": ExtResource("%d")}'%k)
        lines+=['{','"frames": ['+', '.join(frames)+'],',
                '"loop": '+str(c['loop']).lower()+',',f'"name": &"{c["action"]}",',
                f'"speed": {float(c["fps"])}','},']
    lines+= [']','']
    p=RES/f'{aid.lower().replace("-","_")}_review.tres';p.write_text('\n'.join(lines));return p


def write_scene(aid,clips,frame_res,width,height,pivot):
    count=len(clips)
    lines=[f'[gd_scene load_steps={5+count*2+2*(count-1)} format=3]',
           f'[ext_resource type="SpriteFrames" path="{uri(frame_res)}" id="1"]','']
    animations=[]
    for i,c in enumerate(clips):
        action=c['action'];frames=len(c['exports']);fps=c['fps'];length=frames/fps
        animations.append(f'&"{action}": SubResource("Anim_{i}")')
        lines += [f'[sub_resource type="Animation" id="Anim_{i}"]',f'resource_name = "{action}"',f'length = {length}',
                  f'loop_mode = {1 if c["loop"] else 0}',
                  'tracks/0/type = "value"','tracks/0/imported = false','tracks/0/enabled = true',
                  'tracks/0/path = NodePath("Sprite:animation")','tracks/0/interp = 1',
                  'tracks/0/keys = {"times": PackedFloat32Array(0), "transitions": PackedFloat32Array(1), "update": 1, "values": [&"'+action+'"]}',
                  'tracks/1/type = "value"','tracks/1/imported = false','tracks/1/enabled = true',
                  'tracks/1/path = NodePath("Sprite:frame")','tracks/1/interp = 1',
                  'tracks/1/keys = {"times": PackedFloat32Array('+', '.join(str(round(j/fps,6)) for j in range(frames))+'), "transitions": PackedFloat32Array('+', '.join('1' for _ in range(frames))+'), "update": 1, "values": ['+', '.join(str(j) for j in range(frames))+']}',
                  '',f'[sub_resource type="AnimationNodeAnimation" id="State_{i}"]',f'animation = &"{action}"','']
    lines += ['[sub_resource type="AnimationNodeStateMachineTransition" id="StartTransition"]','advance_mode = 2','']
    hub=clips[0]['action']
    transitions=[f'"Start", "{hub}", SubResource("StartTransition")']
    for i,c in enumerate(clips[1:],1):
        # Enabled transitions allow playback.travel() through an actual graph.
        # One-shots return at their authored end; loops remain active until an
        # explicit travel request. Partial source clips retain their own names.
        lines += [f'[sub_resource type="AnimationNodeStateMachineTransition" id="To_{i}"]',
                  'advance_mode = 1','switch_mode = 0','reset = true','',
                  f'[sub_resource type="AnimationNodeStateMachineTransition" id="Return_{i}"]',
                  f'advance_mode = {1 if c["loop"] else 2}',
                  f'switch_mode = {0 if c["loop"] else 2}','reset = true','']
        transitions += [f'"{hub}", "{c["action"]}", SubResource("To_{i}")',
                        f'"{c["action"]}", "{hub}", SubResource("Return_{i}")']
    lines += ['[sub_resource type="AnimationLibrary" id="Library"]','_data = {'+', '.join(animations)+'}','',
              '[sub_resource type="AnimationNodeStateMachine" id="States"]']
    for i,c in enumerate(clips):
        lines += [f'states/{c["action"]}/node = SubResource("State_{i}")',f'states/{c["action"]}/position = Vector2({260+(i%4)*200}, {100+(i//4)*130})']
    lines+=['states/Start/position = Vector2(60, 100)', 'transitions = ['+', '.join(transitions)+']','',
            f'[node name="{aid.replace("-", "")}AnimationReview" type="Node2D"]',
            'metadata/production_approved = false',
            'metadata/purpose = "Source diagnostic review. All available states are reachable through native AnimationTree playback.travel(). One-shots return at their authored end; partial actions remain partial. No combat logic or hitboxes are inferred."','',
            '[node name="Backdrop" type="Polygon2D" parent="."]',
            'polygon = PackedVector2Array(0, 0, 1280, 0, 1280, 720, 0, 720)',
            'color = Color(0.035, 0.14, 0.169, 1)','',
            '[node name="Title" type="Label" parent="."]','position = Vector2(32, 24)',
            f'text = "{aid} | exact source pixels | diagnostic animation review"','',
            '[node name="Status" type="Label" parent="."]','position = Vector2(32, 64)',
            'text = "Source overlaps, attached VFX, clipping and missing actions remain pending. Not production approval."','',
            '[node name="Baseline" type="Line2D" parent="."]',
            'points = PackedVector2Array(160, 610, 1120, 610)','width = 1.0','default_color = Color(0.3, 0.5, 0.5, 1)','',
            '[node name="Actor" type="Node2D" parent="."]',f'position = Vector2(640, {420 if aid in ["C3-ENM-002","C3-ENM-005"] else 610})',
            f'scale = Vector2({min(0.8,450/height)}, {min(0.8,450/height)})','',
            '[node name="Sprite" type="AnimatedSprite2D" parent="Actor"]',
            'sprite_frames = ExtResource("1")',f'animation = &"{clips[0]["action"]}"',
            'centered = false',f'offset = Vector2({-pivot[0]}, {-pivot[1]})',
            'texture_filter = 2','',
            '[node name="AnimationPlayer" type="AnimationPlayer" parent="Actor"]',
            'libraries = {&"": SubResource("Library")}','',
            '[node name="AnimationTree" type="AnimationTree" parent="Actor"]',
            'tree_root = SubResource("States")','anim_player = NodePath("../AnimationPlayer")',
            'active = true','',
            '[node name="AvailableActions" type="Label" parent="."]','position = Vector2(32, 660)',
            'text = "'+', '.join(c['action'] for c in clips)+'"','']
    p=SCENES/f'{aid.lower().replace("-","_")}_animation_review.tscn';p.write_text('\n'.join(lines));return p


if __name__=='__main__':
    main()
