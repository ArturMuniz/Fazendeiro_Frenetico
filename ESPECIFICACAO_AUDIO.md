# Especificação de Áudio — O Fazendeiro Frenético
### v2 — atualizado com técnicas de game juice e psicoacústica

Documento de referência pra recriar todos os sons do jogo com uma IA de áudio profissional (ElevenLabs Sound Effects, Suno v4, Udio, AIVA) ou com um sound designer. Os arquivos atuais (`/audio/*.wav`) foram regerados por síntese aplicando as técnicas descritas aqui — já são um placeholder bem mais "gostoso" de ouvir que a primeira leva, mas continuam sendo placeholder, não arte final.

**13 sons no total**: 10 efeitos da leva anterior (refinados) + 3 novos (fusão, aviso de boss, compra) que fecham lacunas reais de feedback do jogo.

---

## 1. Princípios de game juice aplicados

- **Sons de altíssima repetição** (`hit`, `pickup`) ficam entre **0,05–0,10s**, com decay quase zero — nada de cauda longa, porque toda vez que se acumula no buffer com dezenas de instâncias por segundo, mascara o resto do áudio e cansa o ouvido.
- **Variação de pitch aleatória** (±5-8%) em todo som tocado — já implementada no `AudioManager.play_sfx()` — evita o "efeito metralhadora" de ouvir o mesmo som idêntico repetido sem parar.
- **Separação espectral**: dano fica nos médios-graves (200-500Hz), coleta fica nos agudos (2-8kHz) — dois sons que tocam quase juntos (hit + pickup) não competem pela mesma faixa de frequência.
- **Sistema de prioridade no pool de áudio** (novo — ver seção 4): um clique de botão nunca corta o jingle de level-up; o inverso sim.
- **Morte de boss em 3 fases**: impacto seco → acorde de vitória → cauda de sub-grave (40-80Hz) — dá peso dramático ao momento mais importante do jogo.

---

## 2. Tabela completa de efeitos sonoros

| Arquivo | Gatilho no jogo | Duração alvo | Frequência de disparo | Prioridade |
|---|---|---|---|---|
| `sfx_attack_melee.wav` | Foice arremessa, Forquilha acerta, Motosserra/Bezerro acertam | 0,10–0,20s | Média/Alta | Média |
| `sfx_attack_ranged.wav` | Milho, Batata, Mamona disparam; Cerca choca | 0,08–0,15s | Alta | Média |
| `sfx_hit.wav` | Qualquer dano em inimigo (o mais tocado do jogo) | 0,05–0,10s | Extrema | **Alta** |
| `sfx_enemy_death.wav` | Morte de inimigo comum | 0,15–0,30s | Alta | Média |
| `sfx_boss_death.wav` | Morte de boss | 0,60–1,00s | Baixa (1x/run) | **Crítica** |
| `sfx_boss_spawn.wav` 🆕 | Boss aparece na arena | 0,6–0,8s | Baixa (1x/run) | **Crítica** |
| `sfx_level_up.wav` | Cartas de upgrade abrem | 0,30–0,50s | Baixa/Média | **Crítica** |
| `sfx_fusion.wav` 🆕 | Arma/passivo funde pro próximo nível | 0,30–0,40s | Média | Alta |
| `sfx_pickup.wav` | Coleta de orbe de XP | 0,05–0,10s | Extrema | **Alta** |
| `sfx_player_hurt.wav` | Jogador toma dano | 0,15–0,25s | Média | Alta |
| `sfx_purchase.wav` 🆕 | Compra/desbloqueio confirmado no Hub | 0,20–0,25s | Baixa | Média |
| `sfx_button.wav` | Clique de UI (inclui tentativa sem fundos) | 0,03–0,06s | Média | Baixa |
| `sfx_game_over.wav` | Jogador morre | 0,80–1,20s | Múltipla (1x/run) | **Crítica** |

🆕 = adicionado nesta revisão — são momentos do jogo que **não tinham nenhum som antes**: fundir uma arma (um dos momentos mais satisfatórios do loop de progressão!), o boss aparecendo, e uma compra confirmada no Hub.

---

## 3. Música de fundo

