# Integração dos sprites novos e animações

Data: 16/10/2026. Projeto: O Fazendeiro Frenético. Engine de validação: Godot 4.7.2, Windows.

## Resultado entregue

As artes selecionadas da pasta `C:/Users/artur/Downloads/.exe/Novos Sprites ChatGpt` foram preparadas e conectadas diretamente ao jogo. A revisão abrangeu **184 imagens**, registradas individualmente na [auditoria](docs/direcao_visual/06_AUDITORIA_NOVOS_SPRITES.md).

- **211 PNGs de produção:** 209 recortes de sprites/ícones/efeitos e dois pisos. Nem toda peça preparada é exibida pela UI atual: símbolos de configurações e outras peças de suporte permanecem disponíveis para funcionalidades futuras.
- **13 famílias visuais:** três personagens jogáveis, sete inimigos ativos e três níveis do companheiro.
- **39 estados de animação** no catálogo; há compartilhamento intencional entre idle/walk da Lesma e da Lagarta. A verificação percorre138 referências de quadros, incluindo esses compartilhamentos.
- **118 imagens novas selecionadas**, além de quatro fontes antigas recuperadas para Foice, Cerca, Lesma e Lagarta. O piso do Celeiro vem da entrega nova e o da Horta reutiliza a fonte previamente aprovada com contraste/saturação reduzidos.
- **23 PNGs antigos sem referência de runtime** foram retirados de `art/` e preservados em [arquivo histórico](docs/arquivo_sprites_anteriores/README.md), com `.gdignore`. Os originais nas pastas fornecidas por Artur permanecem intactos.

Não foram alterados valores de dano, vida, velocidade, alcance, cooldown, economia ou progressão. Em `EnemyDB` e `WeaponDB`, a comparação com a base Git confirmou mudanças apenas nos caminhos das imagens.

## Seleção artística e preparação

As oito pranchas com todas as fontes estão em [revisao_integrada](docs/direcao_visual/revisao_integrada/). A seleção evita importar folhas inteiras como se fossem uma animação regular: há arquivos2×2,3×2,4×2, faixas horizontais e composições com uma figura central maior. Cada região usada tem recorte explícito no pipeline.

O script [prepare_polished_art.py](tools/prepare_polished_art.py) executa remoção da chave magenta, tratamento do fundo branco externo do ícone de aplicativo, recuperação de checkerboards nas quatro fontes antigas quando necessário, limpeza de fragmentos desconectados, normalização de escala e exportação RGBA. Os originais nunca são sobrescritos.

O [manifesto de recortes](art/polished/manifest.json) registra nome de origem, SHA-256, região recortada, dimensões e espelhamento. O [catálogo](art/polished/catalog.json) relaciona entidades, estados, quadros, FPS e offsets; o mesmo conteúdo é gerado em `polished_art_data.gd` para consumo do jogo.

Os quadros de uma sequência compartilham canvas e ponto de apoio. Quadros com asas recolhidas, corpo comprimido ou personagem caído recebem ajustes específicos para evitar que o corpo cresça ao preencher a mesma altura artificialmente. A direção-base foi uniformizada antes de aplicar o espelhamento do jogo. As margens dos canvases dos atores foram conferidas após importação no Godot.

Nenhum dos209 recortes finais contém pixels de magenta forte opaco pelo critério automatizado da preparação. Todos têm canal alpha com transparência real. Os pisos são intencionalmente opacos. A ausência de fundo foi também inspecionada sobre os terrenos e o pergaminho; o teste numérico sozinho não certifica a qualidade de cada contorno.

## Personagens e companheiros

| Personagem | Descanso | Caminhada | Morte | Reprodução |
|---|---|---|---|---|
| Fazendeiro | 4 quadros,4 FPS | 4 quadros,8 FPS | 5 quadros,9 FPS | Idle/walk repetem; morte termina no último quadro |
| Vovó | 4 quadros,4 FPS | 4 quadros,7 FPS | 4 quadros,8 FPS | Mesma regra; retrato próprio no lobby |
| Netinho | 2 quadros,3 FPS | 4 quadros,9 FPS | 4 quadros,8 FPS | Sem usar a pose de disparo como descanso |

Os três personagens agora recebem a família visual correspondente à seleção do Hub. Os atributos e armas iniciais continuam vindos de `CharacterDB`. O Netinho da nova entrega carrega um estilingue no desenho; ele é parte da arte fornecida e não dispara nem muda sua arma inicial de Milho. Uma futura versão de mãos livres pode remover essa ambiguidade visual sem alterar a mecânica.

A derrota inicia uma apresentação curta no cenário: a simulação para e a recompensa é liquidada imediatamente; somente o animador do personagem termina a queda. Ao concluir, a tela de resultado é revelada. Essa exceção de apresentação não libera combate, movimento, timers ou outras animações pausadas. O resultado também contém uma pequena prévia da pose de derrota e o emblema apropriado. Em vitória, o personagem permanece em descanso.

