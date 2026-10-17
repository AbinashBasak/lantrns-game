"""Phase 07 effect definitions. Each render(i, n) returns one RGBA frame; palette follows ART-002 section 7."""
import math
import random
import numpy as np
from fxlib import Canvas, lerp, clamp01, ease_out, ease_in, smooth

CY, BL, ICE = '#7EE0FF', '#3A7BFF', '#E8FBFF'
GOLD, ORG, CREAM = '#FFE27A', '#FF9D3A', '#FFFBE0'
WARM, FIRE = '#FFE7A3', '#F06C4A'
DUST, DUST_L, DUST_D = '#C4B69A', '#E6DCC4', '#A89F8D'
EARTH, EARTH_D = '#8A6F4E', '#5C472F'
STONE, STONE_L, STONE_D = '#6B6E72', '#8D8F95', '#3A2E1F'
RUNE, RUNE_D = '#6FE8FF', '#2E7BFF'
CORE, CORE_L = '#5BD6FF', '#B8F5FF'
LEAF, LEAF_D, EMBER = '#8FA36B', '#3A4D3A', '#FFB347'
TAU = math.tau


def polar(cx, cy, r, th):
    return cx + r * math.cos(th), cy + r * math.sin(th)


def fx001(i, n):
    c = Canvas(192, 192)
    cx, cy, R = 80, 120, 78
    head = -140 + 168 * ease_out(min(1, (i + 1) / 4))
    tail = head - 110 * min(1, (i + 1) / 3) if i < 4 else lerp(head - 110, head - 8, smooth((i - 3) / 2))
    fade = 1 if i <= 3 else max(0.0, 1 - (i - 3) * 0.38)
    a0, a1 = math.radians(tail) % TAU, math.radians(head) % TAU
    a1 = a0 + ((a1 - a0) % TAU)
    c.ring(cx, cy, R, 44, BL, 0.6 * fade, 1.0, a0=a0, a1=a1, taper=True, add=True)
    c.ring(cx, cy, R, 28, CY, 0.95 * fade, 0.55, a0=a0, a1=a1, taper=True, add=True)
    c.ring(cx, cy, R, 12, ICE, fade, 0.6, a0=a0, a1=a1, taper=True, add=True)
    c.ring(cx, cy, R + 15, 3, CY, 0.5 * fade, 1.5, a0=a0 + (a1 - a0) * 0.45, a1=a1, taper=True, add=True)
    hx, hy = polar(cx, cy, R, math.radians(head))
    c.star(hx, hy, 15 * fade + 2, ICE, 0.9 * fade, 4, 3, add=True)
    return c.image()


def fx002(i, n):
    c = Canvas(128, 128)
    rng = random.Random(2)
    t = i / (n - 1) * 0.92
    for k in range(14):
        th = TAU * k / 14 + rng.uniform(-0.2, 0.2)
        v, L = rng.uniform(24, 52), rng.uniform(14, 34)
        r = v * ease_out(t) + 6
        r0 = max(r - L * (1 - t * 0.6), 2)
        x0, y0, x1, y1 = *polar(64, 64, r0, th), *polar(64, 64, r, th)
        fade = (1 - t) ** 0.7
        c.capsule(x0, y0, x1, y1, 5, ORG, 0.7 * fade, 1.4, True, w1=2)
        c.capsule(x0, y0, x1, y1, 2.6, GOLD, fade, 1.3, True, w1=1.2)
        c.capsule(x0, y0, x1, y1, 1.1, CREAM, fade, 1.2, True, w1=0.6)
    for k in range(8):
        th = TAU * k / 8 + rng.uniform(-0.3, 0.3)
        v = rng.uniform(18, 40)
        x, y = polar(64, 64, v * ease_out(t) + 8, th)
        c.blob(x, y + 12 * t * t, 3.2 * (1 - t) + 0.6, GOLD, 1 - t, 1.2, True)
    if i < 4:
        c.blob(64, 64, lerp(34, 12, t), GOLD, (1 - t) ** 1.4, 2, True)
        c.star(64, 64, 30 * (1 - t) + 8, CREAM, 0.9 * (1 - t), 8, 3, add=True)
    return c.image()


