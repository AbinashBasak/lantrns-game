"""Phase 09 sound-effect synthesis. Each builder returns {variant_name: mono ndarray}."""
import numpy as np
from audiolib import *


def rg(seed):
    return np.random.default_rng(seed)


def thump(f0, f1, dur, tau, amp=1.0):
    n = N(dur)
    return amp * np.sin(2 * np.pi * np.cumsum(glide(f0, f1, n)) / SR) * expdec(n, tau, 0.002)


def burst(dur, lo, hi, tau, rng, amp=1.0, attack=0.002):
    n = N(dur)
    return amp * bp(white(n, rng), lo, hi) * expdec(n, tau, attack)


def bell(f, dur, amp=1.0, ratios=(1, 2.76, 5.4, 8.93), amps=(1, .5, .25, .12), decay=1.5):
    n = N(dur)
    t = tt(n)
    out = np.zeros(n)
    for k, (r, a) in enumerate(zip(ratios, amps)):
        if f * r < 16000:
            out += a * np.sin(2 * np.pi * f * r * t) * np.exp(-t * (1 / decay) * (1 + 1.3 * k))
    return amp * out * np.clip(t / 0.002, 0, 1)


def formant(src, formants, bws):
    return sum(bp(src, f - b / 2, f + b / 2) * g for (f, g), b in zip(formants, bws))


def sfx001():
    out = {}
    for v in range(4):
        r = rg(100 + v)
        x = burst(0.18, 500 + 80 * v, 3200, 0.04, r, 1.0, 0.004) + burst(0.18, 4000, 9000, 0.07, r, 0.25, 0.004) + thump(115 - 6 * v, 70, 0.18, 0.05, 0.45)
        out[f'step_{v + 1}'] = fit(x, N(0.2))
    return out


def sfx002():
    out = {}
    for v in range(4):
        r = rg(200 + v)
        x = burst(0.16, 1500, 6500, 0.014, r, 1.0, 0.001) + thump(150 - 8 * v, 95, 0.16, 0.035, 0.55)
        x += 0.4 * np.sin(2 * np.pi * (1100 + 140 * v) * tt(N(0.16))) * expdec(N(0.16), 0.02, 0.001)
        out[f'step_{v + 1}'] = fit(x, N(0.18))
    return out


def sfx003():
    n = N(0.32)
    r = rg(3)
    f = glide(260, 640, n)
    x = 0.6 * osc(f, n, 'sine') + 0.25 * osc(f * 2, n, 'sine') + 0.5 * hp(white(n, r), 1800) * expdec(n, 0.12)
    x *= adsr(n, 0.015, 0.08, 0.6, 0.12)
    return {'jump': x}


def sfx004():
    out = {}
    for name, dur, f0, tau, nz in (('soft', 0.22, 110, 0.07, 0.5), ('hard', 0.34, 85, 0.11, 0.9)):
        r = rg(4 if name == 'soft' else 5)
        x = thump(f0, 42, dur, tau, 1.0) + lp(white(N(dur), r), 1400) * expdec(N(dur), tau * 0.9) * nz + hp(white(N(dur), r), 3500) * expdec(N(dur), 0.06) * 0.25
        out[name] = x
    return out


def sfx005():
    out = {}
    for v, (f0, f1, dur) in enumerate(((700, 4200, 0.26), (600, 3600, 0.3), (850, 4800, 0.22)), 1):
        n = N(dur)
        r = rg(50 + v)
        x = sweep(white(n, r), 'band', f0, f1, 0.5)
        env = np.sin(np.pi * np.clip(tt(n) / (n / SR), 0, 1)) ** 1.5
        x = x * env + 0.12 * osc(glide(f0 * 0.4, f1 * 0.3, n), n, 'sine') * env
        out[f'swing_{v}'] = x
    return out


def sfx006():
    out = {}
    for v, base in enumerate((1.0, 1.12, 0.9), 1):
        r = rg(60 + v)
        n = N(0.5)
        x = burst(0.5, 2000, 9000, 0.02, r, 1.0, 0.0005) + thump(180, 70, 0.5, 0.04, 0.6)
        for fr, a, d in ((1150, 0.5, 0.2), (1830, 0.4, 0.16), (2870, 0.3, 0.12), (4210, 0.2, 0.09)):
            x += a * np.sin(2 * np.pi * fr * base * tt(n)) * expdec(n, d, 0.0005)
        out[f'impact_{v}'] = x
    return out


