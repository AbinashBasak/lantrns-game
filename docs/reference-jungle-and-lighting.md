# Reference forest scene and dynamic lighting

The three mandatory jungle rooms and main forest now use the supplied modular assets with source colors preserved. The full game screenshot is kept as a reference, not a flattened playable level. Twenty-two cutouts/UI modules were recovered from the supplied sheet; the checkerboard was baked into that source and was explicitly alpha-masked. Retained diffuse pixels keep their RGB values. Live guidance and keyboard text use reconstructed empty interiors and separate icons/borders, rather than baked copy.

Five new built-in image_gen replacements address missing detail: a 1536×1024 forest backdrop, a complete supported treehouse/trunk, a rooted tree arch, a waterfall cliff and a broad lush fern cluster. Source originals and older sheet derivatives remain archived. Generated scenery has about 1000–2100px source width and is reduced to runtime size; it is not enlarged from the asset-sheet thumbnail. The background preserves its aspect ratio. Isolated props are capped at native resolution, including the small supplied vines and leaf accents, so they cannot be enlarged into pixelated scenery. Generation prompts and file hashes are in the runtime manifests and each existing asset-ID metadata file.

Architecture sits at fixed world positions with its roots entirely on authored solid floors; its lamps share the same transformed coordinates used by the lights. Cascades are behind actual gaps. Terrain interior slices prevent transparent grid seams; floating platforms keep natural end caps. Dense small foliage patches meet supported surfaces while leaving the player's body, gaps and landing areas visible. The existing player, enemies, collisions, mandatory puzzles and rewards remain controller-owned. All platform paths were checked against the player's 330px/s speed, 680px/s jump and 1600px/s² gravity with conservative margins, and actual traversal tests pass.

The original player hearts and health bar are preserved. Points, objective/feedback cards, supplied leaf guidance and keyboard keycaps use live content. Jungle progress text is contained in the upper-left objective card. Changed instructions auto-hide after five seconds; identical repeated source text cannot restart them.

World lighting uses actual PointLight2D nodes, a shared radial .tres, neutral mild CanvasModulate ambient and terrain/actor occluders. Lamp cores, treehouse lamps, puzzle lights, Mote and player emitters illuminate nearby objects separately from the painted art. Offscreen lights are disabled and at most two nearest lamps use shadows. Reduced effects removes flicker and shadow passes. HUD uses its separate canvas. No fake normal maps were introduced; CanvasTexture normal workflows are documented in the installed skill for future authored normals.

A frozen native-renderer comparison switched only world PointLight2D nodes on/off while retaining ambient, scenery and UI. It changed more than 145,000 world pixels below y220, establishing real illumination independent of painted highlights. See reference-lighting-render-proof.json and the on/off/difference PNGs. Painted distant-house highlights naturally remain when real lights are off.

Validation: 276 scene/support/reachability/anchor checks, 34 traversal checks, 29 dynamic HUD checks, 12 reference light checks, 11 guidance checks and 11 reward HUD checks pass. Native Godot OpenGL/Metal rendering was reviewed in all three rooms and the main forest. Existing tests may emit resource-cleanup messages after successful assertions; physical-device performance and final art approval remain unverified.

The user-provided godot-2d-lighting skill is installed in the personal skills folder and validated. Persistent project decisions/research are recorded in project-memory.md and linked from the root AGENTS.md.

Primary research sources:

- [Godot 2D lights and shadows](https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html)
- [Light2D masks, ranges and shadow filtering](https://docs.godotengine.org/en/stable/classes/class_light2d.html)
- [CanvasTexture normal maps](https://docs.godotengine.org/en/stable/classes/class_canvastexture.html)
- [DirectionalLight2D limitations](https://docs.godotengine.org/en/stable/classes/class_directionallight2d.html)
