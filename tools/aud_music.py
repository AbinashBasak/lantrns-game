"""Phase 09 music: simple synthesized loop prototypes (placeholder-grade composition)."""
import re
import numpy as np
from audiolib import *
from aud_sfx import bell

MODES = {'minor': [0, 2, 3, 5, 7, 8, 10], 'major': [0, 2, 4, 5, 7, 9, 11], 'dorian': [0, 2, 3, 5, 7, 9, 10],
         'phrygian': [0, 1, 3, 5, 7, 8, 10], 'lydian': [0, 2, 4, 6, 7, 9, 11], 'harmonic': [0, 2, 3, 5, 7, 8, 11]}
PC = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}
QUAL = {'': [0, 4, 7], 'm': [0, 3, 7], 'maj7': [0, 4, 7, 11], 'm7': [0, 3, 7, 10], '7': [0, 4, 7, 10], 'sus2': [0, 2, 7], 'dim': [0, 3, 6]}


def chord(name, octave=3):
    m = re.match(r'([A-G])([b#]?)(.*)', name)
    root = PC[m[1]] + (1 if m[2] == '#' else -1 if m[2] == 'b' else 0)
    return [12 * (octave + 1) + root + i for i in QUAL[m[3]]]


def scale_notes(key_pc, mode, lo, hi):
    pcs = {(key_pc + i) % 12 for i in MODES[mode]}
    return [m for m in range(lo, hi + 1) if m % 12 in pcs]


def melody(prog, key_pc, mode, bpb, patterns, seed, lo, hi, rest=0.08):
    rng = np.random.default_rng(seed)
    sc = scale_notes(key_pc, mode, lo, hi)
    notes, prev, mid = [], None, (lo + hi) // 2
    for bar, name in enumerate(prog):
        cpcs = {c % 12 for c in chord(name)}
        ct = [m for m in sc if m % 12 in cpcs]
        phase = (bar % 4) / 4
        target = mid + 4 * np.sin(np.pi * phase)
        for beat, dur in patterns[bar % len(patterns)]:
            strong = beat % 2 == 0
            if prev is None:
                pitch = min(ct, key=lambda m: abs(m - target))
            elif strong:
                want = prev + rng.choice([-3, -2, -1, 0, 1, 2, 3]) + (1 if target > prev else -1)
                pitch = min(ct, key=lambda m: abs(m - want))
            else:
                i = sc.index(prev) if prev in sc else int(np.argmin([abs(m - prev) for m in sc]))
                i = int(np.clip(i + rng.choice([-2, -1, 1, 2]) + (1 if target > prev else -1) * rng.choice([0, 1]), 0, len(sc) - 1))
                pitch = sc[i]
            if bar == len(prog) - 1 and beat == patterns[bar % len(patterns)][0][0]:
                pitch = min([m for m in sc if m % 12 == key_pc], key=lambda m: abs(m - mid))
            prev = pitch
            if not strong and rng.random() < rest:
                continue
            notes.append((bar * bpb + beat, pitch, dur))
    return notes


def pluck(m, dur, harp=False):
    f = float(mtof(m))
    n = N(dur + 0.6)
    amps = [1 / h ** 1.1 for h in range(1, 9)]
    dec = [(1.4 if harp else 2.4) + (1.0 if harp else 1.8) * h for h in range(1, 9)]
    return harmonics(f, n, amps, dec) * np.clip(tt(n) / 0.002, 0, 1)


def pad(m, dur):
    f = float(mtof(m))
    n = N(dur + 0.9)
    amps = [1 / h ** 1.4 for h in range(1, 9)]
    x = sum(harmonics(f, n, amps, detune=d) for d in (-0.004, 0.0, 0.004))
    return x * adsr(n, 0.35, 0.2, 0.8, 0.9) / 3


def flute(m, dur):
    f = float(mtof(m))
    n = N(dur + 0.15)
    t = tt(n)
    vib = 1 + 0.005 * np.sin(2 * np.pi * 5.2 * t) * np.clip((t - 0.15) / 0.2, 0, 1)
    x = np.sin(2 * np.pi * np.cumsum(f * vib) / SR) + 0.3 * np.sin(4 * np.pi * np.cumsum(f * vib) / SR) + 0.08 * np.sin(6 * np.pi * np.cumsum(f * vib) / SR)
    x += 0.06 * bp(np.random.default_rng(int(m)).standard_normal(n), min(f * 1.5, 15000), min(f * 3, 18000))
    return x * adsr(n, 0.05, 0.1, 0.85, 0.12)


