"""Reproducible crop/chroma preparation. Originals are never changed.

Usage: python tools/prepare_polished_art.py SOURCE_DIR OLD_SOURCE_DIR
Requires Pillow and numpy. Manual selection and per-cell bounds are intentional.
"""
from pathlib import Path
import hashlib
import json
import sys
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageOps, ImageEnhance

ROOT = Path(__file__).resolve().parents[1]
SRC = Path(sys.argv[1])
OLD = Path(sys.argv[2])
OUT = ROOT / 'art' / 'polished'
OUT.mkdir(parents=True, exist_ok=True)
FILES = sorted(p for p in SRC.iterdir() if p.suffix.lower() in {'.jpg', '.png', '.jpeg'})
INVENTORY = {i + 1: p for i, p in enumerate(FILES)}
CATALOG = {'actors': {}, 'ui': {}, 'weapons': {}, 'effects': {}, 'props': {}}
RECORDS = []
USED = {}


def source(s):
    return INVENTORY[s] if isinstance(s, int) else OLD / s


def cut(s, box=None, checker=False):
    path = source(s)
    im = Image.open(path).convert('RGBA')
    if box:
        w, h = im.size
        im = im.crop(tuple(round(v * (w if k % 2 == 0 else h)) for k, v in enumerate(box)))
    a = np.array(im)
    r, g, b = [a[:, :, k].astype(np.int16) for k in range(3)]
    if checker:
        neutral = ((np.maximum.reduce([r,g,b])-np.minimum.reduce([r,g,b])) < 22) & (r > 48)
        # Flood only edge-connected neutral checker; preserve enclosed eyes/metal.
        mask = Image.fromarray(np.where(neutral, 255, 0).astype('uint8')).copy()
        for x in range(mask.width):
            for y in [0, mask.height-1]:
                if mask.getpixel((x,y)) == 255:
                    ImageDraw.floodfill(mask,(x,y),128)
        for y in range(mask.height):
            for x in [0, mask.width-1]:
                if mask.getpixel((x,y)) == 255:
                    ImageDraw.floodfill(mask,(x,y),128)
        transparent = np.array(mask) == 128
    else:
        transparent = (r > g*1.45+15) & (b > g*1.45+15) & (np.minimum(r,b) > 50)
        if s == 45:
            white = Image.fromarray(np.where((r>230)&(g>230)&(b>230),255,0).astype('uint8')).copy()
            ImageDraw.floodfill(white,(0,0),128)
            transparent |= np.array(white)==128
    a[transparent, 3] = 0
    a[transparent, :3] = 0
    im = Image.fromarray(a)
    bounds = im.getbbox()
    assert bounds, path
    im = im.crop(bounds)
    USED.setdefault(path.name, []).append('recorte e alpha: ' + str(box))
    return im, path, box


def export(name, s, box=None, height=None, longest=None, canvas=None, anchor=None, mirror=False, checker=False):
    im, path, crop = cut(s, box, checker)
    raw_size = im.size
    factor = min(height/im.height, (canvas[0]-12)/im.width) if height else longest/max(im.size)
    size = (max(1,round(im.width*factor)),max(1,round(im.height*factor)))
    im = im.resize(size,Image.Resampling.NEAREST)
    if checker:
        # Remove disconnected checker/JPEG crumbs at the final pixel grid.
        alpha=np.array(im.getchannel('A'))>0
        visited=np.zeros(alpha.shape,dtype=bool)
        components=[]
        for py,px in zip(*np.where(alpha)):
            if visited[py,px]:
                continue
            stack=[(int(py),int(px))];visited[py,px]=True;component=[]
            while stack:
                cy,cx=stack.pop();component.append((cy,cx))
                for ny,nx in [(cy-1,cx),(cy+1,cx),(cy,cx-1),(cy,cx+1)]:
                    if 0<=ny<alpha.shape[0] and 0<=nx<alpha.shape[1] and alpha[ny,nx] and not visited[ny,nx]:
                        visited[ny,nx]=True;stack.append((ny,nx))
            components.append(component)
        keep=max(components,key=len)
        a=np.array(im);a[:,:,3]=0
        for py,px in keep:
            a[py,px,3]=255
        im=Image.fromarray(a)
    if mirror:
        im = ImageOps.mirror(im)
    if canvas:
        result = Image.new('RGBA',canvas)
        x = round(anchor[0]-im.width/2)
        y = round(anchor[1]-im.height)
        assert x >= 2 and y >= 2 and x+im.width <= canvas[0]-2 and y+im.height <= canvas[1]-2, (name,size)
        result.alpha_composite(im,(x,y))
        im = result
    im.save(OUT/(name+'.png'))
    record = dict(output=name+'.png', source=path.name, sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                  crop=crop, raw_bounds_size=raw_size, size=im.size, mirror=mirror, checker_removed=checker)
    RECORDS.append(record)
    return 'res://art/polished/'+name+'.png'


