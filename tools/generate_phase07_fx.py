"""Render Phase07 visual-effect prototypes procedurally and write exports, previews and metadata.

Usage: generate_phase07_fx.py [FX-001 ...] [--reviewed]
"""
from pathlib import Path
import sys, json, hashlib, datetime
from PIL import Image, ImageDraw
sys.path.insert(0, str(Path(__file__).resolve().parent))
from fx_effects import EFFECTS

ROOT = Path(__file__).resolve().parents[1]
PHASE = ROOT / 'assets/production/phase_07_visual_effects'
CANON = '/Users/abinashbasak/Desktop/games/lantrns/lantrns-game'
TZ = datetime.timezone(datetime.timedelta(hours=5, minutes=30))


def canon(p):
    return CANON + '/' + str(Path(p).resolve().relative_to(ROOT.resolve()))


def record(p, role):
    p = Path(p)
    im = Image.open(p)
    return {'path': canon(p), 'role': role, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest(), 'bytes': p.stat().st_size,
            'dimensions': list(im.size), 'mode': im.mode, 'alpha_extrema': list(im.getchannel('A').getextrema()) if 'A' in im.getbands() else None}


def checker(im, dark, max_w=1600):
    im = im.convert('RGBA')
    if im.width > max_w:
        im = im.resize((max_w, round(im.height * max_w / im.width)), Image.Resampling.LANCZOS)
    bg = Image.new('RGBA', im.size, '#1c2a2e' if dark else '#eeeeee')
    dr = ImageDraw.Draw(bg)
    for y in range(0, im.height, 16):
        for x in range(0, im.width, 16):
            if (x // 16 + y // 16) % 2:
                dr.rectangle((x, y, x + 15, y + 15), fill='#26383d' if dark else '#d4d4d4')
    bg.alpha_composite(im)
    return bg.convert('RGB')


def build(spec, reviewed):
    aid, (w, h), n, cols = spec['id'], spec['size'], spec['frames'], spec['cols']
    rows = -(-n // cols)
    folder = PHASE / aid
    dirs = {k: folder / k for k in ('source_images', 'exports', 'previews')}
    for d in dirs.values():
        d.mkdir(parents=True, exist_ok=True)
    frames = [spec['render'](i, n) for i in range(n)]
    sheet = Image.new('RGBA', (cols * w, rows * h))
    paths = []
    for i, fr in enumerate(frames):
        assert fr.size == (w, h), (aid, i, fr.size)
        sheet.alpha_composite(fr, ((i % cols) * w, (i // cols) * h))
        p = dirs['exports'] / f'{aid}_{spec["slug"]}_{i:02d}.png'
        fr.save(p)
        paths.append(p)
    src = dirs['source_images'] / f'{aid}_{spec["slug"]}_procedural_sheet.png'
    sheet.save(src)
    sheet_path = dirs['exports'] / f'{aid}_{spec["slug"]}_sheet.png'
    sheet.save(sheet_path)
    data = {'asset_id': aid, 'cell_size': [w, h], 'columns': cols, 'rows': rows, 'frame_count': n, 'fps': spec['fps'], 'loop': spec['loop'],
            'pivot_px': list(spec['pivot']), 'sequences': {k: {'first': v[0], 'last': v[1]} for k, v in spec['sequences'].items()}, 'sheet': sheet_path.name}
    (dirs['exports'] / f'{aid}_{spec["slug"]}_frames.json').write_text(json.dumps(data, indent=2) + '\n')
    pv = []
    for dark in (False, True):
        p = dirs['previews'] / f'{aid}_contact_{"dark" if dark else "light"}.png'
        checker(sheet, dark).save(p)
        pv.append(p)
    dk = [checker(f, True, 4096).convert('P', palette=Image.Palette.ADAPTIVE) for f in frames]
    gif = dirs['previews'] / f'{aid}_{spec["slug"]}_preview.gif'
    dk[0].save(gif, save_all=True, append_images=dk[1:], duration=round(1000 / spec['fps']), loop=0, disposal=2)
    pv.append(gif)
    now = datetime.datetime.now(TZ).isoformat()
    exports = paths + [sheet_path, dirs['exports'] / f'{aid}_{spec["slug"]}_frames.json']
    meta = {
        'asset_id': aid, 'id': aid, 'title': spec['title'], 'folder': canon(folder),
        'prompt': f'Procedural: {spec["title"]} rendered by tools/fx_effects.py ({spec["render"].__name__}) with the ART-002 VFX palette; no generative image model used.',
        'generation_tool': 'procedural (Pillow + numpy; tools/generate_phase07_fx.py)', 'production_approved': False, 'runtime_integrated': False,
        'last_updated': now, 'stage': 'procedural prototype frames, previews and metadata saved; art direction review, in-engine timing and runtime integration pending',
        'requested_deliverables_saved_and_reviewed': reviewed,
        'deliverables': [{
            'slug': spec['slug'], 'path': canon(src), 'frame_count': n, 'cols': cols, 'rows': rows, 'roles': [f'frame_{i:02d}' for i in range(n)],
            'sequences': data['sequences'], 'export_cell_dimensions': [w, h], 'pivot_px': list(spec['pivot']), 'timing': {'fps': spec['fps']}, 'loop': spec['loop'],
            'provenance': 'procedural render; deterministic (fixed RNG seeds), no external source image',
            'export_paths': [canon(p) for p in exports], 'preview_paths': [canon(p) for p in pv],
            'source_file': record(src, 'procedural sheet'),
            'export_files': [record(p, 'frame png') for p in paths] + [record(sheet_path, 'sheet png')],
        }],
        'review_notes': spec['notes'] + ['Prototype effect art for timing and readability; not final production approval.', 'No Godot scene, AnimatedSprite2D, particle or shader integration implied.'],
    }
    (folder / 'metadata.json').write_text(json.dumps(meta, indent=2, ensure_ascii=False) + '\n')
    print(aid, f'{n} frames {w}x{h}', f'{sum(p.stat().st_size for p in exports) // 1024} KiB exports')


if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    reviewed = '--reviewed' in sys.argv
    for s in EFFECTS:
        if not args or s['id'] in args:
            build(s, reviewed)
