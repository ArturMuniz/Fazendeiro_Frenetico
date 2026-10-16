"""Prepara somente fontes aprovadas, sem redesenho; originais permanecem intactos.
Uso: python tools/prepare_ui_assets.py CAMINHO_DOS_SPRITES
Requer Pillow e NumPy. Manifesto registra origem, recorte e SHA-256.
"""
import hashlib
import json
import sys
from pathlib import Path
import numpy as np
from PIL import Image

SOURCE = Path(sys.argv[1])
OUTPUT = Path(__file__).resolve().parents[1] / 'art' / 'ui_rural'
OUTPUT.mkdir(parents=True, exist_ok=True)
manifest = []


def export(name, source, box=None, limit=256, key=True):
    path = SOURCE / source
    im = Image.open(path).convert('RGBA')
    if box:
        im = im.crop(box)
    if key:
        a = np.asarray(im).copy()
        r, g, b = [a[:, :, c].astype(float) for c in range(3)]
        mask = (r > 100) & (b > 100) & (g < r * .65) & (g < b * .65)
        a[mask, 3] = 0
        im = Image.fromarray(a)
    if key or box:
        bounds = im.getchannel('A').getbbox()
        assert bounds, name
        im = im.crop(bounds)
    im.thumbnail((limit, limit), Image.Resampling.NEAREST)
    im.save(OUTPUT / (name + '.png'))
    manifest.append(dict(output=name+'.png', source=source, crop=box, size=im.size,
                         source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))


export('campaign', 'Pixel_art_campaign_map_20261015080945.jpg', limit=1376, key=False)
export('panel', 'Wooden_panel_frame_asset_20261015081140.jpg')
export('emblem', 'Wooden_farm_game_logo_emblem_20261015081042.jpg')
# Faixas da folha; cada corte é recortado novamente pelo alpha resultante.
for i, (top, bottom) in enumerate([(0, 342), (342, 676), (676, 1024)]):
    export(['button', 'button_pressed', 'button_disabled'][i],
           'Wooden_buttons_pixel_art_sheet_20261015081053.jpg', (0, top, 1024, bottom), 512)
for i, name in enumerate(['locked', 'available', 'cleared', 'boss']):
    export('map_'+name, 'Four_wooden_medallion_game_buttons_20261015080958.jpg',
           (i*344, 0, (i+1)*344, 768), 128)
for name, box in zip(['espantalho', 'sementes', 'termica', 'galochas', 'ima'],
                     [(0, 0, 341, 500), (341, 0, 700, 500), (700, 0, 1024, 500),
                      (0, 500, 512, 1024), (512, 500, 1024, 1024)]):
    export('passive_'+name, 'icons_passives.png', box, 96)
for i, name in enumerate(['vida_extra', 'dano_extra', 'velocidade_extra']):
    edges = [0, 380, 680, 1024]
    export('farm_'+name, 'Pixel_art_item_icons_20261015081106.jpg', (edges[i], 0, edges[i+1], 1024), 96)
export('char_fazendeiro', '1.1 Idle — 2 a 4 frames.png', (0, 0, 128, 128), 128, False)
export('char_netinho', 'netinhoagil-andando.jpg', (0, 0, 344, 768), 128)
for name, file in {
    'bezerro_2': 'bezerro-lv2.jpg', 'bezerro_3': 'bezerro-lv3.jpg',
    'batata_3': 'canhaobatata-arma-lv3.jpg', 'mamona_2': 'estilinguemamona-arma-lv2.jpg',
    'mamona_3': 'estilinguemamona-arma-lv3.jpg', 'milho_2': 'metralhadora-arma-lv2.jpg',
    'motosserra_2': 'serraele-armalv2.jpg', 'motosserra_3': 'serraele-armalv3.jpg'
}.items():
    export('weapon_'+name, file, limit=96)
export('weapon_bezerro_1', 'icone-bezerro.jpg', (0, 0, 341, 1024), 96)
(OUTPUT / 'manifest.json').write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding='utf-8')
print(f'{len(manifest)} recursos preparados em {OUTPUT}')