def frames(entity,state, specs, height, fps=8, loop=True, mirror=False, canvas=(128,128), anchor=(64,96), longest=None):
    paths = []
    for i, spec in enumerate(specs):
        s, box = spec[:2]
        target = spec[2] if len(spec)>2 else height
        flip = spec[3] if len(spec)>3 else mirror
        paths.append(export(f'{entity}_{state}_{i:02}',s,box,height=target if not longest else None,
                            longest=longest,canvas=canvas,anchor=anchor,mirror=flip,
                            checker=isinstance(s,str)))
    CATALOG['actors'].setdefault(entity,{})[state] = dict(frames=paths, fps=fps, loop=loop,
        offset=[0,-16] if not entity.startswith('boss_') else [0,-24])


QUADS = [(0,0,.5,.5),(.5,0,1,.5),(0,.5,.5,1),(.5,.5,1,1)]

# Same garment/identity throughout each selected family. Five-pose sheets with
# oversized central figures are deliberately not treated as a regular grid.
frames('fazendeiro','idle',[(120,QUADS[0]),(109,QUADS[0]),(108,QUADS[0]),(120,QUADS[0])],64,4,mirror=True)
frames('fazendeiro','walk',[(53,q,64,i==0) for i,q in enumerate(QUADS)],64,8)
frames('fazendeiro','death',[(110,QUADS[0]),(100,QUADS[0],54),(49,None,64),(48,None,28),(47,None,26)],64,9,False,mirror=True)
frames('vovo','idle',[(39,None),(113,None),(77,None),(39,None)],64,4)
frames('vovo','walk',[(114,None),(132,None),(153,None),(154,None)],64,7)
frames('vovo','death',[(150,None),(151,None),(76,None,54),(149,None,28)],64,8,False)
frames('netinho','idle',[(102,None),(103,None)],58,3)
frames('netinho','walk',[(1,None),(25,None),(57,None),(26,None)],58,9)
frames('netinho','death',[(23,None),(94,(0,.04,1,1),43),(22,None,30),(22,None,30)],58,8,False)

def row_cells(n, y0=.05, y1=.88):
    return [(i/n+.014,y0,(i+1)/n-.014,y1) for i in range(n)]

