from pathlib import Path
import cairosvg
W,H=1792,1024
parts=[]
def add(s): parts.append(s)
add(f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
<defs>
  <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f7f0df"/><stop offset="1" stop-color="#e9dfc9"/></linearGradient>
  <linearGradient id="blue" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5ea1ee"/><stop offset="1" stop-color="#22518b"/></linearGradient>
  <linearGradient id="cloth" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff1d8"/><stop offset="1" stop-color="#cfbda3"/></linearGradient>
  <linearGradient id="bark" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#73875b"/><stop offset="1" stop-color="#3c4938"/></linearGradient>
  <linearGradient id="stone" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#8797a0"/><stop offset="1" stop-color="#3e4b5a"/></linearGradient>
  <filter id="softShadow" x="-30%" y="-30%" width="160%" height="170%"><feGaussianBlur stdDeviation="5"/></filter>
  <style>
  .title{{font-family:Georgia,serif;font-weight:bold;fill:#20302e;letter-spacing:1px}}
  .sub{{font-family:Arial,sans-serif;fill:#52605a}}
  .label{{font-family:Georgia,serif;font-weight:bold;fill:#263633;font-size:20px}}
  .small{{font-family:Arial,sans-serif;fill:#667067;font-size:15px}}
  .measure{{font-family:Arial,sans-serif;fill:#728078;font-size:13px}}
  .outline{{stroke:#26312e;stroke-width:3;stroke-linejoin:round;stroke-linecap:round}}
  .thin{{stroke:#26312e;stroke-width:2;stroke-linejoin:round;stroke-linecap:round}}
  </style>
</defs>
<rect width="1792" height="1024" fill="url(#bg)"/>
''')
# subtle border + header
add('<rect x="22" y="22" width="1748" height="980" rx="22" fill="none" stroke="#bba985" stroke-width="2"/>')
add('<text x="58" y="73" class="title" font-size="35">ART-003  |  CHARACTER PROPORTION &amp; SCALE</text>')
add('<text x="60" y="108" class="sub" font-size="18">Lanterns Underroot · Side-view reference · Common ground line · Provisional measurements</text>')
add('<text x="1730" y="68" text-anchor="end" class="small">ART FOUNDATION / 03</text>')
add('<line x1="58" y1="132" x2="1734" y2="132" stroke="#c4b597" stroke-width="2"/>')
# drawing field and ruler
base=790
# grid lines at every tile 72 display px, labeled tile units
for i in range(1,5):
    y=base-i*72
    add(f'<line x1="82" y1="{y}" x2="1725" y2="{y}" stroke="#d6cbb4" stroke-width="1.3" stroke-dasharray="6 7"/>')
    add(f'<text x="57" y="{y+5}" class="measure" text-anchor="end">{i} tile</text>')
add(f'<line x1="82" y1="{base}" x2="1725" y2="{base}" stroke="#68766b" stroke-width="3"/>')
add('<text x="82" y="822" class="small">SHARED BASELINE</text>')
# columns
centers=[183,421,659,897,1135,1373,1611]
labels=[('TAVI','Player'),('MOTE','Companion'),('ROOTLING','Ground enemy'),('THORNWING','Flying enemy'),('SPORELING','Ranged enemy'),('BRAMBLEGUARD','Heavy enemy'),('HOLLOW SENTINEL','Chapter 1 boss')]
for i,c in enumerate(centers):
    add(f'<line x1="{c-102}" y1="154" x2="{c-102}" y2="872" stroke="#d3c7ad" stroke-width="1"/>')
    add(f'<line x1="{c}" y1="154" x2="{c}" y2="790" stroke="#e0d6c2" stroke-width="1" stroke-dasharray="3 7"/>')
add('<line x1="1735" y1="154" x2="1735" y2="872" stroke="#d3c7ad" stroke-width="1"/>')
# character functions
# Tavi: full side facing right, approx rendered height 126 px, bottom 790 top 664
# sprite coord local x center, base y, scale=1 (design drawn 130 high)
def tavi(cx, by, s=1):
    def p(x,y): return f'{cx+x*s:.1f},{by+y*s:.1f}'
    # shadow
    add(f'<ellipse cx="{cx}" cy="{by+2*s}" rx="39" ry="6" fill="#4b4a3e" opacity=".16"/>')
    # legs and boots
    add(f'<path d="M {p(-7,-38)} L {p(-14,-18)} L {p(-10,-7)} L {p(3,-7)} L {p(2,-21)} L {p(8,-34)} Z" fill="#514b45" class="outline"/>')
    add(f'<path d="M {p(5,-39)} L {p(9,-22)} L {p(20,-11)} L {p(31,-10)} L {p(33,-4)} L {p(15,-3)} L {p(2,-14)} L {p(-3,-30)} Z" fill="#705039" class="outline"/>')
    add(f'<path d="M {p(-13,-9)} Q {p(-1,-14)} {p(7,-8)} L {p(8,-2)} L {p(-14,-2)} Z" fill="#362f2b" class="thin"/>')
    add(f'<path d="M {p(17,-9)} L {p(34,-8)} L {p(36,-2)} L {p(12,-2)} Z" fill="#362f2b" class="thin"/>')
    # torso tunic
    add(f'<path d="M {p(-15,-88)} Q {p(-2,-98)} {p(11,-88)} L {p(17,-54)} L {p(10,-35)} L {p(-12,-36)} L {p(-20,-55)} Z" fill="url(#cloth)" class="outline"/>')
    # tunic hem panels
    add(f'<path d="M {p(-15,-56)} L {p(-6,-55)} L {p(-9,-37)} L {p(-16,-38)} Z" fill="#b5a085" class="thin"/>')
    # belt
    add(f'<path d="M {p(-17,-58)} L {p(15,-57)} L {p(15,-50)} L {p(-16,-50)} Z" fill="#7b5634" class="thin"/>')
    add(f'<rect x="{cx+2*s:.1f}" y="{by-58*s:.1f}" width="5" height="7" rx="1" fill="#d6b56d"/>')
    # arm back
    add(f'<path d="M {p(-13,-83)} L {p(-25,-69)} L {p(-19,-56)} L {p(-11,-58)} L {p(-15,-69)} L {p(-5,-78)} Z" fill="#e0c8a6" class="outline"/>')
    # front arm holding sword
    add(f'<path d="M {p(8,-82)} L {p(20,-72)} L {p(25,-61)} L {p(17,-57)} L {p(10,-67)} L {p(1,-72)} Z" fill="#dfc39d" class="outline"/>')
    add(f'<circle cx="{cx+22*s:.1f}" cy="{by-59*s:.1f}" r="4" fill="#edc99f" class="thin"/>')
    # scarf trailing left
    add(f'<path d="M {p(-4,-88)} Q {p(-19,-96)} {p(-37,-88)} L {p(-53,-80)} L {p(-32,-78)} L {p(-45,-67)} Q {p(-20,-70)} {p(-7,-80)} Z" fill="#bb433d" class="outline"/>')
    # neck and head
    add(f'<rect x="{cx-4*s:.1f}" y="{by-103*s:.1f}" width="13" height="15" rx="4" fill="#edc9a1" class="thin"/>')
    add(f'<path d="M {p(-13,-115)} Q {p(-8,-131)} {p(8,-126)} Q {p(23,-123)} {p(20,-108)} L {p(12,-96)} L {p(-5,-98)} Z" fill="#edc9a1" class="outline"/>')
    # hair blue spikes
    add(f'<path d="M {p(-15,-112)} L {p(-20,-124)} L {p(-7,-120)} L {p(-2,-134)} L {p(6,-126)} L {p(17,-129)} L {p(20,-119)} L {p(29,-114)} L {p(17,-109)} L {p(3,-111)} L {p(-3,-104)} L {p(-12,-107)} Z" fill="url(#blue)" class="outline"/>')
    # face nose and eye
    add(f'<path d="M {p(18,-111)} L {p(25,-106)} L {p(18,-104)}" fill="#edc9a1" class="thin"/>')
    add(f'<circle cx="{cx+13*s:.1f}" cy="{by-113*s:.1f}" r="2.3" fill="#1d2730"/>')
    # sword in front
    add(f'<path d="M {p(26,-57)} L {p(54,-91)} L {p(57,-96)} L {p(53,-90)} L {p(24,-54)} Z" fill="#dce7e9" stroke="#4b6577" stroke-width="2" stroke-linejoin="round"/>')
    add(f'<path d="M {p(20,-60)} L {p(28,-54)}" stroke="#8b623e" stroke-width="4" stroke-linecap="round"/>')

def mote(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+1}" rx="20" ry="4" fill="#6ca5aa" opacity=".14"/>')
    # glow aura
    add(f'<circle cx="{cx}" cy="{by-34}" r="29" fill="#7ae3ec" opacity=".12"/>')
    # tiny wing leaves
    add(f'<path d="M {cx-5} {by-36} Q {cx-31} {by-58} {cx-30} {by-76} Q {cx-9} {by-69} {cx+1} {by-50} Z" fill="#e8f0c8" stroke="#92b6ad" stroke-width="2"/>')
    add(f'<path d="M {cx+4} {by-35} Q {cx+16} {by-62} {cx+34} {by-65} Q {cx+34} {by-43} {cx+10} {by-27} Z" fill="#edf3d4" stroke="#92b6ad" stroke-width="2"/>')
    # body rounded little spirit
    add(f'<path d="M {cx-19} {by-35} Q {cx-19} {by-53} {cx} {by-54} Q {cx+20} {by-53} {cx+20} {by-35} L {cx+16} {by-14} Q {cx+8} {by-7} {cx} {by-15} Q {cx-11} {by-7} {cx-17} {by-16} Z" fill="#fff4d9" stroke="#6b9b9d" stroke-width="2.5"/>')
    add(f'<ellipse cx="{cx-7}" cy="{by-34}" rx="2.5" ry="3.5" fill="#24455a"/><ellipse cx="{cx+7}" cy="{by-34}" rx="2.5" ry="3.5" fill="#24455a"/>')
    add(f'<path d="M {cx-4} {by-25} Q {cx} {by-21} {cx+4} {by-25}" fill="none" stroke="#d58c79" stroke-width="1.6" stroke-linecap="round"/>')
    # tiny sparkles
    add(f'<path d="M {cx-31} {by-45} l0 -7 M {cx-35.0} {by-48.5} l7 0 M {cx+30} {by-21} l0 -6 M {cx+27} {by-24} l6 0" stroke="#fff5cd" stroke-width="2" stroke-linecap="round"/>')

def rootling(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+1}" rx="34" ry="5" fill="#4b4a3e" opacity=".16"/>')
    # legs
    add(f'<path d="M {cx-23} {by-20} L {cx-30} {by-6} L {cx-20} {by-3} L {cx-11} {by-17} Z M {cx+1} {by-20} L {cx-3} {by-5} L {cx+11} {by-3} L {cx+15} {by-20} Z" fill="#4b5141" class="outline"/>')
    # body
    add(f'<path d="M {cx-31} {by-30} Q {cx-28} {by-51} {cx-7} {by-47} Q {cx+9} {by-56} {cx+27} {by-36} L {cx+30} {by-22} L {cx+13} {by-17} L {cx-17} {by-18} L {cx-32} {by-22} Z" fill="url(#bark)" class="outline"/>')
    # bark plates/moss
    add(f'<path d="M {cx-24} {by-35} Q {cx-8} {by-53} {cx+5} {by-41} L {cx-4} {by-31} Z" fill="#83985f" stroke="#344637" stroke-width="2"/>')
    add(f'<path d="M {cx+8} {by-40} Q {cx+21} {by-49} {cx+28} {by-33} L {cx+16} {by-28} Z" fill="#657d4c" stroke="#344637" stroke-width="2"/>')
    # head/front snout
    add(f'<path d="M {cx+9} {by-42} L {cx+26} {by-39} L {cx+35} {by-28} L {cx+20} {by-23} L {cx+7} {by-29} Z" fill="#555d4d" class="thin"/>')
    add(f'<circle cx="{cx+21}" cy="{by-35}" r="3.2" fill="#f2b94d" stroke="#28332e" stroke-width="1.5"/>')
    # root tail
    add(f'<path d="M {cx-26} {by-27} Q {cx-39} {by-21} {cx-37} {by-12}" fill="none" stroke="#66523b" stroke-width="5" stroke-linecap="round"/>')

def thornwing(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+1}" rx="31" ry="4" fill="#4b4a3e" opacity=".12"/>')
    # wings
    add(f'<path d="M {cx-3} {by-26} Q {cx-32} {by-59} {cx-43} {by-47} Q {cx-39} {by-26} {cx-14} {by-20} Z" fill="#d9ebec" fill-opacity=".88" stroke="#6a8f91" stroke-width="2"/>')
    add(f'<path d="M {cx+1} {by-27} Q {cx+17} {by-61} {cx+38} {by-52} Q {cx+34} {by-30} {cx+11} {by-20} Z" fill="#e6d6d0" fill-opacity=".9" stroke="#9a7169" stroke-width="2"/>')
    # abdomen
    add(f'<path d="M {cx-12} {by-26} Q {cx+4} {by-41} {cx+18} {by-30} L {cx+27} {by-22} L {cx+13} {by-13} L {cx-3} {by-17} Z" fill="#984b3e" class="outline"/>')
    for j in range(3):
        add(f'<path d="M {cx+2+j*6} {by-31+j*2} l4 5" stroke="#e59c70" stroke-width="2"/>')
    # head & eyes
    add(f'<circle cx="{cx-15}" cy="{by-30}" r="9" fill="#6e4d41" class="thin"/>')
    add(f'<circle cx="{cx-18}" cy="{by-32}" r="3" fill="#f4c04f"/>')
    # thorn spikes
    add(f'<path d="M {cx-8} {by-37} L {cx-13} {by-48} L {cx-1} {by-40} L {cx+6} {by-48} L {cx+8} {by-37} L {cx+20} {by-40} L {cx+15} {by-30}" fill="#b75a45" class="thin"/>')
    # legs
    add(f'<path d="M {cx-3} {by-17} L {cx-14} {by-7} M {cx+8} {by-16} L {cx+16} {by-6} M {cx+20} {by-19} L {cx+29} {by-11}" fill="none" stroke="#463a35" stroke-width="3.5" stroke-linecap="round"/>')

def sporeling(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+1}" rx="27" ry="4" fill="#4b4a3e" opacity=".15"/>')
    # feet
    add(f'<path d="M {cx-16} {by-10} L {cx-19} {by-3} L {cx-4} {by-2} L {cx+1} {by-11} Z M {cx+4} {by-11} L {cx+9} {by-3} L {cx+22} {by-3} L {cx+18} {by-12} Z" fill="#5b6b43" class="thin"/>')
    # body
    add(f'<path d="M {cx-17} {by-19} Q {cx-20} {by-34} {cx-8} {by-36} L {cx+8} {by-36} Q {cx+20} {by-32} {cx+17} {by-18} L {cx+11} {by-10} L {cx-10} {by-10} Z" fill="#e6d6b9" class="outline"/>')
    add(f'<circle cx="{cx-6}" cy="{by-27}" r="2.2" fill="#3a4237"/><circle cx="{cx+7}" cy="{by-27}" r="2.2" fill="#3a4237"/>')
    add(f'<path d="M {cx-3} {by-20} Q {cx} {by-18} {cx+4} {by-20}" fill="none" stroke="#bb7a6b" stroke-width="1.5"/>')
    # cap
    add(f'<path d="M {cx-35} {by-36} Q {cx-31} {by-61} {cx-8} {by-62} Q {cx+17} {by-64} {cx+33} {by-41} Q {cx+19} {by-35} {cx-4} {by-36} Z" fill="#b84943" class="outline"/>')
    for dx,dy,r in [(-18,-48,3.5),(-2,-54,4),(15,-47,3.2),(23,-40,2.8)]:
        add(f'<circle cx="{cx+dx}" cy="{by+dy}" r="{r}" fill="#fff0d4"/>')
    # green small leaf
    add(f'<path d="M {cx+4} {by-60} Q {cx+9} {by-72} {cx+18} {by-68} Q {cx+15} {by-60} {cx+4} {by-60} Z" fill="#678b51" stroke="#344637" stroke-width="1.5"/>')

def brambleguard(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+2}" rx="53" ry="7" fill="#4b4a3e" opacity=".17"/>')
    # legs
    add(f'<path d="M {cx-29} {by-61} L {cx-36} {by-30} L {cx-28} {by-7} L {cx-9} {by-7} L {cx-8} {by-19} L {cx-14} {by-49} Z" fill="#4d5748" class="outline"/>')
    add(f'<path d="M {cx+10} {by-62} L {cx+13} {by-30} L {cx+28} {by-9} L {cx+45} {by-9} L {cx+43} {by-22} L {cx+28} {by-53} Z" fill="#4d5748" class="outline"/>')
    add(f'<path d="M {cx-34} {by-10} L {cx-7} {by-10} L {cx-3} {by-3} L {cx-41} {by-3} Z M {cx+26} {by-10} L {cx+49} {by-10} L {cx+53} {by-3} L {cx+24} {by-3} Z" fill="#333b34" class="thin"/>')
    # torso plates
    add(f'<path d="M {cx-29} {by-113} Q {cx-12} {by-133} {cx+13} {by-119} L {cx+34} {by-94} L {cx+22} {by-61} L {cx-18} {by-58} L {cx-38} {by-83} Z" fill="url(#bark)" class="outline"/>')
    add(f'<path d="M {cx-28} {by-106} L {cx-9} {by-118} L {cx+3} {by-98} L {cx-11} {by-81} Z" fill="#8b9a67" class="thin"/>')
    add(f'<path d="M {cx+7} {by-111} L {cx+24} {by-101} L {cx+20} {by-81} L {cx+2} {by-88} Z" fill="#64784f" class="thin"/>')
    # arms
    add(f'<path d="M {cx-29} {by-108} L {cx-48} {by-88} L {cx-43} {by-62} L {cx-28} {by-59} L {cx-22} {by-77} L {cx-10} {by-93} Z" fill="#526044" class="outline"/>')
    add(f'<path d="M {cx+24} {by-106} L {cx+42} {by-87} L {cx+43} {by-67} L {cx+29} {by-59} L {cx+18} {by-80} Z" fill="#596747" class="outline"/>')
    # blue core
    add(f'<path d="M {cx-6} {by-102} L {cx+7} {by-109} L {cx+17} {by-99} L {cx+14} {by-83} L {cx} {by-78} L {cx-8} {by-88} Z" fill="#39b8d5" stroke="#c5f4fa" stroke-width="3"/>')
    add(f'<circle cx="{cx+4}" cy="{by-94}" r="5" fill="#d9fdff"/>')
    # head
    add(f'<path d="M {cx-19} {by-132} L {cx-14} {by-149} L {cx-2} {by-139} L {cx+10} {by-151} L {cx+20} {by-135} L {cx+14} {by-119} L {cx-9} {by-117} Z" fill="#62754e" class="outline"/>')
    add(f'<circle cx="{cx+6}" cy="{by-131}" r="3.5" fill="#f5bd4f" stroke="#2e3930" stroke-width="1.5"/>')
    # bramble horns
    add(f'<path d="M {cx-14} {by-134} L {cx-27} {by-145} L {cx-14} {by-142} M {cx+17} {by-135} L {cx+30} {by-143} L {cx+22} {by-130}" fill="none" stroke="#6b4c31" stroke-width="6" stroke-linecap="round"/>')

def sentinel(cx, by):
    add(f'<ellipse cx="{cx}" cy="{by+3}" rx="74" ry="9" fill="#4b4a3e" opacity=".2"/>')
    # legs heavy
    add(f'<path d="M {cx-42} {by-102} L {cx-52} {by-66} L {cx-48} {by-19} L {cx-30} {by-8} L {cx-8} {by-10} L {cx-8} {by-28} L {cx-18} {by-65} L {cx-14} {by-99} Z" fill="url(#stone)" class="outline"/>')
    add(f'<path d="M {cx+9} {by-104} L {cx+21} {by-69} L {cx+20} {by-29} L {cx+35} {by-7} L {cx+59} {by-8} L {cx+60} {by-20} L {cx+44} {by-67} L {cx+44} {by-103} Z" fill="url(#stone)" class="outline"/>')
    add(f'<path d="M {cx-55} {by-12} L {cx-6} {by-12} L {cx+1} {by-3} L {cx-61} {by-3} Z M {cx+30} {by-12} L {cx+64} {by-12} L {cx+73} {by-3} L {cx+24} {by-3} Z" fill="#303b48" class="thin"/>')
    # torso massive
    add(f'<path d="M {cx-44} {by-196} L {cx-64} {by-165} L {cx-51} {by-118} L {cx-24} {by-101} L {cx+36} {by-104} L {cx+55} {by-137} L {cx+46} {by-177} L {cx+19} {by-198} Z" fill="url(#stone)" class="outline"/>')
    # armor stone plates
    add(f'<path d="M {cx-46} {by-184} L {cx-22} {by-196} L {cx-10} {by-171} L {cx-27} {by-149} L {cx-45} {by-157} Z" fill="#9ba7a6" class="thin"/>')
    add(f'<path d="M {cx+9} {by-193} L {cx+34} {by-182} L {cx+44} {by-158} L {cx+22} {by-148} L {cx+3} {by-171} Z" fill="#657581" class="thin"/>')
    # left arm and fist
    add(f'<path d="M {cx-47} {by-184} L {cx-68} {by-161} L {cx-78} {by-127} L {cx-66} {by-105} L {cx-46} {by-113} L {cx-46} {by-136} L {cx-28} {by-158} Z" fill="#697b86" class="outline"/>')
    add(f'<path d="M {cx-77} {by-131} L {cx-88} {by-121} L {cx-82} {by-104} L {cx-62} {by-102} L {cx-54} {by-114} L {cx-64} {by-128} Z" fill="#86969b" class="outline"/>')
    # right arm
    add(f'<path d="M {cx+39} {by-183} L {cx+60} {by-169} L {cx+71} {by-142} L {cx+68} {by-119} L {cx+48} {by-114} L {cx+38} {by-136} L {cx+26} {by-155} Z" fill="#6c7b86" class="outline"/>')
    add(f'<path d="M {cx+51} {by-121} L {cx+72} {by-118} L {cx+82} {by-103} L {cx+65} {by-95} L {cx+49} {by-104} Z" fill="#81939c" class="outline"/>')
    # core and blue rune
    add(f'<path d="M {cx-11} {by-169} L {cx+10} {by-184} L {cx+29} {by-169} L {cx+25} {by-139} L {cx+7} {by-126} L {cx-11} {by-141} Z" fill="#1f8dbb" stroke="#b0efff" stroke-width="4"/>')
    add(f'<path d="M {cx+7} {by-174} L {cx+7} {by-140} M {cx-2} {by-160} L {cx+7} {by-168} L {cx+16} {by-160} M {cx-1} {by-149} L {cx+7} {by-155} L {cx+15} {by-149}" fill="none" stroke="#d7fbff" stroke-width="3" stroke-linecap="round"/>')
    # head
    add(f'<path d="M {cx-27} {by-202} L {cx-32} {by-225} L {cx-14} {by-218} L {cx-7} {by-239} L {cx+4} {by-221} L {cx+25} {by-229} L {cx+31} {by-207} L {cx+18} {by-190} L {cx-12} {by-190} Z" fill="#657783" class="outline"/>')
    # stone face eyes
    add(f'<path d="M {cx-16} {by-207} L {cx-1} {by-212} L {cx-2} {by-203} Z M {cx+7} {by-211} L {cx+21} {by-206} L {cx+8} {by-201} Z" fill="#43d2ef" stroke="#c5f8ff" stroke-width="2"/>')
    # moss and spikes
    add(f'<path d="M {cx-56} {by-169} Q {cx-48} {by-188} {cx-31} {by-180} L {cx-34} {by-165} Z M {cx+29} {by-190} Q {cx+45} {by-194} {cx+48} {by-177} L {cx+34} {by-174} Z" fill="#849957" stroke="#394b3a" stroke-width="2"/>')
    add(f'<path d="M {cx-25} {by-194} L {cx-40} {by-207} L {cx-24} {by-203} M {cx+22} {by-195} L {cx+39} {by-205} L {cx+31} {by-188}" fill="none" stroke="#6c5036" stroke-width="7" stroke-linecap="round"/>')

# place sprite centers. baseline 790
# Tavi target 126 height; built local height ~134 * .94 ~=126
tavi(centers[0],base,0.94)
mote(centers[1],base-8)
rootling(centers[2],base)
thornwing(centers[3],base)
sporeling(centers[4],base)
brambleguard(centers[5],base)
sentinel(centers[6],base)
# heights based on intended scale; boxes/labels in bottom region
heights=['1.75 tiles','0.65 tiles','0.85 tiles','0.85 tiles','0.95 tiles','2.2 tiles','3.75 tiles']
for i,c in enumerate(centers):
    # label placement below baseline, consistent area
    add(f'<text x="{c}" y="858" class="label" font-size="{18 if i != 6 else 17}" text-anchor="middle">{labels[i][0]}</text>')
    add(f'<text x="{c}" y="882" class="small" text-anchor="middle">{labels[i][1]}</text>')
    add(f'<text x="{c}" y="907" class="measure" text-anchor="middle">Target height: {heights[i]}</text>')
# footer guidance
add('<rect x="58" y="930" width="1676" height="48" rx="12" fill="#e4dac3" stroke="#c5b696"/>')
add('<text x="80" y="950" class="small" font-weight="bold">SCALE RULE</text>')
add('<text x="80" y="968" class="small">1 tile = 64 px baseline reference · Character drawings are proportion guides, not final sprite sheets; approve silhouettes before animation production.</text>')
add('</svg>')
svg=''.join(parts)
svg_path=Path('/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/archive/rebuilt-assets/lanterns_underroot_art003_character_scale.svg')
png_path=Path('/Users/abinashbasak/Desktop/games/lantrns/lantrns-game/archive/rebuilt-assets/lanterns_underroot_art003_character_scale.png')
svg_path.write_text(svg,encoding='utf-8')
cairosvg.svg2png(bytestring=svg.encode(),write_to=str(png_path),output_width=W,output_height=H)
print(svg_path, svg_path.stat().st_size)
print(png_path, png_path.stat().st_size)