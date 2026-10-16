# Interface rural — implementação e validação

Entrega local: 16/10/2026. Godot 4.7.2, GDScript, renderer Mobile.

## O que foi implementado

- **Lobby:** mapa ilustrado com medalhões posicionados nas clareiras, seleção de destinos e indicação de bloqueio/conclusão. Abas de Mapas, Personagens e Fazenda; saldo de ouro, personagem escolhido e ação de iniciar permanecem acessíveis.
- **Personagens:** retratos aprovados de Fazendeiro/Netinho, descrição e arma inicial. Vovó conserva apresentação textual até sua arte ser corrigida. Desbloqueio continua usando os custos existentes.
- **Fazenda:** ícones aprovados, nível atual → próximo, descrição e preço. Compra e desbloqueio agora persistem débito e benefício juntos; falha reverte ambos, com mensagem na tela.
- **HUD:** vida/XP em barras geradas pelo motor, tempo, abates, mapa/fase, botão de pausa legível e barra nomeada do chefe. Indicador de fase mantém o comportamento temporal existente.
- **Joystick:** base circular e manopla desenhadas pelo motor, em cores coerentes. Preserva área de entrada, posicionamento e limpeza de movimento do pacote de estabilidade.
- **Pausa:** abas Equipamento/Atributos, lista de armas e passivos com níveis e valores, ícones aprovados quando disponíveis. Reiniciar/sair pelo menu exige confirmação, preservando a pausa.
- **Cartas:** três opções empilhadas, tipo, nível atual → próximo, valores efetivos, detalhes completos da seleção e acesso à build. Selecionar não aplica: o botão Confirmar consome uma escolha. Geração da carta impede callbacks antigos de gastar a próxima opção.
- **Vitória/derrota:** tema compartilhado, descrição das consequências de próximo mapa/modo livre, recompensa salva, crédito no encerramento, saldo permanente e build final. Falha de save informa pagamento pendente e oferece nova tentativa.

As telas usam madeira e pergaminho do conjunto aprovado, sem depender dos sprites classificados para ajuste. O mundo e as animações antigas do combate não foram substituídos neste pacote: a autorização aplicada aqui é a implementação da interface com fontes aprovadas.

## Arte integrada

Foram preparados **29 recursos PNG** em `art/ui_rural/`: mapa, painel, emblema, três estados de botão, quatro medalhões, cinco passivos, três upgrades de fazenda, dois retratos e nove ícones de armas por nível.

`art/ui_rural/manifest.json` registra arquivo-fonte, recorte, tamanho e SHA-256. `tools/prepare_ui_assets.py` reproduz a preparação a partir da pasta original, com Pillow/NumPy. A preparação faz recorte, remoção de chave magenta e redução; não gera nova arte. Os originais foram preservados.

Após a primeira renderização, foram corrigidos os limites de recorte dos botões, botas, ímã e ícones da fazenda. A prancha final dos 29 recursos foi inspecionada. Itens sem ícone aprovado usam nome/nível; nenhum tier 2 é apresentado como se fosse tier 1. Novas imagens e animações continuam a cargo de Artur no Google Flow, conforme `docs/direcao_visual/README.md`.

## Arquitetura

| Arquivo | Responsabilidade |
|---|---|
| `rural_ui.gd` | Theme compartilhado, texturas aprovadas, painéis, botões, estrutura de modal com conteúdo rolável e rodapé fixo, equipamento/atributos |
| `ui_data.gd` | Formatação PT-BR e apresentação de valores provenientes dos DBs e do jogador; sem modificar a simulação |
| `hub.gd` / `hub.tscn` | Lobby e compras; tratamento transacional de falha de save |
| `hud.gd` / `hud.tscn` | HUD compacto e barra de chefe |
| `level_up_ui.gd` | Seleção, confirmação, detalhes e fila de melhorias |
| `pause_menu.gd` | Abas de consulta e confirmação de abandono/reinício |
| `boss_victory_ui.gd` / `run_end_ui.gd` | Continuidade, resultados e estados de persistência |
| `player.gd` | Envia à apresentação o prêmio já salvo e o bônus de derrota; fórmulas do pacote anterior preservadas |
| `TouchJoystick.gd` | Desenho circular do controle existente |

Containers distribuem conteúdo; o corpo das janelas pode rolar e ações permanecem no rodapé. O modal usa área segura nos sistemas móveis, ainda sem validação em aparelho físico. Durante a regressão, foi corrigida uma altura provisória excessiva após textos longos e um callback diferido que tentava acessar uma janela já removida.

A UI continua consumindo o `PauseManager`; nenhum novo escritor de `SceneTree.paused` foi introduzido. Menus antigos presentes em algumas cenas são ocultados e substituídos pela composição em código, mantendo caminhos usados pela versão atual.

## Precisão dos números e balanceamento

