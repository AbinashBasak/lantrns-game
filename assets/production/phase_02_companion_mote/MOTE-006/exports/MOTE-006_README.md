# MOTE-006 Glow pulse

six-frame animation prototype generated and visually reviewed; continuity/alpha cleanup and production approval pending.

6 derived 512 × 512 RGBA exports and horizontal strips. Unchanged built-in imagegen sources are archived in source_images. Crop/placement transforms, timing when applicable, and masks are described in the manifest. GIFs repeat for review.

Character-present glow pulse, distinct from FX-only light asset. Low/medium/high/peak/medium/low warm emission is visibly readable and body pose remains stable.

Glow exceeds requested 25px bound and neighboring haze may touch cell boundaries. Isolation/cleanup required before runtime use.

Small scale/leaf/outline drift prevents an exact seamless loop; low endpoints need final match.

All subject parts fit equal 512x512 cells; source alpha retained.

Generated model MOTE-001 is a proposal based on ART-003 and ART-005; user design approval has not been inferred.

Generated alpha is preserved. Review edge halos, tiny anatomy, identity consistency and timing before runtime use. No Godot integration or in-engine review performed.
