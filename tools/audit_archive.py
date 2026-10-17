from pathlib import Path
import json,uuid,hashlib
ROOT=Path(__file__).resolve().parents[1]
archive=ROOT/'archive/shared-chat'
source=json.loads((archive/'image-manifest.json').read_text())
index=[]
for item in source:
 ptr=item['pointer'];ident=str(uuid.UUID(ptr['asset_pointer'].split('file_')[1].split('?')[0]))
 path=archive/'images'/(ident+'.png')
 if not path.exists():raise FileNotFoundError(path)
 data=path.read_bytes()
 if not data.startswith(b'\x89PNG\r\n\x1a\n'):raise ValueError(path)
 index.append({'title':item['title'],'file':str(path.relative_to(ROOT)),'bytes':len(data),'source_bytes':ptr['size_bytes'],'sha256':hashlib.sha256(data).hexdigest(),'message_id':item['message_id']})
(archive/'retrieval-index.json').write_text(json.dumps(index,ensure_ascii=False,indent=2))
lines=['# Original generated images','',f'All {len(index)} original generated images referenced by the shared conversation are stored locally.','', '| Image | Saved source | Bytes |','|---|---|---:|']
for item in index:
 name=Path(item['file']).name
 lines.append(f"| {item['title']} | [{name}](images/{name}) | {item['bytes']} |")
(archive/'GENERATED-IMAGE-INDEX.md').write_text('\n'.join(lines)+'\n')
print(f'ARCHIVE AUDIT PASS: {len(index)}/{len(source)} original generated images present; signatures and SHA-256 recorded')

reference_path = archive/'embedded-reference-retrieval.json'
if reference_path.exists():
    references=json.loads(reference_path.read_text())
    for record in references:
        assert record and record['status']=='saved', record
        path=ROOT/record['file']
        assert hashlib.sha256(path.read_bytes()).hexdigest()==record['sha256'], path
    print(f'EMBEDDED REFERENCE AUDIT PASS: {len(references)} saved reference images; SHA-256 verified')
