"""Phase 09 ambient soundscapes: seamless 30 s stereo loops."""
import numpy as np
from audiolib import *
from aud_sfx import bell, thump

DUR = 30.0
L = N(DUR)
XF = N(2.0)
PENT = [0, 2, 4, 7, 9]


def bed(kind, rng, f=None, lo=None, hi=None, gain=1.0, lfo=None, stereo=True):
    n = L + XF
    chans = []
    for _ in range(2 if stereo else 1):
        x = {'pink': pink, 'brown': brown, 'white': white}[kind](n, rng)
        if kind == 'white':
            x = x / 4
        if f:
            x = lp(x, f)
        if lo and hi:
            x = bp(x, lo, hi)
        elif lo:
            x = hp(x, lo)
        if lfo:
            rate, depth = lfo
            x = x * (1 - depth + depth * (0.5 + 0.5 * np.sin(2 * np.pi * rate * tt(n) + rng.uniform(0, 6.28))))
        x = x / (np.std(x) + 1e-9) * 0.2 * gain
        chans.append(x)
    s = np.stack(chans, axis=1) if stereo else np.stack([chans[0]] * 2, axis=1)
    return loopify(s, L, XF)


def mix_events(buf, events, wrap=True):
    for sig, start, gain, p in events:
        add(buf, pan(sig, p) if sig.ndim == 1 else sig, start, gain, wrap)
    return buf


def chirp(f0, f1, dur, rng, fm=0, am=0, shape=1.0):
    n = N(dur)
    t = tt(n)
    f = glide(f0, f1, n, 'lin') * (1 + 0.03 * np.sin(2 * np.pi * fm * t) if fm else 1)
    x = np.sin(2 * np.pi * np.cumsum(f) / SR) + 0.2 * np.sin(4 * np.pi * np.cumsum(f) / SR)
    env = np.sin(np.pi * np.clip(t / dur, 0, 1)) ** shape
    if am:
        env = env * (0.6 + 0.4 * np.sin(2 * np.pi * am * t))
    return x * env


def amb001():
    r = np.random.default_rng(1001)
    buf = bed('pink', r, f=700, gain=0.8, lfo=(0.06, 0.6))
    buf += 0.35 * bed('pink', r, lo=3000, hi=7000, gain=0.25, lfo=(0.11, 0.8))
    ev = []
    for k, (f, p) in enumerate(((4200, -0.6), (4650, 0.2), (5100, 0.7))):
        n = N(DUR)
        t = tt(n)
        gate = (np.sin(2 * np.pi * (5.2 + 0.4 * k) * t) > 0.2) * (np.sin(2 * np.pi * 0.17 * t + k * 2) > -0.4)
        gate = lp(gate.astype(float), 120)
        tone = np.sin(2 * np.pi * f * t) * (0.7 + 0.3 * np.sin(2 * np.pi * 45 * t))
        buf += pan(tone * gate * 0.05, p)
    for start in (6.5, 19.0):
        n = N(1.7)
        hoo = np.zeros(n)
        for off, f, d in ((0.0, 392, 0.28), (0.4, 330, 0.28), (0.85, 330, 0.7)):
            m = N(d)
            seg = np.sin(2 * np.pi * np.cumsum(glide(f * 1.04, f, m)) / SR) * np.sin(np.pi * np.linspace(0, 1, m)) ** 1.5
            hoo[N(off):N(off) + m] += seg
        ev.append((lp(hoo, 900), start, 0.22, 0.5 if start < 10 else -0.5))
    for k in range(9):
        n = N(0.6)
        ev.append((hp(white(n, r), 2500) * expdec(n, 0.12, 0.05) * 0.35, r.uniform(0, DUR - 1), 0.12, r.uniform(-1, 1)))
    mix_events(buf, ev)
    return buf


def amb002():
    r = np.random.default_rng(1002)
    buf = bed('pink', r, f=900, gain=0.7, lfo=(0.05, 0.5))
    buf += 0.5 * bed('brown', r, lo=150, hi=700, gain=0.9, lfo=(3.7, 0.55))
    ev = []
    for k in range(6):
        n = N(0.9)
        f = r.uniform(110, 190)
        creak = bp(osc(f + 25 * np.sin(2 * np.pi * 3.3 * tt(n)), n, 'saw'), 300, 1400) * adsr(n, 0.12, 0.2, 0.6, 0.3)
        ev.append((creak, r.uniform(1, DUR - 2), 0.1, r.uniform(-0.8, 0.8)))
    for k in range(7):
        f = 880 * 2 ** (PENT[r.integers(0, 5)] / 12) * (2 if r.random() < 0.4 else 1)
        ev.append((bell(f, 2.5, 1.0, ratios=(1, 2.4, 4.1), amps=(1, .3, .15), decay=1.4), r.uniform(0, DUR - 2.5), 0.07, r.uniform(-0.9, 0.9)))
    for k in range(3):
        s = r.uniform(3, DUR - 3)
        for j in range(3):
            n = N(0.12)
            ev.append((thump(260, 200, 0.12, 0.03, 1.0) + bp(white(n, r), 800, 3000) * expdec(n, 0.03), s + j * 0.55, 0.09, 0.8))
    n = N(DUR)
    flick = (hp(white(n, r), 3500) * (r.random(n) < 0.0009) * 5)
    buf += pan(lp(flick, 9000) * 0.05, 0.3)
    mix_events(buf, ev)
    return buf


