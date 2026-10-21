# Exact title reference and shared botanical dialogue

The title screen uses the user-supplied UI-016 reference unchanged, preserving its original artwork, logo, text and composition. Transparent live hit areas sit over Begin Chapter1 and Replay the prologue. Begin opens Chapter1 directly; Replay starts the prologue, whose eastern exit still continues into Chapter1. Keyboard start, mouse and touch use the same routes. F5 opens this shared title screen.

Six subtle runtime PointLight2D emitters add restrained movement to the reference lanterns. They affect only the menu artwork mask and remain animated while the title is paused. Reduced-effects mode zeros the added light, preserving the exact supplied image. No frame repaint or replacement text is drawn over this title reference.

Regular prologue and chapter dialogue now share UI-009 generation03: a text-free parchment/root frame with side lanterns, separate live speaker nameplate, serif body text and green/gold Continue button. Mouse/touch activate the callback once; E/Y/Enter use shared dialogue input. Long Rusk/tutorial lines fit adaptively while remaining within the text area. Pause hides the dialogue overlay so utility controls stay accessible. The existing orchard memory and chapter-completion cards retain their specialized layouts. Pause/settings labels and buttons now use the same serif, emerald and gold vocabulary.

Original artwork and earlier generations remain in production folders. The exact title is recorded as user-provided artwork, not a new AI generation. Source/runtime hashes and crop records live in the UI runtime manifest and individual UI-016/UI-009 metadata. Native previews: [title](chapter01-exact-title-preview.png), [dialogue](botanical-dialogue-preview.png).

Validation covers original reference bytes/dimensions, actual menu controls and routes, restrained real menu lights, long dialogue fitting, single-step continuation and pause/resume. See [full validation](prologue-validation.txt) and [exported-pack validation](prologue-pack-validation.txt). Physical-device performance and final art/release approval remain separate.

All344 source-project checks pass, including13 exact-menu,17 botanical-dialogue and10 title-lighting checks.

The rebuilt exported content pack passes all included suites, including exact-title pixel integrity, botanical dialogue and menu lighting. All488 runtime source/output hash records verify. Independent parallel reviews confirmed native layout, source provenance and master/project checklist synchronization.
