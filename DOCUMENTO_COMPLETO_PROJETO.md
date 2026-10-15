# O Fazendeiro Frenético — Documento Completo do Projeto

Documento de referência único, cobrindo visão geral, gameplay, sistemas, arte, tecnologia e pendências — reflete o **estado real e atual** do projeto (não o plano original, mas o que já está implementado e funcionando).

---

## 1. Visão Geral

**Gênero:** Auto-battler roguelike de arena (referências: Vampire Survivors, Brotato).

**Tema:** Um fazendeiro defende sua horta contra uma invasão de pragas mutantes. Tom bem-humorado, colorido, caótico.

**Plataforma-alvo:** Android, com foco em rodar bem em aparelhos de entrada.

**Engine:** Godot 4.7, GDScript, renderer "Mobile".

**Pilares de design:**
- Leveza técnica acima de tudo.
- Sessões curtas e repetíveis (roda em torno de 5-10 minutos hoje, configurável).
- Progressão dentro da run (fusão de armas/itens) **e** entre runs (moeda permanente, desbloqueios).
- Dificuldade que cresce continuamente, evitando que o jogador fique "forte demais" depois de um tempo.

---

## 2. Fluxo do Jogo (tela por tela)

```
Hub (tela inicial)
  → escolhe/desbloqueia personagem
  → compra upgrades permanentes da fazenda
  → "Iniciar Run"
      ↓
Run (main.tscn)
  → mapa sorteado entre 3 opções
  → move com joystick, ataques automáticos
  → ondas de inimigos, dificuldade cresce com o tempo
  → sobe de nível → escolhe upgrade (arma / passivo / stat genérico)
  → boss sorteado entre 3 aparece perto do fim da run
  → jogador morre (ainda não há "vitória", só sobrevivência)
      ↓
Tela de fim de run (mínima)
  → mostra tempo sobrevivido, nível alcançado, moedas ganhas
  → botão "Voltar para o Hub"
```

---

## 3. Gameplay — Sistemas Detalhados

### 3.1 Movimento e controle
- Joystick virtual touch-based (`TouchJoystick`), com emulação de mouse habilitada pra testar no PC.
- Personagem (`CharacterBody2D`) se move na direção do joystick; usa flip horizontal (não sprites por direção) pra economizar arte e processamento.
- Câmera (`Camera2D`) segue o personagem com suavização.

### 3.2 Combate
- Todas as armas atacam **automaticamente** — o jogador só se move e escolhe upgrades.
- Sistema orientado a dados: cada arma tem um `kind` que decide qual script/cena usar. Adicionar uma arma nova quase sempre é só editar uma tabela, sem escrever lógica nova.

| Kind | Script | Comportamento |
|---|---|---|
| `ranged` | `weapon.gd` | Projétil até o inimigo mais próximo; suporta perfuração, ricochete e dano em área (splash) via dados |
| `melee_swing` | `melee_swing_weapon.gd` | Golpe em área que causa dano a quem estiver dentro do raio no instante do ataque (pulso a cada cooldown) |
| `melee_aura` | `melee_aura_weapon.gd` | Dano contínuo (tick) a quem estiver dentro do raio, o tempo todo |
| `melee_stab` | `melee_stab_weapon.gd` | Estocada de alvo único, só acerta se o inimigo mais próximo estiver dentro do alcance |
| `summon` | `summon_weapon.gd` + `companion.gd` | Invoca um companheiro que persegue e ataca inimigos sozinho |
| `trap` | `trap_weapon.gd` + `trap.gd` | Larga armadilhas estacionárias que causam dano por tempo a quem passar por cima |

### 3.3 XP, nível e fusão
- Inimigos soltam orbes de XP ao morrer (atraídos pelo jogador dentro do raio de coleta/ímã).
- Ao encher a barra de XP, o jogo **pausa de verdade** (`get_tree().paused`) e sorteia 3 cartas entre: upgrades genéricos, armas (novas ou fusão) e passivos (novos ou fusão).
- **Regra de fusão:** 2 cópias de uma arma/passivo de nível N viram 1 cópia de nível N+1 (até nível 3). O sorteio nunca oferece uma arma/passivo já no nível máximo, nem arma nova se o inventário (6 armas / 6 passivos) estiver cheio.
- Upgrades genéricos aplicam bônus globais: +dano (flat, todas as armas), +velocidade de ataque (com piso de 25% do cooldown original, pra não explodir o DPS), +velocidade de movimento, +vida máxima com cura total.

