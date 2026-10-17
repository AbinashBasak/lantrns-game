"""Download image references embedded in the source chat's rendered responses."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.request import Request,urlopen
import json,hashlib,re,time
ROOT=Path(__file__).resolve().parents[1]
ARCHIVE=ROOT/'archive/shared-chat'
OUT=ARCHIVE/'reference-images'
OUT.mkdir(exist_ok=True)
records=json.loads((ARCHIVE/'embedded-reference-manifest.json').read_text())

def recover(pair):
 i,record=pair
 name=re.sub(r'[^a-z0-9]+','-',record.get('title','image').lower()).strip('-')[:70]
 result={**record,'archive_id':f'reference-{i+1:03d}','attempts':[]}
 for field in ['content_url','original_content_url','thumbnail_url']:
  url=record.get(field)
  if not url:continue
  try:
   req=Request(url,headers={'User-Agent':'Mozilla/5.0'})
   with urlopen(req,timeout=18) as response:
    kind=response.headers.get('Content-Type','').split(';')[0];data=response.read(25_000_001)
   if len(data)>25_000_000:raise ValueError('Image exceeds 25 MB limit')
   if data.startswith(b'\x89PNG\r\n\x1a\n'):ext='.png'
   elif data.startswith(b'\xff\xd8'):ext='.jpg'
   elif data.startswith((b'GIF87a',b'GIF89a')):ext='.gif'
   elif data.startswith(b'RIFF') and data[8:12]==b'WEBP':ext='.webp'
   elif b'<svg' in data[:1000]:ext='.svg'
   elif kind in ['image/avif','image/heif']:ext='.avif'
   else:raise ValueError(f'Response is not a recognized image ({kind})')
   path=OUT/f'{i+1:03d}-{name}{ext}';path.write_bytes(data)
   result.update(status='saved',file=str(path.relative_to(ROOT)),retrieved_from=field,bytes=len(data),sha256=hashlib.sha256(data).hexdigest(),content_type=kind)
   break
  except Exception as exc:result['attempts'].append({'field':field,'error':str(exc)})
 else:result['status']='unavailable'
 return i,result

results=[None]*len(records)
with ThreadPoolExecutor(max_workers=10) as pool:
 futures=[pool.submit(recover,pair) for pair in enumerate(records)]
 for future in as_completed(futures):
  i,result=future.result();results[i]=result
  print(result['archive_id'],result['status'],result.get('file',''),flush=True)
  (ARCHIVE/'embedded-reference-retrieval.json').write_text(json.dumps(results,ensure_ascii=False,indent=2))
print('REFERENCE RECOVERY:',sum(r['status']=='saved' for r in results),'/',len(results),flush=True)