Bezerro, Novilha e Vaca Voadora possuem famílias distintas para repouso, movimento e ataque por contato. A folha com bezerro bípede foi rejeitada; o nível3 usa a sequência alada fornecida, enquanto o deslocamento real continua sendo o comportamento existente do companheiro. Evoluir atualiza o mesmo companheiro, sem invocar outro.

[Prévia dos três ciclos de caminhada](docs/direcao_visual/revisao_integrada/personagens_caminhando.gif). A montagem usa8 FPS para comparação lado a lado; os FPS reais de cada personagem estão na tabela.

## Inimigos, morte e pooling

Os sete IDs existentes em `EnemyDB` têm visual próprio: Pulgão, Lesma, Gafanhoto Saltador, Mosca Atiradora, Lagarta Titã, Rainha das Moscas e Gafanhoto Gigante. Espécies futuras, como rato, aranha e abelha, não foram adicionadas ao combate por existirem imagens disponíveis.

As animações acompanham movimento, salto, pouso e disparo quando há sequência adequada. O ataque de Mosca/Rainha é acionado junto ao evento já existente; a arte não governa os timers ou o dano. O hit feedback usa modulação breve e efeitos independentes.

Morte visual não retém o inimigo no conjunto de alvos: colisão e comportamento são desativados e o corpo volta ao pool. A apresentação fica num nó visual separado, sem colisão, sem XP e sem recompensa. Quando há sequência de morte limpa, ela é usada; nos demais casos, há dissipação curta de casca/poeira. Isso inclui Pulgão, Lesma, Lagarta e Gafanhoto Gigante: suas fontes de morte ausentes ou inadequadas não foram forçadas como animações completas.

Ao reutilizar um inimigo, o catálogo, estado, quadro, relógio da animação, orientação, escala e tint de dano são reiniciados. As formas de colisão continuam independentes e preservam os raios anteriores. Animações de gameplay e efeitos congelam com a pausa.

## Interface, armas e mundo

- Hub: retratos dos três personagens e símbolo único de ouro. Saldo com largura flexível, validado nas quatro resoluções da suíte de UI.
- HUD: molduras separadas de vida/XP, preenchimentos e valores do motor. Barra nomeada de chefe preservada.
- Joystick: anel transparente e manopla separados, mantendo a mesma geometria de toque e centro do controle.
- Pausa/atributos: seis símbolos de vida, velocidade, dano, intervalo, defesa e coleta com valores reais ao lado.
- Inventário/cartas: novos ícones nos níveis com correspondência segura; nomes, níveis e números continuam renderizados pelo Godot.
- Vitória/derrota: emblemas rurais sem textos embutidos. Os estados de pagamento e retry continuam ligados ao save.
- Mundo: projéteis de milho, batata, mamona e gosma hostil; semente de XP, poste de cerca, corpos de armas e companheiros. As cenas também receberam referências limpas para evitar mostrar o logo do Godot como placeholder.
- Cenário: Celeiro usa o piso novo de tábuas discretas; Horta usa grama aprovada com menos contraste; Pomar mantém o piso neutro anterior. Props novos ficam atrás da ação, com distribuição determinística e sem colisões ocultas.
- Efeitos: impacto, serragem, eletricidade e dissipação de morte. O efeito de morte usa recortes de larguras diferentes e exclui a casca intacta que poderia parecer pickup. Há limite de40 efeitos simultâneos, inclusive para chamadas no mesmo frame.
- Aplicativo: ícone próprio do Fazendeiro, com remoção do branco externo. Este projeto ainda não contém preset/APK Android exportado.

## Fontes que ficaram fora ou exigem complementos

As decisões de cada arquivo estão na auditoria. Principais casos:

| Fonte/caso | Decisão |
|---|---|
| Carta com `ORDER118` escrito | Manter painel aprovado sem texto; não colocar instrução da IA na UI |
| Chão do Pomar com caixas, cestos e árvores desenhados | Rejeitar como piso repetível; usar props separados |
| Piso outonal com manchas dominantes | Preservar alternativa, manter chão neutro atual |
| Bezerro em pé sobre duas patas | Rejeitar para a sequência quadrúpede |
| Folhas de cinco poses com personagem central maior | Usar folhas/recortes coerentes, sem cortar como grade uniforme |
| Morte de chefe com linha de chão contínua e corpos sobrepostos | Usar efeito independente; falta sequência limpa de morte |
| Forquilha com chamas | Não atribuir uma propriedade elemental inexistente |
| Canhão com símbolo nuclear e tier sem confirmação | Preservar fonte; não preencher automaticamente o nível2 por aparência |
| Foice/Forquilha tier3, Canhão2 e família de Cerca sem novo ícone adequado | Manter ícone aprovado quando existente ou apresentação textual do nível real; a arma de mundo pode usar representação genérica da família |
| Símbolos de configurações/volume/navegação adicionais | Preparados quando adequados; dependem da funcionalidade correspondente, sem botões decorativos sem ação |

