# O Fazendeiro Frenético

Jogo 2D de combate automático para Android, desenvolvido em Godot. O jogador enfrenta pragas, escolhe melhorias e evolui suas armas durante partidas com temática rural.

## Abrir o projeto

1. Instale o Godot 4.7.2 Standard, com suporte a GDScript.
2. Importe o arquivo `project.godot` no gerenciador de projetos.
3. Aguarde a importação dos recursos e pressione **F6** para executar uma cena ou **F5** para iniciar pelo Hub.

O movimento usa joystick virtual; a emulação de toque pelo mouse está habilitada para testes no computador.

## Sistemas atuais

- Campanha Horta → Celeiro → Pomar, com desbloqueio de mapas.
- Três fases por mapa, chefe fixo e opção de continuar em modo livre.
- Oito armas disponíveis, três armas fixas por run, oito passivos disponíveis e três personagens com atributos diferentes.
- Progressão por XP, melhorias durante a partida e upgrades permanentes.
- Hub, pausa, resultados, áudio e pooling parcial de entidades.

## Estado do desenvolvimento

O primeiro pacote de controle e estabilidade está implementado. Consulte [o relatório técnico e os comandos de teste](RELATORIO_ESTABILIDADE.md). A validação dirigida passou em Windows; após o primeiro teste do usuário no S24+, a revisão 0.24.2 aguarda nova avaliação no aparelho e partidas de longa duração.

Versão em desenvolvimento. Os três personagens e os sete inimigos ativos têm famílias visuais próprias. O preset de exportação Android está incluído; o teste do usuário no Galaxy S24+ orientou o pacote de ergonomia, mapas e encontros descrito abaixo. Algumas artes complementares e o balanceamento final continuam pendentes.

Os documentos `DOCUMENTO_COMPLETO_PROJETO.md`, `RELATORIO_SPRITES.md` e `ESPECIFICACAO_AUDIO.md` registram etapas do desenvolvimento e podem conter descrições anteriores às regras atualmente implementadas.

Os recursos utilizados pelo jogo estão em `art/` e `audio/`. Caches do Godot e arquivos de configuração local do editor não são versionados.

A [direção visual e o fluxo de entrega de arte pelo Google Flow](docs/direcao_visual/README.md) incluem a auditoria dos 120 arquivos, os layouts de UI e o backlog de assets. Esses documentos descrevem o planejamento da nova interface.

A interface rural foi implementada com os assets aprovados. Veja o [relatório de implementação, validação e limitações](RELATORIO_INTERFACE_RURAL.md): lobby, HUD, pausa/inventário, cartas com valores e confirmação, vitória e derrota.

O [relatório dos sprites polidos](RELATORIO_SPRITES_POLIDOS.md) registra a integração posterior:184 fontes revisadas, personagens/inimigos animados, substituições,275 verificações e25 capturas do renderizador.

O [pacote atual do Fazendeiro, baseado nos anexos originais](docs/arte_fazendeiro_fiel/README.md), integrado em 18/10/2026, inclui 38 quadros: repouso, caminhada, corrida, dois gestos de descanso e morte. A documentação reúne GIFs, fontes Aseprite, prompts e os resultados de 322 verificações Godot. Ele substitui no jogo o estudo simplificado anterior, preservado em `docs/arte_fazendeiro/`.

A [Vovó Resistente](docs/arte_vovo_resistente/README.md) também recebeu uma família baseada nos anexos: 32 quadros de descanso, caminhada, corrida, plantio de uma muda e morte com alma de óculos. Essa integração preserva os atributos e foi verificada com 357 checks Godot em Windows. Veja as prévias, fontes e ressalvas no relatório.

Os [mapas remodelados](docs/remodelagem_mapas/README.md) documentam a primeira composição rural. O pacote posterior de feedback S24 mantém as parcelas decorativas e seu cache limitado, mas separa construções/cercas únicas nas bordas, com colisões e rotas de desvio. O centro permanece livre de colisões arquitetônicas.

A [pesquisa e direção musical country/sertaneja](docs/trilha_country/README.md) reúne a análise técnica das duas referências do usuário, cinco composições instrumentais de demonstração em MP3/OGG/MIDI, prompts de produção e 60 verificações técnicas. As propostas estão disponíveis para escuta e ainda não substituem a trilha ativa.

O [polimento de atores, interface e monetização](docs/polimento_atores/README.md) integra 126 quadros de Netinho/inimigos, prévias animadas, vestiário com roupas compradas por ouro e anúncios recompensados com retorno ao checkpoint ou dobra de moedas. Naquela entrega foram aprovadas 508 verificações de runtime/renderização. O plugin AdMob Android está instalado com IDs de teste; a configuração da conta de produção e a validação completa dos anúncios no aparelho continuam pendentes. O relatório detalha as regras de retorno, limites e evidências visuais.

O preset **Android Teste** gera APKs ARM64 de desenvolvimento para o Galaxy S24+. O [guia de instalação no Android](docs/TESTE_ANDROID.md) descreve as builds e o roteiro no aparelho. Os IDs de anúncios continuam sendo de teste; a configuração de produção permanece pendente.

O [pacote de feedback S24+ 0.24.2](docs/feedback_s24/README.md) aumenta e reposiciona o joystick, remove construções repetidas, acrescenta colisões periféricas e navegação, líderes de horda, três armas fixas por run e mais itens/atributos. O relatório reúne regras, valores iniciais, 594 verificações aprovadas e 12 capturas. O conforto e a dificuldade desta revisão precisam de novo teste no aparelho.
