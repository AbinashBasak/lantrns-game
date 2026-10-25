# Chapter 3 section authoring scaffolds

These eight unpopulated Godot scene structures follow §4.1–4.2 of `lanterns_underroot_chapter_3_production_bible.md`. They are **not playable sections and are not approved**. No campaign route or existing chapter scene is changed.

Open each `.tscn` in Godot to author its environment, lighting, gameplay objects and effects. The saved hierarchy is editor-native; there is no runtime construction script. All eight scene roots carry `scaffold = true`, their stable section ID, and the source bible reference.

Parallax layers, TileMapLayers, prop groups and VFX groups are intentionally empty pending the ordered production assets and their review. No stand-in art, invented terrain coordinates, player instances, enemy instances, camera limits or collision geometry are included. Default node origins are not an authored level layout. CameraBounds is an empty grouping node until actual section bounds exist.

CanvasModulate remains neutral white pending art review. Populate LanternLights and CrystalLights with native PointLight2D scenes and LightOccluders with reviewed LightOccluder2D shapes when the matching visible sources and geometry are available. Dynamic illumination must stay separate from base artwork. AmbientParticles is an empty Node2D group, not a running particle emitter.

ExitTrigger is an Area2D with monitoring and monitorability disabled, zero collision masks and no collider. It cannot transition anywhere. Populate and validate destination spawn IDs and collision geometry only during the documented integration stage.

The bible’s section approval requirements still apply: reachable complete route, readable combat, persistent interactables, camera and lighting checks, save/reload and performance validation. None are marked complete by these scaffolds.