frames('pulgao','idle',[(157,row_cells(4,.03,.75)[i]) for i in [0,2]],27,6,canvas=(96,96),anchor=(48,64))
frames('pulgao','walk',[(157,row_cells(4,.03,.75)[i]) for i in [0,2]],27,10,canvas=(96,96),anchor=(48,64))
frames('mosca','idle',[(129,None),(177,None),(176,None),(60,None,21)],30,10,canvas=(96,96),anchor=(48,64))
frames('mosca','walk',[(129,None),(177,None),(176,None),(60,None,21)],30,12,canvas=(96,96),anchor=(48,64))
frames('mosca','attack',[(165,None),(69,None),(129,None)],30,12,False,canvas=(96,96),anchor=(48,64))
frames('mosca','death',[(164,b,h) for b,h in zip(row_cells(4),[34,26,28,20])],30,12,False,canvas=(96,96),anchor=(48,64))
frames('gafanhoto','idle',[(78,b) for b in row_cells(2,.05,.92)],33,4,canvas=(96,96),anchor=(48,64))
frames('gafanhoto','jump',[(86,b) for b in row_cells(2,.05,.92)],33,10,canvas=(96,96),anchor=(48,64))
frames('gafanhoto','land',[(82,(.66,.05,.99,.92))],27,10,False,canvas=(96,96),anchor=(48,64))
frames('gafanhoto','death',[(79,b,h) for b,h in zip(row_cells(4),[33,33,22,18])],33,12,False,canvas=(96,96),anchor=(48,64))
# Original identity recovered properly: these two species have no replacements
# in the new delivery. Their former runtime PNGs had opaque checkerboards.
frames('lesma','idle',[('telsmatank-andando.jpg',(0,0,.5,1)),('telsmatank-andando.jpg',(.5,0,1,1))],33,5,canvas=(96,96),anchor=(48,64))
CATALOG['actors']['lesma']['walk'] = CATALOG['actors']['lesma']['idle']
frames('boss_lagarta','idle',[('boss-largatagi.jpg',(i/4+.008,.12,(i+1)/4-.008,.59),h) for i,h in enumerate([106,72,72,106])],106,5,canvas=(256,256),anchor=(128,176))
CATALOG['actors']['boss_lagarta']['walk'] = CATALOG['actors']['boss_lagarta']['idle']
frames('boss_rainha_moscas','idle',[(144,b,h) for b,h in zip(row_cells(3),[85,72,74])],82,8,canvas=(256,256),anchor=(128,176))
frames('boss_rainha_moscas','walk',[(143,b) for b in row_cells(3)],82,12,canvas=(256,256),anchor=(128,176))
frames('boss_rainha_moscas','attack',[(142,b) for b in row_cells(4)],82,12,False,canvas=(256,256),anchor=(128,176))
frames('boss_rainha_moscas','death',[(141,b,h) for b,h in zip(row_cells(4),[82,98,65,36])],82,10,False,canvas=(256,256),anchor=(128,176))
frames('boss_gafanhoto_gigante','idle',[(73,(i/4+.035,.055,(i+1)/4-.018,.45)) for i in range(4)],108,6,canvas=(256,256),anchor=(128,176))
frames('boss_gafanhoto_gigante','jump',[(80,b) for b in row_cells(2,.03,.92)],108,10,canvas=(256,256),anchor=(128,176))
frames('boss_gafanhoto_gigante','land',[(71,(0,.03,.5,.47))],102,12,False,canvas=(256,256),anchor=(128,176))
# #072 has connected floor/overlapping bodies: use the detached death FX instead.

# First companion sheet is wrongly bipedal: use the quadruped walking family.
for level, idle, walk, attack in [(1,68,68,16),(2,37,40,33),(3,61,37,38)]:
    ent = f'bezerro_{level}'
    boxes = [(i/4+.005,j/2+.012,(i+1)/4-.005,(j+1)/2-.025) for j in range(2) for i in range(4)]
    idle_boxes = row_cells(4,.06,.90) if level==3 else boxes[:4]
    walk_boxes = [(i/3+.002,j/2+.01,(i+1)/3-.002,(j+1)/2-.01) for j in range(2) for i in range(3)] if level==2 else boxes
    if level==3:
        walk=61
        walk_boxes=idle_boxes
    frames(ent,'idle',[(idle,b) for b in idle_boxes],36,5,longest=52)
    frames(ent,'walk',[(walk,b) for b in walk_boxes],36,10,longest=52)
    # Use only first-row headbutt; trim printed labels/borders on some sheets.
    attack_boxes=boxes[:4] if level!=2 else [(i/4+.005,.015,(i+1)/4-.005,.49) for i in [0,1,2,0]]
    frames(ent,'attack',[(attack,b) for b in attack_boxes],36,12,False,longest=52)