def amb003():
    r = np.random.default_rng(1003)
    buf = bed('pink', r, lo=250, hi=1600, gain=1.0, lfo=(0.09, 0.8))
    buf += 0.12 * bed('pink', r, lo=2500, hi=8000, gain=0.3, lfo=(0.13, 0.9))
    ev = []

    def songA(f):
        out = np.zeros(N(1.1))
        for k in range(r.integers(3, 6)):
            c = chirp(f, f * 1.25, 0.09, r, shape=0.8)
            out[N(0.18 * k):N(0.18 * k) + len(c)] += c
        return out

    def songB(f):
        out = np.zeros(N(1.0))
        for k, ff in enumerate((f, f * 1.18, f * 0.92)):
            c = chirp(ff, ff * 1.02, 0.22, r, shape=0.6)
            out[N(0.3 * k):N(0.3 * k) + len(c)] += c
        return out

    def songC(f):
        return chirp(f, f * 0.95, 0.9, r, fm=0, am=32, shape=0.5)

    for k in range(16):
        kind = k % 3
        f = r.uniform(2800, 4200) if kind != 1 else r.uniform(2000, 2600)
        sig = (songA, songB, songC)[kind](f)
        ev.append((sig, r.uniform(0, DUR - 1.5), r.uniform(0.15, 0.3), r.uniform(-0.9, 0.9)))
    mix_events(buf, ev)
    return buf


def amb004():
    r = np.random.default_rng(1004)
    buf = bed('brown', r, f=220, gain=0.6, lfo=(0.04, 0.4))
    ev = []
    for k in range(13):
        f0 = r.uniform(900, 1700)
        n = N(0.5)
        t = tt(n)
        drip = np.sin(2 * np.pi * np.cumsum(glide(f0, f0 * 0.55, n)) / SR) * np.exp(-t / 0.05) * np.clip(t / 0.001, 0, 1)
        drip += 0.3 * np.sin(2 * np.pi * f0 * 2.01 * t) * np.exp(-t / 0.02)
        ev.append((drip, r.uniform(0, DUR - 0.6), r.uniform(0.15, 0.4), r.uniform(-0.9, 0.9)))
    drips = np.zeros((L, 2))
    mix_events(drips, ev)
    folded = fold(reverb(drips, 3.2, 0.9, 4, damp=3500), L)
    for k in range(3):
        n = N(1.6)
        res = (np.sin(2 * np.pi * r.uniform(70, 110) * tt(n)) * np.sin(np.pi * np.linspace(0, 1, n)) ** 2) * 0.05
        add(buf, pan(res, r.uniform(-0.6, 0.6)), r.uniform(0, DUR - 2), 1.0, True)
    return buf + folded * 1.0


def amb005():
    r = np.random.default_rng(1005)
    t = tt(L)
    drone = sum(a * np.sin(2 * np.pi * f * t + k) * (0.7 + 0.3 * np.sin(2 * np.pi * lf * t + k)) for k, (f, a, lf) in enumerate(((38, 0.5, 2 / DUR), (45.5, 0.35, 2 / DUR), (61, 0.25, 3 / DUR), (92, 0.1, 4 / DUR))))
    buf = np.stack([drone, np.roll(drone, N(0.003))], axis=1) * 0.5
    buf += bed('brown', r, f=130, gain=1.6, lfo=(0.07, 0.6))
    ev = []
    for k in range(8):
        n = N(0.9)
        creak = bp(osc(glide(r.uniform(70, 140), r.uniform(50, 90), n), n, 'saw'), 120, 600) * adsr(n, 0.2, 0.2, 0.5, 0.3)
        ev.append((creak, r.uniform(0, DUR - 1.2), 0.12, r.uniform(-0.8, 0.8)))
    for k in range(14):
        n = N(0.05)
        ev.append((bp(white(n, r), 400, 2500) * expdec(n, 0.012, 0.0005), r.uniform(0, DUR), 0.1, r.uniform(-1, 1)))
    mix_events(buf, ev)
    return buf