def bass(m, dur):
    f = float(mtof(m))
    n = N(dur + 0.1)
    x = harmonics(f, n, [1, 0.4, 0.2, 0.1])
    return x * adsr(n, 0.01, 0.12, 0.7, 0.1)


def brass(m, dur):
    f = float(mtof(m))
    n = N(dur + 0.12)
    t = tt(n)
    x = sum((1 / h ** 0.8) * np.clip(t / (0.02 + 0.02 * h), 0, 1) * np.sin(2 * np.pi * f * h * t) for h in range(1, 11) if f * h < 14000)
    return x * adsr(n, 0.04, 0.1, 0.8, 0.12) * 0.4


def choir(m, dur):
    f = float(mtof(m))
    n = N(dur + 0.8)
    src = sum(harmonics(f, n, [1 / h for h in range(1, 25)], detune=d) for d in (-0.006, 0.0, 0.006))
    voice = sum(bp(src, fc - bw / 2, fc + bw / 2) * g for fc, bw, g in ((700, 150, 1.0), (1150, 200, 0.7), (2600, 400, 0.3)))
    return voice * adsr(n, 0.5, 0.3, 0.8, 0.8) * 0.4


def belln(m, dur):
    return bell(float(mtof(m)), dur + 1.2, 0.8, ratios=(1, 2.76, 5.4), amps=(1, .35, .15), decay=1.6)


def kick(vol=1):
    n = N(0.3)
    return vol * np.sin(2 * np.pi * np.cumsum(glide(150, 45, n)) / SR) * expdec(n, 0.09, 0.001)


def snare(vol=1):
    n = N(0.25)
    r = np.random.default_rng(1)
    return vol * (bp(r.standard_normal(n), 1200, 7000) * expdec(n, 0.08, 0.001) * 0.8 + np.sin(2 * np.pi * 190 * tt(n)) * expdec(n, 0.05, 0.001) * 0.5)


def hat(vol=1):
    n = N(0.08)
    return vol * hp(np.random.default_rng(2).standard_normal(n), 7000) * expdec(n, 0.025, 0.0005) * 0.5


def tom(vol=1, f=200):
    n = N(0.4)
    return vol * np.sin(2 * np.pi * np.cumsum(glide(f, f * 0.45, n)) / SR) * expdec(n, 0.14, 0.001)


def taiko(vol=1):
    n = N(0.8)
    return vol * (np.sin(2 * np.pi * np.cumsum(glide(110, 55, n)) / SR) * expdec(n, 0.3, 0.002) + 0.4 * lp(np.random.default_rng(3).standard_normal(n), 800) * expdec(n, 0.08))


def crash(vol=1):
    n = N(1.8)
    return vol * hp(np.random.default_rng(4).standard_normal(n), 4500) * expdec(n, 0.6, 0.001) * 0.5


def shaker(vol=1):
    n = N(0.1)
    return vol * hp(np.random.default_rng(5).standard_normal(n), 5000) * expdec(n, 0.03, 0.01) * 0.4


DRUMS = {'k': kick, 's': snare, 'h': hat, 't': tom, 'T': taiko, 'c': crash, 'x': shaker}


