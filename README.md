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