def fx003(i, n):
    c = Canvas(128, 128)
    s, a = [0.55, 1.0, 0.8, 0.45][i], [1, 1, 0.75, 0.35][i]
    c.blob(64, 64, 34 * s, '#FFFFFF', 0.55 * a, 1.6, True)
    c.star(64, 64, 56 * s, GOLD, 0.8 * a, 4, 4, add=True)
    c.star(64, 64, 52 * s, '#FFFFFF', a, 4, 4, add=True, core=0.2)
    c.star(64, 64, 36 * s, '#FFFFFF', 0.9 * a, 4, 4, math.pi / 4, True, 0.2)
    c.ring(64, 64, 28 * s * (1 + 0.15 * i), 3, CREAM, 0.6 * a, 1.4, add=True)
    return c.image()


def fx004(i, n):
    c = Canvas(192, 192)
    rng = random.Random(4)
    t = i / (n - 1) * 0.92
    for k in range(6):
        ang = TAU * k / 6 + rng.uniform(-0.4, 0.4)
        r = lerp(12, 40, ease_out(t))
        x, y = polar(96, 92, r * 0.8, ang)
        c.blob(x, y - 6 * t, r * 0.55, LEAF_D if k % 2 else LEAF, 0.55 * (1 - t) ** 1.2, 0.9)
    if i < 2:
        c.blob(96, 92, 40 - 10 * i, GOLD, 0.7 - 0.3 * i, 2, True)
    for k in range(12):
        ang = TAU * k / 12 + rng.uniform(-0.25, 0.25)
        v, size = rng.uniform(28, 56), rng.uniform(8, 13)
        spin = rng.uniform(-4, 4)
        x, y = polar(96, 92, v * ease_out(t) + 4, ang)
        y += 24 * t * t
        al = 1 - smooth((t - 0.55) / 0.45)
        pts = [polar(x, y, size * f, spin * t + g) for f, g in ((1, 0), (0.55, 2.3), (0.9, 4.2))]
        c.poly(pts, LEAF_D, al)
        c.poly([polar(x, y, size * 0.6 * f, spin * t + g) for f, g in ((1, 0.2), (0.55, 2.4), (0.9, 4.3))], LEAF, al * 0.9)
    for k in range(10):
        ang = TAU * k / 10 + rng.uniform(-0.3, 0.3)
        x, y = polar(96, 92, 30 * ease_out(t) + 4, ang)
        c.blob(x, y - 26 * t, 10 * (1 - t * 0.5), EMBER if k % 2 else GOLD, 0.95 * (1 - t) ** 0.8, 1.6, True)
    return c.image()


def _puff(c, x, y, r, a, col=DUST, light=DUST_L, shade=DUST_D, sy=1.0):
    c.blob(x - r * 0.12, y + r * 0.1, r, shade, a * 0.8, 0.7, sy=sy)
    c.blob(x, y, r * 0.92, col, a, 0.7, sy=sy)
    c.blob(x + r * 0.25, y - r * 0.25 * sy, r * 0.5, light, a * 0.7, 1.0, sy=sy)


def fx005(i, n):
    c = Canvas(96, 96)
    t = (i + 0.5) / n
    for k, (dx, delay) in enumerate(((0, 0), (-11, 0.1), (-21, 0.2))):
        ti = min(max((t - delay) / (1 - delay), 0), 1)
        r = lerp(7, 21, ease_out(ti))
        _puff(c, 68 + dx - 14 * ease_out(ti), 82 - 7 * ti - r * 0.3, r, (1 - ti) ** 1.1)
    return c.image()


def fx006(i, n):
    c = Canvas(128, 128)
    t = (i + 0.5) / n
    for side in (-1, 1):
        for j, (off, rr) in enumerate(((0, 1), (-8, 0.7), (8, 0.6))):
            r = lerp(10, 26, t) * rr
            _puff(c, 64 + side * (lerp(8, 38, ease_out(t)) + off * t), 104 - r * 0.45 - 8 * t, r, (1 - t) ** 1.1, sy=0.8)
    c.ring(64, 105, lerp(10, 50, ease_out(t)), 4, DUST_L, 0.85 * (1 - t), 1.5, sy=0.2)
    if i < 4:
        for k in range(3):
            c.blob(64 + (k - 1) * 9, 98 - 22 * t - k * 3, 5 * (1 - t * 0.6), DUST_L, 0.6 * (1 - t), 0.9)
    return c.image()


