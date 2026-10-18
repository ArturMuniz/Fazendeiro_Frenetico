# Fazendeiro fiel às referências — 18/10/2026

Família visual ativa do Fazendeiro Clássico. Os três anexos do usuário orientam rosto jovem sem barba, chapéu marrom de aba larga, camisa xadrez azul e ferrugem, jeans, botas e pazinha metálica. A geração partiu dessas referências, seguida de preparação e ajustes no Aseprite. É uma reconstrução próxima dos anexos, sem promessa de identidade pixel a pixel.

## Animações entregues

| Estado | Quadros | Duração base | Comportamento | Prévia | Fonte editável |
|---|---:|---:|---|---|---|
| Descanso, respirar e piscar | 4 | 1,40 s | Loop | [GIF](previas/idle/idle.gif) | [Aseprite](fontes/fazendeiro_idle.aseprite) |
| Andar | 6 | 0,73 s | Loop | [GIF](previas/walk/walk.gif) | [Aseprite](fontes/fazendeiro_walk.aseprite) |
| Correr | 8 | 0,53 s | Loop | [GIF](previas/run/run.gif) | [Aseprite](fontes/fazendeiro_run.aseprite) |
| Ajustar o chapéu | 8 | 1,20 s | Uma execução | [GIF](previas/idle_hat/idle_hat.gif) | [Aseprite](fontes/fazendeiro_idle_hat.aseprite) |
| Espantar uma mosquinha | 8 | 1,09 s | Uma execução | [GIF](previas/idle_swat/idle_swat.gif) | [Aseprite](fontes/fazendeiro_idle_swat.aseprite) |
| Morrer, com chapéu separado | 4 | 0,84 s | Segura a pose final | [GIF](previas/death/death.gif) | [Aseprite](fontes/fazendeiro_death.aseprite) |

São **38 quadros efetivos**. Os GIFs são ampliados em 4×; o loop do visualizador não determina o comportamento do Godot. As folhas nativas e seus metadados ficam em cada pasta de prévia. Os arquivos Aseprite têm uma camada de arte consolidada, com os quadros e tempos editáveis; não são um rig por partes.

## Tratamento das imagens

- Originais preservados em `originais/`; seis saídas brutas da IA em `gerados/`.
- Os JPGs enviados têm quadriculado gravado nos pixels. Serviram como referência para novas folhas com alpha, evitando tratar o quadriculado como transparência real.
- As saídas geradas tinham pixels semitransparentes e pequenos resíduos. No Aseprite, alpha abaixo de 224 foi descartado, o restante ficou opaco; pequenos componentes isolados foram removidos, preservando chapéus, ferramentas e mosquinha.
- Recortes individuais consideram as extremidades de cada pose. Escala constante por sequência e alinhamento pela massa da cabeça reduzem oscilações de tamanho e posição.
- Quadros finais: PNG RGBA de 128 × 128, alpha binário, pelo menos dois pixels transparentes nas bordas. Figura em pé com altura aproximada de 64 pixels; âncora inferior nominal em y=96 e offset de exibição `(0, -16)`.
- A corrida gerada repetia excessivamente a mesma passada. Pernas e botas receberam ajuste articulado no Aseprite para alternar os apoios; o tronco mantém o desenho gerado com base nos anexos.
- As cores detalhadas foram preservadas. Há milhares de cores nas fontes; os relatórios do validador observam paleta extensa e contorno com múltiplas cores. Não se trata de pixel art com paleta restrita a 28 cores como o estudo anterior.

## Integração no jogo

`farmer_art_data.gd` e `art/fazendeiro_fiel/catalog.json` descrevem quadros, tempos, loop e offset. `GameArt` fornece essa família ao animador e ao retrato do personagem. `player.tscn` e o fallback do script apontam para a nova arte. A família anterior permanece arquivada, mas não é a selecionada para o Fazendeiro.