# UI uses a semantic lookup, avoiding writes over previously approved sources.
for key,s in {'app_icon':45,'portrait_fazendeiro':51,'portrait_vovo':34,'portrait_netinho':126,
              'char_fazendeiro':121,'char_vovo':39,'char_netinho':103,
              'joystick_base':161,'joystick_knob':27,'currency_gold':105,
              'icon_pause':124,'icon_confirm':64,'icon_resume':66,'icon_close':70,
              'icon_back':117,'icon_restart':67,'icon_inventory':158,'icon_settings':112,
              'stat_health':148,'stat_damage':174,'stat_defense':184,'stat_collection':84,
              'stat_speed':127,'stat_interval':104,'victory_emblem':131,'defeat_emblem':44,
              'boss_emblem':137,'save_seed':128,'slot':107,'cost_plate':123,
              'health_frame':116,'xp_frame':134}.items():
    CATALOG['ui'][key] = export(key,s,longest=256 if key.startswith('portrait') else 192)
for key,s in {'forquilha_1':2,'forquilha_2':87,'milho_1':119,'milho_2':111,'milho_3':115,
              'batata_1':138,'mamona_1':166,'mamona_2':135,'mamona_3':130,
              'motosserra_1':20,'motosserra_2':21,'motosserra_3':75}.items():
    CATALOG['weapons'][key] = export('weapon_'+key,s,longest=80)
CATALOG['weapons']['foice_1'] = export('weapon_foice_1','foice-arma.jpg',longest=64,checker=True)
CATALOG['ui']['trap_base'] = export('trap_base','icone-cercaeletrica.jpg',longest=44)
for key,s in {'projectile_milho':32,'projectile_batata':140,'projectile_mamona':18,
              'projectile_enemy':91,'pickup_xp':162}.items():
    CATALOG['ui'][key] = export(key,s,longest=18 if key!='projectile_batata' else 24)

for name,s,boxes in [
    ('impact',35,[(i/4+.012,.01,(i+1)/4-.012,.48) for i in range(4)]),
    ('electric',43,row_cells(4)),('sawdust',19,row_cells(4)),
    # Irregular widths: full burst and two dissipations, not four equal cells.
    # The intact first husk is omitted so death cannot look like a pickup.
    ('death',136,[(.23,.02,.53,.93),(.535,.02,.78,.93),(.79,.02,1,.93)])
]:
    paths=[]
    for i,b in enumerate(boxes):
        paths.append(export(f'fx_{name}_{i}',s,b,longest=48 if name!='death' else 42,canvas=(96,96),anchor=(48,72)))
    CATALOG['effects'][name] = dict(frames=paths,fps=16,loop=False,offset=[0,0])

for key,s in {'horta_cerca':181,'horta_canteiro':17,'horta_espantalho':163,'celeiro_feno':83,
              'celeiro_barril':178,'celeiro_caixa':180,'celeiro_roda':175,
              'pomar_arvore':6,'pomar_cesto':62,'pomar_folhas':125,'pomar_escada':182}.items():
    CATALOG['props'][key] = export('prop_'+key,s,longest=136 if 'arvore' in key else 48)

# Quiet barn base, with periodic boundary correction. New orchard images have
# baked props/blobs, so retain the neutral old dirt instead of importing them.
ground=Image.open(source(159)).convert('RGB').resize((128,128),Image.Resampling.NEAREST)
a=np.array(ground,dtype=np.float32)
# Mirror blend of a 6px edge strip makes opposite borders match exactly.
for k in range(6):
    mix=(a[:,k].copy()+a[:,-1-k].copy())/2
    a[:,k]=mix; a[:,-1-k]=mix
for k in range(6):
    mix=(a[k].copy()+a[-1-k].copy())/2
    a[k]=mix; a[-1-k]=mix
Image.fromarray(np.uint8(a)).save(OUT/'ground_celeiro.png')
USED.setdefault(source(159).name,[]).append('piso com correção periódica de bordas')
horta=Image.open(OLD/'Vegetable_garden_grass_texture_20261015081024.jpg').convert('RGB').resize((128,128),Image.Resampling.NEAREST)
horta=ImageEnhance.Color(horta).enhance(.65)
horta=ImageEnhance.Contrast(horta).enhance(.60)
horta=ImageEnhance.Brightness(horta).enhance(.83)
horta.save(OUT/'ground_horta.png')