| Arquivo | Onde toca | Duração/loop | Andamento | Caráter |
|---|---|---|---|---|
| `music_hub.wav` | Tela do Hub | 30–90s, loop com crossfade | 90–110 BPM | Calmo, acolhedor, rural (violão/banjo/harmônica) |
| `music_gameplay.wav` | Durante a run | 60–120s, loop com crossfade | 130–150 BPM | Energético, rítmico, sustenta tensão sem virar terror |

**Sobre o loop:** os arquivos atuais já usam crossfade de potência constante no ponto de emenda (mistura os últimos ~0,3s com os primeiros ~0,3s antes de exportar), técnica padrão de DAW pra sumir com o clique perceptível quando a faixa reinicia. Se regerar com IA, aplique a mesma técnica no Audacity/DAW antes de importar.

---

## 4. Sistema de prioridade do pool de áudio (novo)

O `AudioManager` tem 8 canais simultâneos (`AudioStreamPlayer`). Quando todos estão ocupados e um som novo precisa tocar, ele só "rouba" o canal do som de **menor prioridade** em execução — e só se for igual ou mais importante que ele. Isso evita que, numa run caótica com dezenas de hits por segundo, um evento importante (boss morrendo, level up) seja cortado por um som trivial.

| Prioridade | Sons | Comportamento |
|---|---|---|
| **Crítica (3)** | `boss_death`, `boss_spawn`, `level_up`, `game_over` | Quase nunca são cortados — só por outro som crítico |
| **Alta (2)** | `hit`, `pickup`, `player_hurt`, `fusion` | Cortam sons médios/baixos se precisar |
| **Média (1)** | `attack_melee`, `attack_ranged`, `enemy_death`, `purchase` | Cortam só sons de baixa prioridade |
| **Baixa (0)** | `button` | Primeiro a ser cortado quando o pool lota |

---

## 5. Prompts prontos pra IA de áudio

### ElevenLabs Sound Effects (efeitos pontuais)

| Arquivo | Prompt |
|---|---|
| `sfx_attack_melee.wav` | *Fast sharp pitchfork swoosh cutting through dry corn stalks, meaty organic impact, close mic, dry studio room, no reverb, duration 0.15 seconds* |
| `sfx_attack_ranged.wav` | *Cartoonish compressed air pop, toy potato cannon shoot, short suction release, funny light thud, dry clean recording, duration 0.10 seconds* |
| `sfx_hit.wav` | *Short crispy organic wood block click, dry vegetable slap, instant attack, high clarity, zero decay, tiny thump, duration 0.08 seconds* |
| `sfx_enemy_death.wav` | *Cute cartoon bubble pop, soft mud squish poof, comedic bug squish, clean isolated transient, duration 0.20 seconds* |
| `sfx_boss_death.wav` | *Comedic victory explosion, cartoon fireworks pop, low pitch bass boom, celebratory fanfare chord, organic crash, duration 0.8 seconds* |
| `sfx_boss_spawn.wav` | *Ominous but comedic low horn stab, three-note warning motif, cartoon danger sting, sub-bass thump on final note, duration 0.7 seconds* |
| `sfx_level_up.wav` | *Bright major chord arpeggio, ascending acoustic chime jingle, upbeat level up fanfare, crisp high frequency shine, duration 0.4 seconds* |
| `sfx_fusion.wav` | *Magical ascending whoosh into a bright sparkling chord, power-up merge sound, crystalline shimmer, satisfying upgrade confirmation, duration 0.35 seconds* |
| `sfx_pickup.wav` | *High pitched metallic coin blip, crystal gem collect sound, short resonant chime, instant bright pop, duration 0.08 seconds* |
| `sfx_player_hurt.wav` | *Funny short grunt groan, subtle dissonant wood break, light comical punch, quick grunt, duration 0.20 seconds* |
| `sfx_purchase.wav` | *Satisfying two-note cha-ching coin purchase confirmation, bright ascending chime, cash register style but cartoonish, duration 0.22 seconds* |
| `sfx_button.wav` | *Subtle clean plastic UI button click, soft mechanical tap, minimal low end, dry tactile click, duration 0.05 seconds* |
| `sfx_game_over.wav` | *Descending funny trombone slide, comedic fail jingle, short sad country banjo pluck, descending minor pitch, duration 1.0 second* |