### 3.4 Arsenal completo (8 armas)

| Arma | Tipo | Nível 1 → 3 (resumo) |
|---|---|---|
| Foice Giratória | melee_swing | Dano 6→16, raio 50→68, ativa por 0,2-0,25s a cada ataque |
| Motosserra Enferrujada | melee_aura | Dano/tick 4→10, raio 46→68, tick a cada 0,4→0,3s |
| Forquilha (Tridente de Feno) | melee_stab | Dano 9→22, alcance 60→74, cooldown 0,6→0,4s |
| Milho-Metralhadora | ranged | Dano 3→6, cooldown 0,6→0,3s |
| Canhão de Batata | ranged (pierce+splash) | Dano 14→24, perfura 0→3→infinito, explode em área 40→70px |
| Estilingue de Mamona | ranged (bounces) | Dano 4→7, ricocheteia 1→3→10 vezes |
| Bezerro Guarda-Costas | summon | Companheiro com dano 4→10, ataca a cada 1,2→0,8s |
| Cerca Elétrica | trap | Dano 3→6/tick, armadilha dura 3→4s, solta a cada 3→2s |

> Alcances corpo a corpo (46-74px) ficam sempre acima da distância real de contato entre personagem e inimigo (~22-28px), garantindo que o jogador consiga matar antes de encostar.

### 3.5 Itens passivos (5)

| Item | Efeito incremental por nível | Total no nível 3 |
|---|---|---|
| Espantalho de Bolso | Defesa +10%/+10%/+20% | -40% de dano recebido |
| Sementes Mágicas | Vida máxima +20/+30/+50 | +100 HP |
| Garrafa Térmica | Velocidade de ataque +10%/+10%/+30% | -50% cooldown |
| Galochas | Velocidade de movimento +10%/+10%/+20% | +40% |
| Ímã de Geladeira | Raio de coleta +20%/+30%, nível 3 = coleta automática da tela toda a cada 15s | — |

*(Os dados guardam o **ganho de cada nível**, não o total acumulado — fundir só soma em cima, nunca precisa desfazer o efeito anterior.)*

### 3.6 Inimigos

| Arquétipo | Comportamento | Papel |
|---|---|---|
| Pulgão Corredor | Persegue rápido, pouco HP | Pressão constante |
| Lesma Tanque | Persegue devagar, muito HP | Obstáculo |
| Gafanhoto Saltador | Avança em pulos curtos | Quebra o ritmo |
| Mosca Atiradora | Mantém distância, atira | Ameaça à distância |

### 3.7 Bosses (3, sorteado 1 por run)

| Boss | Comportamento |
|---|---|
| Lagarta Titã | Bruto: só persegue e bate forte por contato |
| Rainha das Moscas | Mantém distância e solta rajadas de projéteis |
| Gafanhoto Gigante | Pula e causa dano em área ao pousar perto do jogador |

### 3.8 Curva de dificuldade
- Frequência de spawn sobe de 2,0s para 0,6s ao longo da run (`spawn_interval_start/min`).
- **HP e dano de todo inimigo escalam continuamente com o tempo de run** (+35% a cada 30s, sem teto) — é o que evita que os inimigos "fiquem fracos" depois de um tempo, acompanhando o crescimento do jogador.
- Arquétipos são liberados aos poucos: Lesma aos 30s, Gafanhoto aos 90s, Mosca aos 150s.
- Boss aparece uma vez, no tempo definido por `boss_time` (padrão 300s = 5min, configurável no Inspector do `EnemySpawner`).
- Teto de inimigos simultâneos (`max_active_enemies`, padrão 100) protege a performance.