def fx007(i, n):
    c = Canvas(192, 128)
    rng = random.Random(7)
    t = (i + 0.5) / n
    for side in (-1, 1):
        for off, rr in ((0, 1), (-14, 0.75), (14, 0.65), (-26, 0.5)):
            r = lerp(9, 22, ease_out(t)) * rr
            _puff(c, 96 + side * (lerp(10, 56, ease_out(t)) + off * 0.5 * t), 108 - r * 0.45 - 10 * t, r, (1 - t) ** 1.1 * 0.9, sy=0.8)
    c.ring(96, 109, lerp(12, 84, ease_out(t)), 4, DUST_L, 0.75 * (1 - t), 1.5, sy=0.18)
    for k in range(6):
        d = (k - 2.5) / 2.5
        x = 96 + d * 60 * ease_out(t)
        y = 106 - 30 * rng.uniform(0.6, 1) * 4 * t * (1 - t)
        c.disc(x, y, 2.2, DUST_D, 1 - t, 0.8)
    return c.image()


def fx008(i, n):
    c = Canvas(128, 192)
    rng = random.Random(8)
    t = 0.08 + 0.84 * i / (n - 1)
    for k in range(5):
        x0 = rng.uniform(26, 102)
        size, spin, delay = rng.uniform(8, 15), rng.uniform(-5, 5), rng.uniform(0, 0.4)
        ti = min(max((t * 1.2 - delay) / 0.8, 0), 1)
        y = -2 + 204 * ti * ti
        x = x0 + 8 * math.sin(k + ti * 3)
        al = 1 - smooth((t - 0.75) / 0.25)
        for j in range(1, 4):
            yt = -12 + 214 * max(ti - j * 0.06, 0) ** 2
            c.blob(x, yt, 5 * (1 - j * 0.2), DUST, 0.35 * al * (1 - j * 0.25), 1.0)
        base = [(1, 0.2), (0.8, 1.4), (1.05, 2.5), (0.7, 3.6), (0.95, 4.9)]
        pts = [polar(x, y, size * f, g + spin * ti) for f, g in base]
        c.poly(pts, STONE_D, al)
        c.poly([polar(x - 1, y - 1, size * f * 0.82, g + spin * ti) for f, g in base], STONE, al)
        c.poly([polar(x - size * 0.2, y - size * 0.25, size * f * 0.4, g + spin * ti) for f, g in base[:3]], STONE_L, al * 0.8)
    return c.image()


def fx009(i, n):
    c = Canvas(256, 256)
    rng = random.Random(9)
    t = i / n
    p = 0.5 + 0.5 * math.sin(TAU * t)
    c.blob(128, 128, 112, ORG, 0.2 + 0.1 * p, 2.0, True)
    c.blob(128, 128, 78, GOLD, 0.4 + 0.12 * p, 2.2, True)
    c.blob(128, 128, 34 + 3 * p, CREAM, 0.8, 2.5, True)
    for k in range(2):
        u = (t + k / 2) % 1
        c.ring(128, 128, 30 + 92 * u, 5 - 3 * u, WARM, 0.55 * (1 - u) ** 1.5 * smooth(u * 6), 1.4, add=True)
    for k in range(7):
        ph, x = rng.random(), 128 + rng.uniform(-48, 48)
        u = (t + ph) % 1
        c.blob(x + 5 * math.sin(TAU * (u + ph)), 168 - 110 * u, 4.5, GOLD, math.sin(math.pi * u), 1.8, True)
    return c.image()


def fx010(i, n):
    c = Canvas(128, 128)
    t = i / n
    p = 0.5 + 0.5 * math.sin(TAU * t)
    c.blob(64, 64, 46 + 6 * p, CY, 0.35, 2.0, True)
    c.blob(64, 64, 27 + 3 * p, CORE_L, 0.55, 2.0, True)
    c.star(64, 64, 36 + 6 * p, CORE_L, 0.7, 4, 3, t * math.pi / 2, True)
    c.blob(64, 64, 12, '#FFF9E3', 0.95, 1.4, True)
    for k in range(3):
        th = TAU * t + TAU * k / 3
        for tr in range(4):
            x, y = polar(64, 64, 38, th - tr * 0.13)
            c.blob(x, y, 3.2 - tr * 0.6, ICE, 0.9 - tr * 0.22, 1.5, True)
    return c.image()