class Song:
    def __init__(self, bpm, bpb, bars, rt=2.0, seed=0):
        self.spb, self.bpb, self.bars, self.rt, self.seed = 60 / bpm, bpb, bars, rt, seed
        self.L = N(bars * bpb * self.spb)
        self.tail = N(4.5)
        self.buses = {}

    def bus(self, name, p=0.0, level=1.0, send=0.2):
        self.buses[name] = dict(buf=np.zeros((self.L + self.tail, 2)), p=p, level=level, send=send)

    def note(self, bus, inst, beat, midi, dur, vel=1.0, pan_off=0.0):
        b = self.buses[bus]
        seg = inst(midi, dur * self.spb)
        add(b['buf'], pan(seg, np.clip(b['p'] + pan_off, -1, 1)), beat * self.spb, vel)

    def hit(self, bus, key, beat, vol=1.0):
        b = self.buses[bus]
        seg = DRUMS[key](vol)
        add(b['buf'], pan(seg, b['p']), beat * self.spb)

    def drums(self, bus, patterns, bars_range=None):
        """patterns: {key: 16-char-per-bar string(s)} for 4/4 sixteenth grid; list cycles per bar."""
        for bar in range(self.bars):
            if bars_range and not (bars_range[0] <= bar < bars_range[1]):
                continue
            for key, pats in patterns.items():
                pat = pats[bar % len(pats)] if isinstance(pats, (list, tuple)) else pats
                for i, ch in enumerate(pat):
                    if ch in 'xX':
                        self.hit(bus, key, bar * self.bpb + i * 0.25, 1.0 if ch == 'X' else 0.6)

    def render(self):
        n = self.L + self.tail
        dry = np.zeros((n, 2))
        send = np.zeros((n, 2))
        for b in self.buses.values():
            dry += b['buf'] * b['level']
            send += b['buf'] * b['level'] * b['send']
        wet = reverb_wet(send, self.rt, self.seed)
        mix = np.pad(dry, ((0, len(wet) - n), (0, 0))) + wet * 0.55
        return fold(mix, self.L)


def arp_events(song, bus, prog, octave, pattern, step, harp=True, vel=0.5, inst=None):
    for bar, name in enumerate(prog):
        tones = chord(name, octave)
        tones = tones + [tones[0] + 12]
        for i, idx in enumerate(pattern):
            beat = bar * song.bpb + i * step
            if beat >= (bar + 1) * song.bpb:
                break
            song.note(bus, inst or (lambda m, d: pluck(m, d, harp)), beat, tones[idx % len(tones)], step * 2.2, vel)


def bass_events(song, bus, prog, kind='half', vel=0.8):
    for bar, name in enumerate(prog):
        r = chord(name, 1)[0] + 12
        if kind == 'half':
            song.note(bus, bass, bar * song.bpb, r, song.bpb / 2 - 0.1, vel)
            song.note(bus, bass, bar * song.bpb + song.bpb / 2, r + 7 if song.bpb == 4 else r, song.bpb / 2 - 0.1, vel * 0.85)
        elif kind == 'eighths':
            for i in range(song.bpb * 2):
                song.note(bus, bass, bar * song.bpb + i * 0.5, r + (12 if i % 4 == 3 else 0), 0.45, vel)
        elif kind == 'pedal':
            song.note(bus, bass, bar * song.bpb, chord(prog[0], 1)[0] + 12, song.bpb - 0.1, vel)
        elif kind == 'waltz':
            song.note(bus, bass, bar * song.bpb, r, 0.9, vel)


def pad_events(song, bus, prog, octave=3, vel=0.5, inst=pad, voices=3):
    for bar, name in enumerate(prog):
        for m in chord(name, octave)[:voices]:
            song.note(bus, inst, bar * song.bpb, m, song.bpb, vel / voices * 1.6)


def lead_events(song, bus, notes, inst=flute, vel=0.8, dbl=None, dbl_inst=None, dbl_vel=0.3):
    for beat, m, d in notes:
        song.note(bus, inst, beat, m, d * 0.95, vel)
        if dbl is not None:
            song.note(dbl, dbl_inst or inst, beat, m + 12, d * 0.9, dbl_vel)


def finish(song):
    out = song.render()
    return out


P44 = [[(0, 1.5), (1.5, .5), (2, 1), (3, 1)], [(0, 1), (1, 1), (2, 2)], [(0, .5), (.5, .5), (1, 1), (2, 1.5), (3.5, .5)], [(0, 2), (2, 1), (3, 1)]]
P44S = [[(0, 2), (2, 2)], [(0, 3), (3, 1)], [(0, 1.5), (1.5, 2.5)], [(0, 4)]]
P34 = [[(0, 1), (1, 1), (2, 1)], [(0, 2), (2, 1)], [(0, 1.5), (1.5, .5), (2, 1)]]