### 3.9 Mapas
- 3 mapas (Horta, Celeiro, Pomar ao Entardecer), sorteado 1 por run.
- **Estado atual:** só trocam a cor de fundo e mostram o nome no HUD — ainda não têm tilemap/arte de terreno de verdade (estrutura já pronta pra isso, só falta o `TileMap`).

### 3.10 Meta-progressão
- **Moeda permanente** salva em `user://save_data.json`, sobrevive entre sessões.
- **Hub** (tela inicial): mostra moeda, permite escolher/desbloquear personagem e comprar upgrades permanentes.
- **3 personagens:**

| Personagem | Trade-off | Arma inicial |
|---|---|---|
| Fazendeiro Clássico | Nenhum (grátis) | Foice |
| Vovó Resistente | +30 vida, -15% velocidade | Motosserra |
| Netinho Ágil | +20% velocidade, -15 vida | Milho-Metralhadora |

- **Upgrades permanentes da fazenda** (até 3 níveis cada): Celeiro Reforçado (+vida), Adubo Premium (+dano), Botas do Vovô (+velocidade). Aplicados automaticamente no início de toda run.
- **Ao morrer:** ganha moedas com base em tempo de sobrevivência + nível alcançado, vê uma tela mínima de resultado, volta pro Hub.

### 3.11 HUD
- Barra de vida com moldura de madeira (arte real), atualizada por polling a cada frame.
- Nome do mapa no canto superior direito.
- **Falta:** barra de XP visível (asset já processado, não integrado).

---

## 4. Estado da Arte Visual

### 4.1 Já integrados no jogo
Personagem (idle + andando animados), Lesma Tanque, Gafanhoto Saltador, boss Lagarta Titã, ícones de Foice/Motosserra/Forquilha (aparecem no personagem), projéteis de Milho/Batata/Mamona, moldura da barra de vida.

### 4.2 Prontos, aguardando integração
Bezerro (andando/ataque), efeito de ataque da Cerca Elétrica, variações de nível 2/3 de Foice/Forquilha/Motosserra/Mamona, efeito de morte genérico, morte do personagem, ícones de moeda, moldura de carta de level-up, base do joystick, moldura da barra de XP.

### 4.3 Precisam de reexportação (fundo não saiu limpo)
Bezerro (base e nível 2/3), Cerca Elétrica (ícone e nível 2/3), Pulgão Corredor (vivo e morte), Espantalho de Bolso, Galochas, bosses Rainha das Moscas e Gafanhoto Gigante, Foice nível 3 e efeito de ataque (parcial).

### 4.4 Têm texto/legenda desenhado dentro da imagem
Milho-Metralhadora nível 2/3, Canhão de Batata (composição completa) — precisam ser recortados sem o texto.

### 4.5 Sprites que ainda não existem
Mosca Atiradora comum (só existe a versão boss), Vovó Resistente, Netinho Ágil, ícones dos 3 upgrades da fazenda, orbe de XP com arte própria.

*(Detalhe completo arquivo por arquivo: `RELATORIO_SPRITES.md`, já entregue anteriormente.)*

### 4.6 Texturas de mapa
Grama, terra/caminho, decorações de Horta/Celeiro/Pomar — prontas, opacas, só faltam entrar como `TileMap`/`TextureRect` em vez da cor sólida atual.

---

## 5. Arquitetura Técnica

### 5.1 Padrão geral: dados + dispatch
Quase todo sistema (armas, passivos, inimigos, personagens, upgrades, mapas) segue o mesmo padrão:
1. Uma tabela de dados num **autoload** (`WeaponDB`, `PassiveDB`, `EnemyDB`, `CharacterDB`, `FarmUpgradeDB`, `MapDB`).
2. Um campo (`kind`/`behavior`) que diz qual script/cena usar.
3. Um dicionário de cenas (`WEAPON_SCENES`, `WEAPON_SCENES` por comportamento) que resolve qual instanciar.

Isso significa que **adicionar conteúdo novo raramente exige lógica nova** — na maioria das vezes é só uma entrada a mais na tabela.

