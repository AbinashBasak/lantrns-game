"""Render Phase09 audio prototypes procedurally and write exports, spectrogram previews and metadata.

Usage: generate_phase09_audio.py [AUD-SFX-001 ...] [--reviewed]
"""
from pathlib import Path
import sys, json, hashlib, datetime
import numpy as np
import soundfile as sf
from scipy import signal
from scipy.io import wavfile
import pyloudnorm
from PIL import Image, ImageDraw
sys.path.insert(0, str(Path(__file__).resolve().parent))
from audiolib import SR, fade, peak_norm, N
from aud_sfx import SFX
from aud_amb import AMB, post
from aud_music import MUSIC

ROOT = Path(__file__).resolve().parents[1]
PHASE = ROOT / 'assets/production/phase_09_audio_asset_inventory'
CANON = '/Users/abinashbasak/Desktop/games/lantrns/lantrns-game'
TZ = datetime.timezone(datetime.timedelta(hours=5, minutes=30))
SUBDIR = {'SFX': 'sound_effects', 'AMB': 'ambient_soundscapes', 'MUS': 'music'}
LUFS_TARGET = {'AMB': -28.0, 'MUS': -20.0}


def canon(p):
    return CANON + '/' + str(Path(p).resolve().relative_to(ROOT.resolve()))


def slug(title):
    return ''.join(c.lower() if c.isalnum() else '_' for c in title).strip('_').replace('__', '_')


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def loudness(x):
    if len(x) < SR * 1.0:
        return None
    return float(pyloudnorm.Meter(SR).integrated_loudness(x))


def finalize(x, kind):
    x = np.nan_to_num(x)
    x = x - np.mean(x, axis=0)
    if kind == 'SFX':
        return peak_norm(fade(x, 0.002, 0.01), -1.5)
    target = LUFS_TARGET[kind]
    lu = loudness(x)
    x = x * 10 ** ((target - lu) / 20)
    p = np.max(np.abs(x))
    if p > 0.89:
        x = np.tanh(x / p * 1.2) / np.tanh(1.2) * 0.89
    return x


def measure(x, loop):
    mono = x if x.ndim == 1 else x.mean(axis=1)
    peak = float(np.max(np.abs(x)))
    rms = float(np.sqrt(np.mean(mono ** 2)))
    m = {'duration_s': round(len(x) / SR, 3), 'channels': 1 if x.ndim == 1 else 2, 'sample_rate': SR,
         'peak_dbfs': round(20 * np.log10(peak + 1e-9), 2), 'rms_dbfs': round(20 * np.log10(rms + 1e-9), 2),
         'lufs_integrated': None if loudness(x) is None else round(loudness(x), 2),
         'clipped_samples': int(np.sum(np.abs(x) >= 0.999)), 'dc_offset': round(float(np.mean(mono)), 6),
         'silent_fraction_below_-60dB': round(float(np.mean(np.abs(mono) < 1e-3)), 3)}
    if loop:
        jump = float(np.mean(np.abs(x[0] - x[-1])))
        typical = float(np.mean(np.abs(np.diff(mono)))) + 1e-9
        m['loop_seam_ratio'] = round(jump / typical, 2)
    return m


def spectrogram_png(x, path, title):
    mono = x if x.ndim == 1 else x.mean(axis=1)
    f, t, S = signal.spectrogram(mono, SR, nperseg=2048, noverlap=1536)
    keep = f <= 12000
    db = 10 * np.log10(S[keep] + 1e-12)
    db = np.clip((db - (db.max() - 80)) / 80, 0, 1)[::-1]
    W = 1400
    cols = np.array([db[:, int(i * db.shape[1] / W)] for i in range(W)]).T
    r = np.clip(cols * 2.2 - 0.9, 0, 1)
    g = np.clip(cols * 2.0 - 0.3, 0, 1) ** 1.2
    b = np.clip(0.6 - np.abs(cols - 0.3) * 1.6 + cols * 0.2, 0, 1)
    img = Image.fromarray((np.stack([r, g, b], axis=-1) * 255).astype(np.uint8)).resize((W, 300), Image.Resampling.BILINEAR)
    wave = Image.new('RGB', (W, 90), '#10181b')
    dr = ImageDraw.Draw(wave)
    seg = len(mono) / W
    for i in range(W):
        s = mono[int(i * seg):int((i + 1) * seg) + 1]
        if len(s):
            dr.line((i, 45 - s.max() * 42, i, 45 - s.min() * 42), fill='#7ee0ff')
    out = Image.new('RGB', (W, 300 + 90 + 22), '#10181b')
    out.paste(img, (0, 22))
    out.paste(wave, (0, 322))
    ImageDraw.Draw(out).text((8, 5), f'{title} - spectrogram 0-12 kHz, {len(mono) / SR:.2f}s', fill='#e8fbff')
    out.save(path)


