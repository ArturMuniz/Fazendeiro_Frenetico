# Etapa 2 — Arquitetura visual e mapa de interface

Projeto: O Fazendeiro Frenético. Data: 15/10/2026. Proposta de design, ainda não implementada.

## Princípio de composição

Madeira para estrutura, pergaminho para informação, ferramentas/sementes para identidade e área central livre para sobrevivência. O acabamento vem de consistência, hierarquia e resposta ao toque. Evitar molduras pesadas em cada número do HUD.

Referências de gênero consultadas: [Brotato, página oficial do produto](https://store.steampowered.com/app/1942280/Brotato/), com armas automáticas e construção de builds; [Vampire Survivors, site da poncle](https://poncle.games/vampire-survivors), com sobrevivência e progressão entre tentativas. A aplicação dessas referências abaixo é uma proposta própria: favorecer decisões de build claras e leitura rápida em movimento, sem copiar a arte ou atribuir a esses jogos os layouts aqui especificados.

## Contrato: somente fontes aprovadas

Os IDs referem-se à tabela completa da Etapa 1. Preparação de uma fonte aprovada significa recortar, remover chave magenta, definir pivô e exportar; não redesenhar componentes com defeitos.

| Uso | Fonte aprovada | Restrição |
|---|---|---|
| Fundo do lobby | #094 — Pixel_art_campaign_map | Manter proporção e clareiras; nunca esticar para preencher a tela |
| Identidade no cabeçalho | #119 — Wooden_farm_game_logo_emblem | Nome do jogo em texto do motor, fora da textura |
| Painéis, slots e cartas provisórias | #120 — Wooden_panel_frame_asset | Nove cortes; cantos/ferragens não esticam; testar a espessura em miniaturas |
| Botões | #118 — Wooden_buttons_pixel_art_sheet | Normal, pressionado, desabilitado; rótulos do motor |
| Estados dos mapas | #059 — Four_wooden_medallion_game_buttons | Cada símbolo acompanhado de nome/estado em texto |
| Upgrades da fazenda | #096 — Pixel_art_item_icons | Confirmar vínculo ícone → efeito, sem assumir atributo pelo desenho |
| Passivos | #074 — icons_passives | Cinco recortes; o sexto espaço é vazio |
| Personagens disponíveis para exibição gráfica | #001 Fazendeiro idle; #088 Netinho | Enquanto Vovó estiver em ajuste, mostrar seu nome/atributos em card textual; não fingir que está bloqueada por falta de arte |
| Armas/companheiros aprovados | #024, #025, #031, #045, #046, #072, #079, #106, #107 | Exibir apenas quando corresponderem ao item e nível reais; nunca usar tier 2 como tier 1 |
| Outros itens sem ícone aprovado | Texto e slot neutro baseado em #120 | A ausência de arte não esconde o item nem modifica o inventário |
| Cenário e decoração opcionais | #110, #111; #092, #093, #095 | Decoração de lobby ou piso compatível; não colocar props sobre texto |

Não usar as barras #017/#018, carta #034, joystick #077, moedas #082 nem símbolos #097 enquanto estiverem em ajuste. **Texto, formas simples e preenchimentos feitos pelo motor são componentes de UI, não sprites novos ou reprovados.** Eles permitem um layout funcional usando somente o conjunto aprovado. As artes finais correspondentes estão no backlog da Etapa 3.

## Sistema visual comum

- Referência de layout: 720×1280 em retrato. Coordenadas abaixo são unidades de referência, não pixels físicos garantidos em todo telefone.
- Trabalhar dentro da área segura do aparelho; margem inicial de 24, espaçamentos em múltiplos de 8 e intervalos entre seções de 16–24.
- Elementos de toque principais: área mínima proposta de 96×96 nessa referência, com folga entre ações. Verificar tamanho físico no aparelho; não confundir 96 pixels de projeto com 96 dp.
- Tipografia: títulos 40–48; botões 32–36; corpo 30–32; informação secundária 26–28. Evitar fonte pixelada estreita em descrições longas. Selecionar uma fonte de corpo com acentos PT-BR antes de fechar o tema.
- Paleta proposta, a validar em tela: madeira #704426, contorno #281D17, pergaminho #F1E2BF, texto #2B2118, vida #BC4036, XP #429DA6, ouro #E7B94C. Valores são diretrizes, não cores medidas dos arquivos.
- Texto escuro sobre pergaminho sólido; texto claro sobre painel escuro sólido. Não colocar parágrafos diretamente sobre a grama. Cor nunca é a única indicação de estado.
- Vermelho é reservado para vida/ameaça/ações destrutivas; verde para ganho e conclusão; dourado para moeda e destaque. Não transformar essas cores em raridades não implementadas.
- Animações propostas: feedback de pressão imediato e transições curtas de 120–180 ms. Não atrasar a retomada ou manter combate ativo durante uma transição modal.
- Preferir transformação inteira para sprites pixelados; manter texto legível quando a escala disponível não for inteira. Não distorcer a proporção de personagens para preencher slots.

## 1. Lobby e menu principal

| Região | Âncora/layout em 720×1280 | Conteúdo e comportamento |
|---|---|---|
| Cabeçalho | Topo, área y=24–144 | Emblema #119 pequeno à esquerda; título em duas linhas ao lado; saldo de ouro em texto à direita, sem segunda moeda |
| Mapa | Centro, caixa x=96, y=160, w=528, h=720 | #094 em modo manter proporção/contain. Fundo excedente neutro; não cortar Horta/Pomar para preencher |
| Nós | Filhos do mesmo retângulo efetivo da imagem | Medalhões #059 nas clareiras. Referências aproximadas na imagem: Horta (0,68; 0,69), Celeiro (0,35; 0,44), Pomar (0,67; 0,21); ajustar visualmente após importação |
| Resumo selecionado | x=24, y=896, w=672, h=144 | Painel #120: nome do mapa, estado, chefe e personagem. Aviso curto: “Cada mapa inicia uma nova build” |
| Ação principal | x=24, y=1056, w=672, h=96 | Botão #118 “Jogar — Horta”; bloqueado: “Conclua Horta para liberar”. Não depender apenas de cinza |
| Navegação | Centro-inferior, y=1168–1256 | Três abas textuais: Mapas, Personagens, Fazenda. Configurações acessíveis por botão textual no cabeçalho ou tela secundária; ajustar altura se necessário |

O posicionamento dos medalhões é relativo ao retângulo **real** da imagem depois do contain, não à tela inteira. A área ilustrada pode ficar mais estreita; manter alvos de toque grandes mesmo quando o medalhão visual é menor. Textos de mapa ficam em pequenas placas sem encobrir o caminho.

Estados do nó: Bloqueado (cadeado + requisito), Disponível (broto + botão Jogar), Concluído (visto + “Concluído”). O símbolo de boss serve ao painel do mapa; não substituir “Concluído” por “Boss” nem sugerir uma quarta região.

Personagens: três cards com nome, arma inicial, diferenças de atributos, status e custo real. Fazendeiro/Netinho usam as fontes aprovadas; Vovó recebe apresentação textual até sua arte ser corrigida. Selecionado tem borda e palavra “Selecionado”.

Fazenda: cards verticais de upgrades com #096, nível atual → próximo, ganho real, custo e botão Comprar. Mostrar nível máximo e saldo insuficiente explicitamente. Desabilitar compra duplicada enquanto grava. A arte não altera a economia.

Cosméticos ficam fora da navegação principal até existir conteúdo funcional. Configurações futuras devem oferecer volume, posição do controle e intensidade dos efeitos; não exibir switches que não persistem ou não fazem nada.

## 2. HUD de gameplay

```text
┌────────────────────────────────────┐
│ Vida 78/100    02:14        Pausa   │
│ XP ━━━━━━━━━  Nível 6              │
│ Horta · Fase 2/4  ·  Abates 47      │
│ [Barra nomeada do chefe, se houver] │
│                                    │
│          ÁREA DE COMBATE            │
│                                    │
│                                    │
│ (joystick)                         │
└────────────────────────────────────┘
```

| Elemento | Posição | Fonte/execução e regra |
|---|---|---|
| Vida | Superior esquerdo; caixa ~264×56 em x=24, y=24 | Trilho simples e fill do motor; “78 / 100” sempre legível. Moldura fina derivada de #120 somente se não engolir o preenchimento |
| Tempo da run | Superior central, sem sobrepor vida | MM:SS; marcador temporal estável. O tempo restante da fase fica no texto secundário, com rótulo “Fase”, quando necessário |
| Pausa | Superior direito, alvo 96×96 | Botão #118 com texto “Pausa” até aprovar símbolo #097. Não adicionar botão de tiro ao auto-battler |
| XP e nível | Abaixo da primeira linha; aproximadamente y=104 | Barra fina, rótulo “Nível 6”. Preenchimento ciano, diferente da vida; sem textura da barra reprovada |
| Mapa/fase e abates | Linha y=144–184 | “Horta · Fase 2/4”; “Abates 47”. Número de inimigos vivos só em modo de diagnóstico, sem confundir com abates |
| Ouro | Fora do HUD permanente; na pausa/resultados | Ouro bancado só muda quando efetivamente salvo. Se houver demanda por contador no HUD, rotular “Ouro salvo” e usar valor real, nunca chamar estimativa de ouro coletado |
| Boss | Abaixo da faixa superior, somente no boss | Barra fina nomeada; mantém área central livre. Entrada do chefe com aviso curto; não exibir anúncio atrás de cartas |
| Joystick | Inferior esquerdo, dentro da área segura | Base visual ~144, centro a ~112 da esquerda e ~132 do fundo. Duas formas do motor enquanto #077 é corrigido; manopla e base compartilham centro |
| Zona do polegar | Área inferior esquerda reservada, sem botões concorrentes | Manter pista de perigo visível fora do dedo. Opção futura de espelhar para direita altera controle e reservas, não apenas a textura |
| Inventário resumido | Na pausa; opcional HUD compacto após teste | Evitar colocar 12 slots grandes no campo. Inventário completo é acessível via Pausa, sem novo botão de ação |

O HUD não deve inventar dash, habilidade ativa, consumível ou ataque manual. A mecânica atual exige movimento e pausa. Novos botões só entram junto com a mecânica correspondente.

## 3. Pausa, inventário e estatísticas

Overlay escuro do motor sobre gameplay congelado; painel #120 central, largura 672 e altura adaptável. Rodapé de ações fica fixo; somente a região de conteúdo rola em telas baixas.

| Região | Conteúdo |
|---|---|
| Topo do painel | “Pausado”, mapa/fase e tempo; botão grande “Continuar” claramente prioritário |
| Abas de conteúdo | “Equipamento” e “Atributos”; mesma área central, evitando uma parede de números |
| Equipamento | Duas linhas de seis slots: Armas 0–6 e Passivos 0–6. Slot vazio tem rótulo/traço, não cadeado. Item mostra nome e nível 1–3; ícone somente se aprovado e correto para aquele tier |
| Detalhe selecionado | Toque em um slot mostra nome, nível, valores efetivos e explicação curta no próprio painel; não depender de hover. O item não é descartado/equipado por esse toque |
| Atributos | Vida atual/máxima, velocidade, dano adicional, intervalo de ataques/modificador, defesa e coleta. Unidades explícitas; separar valor base de bônus quando necessário |
| Rodapé | Continuar; Reiniciar; Voltar ao Hub. Reiniciar/Hub abrem confirmação por perda da run em andamento, com texto específico e cancelamento fácil |

Na resolução de referência, slots visuais de 80 com alvos de toque de 96 podem usar faixa rolável; não sobrepor alvos. Alternativa preferida na tela de pausa: grade 3×2 por categoria, cada célula com área de toque 96 ou maior. A contagem seis é preservada em ambos os formatos.

O conteúdo de estatísticas deve refletir cálculo real: dano flat não vira percentual; intervalo menor significa ataque mais frequente; passivos incrementais são apresentados com total acumulado claramente identificado. Não inventar DPS para armas cujo acerto, alvo e frequência não possam ser expressos corretamente.

## 4. Escolha de melhorias

Em retrato, **três cartas horizontais empilhadas**, não três colunas estreitas. A leitura de valores é mais importante que uma ilustração grande.

| Região | Layout sugerido |
|---|---|
| Cabeçalho | y=40–136: “Escolha uma melhoria”; quantidade pendente se houver; instrução “Selecione uma opção” |
| Cartas | x=24, w=672; três blocos de h≈184, separados por 16, iniciando em y≈176; #120 como moldura adaptável |
| Dentro da carta | Ícone correto à esquerda (até 80×80); nome e tipo; nível atual → próximo; até três linhas principais de comparação. “Ver detalhes” expande a carta ou substitui o painel inferior |
| Build atual | Área abaixo das cartas com abas “Equipamento” e “Atributos”; mostrar lista compacta textual e rolagem, sem reduzir fonte para caber tudo |
| Confirmação | Rodapé fixo, botão #118 “Escolher Forquilha”; desabilitado até seleção. Separar selecionar de confirmar evita gastar escolha ao tentar ler |

Exemplo de conteúdo — **valores ilustrativos, não uma alteração de balanceamento**:

```text
Forquilha · Arma
Nível 1 → 2
Dano: 9 → 14
Intervalo: 0,6 s → 0,5 s
Alcance: 60 → 66
```

Nova arma: “Não equipada → Nível 1” e valores iniciais; nunca mostrar “0 de dano” como se já estivesse equipada. Bônus genérico: mostrar a mudança no atributo real, sem inventar nível de item. Nível máximo: não oferecer uma evolução inexistente.

Seta, número anterior e posterior permanecem legíveis sem cor. Destacar só o que mudou. Redução de intervalo pode receber indicação positiva “Ataca mais rápido”; não pintar todo número menor como perda.

Não criar molduras Comum/Rara/Épica: o sistema atual não tem raridades. Os tipos “Arma”, “Passivo” e “Atributo” usam a mesma família visual com rótulo explícito. O painel de detalhes permanece parte da escolha e mantém sua pausa, evitando um segundo controlador de tempo.

## 5. Vitória, modo livre e derrota

### Chefe derrotado: escolha de continuidade

Painel central #120, fundo de gameplay escurecido. Cabeçalho “Chefe derrotado!” e nome do mapa. Mostrar “Bônus de vitória salvo: 50” e, quando aplicável, “Primeira conclusão: +100”. O saldo animado só chega ao valor confirmado pela persistência.

Três botões verticais #118, nesta ordem: “Próximo mapa — Celeiro”, “Continuar no modo livre”, “Encerrar e ver resultado”. Usar texto claro em vez de “Voltar ao Hub” quando a ação primeiro abre o resultado. No último mapa, retirar a ação inexistente de próximo mapa e redistribuir espaço.

Mostrar junto ao próximo mapa: “Sua build será reiniciada”. Modo livre: “Mantenha sua build; a dificuldade continua aumentando”. Não misturar essas consequências com a descrição da recompensa.

Falha de gravação substitui opções por mensagem curta e “Tentar salvar novamente”. A confirmação só aparece quando a gravação termina; não celebrar crédito não persistido.

### Resultado final

Painel central com título “Vitória” ou “Fim da partida”, nunca depender apenas de verde/vermelho. Resumo: mapa, tempo, nível, abates e chefe derrotado. Abaixo, build final em lista/slots e bloco de moedas com discriminação:

- Bônus de vitória já salvo.
- Parcela por tempo e nível creditada agora.
- Bônus antigo de derrota após chefe, quando aplicável, sem ocultá-lo no total.
- Total obtido nesta run e saldo permanente, com rótulos distintos.

Botões grandes: “Jogar novamente” e “Voltar ao Hub”. Na derrota, a ação principal incentiva nova tentativa; na vitória, preservar decisão do jogador sem esconder o Hub. Sem ranking, precisão de tiro ou danos por arma se essas métricas ainda não forem coletadas.

Em caso de save falhar, substituir o crédito por “Pagamento pendente” e “Tentar salvar”; não permitir duplicar recompensa com clique repetido. O estado do modal respeita o PauseManager já implementado: resultado > vitória > melhorias > pausa manual.

## Adaptação e critérios de aceite

- Tela alta: ampliar área de mapa/combate, mantendo HUD nas bordas e ações na área segura. Não ampliar fonte e botões indefinidamente.
- Tela curta/landscape: HUD compacto, pausa em duas colunas quando couber, conteúdo de cartas com rolagem vertical e confirmação fixa. Não forçar o layout retrato a transbordar.
- Verificar 360×640, 720×1280, 1080×2400 e uma janela curta; depois testar em Android real. Esses testes do novo layout ainda não foram executados.
- Textos longos e números grandes não podem deslocar botões. Limitar abreviações a informação secundária; nome completo no detalhe.
- Testar sobre Horta, Celeiro e Pomar com inimigos e efeitos. Contraste aprovado na prancha não garante legibilidade em combate.
- Revisar toque de polegar, visibilidade sob o dedo, recortes da tela, foco, pausa sobreposta e retorno do aplicativo.
- Usar arte aprovada no nível correto; fallback textual onde falta imagem. Nenhum sprite “Precisa de Ajuste” entra como se já estivesse aprovado.

## Integração futura no Godot

Criar um Theme compartilhado, com estilos de painel/botão e tipografia. Usar Containers para fluxo de conteúdo e âncoras para HUD/área segura; posicionar os medalhões a partir do retângulo da textura. Uma fonte de dados deve alimentar nome, nível, valores da carta e efeitos do combate. A UI consome os estados existentes do PauseManager, sem escrever diretamente em `SceneTree.paused`.

Primeiro protótipo: lobby com #094/#059/#118/#119/#120, HUD funcional com formas do motor, pausa/inventário e cartas com texto real. Só depois incorporar o material corrigido da Etapa 3. Esta entrega planeja; não muda cenas, scripts ou balanceamento.
