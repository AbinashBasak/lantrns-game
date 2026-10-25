"""Archive the supplied continuation-chat ZIP without treating prompts as delivered art."""
import collections
import hashlib
import json
import re
import zipfile
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
ZIP = ROOT.parent / '1.zip'
CID = '6add021c-c67c-83ec-9352-619f2860e01f'
DEST = ROOT / 'assets/production/source_archives' / ('chat_export_' + CID[:8])
DOC = ROOT / 'docs/chapter03'
MASTER = Path('/Users/abinashbasak/Downloads/lanterns_underroot_master_asset_checklist.md')
COPY = ROOT / 'docs/lanterns_underroot_master_asset_checklist.md'
REG = ROOT / 'assets/production/asset_registry.json'
BIBLE = ROOT / 'lanterns_underroot_chapter_3_production_bible.md'
ID_PATTERN = r'C3[-_][A-Z]+[-_]\d{3}(?:[-_](?:[A-Z]+[-_])?\d{3})?'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and path.read_bytes() != data:
        raise RuntimeError(f'Refusing to replace an earlier archive file: {path}')
    path.write_bytes(data)


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n')


def main():
    # Read both designated sources before associating any registered asset.
    master = MASTER.read_text() if MASTER.exists() else COPY.read_text()
    if not MASTER.exists():
        print('Downloads master unavailable; using project copy.')
    registry = json.loads(REG.read_text())
    bible_bytes = BIBLE.read_bytes()
    official_ids = set(re.findall(ID_PATTERN, bible_bytes.decode()))
    zip_hash = digest(ZIP.read_bytes())
    members = []
    with zipfile.ZipFile(ZIP) as archive:
        for entry in archive.infolist():
            if entry.is_dir():
                continue
            rel = Path(entry.filename)
            if rel.is_absolute() or '..' in rel.parts:
                raise RuntimeError(f'Unsafe archive member: {entry.filename}')
            data = archive.read(entry)
            path = DEST / 'original_export' / rel
            save(path, data)
            members.append(dict(zip_member=entry.filename, path=str(path),
                                bytes=len(data), sha256=digest(data)))
        messages = json.loads(archive.read(next(x.filename for x in archive.infolist()
                                                if x.filename.endswith('/messages.json'))))
        raw = json.loads(archive.read(next(x.filename for x in archive.infolist()
                                           if x.filename.endswith('/conversation.raw.json'))))
    assert messages['id'] == CID
    mapping = raw['mapping']
    images = [r for r in members if r['path'].lower().endswith('.png')]
    linked = set()
    missing = []
    by_key = collections.defaultdict(list)
    for index, message in enumerate(messages['messages']):
        for item in message['items']:
            if item['type'] == 'asset':
                by_key[item['key']].append((index, message))
    for key, refs in by_key.items():
        matches = [r for r in images if Path(r['path']).stem.endswith('-' + key[-8:])]
        if not matches:
            missing.append(dict(file_key=key, messages=[m['id'] for _, m in refs],
                                roles=sorted({m['role'] for _, m in refs}),
                                status='not included in ZIP; no replacement invented'))
            continue
        assert len(matches) == 1
        record = matches[0]
        linked.add(record['path'])
        index, message = refs[0]
        node = mapping.get(message['id'], {})
        raw_message = node.get('message') or {}
        parent_id = node.get('parent')
        parent = (mapping.get(parent_id, {}).get('message') or {})
        parts = parent.get('content', {}).get('parts', [])
        prompt_text = '\n'.join(p for p in parts if isinstance(p, str))
        fallback = False
        if not prompt_text or 'skipped_mainline' in prompt_text:
            # Retain context for investigation; never silently assign its ID.
            prompt_text = '\n'.join(a.get('text', '') for a in
                                    messages['messages'][max(0, index-1)]['items'])
            fallback = True
        ids = list(dict.fromkeys(i.replace('_', '-') for i in re.findall(ID_PATTERN, prompt_text)))
        title = raw_message.get('metadata', {}).get('image_gen_title')
        pointers = [p for p in raw_message.get('content', {}).get('parts', [])
                    if isinstance(p, dict) and p.get('content_type') == 'image_asset_pointer']
        generated = next((p for p in pointers if key in p.get('asset_pointer', '')), {})
        issues = []
        if index in (8, 10):
            issues.append('Explicitly rejected by source conversation at message index 11.')
        if not ids:
            issues.append('No explicit asset ID in associated prompt; contextual association pending.')
        if len(ids) > 1:
            issues.append('Multiple requested IDs; do not split or assign automatically.')
        record.update(file_key=key, source_message_id=message['id'], source_message_index=index,
                      prompt_message_id=parent_id, prompt_text=prompt_text,
                      prompt_context_fallback=fallback, requested_asset_ids=ids,
                      generated_subject_title=title,
                      generation_metadata=generated.get('metadata', {}).get('generation'),
                      source_pointer=generated.get('asset_pointer'),
                      source_time=message.get('time'), issues=issues,
                      review_status='failed source attempt' if index in (8, 10) else
                                    'archived source attempt; visual deliverable review pending')
    for record in images:
        record.setdefault('requested_asset_ids', [])
        record['official_requested_asset_ids'] = [i for i in record['requested_asset_ids'] if i in official_ids]
        record['unofficial_requested_asset_ids'] = [i for i in record['requested_asset_ids'] if i not in official_ids]
        record['production_requirements_status'] = dict(
            purpose_and_scenes='unverified; use designated bible inventory',
            pivot='unverified', frame_count=None, fps=None, z_index=None,
            receives_light=None, casts_shadows=None, emits_light=None,
            collision_shape='unverified; never infer from image alpha bounds',
            import_filter='not assigned', compression='not assigned',
            status='source attempt; cleanup and review pending',
            approval_gate='Bible sections 1, 5.3, 15 and 17; actual-scene QA required')
        with Image.open(record['path']) as im:
            im.load()
            alpha = im.getchannel('A') if 'A' in im.getbands() else None
            record.update(dimensions=list(im.size), mode=im.mode,
                          has_alpha_channel=alpha is not None,
                          alpha_extrema=list(alpha.getextrema()) if alpha is not None else None,
                          transparent_pixels_present=alpha is not None and alpha.getextrema()[0] < 255,
                          visible_bounds=list(alpha.getbbox()) if alpha is not None and alpha.getbbox() else None,
                          provenance='unchanged bytes supplied in user ZIP; not reconstructed',
                          production_approved=False, frame_count_verified=False,
                          timing_status='not normalized or timed; consult preserved source prompt',
                          runtime_integrated=False)
        if record['path'] not in linked:
            record.update(requested_asset_ids=[], source_message_id=None,
                          review_status='unmatched archive image; association pending',
                          issues=['No exact file-key suffix correspondence in messages.json.'])
    # Keep a manageable visual index without modifying any original image.
    preview_paths = []
    ordered = sorted(images, key=lambda r: (r.get('source_message_index', 99999), r['path']))
    for page in range((len(ordered) + 23) // 24):
        subset = ordered[page*24:(page+1)*24]
        sheet = Image.new('RGB', (1600, 6*215), '#202a30')
        draw = ImageDraw.Draw(sheet)
        for i, r in enumerate(subset):
            x, y = (i % 4)*400, (i//4)*215
            with Image.open(r['path']) as im:
                im = im.convert('RGBA'); im.thumbnail((390, 158))
                sheet.paste(im, (x+(400-im.width)//2, y), im)
            label = f"{Path(r['path']).name} | msg {r.get('source_message_index', '?')}"
            draw.text((x+5, y+160), label[:65], fill='white')
            draw.text((x+5, y+176), ', '.join(r['requested_asset_ids'])[:62], fill='#e7c477')
            title_label = (r.get('generated_subject_title') or 'Unmatched image')[:60]
            draw.text((x+5, y+192), title_label.encode('ascii', 'replace').decode(), fill='#a7d8db')
        path = DEST / 'previews' / f'chat_export_{CID[:8]}_contact_{page+1:02}.jpg'
        path.parent.mkdir(parents=True, exist_ok=True)
        sheet.save(path, quality=90)
        preview_paths.append(str(path))
    # Only extend an existing registered folder. New/unofficial IDs remain indexed
    # in the archive until their definitions and actual outputs are reviewed.
    sentinel = next(a for a in registry['assets'] if a['asset_id'] == 'C3-ENM-004')
    metadata_path = Path(sentinel['metadata'])
    meta = json.loads(metadata_path.read_text())
    for r in images:
        if r['requested_asset_ids'] != ['C3-ENM-004']:
            continue
        path = Path(sentinel['folder']) / 'source_images' / (
            'C3-ENM-004_export_' + Path(r['path']).name)
        save(path, Path(r['path']).read_bytes())
        entry = dict(r, path=str(path), archive_original_path=r['path'],
                     source_archive=str(ZIP), source_archive_sha256=zip_hash,
                     action='source attempt; see prompt and generated subject title')
        existing = next((s for s in meta['sources'] if s.get('path') == str(path)), None)
        if existing:
            assert existing['sha256'] == entry['sha256']
        else:
            meta['sources'].append(entry)
        r['registered_source_path'] = str(path)
    stage = 'continuation ZIP source attempts archived; visual/animation QA and production approval pending'
    meta['stage'] = stage
    if meta.get('notes') and not meta.get('continuation_archive'):
        meta.setdefault('prior_review_notes', []).append(dict(
            context='before continuation ZIP intake', notes=meta['notes']))
    meta['notes'] = ('Earlier generations retained. Continuation includes idle, walk, shield, windup, slam, '
                     'recovery, hurt and death requests; prompts do not establish correct delivered art. '
                     'The first two continuation outputs were explicitly rejected. Frame, identity, alpha, '
                     'shield/weapon continuity and VFX separation remain subject to review.')
    meta['continuation_archive'] = str(DEST / 'metadata.json')
    write_json(metadata_path, meta)
    sentinel.update(source_count=len(meta['sources']), stage=stage)
    counts = collections.Counter(i for r in images for i in r['requested_asset_ids'])
    manifest = dict(source_zip=str(ZIP), source_zip_sha256=zip_hash,
                    governing_production_bible=str(BIBLE), production_bible_sha256=digest(bible_bytes),
                    conversation_id=CID, source_kind='user-supplied chat export ZIP',
                    member_count=len(members), image_count=len(images),
                    exact_message_image_matches=len(linked),
                    unlinked_image_count=len(images)-len(linked),
                    missing_asset_references=missing, requested_id_counts=dict(counts),
                    members=members, image_records=images, preview_paths=preview_paths,
                    stage='complete ZIP intake; asset review pending', production_approved=False,
                    warning='Requested IDs are intent, not proof of delivered subject or completed animation. '
                            'Conversation-generated extended IDs are not official inventory additions.')
    write_json(DEST / 'metadata.json', manifest)
    report = DOC / 'continuation-zip-intake.md'
    lines = ['# Continuation ZIP intake — 2026-10-25', '',
             f'Governing rules: [user-designated Chapter 3 production bible]({BIBLE}). '
             f'SHA-256 `{digest(bible_bytes)}`. Its copy under docs/ is byte-identical at intake. '
             'Use its official inventory, ordered backlog and definition of done strictly.', '',
             f'User-supplied archive: [{ZIP.name}]({ZIP}). SHA-256 `{zip_hash}`.', '',
             f'All {len(members)} file members were extracted unchanged, including {len(images)} PNGs, '
             'the conversation, JSON records, two downloadable text/Markdown files and export diagnostics. '
             f'{len(linked)} PNGs have exact file-key matches; three remain unassociated. '
             f'{len(missing)} referenced user attachment keys are absent from the ZIP; '
             'six are explicitly reported as HTTP 403 in the original errors.txt. No browser or download recovery was used.', '',
             f'[Complete provenance, hashes, dimensions, alpha and message mapping]({DEST / "metadata.json"}).', '',
             '## Interpretation', '',
             'Every PNG is a source attempt, not a verified completed asset. Original output titles and prompts '
             'are preserved separately. Repeated wrong subjects occur: Sentinel requests produced crab/serpent '
             'art, Golden Fragment requests produced chests, Lore Tablet requests produced hearts/keys, '
             'and BG-012 root requests produced water caustics. Failed/repeated generations remain archived.', '',
             'Only C3-ENM-004 was added to an already registered source folder. Other images remain fully '
             'preserved and searchable in this archive; intended IDs are not newly registered official assets. '
             'No checkboxes, runtime art, frame slicing or gameplay systems were changed.', '',
             'The original production bible defines BG-011 as water caustics and BG-012 as foreground roots. '
             'Assistant-created BG-011-001–026, BG-008-LGT/VFX extensions and ENM-009 are not automatically '
             'official asset IDs. Do not infer completed caustics, root art, depth maps or mask maps from their labels.', '',
             '## Contact sheets', '']
    lines += [f'- [Page {i+1}]({p})' for i, p in enumerate(preview_paths)]
    lines += ['', '## Requested IDs in source prompts', '', '| Requested ID | Attempts |', '|---|---:|']
    lines += [f'| {i} | {n} |' for i, n in sorted(counts.items())]
    report.write_text('\n'.join(lines) + '\n')
    registry['chapter_03_continuation_archive'] = dict(
        conversation_id=CID, source_zip=str(ZIP), metadata=str(DEST / 'metadata.json'),
        governing_production_bible=str(BIBLE), production_bible_sha256=digest(bible_bytes),
        report=str(report), image_count=len(images), stage=manifest['stage'])
    registry['last_updated'] = '2026-10-25'
    write_json(REG, registry)
    marker = '<!-- continuation-zip-6add021c:start -->'
    block = (f'{marker}\n## Chapter 3 continuation ZIP — 2026-10-25\n\n'
             f'All {len(images)} original PNGs and conversation/files from the supplied `1.zip` are preserved. '
             f'{len(linked)} images map exactly to source message file keys; three remain unassociated. '
             'Nine user attachment references have no included file (six explicit HTTP 403 errors). '
             'C3-ENM-004 continuation attempts are saved in its registered source folder; other attempts '
             'remain indexed in the complete source archive pending asset association and visual review. '
             'Wrong/repeated outputs are retained as attempts, not completed deliverables. Existing checkboxes '
             'and production approvals remain unchanged.\n\n'
             f'[Intake report]({report}) · [Archive provenance]({DEST / "metadata.json"}) · '
             f'[Sentinel metadata]({metadata_path})\n'
             '<!-- continuation-zip-6add021c:end -->')
    if marker in master:
        master = re.sub(re.escape(marker)+r'.*?<!-- continuation-zip-6add021c:end -->',
                        lambda _: block, master, flags=re.S)
    else:
        master = master.rstrip() + '\n\n' + block + '\n'
    master = master.replace('Death sheet absent. Shield/weapon continuity and core/VFX separation need review.',
                            'Continuation death-request and other source attempts archived; correctness, '
                            'shield/weapon continuity and core/VFX separation need review.')
    if MASTER.exists():
        MASTER.write_text(master)
    COPY.write_text(master)
    # Validate every archive member, registered source copy and new saved link.
    for r in members:
        assert digest(Path(r['path']).read_bytes()) == r['sha256'], r['path']
    for r in images:
        if 'registered_source_path' in r:
            assert digest(Path(r['registered_source_path']).read_bytes()) == r['sha256']
    for path in [DEST / 'metadata.json', report, metadata_path, *map(Path, preview_paths)]:
        assert path.exists(), path
    assert not MASTER.exists() or MASTER.read_bytes() == COPY.read_bytes()
    print(json.dumps(dict(members=len(members), images=len(images), exact_matches=len(linked),
                          missing_references=len(missing), sentinel_sources=len(meta['sources']),
                          report=str(report), provenance=str(DEST / 'metadata.json')), indent=2))


if __name__ == '__main__':
    main()
