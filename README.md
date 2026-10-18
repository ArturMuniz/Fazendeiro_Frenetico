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
- Oito armas, cinco passivos e três personagens com atributos diferentes.
- Progressão por XP, melhorias durante a partida e upgrades permanentes.
- Hub, pausa, resultados, áudio e pooling parcial de entidades.

## Estado do desenvolvimento

O primeiro pacote de controle e estabilidade está implementado. Consulte [o relatório técnico e os comandos de teste](RELATORIO_ESTABILIDADE.md). A validação dirigida passou em Windows; testes em Android físico e de longa duração continuam pendentes.

Versão em desenvolvimento. Os três personagens e os sete inimigos ativos têm famílias visuais próprias; animações e recortes selecionados foram integrados em16/10/2026. A revisão em Android físico e algumas artes complementares continuam pendentes. Não há configuração de exportação Android incluída nesta cópia.

Os documentos `DOCUMENTO_COMPLETO_PROJETO.md`, `RELATORIO_SPRITES.md` e `ESPECIFICACAO_AUDIO.md` registram etapas do desenvolvimento e podem conter descrições anteriores às regras atualmente implementadas.

Os recursos utilizados pelo jogo estão em `art/` e `audio/`. Caches do Godot e arquivos de configuração local do editor não são versionados.

A [direção visual e o fluxo de entrega de arte pelo Google Flow](docs/direcao_visual/README.md) incluem a auditoria dos 120 arquivos, os layouts de UI e o backlog de assets. Esses documentos descrevem o planejamento da nova interface.

A interface rural foi implementada com os assets aprovados. Veja o [relatório de implementação, validação e limitações](RELATORIO_INTERFACE_RURAL.md): lobby, HUD, pausa/inventário, cartas com valores e confirmação, vitória e derrota.

O [relatório dos sprites polidos](RELATORIO_SPRITES_POLIDOS.md) registra a integração posterior:184 fontes revisadas, personagens/inimigos animados, substituições,275 verificações e25 capturas do renderizador.

O [pacote atual do Fazendeiro, baseado nos anexos originais](docs/arte_fazendeiro_fiel/README.md), integrado em 18/10/2026, inclui 38 quadros: repouso, caminhada, corrida, dois gestos de descanso e morte. A documentação reúne GIFs, fontes Aseprite, prompts e os resultados de 322 verificações Godot. Ele substitui no jogo o estudo simplificado anterior, preservado em `docs/arte_fazendeiro/`.

A [Vovó Resistente](docs/arte_vovo_resistente/README.md) também recebeu uma família baseada nos anexos: 32 quadros de descanso, caminhada, corrida, plantio de uma muda e morte com alma de óculos. Essa integração preserva os atributos e foi verificada com 357 checks Godot em Windows. Veja as prévias, fontes e ressalvas no relatório.

Os [mapas remodelados](docs/remodelagem_mapas/README.md) usam canteiros e galpão na Horta, armazenamento e celeiro no terreiro, e fileiras de árvores frutíferas no Pomar. Cenário decorativo atravessável, desenho atrás dos atores e parcelas visuais com cache limitado preservam o combate durante deslocamentos. O relatório reúne pesquisa, antes/depois, fontes e testes.

A [pesquisa e direção musical country/sertaneja](docs/trilha_country/README.md) reúne a análise técnica das duas referências do usuário, cinco composições instrumentais de demonstração em MP3/OGG/MIDI, prompts de produção e 60 verificações técnicas. As propostas estão disponíveis para escuta e ainda não substituem a trilha ativa.

O [polimento atual de atores, interface e monetização](docs/polimento_atores/README.md) integra 126 quadros de Netinho/inimigos, prévias animadas, vestiário com roupas compradas por ouro e anúncios recompensados com retorno ao checkpoint ou dobra de moedas. Foram aprovadas 508 verificações de runtime/renderização. O plugin AdMob Android está instalado com IDs de teste; a configuração da conta, exportação e validação em aparelho continuam pendentes. O relatório detalha as regras de retorno, limites e evidências visuais.