def mus001():
    prog = ['Dm', 'Bb', 'F', 'C'] * 2 + ['Gm', 'Bb', 'F', 'C'] + ['Bb', 'C', 'Dm', 'Dm']
    s = Song(88, 4, 16, 2.4, 101)
    for nm, p, lv, sd in (('lead', 0.05, 0.9, 0.3), ('arp', -0.2, 0.6, 0.35), ('pad', 0.0, 0.6, 0.5), ('bass', 0.0, 0.8, 0.05), ('drums', 0.0, 0.5, 0.2), ('bells', 0.3, 0.4, 0.7)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 2, 'minor', 4, P44, 11, 62, 81), flute, 0.8)
    arp_events(s, 'arp', prog, 3, [0, 1, 2, 3, 2, 1, 2, 1], 0.5)
    pad_events(s, 'pad', prog, 3, 0.5)
    bass_events(s, 'bass', prog, 'half', 0.8)
    s.drums('drums', {'k': ['x.......x.......', 'x...x...x.......'], 'T': ['........X.......'], 'x': ['..x...x...x...x.']}, (4, 16))
    s.hit('drums', 'T', 15 * 4 + 3, 0.9)
    for bar in range(0, 16, 2):
        s.note('bells', belln, bar * 4 + 2, chord(prog[bar], 5)[2], 1.5, 0.5)
    return finish(s)


def mus002():
    prog = ['G', 'Em', 'C', 'D', 'G', 'Em', 'C', 'D', 'C', 'G', 'D', 'G', 'Am', 'D', 'G', 'G']
    s = Song(104, 3, 16, 1.6, 102)
    for nm, p, lv, sd in (('lead', 0.1, 0.9, 0.2), ('gtr', -0.25, 0.7, 0.2), ('pad', 0.0, 0.3, 0.4), ('bass', 0.0, 0.7, 0.05), ('perc', 0.0, 0.3, 0.1)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 7, 'major', 3, P34, 21, 67, 83, 0.1), pluck, 0.7, 'lead', flute, 0.25)
    for bar, name in enumerate(prog):
        t = chord(name, 3)
        s.note('gtr', pluck, bar * 3, t[0], 0.9, 0.5)
        s.note('gtr', pluck, bar * 3 + 1, t[1] + 12, 0.9, 0.45)
        s.note('gtr', pluck, bar * 3 + 2, t[2] + 12, 0.9, 0.45)
    bass_events(s, 'bass', prog, 'waltz', 0.7)
    pad_events(s, 'pad', prog, 3, 0.4)
    for bar in range(4, 16):
        for i in range(3):
            s.hit('perc', 'x', bar * 3 + i, 0.8 if i == 0 else 0.5)
    return finish(s)


def mus003():
    prog = ['Am', 'G', 'Am', 'G', 'F', 'C', 'G', 'Am', 'Am', 'G', 'F', 'G', 'F', 'G', 'Am', 'Am']
    s = Song(104, 4, 16, 2.2, 103)
    for nm, p, lv, sd in (('lead', 0.15, 0.8, 0.4), ('arp', -0.25, 0.65, 0.4), ('pad', 0.0, 0.5, 0.5), ('bass', 0.0, 0.7, 0.05), ('perc', 0.0, 0.4, 0.2), ('bells', 0.35, 0.4, 0.7)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 9, 'dorian', 4, P44, 31, 64, 83, 0.2), flute, 0.7)
    arp_events(s, 'arp', prog, 3, [0, 1, 2, 3, 2, 1, 0, 1], 0.5, True, 0.55)
    pad_events(s, 'pad', prog, 3, 0.4)
    bass_events(s, 'bass', prog, 'half', 0.7)
    s.drums('perc', {'x': ['x.x.x.x.x.x.x.x.'], 'k': ['x.......x.......'], 'h': ['..x...x...x...x.']}, (2, 16))
    for bar in range(0, 16, 4):
        s.note('bells', belln, bar * 4, chord(prog[bar], 5)[0], 2, 0.5)
        s.note('bells', belln, bar * 4 + 2, chord(prog[bar], 5)[2], 2, 0.45)
    return finish(s)


