# Primeiro pacote: controle e estabilidade

Data: 15/10/2026. Implementação local sobre a versão 24. O ZIP depende da aprovação do usuário.

## Resultado e arquitetura

Os seis itens do pacote foram implementados e passaram na suíte dirigida de regressão: **78 verificações, zero falhas**, Godot 4.7.2, Windows. Também foram capturadas e inspecionadas cinco telas com o renderer D3D12 Mobile na GPU RTX 4050. Isso não equivale a certificação de ausência de bugs, teste de longa duração ou validação em Android físico.

A ordem técnica proposta faz sentido. A pausa centralizada e o ciclo de vida das entidades são pré-requisitos para validar os demais sistemas. O bônus de vitória foi tratado neste pacote porque depende das transições entre vitória, modo livre e resultado. Cartas detalhadas, arte e balanceamento continuam nas próximas etapas.

## Alterações implementadas

### 1. Joystick

- Âncoras no canto inferior esquerdo; posição do indicador calculada em relação à base.
- Entrada e indicador são zerados ao pausar ou perder foco, evitando movimento preso após soltar o toque durante um menu.
- Eventos ignorados durante pausa; consultas retornam vetor zero.
- Verificações geométricas em 360×640, 1080×2400 e 1280×720; toque injetado no viewport produz deslocamento real do jogador.

Arquivos: `TouchJoystick.gd`, `virtual_joystick.tscn`.

### 2. Colisões independentes

- Shapes do corpo e da hitbox são duplicadas por instância, antes de aplicar o tamanho do inimigo.
- A foice arremessada e a aura também possuem shapes próprias.
- Inimigos desativados saem imediatamente do grupo de alvos e não continuam causando dano durante a devolução diferida ao pool.

Arquivos: `enemy.gd`, `thrown_foice.gd`, `melee_aura_weapon.gd`.

### 3. Pool e partidas consecutivas

- O spawner entrega explicitamente o jogador atual ao configurar um inimigo reutilizado.
- A devolução limpa a referência anterior; a configuração reinicia movimento, salto, animação, rajada e timers.
- Proteções contra devolução duplicada e aquisição de nós inválidos; limpeza das instâncias ociosas no encerramento.
- Removido o preload da própria cena nos scripts de entidades reutilizadas, evitando dependências circulares.

Arquivos principais: `pool.gd`, `enemy.gd`, `enemy_spawner.gd`, `projectile.gd`, `enemy_projectile.gd`, `damage_number.gd`.

### 4. Pausa e sobreposição de menus

Novo autoload `PauseManager`, único responsável por escrever `SceneTree.paused`.

- Estados RUNNING, MODAL e TRANSITION.
- Cada proprietário adquire seu bloqueio e libera apenas o próprio bloqueio.
- Prioridade: foco > resultado > vitória > cartas > pausa manual.
- Apenas o modal ativo fica visível. Fechar a vitória para continuar restaura cartas pendentes sem liberar o combate.
- Referências fracas e liberação ao sair da árvore impedem bloqueios pertencentes a telas destruídas.
- Mudanças de cena são centralizadas e protegidas contra chamadas duplicadas.
- Seleção de cartas usa identificação da geração para impedir que um clique duplicado consuma a próxima escolha.
- O resultado encerra a fila de melhorias; jogador morto não recebe novas escolhas.

Arquivos: `pause_manager.gd`, `project.godot`, `pause_menu.gd`, `level_up_ui.gd`, `boss_victory_ui.gd`, `run_end_ui.gd`, `hub.gd`, `player.gd`.

### 5. Timers de gameplay

- Duração dos projéteis, giro da foice e aterrissagem usam timers filhos das entidades, sujeitos à pausa da árvore.
- Timers são interrompidos na desativação e reiniciados na reutilização. Uma expiração da utilização anterior não deve atingir a nova entidade.
- Validado que o tempo restante permanece congelado e que os efeitos terminam após retomar.
- Liberação explícita dos streams de áudio no encerramento elimina os avisos de recursos pendentes observados no teste automatizado.

