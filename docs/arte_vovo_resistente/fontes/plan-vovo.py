"""Read-only image measurements and crop metadata; no raster edits."""
from pathlib import Path
from PIL import Image
import json
import numpy as np

docs=Path(__file__).resolve().parents[2]/'fazendeiro-caotico/docs/arte_vovo_resistente'
layouts={
 'idle':([0,512,1024],[0,780,1536]),
 'walk':([0,570,975,1536],[0,512,1024]),
 'run':([0,420,835,1250,1678],[0,470,937]),
 'idle_plant':([0,445,858,1260,1678],[0,486,937]),
}
plan={}
for state in ['idle','walk','run','idle_plant','death']:
 path=(docs/'gerados'/f'{state}_sheet.png').resolve()
 if state=='death':
  boxes=[[0,0,560,600],[560,0,500,600],[1060,0,619,520],[0,600,570,337],[570,600,577,337],[1147,520,532,417]]
 elif state=='run':
  xs=[0,420,835,1250,1678]; splits=[476,475,476,456]
  boxes=[[xs[c],0,xs[c+1]-xs[c],splits[c]] for c in range(4)]+[[xs[c],splits[c],xs[c+1]-xs[c],937-splits[c]] for c in range(4)]
 else:
  xs,ys=layouts[state]; boxes=[[x,y,xs[c+1]-x,ys[r+1]-y] for r,y in enumerate(ys[:-1]) for c,x in enumerate(xs[:-1])]
 with Image.open(path) as im:
  a=np.array(im)[:,:,3]>=224
  for i,(x,y,w,h) in enumerate(boxes):
   mask=a[y:y+h,x:x+w]
   print(state,i,'opaque',int(mask.sum()),'boundary',int(mask[0].sum()+mask[-1].sum()+mask[:,0].sum()+mask[:,-1].sum()))
 plan[state]={'path':str(path),'boxes':boxes}
(docs/'gerados/crop_plan.json').write_text(json.dumps(plan,indent=2),encoding='utf-8')