def mus004():
    prog = ['Em', 'Em', 'Cmaj7', 'Em', 'Am', 'Em', 'B7', 'Em', 'Cmaj7', 'D', 'Em', 'Em']
    s = Song(64, 4, 12, 3.4, 104)
    for nm, p, lv, sd in (('lead', 0.15, 0.7, 0.7), ('pad', 0.0, 0.9, 0.5), ('choir', 0.0, 0.5, 0.6), ('bass', 0.0, 0.8, 0.1), ('perc', 0.0, 0.5, 0.6), ('bells', -0.3, 0.5, 0.8)):
        s.bus(nm, p, lv, sd)
    pad_events(s, 'pad', prog, 3, 0.7, pad, 4)
    pad_events(s, 'choir', prog, 4, 0.4, choir, 3)
    bass_events(s, 'bass', prog, 'pedal', 0.7)
    lead_events(s, 'lead', melody(prog, 4, 'harmonic', 4, P44S, 41, 64, 84, 0.25), belln, 0.7)
    for bar in range(0, 12, 4):
        s.hit('perc', 'T', bar * 4 + 3, 0.6)
        s.hit('perc', 't', bar * 4 + 3.5, 0.5)
    return finish(s)


def mus005():
    prog = ['Em', 'F', 'Em', 'F', 'Em', 'F', 'G', 'F', 'Em', 'F', 'Em', 'Bb', 'F', 'G', 'F', 'Em']
    s = Song(142, 4, 16, 1.6, 105)
    for nm, p, lv, sd in (('lead', 0.1, 0.8, 0.2), ('stab', -0.2, 0.7, 0.2), ('pad', 0.0, 0.4, 0.3), ('bass', 0.0, 0.9, 0.0), ('drums', 0.0, 0.8, 0.15)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 4, 'phrygian', 4, P44, 51, 59, 79, 0.0), brass, 0.65)
    for bar, name in enumerate(prog):
        for beat in (0, 1.5, 2.5):
            for m in chord(name, 3)[:3]:
                s.note('stab', brass, bar * 4 + beat, m, 0.4, 0.3)
    pad_events(s, 'pad', prog, 3, 0.4, pad, 3)
    bass_events(s, 'bass', prog, 'eighths', 0.8)
    s.drums('drums', {'k': ['x..x..x...x.x...', 'x..x..x...x...x.'], 's': ['....x.......x...'], 'h': ['x.x.x.x.x.x.x.x.'], 'T': ['x...............']})
    for bar in (7, 15):
        for i, f in enumerate((220, 180, 150, 120)):
            s.hit('drums', 't', bar * 4 + 3 + i * 0.25, 0.8)
    s.hit('drums', 'c', 0, 0.8)
    s.hit('drums', 'c', 8 * 4, 0.8)
    return finish(s)


def mus006():
    prog = ['Fmaj7', 'G', 'Am7', 'Fmaj7', 'Bbmaj7', 'G', 'Am7', 'Fmaj7', 'Dm7', 'G', 'Am7', 'Fmaj7']
    s = Song(72, 4, 12, 3.0, 106)
    for nm, p, lv, sd in (('lead', 0.1, 0.7, 0.6), ('arp', -0.2, 0.7, 0.6), ('pad', 0.0, 0.6, 0.5), ('bass', 0.0, 0.5, 0.1), ('bells', 0.3, 0.4, 0.8)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 5, 'lydian', 4, P44S + P44[:1], 61, 65, 84, 0.2), flute, 0.6)
    arp_events(s, 'arp', prog, 3, [0, 1, 2, 3, 2, 1, 2, 3], 0.5, True, 0.55)
    pad_events(s, 'pad', prog, 3, 0.6, pad, 4)
    bass_events(s, 'bass', prog, 'half', 0.5)
    for bar in range(0, 12, 3):
        s.note('bells', belln, bar * 4 + 1, chord(prog[bar], 5)[2], 2, 0.45)
    return finish(s)