def sfx007():
    out = {}
    for v, (f0, f1) in enumerate(((140, 95), (170, 110)), 1):
        r = rg(70 + v)
        n = N(0.55)
        t = tt(n)
        f = glide(f0, f1, n) * (1 + 0.04 * np.sin(2 * np.pi * 24 * t))
        src = osc(f, n, 'saw') + 0.3 * white(n, r) * 0.3
        voice = formant(src, ((620, 1.0), (1050, 0.7), (2400, 0.3)), (160, 200, 300))
        x = voice * adsr(n, 0.04, 0.1, 0.7, 0.2) + 0.5 * sweep(white(n, r), 'band', 400, 2200, 0.5) * expdec(n, 0.15, 0.01)
        out[f'attack_{v}'] = x
    return out


def sfx008():
    r = rg(8)
    n = N(0.9)
    t = tt(n)
    tone = osc(glide(520, 90, n), n, 'saw') * np.exp(-t / 0.28)
    puff = sweep(white(n, r), 'low', 6000, 400) * np.exp(-t / 0.3)
    sparkle = np.zeros(n)
    for k in range(7):
        s0 = int(r.uniform(0.02, 0.5) * SR)
        f = r.uniform(1800, 4200)
        seg = np.sin(2 * np.pi * f * tt(N(0.12))) * expdec(N(0.12), 0.04)
        sparkle[s0:s0 + len(seg)] += seg[:n - s0] * 0.25
    return {'defeat': 0.55 * lp(tone, 3000) + 0.8 * puff + sparkle}


def sfx009():
    out = {}
    for v, (f0, f1) in enumerate(((210, 150), (240, 170)), 1):
        r = rg(90 + v)
        n = N(0.36)
        src = osc(glide(f0, f1, n), n, 'saw')
        voice = formant(src, ((650, 1.0), (1100, 0.8), (2500, 0.25)), (140, 180, 300)) * adsr(n, 0.015, 0.08, 0.6, 0.12)
        x = voice + 0.7 * thump(130, 60, 0.36, 0.06) + 0.4 * burst(0.36, 600, 3000, 0.05, r)
        out[f'hurt_{v}'] = x
    return out


def sfx010():
    r = rg(10)
    n = N(2.4)
    x = np.zeros(n)
    nc = N(0.75)
    t = tt(nc)
    f = 130 + 60 * np.sin(2 * np.pi * 3.1 * t) * np.linspace(0.3, 1, nc) + glide(0, 60, nc, 'lin')
    creak = bp(osc(f, nc, 'saw'), 300, 1600) * (0.6 + 0.4 * bp(white(nc, r), 4, 40, 1)[:nc] * 6)
    x[:nc] += 0.8 * creak * adsr(nc, 0.08, 0.2, 0.8, 0.12)
    x = add(x, burst(0.06, 2500, 7000, 0.01, r, 1.2, 0.0005), 0.78)
    for k, f in enumerate((1046.5, 1318.5, 1568, 2093)):
        x = add(x, bell(f, 1.4, 0.35, decay=0.9), 0.95 + 0.06 * k)
    return {'chest_open': x}


def sfx011():
    n = N(0.9)
    x = np.zeros(n)
    for k, f in enumerate((1318.5, 1661.2, 1975.5, 2637)):
        x = add(x, bell(f, 0.6, 0.5, ratios=(1, 2.01, 3.0), amps=(1, .35, .15), decay=0.3), 0.065 * k)
    return {'pickup': x}


