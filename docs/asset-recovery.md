# Chat asset recovery

Source: https://chatgpt.com/share/6ad136a4-4cc8-83ee-9742-05bc90e2a1dc

The full shared page, decoded conversation, transcript, 102 tool-code blocks, 35 sandbox file references, and all 36 original generated images are preserved under `archive/shared-chat/`. `IMAGE-INDEX.md` lists the images by their generation titles; `retrieval-index.json` records file locations, sizes, original message IDs, and SHA-256 hashes. Alternate and rejected generations are retained. The source chat stopped without a successful TAVI-017 hurt-animation deliverable.

Original Markdown contents recovered from embedded tool output include the chapter plan, prologue/Chapter 1 development plan, and master asset checklist. The complete campaign story is saved as `docs/full-story.md`. Existing Lanterns Underroot reference boards in Downloads were also copied into `assets/references/` without changing their originals.

The shared chat's sandbox ZIP/GIF/processed-sheet links did not yield downloads. Their original bytes are not claimed to be recovered. Seven animation packs were rebuilt from the recovered source sheets, with independent frame PNGs, sprite sheets, GIFs, contact sheets, and source manifests. These packs live under `archive/rebuilt-assets/`; the runtime PNGs and Godot SpriteFrames live under `assets/characters/tavi/`. Each manifest records the source SHA-256, crop rectangles and frame timing. Rebuilt dimensions and extraction can differ from the source chat's earlier prototype packs.

The reference sheets include headers, labels, silhouettes and annotations. Those sheets are archived whole; gameplay uses only extracted character frames. The character extraction excludes annotations and normalizes frame canvases and foot baselines. Alpha edges, scarf/sword clipping, pose consistency and the RGB-matted rising-jump source still need hand cleanup for release. Some sword slash effects are baked into the original character art.

The source recipes remain available as data in `tool-code.json`, including recipes for the ART-003 scale reference and ART-004 material board. Reconstructed reference outputs, when present, are explicitly labeled in `archive/rebuilt-assets/`.

The archive is excluded from Godot's resource importer through `.gdignore`. It remains ordinary accessible project files. Reference boards are not used as level backgrounds or tiles. The level environment and non-player characters are code-drawn placeholders.

## Corrected image audit

The first audit covered generated-image pointers only and missed reference images embedded in rendered assistant responses. A recursive audit of the shared chat's component image records found 47 additional reference-image entries. All 47 were downloaded, decoded, and hash-verified. The archive now includes 83 chat-image files: 36 generated sources plus 47 embedded references.

Open `archive/shared-chat/IMAGE-GALLERY.html` for an offline visual index, or `IMAGE-INDEX.md` for a linked list. `embedded-reference-retrieval.json` preserves titles, source URLs, originating message IDs, download status and hashes. `image-audit-result.json` records the completed checks. These reference images are archived as chat references and are not used as game assets.
