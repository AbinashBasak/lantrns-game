# Sentinel reward scene polish

The existing reward artwork now uses a 3.8-second chest sequence: anticipation rattle, unlatch, lid opening, Rootward Charm reveal, and a settled looted state. Four existing chest states share one source-pixel scale and floor anchor. Gold orbit trails, sparks, and framed point awards provide motion without replacing the generated assets.

Real PointLight2D illumination follows the chest opening, floating Golden Fragment, and onward portal. Nearby temple lanterns retain their dynamic lighting. Effects freeze on pause, reduce motion with reduced-effects settings, and cull distant lights without adding shadow passes.

The Golden Fragment uses one floating runtime sprite above an empty pedestal, moving gold trails, and a collection burst. A slim chapter objective and framed chest label with a clickable E USE prompt guide the reward sequence. Dialogue and pause hide those prompts.

Rewards retain their existing once-only gameplay behavior: opening grants 500 points, Rootward Charm, sword damage upgrade, and vitality restoration. Animation does not delay or duplicate the grant. Final Sentinel victory remains 1000 points.

Validation: source integration suite and isolated exported-pack suite include 33 additional reward checks (9 animation, 13 lighting, 11 UI). Native captures cover closed, opening, reveal, and looted chest stages. Physical-device performance and human pacing review remain pending.

Previews: [closed](reward-closed-preview.png), [opening](reward-opening-preview.png), [reveal](reward-reveal-preview.png), [looted](reward-looted-preview.png).

No production source images were changed or newly generated; the production asset registry and approval checkboxes remain unchanged.