Joystick parcial usa caminhada; intensidade a partir de 0,80 entra na corrida e até 0,62 retorna à caminhada. A histerese evita alternância rápida na fronteira. A cadência acompanha a velocidade real. **Corrida é uma apresentação visual: não concede bônus de velocidade ou de atributos.** A pazinha faz parte do desenho original; não cria uma arma adicional.

Após 3,5 segundos parado, o personagem pode ajustar o chapéu ou espantar uma mosquinha. Os gestos alternam e aguardam cinco segundos após a conclusão para repetir. Movimento e dano interrompem o gesto. Pausa congela as animações de gameplay. A morte dura 840 ms e apresenta o resultado ao terminar, mantendo o combate bloqueado. Nova partida limpa os estados de animação. Os outros dois personagens mantêm suas próprias famílias visuais.

## Verificações e limites

| Verificação | Resultado |
|---|---|
| Animações do fazendeiro | 47 verificações, zero falhas |
| Controle e estabilidade | 78 verificações, zero falhas |
| Interface | 121 verificações, zero falhas |
| Arte integrada e morte dos personagens | 76 verificações, zero falhas |
| Total Godot | **322 verificações, zero falhas** |
| Integridade dos PNGs | 38 quadros RGBA; alpha 0/255; margens sem cortes |
| Exportação Aseprite | 6 sequências aprovadas; zero erros ou avisos; notas informativas de estilo preservadas |
| Renderizador Windows | 5 capturas: descanso, corrida, chapéu, morte e resultados |

Evidências estão em [evidencias/](evidencias/); capturas em [capturas/](capturas/). As capturas são cenas controladas de QA, com spawner e movimento desativados para inspeção. Não representam uma partida completa de divulgação.

A revisão visual independente deu 7,3/10, sem bloqueios: rosto, roupa e morte se aproximam dos anexos. O sombreado das pernas da corrida é mais simples que o da camisa; algumas transições de quadril e joelho ainda podem ganhar refinamento. Não houve validação em Android físico nem teste de longa duração nesta entrega.

## Fontes e reprodução

Os [prompts e referências](PROMPTS.md) registram a geração pela ferramenta de imagem integrada do Codex. As três folhas complementares têm seus prompts completos em [JSON](prompts_complementares.json).

O fluxo usado neste workspace foi:

1. Gerar folhas de descanso, caminhada, morte, corrida e dois gestos com os anexos como referência.
2. Preparar recortes com `sprite-tools/aseprite-ai-artist/prepare-reference-farmer.lua`, usando `docs/arte_fazendeiro_fiel/gerados/crop_plan.json` como parâmetro `plan` e `sprite-tools/fazendeiro-reference` como `output`.
3. Executar `finish-reference-farmer.lua` com o mesmo `output` para finalizar corrida, durações, tags e fontes `.aseprite`. O script usa cópias normalizadas intocadas em `source_frames`, permitindo repetir a finalização sem acumular alterações.
4. Executar `export-reference-farmer.mjs` no diretório `sprite-tools/aseprite-ai-artist`, com Node, Aseprite e servidor MCP locais instalados. O cliente depende dessa instalação; as cópias em `fontes/` documentam o processo, não constituem um instalador autônomo.
5. Na raiz do projeto Godot: `python tools/install_reference_farmer.py --source ../sprite-tools/fazendeiro-reference`.
6. Executar `python tools/check_reference_farmer.py`, importar recursos no Godot e rodar as quatro suítes de `tests/` listadas acima.

Cópias dos scripts Lua, exportador e cliente MCP estão em `fontes/`. Para reproduzir fora deste computador, ajuste os caminhos do cliente e disponibilize as dependências locais. O arquivo `.gdignore` desta pasta mantém referências e arquivos de trabalho fora da importação do jogo.

Com Godot disponível no PATH, os testes podem ser repetidos na raiz do projeto:

```powershell
foreach ($suite in @('farmer_animation_suite', 'stability_suite', 'ui_suite', 'art_suite')) {
    godot --headless --audio-driver Dummy --path . --script "res://tests/$suite.gd"
    if ($LASTEXITCODE -ne 0) { throw "Falha em $suite" }
}
```
