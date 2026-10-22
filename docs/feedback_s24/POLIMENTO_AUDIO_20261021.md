# Polimento de HUD e controle — feedback em áudio, 21/10/2026

Este documento registra o pacote inicial do áudio. A integração posterior 0.25.0 mantém essas mudanças e acrescenta os mapas/atores aprovados e os ajustes de escala HD; veja [a validação atual de 640 verificações](../integracao_hd/README.md). A suíte S24 passou a verificar arenas finitas, totalizando 62 checks em vez dos 68 da etapa anterior.

## Pedidos identificados

| Origem | Feedback | Implementação |
|---|---|---|
| Áudio 20:15:42, início | Movimento no ponto em que o dedo toca, em vez de um controle fixo | Joystick flutuante, neutro ao nascer, visível somente durante o toque |
| Áudio 20:15:42, 15–31 s | Excesso de informação no topo e espaço inferior sem informações úteis | Topo compacto com vida, XP, tempo e abates; equipamento na parte inferior |
| Áudio 20:15:42, 31–55 s | Acesso ao menu de informações/configuração com pausa | Botão de menu compacto; mantém pausa real, Esc/voltar e inventário/atributos existentes |
| Áudio 20:16:23 | Ícones de armas e níveis na parte inferior, sem repetir o nome da lavoura | Três espaços de armas e seis de buffs, com ícones e níveis reais; nome do mapa disponível no menu |

As referências faladas a outros jogos não ficaram claras na transcrição e não foram tomadas como requisitos. Não foi inferido um pedido de remover a pausa.

## Decisões de implementação

- Novos toques só entram no joystick após a UI processar os eventos. O menu não inicia movimento.
- Depois que um dedo assume o joystick, seus eventos de arraste e soltura são recebidos antes da UI. Soltar sobre um botão não prende o personagem nem aciona o botão.
- Outro dedo não rouba o controle. Pausa, perda de foco e mudança de tamanho limpam a entrada.
- O ponto de origem do gesto é o toque real. A arte é mantida dentro da área segura; tocar perto de uma borda não gera deslocamento inicial involuntário.
- Vida/XP/tempo/abates permanecem no topo. Fases e chefes continuam com seus avisos; o nome do mapa não ocupa espaço permanente.
- A faixa inferior mostra os três espaços de armas e seis de passivos. Evoluções atualizam ícone e nível, sem recriar a interface a cada quadro. Se um nível não possui arte própria, mantém o ícone original da arma.
- O nível da arma é exibido como atual/máximo do catálogo. Não foi criada barra fictícia de XP individual: as armas evoluem pelas cartas existentes. A barra de XP mostra o progresso real do personagem.
- Valores de combate, limites de inventário, progressão, recompensas e conteúdo dos mapas não foram rebalanceados.

## Verificação

| Suíte | Verificações | Falhas |
|---|---:|---:|
| stability_suite | 79 | 0 |
| s24_feedback_suite | 68 | 0 |
| ui_suite | 142 | 0 |
| mobile_hud_suite | 35 | 0 |
| Total | 324 | 0 |

A suíte nova verifica toque em áreas diferentes e junto à borda, entrada inicialmente neutra, direção, propriedade do dedo, soltura sobre menu, pausa/retorno, níveis máximos, ícones de armas evoluídas, XP verdadeiro e HUD sem cortes em viewports reais de 360 × 640, 720 × 1560 e 1280 × 720.

As capturas visuais usam o Godot desktop em formato de celular. Ainda é necessário validar conforto do gesto, escala dos textos e recortes do sistema em aparelho Android físico.

## Arquivos locais de apoio

Na raiz do workspace, fora do repositório do jogo:

- `Feedback_Audios_20261021/`: transcrição automática com timestamps e logs das suítes. Os áudios originais foram lidos localmente, sem upload.
- `Previa_Polimento_Feedback_20261021/`: demonstração real na lavoura, capturas e atalho para jogar.

Os atalhos das três prévias anteriores carregam o HUD e o joystick compartilhados atualizados. Suas imagens antigas continuam como registro da apresentação anterior.
