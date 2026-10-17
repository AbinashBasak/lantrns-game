"""Procedural audio synthesis primitives (numpy/scipy). Mono arrays unless noted; stereo is (n, 2)."""
import numpy as np
from scipy import signal

SR = 44100


def N(d):
    return int(round(d * SR))


def tt(n):
    return np.arange(n) / SR


def white(n, rng):
    return rng.standard_normal(n)


def colored(n, rng, power):
    spec = np.fft.rfft(rng.standard_normal(n))
    f = np.fft.rfftfreq(n, 1 / SR)
    f[0] = f[1]
    x = np.fft.irfft(spec / f ** (power / 2), n)
    return x / (np.max(np.abs(x)) + 1e-9)


def pink(n, rng):
    return colored(n, rng, 1.0)


def brown(n, rng):
    return colored(n, rng, 2.0)


def _sos(kind, f, order):
    nyq = SR / 2
    f = np.clip(np.asarray(f, dtype=float), 20, nyq * 0.98)
    return signal.butter(order, f / nyq, btype=kind, output='sos')


def lp(x, f, order=2):
    return signal.sosfilt(_sos('low', f, order), x)


def hp(x, f, order=2):
    return signal.sosfilt(_sos('high', f, order), x)


def bp(x, lo, hi, order=2):
    return signal.sosfilt(_sos('band', [lo, hi], order), x)


def sweep(x, kind, f0, f1, bw=0.6, block=512):
    """Band/low/high-pass with cutoff moving geometrically from f0 to f1."""
    out = np.zeros_like(x)
    nb = -(-len(x) // block)
    zi = None
    for b in range(nb):
        f = f0 * (f1 / f0) ** (b / max(nb - 1, 1))
        sos = _sos('band', [f / (1 + bw), f * (1 + bw)], 2) if kind == 'band' else _sos(kind, f, 2)
        seg = x[b * block:(b + 1) * block]
        if zi is None:
            zi = np.zeros((sos.shape[0], 2))
        seg_out, zi = signal.sosfilt(sos, seg, zi=zi)
        out[b * block:(b + 1) * block] = seg_out
    return out


def expdec(n, tau, attack=0.002):
    t = tt(n)
    e = np.exp(-t / tau)
    a = np.clip(t / max(attack, 1e-4), 0, 1)
    return e * a


def adsr(n, a, d, s, r):
    t = tt(n)
    dur = n / SR
    e = np.where(t < a, t / max(a, 1e-4), np.where(t < a + d, 1 - (1 - s) * (t - a) / max(d, 1e-4), s))
    rel = np.clip((dur - t) / max(r, 1e-4), 0, 1)
    return e * rel


def glide(f0, f1, n, curve='exp'):
    t = np.linspace(0, 1, n)
    return f0 * (f1 / f0) ** t if curve == 'exp' else f0 + (f1 - f0) * t


def osc(freq, n, shape='sine', phase=0.0):
    f = np.broadcast_to(np.asarray(freq, dtype=float), (n,))
    ph = 2 * np.pi * np.cumsum(f) / SR + phase
    if shape == 'sine':
        return np.sin(ph)
    if shape == 'tri':
        return 2 / np.pi * np.arcsin(np.sin(ph))
    if shape == 'saw':
        return lp(2 * ((ph / (2 * np.pi)) % 1) - 1, 9000)
    if shape == 'square':
        return lp(np.sign(np.sin(ph)), 9000)
    raise ValueError(shape)


def harmonics(f, n, amps, decays=None, detune=0.0):
    t = tt(n)
    out = np.zeros(n)
    for h, a in enumerate(amps, 1):
        fh = f * h * (1 + detune)
        if fh > 16000:
            break
        env = np.exp(-t * decays[h - 1]) if decays is not None else 1.0
        out += a * np.sin(2 * np.pi * fh * t) * env
    return out


def fit(x, n):
    if len(x) >= n:
        return x[:n]
    return np.concatenate([x, np.zeros(n - len(x))])


def peak_norm(x, db=-1.0):
    p = np.max(np.abs(x)) + 1e-9
    return x * (10 ** (db / 20) / p)


def fade(x, fin=0.003, fout=0.01):
    x = x.copy()
    a, b = N(fin), N(fout)
    if a:
        x[:a] *= np.linspace(0, 1, a)[:, None] if x.ndim == 2 else np.linspace(0, 1, a)
    if b:
        x[-b:] *= np.linspace(1, 0, b)[:, None] if x.ndim == 2 else np.linspace(1, 0, b)
    return x


def reverb(x, rt=1.5, wet=0.25, seed=0, damp=5000):
    """Noise-IR reverb; mono -> stereo, stereo -> stereo."""
    rng = np.random.default_rng(seed)
    n = N(rt * 1.2)
    t = tt(n)
    irs = []
    for _ in range(2):
        ir = lp(rng.standard_normal(n), damp) * np.exp(-6.9 * t / rt)
        ir[:N(0.012)] *= np.linspace(0, 1, N(0.012))
        irs.append(ir / np.sqrt(np.sum(ir ** 2)))
    chans = [x, x] if x.ndim == 1 else [x[:, 0], x[:, 1]]
    w = np.stack([signal.fftconvolve(chans[i], irs[i]) for i in range(2)], axis=1)
    dry = np.stack(chans, axis=1)
    dry = np.pad(dry, ((0, len(w) - len(dry)), (0, 0)))
    return dry * (1 - wet * 0.5) + w * wet


def pan(x, p):
    """p in [-1, 1]; returns (n, 2) equal-power."""
    a = (p + 1) * np.pi / 4
    return np.stack([x * np.cos(a), x * np.sin(a)], axis=1)


def to_stereo(x):
    return np.stack([x, x], axis=1) if x.ndim == 1 else x


def add(buf, sig, start, gain=1.0, wrap=False):
    """Mix sig into buf at start seconds; wrap folds overflow around the loop point."""
    i = N(start)
    sig = sig * gain
    if sig.ndim == 1 and buf.ndim == 2:
        sig = np.stack([sig, sig], axis=1)
    L = len(buf)
    while len(sig):
        i %= L if wrap else L + 1
        take = min(len(sig), L - i)
        if take <= 0:
            break
        buf[i:i + take] += sig[:take]
        sig = sig[take:]
        if not wrap:
            break
        i = 0
    return buf


def loopify(x, length, xfade):
    """Make a seamless loop of `length` samples from a longer bed by equal-power crossfade."""
    head, tail = x[:xfade], x[length:length + xfade]
    t = np.linspace(0, 1, xfade)
    if x.ndim == 2:
        t = t[:, None]
    out = x[:length].copy()
    out[:xfade] = head * np.sin(t * np.pi / 2) + tail * np.cos(t * np.pi / 2)
    return out


def fold(buf, length):
    """Fold anything past `length` back onto the start (circular add)."""
    out = buf[:length].copy()
    rest = buf[length:]
    while len(rest):
        take = min(len(rest), length)
        out[:take] += rest[:take]
        rest = rest[take:]
    return out


def mtof(m):
    return 440.0 * 2 ** ((np.asarray(m) - 69) / 12)


def reverb_wet(x, rt=1.5, seed=0, damp=5000):
    """Wet-only noise-IR reverb for send buses; always returns (n + ir, 2)."""
    return reverb(x, rt, 2.0, seed, damp)