### Suno v4 / Udio (música — Custom Mode, Instrumental ligado)

**`music_hub.wav`**
- Style: *Cozy rural country folk, 100 BPM, warm acoustic guitar fingerpicking, casual banjo accompaniment, soft harmonica lead, bright major key, peaceful farm village vibe, clean mix*
- Structure: `[Intro: Fingerpicking guitar] [Theme: Banjo melody] [Bridge: Harmonica] [Outro: Smooth fade]`

**`music_gameplay.wav`**
- Style: *Fast energetic bluegrass country rock hybrid, 140 BPM, driving fast banjo roll, rhythm acoustic guitar strumming, punchy upbeat drums, game combat loop, seamless arrangement*
- Structure: `[Intro: Fast banjo roll] [A-Section: High energy bluegrass] [B-Section: Upbeat rhythm] [Loop: Seamless]`

---

## 6. Checklist de pós-processamento em DAW (Audacity ou similar)

Antes de importar qualquer áudio gerado por IA pro projeto:

1. **Converter pra Mono** — o jogo é 2D simples e toca muitos sons ao mesmo tempo; estéreo desperdiça RAM e pode causar cancelamento de fase em alto-falante único de celular.
2. **Normalizar o pico em -3,0 dBFS** em todos os SFX — garante volume equilibrado entre um som fraco (clique de botão) e um forte (morte de boss) antes mesmo do `AudioManager` aplicar o volume geral.
3. **Cortar silêncio/ruído nas pontas** — qualquer milissegundo de silêncio antes do som começar atrapalha a sensação de resposta instantânea, especialmente em `hit` e `pickup`.
4. **Loop de música**: identificar o ponto de corte num cruzamento por zero (zero-crossing), pegar os últimos ~0,5s e sobrepor com crossfade de potência constante nos primeiros ~0,5s, exportar só até esse ponto.
5. **EQ leve pra separar do resto**: reforçar 4-8kHz em `pickup`/`level_up` (brilho), manter `hit` focado em 200-500Hz (corpo seco), aplicar high-pass em 40Hz na música de fundo pra não competir com o sub-grave do `boss_death`.

---

## 7. Configuração de importação no Godot 4

| Categoria | Formato | Canais | Loop Mode | Estratégia |
|---|---|---|---|---|
| SFX | `.wav` | Mono | Disabled | Descomprimido em RAM, disparo com latência zero |
| Música | `.wav` (ou `.ogg` na build final, menor) | Mono/Estéreo | Forward | Stream contínuo, baixo custo de CPU/RAM |

No painel de importação (aba "Import" ao selecionar o arquivo no FileSystem): ative **Force Mono** se o arquivo fonte vier em estéreo, e para música defina **Loop Mode = Forward**.

---

## 8. Como trocar os arquivos depois

1. Gere os sons/músicas com a IA escolhida, seguindo os prompts da seção 5.
2. Trate em DAW seguindo o checklist da seção 6.
3. Salve com **exatamente os mesmos nomes** da tabela da seção 2/3 dentro de `/audio`, substituindo os placeholders.
4. Nenhum script precisa mudar — `audio_manager.gd` já referencia esses caminhos e prioridades. Só reimportar o projeto no Godot.

---

## 9. Ideias de "juice" pra além do áudio (não implementadas ainda)

O material de referência trouxe duas técnicas de *game feel* que complementam o áudio mas são código de gameplay, não arquivo de som — deixo documentado caso queira implementar depois:

- **Hit-stop**: pausar o jogo por 3-5 frames (Engine.time_scale bem baixo por um instante) no exato momento de um hit importante, sincronizado com `sfx_hit`. Dá sensação de "resistência física" ao golpe. Recomendo aplicar só em hits fortes (boss, crítico) pra não deixar o combate comum truncado.
- **Screen shake**: tremor de câmera curto ao matar um boss, sincronizado com `sfx_boss_death` e o sub-grave de 40-80Hz — o abalo visual reforça o peso do som.