def fx011(i, n):
    c = Canvas(192, 192)
    rng = random.Random(11)
    prog = smooth(i / 5)
    inten = [0.25, 0.4, 0.55, 0.7, 0.85, 1.0, 0.9, 0.8][i]
    diamond = [(96, 40), (122, 96), (96, 152), (70, 96), (96, 40)]
    c.blob(96, 100, 80, RUNE_D, 0.25 * inten, 2, True)
    for lw, col, al, p in ((12, RUNE_D, 0.45, 1.5), (4.5, RUNE, 0.95, 1.4), (1.8, ICE, 1.0, 1.2)):
        c.ring(96, 96, 70, lw, col, al * inten, p, a0=-math.pi / 2, a1=-math.pi / 2 + TAU * max(prog, 0.02), add=True)
        c.polyline(diamond, lw, col, al * inten, p, prog, True)
        c.polyline([(96, 58), (96, 134)], lw * 0.8, col, al * inten, p, prog, True)
        c.polyline([(84, 96), (108, 96)], lw * 0.8, col, al * inten, p, prog, True)
    if i >= 4:
        c.blob(96, 96, 30 * inten, RUNE, 0.45, 2, True)
        c.star(96, 96, 54 * inten, ICE, 0.5 * inten, 4, 4, add=True)
    for k in range(9):
        x = 96 + rng.uniform(-48, 48)
        u = min(max((i - 3) / 4 + rng.uniform(-0.15, 0.15), 0), 1)
        c.blob(x, 150 - 70 * u, 3.4 * (1 - u * 0.5), RUNE, math.sin(math.pi * u) * 0.9, 1.6, True)
    return c.image()


def fx012(i, n):
    c = Canvas(256, 96)
    sweep = lerp(10, 262, ease_out(min(1, i / 6)))
    rev = 1.0 if i >= 6 else 0.0
    dx, dy = np.abs(c.xx - 128) - (100 - 6), np.abs(c.yy - 56) - (12 - 6)
    sdf = np.hypot(np.maximum(dx, 0), np.maximum(dy, 0)) + np.minimum(np.maximum(dx, dy), 0) - 6
    seen = clamp01((sweep - c.xx) / 6)
    if i == n - 1:
        seen = np.ones_like(seen)
    steady = 0.7 if i >= 6 else 1.0
    c.put(clamp01(-sdf / 2) * 0.28 * seen, RUNE_D, 1, True)
    c.put(clamp01(1 - np.abs(sdf) / 7) ** 2 * seen, RUNE_D, 0.55 * steady, True)
    c.put(clamp01(1 - np.abs(sdf) / 2.4) * seen, RUNE, 0.95, True)
    c.put(clamp01(1 - np.abs(sdf) / 1.0) * seen, ICE, 1.0, True)
    band = np.exp(-(((c.xx - sweep) / 12) ** 2)) * clamp01(1 - np.abs(sdf) / 14)
    if i < n - 1:
        c.put(band, ICE, 0.85, True)
    for k in range(5):
        x = 48 + k * 40
        lit = clamp01((sweep - x) / 20)
        c.blob(x, 56, 5 * lit + 0.1, RUNE, 0.9 * lit * steady, 1.5, True)
        c.disc(x, 56, 1.6 * lit, ICE, lit, 0.5)
    rng = random.Random(12)
    for k in range(10):
        x = 40 + rng.uniform(0, 176)
        u = min(max((i / (n - 1)) * 1.3 - rng.uniform(0, 0.5), 0), 1)
        if x < sweep:
            c.blob(x, 40 - 24 * u, 3 * (1 - u * 0.4), RUNE, math.sin(math.pi * u) * 0.85, 1.6, True)
    return c.image()


def fx013(i, n):
    c = Canvas(128, 128)
    rng = random.Random(13)
    t = (i + 0.5) / n
    f = (1 - t) ** 1.2
    c.blob(64, 70, lerp(18, 40, t), GOLD, 0.4 * f, 2, True)
    c.star(64, 70, lerp(20, 50, ease_out(min(1, t * 2))), GOLD, 0.9 * f, 4, 3, add=True)
    c.star(64, 70, lerp(12, 30, ease_out(min(1, t * 2))), CREAM, f, 4, 3, math.pi / 4, True, 0.2)
    c.ring(64, 70, lerp(8, 46, ease_out(t)), 3.5 * (1 - t) + 1, GOLD, 0.8 * f, 1.4, add=True)
    for k in range(7):
        th = TAU * k / 7 + rng.uniform(-0.3, 0.3)
        x, y = polar(64, 70, 12 + 30 * ease_out(t), th)
        c.blob(x, y - 22 * t, 5 * (1 - t) + 1, ['#FFE27A', '#F2C76B', CREAM][k % 3], f, 1.6, True)
    return c.image()


