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

Versão em desenvolvimento, com polimento visual e correções técnicas pendentes. Alguns personagens e inimigos ainda usam arte provisória. Não há configuração de exportação Android incluída nesta cópia.

Os documentos `DOCUMENTO_COMPLETO_PROJETO.md`, `RELATORIO_SPRITES.md` e `ESPECIFICACAO_AUDIO.md` registram etapas do desenvolvimento e podem conter descrições anteriores às regras atualmente implementadas.

Os recursos utilizados pelo jogo estão em `art/` e `audio/`. Caches do Godot e arquivos de configuração local do editor não são versionados.
