from pathlib import Path
from PIL import Image,ImageOps,ImageDraw
import json,hashlib,html
ROOT=Path(__file__).resolve().parents[1]
archive=ROOT/'archive/shared-chat'
generated=json.loads((archive/'retrieval-index.json').read_text())
references=json.loads((archive/'embedded-reference-retrieval.json').read_text())
assert len(generated)==36 and len(references)==47
assert all(r and r['status']=='saved' for r in references)
items=[]
for kind,records in [('Generated image',generated),('Embedded reference',references)]:
 for record in records:
  path=ROOT/record['file'];data=path.read_bytes()
  assert hashlib.sha256(data).hexdigest()==record['sha256']
  with Image.open(path) as im:
   im.verify()
  with Image.open(path) as im:size=list(im.size)
  items.append({**record,'kind':kind,'dimensions':size})
(archive/'complete-image-inventory.json').write_text(json.dumps(items,ensure_ascii=False,indent=2))
source=json.loads((archive/'rechecked-chat-data.json').read_text())['loaderData']['routes/share.$shareId.($action)']['serverResponse']['data']
order={key:i for i,key in enumerate(source['mapping'])}
items.sort(key=lambda x:(order.get(x['message_id'],9999),x.get('index',0)))
parts=['<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lanterns Underroot — complete chat image archive</title><style>body{font:16px system-ui;background:#142125;color:#eee7d5;margin:32px}header{max-width:980px}a{color:#e8bc70}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px}figure{margin:0;padding:15px;background:#223338;border-radius:10px}img{display:block;width:100%;height:240px;object-fit:contain;background:repeating-conic-gradient(#34474a 0 25%,#405254 0 50%) 0/24px 24px}figcaption{margin-top:12px;line-height:1.5}small{color:#b3c2b5}h1{font-size:32px}</style><header><h1>Lanterns Underroot — chat image archive</h1><p>83 saved images from the shared chat: 36 original generated images and 47 embedded reference images. Ordered by their chat messages.</p><p>The embedded references were displayed in the conversation. Their source links are preserved for attribution. Original processed sandbox-download images and locally rebuilt animation outputs are tracked separately in the recovery notes.</p><p><a href="transcript.md">Chat transcript</a> · <a href="complete-image-inventory.json">Complete image inventory</a> · <a href="../../docs/asset-recovery.md">Recovery notes</a></p></header><div class="grid">']
for i,item in enumerate(items,1):
 rel=Path(item['file']).relative_to('archive/shared-chat').as_posix();title=html.escape(item.get('title','Image'));kind=html.escape(item['kind']);w,h=item['dimensions'];link=item.get('url') or item.get('original_content_url')
 source_link=f'<br><a href="{html.escape(link,quote=True)}">Reference source</a>' if link else ''
 parts.append(f'<figure><a href="{html.escape(rel,quote=True)}"><img loading="lazy" src="{html.escape(rel,quote=True)}" alt="{title}"></a><figcaption><small>{i:02d} · {kind} · {w} × {h}</small><br>{title}{source_link}</figcaption></figure>')
parts.append('</div></html>');(archive/'IMAGE-GALLERY.html').write_text('\n'.join(parts))
lines=['# Complete chat image index','', 'The shared chat contains **36 original generated images** and **47 additional embedded reference images**. All **83 images** are saved and have been decoded and hash-verified.','', '[Open the offline visual gallery](IMAGE-GALLERY.html) · [Machine-readable inventory](complete-image-inventory.json)','', '| # | Type | Image | Dimensions |','|---:|---|---|---|']
for i,item in enumerate(items,1):
 rel=Path(item['file']).relative_to('archive/shared-chat').as_posix();title=item.get('title','Image').replace('|','\\|');w,h=item['dimensions']
 lines.append(f'| {i} | {item["kind"]} | [{title}]({rel}) | {w} × {h} |')
(archive/'IMAGE-INDEX.md').write_text('\n'.join(lines)+'\n')
# A compact contact sheet specifically showing the newly recovered images.
cols=5;cw=240;ch=190
contact=Image.new('RGB',(cols*cw,((len(references)+cols-1)//cols)*ch),'#142125');draw=ImageDraw.Draw(contact)
for i,item in enumerate(references):
 with Image.open(ROOT/item['file']) as im:
  im=ImageOps.contain(im.convert('RGB'),(cw-12,ch-40))
  x=(i%cols)*cw;y=(i//cols)*ch;contact.paste(im,(x+(cw-im.width)//2,y))
  label=f'{i+1:02d} '+item.get('title','Image')[:31]
  draw.text((x+6,y+ch-32),label,fill='#eee7d5')
contact.save(archive/'newly-recovered-references.jpg',quality=90)
report={'generated_images':36,'embedded_reference_images':47,'total_saved_images':83,'decoded_successfully':len(items),'sha256_verified':len(items),'missing_generated_images':0,'missing_embedded_reference_images':0,'scope':'All unique generated image pointers and embedded image records in the shared-chat snapshot; original sandbox derivative downloads are tracked separately.'}
(archive/'image-audit-result.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
