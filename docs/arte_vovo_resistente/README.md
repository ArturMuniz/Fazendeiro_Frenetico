# Vovó Resistente — 18/10/2026

Nova família visual integrada para a personagem `vovo`, baseada nos três anexos do usuário. Mantidos rosto idoso com óculos redondos, cabelo branco, chapéu amarelo com faixa vermelha, roupa mostarda, avental verde florido, luvas marrons e botas verdes. As imagens originais continuam preservadas em `originais/`.

## Arquivos e prévias

| Animação | Quadros | Duração base | Execução | Prévia | Fonte Aseprite |
|---|---:|---:|---|---|---|
| Descanso: respirar e piscar | 4 | 1,40 s | Loop | [GIF](previas/idle/idle.gif) | [Editar](fontes/vovo_idle.aseprite) |
| Caminhada | 6 | 0,84 s | Loop | [GIF](previas/walk/walk.gif) | [Editar](fontes/vovo_walk.aseprite) |
| Corrida | 8 | 0,60 s | Loop | [GIF](previas/run/run.gif) | [Editar](fontes/vovo_run.aseprite) |
| Cavar, semear e plantar uma muda | 8 | 1,74 s | Uma execução | [GIF](previas/idle_plant/idle_plant.gif) | [Editar](fontes/vovo_idle_plant.aseprite) |
| Queda e alma com óculos | 6 | 0,84 s | Segura a pose final | [GIF](previas/death/death.gif) | [Editar](fontes/vovo_death.aseprite) |

**32 quadros efetivos**, PNG RGBA de 128 × 128; GIFs de prévia ampliados em 4× para 512 × 512. A repetição dos GIFs é independente das regras de loop do jogo. Cada pasta de prévia contém folha PNG, atlas JSON, filmstrip e relatório de validação. As fontes Aseprite têm uma camada consolidada com frames, tags e durações editáveis; não possuem um rig por partes.

## Preparação da arte

As folhas foram geradas pela ferramenta de imagem integrada do Codex, com os anexos como referência e solicitação de fundo transparente. Os [prompts completos e caminhos das saídas](prompts.json) estão preservados; os cinco resultados brutos ficam em `gerados/`. Não foi usada API externa nem chave de API. A reconstrução procura manter a identidade dos anexos, sem afirmar reprodução pixel a pixel.

O Aseprite preparou o alpha e os recortes. Pixels com alpha abaixo de 224 foram descartados; os demais ficaram opacos. Componentes minúsculos nas saídas brutas foram removidos antes do ajuste de escala. A conferência de recortes confirmou ausência de pixels opacos nos limites de cada região, inclusive ao redor da pá, do chapéu solto e da alma.

Cada sequência usa um fator constante para evitar mudança arbitrária de tamanho entre poses. No descanso e deslocamento, a figura tem aproximadamente 64 pixels de altura. Plantio usa a pose inicial em pé como escala; morte usa a primeira pose. Os quadros têm margem transparente de pelo menos dois pixels, âncora inferior nominal y=96 e offset de exibição `(0, -16)`. Na morte, o corpo deitado mantém a escala, em vez de ser ampliado para preencher a altura.

A geração inicial repetiu a mesma perna adiantada em caminhada e corrida. Uma correção localizada no Aseprite trocou os papéis das pernas na segunda metade dos ciclos. Rosto, chapéu, tronco e avental foram preservados. A modificação ficou entre 17,9% e 23,0% dos pixels opacos por quadro afetado; as primeiras metades não foram alteradas. As cópias normalizadas originais estão no workspace de arte, em `sprite-tools/vovo-reference/{estado}/source_frames/`.

## Comportamento no jogo

- `GameArt.actor("vovo")` passa a usar `vovo_art_data.gd`; `GameArt.ui("char_vovo")` usa o novo descanso. Os PNGs ativos estão em `art/vovo_resistente/`, com catálogo JSON.
- Joystick parcial seleciona caminhada. Intensidade a partir de 0,80 entra em corrida; até 0,62 retorna à caminhada. A cadência acompanha a velocidade real, sem conceder bônus de movimento.
- Após 3,5 segundos parada, a Vovó executa o plantio. Depois de completá-lo, espera cinco segundos de inatividade para repetir. Movimento e dano interrompem imediatamente o gesto. A pausa congela os quadros.
- Pá, terra, sementes e muda são elementos visuais temporários da animação. Não criam cultivo persistente, dano, colisões ou recompensas.
- A morte tem seis poses, termina em 840 ms e mantém a pose com a pequena alma. A apresentação continua com o combate bloqueado e revela os resultados ao terminar.
- A nova partida limpa estado, gesto, quadro e temporização. A seleção de gestos agora é por personagem; Fazendeiro mantém seus dois gestos e Netinho não recebe os da Vovó.

