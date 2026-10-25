# Chapter 3 environment preparation

Existing ZIP art is organized in bible order by verified subject, not unreliable requested IDs. All original files remain untouched in the production source archive. Detailed source, crop rectangles, alpha operations, dimensions, hashes, pivots, layers, lighting/collision roles and blockers are recorded in [the JSON handoff](environment-asset-preparation.json).

Import candidates are under `art/environment/chapter_03/`. Open `scenes/chapter_03/review/c3_environment_asset_review_01.tscn` through `_08.tscn` for editable Sprite2D galleries. These galleries do not alter the campaign or approve art. Depth/mask panel crops live in `art/source/chapter_03/environment/guide_panels/` with `.gdignore`; they are reference images, not inferred normal maps.

Most modular sheets use a painted checkerboard. Their base-panel exports have reconstructed alpha using an explicit bright-neutral key, with no enlargement. Review isolated edges and compare against the archived source before runtime placement. The statue120 and distant layer076/079/090 have native alpha. No complete level screenshot or atlas thumbnail is enlarged into playable scenery.

The set includes isolated ruined arches/pillars/statues, ornate ledges, a stair and rope-bridge candidate, wall reliefs, unlit hanging lamp, hanging vines and individual rubble. Perspective stairs/bridges need gameplay fitting; seamless mossy terrain top/middle/underside and matching rune-door states remain unfulfilled. Source claims of C3-BG-011 sub-IDs are remapped to official PROP/TILE/DEC IDs; caustics requested as BG012 belong to BG011 and are handled with VFX.

Validated 59 RGBA exports and hash/link records. Godot 4.7.2 imported and rendered all eight native galleries without warnings/errors. Resource-reference validation passed with zero errors and zero warnings. Native captures are `environment-asset-preparation-native-01.png` through `-08.png`; see [validation details](environment-asset-preparation-validation.json). The alpha-key silhouettes remain cleanup/review candidates rather than final production approvals.
