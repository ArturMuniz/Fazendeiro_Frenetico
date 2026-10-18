"""Prepare text-only authoring metadata. Raster edits run inside Aseprite."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT.parent/'sprite-tools/actor-polish'
OUT.mkdir(parents=True,exist_ok=True)
catalog=json.loads((ROOT/'art/polished/catalog.json').read_text(encoding='utf-8'))
manifest=json.loads((ROOT/'art/polished/manifest.json').read_text(encoding='utf-8'))
src=Path(r'C:/Users/artur/Downloads/.exe/Novos Sprites ChatGpt')
records={r['output']:r for r in manifest}
netinho={s:[{'path':str(src/records[Path(p).name]['source']), 'crop':records[Path(p).name]['crop']} for p in data['frames']] for s,data in catalog['actors']['netinho'].items()}
for entity in catalog['actors'].values():
    for data in entity.values(): data['frames']=[str(ROOT/p.removeprefix('res://')) for p in data['frames']]
plan={'root':str(ROOT),'actors':catalog['actors'],'netinho':netinho,
 'giant':str(src/'Giant_grasshopper_pixel_art_20261016150233.jpg'),
 'aphid_walk':str(src/'Running_aphid_idle_animation_sheet_20261016144919.jpg'),
 'aphid_death':str(src/'Pixel_art_death_animation_sheet_20261016144314.jpg'),
 'hopper':str(src/'Grasshopper_compressing_legs_ani…_20261016144832.jpg')}
(OUT/'plan.json').write_text(json.dumps(plan,ensure_ascii=False,indent=2),encoding='utf-8')
print(OUT/'plan.json')
