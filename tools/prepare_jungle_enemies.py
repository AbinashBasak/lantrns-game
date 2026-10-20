"""Copy reviewed generated exports; preserve production sources and record hashes."""
import hashlib,json,pathlib,shutil
ROOT=pathlib.Path(__file__).resolve().parents[1]
BASE=ROOT/'assets/production/phase_03_enemies_and_chapter_1_boss/enemies'
OUT=ROOT/'assets/runtime/chapter01/enemies'
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
for variant,clips in {'sporeling': [('idle','EN-012','idle'),('move','EN-012','movement'),('attack','EN-013','spore_attack'),('hurt','EN-014','hurt'),('defeat','EN-014','defeat')], 'brambleguard':[('idle','EN-016','idle'),('move','EN-016','walk'),('attack','EN-017','heavy_attack'),('hurt','EN-018','hurt'),('defeat','EN-018','defeat')]}.items():
 manifest={'variant':variant,'provenance':'Unmodified generated production exports copied for runtime; not final art approval.','animations':{}}
 target=OUT/variant; target.mkdir(parents=True,exist_ok=True)
 for key,aid,clip in clips:
  source_manifest=BASE/aid/'exports'/f'{aid}_{clip}_manifest.json'; raw=json.loads(source_manifest.read_text())
  frames=[]
  for src in raw['frames']:
   src=pathlib.Path(src); dst=target/src.name; shutil.copyfile(src,dst)
   frames.append({'path':'res://'+str(dst.relative_to(ROOT)),'runtime':str(dst.relative_to(ROOT)),'source':str(src.relative_to(ROOT)),'sha256':digest(dst),'source_sha256':digest(src)})
  manifest['animations'][key]={'asset_id':aid,'loop':key in ('idle','move'),'durations_ms':raw['frame_durations_ms'],'pivot_px':raw['pivot_px'],'frames':frames}
 (target/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
 print(variant,sum(len(c['frames']) for c in manifest['animations'].values()),'frames')