def fx014(i, n):
    c = Canvas(192, 256)
    rng = random.Random(14)
    a = smooth(i / 3) if i <= 3 else (1.0 if i <= 6 else max(0.0, 1 - (i - 6) / 3.2))
    h = 175 * ease_out(min(1, (i + 1) / 4))
    wid = (24 - 10 * clamp01((226 - c.yy) / 175)) * (0.6 + 0.4 * a)
    col = np.exp(-(((c.xx - 96) / wid) ** 2)) * clamp01((226 - c.yy) / h) ** 0 * clamp01(1 - (226 - c.yy) / h) ** 0.8 * (c.yy < 226)
    c.put(col, ORG, 0.45 * a, True)
    c.put(col ** 1.8, WARM, 0.85 * a, True)
    c.put(col ** 4, CREAM, 0.9 * a, True)
    c.blob(96, 224, 46, FIRE, 0.5 * a, 2, True, sy=0.45)
    c.blob(96, 224, 26, GOLD, 0.8 * a, 2, True, sy=0.45)
    for k in range(2):
        u = min(max(i / (n - 1) * 1.6 - k * 0.25, 0), 1)
        c.ring(96, 226, lerp(10, 64, ease_out(u)), 4 * (1 - u) + 1, WARM, 0.8 * (1 - u), 1.4, sy=0.28, add=True)
    for k in range(10):
        ph = rng.random()
        u = (i / (n - 1) * 1.2 + ph) % 1
        c.blob(96 + rng.uniform(-22, 22) * (1 - u * 0.4), 224 - 170 * u, 4 * (1 - u * 0.5), GOLD, math.sin(math.pi * u) * a, 1.8, True)
    return c.image()


def fx015(i, n):
    c = Canvas(320, 160)
    rng = random.Random(15)
    t = (i + 0.5) / n
    if i < 3:
        c.blob(160, 120, lerp(60, 24, i / 2), GOLD, 0.8 - 0.2 * i, 2, True, sy=0.8)
        c.star(160, 118, 56 - 12 * i, CORE, 0.8 - 0.25 * i, 6, 3, add=True)
    c.ring(160, 130, lerp(10, 140, ease_out(t)), lerp(18, 5, t), DUST_L, (1 - t) ** 0.8, 1.0, sy=0.17)
    c.ring(160, 130, lerp(6, 110, ease_out(t)), lerp(10, 3, t), '#FFFFFF', 0.6 * (1 - t), 1.2, sy=0.17, add=True)
    for side in (-1, 1):
        front = lerp(8, 100, ease_out(t))
        for j, (off, rr) in enumerate(((0, 1), (-26, 0.8), (-52, 0.6), (-72, 0.45))):
            r = lerp(22, 50, t) * rr
            x = 160 + side * max(front + off * t, 4)
            _puff(c, x, 128 - r * 0.55 - 14 * t, r, (1 - t) ** 1.0, EARTH if j % 2 else DUST, DUST_L, EARTH_D, 0.85)
    for k in range(9):
        vx, vy = rng.uniform(-70, 70), rng.uniform(70, 120)
        x, y = 160 + vx * t, 124 - vy * t + 150 * t * t
        if y < 138:
            sz = rng.uniform(6, 12)
            th = rng.uniform(0, TAU) + t * 5
            pts = [polar(x, y, sz * f, th + g) for f, g in ((1, 0), (0.7, 2.2), (0.9, 4.1))]
            c.poly(pts, EARTH_D, 1 - smooth((t - 0.6) / 0.4))
    zig = [(160, 132)]
    for step in range(1, 7):
        zig.append((160 + step * 20, 132 + (4 if step % 2 else -2)))
    for side in (-1, 1):
        c.polyline([(160 + side * (x - 160), y) for x, y in zig], 3, '#1C1712', 0.8 * (1 - t), 1.2, ease_out(min(1, t * 1.5)))
    return c.image()


def fx016(i, n):
    c = Canvas(192, 192)
    rng = random.Random(16)
    t = i / n
    p = 0.5 + 0.5 * math.sin(TAU * t)
    c.blob(96, 96, 80, CORE, 0.25 + 0.06 * p, 2, True)
    c.blob(96, 96, 46, CORE_L, 0.45, 2, True)
    for k in range(3):
        th0 = TAU * k / 3 + t * TAU / 3
        for j in range(44):
            u = j / 43
            x, y = polar(96, 96, 10 + u * 64, th0 + u * 4.8)
            c.blob(x, y, lerp(6, 2, u), CORE if u > 0.4 else CORE_L, (1 - u) ** 1.2 * 0.9, 1.5, True)
    c.blob(96, 96, 18 + 3 * p, '#FFFFFF', 0.95, 1.4, True)
    for k in range(6):
        th = rng.uniform(0, TAU) + (i * 1.9 if k % 2 else 0)
        pts, r = [], 14
        for s in range(5):
            pts.append(polar(96, 96, r, th + rng.uniform(-0.25, 0.25)))
            r += rng.uniform(8, 14)
        c.polyline(pts, 2.2, ICE, 0.8, 1.2, 1.0, True)
    return c.image()