### 5.2 Autoloads (singletons globais)
`WeaponDB`, `PassiveDB`, `EnemyDB`, `MapDB`, `SaveManager`, `CharacterDB`, `FarmUpgradeDB`.

### 5.3 Cenas principais
- `hub.tscn` — tela inicial (cena principal do projeto)
- `main.tscn` — a run em si (personagem, spawner, HUD, level-up UI, fundo do mapa)
- `player.tscn`, `enemy.tscn`, `projectile.tscn`, `enemy_projectile.tscn`, `xp_orb.tscn`, `companion.tscn`, `trap.tscn`
- Uma cena por tipo de arma: `weapon.tscn`, `melee_swing_weapon.tscn`, `melee_aura_weapon.tscn`, `melee_stab_weapon.tscn`, `summon_weapon.tscn`, `trap_weapon.tscn`

### 5.4 Decisões técnicas importantes
- **`call_deferred`** usado ao instanciar nós físicos dentro de callbacks de colisão (evita o erro "flushing queries" do motor de física).
- **Detecção de colisão sempre ligada** (em vez de ligar/desligar em tempo real) — mais robusto contra timing de física.
- **Multiplicador de dificuldade** passado por parâmetro (`configure(id, difficulty_multiplier)`), não hardcoded.
- **Object pooling ainda não implementado** — inimigos/projéteis são instanciados e destruídos normalmente. Vira prioridade se a performance cair em teste real com muitos inimigos na tela.

---

## 6. Pendências Conhecidas (próximos passos possíveis)

- 🔲 **Áudio** — nenhum som/música implementado ainda.
- 🔲 **Tela de fim de run polida** — hoje é só texto + 1 botão; falta retry direto, estatísticas (kills, dano causado), talvez replay do build.
- 🔲 **Menu de pausa** — não existe ainda durante a run.
- 🔲 **Arte pendente** — ver seção 4.
- 🔲 **Barra de XP no HUD** — asset pronto, não conectado.
- 🔲 **Mapas com tilemap de verdade** — hoje é só cor sólida de fundo.
- 🔲 **Object pooling** — otimização de performance pra quando houver muitos inimigos/projéteis.
- 🔲 **Monetização** — AdMob (anúncio recompensado) e Google Play Billing (cosméticos) ainda não integrados.
- 🔲 **Teste em dispositivo Android real** — todo o desenvolvimento até aqui foi testado no editor/PC.
- 🔲 **Publicação** — conta no Google Play Console, ficha da loja, política de privacidade.

---

## 7. Histórico de Versões (resumo)

| Versão | O que trouxe |
|---|---|
| v1-v3 | Joystick, movimento, combate básico, correções de bugs de física |
| v4 | Arsenal completo: 8 armas com sistema `kind`/dispatch |
| v5 | 5 itens passivos com fusão |
| v6 | 4 arquétipos de inimigo, curva de dificuldade inicial, HUD (barra de vida) |
| v7 | Balanceamento (escalonamento contínuo de dificuldade), 3 bosses, 3 mapas, câmera |
| v8 | Meta-progressão completa: Hub, 3 personagens, upgrades permanentes, save em arquivo |
| v9 | Rebalanceamento de armas corpo a corpo (alcances, Foice em pulso, Batata com splash) |
| v10 | Correção definitiva da Foice, primeira leva de arte real integrada |

---

## 8. Resumo em uma frase por sistema

- **Movimento:** joystick virtual + flip horizontal.
- **Combate:** automático, 8 armas orientadas a dados, cada uma com sua mecânica.
- **Progressão de run:** XP → level-up pausado → 3 cartas → fusão automática.
- **Progressão permanente:** moeda salva em arquivo → Hub → personagens e upgrades.
- **Dificuldade:** cresce sem teto, continuamente, pra sempre acompanhar o jogador.
- **Variedade:** 4 inimigos comuns + 3 bosses sorteados + 3 mapas sorteados.
- **Arte:** cerca de um terço já integrado com sprites reais; resto em placeholder ou pendente de correção/criação.
