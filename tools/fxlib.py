"""Procedural 2D effect renderer: supersampled premultiplied-alpha canvas with soft primitives."""
import math
import numpy as np
from PIL import Image, ImageDraw

SS = 4


def rgb(h):
    h = h.lstrip('#')
    return np.array([int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)], dtype=np.float32)


def lerp(a, b, t):
    return a + (b - a) * t


def clamp01(v):
    return np.clip(v, 0, 1)


def ease_out(t):
    return 1 - (1 - t) ** 3


def ease_in(t):
    return t ** 3


def smooth(t):
    t = min(max(t, 0.0), 1.0)
    return t * t * (3 - 2 * t)


class Canvas:
    def __init__(self, w, h):
        self.w, self.h = w, h
        self.arr = np.zeros((h * SS, w * SS, 4), dtype=np.float32)
        yy, xx = np.mgrid[0:h * SS, 0:w * SS].astype(np.float32)
        self.xx, self.yy = (xx + 0.5) / SS, (yy + 0.5) / SS

    def _box(self, x, y, rx, ry):
        x0 = max(int((x - rx) * SS), 0)
        x1 = min(int((x + rx) * SS) + 1, self.w * SS)
        y0 = max(int((y - ry) * SS), 0)
        y1 = min(int((y + ry) * SS) + 1, self.h * SS)
        return slice(y0, y1), slice(x0, x1)

    def put(self, mask, color, alpha=1.0, add=False, box=None):
        sl = box or (slice(None), slice(None))
        m = np.clip(mask, 0, 1) * alpha
        c = rgb(color) if isinstance(color, str) else np.asarray(color, dtype=np.float32)
        a = self.arr[sl]
        if add:
            a[..., :3] += c * m[..., None]
            a[..., 3] = np.minimum(a[..., 3] + m, 1)
        else:
            a[..., :3] = c * m[..., None] + a[..., :3] * (1 - m[..., None])
            a[..., 3] = m + a[..., 3] * (1 - m)

    def blob(self, x, y, r, color, alpha=1.0, p=2.0, add=False, sx=1.0, sy=1.0):
        if r <= 0 or alpha <= 0:
            return
        box = self._box(x, y, r * sx, r * sy)
        d = np.hypot((self.xx[box] - x) / (r * sx), (self.yy[box] - y) / (r * sy))
        self.put(clamp01(1 - d) ** p, color, alpha, add, box)

    def disc(self, x, y, r, color, alpha=1.0, edge=0.6, sx=1.0, sy=1.0):
        box = self._box(x, y, r * sx + 2, r * sy + 2)
        d = np.hypot((self.xx[box] - x) / sx, (self.yy[box] - y) / sy)
        self.put(clamp01((r - d) / edge), color, alpha, False, box)

    def capsule(self, x0, y0, x1, y1, width, color, alpha=1.0, p=1.5, add=False, w1=None):
        w1 = width if w1 is None else w1
        pad = max(width, w1) / 2 + 1
        box = self._box((x0 + x1) / 2, (y0 + y1) / 2, abs(x1 - x0) / 2 + pad, abs(y1 - y0) / 2 + pad)
        px, py = self.xx[box] - x0, self.yy[box] - y0
        vx, vy = x1 - x0, y1 - y0
        L2 = vx * vx + vy * vy or 1e-6
        s = np.clip((px * vx + py * vy) / L2, 0, 1)
        d = np.hypot(px - s * vx, py - s * vy)
        hw = (lerp(width, w1, s)) / 2
        self.put(clamp01(1 - d / np.maximum(hw, 1e-3)) ** p, color, alpha, add, box)

    def polyline(self, pts, width, color, alpha=1.0, p=1.5, upto=1.0, add=False):
        segs = list(zip(pts[:-1], pts[1:]))
        lens = [math.dist(a, b) for a, b in segs]
        total = sum(lens) * upto
        run = 0
        for (a, b), L in zip(segs, lens):
            if run >= total:
                break
            f = min(1.0, (total - run) / L) if L else 1.0
            self.capsule(a[0], a[1], lerp(a[0], b[0], f), lerp(a[1], b[1], f), width, color, alpha, p, add)
            run += L

    def ring(self, x, y, r, width, color, alpha=1.0, p=1.5, sx=1.0, sy=1.0, a0=None, a1=None, taper=False, add=False):
        pad = width + 2
        box = self._box(x, y, r * sx + pad, r * sy + pad)
        dx, dy = (self.xx[box] - x) / sx, (self.yy[box] - y) / sy
        d = np.hypot(dx, dy)
        hw = np.full_like(d, width / 2)
        if a0 is not None:
            th = np.arctan2(dy, dx)
            span = a1 - a0
            u = ((th - a0) % (2 * math.pi)) / (2 * math.pi)
            inside = u <= (span / (2 * math.pi))
            uu = np.where(inside, u / max(span / (2 * math.pi), 1e-6), 0)
            hw = hw * (uu ** 0.8 if taper else 1.0) * inside
        self.put(clamp01(1 - np.abs(d - r) / np.maximum(hw, 1e-3)) ** p * (hw > 1e-3), color, alpha, add, box)

    def star(self, x, y, r, color, alpha=1.0, spikes=4, sharp=3.0, rot=0.0, add=False, core=0.28):
        box = self._box(x, y, r, r)
        dx, dy = self.xx[box] - x, self.yy[box] - y
        d = np.hypot(dx, dy)
        th = np.arctan2(dy, dx) - rot
        lobe = np.abs(np.cos(spikes * th / 2)) ** sharp
        lim = r * (core + (1 - core) * lobe)
        self.put(clamp01(1 - d / np.maximum(lim, 1e-3)) ** 1.6, color, alpha, add, box)

    def poly(self, pts, color, alpha=1.0, edge=0.5):
        xs, ys = [p[0] for p in pts], [p[1] for p in pts]
        box = self._box((min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2, (max(xs) - min(xs)) / 2 + 2, (max(ys) - min(ys)) / 2 + 2)
        h = box[0].stop - box[0].start
        w = box[1].stop - box[1].start
        if w <= 0 or h <= 0:
            return
        im = Image.new('L', (w, h), 0)
        ImageDraw.Draw(im).polygon([((px * SS) - box[1].start, (py * SS) - box[0].start) for px, py in pts], fill=255)
        self.put(np.asarray(im, dtype=np.float32) / 255, color, alpha, False, box)

    def image(self):
        a = self.arr.reshape(self.h, SS, self.w, SS, 4).mean(axis=(1, 3))
        al = a[..., 3:4]
        rgbs = np.where(al > 1e-4, a[..., :3] / np.maximum(al, 1e-4), 0)
        out = np.concatenate([np.clip(rgbs, 0, 1), np.clip(al, 0, 1)], axis=-1)
        return Image.fromarray((out * 255 + 0.5).astype(np.uint8), 'RGBA')