Arquivos: `projectile.gd`, `enemy_projectile.gd`, `thrown_foice.gd`, `enemy.gd`, `audio_manager.gd`.

### 6. Vitória e persistência

- O chefe concede e salva imediatamente 50 moedas, mais 100 na primeira conclusão do mapa, junto com o desbloqueio.
- Continuar em modo livre mantém esse crédito mesmo se a partida terminar em derrota.
- O encerramento credita a parcela restante: `int(tempo / 5) + nível × 3`. O bônus preexistente de 20 na derrota após chefe foi preservado, adicionalmente à vitória já salva.
- Encerrar como vitória ou avançar de mapa não adiciona esse bônus de derrota.
- Identificador por partida e recibos persistidos impedem repetir o prêmio ou a liquidação em callbacks/retries. O histórico é limitado aos últimos 128 recibos; não é um sistema de proteção contra edição de saves.
- A gravação escreve um arquivo temporário completo antes de substituir o save. Falhas retornam erro, revertem as alterações em memória da transação e mantêm uma tela para tentar salvar novamente.
- Resultados distinguem o bônus já recebido do crédito feito no encerramento.
- Saves anteriores permanecem compatíveis: a ausência de `reward_receipts` inicializa um dicionário vazio. Não há pagamento retroativo de vitórias anteriores.

Arquivos: `save_manager.gd`, `player.gd`, `boss_victory_ui.gd`, `run_end_ui.gd`.

Os bancos de atributos, armas, inimigos e mapas não foram alterados. A diferença econômica pretendida é que o modo livre conserva o prêmio de vitória que antes podia perder.

## Validação reproduzível

Na pasta do projeto, substituindo `godot` pelo executável local:

```powershell
godot --headless --audio-driver Dummy --path . --script res://tests/stability_suite.gd
godot --audio-driver Dummy --path . --resolution 720x1280 --script res://tests/visual_smoke.gd
```

`tests/stability_suite.gd` testa controle, prioridades de pausa, colisões independentes, referências reutilizadas, timers, dez reinícios reais de cena, recompensas, falhas de gravação e recuperação, três mapas, próximo mapa, hub e reinício após derrota.

São testes dirigidos e acelerados: interrompem o spawner em cenários específicos, avançam fases diretamente e usam vida/dano de teste. Não são dez campanhas completas jogadas manualmente. Os saves são redirecionados para `tests/.tmp/`; o progresso pessoal não é sobrescrito.

`tests/visual_smoke.gd` captura gameplay, pausa, cartas, vitória e resultado em `tests/.tmp/`. A janela solicitada em 720×1280 foi ajustada pelo desktop para uma área renderizada de 720×1061. As cinco imagens foram verificadas: joystick alinhado, modais legíveis e somente a tela prioritária visível. As cartas mantêm os textos antigos, conforme o escopo.

A execução final da suíte terminou com `RESULT checks=78 failures=0`, código de saída 0 e sem avisos de vazamento. A execução gráfica terminou com código 0. `git diff --check` não encontrou erros de whitespace.

## Pendências e próxima etapa

Antes de declarar a etapa 1 completamente validada para distribuição: testar em aparelho Android real, alternância de aplicativo, gestos do sistema, multitoque, proporções com recortes e sessões longas com muitos inimigos. Não há configuração de exportação Android nesta cópia.

O fluxo transacional novo cobre vitória e encerramento; as compras antigas do hub ainda precisam de uma revisão específica de tratamento de falha de persistência na etapa de recompensas. Não há retomada de uma run interrompida: o prêmio já salvo é preservado, mas a parcela ainda não liquidada depende do encerramento da partida.

Depois dessa validação: esclarecer efeitos dos upgrades e implementar cartas com nível atual → próximo nível e valores derivados da mesma fonte usada pelo combate; depois inventário, feedback de dano/morte/chefes, arte/interface e, por último, balanceamento e otimização Android.

Não foi gerado ZIP nem publicado este pacote no GitHub. As alterações estão no projeto local para revisão.