def fx017(i, n):
    c = Canvas(320, 320)
    rng = random.Random(17)
    if i <= 3:
        u = i / 3
        c.blob(160, 160, lerp(14, 54, u), CORE, 0.4 + 0.4 * u, 2, True)
        c.blob(160, 160, lerp(6, 24, u), '#FFFFFF', 0.6 + 0.4 * u, 1.6, True)
        for k in range(26):
            th = rng.uniform(0, TAU)
            r = lerp(rng.uniform(104, 136), 22, ease_in(min(1, u * 0.85 + rng.uniform(0, 0.15))))
            x, y = polar(160, 160, r, th)
            c.blob(x, y, 4, CORE_L if k % 2 else GOLD, 0.4 + 0.6 * u, 1.6, True)
            x2, y2 = polar(160, 160, r + 14, th)
            c.capsule(x, y, x2, y2, 2.4, CORE, 0.5, 1.3, True, w1=0.5)
    elif i == 4:
        c.blob(160, 160, 150, '#FFFFFF', 0.85, 1.4, True)
        c.blob(160, 160, 90, GOLD, 0.7, 1.8, True)
        c.star(160, 160, 150, CORE_L, 0.9, 12, 3, add=True)
    else:
        u = (i - 4) / 5.6
        f = (1 - u) ** 1.1
        c.blob(160, 160, lerp(90, 30, u), GOLD, 0.5 * f, 2, True)
        c.ring(160, 160, lerp(20, 140, ease_out(u)), lerp(18, 3, u), CORE, 0.9 * f, 1.3, add=True)
        c.ring(160, 160, lerp(10, 112, ease_out(u)), lerp(10, 2, u), GOLD, 0.8 * f, 1.3, add=True)
        c.ring(160, 160, lerp(20, 140, ease_out(u)), lerp(5, 1, u), '#FFFFFF', f, 1.3, add=True)
        c.star(160, 160, lerp(140, 60, u), CORE_L, 0.6 * f, 12, 4, u * 0.5, True)
        for k in range(20):
            th = TAU * k / 20 + rng.uniform(-0.2, 0.2)
            x, y = polar(160, 160, lerp(30, 128 + rng.uniform(0, 14), ease_out(u)), th)
            c.blob(x, y, 3.5 * (1 - u * 0.5), GOLD if k % 3 == 0 else CORE_L, f, 1.6, True)
    return c.image()


def fx018(i, n):
    c = Canvas(192, 192)
    rng = random.Random(18)
    pts = [(96 + rng.uniform(-18, 18), 118 + rng.uniform(-44, 36), rng.uniform(0, 0.4), rng.uniform(-10, 10)) for _ in range(34)]
    if i < 6:
        t = (i + 0.5) / 6
        c.blob(96, 112, 54 * (1 - t) + 10, CY, 0.4 * (1 - t), 2, True, sy=1.3)
        for x, y, d, dx in pts:
            u = max(t - d * 0.5, 0) / (1 - d * 0.5)
            c.blob(x + dx * u + 6 * math.sin(7 * u + x), y - 70 * ease_out(u), 4.2 * (1 - u * 0.6), CORE_L if x > 96 else CY, (1 - u) ** 0.9, 1.6, True)
    else:
        k = i - 6
        t = k / 5
        for x, y, d, dx in pts:
            u = min(max((t * 1.2 - d * 0.3), 0), 1)
            sx, sy = x + dx * 4 + 40 * math.sin(x), y - 70 + 20 * math.cos(y)
            e = ease_out(u)
            c.blob(lerp(sx, x, e), lerp(sy, y, e), 4.2 * (0.5 + 0.5 * e), CORE_L if x > 96 else CY, 0.3 + 0.7 * e, 1.6, True)
        if k >= 3:
            f = (k - 3) / 2
            c.blob(96, 112, lerp(24, 70, f), CY, 0.7 * (1 - f * 0.7), 2, True, sy=1.25)
            c.ring(96, 112, lerp(12, 62, ease_out(f)), 4 * (1 - f) + 1, ICE, 0.9 * (1 - f), 1.3, add=True, sy=1.2)
            c.star(96, 112, lerp(30, 56, f), ICE, 0.8 * (1 - f), 4, 3, add=True)
    return c.image()