Atributos, alcance, colisão e regras de armas permanecem com os valores existentes. O retrato anterior e os arquivos antigos permanecem no projeto; a animação de mundo e a miniatura de seleção usam a família nova.

## Validação

| Suíte / inspeção | Resultado |
|---|---|
| `vovo_animation_suite.gd` | 37 verificações, zero falhas |
| `farmer_animation_suite.gd` | 45 verificações, zero falhas |
| `stability_suite.gd` | 78 verificações, zero falhas |
| `ui_suite.gd` | 121 verificações, zero falhas |
| `art_suite.gd` | 76 verificações, zero falhas |
| Total Godot | **357 verificações, zero falhas** |
| Integridade dos PNGs | 32 RGBA, 128 × 128, alpha somente 0/255, bordas transparentes, sem magenta saturado |
| Prévia GIF | 5 GIFs, contagens e dimensões corretas |
| Aseprite | 5 sequências aprovadas; zero erros; três avisos explicados abaixo |
| Renderizador | Capturas Windows via D3D12: descanso, corrida, plantio, morte e resultados |

Os logs desta entrega estão em [evidencias/](evidencias/) e as imagens em [capturas/](capturas/). As capturas são cenas controladas de QA, com movimento e spawner desativados, não uma gravação de partida normal. Os testes usam arquivos de save próprios em `tests/.tmp/`.

O validador Aseprite sinaliza pixels isolados no plantio: um no quadro 5 e três no quadro 6; na morte, dois no quadro 4. Eles correspondem à terra/sementes e poeira presentes nas referências e foram mantidos como partículas intencionais. Há também notas informativas sobre paleta extensa e contorno com múltiplas cores. As cores ricas das imagens foram preservadas; não se trata de uma paleta restrita a 32 cores.

A revisão independente inicial deu 6,8/10 e bloqueou a repetição da mesma perna. Na comparação cega após o ajuste, escolheu a versão corrigida para ambos os ciclos, com 7,1/10 e sem o bloqueio. Compromissos: pernas da segunda metade têm sombras mais simples e botas mais retangulares; o plantio termina curvado e volta diretamente ao descanso em pé. Esses pontos ainda admitem polimento. Não houve teste em Android físico nem sessão de longa duração nesta entrega.

## Reprodução local

Scripts em `fontes/` documentam o processo; dependem da instalação local do Aseprite AI Artist e dos caminhos deste workspace. Fluxo:

1. `plan-vovo.py`: mede as imagens sem editá-las e grava os recortes em `gerados/crop_plan.json`.
2. Aseprite batch executa `prepare-reference-vovo.lua`, com parâmetros `plan` apontando para o JSON e `output` apontando para `sprite-tools/vovo-reference`.
3. Aseprite executa `fix-vovo-gait.lua` com o mesmo `output`, depois `assemble-reference-vovo.lua`. A correção sempre parte de `source_frames`, sem acumular alterações.
4. Node executa `export-reference-vovo.mjs` a partir da instalação em `sprite-tools/aseprite-ai-artist`, que abre os documentos pelo MCP, produz prévias e valida.
5. Na raiz do projeto Godot: `python tools/install_reference_vovo.py --source ../sprite-tools/vovo-reference` valida e copia os exports.
6. Importe os recursos no Godot e execute as suítes abaixo.

```powershell
foreach ($suite in @('vovo_animation_suite', 'farmer_animation_suite', 'stability_suite', 'ui_suite', 'art_suite')) {
    godot --headless --audio-driver Dummy --path . --script "res://tests/$suite.gd"
    if ($LASTEXITCODE -ne 0) { throw "Falha em $suite" }
}
```

Para as capturas, execute `tests/vovo_visual_smoke.gd` com renderizador habilitado. O arquivo `.gdignore` desta pasta exclui documentos, referências e fontes de trabalho da importação de recursos do jogo.
