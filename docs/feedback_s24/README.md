# Ajustes após o teste no Galaxy S24+

Implementação: 18–19/10/2026. Build: **0.24.2-teste**, código Android **25**.

[Download da versão de teste e APK no GitHub](https://github.com/ArturMuniz/Fazendeiro_Frenetico/releases/tag/v0.24.2-teste).

APK local: `builds/Fazendeiro_Frenetico_S24_v0.24.2_Teste.apk` (103.881.270 bytes). SHA-256: `c437ab1b99594534ecd86193c3983c286cc7fc02021a1376d6728cb296818d59`. Integridade ZIP/CRC, assinatura v2, ARM64 exclusivo, IDs de teste e ausência de documentação/testes no APK verificados. O certificado coincide com o APK anterior, permitindo atualização sem desinstalar. A versão nova ainda não foi executada no aparelho nesta entrega.

Este pacote implementa o feedback do Artur sobre controle, cenários repetidos, falta de encontros intermediários, excesso de armas e pouca variedade de melhorias. Decisões confirmadas: **construções nas bordas, centro livre; três armas fixas por run, permitindo apenas evoluir as escolhidas**.

## O que mudou

| Frente | Comportamento implementado |
|---|---|
| Joystick | Raio de referência de 60 → 96 unidades; indicador proporcional; centro afastado das duas bordas; curso completo do dedo dentro da área segura; zona morta de 8% |
| Construções | Uma construção principal por mapa e quatro cercas curtas em posições fixas periféricas. Casas e cercas não são mais replicadas pelas parcelas do chão |
| Centro | Nenhuma colisão arquitetônica na clareira de 800 × 1.200 unidades. Canteiros e decoração baixa continuam atravessáveis |
| Colisões periféricas | Paredes e base das cercas bloqueiam jogador, inimigos, companheiro e projéteis diretos. Há grandes passagens entre as cercas e não existe fechamento completo da arena |
| Navegação | Inimigos e bezerro usam desvios ao redor dos marcos; atiradores buscam passagem quando uma construção bloqueia a linha até o jogador |
| Encontros | Até um líder por fase, com aviso de 1,8 s, escolta de até quatro inimigos, coroa/anel e vida no HUD |
| Armas | Máximo de três tipos, incluindo a arma inicial do personagem. Arma repetida evolui até nível 3; uma quarta arma é recusada também na lógica do inventário |
| Cartas | Havendo opções válidas, cada rodada oferece uma arma, um passivo e um atributo. Com três armas, só aparecem evoluções das equipadas; com todas no máximo, entram outras melhorias |
| Itens | O catálogo passou de cinco para oito passivos. O limite continua sendo seis passivos por run |
| Atributos | Regeneração, XP adicional, defesa e coleta também entram nas cartas; regeneração e XP aparecem nos atributos da pausa |
| Checkpoint | Restaura os novos atributos, líderes e avisos pendentes. A metade correta é 171 s numa campanha de 342 s até a chegada do chefe |

## Ergonomia do joystick

`TouchJoystick.geometry()` calcula raio, tamanho do indicador e centro a partir da área segura da tela. Em 720 unidades de largura, o raio é 96 e o indicador tem 76,8 de largura. A margem considera **raio de deslocamento + metade do indicador**, para que o botão continue visível mesmo quando totalmente puxado para baixo ou para a esquerda.

A área segura física do Android é convertida para as coordenadas lógicas do viewport. O layout é recalculado em redimensionamentos, zerando a entrada anterior. O primeiro dedo mantém a propriedade do controle; soltar outro dedo não interrompe o movimento. Pausa e perda de foco continuam limpando a entrada.

O teste automatizado usa a proporção 720 × 1.560, correspondente a 1440 × 3120 ou 1080 × 2340, além de telas menores e orientação horizontal. A avaliação de conforto continua dependendo do novo teste no aparelho.

## Cenário e arquitetura

- `farm_landscape_chunk.gd`: chão e decoração baixa, determinísticos e com cache limitado. Não contém corpos de construções.
- `farm_landmarks.gd`: marcos únicos, desenhados separadamente, com shapes próprios. A construção principal fica a noroeste; as cercas ficam ao norte/sul com passagens largas.
- `farm_obstacles.gd`: grafo de visibilidade entre cantos dos obstáculos, com margem de 36 unidades. As conexões estáticas são preparadas uma vez; os pontos de início/destino são temporários.
- Jogador, inimigos e companheiro passam a consultar a camada 4 de física (valor 8), além da camada anterior. As hitboxes de combate conservam a configuração anterior.
- Inimigos e companheiro renovam a direção de navegação a cada 0,35 s ou ao alcançar/mudar o destino. O surgimento evita footprints com margem de 40 unidades.

Não foi criada uma parede em torno de toda a fase: o jogador pode atravessar as passagens e continuar se deslocando. Os marcos ficam nas bordas **da clareira inicial**, em coordenadas fixas do mundo; não acompanham o jogador nem se repetem ao caminhar longe.

Ataques em área e armas corpo a corpo mantêm suas regras de alcance. O bloqueio de projéteis diretos por paredes funciona nos dois lados. Árvores, canteiros e os demais elementos decorativos continuam sem colisão; este pacote resolve a arquitetura de casas/cercas sem transformar todo elemento visual em obstáculo.

## Líderes de horda

O encontro começa a partir de 60% do tempo de cada fase. A agenda respeita as três fases e os respiros existentes, sem mudar os intervalos normais de spawn.

| Fase | Aviso no relógio da run | Primeiro surgimento possível |
|---|---:|---:|
| 1 | 60 s | 61,8 s |
| 2 | 170 s | 171,8 s |
| 3 | 290 s | 291,8 s |

Esses tempos são de gameplay, excluindo menus/anúncios. Dependem das durações atuais de 100/110/120 s e respiros de 4 s. Se um líder anterior ainda estiver vivo, o próximo aguarda enquanto a fase atual durar; o sistema evita acumular líderes novos. Se a fase terminar, um aviso pendente é cancelado. O chefe final continua chegando pela agenda da campanha.

O líder usa o último arquétipo disponível na fase. Na Horta: Pulgão → Lesma → Gafanhoto. Nos outros mapas a composição acompanha a tabela de arquétipos existente.

Parâmetros iniciais, sujeitos a playtest:

- Vida: `max(vida_base × 5, 50) × dificuldade_da_fase`.
- Dano de contato: ×1,15; movimento: ×1,08; sprite e raios de colisão: ×1,25.
- XP do líder: `XP_base × 5 + 5`; mantém o bônus de XP do jogador na coleta.
- Escolta: até quatro inimigos normais; o limite total de inimigos continua valendo.
- Recompensa: uma melhoria garantida por morte, além do XP que pode gerar níveis normalmente.
- A morte de um líder não conclui o mapa, não paga bônus de chefe e não abre a vitória.

O estado de líder é um parâmetro explícito de `Enemy.configure()`, separado do ID do chefe. A reutilização no pool apaga marcação, escala, vida extra, navegação e referência anterior de alvo. Não foram criadas novas famílias de sprite: a apresentação usa os sprites originais animados e sinais geométricos no renderizador.

## Itens e atributos novos

Os níveis são incrementais; a coluna final mostra o total após três escolhas do mesmo item.

| Item | Nível 1 | Ganho no nível 2 | Ganho no nível 3 | Total no nível 3 |
|---|---:|---:|---:|---:|
| Queijo Curado | +0,4 vida/s | +0,4 vida/s | +0,7 vida/s | +1,5 vida/s |
| Caderno da Roça | +10% de XP | +10% de XP | +15% de XP | +35% de XP |
| Pedra de Amolar | +1 de dano por acerto | +2 | +3 | +6 por acerto |

As cartas de atributo adicionais oferecem +0,25 vida/s, +5% de XP, +5 pontos percentuais de defesa ou +20 de raio de coleta. A defesa tem teto de 75% para impedir imunidade pelo empilhamento de cartas; melhorias sem efeito nesse teto e no piso de intervalo ×0,25 são retiradas da oferta.

A regeneração usa o delta da simulação, congela na pausa e não excede a vida máxima. O bônus de XP é aplicado uma única vez na coleta. Os números aparecem antes/depois nas cartas e são restaurados pelo checkpoint.

As três armas ocupam posições fixas; não existe substituição nesta versão. Há preferência de 65% pelas evoluções disponíveis da própria build enquanto ainda há espaço para armas novas. Essa preferência não impede novas escolhas; depois da terceira arma, os outros tipos saem completamente da oferta.

Os itens novos reaproveitam **ícones de atributo/XP aprovados**, sem artes exclusivas de queijo, caderno e pedra. Essas ilustrações próprias permanecem pendentes; o nome e a descrição informam o efeito real.

## Validação

| Suíte | Verificações | Falhas |
|---|---:|---:|
| Controle, pausa, pool e campanhas | 78 | 0 |
| Interface, números e passivos | 142 | 0 |
| Mapas e streaming | 80 | 0 |
| Monetização e checkpoint | 50 | 0 |
| Feedback S24: controles, armas, líderes, atributos, colisões e rotas | 68 | 0 |
| Polimento de atores | 18 | 0 |
| Fazendeiro | 45 | 0 |
| Vovó | 37 | 0 |
| Arte e integração de atores | 76 | 0 |
| **Total** | **594** | **0** |

A suíte específica verifica 200 sorteios de cartas, 100 posições de surgimento em cada mapa, deslocamento real do jogador contra a parede e perseguição real contornando a construção nos três mapas. Inclui líderes em limite de população, reset no pool, morte idempotente e restauração do checkpoint sem multiplicar vida novamente.

Foram renderizadas e inspecionadas 12 capturas em Windows/OpenGL, em `telas/`: clareira, visão das bordas e construção de cada mapa, líder/equipamentos, pausa e cartas. Isso verifica a composição no renderizador do PC; não substitui a medição de FPS, temperatura, ergonomia ou anúncios no Android. Os logs das nove suítes, renderização e exportação estão em `testes/`.

Para executar a suíte nova, na raiz do projeto:

```powershell
& 'CAMINHO/Godot_v4.7.2-stable_win64_console.exe' --headless --path . --script res://tests/s24_feedback_suite.gd
```

## Próximo teste no S24+

1. Atualizar pelo APK 0.24.2 sem desinstalar a versão anterior.
2. Puxar o joystick nos oito sentidos e testar junto de um segundo dedo tocando em Pausa.
3. Alcançar a terceira arma, conferir ausência de armas novas e concluir suas evoluções.
4. Observar os líderes das três fases: o aviso é legível? Há tempo para reação? O encontro dura pouco ou demais?
5. Circular perto do galpão/celeiro e atravessar os espaços entre cercas; conferir perseguição e tiros nas paredes.
6. Testar uma morte após a metade: retornar deve recuperar build, novos atributos e o encontro daquele checkpoint.
7. Fazer três runs consecutivas, observando dificuldade, legibilidade e aquecimento.

O balanceamento final permanece aberto: reduzir seis armas para três muda bastante o poder da build. Os valores-base das armas, personagens e intervalos normais de inimigos foram preservados para separar esse efeito dos encontros novos. A proposta de ciclos de pressão de 40 s continua sendo um experimento futuro, não uma funcionalidade já ativa.