def fx019(i, n):
    c = Canvas(192, 128)
    rng = random.Random(19)
    if i < 6:
        t = (i + 0.5) / 6
        for k, dl in enumerate((0, 0.25)):
            u = min(max((t - dl) / (1 - dl), 0), 1)
            c.ring(96, 84, lerp(5, 70, ease_out(u)), 3.2 * (1 - u) + 0.8, ICE, 0.85 * (1 - u), 1.4, sy=0.24)
            c.ring(96, 84, lerp(5, 70, ease_out(u)) * 0.88, 2, CY, 0.6 * (1 - u), 1.4, sy=0.24)
    else:
        t = (i - 6 + 0.5) / 8
        f = 1 - smooth((t - 0.6) / 0.4)
        c.ring(96, 84, lerp(8, 62, ease_out(t)), 3 * (1 - t) + 1, ICE, 0.8 * (1 - t), 1.4, sy=0.24)
        if t < 0.55:
            h = 34 * math.sin(math.pi * t / 0.55)
            c.capsule(96, 84, 96, 84 - h, 18 * (1 - t), CY, 0.7, 1.0, False, w1=6)
            c.capsule(96, 84, 96, 84 - h, 8 * (1 - t), ICE, 0.95, 1.0, False, w1=2.5)
        for k in range(22):
            ang = math.radians(rng.uniform(-75, 75) - 90)
            v = rng.uniform(80, 140)
            vx, vy = v * math.cos(ang), v * math.sin(ang)
            x, y = 96 + vx * t * 0.9, 84 + vy * t + 120 * t * t
            if y < 88:
                c.capsule(x, y, x - vx * 0.035, y - (vy + 240 * t) * 0.035, 6.5, ICE, f, 1.0, False, w1=3.5)
                c.disc(x, y, 2.8, '#FFFFFF', f, 0.8)
    return c.image()


def fx020(i, n):
    c = Canvas(128, 96)
    if i < 6:
        t = i / 6
        c.blob(92, 48, 28, CORE, 0.4, 2, True)
        for j in range(3):
            ph = TAU * t + j * 2.1
            tail = 80 - 6 * j
            c.capsule(92, 48 + 2 * math.sin(ph), 92 - tail, 48 + 5 * math.sin(ph + 1.3), 20 - 5 * j, [CORE, CORE_L, ICE][j], 0.55, 1.3, True, w1=0)
        for j in range(6):
            u = (t + j / 6) % 1
            c.blob(88 - 78 * u, 48 + 9 * math.sin(TAU * (u + t)), 3.2 * (1 - u * 0.6), ICE, (1 - u) ** 0.7, 1.6, True)
        c.blob(92, 48, 15, CORE_L, 0.9, 1.8, True)
        c.blob(92, 48, 8, '#FFFFFF', 1.0, 1.3, True)
        c.star(92, 48, 20 + 2 * math.sin(TAU * t), ICE, 0.7, 4, 3, t * math.pi / 2, True)
    else:
        k = i - 6
        t = k / 4.6
        f = (1 - t) ** 1.1
        c.blob(64, 48, lerp(40, 14, t), CORE, 0.6 * f, 2, True)
        c.ring(64, 48, lerp(8, 40, ease_out(t)), lerp(7, 2, t), CORE_L, 0.9 * f, 1.3, add=True)
        c.star(64, 48, lerp(44, 22, t), ICE, 0.9 * f, 6, 3, add=True)
        rng = random.Random(20)
        for s in range(10):
            th = TAU * s / 10 + rng.uniform(-0.2, 0.2)
            r0, r1 = 8 + 26 * ease_out(t), 14 + 34 * ease_out(t)
            x0, y0, x1, y1 = *polar(64, 48, r0, th), *polar(64, 48, r1, th)
            c.capsule(x0, y0, x1, y1, 3, CORE_L, f, 1.3, True, w1=1)
    return c.image()


def spec(aid, title, slug, size, frames, fps, loop, pivot, render, seqs=None, cols=None, notes=None):
    return dict(id=aid, title=title, slug=slug, size=size, frames=frames, fps=fps, loop=loop, pivot=pivot, render=render,
                sequences=seqs or {'main': [0, frames - 1]}, cols=cols or (frames if frames <= 8 else math.ceil(frames / 2)), notes=notes or [])