def sfx012():
    r = rg(12)
    n = N(1.8)
    t = tt(n)
    sw = np.sin(np.pi * np.clip(t / 0.95, 0, 1)) ** 2 * (t < 0.95)
    hum = sum(np.sin(2 * np.pi * f * t + k) * (0.6 + 0.4 * np.sin(2 * np.pi * (5 + k) * t)) for k, f in enumerate((220, 330, 441, 661))) / 4
    x = hum * sw * 0.8 + 0.3 * sweep(white(n, r), 'band', 500, 5000, 0.4) * sw
    for k, f in enumerate((880, 1320, 1760)):
        x = add(x, bell(f, 1.0, 0.45, decay=0.8), 0.75 + 0.04 * k)
    return {'rune': reverb(x, 1.2, 0.3, 12)[:n, 0]}


def sfx013():
    r = rg(13)
    n = N(2.6)
    x = 0.25 * sweep(white(n, r), 'band', 300, 2500, 0.5) * np.sin(np.pi * np.clip(tt(n) / 0.7, 0, 1)) ** 2 * (tt(n) < 0.7)
    for k, f in enumerate((440, 659.3, 880, 1108.7)):
        x = add(x, bell(f, 2.2, 0.5 / (1 + 0.15 * k), decay=1.6), 0.05 + 0.07 * k)
    return {'checkpoint': reverb(x, 1.6, 0.3, 13)[:n, 0]}


def sfx014():
    r = rg(14)
    n = N(1.8)
    t = tt(n)
    env = np.clip(t / 0.15, 0, 1) * np.clip((1.45 - t) / 0.25, 0, 1)
    grind = lp(brown(n, r), 420) * (0.55 + 0.45 * np.sin(2 * np.pi * 9 * t + np.cumsum(r.standard_normal(n)) * 0.0004)) * env
    rumble = np.sin(2 * np.pi * 52 * t) * env * 0.35
    x = grind * 1.4 + rumble
    x = add(x, thump(110, 50, 0.3, 0.07, 0.9), 0.0)
    x = add(x, thump(95, 45, 0.35, 0.09, 1.0), 1.45)
    x = add(x, burst(0.25, 200, 1800, 0.06, r, 0.5), 1.45)
    return {'door_open': x}


def sfx015():
    r = rg(15)
    out = {}
    n = N(1.3)
    slam = thump(75, 28, 1.3, 0.4, 1.0) + lp(white(n, r), 900) * expdec(n, 0.3) * 0.9 + burst(1.3, 1500, 8000, 0.03, r, 0.7)
    out['slam'] = slam
    n = N(0.7)
    out['swipe'] = sweep(white(n, r), 'band', 180, 1600, 0.6) * np.sin(np.pi * np.clip(tt(n) / (n / SR), 0, 1)) ** 1.3 * 1.2 + 0.3 * thump(60, 40, 0.7, 0.2)
    n = N(1.5)
    t = tt(n)
    f = glide(75, 52, n) * (1 + 0.03 * np.sin(2 * np.pi * 14 * t))
    src = osc(f, n, 'saw') + 0.4 * white(n, r)
    out['roar'] = formant(src, ((300, 1.0), (700, 0.8), (1500, 0.4)), (120, 200, 300)) * adsr(n, 0.12, 0.3, 0.8, 0.5) * 2.0
    n = N(1.4)
    t = tt(n)
    charge = osc(glide(100, 900, N(0.65)), N(0.65), 'saw') * np.linspace(0.1, 1, N(0.65)) ** 2
    x = np.zeros(n)
    x[:len(charge)] += 0.5 * lp(charge, 3500)
    x = add(x, burst(0.75, 300, 7000, 0.18, r, 1.0, 0.003), 0.65)
    x = add(x, thump(130, 45, 0.75, 0.15, 0.9), 0.65)
    out['blast'] = x
    return out


def sfx016():
    r = rg(16)
    n = N(0.9)
    t = tt(n)
    x = burst(0.9, 1800, 9000, 0.015, r, 1.0, 0.0005) + thump(100, 40, 0.9, 0.12, 1.0)
    groan = lp(osc(glide(95, 62, n), n, 'saw'), 700) * adsr(n, 0.05, 0.3, 0.5, 0.4)
    return {'damage': x + 0.6 * groan}


