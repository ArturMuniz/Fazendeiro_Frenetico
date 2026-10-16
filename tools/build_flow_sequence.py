"""Expand the visual production guide into ordered, concrete generation jobs."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs" / "direcao_visual"
SOURCE = (DOCS / "04_PROMPTS_GOOGLE_FLOW.md").read_text(encoding="utf-8")
INVENTORY = {row["id"]: row["name"] for row in json.loads((DOCS / "inventario.json").read_text(encoding="utf-8"))}
JOBS = []


def block(marker):
    start = SOURCE.index(marker)
    match = re.search(r"```text\n(.*?)\n```", SOURCE[start:], re.S)
    assert match, marker
    return match.group(1)


def rows(start, end):
    text = SOURCE[SOURCE.index(start):SOURCE.index(end, SOURCE.index(start) + len(start))]
    result = []
    for line in text.splitlines():
        if line.startswith("| ") and not line.startswith("|---"):
            result.append([x.strip() for x in line.strip("|").split("|")])
    return result[1:]


def ref(number):
    return "fonte original #" + str(number).zfill(3) + " — " + INVENTORY[number]


def add(group, title, output, prompt, references, depends=(), frames=1, canvas="128×128", fps="—", loop="não", mode="GERAR"):
    number = len(JOBS) + 1
    JOBS.append(dict(number=number, group=group, title=title, output=output, prompt=prompt,
                     references=references, depends=list(depends), frames=frames, canvas=canvas,
                     fps=fps, loop=loop, mode=mode))
    return number


characters = [
    ("fazendeiro", "F", "Fazendeiro Clássico", "art/ui_rural/char_fazendeiro.png + " + ref(1), [4, 8, 8]),
    ("vovo", "V", "Vovó Resistente", ref(112) + " + art/ui_rural/char_fazendeiro.png para perspectiva", [4, 8, 8]),
    ("netinho", "N", "Netinho Ágil", "art/ui_rural/char_netinho.png + " + ref(88), [5, 10, 8]),
]
canonical = {}
for entity, key, name, reference, speeds in characters:
    pose = add("01 — Personagens jogáveis", name + " — pose canônica", f"{entity}_reference_right.png", block(f"**CH-{key}-00"), reference)
    canonical[entity] = pose
    for k, state, count, fps, repeat in zip([1, 2, 3], ["idle", "walk", "death"], [4, 6, 6], speeds, ["sim", "sim", "não"]):
        add("01 — Personagens jogáveis", name + " — " + {"idle":"descanso", "walk":"caminhada", "death":"morte"}[state],
            f"{entity}_{state}_right_00..{count-1:02}.png", block(f"**CH-{key}-{k:02}"), f"{entity}_reference_right.png", [pose], count, fps=fps, loop=repeat)
    prompt = block("### CH-P").replace("[PERSONAGEM]", name)
    add("01 — Personagens jogáveis", name + " — retrato", f"portrait_{entity}.png", prompt,
        f"{entity}_reference_right.png", [pose], canvas="256×256", mode="GERAR" if entity == "vovo" else "REFINAMENTO OPCIONAL")

enemy_rows = rows("| ID / prioridade | Complemento a copiar", "### 6.2")
for row in enemy_rows:
    entity = re.search(r"`([^`]+)`", row[0]).group(1)
    original_id = int(re.search(r"#(\d+)", row[2]).group(1))
    boss = entity.startswith("boss_")
    size = "256×256" if boss else "96×96"
    anchor = "(128,208)" if boss else "(48,72)"
    pose = add("02 — Sete inimigos ativos", entity + " — pose canônica", f"{entity}_reference_right.png",
               block("### 6.1") + "\n\n" + row[1], ref(original_id), canvas=size)
    canonical[entity] = pose
    flying = entity in {"mosca", "boss_rainha_moscas"}
    resting = ("Voadora: asas alternam abertura em poses nítidas, corpo paira no máximo dois pixels sem sair da âncora."
               if flying else "Terrestre: respiração mínima, patas e apoio fixos.")
    idle = re.sub(r"Terrestre:.*?âncora\.", resting, block("**EN-IDLE"))
    add("02 — Sete inimigos ativos", entity + " — descanso", f"{entity}_idle_right_00..03.png", idle,
        f"{entity}_reference_right.png", [pose], 4, size, 10 if flying else 6, "sim")
    if entity in {"pulgao", "lesma", "boss_lagarta"}:
        variant = {
            "pulgao": "Patas alternadas e corrida compacta, sem salto.",
            "lesma": "Ondulação curta do corpo viscoso; casco quase estável; não desenhar patas ou rastro de gosma.",
            "boss_lagarta": "Onda de compressão dos segmentos de trás para a frente; cabeça com oscilação mínima."
        }[entity]
        add("02 — Sete inimigos ativos", entity + " — locomoção", f"{entity}_walk_right_00..05.png",
            "Anime a criatura canônica anexada avançando para a direita no lugar em seis poses. " + variant +
            " Sem deslocamento horizontal no canvas, ataque, arma ou efeito. Mesma escala e âncora em todos os quadros, loop contínuo.",
            f"{entity}_reference_right.png", [pose], 6, size, 10 if entity == "pulgao" else 6, "sim")
    elif flying:
        add("02 — Sete inimigos ativos", entity + " — voo", f"{entity}_fly_right_00..03.png", block("**EN-FLY"),
            f"{entity}_reference_right.png", [pose], 4, size, 12, "sim")
    else:
        jump_states = [
            ("jump_prepare", 2, "Comprima as pernas em duas poses de preparação do salto; corpo continua na base.", 10, "não"),
            ("jump_takeoff", 1, "Uma pose de impulso com pernas estendidas e corpo iniciando subida; sem partículas.", "pose sustentada", "não"),
            ("jump_air", 2, "Duas poses de corpo suspenso com pernas recolhidas; mantenha altura visual estável e margem para antenas.", 10, "sim durante salto"),
            ("jump_land", 2, "Duas poses de pouso: pernas absorvem impacto, depois retorna à postura canônica; sem onda ou poeira.", 10, "não"),
        ]
        for state, count, action, fps, repeat in jump_states:
            output = f"{entity}_{state}_00.png" if count == 1 else f"{entity}_{state}_00..01.png"
            add("02 — Sete inimigos ativos", entity + " — " + state, output,
                "Use a criatura canônica anexada, orientada para a direita. " + action +
                f" Mesmo canvas {size}, projeção do apoio em {anchor}; apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.",
                f"{entity}_reference_right.png", [pose], count, size, fps, repeat)
    if flying:
        add("02 — Sete inimigos ativos", entity + " — disparo", f"{entity}_shoot_right_00..03.png", block("**EN-SHOOT"),
            f"{entity}_reference_right.png", [pose], 4, size, 12)
    add("02 — Sete inimigos ativos", entity + " — morte", f"{entity}_death_right_00..03.png", block("**EN-DEATH"),
        f"{entity}_reference_right.png", [pose], 4, size, 12)

for level, identity in [
    (1,"Bezerro creme/marrom compacto, focinho rosa, manchas e chifres iguais à referência."),
    (2,"Novilha mais robusta; conservar marcas e acessórios exatos da referência, sem armadura nova."),
    (3,"Vaca Voadora da referência aprovada; conservar traços existentes, sem inventar asas ou uma habilidade de voo.")
]:
    prefix = f"bezerro_lv{level}"
    pose = add("03 — Companheiros", f"Bezerro nível {level} — pose canônica", prefix + "_reference_right.png",
               identity + " Corpo inteiro para a direita, mesmo estilo dos personagens, canvas128×128, apoio(64,104). Sem chão, sombra, arma ou efeito.",
               f"art/ui_rural/weapon_bezerro_{level}.png")
    for state, marker, count, fps, repeat in [("idle", "**BE-IDLE",4,4,"sim"),("walk","**BE-WALK",6,8,"sim"),("attack","**BE-ATTACK",4,12,"não")]:
        add("03 — Companheiros", f"Bezerro nível {level} — {state}", f"{prefix}_{state}_right_00..{count-1:02}.png",
            identity + "\n" + block(marker), prefix + "_reference_right.png", [pose], count, fps=fps, loop=repeat)

weapon_reference = {
    "foice":ref(52),"forquilha":ref(55),"batata":"art/ui_rural/weapon_batata_3.png",
    "milho":"art/ui_rural/weapon_milho_2.png","mamona":"art/ui_rural/weapon_mamona_2.png",
    "motosserra":"art/ui_rural/weapon_motosserra_2.png","cerca":ref(73)
}
weapon_steps = {}
for row in rows("| Pedido | Complemento para copiar", "**Já disponíveis"):
    output = re.search(r"`([^`]+)`",row[2]).group(1)
    entity = re.search(r"weapon_(.+)_lv\d",output).group(1)
    dep = [weapon_steps[entity]] if entity in weapon_steps else []
    n = add("04 — Quinze ícones de armas faltantes", row[0], output, block("### 8.1") + "\n\n" + row[1], weapon_reference[entity], dep)
    weapon_steps[entity] = n

for row in rows("| ID / prioridade | Complemento | Nome |", "O projétil do código"):
    add("05 — Projéteis e XP", row[0], re.search(r"`([^`]+)`",row[2]).group(1), block("### 9.3")+"\n\n"+row[1],
        ref(61) if "PR-04" in row[0] or "PR-05" in row[0] else "Ícone aprovado da arma correspondente; fontes #014/#015/#099 conforme o objeto", canvas="64×64",
        mode="PREPARAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE NÃO ATENDER" if "PR-04" in row[0] or "PR-05" in row[0] else "GERAR/CORRIGIR")
add("05 — Projéteis e XP", "Semente de XP", "pickup_xp.png", block("**XP-01"), ref(62), canvas="64×64")

for row in rows("| ID / prioridade | Complemento do prompt", "Faixas/aneis de FX"):
    output = re.search(r"`([^`]+)`",row[2]).group(1)
    count = 6 if "seis poses" in row[1] else 4
    size = "256×128" if "FX-03" in row[0] else ("256×256" if "256×256" in row[1] else "128×128")
    fps = int(re.search(r"(\d+) FPS",row[2]).group(1))
    add("06 — Efeitos de combate", row[0], output, block("### 9.2")+"\n\n"+row[1],
        "Referência da família da arma ou criatura; " + ref(60), frames=count, canvas=size, fps=fps,
        mode="OPCIONAL" if "FX-12" in row[0] else "GERAR/CORRIGIR")

panel_refs = "art/ui_rural/panel.png + art/ui_rural/button.png"
for marker, title, output, size in [
    ("**UI-01 /", "Barra de vida — moldura", "ui_health_frame.png", "288×64"),
    ("**UI-02 /", "Barra de XP — moldura", "ui_xp_frame.png", "288×32"),
    ("**UI-03A", "Joystick — base", "joystick_base.png", "192×192"),
    ("**UI-03B", "Joystick — manopla", "joystick_knob.png", "80×80"),
]:
    add("07 — Interface",title,output,block(marker),panel_refs,canvas=size)
nav_template = block("### UI-04")
for start, end in [("| Função | Forma a inserir", "Configurações/volume"),("| Atributo | Complemento para a forma", "Ícone de intervalo")]:
    for row in rows(start,end):
        add("07 — Interface",row[0],re.search(r"`([^`]+)`",row[2]).group(1),
            nav_template.replace("[FUNÇÃO]",row[0]).replace("[FORMA]",row[1]),panel_refs,canvas="64×64")
card_normal = None
for marker, title, output, size in [
    ("### UI-05 /", "Moeda canônica", "currency_gold.png", "128×128"),
    ("**Base /", "Carta normal", "upgrade_card_normal.png", "384×128"),
    ("**Selecionada /", "Carta selecionada", "upgrade_card_selected.png", "384×128"),
    ("### UI-08", "Slot de equipamento", "equipment_slot.png", "128×128"),
    ("**UI-12 /", "Manopla de configurações", "settings_knob.png", "64×64"),
    ("**UI-14 /", "Indicador de gravação", "save_seed.png", "64×64"),
    ("**UI-15 /", "Placa de custo", "cost_plate.png", "192×64"),
    ("**FB-01 /", "Emblema de vitória", "result_victory_emblem.png", "256×256"),
    ("**FB-02 /", "Emblema de derrota", "result_defeat_emblem.png", "256×256"),
    ("**FB-03 /", "Aviso de chefe", "boss_warning_icon.png", "128×128"),
]:
    deps = [card_normal] if output == "upgrade_card_selected.png" else []
    n = add("07 — Interface",title,output,block(marker),"upgrade_card_normal.png" if deps else panel_refs,deps,canvas=size,
            mode="REUTILIZAR MEDALHÃO HOSTIL; GERAR SOMENTE SE NECESSÁRIO" if "FB-03" in marker else "GERAR")
    if output == "upgrade_card_normal.png":
        card_normal = n

grounds = {}
for entity, marker, reference in [("celeiro","### AM-01",ref(115)),("pomar","### AM-02",ref(12))]:
    grounds[entity] = add("08 — Cenários", "Piso base — " + entity, f"ground_{entity}_base.png",block(marker),reference,canvas="256×256")
for entity in ["horta","celeiro","pomar"]:
    for variant in [1,2]:
        add("08 — Cenários",f"{entity} — variação {variant}",f"ground_{entity}_var{variant:02}.png",block("### AM-03"),
            ref(111) if entity == "horta" else f"ground_{entity}_base.png", [grounds[entity]] if entity in grounds else [],canvas="256×256")
for entity, source, objects in [
    ("horta",95,["cerca","canteiro","couve","espantalho"]),
    ("celeiro",93,["feno","barril","caixa","saco","roda"]),
    ("pomar",92,["arvore","cesto","folhas","escada"])
]:
    for obj in objects:
        size = "256×256" if obj == "arvore" else ("128×192" if obj in {"espantalho","escada"} else "128×128")
        add("08 — Cenários",f"{entity} — {obj}",f"prop_{entity}_{obj}.png",block("### AM-04").replace("[OBJETO]",obj),ref(source),canvas=size,
            mode="RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR")

for marker,title,output in [("**BR-02A","Ícone de aplicativo — primeiro plano","app_icon_foreground.png"),("**BR-02B","Ícone de aplicativo — fundo","app_icon_background.png")]:
    add("09 — Identidade do aplicativo",title,output,block(marker),"fazendeiro_reference_right.png + art/ui_rural/emblem.png",[canonical["fazendeiro"]],canvas="1024×1024")

CORE_COUNT = len(JOBS)

for entity in ["foice","forquilha","milho","batata","mamona","motosserra","cerca"]:
    for level in [1,2,3]:
        add("10 — Condicionais: corpos de armas",f"{entity} nível {level} — corpo de mundo",f"world_{entity}_lv{level}.png",
            block("**W-BODY").replace("[ARMA, NÍVEL]",f"{entity}, nível {level}"),
            f"Ícone correto de {entity} nível {level}; usar arquivo existente ou o gerado na etapa04",
            mode="REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE")
add("11 — Condicionais: decoração", "Poça decorativa", "fx_puddle_base.png",block("**FB-09 /"),ref(63),canvas="256×256",mode="OPCIONAL; SEM DANO OU MECÂNICA NOVA")

for entity,num in [("aranha",3),("besouro",19),("formiga",54),("grilo",70),("abelha",2),("barata",16),("rato",103)]:
    note = {
        "aranha":"Corpo escuro, olhos claros e patas legíveis; sem teia anexada.",
        "besouro":"Carapaça azul-escura e postura baixa; não misturar ataque erguido ao idle.",
        "formiga":"Corpo segmentado quente, antenas estáveis e seis patas; sem confundir com Pulgão.",
        "grilo":"Silhueta própria da referência, distinta do Gafanhoto Saltador; sem onda incorporada.",
        "abelha":"Amarelo/preto e asas claras; sem ferrão usado como ataque nesta pose.",
        "barata":"Corpo achatado e antenas; sem dash na pose neutra.",
        "rato":"Corpo marrom, cauda longa e orelhas claras; contorno legível sobre tábuas."
    }[entity]
    pose = add("12 — Reserva: criaturas futuras",entity + " — pose",f"{entity}_reference_right.png",block("## 14.")+"\n\n"+note,ref(num),canvas="96×96",mode="RESERVA; FORA DO PACOTE ATIVO")
    for state,count,fps,repeat in [("idle",4,6,"sim"),("walk",6,8,"sim"),("death",4,12,"não")]:
        if state == "idle":
            p = "Quatro poses de repouso discreto: " + ("asas alternam sem blur, corpo quase estável." if entity == "abelha" else "respiração mínima, patas fixas.")
        elif state == "walk":
            p = ("Seis poses de voo no lugar com asas alternadas, sem borrão." if entity == "abelha" else "Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente.")
        else:
            p = block("**EN-DEATH")
        add("12 — Reserva: criaturas futuras",entity + " — " + state,f"{entity}_{state}_right_00..{count-1:02}.png",
            p+" Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.",
            f"{entity}_reference_right.png",[pose],count,"96×96",fps,repeat,mode="RESERVA; FORA DO PACOTE ATIVO")

style = block("## 2. Bloco de estilo")
header = f'''# Fila sequencial de geração de sprites — Google Flow

O Fazendeiro Frenético · 16/10/2026.

Este arquivo transforma o [guia de prompts](04_PROMPTS_GOOGLE_FLOW.md) numa fila concreta: **{len(JOBS)} pedidos numerados**, com {CORE_COUNT} pedidos no pacote principal e {len(JOBS)-CORE_COUNT} condicionais/reserva. Alguns pedidos pedem recorte/reutilização ou um conjunto de quadros; não são {len(JOBS)} imagens obrigatoriamente novas.

## Como entregar este arquivo à IA

Forneça este Markdown e as referências visuais. Use o comando-mestre abaixo. Se a interface aceitar somente texto, copie o comando-mestre e execute os pedidos em ordem, em lotes que caibam no contexto. Cada bloco de pedido já tem objeto, estado e nome preenchidos; não é necessário combinar tabelas do guia anterior.

Este arquivo é uma especificação para execução sequencial, não um script que adiciona geração em lote ao Flow. A quantidade de saídas por interação, formatos e uso de referências dependem da ferramenta disponível. Quando a interface exigir uma nova ação de gerar, use o pedido seguinte. O [guia técnico](04_PROMPTS_GOOGLE_FLOW.md) mantém os detalhes de exportação e integração.

## Comando-mestre — copiar com a fila

```text
Você é o artista de produção de sprites do jogo O Fazendeiro Frenético. Execute a fila numerada deste documento na ordem, produzindo os arquivos visuais solicitados com as ferramentas de imagem disponíveis. Comece no pedido001. Não substitua a tarefa por análise, resumo ou novos prompts.

Mantenha as regras de estilo abaixo e reutilize as referências fornecidas. Crie um único asset ou uma única animação por pedido; não junte diferentes personagens, níveis ou estados numa grande colagem. Animações podem ser entregues como PNGs sequenciais ou uma folha regular exclusiva daquele estado. Não gerar vídeo por padrão: priorize imagens com poses discretas. Vídeo só como fonte alternativa, identificado como tal.

Finalize e confira o pedido atual antes de avançar. Não solicite confirmação entre os pedidos rotineiros. Caso uma pose canônica apresente mudança de identidade, partes cortadas ou estilo diferente, corrija antes de animá-la. Não afirme ter validado alpha, dimensões ou grade se não conseguir inspecionar os arquivos.

Se uma referência indispensável estiver ausente, registre PENDENTE_REFERENCIA e prossiga apenas com os pedidos independentes. Não invente o personagem nem use uma fonte de outro nível. Se a ferramenta não permitir gerar ou exportar imagens, informe essa limitação; não simule arquivos, links ou conclusão.

Pedidos PREPARAR/REUTILIZAR usam as fontes existentes: extraia ou reutilize quando suas ferramentas permitirem. Gere substituição somente se a extração falhar. Não refaça assets prontos por padrão.

Execute o pacote principal até o final. Depois registre os condicionais e a reserva. Só execute um condicional se a condição descrita acontecer. Criaturas futuras ficam fora do lote ativo e da integração até decisão de conteúdo. Não alterar gameplay para justificar a arte.

Ao atingir limite de ferramenta/contexto, salve ou informe o último pedido concluído e o próximo número. Na próxima interação, retome dali com as mesmas referências, sem refazer o lote anterior. Nunca declare que produziu toda a fila se só concluiu uma parte.

Após cada pedido, mantenha um registro textual externo à imagem: número, nomes reais dos arquivos, estado GERADO/PREPARADO/REUTILIZADO/PENDENTE, referência usada e problemas. Nunca desenhe esse registro dentro do sprite. Ao final de cada lote, apresente as imagens/arquivos reais disponíveis e o ponto de retomada. Só crie ZIP se a ferramenta puder empacotar as saídas reais.
```

## Estilo obrigatório para toda a fila

```text
{style}
```

**Exceções necessárias:** pisos são imagens opacas, contínuas e sem sombra/vinheta; fundo do ícone de aplicativo também é opaco. As demais peças são isoladas. Transparência real quando suportada; caso contrário, cor plana ausente na paleta do asset e registrada no relatório. Nunca desenhar xadrez. Evitar chave verde em roupa/folhagem verde, azul em roupa azul e magenta junto a focinho rosa. A cor do fundo é escolhida por asset, não uma cor universal.

**Animações:** direção direita, sem deslocamento horizontal no canvas, câmera fixa, mesma escala/iluminação e ponto de apoio entre quadros. PNGs preferidos; folha alternativa com uma linha de células de tamanho idêntico, ordem esquerda→direita, sem divisórias ou números. Se a grade sair irregular, marcar para preparação. Os FPS abaixo são propostas de reprodução no Godot e não um pedido de vídeo com FPS exato. Em morte, preservar o último quadro; em salto, o tempo vem da mecânica existente.

**Referências:** nomes `art/ui_rural/...` referem-se ao projeto local. Fontes originais numeradas estão no inventário da auditoria e na pasta de sprites. Um caminho escrito não anexa a imagem ao Flow: Artur deve fornecer os arquivos correspondentes. Saídas anteriores viram referências apenas quando realmente geradas e conferidas.

## Assets prontos que devem ser reaproveitados

O manifesto `art/ui_rural/manifest.json` contém os29 PNGs preparados. Reaproveitar mapa, emblema, painel, três botões, quatro medalhões, cinco passivos, três upgrades, dois recortes de personagens e nove ícones de armas. Isso não cobre automaticamente os estados animados.

Ícones prontos: Bezerro1/2/3, Batata3, Mamona2/3, Milho2, Motosserra2/3. Textos, níveis, comparações, fill de barras, contador, foco, overlay, flash de dano, telegráficos geométricos e tipografia licenciada ficam no motor. Não produzir imagens com números ou nomes fixos.

## Índice de execução

| Faixa | Grupo | Pedidos |
|---|---|---|
'''
groups = []
for j in JOBS:
    if not groups or groups[-1][0] != j['group']:
        groups.append([j['group'], j['number'], j['number']])
    else:
        groups[-1][2] = j['number']
for name,start,end in groups:
    header += f"| {start:03}–{end:03} | {name} | {end-start+1} |\n"

parts = [header]
for j in JOBS:
    dep = ", ".join(f"{n:03}" for n in j['depends']) or "Nenhum pedido anterior obrigatório; fornecer referências externas."
    out = j['output']
    if j['frames'] > 1:
        delivery = f"{j['frames']} quadros; PNGs individuais com os nomes indicados. Alternativa: folha de {j['frames']}×1 células, uma única animação."
    else:
        delivery = "Um PNG estático ou pose única."
    parts.append(f'''\n### Pedido {j['number']:03} — {j['title']}

- Grupo: {j['group']}.
- Ação: **{j['mode']}**.
- Referência a anexar: {j['references']}.
- Dependências: {dep}.
- Saída: `{out}`.
- Canvas final por quadro: {j['canvas']}. FPS proposto: {j['fps']}. Loop: {j['loop']}.

```text
Pedido {j['number']:03}. Siga o estilo obrigatório e as referências desta fila.
{j['prompt']}

Entrega: {delivery} Nome de destino: {out}. Canvas final por quadro: {j['canvas']}. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```
''')

parts.append('''
## Fechamento e retomada

```text
Último pedido concluído: número e nome.
Próximo pedido: número e nome.
Referências canônicas já estabelecidas: listar os arquivos reais.
Gerados/preparados/reutilizados: listar separadamente.
Pendências técnicas: alpha, recorte, grade, inconsistência, arquivo ausente.
Condicionais dispensados: listar a condição que não ocorreu.
Reserva: listar como futura, sem declarar integrada.
```

Para continuar: “Retome esta fila a partir do pedido informado como próximo. Reutilize as poses canônicas já fornecidas e não refaça os pedidos concluídos.”

As artes recebidas serão revisadas e conectadas a personagens, níveis e estados no Godot. Não substituir colisões pelo tamanho do PNG, nem alterar dano/cooldown para caber na animação. Morte visual não mantém inimigo ativo no pool; efeito não paga XP/ouro. O ZIP entregue antes deste documento permanece a versão já empacotada.
''')

destination = DOCS / "05_FILA_SEQUENCIAL_GOOGLE_FLOW.md"
text = "\n".join(parts)
assert text.count("```") % 2 == 0
assert len(set(j['output'] for j in JOBS)) == len(JOBS), "Duplicated outputs"
assert not re.search(r"\[(?:PERSONAGEM|FUNÇÃO|FORMA|OBJETO|ARMA, NÍVEL)\]", text)
assert all(all(d < j['number'] for d in j['depends']) for j in JOBS)
destination.write_text(text, encoding="utf-8")
print(json.dumps({"path":str(destination),"requests":len(JOBS),"main_requests":CORE_COUNT,"groups":groups,"lines":len(text.splitlines()),"characters":len(text)},ensure_ascii=False))