output_text='extends RefCounted\n\n# Generated by tools/prepare_polished_art.py; do not hand-edit.\nconst DATA: Dictionary = '+json.dumps(CATALOG,ensure_ascii=False,indent=2).replace('true','true').replace('false','false')+'\n'
(ROOT/'polished_art_data.gd').write_text(output_text,encoding='utf-8')
(OUT/'catalog.json').write_text(json.dumps(CATALOG,ensure_ascii=False,indent=2),encoding='utf-8')
(OUT/'manifest.json').write_text(json.dumps(RECORDS,ensure_ascii=False,indent=2),encoding='utf-8')
expected={row['output'] for row in RECORDS}|{'ground_celeiro.png','ground_horta.png'}
# Only obsolete generated PNGs inside this dedicated output folder are removed.
assert OUT.resolve().parent == (ROOT/'art').resolve()
for previous in OUT.glob('*.png'):
    if previous.name not in expected:
        previous.unlink()
        previous.with_suffix('.png.import').unlink(missing_ok=True)

# Per-file review: every source was seen in a contact sheet. Selected files are
# used only for the reviewed crops; a rejected cell is not globally approved.
special = {15:'Folha com vários props: duplicação de kits já disponíveis; não usar como sprite único.',
72:'Linha de chão contínua e corpos sobrepostos; não fatiar como grade. Usado efeito de morte independente.',
24:'Texto incorporado no topo; preferida sequência sem rótulos.',33:'Rótulos e variação entre linhas: somente primeira linha com margem recortada.',
36:'Bezerro bípede: anatomia incompatível com caminhada quadrúpede.',
54:'Cinco poses com personagem central maior; não é grade uniforme.',55:'Cinco poses com personagem central maior; preferida folha regular.',
58:'Texto FEED desenhado no saco; evitar esse recorte na produção.',
90:'Vinheta forte; não usada como fundo repetível.',93:'Pomar contém props fixos desenhados no chão; repetição visual inadequada.',
95:'Chamas sugerem arma elemental inexistente; não substituir silenciosamente Forquilha3.',
118:'Texto ORDER118 gravado na carta; manter painel aprovado sem texto.',
122:'Manchas e folhas repetidas dominantes; manter piso neutro até nova textura.',
139:'Símbolo nuclear e nível sem confirmação; manter tier3 aprovado e não atribuir tier2 por aparência.',
160:'Poça com chão e grama incorporados; não é efeito transparente pronto.'}
reserve=set([3,4,5,7,8,9,10,11,12,13,28,29,30,41,59,89,92,98,99,146,147,170,171,172,173])
audit=['# Auditoria das novas artes — 16/10/2026','',
       '184 fontes inspecionadas em oito pranchas. A aprovação abaixo se aplica aos recortes descritos no manifesto, não à folha inteira. Originais preservados. Não há novos inimigos/mecânicas neste pacote.','',
       '| ID | Arquivo | Decisão | Motivo |','|---|---|---|---|']
for i,p in INVENTORY.items():
    if p.name in USED:
        decision='Integrado/preparado'
        reason=special.get(i,'Recorte selecionado, chave magenta removida, exportação RGBA e escala revisada.')
    elif i in special:
        decision='Não integrado'
        reason=special[i]
    elif i in reserve:
        decision='Reserva de conteúdo'
        reason='Espécie/estado fora do EnemyDB ativo; não adicionar mecânica somente por existir arte.'
    else:
        decision='Alternativa preservada'
        reason='Pose/variante redundante ou menos coerente; selecionada a melhor sequência da mesma família.'
    audit.append(f'| {i:03} | `{p.name}` | {decision} | {reason} |')
(ROOT/'docs'/'direcao_visual'/'06_AUDITORIA_NOVOS_SPRITES.md').write_text('\n'.join(audit)+'\n',encoding='utf-8')
print(f'{len(RECORDS)} recortes preparados; {len(USED)} fontes utilizadas; {len(INVENTORY)} fontes auditadas.')