Uma fonte “alternativa preservada” não foi apagada. Também não é tratada como aprovada integralmente só porque uma pose semelhante entrou no jogo.

## Arquitetura da implementação

| Arquivo | Responsabilidade |
|---|---|
| `game_art.gd` | Catálogo semântico e cache compartilhado de texturas; seleção segura de arma/nível |
| `sprite_animator.gd` | Avanço por delta/FPS, loops, one-shots, quadro final, offsets e reset do pool |
| `visual_fx.gd` | Efeitos descartáveis, sem física, com teto de simultaneidade |
| `polished_art_data.gd` | Dados gerados pelo pipeline de preparação |
| `player.gd`, `enemy.gd`, `companion.gd` | Escolha do estado visual a partir do comportamento existente |
| `run_end_ui.gd` | Revelação do resultado após morte visual, com pagamento já processado |
| `rural_ui.gd`, `hub.gd`, `hud.gd`, `TouchJoystick.gd` | Aplicação das novas peças na UI funcional |
| `main.gd` | Decoração determinística sem alteração de colisão |

O cache mantém texturas compartilhadas, evitando recarregar a mesma imagem por inimigo. O animador não modifica atributos, formas físicas ou recompensas. Nodes de efeitos são inseridos imediatamente porque contêm somente desenho; isso permite aplicar o limite também dentro de um único frame e evita uma adição deferida órfã durante troca de cena.

## Validação executada

**275 verificações passaram, zero falhas nas execuções finais:**

| Suíte | Quantidade | Cobertura |
|---|---:|---|
| `tests/stability_suite.gd` | 78 | Joystick, pausas sobrepostas, colisões, pool, timers,10 reinícios reais de cena, campanha, vitória/endless e persistência |
| `tests/ui_suite.gd` | 121 | Valores reais das armas/passivos, transações da loja, cartas, confirmações e layouts em360×640,720×1280,1080×2400 e1280×720; inclui regressão do saldo com ícone |
| `tests/art_suite.gd` | 76 | Família de personagem, avanço/congelamento/retomada, morte no mundo e revelação do resultado, reset do pool para os sete inimigos, XP único, níveis do companheiro, margens/canvas e ciclo de vida dos efeitos |

Os testes usam saves próprios em `tests/.tmp/`; não alteram o save pessoal. São cenários dirigidos e acelerados, não campanhas longas jogadas manualmente.

Foram geradas **25 capturas reais** com D3D12/NVIDIA RTX4050:15 pela suíte visual existente e10 pela nova suíte de arte. A janela efetivamente capturada foi720×1055; a solicitação inicial era720×1280, ajustada pelo desktop. As capturas cobrem lobby, personagens, loja, três mapas, inventário, atributos, cartas, vitória, derrota, morte no cenário e erro de save. Consulte a [prancha das25 telas](docs/direcao_visual/revisao_integrada/25_telas.jpg).

As execuções finais de importação, testes e capturas terminaram com código0 e sem `ERROR`, `SCRIPT ERROR`, `WARNING` ou `FAIL` nos logs verificados. O encerramento da suíte de arte aguarda a liberação do mixer após parar o áudio, para evitar referências de playback ainda em uso ao encerrar o processo.

Para repetir, dentro da pasta do projeto:

```powershell
godot --headless --audio-driver Dummy --path . --script res://tests/stability_suite.gd
godot --headless --audio-driver Dummy --path . --script res://tests/ui_suite.gd
godot --headless --audio-driver Dummy --path . --script res://tests/art_suite.gd
godot --audio-driver Dummy --path . --resolution 720x1280 --script res://tests/art_visual_smoke.gd
godot --audio-driver Dummy --path . --resolution 720x1280 --script res://tests/visual_smoke.gd
```

Substituir `godot` pelo executável local instalado. Para reconstruir as imagens, executar o pipeline com as duas pastas de fontes descritas no início; depois reimportar no editor.

## Limites e próxima revisão

O resultado foi revisado no Windows. Ergonomia, safe areas, desempenho térmico/memória em telefone e partidas longas continuam exigindo teste em Android físico. As sequências fornecidas têm quantidade limitada de poses: este pacote usa as poses coerentes disponíveis e não inventa quadros intermediários nem promete animação AAA a partir de uma folha inconsistente.

Continuam úteis fontes de mãos livres para o Netinho, mortes limpas das criaturas listadas, ícones dos tiers ainda ausentes e piso de Pomar realmente repetível. A fonte de interface continua a padrão do Godot até seleção/licença de uma família final.

O projeto local está atualizado. O ZIP entregue antes desta integração continua representando a versão anterior; este trabalho não o sobrescreveu nem publicou novas alterações no GitHub.