def sfx017():
    r = rg(17)
    n = N(5.0)
    t = tt(n)
    rum = lp(brown(n, r), 260) * (np.clip(t / 0.4, 0, 1)) * np.exp(-np.clip(t - 2.4, 0, None) / 1.2) * 3
    groan = lp(osc(glide(120, 32, N(3.2)), N(3.2), 'saw'), 600) * adsr(N(3.2), 0.1, 0.5, 0.7, 1.2)
    x = rum + 0.6 * np.pad(groan, (0, n - len(groan)))
    for _ in range(40):
        x = add(x, burst(0.05, 800, 6000, 0.01, r, r.uniform(0.2, 0.8)), r.uniform(0.2, 2.8))
    x = add(x, thump(90, 28, 1.6, 0.35, 1.0), 0.0)
    rel = sweep(white(N(1.8), r), 'band', 400, 6000, 0.5) * expdec(N(1.8), 0.5, 0.05) * 0.7
    x = add(x, rel, 3.0)
    for k, f in enumerate((523.3, 784, 1046.5, 1568)):
        x = add(x, bell(f, 2.0, 0.35, decay=1.4), 3.0 + 0.05 * k)
    return {'defeat': reverb(x, 2.2, 0.28, 17)[:n, 0]}


def sfx018():
    t = tt(N(0.12))
    sel = (np.sin(2 * np.pi * 1040 * t) + 0.35 * np.sin(2 * np.pi * 2080 * t)) * expdec(N(0.12), 0.04, 0.001)
    n = N(0.3)
    conf = np.zeros(n)
    conf = add(conf, bell(784, 0.25, 0.8, ratios=(1, 2, 3), amps=(1, .3, .1), decay=0.15), 0.0)
    conf = add(conf, bell(1175, 0.25, 0.9, ratios=(1, 2, 3), amps=(1, .3, .1), decay=0.18), 0.08)
    back = np.zeros(N(0.25))
    back = add(back, bell(880, 0.2, 0.7, ratios=(1, 2, 3), amps=(1, .3, .1), decay=0.12), 0.0)
    back = add(back, bell(587, 0.2, 0.7, ratios=(1, 2, 3), amps=(1, .3, .1), decay=0.14), 0.07)
    return {'select': sel, 'confirm': conf, 'back': back}


SFX = {
    'AUD-SFX-001': ('Running on grass', sfx001, 'Four alternating footstep variants; play randomly, no repeats back to back.'),
    'AUD-SFX-002': ('Running on stone', sfx002, 'Four alternating footstep variants with a sharper click.'),
    'AUD-SFX-003': ('Jump', sfx003, 'Single take-off whoosh.'),
    'AUD-SFX-004': ('Landing', sfx004, 'Soft and hard landing variants; pick by fall distance.'),
    'AUD-SFX-005': ('Sword swing', sfx005, 'Three swing variants for combo steps.'),
    'AUD-SFX-006': ('Sword impact', sfx006, 'Three metallic hit variants.'),
    'AUD-SFX-007': ('Enemy attack', sfx007, 'Two creature snarl-and-lunge variants.'),
    'AUD-SFX-008': ('Enemy defeat', sfx008, 'Descending poof with leaf sparkle.'),
    'AUD-SFX-009': ('Player hurt', sfx009, 'Two short vocal-style grunt variants; no words.'),
    'AUD-SFX-010': ('Chest opening', sfx010, 'Creak, latch click and sparkle chord.'),
    'AUD-SFX-011': ('Collectible pickup', sfx011, 'Rising bell arpeggio.'),
    'AUD-SFX-012': ('Rune activation', sfx012, 'Swelling shimmer with bell strike, mono reverb tail.'),
    'AUD-SFX-013': ('Checkpoint activation', sfx013, 'Warm bell chord with soft whoosh.'),
    'AUD-SFX-014': ('Door opening', sfx014, 'Heavy stone door slide with thunks at start and end.'),
    'AUD-SFX-015': ('Boss attack set', sfx015, 'Four boss attacks: slam, swipe, roar, energy blast.'),
    'AUD-SFX-016': ('Boss damage', sfx016, 'Crack plus stone groan.'),
    'AUD-SFX-017': ('Boss defeat', sfx017, 'Five-second collapse with final release.'),
    'AUD-SFX-018': ('UI selection and confirmation', sfx018, 'Select, confirm and back cues.'),
}
