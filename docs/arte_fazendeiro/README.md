# Fazendeiro animado — 18/10/2026

> Estudo anterior preservado para comparação. Esta família de 64 quadros foi substituída no jogo pela [versão baseada nos anexos originais, com 38 quadros](../arte_fazendeiro_fiel/README.md). Os resultados e descrições abaixo pertencem à versão anterior.

Reconstrução dos sprites do Fazendeiro Clássico no Aseprite AI Artist, com camadas e poses próprias. Mantidos chapéu marrom, camisa xadrez azul, jeans, botas e rosto jovem sem barba. A paleta foi reduzida a 28 cores visíveis para manter contornos e cores estáveis entre poses.

## Ver as animações

Os GIFs abaixo são prévias ampliadas em 3×. A repetição do visualizador de GIF não define o loop do jogo; morte e gestos são estados de execução única no Godot.

| Animação | Quadros | Duração base | Prévia | Fonte editável |
|---|---:|---:|---|---|
| Respirar e piscar | 8 | 1,40 s | [Idle](previas/idle/idle.gif) | [Aseprite](fontes/fazendeiro_idle.aseprite) |
| Andar | 8 | 0,73 s | [Caminhada](previas/walk/walk.gif) | [Aseprite](fontes/fazendeiro_walk.aseprite) |
| Correr | 8 | 0,53 s | [Corrida](previas/run/run.gif) | [Aseprite](fontes/fazendeiro_run.aseprite) |
| Ajeitar o chapéu | 14 | 1,20 s | [Chapéu](previas/idle_hat/idle_hat.gif) | [Aseprite](fontes/fazendeiro_idle_hat.aseprite) |
| Espantar mosquinha | 14 | 1,09 s | [Mosquinha](previas/idle_swat/idle_swat.gif) | [Aseprite](fontes/fazendeiro_idle_swat.aseprite) |
| Cair e perder o chapéu | 12 | 0,84 s | [Morte](previas/death/death.gif) | [Aseprite](fontes/fazendeiro_death.aseprite) |

Cada pasta de prévia também contém a prancha de todos os quadros, a spritesheet, o atlas JSON e o relatório do verificador do Aseprite. As nove camadas dos fontes são sombra, pernas, braços, tronco, cabeça, chapéu e efeitos.

## Experimentar no jogo

1. Abrir o projeto no Godot 4.7.2 e iniciar pelo Hub.
2. Selecionar o Fazendeiro Clássico e iniciar uma partida.
3. Mover pouco o joystick para caminhar. Acima de 80% de intensidade, entra a corrida visual; ela volta à caminhada abaixo de 62%, evitando alternância instável na fronteira.
4. Soltar o joystick: o personagem respira e pisca. Depois de 3,5 s parado, ajeita o chapéu. Os gestos seguintes alternam com a mosquinha; após um gesto completo, o intervalo é de 5 s.
5. Voltar a mover ou sofrer dano durante o gesto: a ação de descanso é interrompida imediatamente. As armas continuam funcionando normalmente enquanto o personagem está parado.

A velocidade máxima permanece igual à versão anterior. A intensidade do joystick já controlava a velocidade de movimento; agora também escolhe a animação. A cadência dos passos acompanha a velocidade real, dentro de limites visuais. Colisão e atributos de combate não foram alterados.

## Integração

- PNGs de runtime: `art/fazendeiro_animado/`, 64 arquivos de 128×128, RGBA com alpha 0/255 e margens transparentes.
- Pés alinhados em (64,96); offset de runtime (0,-16), compatível com a ancoragem anterior.
- `farmer_art_data.gd` guarda caminhos, duração por quadro e loop. `GameArt.actor()` seleciona essa família apenas para o Fazendeiro.
- `SpriteAnimator` aceita `durations_ms` e `playback_speed`; famílias antigas preservam a leitura por FPS.
- `Player` controla andar/correr, intervalo e interrupção dos gestos. A morte tem prioridade e segura a última pose.
- Na derrota, o gameplay pausa imediatamente; só a apresentação de morte continua até revelar o resultado. O crédito de recompensas não depende do final da animação.
- Fontes anteriores em `art/polished/` preservados como referência. A geração antiga não apaga a nova família, que fica em uma pasta própria.

## Validação e limites

**322 verificações Godot passaram:** 47 novas de animação, 78 de estabilidade, 121 de UI e 76 de arte. Os testes cobrem joystick parcial/cheio, histerese, duração por quadro, pausa, interrupções, conclusão única da morte, partidas consecutivas e preservação dos outros personagens.

Os 64 PNGs foram conferidos: canvas constante, nenhuma semitransparência e nenhum pixel opaco encostado na borda do arquivo. Ver [validação dos PNGs](validacao_png.json).

Foram capturadas cinco telas com o renderizador real do Godot em Windows/D3D12: repouso, corrida, chapéu, morte e resultados. Os arquivos em `capturas/` são cenas de verificação, sem simulação normal de inimigos; não são trailer de gameplay.

A revisão visual independente deu **7,5/10**, sem achado impeditivo. Reconheceu o personagem e as seis ações. Compromissos mantidos: vista predominantemente frontal em três quartos; cruzamento de pernas um pouco denso em algumas poses; queda relativamente rígida, usada como comédia. Uma perspectiva mais superior pode ser estudada em outra rodada, se essa for a direção do restante do elenco.

O verificador completo do Aseprite não encontrou erros, mas emitiu **226 avisos de contorno por camada/quadro**, além de notas sobre camadas de efeitos vazias e contornos. Eles foram mantidos nesta versão: o desenho usa junções entre partes sobrepostas e alguns contornos coloridos. A revisão do composto não os classificou como impeditivos; não foi aplicada uma conversão automática de todas as bordas para preto. Os relatórios completos estão nas pastas de prévia.

Ainda não foi feita uma rodada em Android físico. Esta entrega testa o fluxo Aseprite → PNG/atlas → Godot; Stipple Effect e Bitmapflow não foram usados para fabricar estes quadros.

## Reproduzir a exportação

No ambiente local preparado, a partir da raiz do workspace:

```powershell
node .\sprite-tools\aseprite-ai-artist\build-farmer.mjs
node .\sprite-tools\aseprite-ai-artist\validate-farmer.mjs
```

Depois, na pasta do jogo:

```powershell
python .\tools\install_farmer_animation.py --source ..\sprite-tools\fazendeiro-animation
```

O importador apenas confere e copia as imagens; não redimensiona nem redesenha pixels. O desenho é feito no Aseprite pelo MCP, usando as poses em `farmer-design.mjs`. Cópias dos scripts estão em `fontes/`; eles dependem da instalação local documentada em `sprite-tools/README.md`. O código-fonte `.aseprite` é a opção direta para edição manual.

## Executar os testes novos

```text
Godot --headless --audio-driver Dummy --path . --script res://tests/farmer_animation_suite.gd
Godot --audio-driver Dummy --path . --script res://tests/farmer_visual_smoke.gd
```

O segundo comando exige renderização gráfica. Os saves de teste ficam em `tests/.tmp/`, separados do save de jogador.