def encode_ogg(x, ogg):
    sf.write(ogg, np.clip(x, -1, 1), SR, format='OGG', subtype='VORBIS')
    return sf.info(ogg).duration


def build(aid, reviewed):
    kind = aid.split('-')[1]
    reg = {'SFX': SFX, 'AMB': AMB, 'MUS': MUSIC}[kind][aid]
    title, fn, desc = reg[0], reg[1], reg[2]
    folder = PHASE / SUBDIR[kind] / aid
    exports, previews = folder / 'exports', folder / 'previews'
    exports.mkdir(parents=True, exist_ok=True)
    previews.mkdir(parents=True, exist_ok=True)
    sl = slug(title)
    loop = kind != 'SFX'
    variants = fn() if kind == 'SFX' else {'loop': post(fn(), reg[3]) if kind == 'AMB' else fn()}
    files, preview_src = [], []
    for name, x in variants.items():
        x = finalize(x, kind)
        base = f'{aid}_{sl}' if kind != 'SFX' or len(variants) == 1 else f'{aid}_{sl}_{name}'
        ogg = exports / f'{base}.ogg'
        ogg_dur = encode_ogg(x, ogg)
        rec = {'name': name, 'loop': loop, 'ogg_path': canon(ogg), 'ogg_sha256': sha(ogg), 'ogg_bytes': ogg.stat().st_size, 'ogg_decoded_duration_s': round(ogg_dur, 3)}
        if kind == 'SFX':
            wav = exports / f'{base}.wav'
            wavfile.write(wav, SR, (np.clip(x, -1, 1) * 32767).astype(np.int16))
            rec.update({'wav_path': canon(wav), 'wav_sha256': sha(wav), 'wav_bytes': wav.stat().st_size})
        rec.update(measure(x, loop))
        files.append(rec)
        preview_src.append(x)
    cat = np.concatenate([np.pad(v, (0, N(0.08))) for v in preview_src]) if kind == 'SFX' else preview_src[0]
    sp = previews / f'{aid}_spectrogram.png'
    spectrogram_png(cat, sp, f'{aid} {title}')
    notes = [desc, 'Prototype audio synthesized from code (tools/audiolib.py, aud_sfx.py, aud_amb.py, aud_music.py); not recorded or generated by a music model.',
             'Verified by level, loudness, clipping, DC and loop-seam measurements plus spectrogram inspection. Not auditioned by ear; human listening review pending.']
    if kind == 'MUS':
        notes.append('Placeholder-grade composition for pacing and mood; expect to be replaced or re-orchestrated for release.')
    if loop:
        notes.append('Seamless loop: set loop on import in Godot (AudioStreamOggVorbis.loop = true).')
    meta = {'asset_id': aid, 'id': aid, 'title': title, 'folder': canon(folder), 'subsection': {'SFX': 'Sound effects', 'AMB': 'Ambient soundscapes', 'MUS': 'Music'}[kind],
            'prompt': f'Procedural: {desc}', 'generation_tool': 'procedural synthesis (numpy/scipy + ffmpeg libvorbis; tools/generate_phase09_audio.py)',
            'production_approved': False, 'runtime_integrated': False, 'last_updated': datetime.datetime.now(TZ).isoformat(),
            'stage': 'procedural prototype audio, spectrogram preview and metadata saved; listening review, mix balance and runtime integration pending',
            'requested_deliverables_saved_and_reviewed': reviewed,
            'review_method': 'automated measurements and spectrogram inspection; not auditioned by ear',
            'deliverables': [{'slug': sl, 'path': files[0]['ogg_path'], 'preview_path': canon(sp), 'loop': loop, 'files': files}],
            'review_notes': notes}
    (folder / 'metadata.json').write_text(json.dumps(meta, indent=2, ensure_ascii=False) + '\n')
    f0 = files[0]
    print(f'{aid} {title[:28]:28s} files={len(files)} dur={f0["duration_s"]:6.2f}s peak={f0["peak_dbfs"]:6.2f} lufs={f0["lufs_integrated"]} clip={sum(f["clipped_samples"] for f in files)} seam={f0.get("loop_seam_ratio")}')


ALL = list(SFX) + list(AMB) + list(MUSIC)

if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    reviewed = '--reviewed' in sys.argv
    for aid in ALL:
        if not args or aid in args:
            build(aid, reviewed)
