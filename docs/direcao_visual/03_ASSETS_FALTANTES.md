# Etapa 3 — Assets faltantes e correções para produção

Projeto: O Fazendeiro Frenético. Data: 15/10/2026.

Objetivo: completar a interface com uma linguagem rural consistente e leitura de celular. A classificação “Alta” identifica bloqueios de clareza ou de uso básico; “Média” melhora identidade e feedback; “Baixa” adiciona acabamento opcional. Nenhuma prioridade autoriza mudar números de balanceamento ou adicionar mecânicas.

## Guia para toda encomenda

- Referências internas principais: painel #120, botões #118, emblema #119, medalhões #059 e passivos #074 da [auditoria](01_ANALISE_SPRITES.md). A numeração evita depender de nomes longos.
- Madeira castanha com contorno escuro, ferragens discretas e pergaminho creme; perspectiva frontal para UI, perspectiva consistente com o Fazendeiro para personagens.
- Produzir arte sem palavras, números, marca-d'água ou falsos fundos de transparência. Textos PT-BR, níveis e valores serão renderizados no motor.
- Entregar PNG RGBA com transparência verdadeira, fonte editável quando possível e exportações em escala consistente. Não entregar JPG para sprites recortados.
- Margem livre de pelo menos 4 pixels de desenho na escala-fonte definida; pivôs, retângulos de cada quadro e estados documentados. Atlas precisa de padding/extrusão para evitar vazamento de pixels vizinhos.
- Tamanhos abaixo são alvos iniciais de exibição no projeto 720×1280. Definir a grade de pixels da arte antes de desenhar; não tratar resolução da fonte como tamanho de toque.
- Validar sobre fundo claro, escuro e os três terrenos, além de leitura no celular. Sem halo magenta, xadrez, números gravados ou partes cortadas.
- Referências externas de gênero são de organização e clareza, não cópia de sprites: [Brotato](https://store.steampowered.com/app/1942280/Brotato/) e [Vampire Survivors](https://poncle.games/vampire-survivors).

## A. Interface essencial

| ID / elemento | Produção necessária e alvo | Referência de estilo/inspiração | Prioridade | Critério de aceite |
|---|---|---|---|---|
| UI-01 — Barra de vida modular | Corrigir #017 ou criar trilho, fill e moldura separados; exibição ~264×56 | Madeira de #120; fill vermelho simples | Alta | 0%, 1%, 50% e 100% sem deformação; valor textual legível |
| UI-02 — Barra de XP modular | Corrigir #018; trilho/fill separados, sem valor fixo desenhado; altura ~20–28 | Mesma moldura, fill ciano e rótulo de nível | Alta | Diferente de vida por rótulo/posição; preenchimento contínuo |
| UI-03 — Joystick | Corrigir #077: base circular e manopla independentes, estados neutro/ativo; base ~144 e manopla ~56 | Madeira simplificada dos botões #118 | Alta | Pivôs centrais iguais; interior transparente; sem linhas divisórias |
| UI-04 — Símbolos de navegação | Corrigir #097 e completar pausa, continuar, voltar, fechar, confirmar, reiniciar, configurações, inventário | Família de madeira #097, com peso visual uniforme | Alta | Ícones de 40–48 legíveis; nenhum cortado; rótulo acessível acompanha |
| UI-05 — Ouro canônico | Recuperar uma moeda de #082 ou criar uma única versão; 32/48/64 | Milho ou celeiro gravado, paleta ouro quente | Alta | Um símbolo para a economia existente; sem “moeda premium” implícita |
| UI-06 — Carta de melhoria modular | Corrigir #034 ou derivar a moldura de #120 para faixa horizontal ~672×184 | Pergaminho limpo, sem objetos invadindo conteúdo | Alta | Nove cortes testados; área para nome, nível e três atributos |
| UI-07 — Estados da carta | Normal, selecionada e indisponível; destaque pode ser feito no motor | Moldura de UI-06 com canto/marca de seleção | Alta | Seleção distinguível sem cor e sem parecer raridade |
| UI-08 — Slots de equipamento | Quadro vazio, ocupado, selecionado; badge de nível 1–3 renderizado no motor | Pequenas caixas de madeira/pergaminho de #120 | Alta | Ícone não encosta na borda; vazio não parece conteúdo bloqueado |
| UI-09 — Fonte de interface | Selecionar/licenciar fonte de corpo e título compatíveis, não desenhar alfabeto em JPG | Título rústico moderado; corpo simples e aberto | Alta | Acentos, ç, números, vírgula decimal, ×, %, →; leitura em tela pequena |
| UI-10 — Indicadores de comparação | Setas, ganho/perda e sinal de nível máximo; preferir vetor/forma no motor | Contorno simples em harmonia com #118 | Alta | Sinal +/− e texto além de cor; intervalo menor tratado como melhora |
| UI-11 — Ícones de atributos | Vida, dano, intervalo, velocidade, defesa, coleta; ~32–48 | Ferramentas e materiais rurais com formas distintas | Média | Cada símbolo identifica um atributo, sem reutilização ambígua |
| UI-12 — Controles de configurações | Slider, trilho, manopla, toggle e estados; podem ser estilos do motor | Madeira discreta com marcas claras | Média | Volume legível; desligado inequívoco; alvos de toque amplos |
| UI-13 — Scroll e indicador de abas | Thumb/trilho e aba ativa/inativa, de preferência estilos reutilizáveis | #118/#120 com decoração reduzida | Média | Indicar conteúdo abaixo e aba ativa sem depender da cor |
| UI-14 — Estado de gravação | Pequeno indicador “Salvando”, sucesso e erro; animação opcional | Semente/giro simples; texto é obrigatório | Alta | Não sugerir sucesso antes de persistir; erro tem ação de retry |
| UI-15 — Custo e bloqueio | Placa de custo, saldo insuficiente e nível máximo | Pergaminho #120 e cadeado #059 | Média | Não confundir bloqueio de conteúdo com botão sem saldo |

## B. Inventário, armas e personagens

| ID / elemento | Produção necessária e alvo | Referência de estilo/inspiração | Prioridade | Critério de aceite |
|---|---|---|---|---|
| IT-01 — Foice níveis 1–3 | Limpar #052; criar ícones isolados para substituir #050/#051; 3 ícones ~64 | Silhueta curva da foice base, materiais crescentes | Alta | Nenhum personagem; tiers distinguíveis, mesma orientação |
| IT-02 — Forquilha níveis 1–3 | Limpar #055; criar nível 2; recuperar uma arma isolada de #057 | Ferramenta agrícola de três dentes | Alta | Dentes legíveis; sem personagem; nível não indicado só pela cor |
| IT-03 — Canhão níveis 1–2 | Limpar #032 e resolver nível de #030; criar o tier realmente ausente | Estrutura madeira/metal, evolução até #031 | Alta | Correspondência explícita com WeaponDB; não atribuir nível por suposição |
| IT-04 — Milho níveis 1 e 3 | Limpar #081; retirar tiro/partículas de #080 | Manter sabugo e folhas do nível 2 #079 | Alta | Ícone neutro, margens iguais e arma reconhecível em 48/64 |
| IT-05 — Estilingue nível 1 | Corrigir #047 e alinhar com #045/#046 | Madeira em Y e mamona | Alta | Alpha limpo, escala e iluminação coerentes |
| IT-06 — Motosserra nível 1 | Corrigir #105 e alinhar com #106/#107 | Laranja/ferrugem de ferramenta rural | Alta | Mesma direção, peso visual e margem dos níveis superiores |
| IT-07 — Cerca elétrica níveis 1–3 | Corrigir #073/#039/#040 e separar energia | Postes de madeira, fios legíveis, zap ciano | Alta | Nenhuma perda de fios por chroma key; um/dois/três postes distinguíveis |
| IT-08 — Passivos e upgrades: exportação | Preparar cinco ícones #074 e três #096; não requer oito desenhos novos | Fontes aprovadas existentes | Alta | Manifesto relaciona arquivo ao ID do item; sem sexta célula vazia importada |
| IT-09 — Bezerro: ícones finais | Extrair uma pose #072 e preparar #024/#025; não redesenhar sem motivo | Família nova de bezerros aprovada | Média | Mesmo enquadramento; níveis claros; focinho rosa preservado |
| CH-01 — Retratos dos três personagens | Fazendeiro/Netinho podem derivar de fontes aprovadas; Vovó precisa de retrato coerente | Pixel art do #001/#088, não conceitos ilustrados | Alta | Identidade única por personagem e tamanho ~96–128 |
| CH-02 — Fazendeiro andando/morte | Recuperar #048/#084 com alpha, pivôs e escala do #001 | Mesmo rosto, chapéu e roupa do idle atual | Alta | Caminhada sem salto de posição; morte não altera escala |
| CH-03 — Vovó: conjunto coerente | Ajustar #112/#113/#114: idle, caminhada e morte | Perspectiva compatível com #001 e avental/óculos atuais | Alta | Mesma altura/pivô entre estados; sombra separada |
| CH-04 — Netinho: estados complementares | Limpar/separar #089/#090; remover números | #088 como referência de escala/roupa | Média | Idle sem ataques indevidos; morte sem rótulos gravados |
| CH-05 — Companheiro animado | Criar/recuperar ciclos coerentes dos três níveis, evitando #022 | #072/#024/#025 | Média | Não confundir imagem estática com animação; corpo/efeitos separados |

Inventário completo exige oito famílias de armas e cinco passivos. “Aprovado” para um nível não resolve automaticamente os outros dois. Os bônus genéricos também precisam de nome e valores, mas não de raridade ou retrato próprio.

## C. Vitória, derrota e feedback

| ID / elemento | Produção necessária e alvo | Referência de estilo/inspiração | Prioridade | Critério de aceite |
|---|---|---|---|---|
| FB-01 — Cabeçalho de vitória | Emblema de colheita concluída, sem texto; ~160 | Broto/visto de #059 e folhas de #119 | Média | Texto “Vitória” separado; não substituir a recompensa numérica |
| FB-02 — Cabeçalho de derrota | Chapéu/ferramenta apoiada, sem humilhação visual; ~160 | Chapéu do Fazendeiro e madeira #119 | Média | Expressivo e legível; não parecer exclusão do progresso permanente |
| FB-03 — Aviso de chefe | Marca de ameaça, placa curta e barra modular nomeada | Medalhão hostil #059, contorno de UI-01 | Alta | Forte sem tapar o jogador; identidade por nome, não só vermelho |
| FB-04 — Telegráficos de perigo | Círculo, cone/faixa e indicador de pouso conforme ataques existentes; preferir desenho no motor | Contorno alto contraste, chão visível através | Alta | Área corresponde ao alcance real; forma distingue ataque aliado/inimigo |
| FB-05 — Hit feedback | Recuperar linha de impacto de #060; flash por shader como alternativa | Estrela curta creme/amarela com contorno | Alta | Breve, não esconde projétil; opção futura de reduzir flashes |
| FB-06 — Ataques das armas | Recuperar #053/#058/#108/#042/#060 e projéteis #014/#015/#099/#104 | Ferramentas e efeitos da própria família | Média | Arma, trilha e partícula independentes; não duplicar corpos |
| FB-07 — Morte de pragas | Recuperar #083/#102, 3–4 quadros curtos | Folhas, casca e poeira rural | Média | Não parece XP; não altera alvo/colisão após morte |
| FB-08 — XP, coleta e level-up | Recuperar #062 com núcleo e brilho separados | Semente para XP e broto para evolução | Alta | XP e ouro distintos; sem brilho magenta sobre terreno |
| FB-09 — Poça e onda | Corrigir #063 e destacar o estado perigoso | Lama e anel de poeira | Média | Contorno visível; estado final tênue não mantém dano invisível |
| FB-10 — Recompensa creditada | Pequeno brilho/contador interpolado, preferir motor | Ouro de UI-05, partículas discretas | Baixa | Só anima valores salvos; não credita moedas novamente |

## D. Cenários e identidade do mundo

| ID / elemento | Produção necessária e alvo | Referência de estilo/inspiração | Prioridade | Critério de aceite |
|---|---|---|---|---|
| AM-01 — Chão do Celeiro | Corrigir #037 ou #115; escolher uma direção antes de produzir variantes | Terra/palha ou tábuas discretas | Alta | Mosaico 2×2 e 4×4 sem juntas dominantes; inimigos marrons legíveis |
| AM-02 — Chão do Pomar | Corrigir #012, reduzir manchas e emendas | Folhagem outonal do mapa #094 | Alta | Piso reconhecível sem competir com ataques e pragas |
| AM-03 — Variantes de chão | Duas variações discretas por mapa depois da base aprovada | #111 Horta e bases corrigidas AM-01/02 | Média | Mesma borda/valor tonal; distribuição sem padrão óbvio |
| AM-04 — Props: exportação | Preparar #092/#093/#095; não requer redesenhar todos os objetos | Kits aprovados | Média | Escala coerente; oclusão controlada; decoração não promete colisão falsa |
| EN-01 — Inimigos já ativos com arte problemática | Limpar Lagarta #027, Gafanhoto gigante #065, Lesma #109; ajustar Gafanhoto comum #064 | Contorno dos novos #100/#087 e proporções próprias | Alta | Boa leitura no terreno real, chão removido e estados separados |
| EN-02 — Variantes futuras | Ajustar Aranha #003, Besouro #019, Formiga #054 e Grilo #070 | Família nova de insetos | Baixa | Só integrar depois de aprovar e implementar suas mecânicas; não bloqueia UI |
| BR-01 — Título tipográfico do jogo | Composição do nome sobre/ao lado de #119, fonte licenciada | Emblema aprovado com hierarquia limpa | Média | Legível em tela pequena, sem título gerado dentro de imagem |
| BR-02 — Ícone de aplicativo e splash | Criar após fixar identidade; ícone adaptável e marca de carregamento | Fazendeiro canônico + emblema rural | Média | Silhueta reconhecível sem palavras minúsculas; testar recortes de launcher |
| BR-03 — Cosméticos e retratos extras | Produção somente após decisão de conteúdo e identidade | Mesma família dos três personagens | Baixa | Não inserir Lulu/skins como conteúdo jogável sem escopo específico |

## Itens que não precisam de sprites novos agora

- Fundo principal do lobby: #094 já aprovado.
- Emblema rural: #119 já aprovado; falta somente composição tipográfica.
- Base de painel: #120 já aprovada.
- Botões normal/pressionado/desabilitado: #118 já aprovado.
- Medalhões de mapas: #059 já aprovado.
- Números de nível, nomes, valores antes/depois, timer, abates, ouro e porcentagens: texto do motor.
- Overlay de pausa, preenchimento das barras, foco, seleção, telegráficos simples e animação de contador: podem ser desenhados pelo motor.
- Molduras de cartas raras/épicas/lendárias: fora do escopo, pois não existe raridade implementada.
- Botões de ataque/dash/habilidade ativa: fora do escopo, pois o combate atual é automático.

## Ordem de produção sugerida

1. Fixar identidade provisória dos personagens, família de madeira e grade de pixels. Resolver nível do canhão e símbolo único de ouro antes de encomendar versões.
2. Preparar fontes já aprovadas para lobby/painéis/passivos e criar UI-01 a UI-09. Protótipo funcional com texto onde faltar ícone.
3. Completar as oito famílias de armas e os retratos, com nomes/níveis corretos; ligar cartas aos mesmos dados do combate.
4. Implementar sinais essenciais de perigo, chefe, save e XP. Revisar terrenos e inimigos ativos para contraste.
5. Refinar animações, vitória/derrota e identidade de aplicativo. Variantes futuras e cosméticos por último.

## Checklist de entrega de cada asset

- [ ] Nome estável, função, nível/estado e vínculo ao ID de dados documentados.
- [ ] PNG com alpha real; fundo transparente testado em claro/escuro.
- [ ] Sem xadrez, franja magenta, títulos, números de folha ou bordas cortadas.
- [ ] Mesmo estilo, direção, espessura de contorno e escala da família.
- [ ] Quadros com retângulos/pivôs estáveis; efeitos separados do corpo quando necessário.
- [ ] Leitura revisada no tamanho de exibição, não apenas ampliada.
- [ ] Painéis/botões testados em nove cortes; texto longo e estados cabem.
- [ ] Chão testado em repetição; símbolos relevantes testados sobre os três mapas.
- [ ] Interface validada por toque em aparelho real e com redução de efeitos.

Esta lista é um backlog de produção e correção. Não declara que as imagens já foram criadas, que a nova UI foi implementada ou que a validação mobile foi concluída.