Os DBs de armas, inimigos, mapas, passivos, personagens e upgrades não foram alterados. Os valores exibidos seguem o comportamento real:

- Dano por acerto inclui o bônus flat do jogador.
- Intervalo efetivo de foice, forquilha e projéteis inclui o multiplicador com piso de 0,25.
- Aura, companheiro e armadilha mantêm seus intervalos próprios, como no código existente; a UI explicita essa limitação.
- Dano de explosão permanece separado e não recebe um bônus que a implementação atual não aplica.
- Passivos de velocidade/coleta/intervalo acumulam multiplicativamente. A interface calcula essa composição em vez de repetir totais genéricos incorretos.
- Vida, defesa, alcance, duração, ricochetes e perfurações são apresentados quando pertinentes; sem DPS presumido, raridade inventada ou segunda moeda.
- Números usam vírgula decimal e até quatro casas, removendo zeros finais; representam a precisão de apresentação, não todos os dígitos de ponto flutuante.

## Testes executados

**195 verificações dirigidas passaram: 78 de estabilidade + 117 de interface, zero falhas.** As execuções finais retornaram código 0. Os logs foram verificados separadamente para erros de script/engine, pois só a contagem de assertions não detecta todos os erros.

| Suíte | Cobertura |
|---|---|
| `tests/stability_suite.gd` | Controle, pausa sobreposta, shapes independentes, pooling, timers, dez reinícios, recompensas e campanha dos três mapas |
| `tests/ui_suite.gd` | Dano e intervalos das oito armas nos três níveis comparados às entidades/timers; passivos previstos vs aplicados; piso de cooldown; compras com falha/retry; seleção/confirmação; callback antigo; posicionamento das ações em quatro tamanhos |
| `tests/visual_smoke.gd` | 15 capturas reais: lobby, personagens, fazenda, gameplay, pausa, atributos, HUD com chefe, cartas, seleção, vitória, erro de save da vitória, resultado, inventário cheio, erro de save da derrota e derrota |

Tamanhos avaliados por geometria: 360×640, 720×1280, 1080×2400 e 1280×720. Capturas D3D12 Mobile na RTX 4050, janela pedida em 720×1280 e ajustada pelo desktop para 720×1055 na última execução. Capturas críticas foram inspecionadas visualmente: ações acessíveis, recortes corretos e textos dentro dos painéis.

Os testes usam saves em `tests/.tmp/`, redirecionados antes de qualquer gravação; o save pessoal não é alterado. São cenários acelerados/determinísticos de engenharia, não campanhas completas jogadas manualmente. Alguns testes acionam sinais/callbacks de botões diretamente; não substituem um teste de toque no Android.

Para repetir, na pasta do projeto, substitua `godot` pelo executável instalado:

```powershell
godot --headless --audio-driver Dummy --path . --script res://tests/stability_suite.gd
godot --headless --audio-driver Dummy --path . --script res://tests/ui_suite.gd
godot --audio-driver Dummy --path . --resolution 720x1280 --script res://tests/visual_smoke.gd
```

As capturas ficam em `tests/.tmp/`, ignorado pelo Git e excluído do ZIP. O empacotamento do projeto foi autorizado pelo usuário em 16/10/2026. Esta entrega não inclui novo commit ou publicação no GitHub.

## Como testar manualmente

1. Abrir `project.godot` e iniciar pelo Hub. Alternar as três abas, tentar mapa bloqueado e iniciar uma partida.
2. Mover pelo joystick; pausar, consultar Equipamento/Atributos, cancelar Reiniciar e continuar.
3. Na melhoria, selecionar uma carta, conferir números e confirmar. Confirmar rapidamente duas vezes não deve gastar a próxima escolha.
4. Conferir a barra nomeada do chefe. Na vitória, comparar as opções de próximo mapa e modo livre e verificar o prêmio salvo.
5. Terminar a partida, conferir valores creditados e reiniciar. Repetir com build maior para testar rolagem.

## Limitações e próxima entrega

- Ainda é necessário validar ergonomia, safe areas, gestos e desempenho em Android físico e partidas longas.
- A UI usa fonte padrão do Godot; seleção/licenciamento de uma fonte rural de título continua no backlog.
- O inventário usa lista legível com ícones disponíveis e valores, em vez de uma grade exclusivamente gráfica; faltam imagens aprovadas de vários tiers.
- Configurações e cosméticos não foram inseridos como botões sem função. Não fazem parte desta implementação.
- Nenhuma nova animação foi encomendada ou gerada. Vovó e demais fontes pendentes aguardam material aprovado do Flow.
- O projeto é entregue em ZIP após autorização do usuário em 16/10/2026. Extraia e abra `project.godot` no Godot 4.7.2; o pacote contém o projeto-fonte, não um APK ou executável exportado.