def mus007():
    prog = ['Dm', 'Bb', 'Gm', 'A', 'Dm', 'Bb', 'Gm', 'A', 'Bb', 'C', 'Dm', 'Bb', 'Gm', 'A', 'Dm', 'A']
    s = Song(150, 4, 16, 2.4, 107)
    for nm, p, lv, sd in (('lead', 0.1, 0.8, 0.3), ('choir', 0.0, 0.7, 0.5), ('stab', -0.25, 0.6, 0.2), ('bass', 0.0, 0.9, 0.0), ('drums', 0.0, 0.85, 0.15), ('bells', 0.35, 0.4, 0.7)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 2, 'harmonic', 4, P44, 71, 62, 81, 0.0), brass, 0.65)
    pad_events(s, 'choir', prog, 4, 0.8, choir, 3)
    for bar, name in enumerate(prog):
        for beat in (0, 0.75, 1.5, 2.5, 3):
            s.note('stab', brass, bar * 4 + beat, chord(name, 3)[0] + 12, 0.35, 0.3)
    bass_events(s, 'bass', prog, 'eighths', 0.85)
    s.drums('drums', {'k': ['x.x.x...x.x.x...', 'x.x.x...x.x...x.'], 's': ['....x.......x...'], 'h': ['xxxxxxxxxxxxxxxx'], 'T': ['x.......x.......']})
    for bar in range(0, 16, 4):
        s.hit('drums', 'c', bar * 4, 0.9)
    for bar in range(0, 16, 2):
        for i, idx in enumerate((0, 1, 2, 3, 2, 1, 2, 3)):
            s.note('bells', belln, bar * 4 + i * 0.5, chord(prog[bar], 5)[idx % 3], 0.5, 0.35)
    return finish(s)


def mus008():
    prog = ['D', 'Bm', 'G', 'A', 'D', 'Bm', 'G', 'A', 'Em', 'A', 'D', 'D']
    s = Song(70, 4, 12, 3.2, 108)
    for nm, p, lv, sd in (('lead', 0.1, 0.8, 0.5), ('arp', -0.2, 0.65, 0.5), ('pad', 0.0, 0.6, 0.5), ('choir', 0.0, 0.5, 0.6), ('bass', 0.0, 0.5, 0.1), ('bells', 0.3, 0.4, 0.8)):
        s.bus(nm, p, lv, sd)
    lead_events(s, 'lead', melody(prog, 2, 'major', 4, P44, 11, 66, 85, 0.1), flute, 0.8)
    arp_events(s, 'arp', prog, 3, [0, 1, 2, 3, 2, 1, 2, 1], 0.5, True, 0.5)
    pad_events(s, 'pad', prog, 3, 0.55, pad, 3)
    pad_events(s, 'choir', prog, 4, 0.5, choir, 3)
    bass_events(s, 'bass', prog, 'half', 0.5)
    for bar in range(1, 12, 2):
        s.note('bells', belln, bar * 4, chord(prog[bar], 5)[2], 2, 0.5)
    return finish(s)


MUSIC = {
    'AUD-MUS-001': ('Main theme', mus001, 'D minor, 88 BPM, 16 bars: flute theme over harp arpeggios, pad, soft taiko and bell accents.'),
    'AUD-MUS-002': ('Village theme', mus002, 'G major waltz, 104 BPM, 16 bars: plucked melody and guitar-style accompaniment.'),
    'AUD-MUS-003': ('Forest exploration', mus003, 'A dorian, 104 BPM, 16 bars: light shaker pulse, harp arpeggios and sparse flute.'),
    'AUD-MUS-004': ('Temple exploration', mus004, 'E harmonic minor, 64 BPM, 12 bars: pads, soft choir, bell melody and distant drums.'),
    'AUD-MUS-005': ('Boss battle', mus005, 'E phrygian, 142 BPM, 16 bars: driving drums, 8th-note bass and brass stabs.'),
    'AUD-MUS-006': ('Stillmere theme', mus006, 'F lydian, 72 BPM, 12 bars: calm harp, flute and pad with no drums.'),
    'AUD-MUS-007': ('Final boss theme', mus007, 'D harmonic minor, 150 BPM, 16 bars: choir pad, brass, dense drums and bell runs.'),
    'AUD-MUS-008': ('Ending theme', mus008, 'D major, 70 BPM, 12 bars: warm resolved reprise with flute, harp and choir.'),
}
