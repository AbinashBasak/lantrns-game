# ZIP storage

The game loads unpacked resources under `assets/`; its scripts and scenes do not load ZIP files. The 68 existing ZIPs are source downloads or prototype distribution bundles. They remain on disk at their recorded paths, but `.gitignore` excludes ZIPs from Git. Checklist links to these archives are local archive links; they will not be present in a fresh clone. Use the tracked unpacked sources, exports, previews and metadata from a clone.

The largest archive was `assets/production/phase_03_enemies_and_chapter_1_boss/PHASE03_prototype_bundle.zip` (199.21 MiB). It duplicated the phase folder as a distribution bundle. An initial remote-reference check found the GitHub repository empty. The unpushed initial commit was repaired to exclude ZIPs, retaining a local backup reference at `refs/local-backup/pre-zip-cleanup`. The backup is local recovery history and is not included in a normal branch push.

No ZIP bytes were deleted. Existing metadata and provenance records remain intact. `tools/rebuild_animation_packs.py` writes optional download bundles; it does not load them into the game. New Phase 04 work uses unpacked exports without ZIP bundles.

See `zip-storage-audit.json` for the inventory.