def amb006():
    r = np.random.default_rng(1006)
    buf = bed('pink', r, lo=300, hi=2600, gain=0.6, lfo=(0.5, 0.35))
    buf += 0.2 * bed('white', r, lo=1200, hi=4500, gain=0.4, lfo=(7.0, 0.5))
    ev = []
    for k in range(70):
        n = N(0.05)
        f0 = r.uniform(400, 900)
        t = tt(n)
        blip = np.sin(2 * np.pi * np.cumsum(glide(f0, f0 * 2.2, n)) / SR) * np.exp(-t / 0.015)
        ev.append((blip, r.uniform(0, DUR - 0.1), r.uniform(0.4, 0.9), r.uniform(-1, 1)))
    for k in range(5):
        s = r.uniform(1, DUR - 3)
        f = r.uniform(150, 190)
        for j in range(r.integers(3, 6)):
            n = N(0.16)
            t = tt(n)
            croak = bp(osc(f + 15 * j, n, 'saw'), 350, 950) * (0.5 + 0.5 * np.sin(2 * np.pi * 28 * t)) * adsr(n, 0.02, 0.05, 0.7, 0.05)
            ev.append((croak, s + j * 0.22, 1.2, r.uniform(-0.8, 0.8)))
    mix_events(buf, ev)
    buf += 0.2 * bed('pink', r, lo=5200, hi=6200, gain=0.12, lfo=(0.2, 0.9))
    return buf


def amb007():
    r = np.random.default_rng(1007)
    n = L + XF
    chans = []
    for c in range(2):
        x = white(n, r)
        howl = sweep(x, 'band', 260 + 30 * c, 640 - 40 * c, 0.12, 1024)
        howl2 = sweep(white(n, r), 'band', 520, 330, 0.1, 1024)
        chans.append(howl + 0.6 * howl2)
    s = np.stack(chans, axis=1)
    s = s / (np.std(s) + 1e-9) * 0.22
    s *= (0.65 + 0.35 * np.sin(2 * np.pi * 0.08 * tt(n) + 1.0))[:, None]
    buf = loopify(s, L, XF)
    buf += 0.8 * bed('pink', r, f=500, gain=0.6, lfo=(0.05, 0.5))
    ev = []
    for start, f, p in ((3.0, 196, -0.3), (11.5, 220, 0.4), (17.0, 196, -0.2), (25.0, 165, 0.3)):
        b = bell(f, 7.0, 1.0, ratios=(1, 2.0, 2.74, 4.2, 5.4), amps=(1, .6, .5, .25, .15), decay=3.0)
        ev.append((lp(b, 5000), start, 0.9, p))
    mix_events(buf, ev)
    return buf


def amb008():
    r = np.random.default_rng(1008)
    t = tt(L)
    chans = [np.zeros(L), np.zeros(L)]
    for k, f in enumerate((220.0, 329.6, 493.9, 740.0)):
        for c in range(2):
            d = (0.35 if c else -0.35) * (1 + 0.2 * k)
            fr = round((f + d) * DUR) / DUR
            chans[c] += (0.12 / (1 + 0.3 * k)) * np.sin(2 * np.pi * fr * t + k) * (0.8 + 0.2 * np.sin(2 * np.pi * ((1 + k % 2) / DUR) * t))
    buf = np.stack(chans, axis=1) * 0.7
    buf += 0.4 * bed('pink', r, lo=1800, hi=6000, gain=0.2, lfo=(0.06, 0.8))
    ev = []
    for start, f in ((4.0, 1760), (12.5, 2350), (21.0, 1568)):
        ev.append((bell(f, 4.0, 1.0, ratios=(1, 2.01, 3.5), amps=(1, .3, .1), decay=2.0), start, 0.08, r.uniform(-0.6, 0.6)))
    mix_events(buf, ev)
    return buf


def post(buf, rvb):
    if not rvb:
        return buf
    rt, wet, seed = rvb
    return fold(reverb(buf, rt, wet, seed), L)


AMB = {
    'AUD-AMB-001': ('Brackenreach night', amb001, 'Crickets, low night wind, two distant owl calls and leaf rustle.', (2.0, 0.12, 21)),
    'AUD-AMB-002': ('Village ambience', amb002, 'Soft wind, faint murmur, wooden creaks, wind chimes and lantern flicker; no intelligible speech.', (1.6, 0.12, 22)),
    'AUD-AMB-003': ('Forest birds and wind', amb003, 'Wind swells with three synthetic bird-call types.', (1.8, 0.14, 23)),
    'AUD-AMB-004': ('Cave drips', amb004, 'Water drips with long reverb and low cavern air.', None),
    'AUD-AMB-005': ('Underground rumble', amb005, 'Sub-bass drone, brown-noise breathing and distant stone creaks.', (1.5, 0.08, 25)),
    'AUD-AMB-006': ('Glasswater Fen water', amb006, 'Flowing and bubbling water, frog croaks and night insects.', (1.4, 0.1, 26)),
    'AUD-AMB-007': ('Bellows Gorge bells', amb007, 'Gorge wind howl with four distant bell tolls.', (2.6, 0.2, 27)),
    'AUD-AMB-008': ('Quiet Crown ambience', amb008, 'Airy pad with sparse crystalline chimes; the quietest soundscape.', (2.8, 0.22, 28)),
}