EFFECTS = [
    spec('FX-001', 'Sword swing trail', 'sword_swing_trail', (192, 192), 6, 20, False, (80, 120), fx001,
         notes=['Crescent drawn for a right-facing overhead-to-low swing; mirror horizontally for left-facing.', 'Arc origin (pivot) sits at the sword hand; align to the attack animation.']),
    spec('FX-002', 'Sword impact sparks', 'sword_impact_sparks', (128, 128), 6, 24, False, (64, 64), fx002),
    spec('FX-003', 'Enemy hit flash', 'enemy_hit_flash', (128, 128), 4, 30, False, (64, 64), fx003,
         notes=['Burst overlay only. A full-silhouette white flash of the enemy sprite should be a shader/modulate in Godot, not baked art.']),
    spec('FX-004', 'Enemy defeat particles', 'enemy_defeat_particles', (192, 192), 8, 16, False, (96, 92), fx004,
         notes=['Uses the Chapter 1 enemy palette (thorn green plus ember orange). Recolor per enemy in engine if needed.']),
    spec('FX-005', 'Dust from running', 'running_dust', (96, 96), 6, 14, False, (68, 82), fx005,
         notes=['Trails to the left of the pivot for a right-facing runner; flip for left-facing.', 'Pivot is the ground contact point behind the foot.']),
    spec('FX-006', 'Jump take-off puff', 'jump_takeoff_puff', (128, 128), 6, 16, False, (64, 104), fx006),
    spec('FX-007', 'Landing dust', 'landing_dust', (192, 128), 7, 16, False, (96, 108), fx007),
    spec('FX-008', 'Falling debris', 'falling_debris', (128, 192), 8, 12, False, (64, 0), fx008,
         notes=['Five stone chunks fall top to bottom over the full cell height; spawn several instances with offsets for larger collapses.',
                'Chunks intentionally cross the top and bottom cell edges; stack cells vertically or do not clip the sprite.']),
    spec('FX-009', 'Lantern light pulse', 'lantern_light_pulse', (256, 256), 8, 10, True, (128, 128), fx009,
         notes=['Seamless loop. Use with additive blend in Godot; pair with a PointLight2D for real lighting.']),
    spec('FX-010', 'Mote glow', 'mote_glow', (128, 128), 8, 12, True, (64, 64), fx010,
         notes=['Seamless loop. The orbiting sparkle dots use the Mote palette from ART-002.']),
    spec('FX-011', 'Rune activation', 'rune_activation', (192, 192), 8, 14, False, (96, 96), fx011),
    spec('FX-012', 'Hidden platform reveal', 'hidden_platform_reveal', (256, 96), 8, 14, False, (128, 56), fx012,
         notes=['Outline is a 200 x 24 px platform footprint; scale or tile the middle for other widths.']),
    spec('FX-013', 'Collectible pickup', 'collectible_pickup', (128, 128), 8, 18, False, (64, 70), fx013),
    spec('FX-014', 'Checkpoint activation', 'checkpoint_activation', (192, 256), 10, 14, False, (96, 226), fx014),
    spec('FX-015', 'Boss ground impact', 'boss_ground_impact', (320, 160), 8, 16, False, (160, 130), fx015),
    spec('FX-016', 'Boss core energy', 'boss_core_energy', (192, 192), 8, 14, True, (96, 96), fx016,
         notes=['Seamless loop. Three-arm spiral repeats every third of a rotation; crackle lines flicker per frame by design.']),
    spec('FX-017', 'Boss phase transition', 'boss_phase_transition', (320, 320), 10, 14, False, (160, 160), fx017,
         seqs={'charge': [0, 3], 'burst': [4, 9]}),
    spec('FX-018', 'Death and respawn effects', 'death_respawn', (192, 192), 12, 14, False, (96, 118), fx018,
         seqs={'death': [0, 5], 'respawn': [6, 11]}, cols=6),
    spec('FX-019', 'Water ripples and splashes', 'water_ripples_splashes', (192, 128), 14, 14, False, (96, 84), fx019,
         seqs={'ripple': [0, 5], 'splash': [6, 13]}, cols=7, notes=['Water surface line sits at y = 84 in every cell.']),
    spec('FX-020', 'Magic projectile', 'magic_projectile', (128, 96), 11, 16, False, (92, 48), fx020,
         seqs={'flight_loop': [0, 5], 'impact': [6, 10]}, cols=6,
         notes=['Flight loop flies to the right; the impact burst is centered at x = 64 and is not a continuation of the flight pivot.']),
]
