# Prompts de produção visual — O Fazendeiro Frenético

Versão: 16/10/2026. Destino: geração por Artur no Google Flow e preparação/integração posterior no Godot.

Base: [arquitetura visual](02_ARQUITETURA_UI.md), [auditoria dos sprites](01_ANALISE_SPRITES.md), [backlog completo](03_ASSETS_FALTANTES.md), [interface implementada](../../RELATORIO_INTERFACE_RURAL.md) e leitura de `CharacterDB`, `EnemyDB`, `WeaponDB`, `MapDB` e das cenas atuais. Este documento é uma encomenda de arte; os tamanhos, quadros e FPS aqui propostos não são recursos já implementados nem mudanças no balanceamento.

## 1. Como usar este documento

1. Comece pelos três personagens, em especial Vovó, e pelas criaturas que ainda aparecem com textura provisória. Depois complete ícones, efeitos e UI.
2. Anexe a referência visual indicada em cada pedido. Os caminhos `art/...` são relativos à pasta que contém `project.godot`; as fontes numeradas estão na pasta original de sprites e na auditoria.
3. Copie o **Bloco de estilo** e acrescente **um único prompt específico**. Para famílias com tabela, acrescente **uma única linha da tabela** ao modelo. As tabelas são pedidos parametrizados: gerar uma linha por vez, não a tabela inteira como imagem.
4. Aprove primeiro uma pose estática. Reutilize essa mesma pose como referência para cada animação, sem regenerar o personagem do zero.
5. Prefira quadros PNG individuais. Se gerar vídeo, envie também a imagem de referência usada e o vídeo original; eu farei a avaliação e preparação antes de integrar.
6. Salve usando os nomes abaixo e informe o ID. Não substitua arquivos do projeto manualmente só porque o nome parece parecido.

O Flow reúne criação de imagens e vídeo; a documentação oficial descreve o uso de imagens como referências e quadros para vídeo. Este roteiro não pressupõe que o modelo escolhido exporte alpha real, sprite sheets exatos, FPS de jogo ou dimensões arbitrárias. As dimensões abaixo são **contrato de entrega após preparação**; um prompt não garante esses resultados. Ver [anúncio oficial de imagem e vídeo integrados](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates-february-2026/) e [ajuda oficial de criação de vídeo](https://support.google.com/flow/answer/16353334?hl=en).

**Sem geração necessária:** mapa do lobby, emblema, painéis, botões, medalhões, cinco passivos, três upgrades da fazenda e nove ícones de armas já foram preparados no pacote atual. Não gastar créditos para refazê-los. Animações de barras, contadores, foco e seleção serão feitas no motor.

## 2. Bloco de estilo — copiar antes de cada prompt

```text
Crie um asset de produção para o jogo independente brasileiro “O Fazendeiro Frenético”, um jogo 2D de sobrevivência rural com combate automático. Use as imagens anexadas como referência obrigatória de identidade, proporções, perspectiva, materiais e acabamento.

Estilo: pixel art artesanal, simpático e expressivo, contornos castanho-escuros firmes, pixels nítidos e agrupados, silhuetas simples, detalhes suficientes para leitura em celular. Sombreamento em poucos tons, luz suave vinda do alto à esquerda. Preserve exatamente o rosto, a roupa, os acessórios e a escala da referência da família. Não invente outro personagem.

Para personagens e criaturas: vista de jogo 2D oblíqua rasa, compatível com a referência do Fazendeiro, rosto/corpo levemente voltados ao observador e direção principal para a direita. A arte é um recorte para um mundo visto de cima; não é uma cena de plataforma com horizonte. Para interface: vista frontal, sem perspectiva inclinada. Para pisos: vista superior ortogonal.

Materiais da interface: madeira castanha #704426, contorno #281D17, pergaminho creme #F1E2BF e texto futuro #2B2118. Vermelho #BC4036 para vida/ameaça, ciano #429DA6 para XP/energia aliada, ouro quente #E7B94C para a única moeda. São guias, preserve as relações tonais das referências anexadas.

Asset isolado, composição limpa, sem letras, números, logotipos, legendas, marca-d'água, grade ou borda de folha. Nenhum texto faz parte da imagem. Não desenhe xadrez de transparência. Não desenhe cenário, horizonte, chão ou sombra projetada junto ao sprite. Preserve margem livre em todos os lados. Não cortar pontas, chapéu, asas, antenas, ferramentas ou partículas.

Evitar: render 3D, fotografia, pintura com pinceladas, vetor liso, realismo, blur, anti-aliasing suave, bloom, glow intenso, microtexturas, partículas magenta, perspectiva variável, anatomia variável, membros duplicados, arma fundida no corpo e acabamento diferente entre quadros.
```

**Fundo:** pedir transparência verdadeira quando a saída suportar. Caso venha opaco, usar um fundo único e totalmente plano, sem sombra ou gradiente. Para roupa verde, evitar chroma verde. Magenta puro `#FF00FF` pode ser usado quando não existe rosa/magenta no objeto; para bezerros com focinho rosa e efeitos com tons próximos, preferir azul puro `#0000FF` se não houver azul no asset. Informar a cor utilizada. A seleção final de chave depende das cores reais da imagem. Nunca aceitar um xadrez desenhado como alpha.

**Escala de pixels:** usar o recorte aprovado como régua de densidade. Um arquivo grande com aparência de pixels finos não equivale ao sprite atual. Pedir bordas duras e poucos tons; redimensionamento final com nearest-neighbor será revisado na preparação. Não ampliar o mesmo arquivo repetidamente.

## 3. Referências que devem acompanhar os pedidos

| Família | Referência principal para anexar | Complemento permitido |
|---|---|---|
| Fazendeiro | `art/ui_rural/char_fazendeiro.png` e fonte #001 `1.1 Idle — 2 a 4 frames.png` | #048 caminhada e #084 morte somente como ideia de movimento, descartando fundo |
| Netinho | `art/ui_rural/char_netinho.png`; fonte #088 `netinhoagil-andando.jpg` | Boné vermelho e roupa azul dessa fonte; não usar conceito ilustrado #009 como identidade |
| Vovó | #112 `vovoresistente-andando.jpg`, #113 e #114 | Proporção/perspectiva do Fazendeiro; aprovar nova pose canônica antes de animar |
| Madeira e pergaminho | `art/ui_rural/panel.png`, `button.png`, `emblem.png` | Fontes aprovadas #118–120 |
| Armas | Ícone do nível aprovado em `art/ui_rural/weapon_*.png` | Fontes da mesma família; nunca anexar personagem segurando arma como alvo do ícone |
| Bezerro | `weapon_bezerro_1.png`, `_2.png`, `_3.png` em `art/ui_rural/` | Fontes #072, #024 e #025 |
| Pragas | Pulgão #100, Mosca #087, Rainha #085 | Lesma #109, Lagarta #027 e Gafanhoto gigante #065 para identidade, corrigindo defeitos |
| Pisos e props | #111 grama, #110 terra, mapa #094 | Kits #092 Pomar, #093 Celeiro e #095 Horta |

As imagens de referência da auditoria estão em `docs/direcao_visual/`; os originais estão em `C:/Users/artur/Downloads/.exe/fazendeiro_caotico_sripites`. Fontes “Precisa de Ajuste” orientam a identidade, mas não tornam seu acabamento aprovado. Não anexar pranchas com dezenas de imagens quando for possível anexar só o objeto desejado.

## 4. Contrato de arquivos e animações

### 4.1 Tamanhos finais propostos

| Categoria | Canvas por quadro/arquivo | Área útil e ponto de apoio |
|---|---|---|
| Personagem jogável | 128×128 | Corpo em pé dentro de ~88×104; pés no ponto (64,112). Cabeça e chapéu preservados. Escala relativa será validada no jogo |
| Praga pequena | 96×96 | Corpo dentro de ~72×64; apoio/âncora no ponto (48,72) |
| Chefe | 256×256 | Corpo dentro de ~208×192; apoio/âncora no ponto (128,208) |
| Companheiro | 128×128 | Corpo dentro de ~104×88; apoio no ponto (64,104), igual nos três níveis |
| Ícone de item/atributo | 128×128 | Objeto central com pelo menos 12 px livres; será exibido em ~48–96 |
| Retrato | 256×256 | Busto/silhueta central; margem mínima 24; será exibido em ~96–128 |
| Efeito de combate | 128×128 ou 256×256 | Âncora central; faixa de estocada tem contrato próprio |
| Piso repetível | 256×256 | Bordas opostas contínuas; sem transparência |

Valores são coordenadas do arquivo final, origem no canto superior esquerdo. Não são novos raios de colisão. O corpo pode subir durante um salto; o ponto que representa a projeção no chão permanece estável. Em morte, o corpo pode cair lateralmente dentro do mesmo canvas; não recentralizar a silhueta caída.

### 4.2 Ordem de quadros

Preferência: `nome_estado_right_00.png`, `01.png` etc., todos com canvas igual e margem preservada. `right` indica personagem orientado para a direita. O jogo atualmente espelha horizontalmente; não precisamos de oito direções. Roupa e itens devem permitir espelhamento sem texto ou símbolos de lateralidade obrigatória. Se existir acessório realmente assimétrico, documentar para decidir se precisa de versão esquerda.

Alternativa de folha: **uma animação por arquivo**, grade uniforme, ordem da esquerda para a direita. Idle 4 quadros = 4×1; walk 6 = 6×1; death 6 = 6×1. Sem padding interno para a folha de entrada com células de 128×128: 512×128 ou 768×128. Padding/extrusão de atlas será aplicado na preparação, se necessário. Se a IA não respeitar a grade, entregar a saída original para recorte; não inventar coordenadas corretas.

Não misturar idle, caminhada, ataque e morte numa única sequência. “Descanso” aqui significa idle atento no combate: respiração discreta, sem plantar, pular, atirar ou usar habilidade.

### 4.3 Vídeo como material de entrada

O vídeo é uma fonte para extração, não um arquivo que o Godot usa automaticamente como sprite. A saída pode ter compressão, interpolação e deriva. Não prometer recorte perfeito.

Acrescentar ao prompt de movimento:

```text
Use a pose aprovada anexada como imagem inicial e identidade rígida. Mostre um único personagem, corpo inteiro, ocupando a mesma região do enquadramento, sobre fundo totalmente plano e uniforme. Câmera ortográfica fixa: sem pan, zoom, tremor, cortes, transição ou mudança de iluminação. O personagem executa apenas o movimento solicitado no lugar. Não deslocar a câmera para acompanhá-lo. Não adicionar cenário, sombra, trilha, partículas, áudio narrativo, texto ou outros personagens. Preserve o desenho pixelado sem interpolação suave aparente, sem morphing e sem alterar roupa, rosto, escala ou quantidade de membros.
```

Para loop: pedir duas repetições iguais de idle/caminhada e retornar à pose inicial. Para morte: pedir uma execução com pose inicial e final mantidas brevemente, sem retornar à vida. A duração disponível no Flow não determina a duração no jogo; selecionaremos os quadros necessários e descartaremos repetições. Se a geração insistir em deformar o personagem, usar edição de imagem quadro a quadro, com a mesma pose de referência.

## 5. Personagens — poses, descanso, caminhada e morte

Prioridade alta para os três conjuntos. **Importante:** `CharacterDB` já define os três personagens, mas `player.gd` ainda usa as mesmas texturas fixas de idle/walk. As artes deverão ser conectadas ao personagem selecionado numa etapa de integração. A animação de morte também exigirá ligar o estado visual ao fluxo de resultado, preservando salvamento e pausa. Não basta trocar um PNG.

### CH-F — Fazendeiro Clássico

Referência obrigatória: #001 e `char_fazendeiro.png`. Manter o rapaz atual, chapéu castanho, camisa xadrez azul, jeans e botas. A ferramenta que aparece na referência não deve virar parte inseparável do corpo animado, pois armas são renderizadas separadamente.

**CH-F-00 — pose canônica / arquivo `fazendeiro_reference_right.png`**

```text
Reproduza fielmente o Fazendeiro jovem da referência pixelada: mesmo rosto, chapéu castanho de aba larga, camisa xadrez azul, jeans e botas marrons. Corpo inteiro, levemente em três quartos voltado para a direita, postura atenta e simpática. Mãos livres e legíveis, sem foice, arma, sombra ou chão incorporado. Preserve o visual atual; não adicionar barba nem trocar a roupa. Canvas final previsto 128×128, pés alinhados a (64,112), aproximadamente 104 pixels de altura incluindo o chapéu. Uma única pose isolada.
```

**CH-F-01 — descanso / `fazendeiro_idle_right_00..03.png`**

```text
Usando exatamente a pose canônica do Fazendeiro anexada, produza um ciclo de descanso atento com quatro poses: neutro, inspiração muito discreta, retorno ao neutro e expiração discreta com um piscar de olhos. Pés imóveis, chapéu quase imóvel, cabeça e tronco variam no máximo dois pixels na escala final. Sem acenar, cultivar ou empunhar arma. Mesmo canvas e apoio em todos os quadros; ciclo contínuo sem salto. Entrega preferida: quatro PNGs separados, ordem temporal 00 a 03. Não desenhar os números.
```

Integração proposta: 4 quadros, 4 FPS, loop. Um ciclo de 1 s; ajustar após inspeção visual.

**CH-F-02 — caminhada / `fazendeiro_walk_right_00..05.png`**

```text
Anime o Fazendeiro canônico caminhando para a direita no lugar, em seis poses sequenciais: contato pé direito à frente, descida, passagem, contato pé esquerdo à frente, descida oposta, passagem oposta. Braços livres alternam discretamente, sem trocar acessórios ou roupa. Pés continuam ligados à mesma linha de apoio; nenhum deslocamento horizontal do corpo no canvas. Movimento compacto e legível, sem escorregar, saltar ou correr exageradamente. Cabeça e chapéu conservam tamanho. Seis quadros separados com canvas idêntico, sem números, sem rastro ou poeira.
```

Integração proposta: 6 quadros, 8 FPS, loop; movimento real vem de `velocity`, não de deslocamento desenhado.

**CH-F-03 — morte / `fazendeiro_death_right_00..05.png`**

```text
Crie a sequência não repetitiva de derrota do mesmo Fazendeiro, sem sangue: 00 surpresa breve, 01 perde o equilíbrio, 02 dobra os joelhos, 03 cai de lado para a direita, 04 acomoda o corpo, 05 repousa imóvel. Expressão cartunesca respeitosa. Manter rosto, roupa e chapéu reconhecíveis; chapéu permanece junto ao corpo, sem voar para fora do canvas. Não gerar fantasma, moeda, XP, texto, partículas ou tela de derrota. Preserve a âncora original no chão e deixe o corpo cair dentro do mesmo canvas, sem recentralização por quadro. Seis PNGs individuais.
```

Integração proposta: 6 quadros, 8 FPS, sem loop; manter último quadro. Duração ~0,75 s é visual, não novo tempo de invulnerabilidade ou atraso de pagamento.

### CH-V — Vovó Resistente

Referências: #112–114 para identidade; Fazendeiro aprovado para perspectiva e densidade de pixels. Não copiar as sombras elípticas e ações de plantio das folhas antigas.

**CH-V-00 — pose canônica / `vovo_reference_right.png`**

```text
Crie a Vovó Resistente a partir da referência anexada: senhora rural de óculos, chapéu e avental verde, mesma identidade facial e mesmos acessórios do sprite original. Adapte a perspectiva à do Fazendeiro anexado: corpo inteiro em três quartos levemente voltado para a direita, contorno e densidade de pixels equivalentes, proporção compacta e expressão determinada e acolhedora. Mãos livres, sem motosserra, plantio, sombra ou chão. Canvas final previsto 128×128, pés em (64,112), altura visual próxima de 96–104 pixels incluindo chapéu. Não transformar em jovem, bruxa ou caricatura frágil. Uma única pose neutra.
```

**CH-V-01 — descanso / `vovo_idle_right_00..03.png`**

```text
Anime somente a Vovó canônica aprovada em quatro poses de descanso atento: respiração mínima no tronco, piscar breve e avental movendo no máximo dois pixels. Ambos os pés permanecem fixos; óculos, chapéu, rosto e comprimento do avental não mudam. Não plantar, regar, acenar ou usar arma. Mesmo enquadramento, mesma linha de apoio e mesma orientação para a direita. Quatro quadros separados para loop contínuo, sem texto.
```

Integração proposta: 4 quadros, 4 FPS, loop.

**CH-V-02 — caminhada / `vovo_walk_right_00..05.png`**

```text
Anime a Vovó canônica andando para a direita no lugar em seis poses de passos curtos e firmes, alternando contato, descida e passagem dos dois pés. O avental acompanha discretamente o movimento, sem mudar de forma ou comprimento. Manter anatomia, óculos e chapéu estáveis; braços livres, sem arma. Movimento confiante e compacto, sem tropeços durante o loop, sem chão ou sombra. Pés alinhados à linha de apoio; nenhum deslocamento horizontal no arquivo. Seis quadros separados.
```

Integração proposta: 6 quadros, 7–8 FPS, loop. Não usar o FPS para alterar o modificador real de velocidade da Vovó.

**CH-V-03 — morte / `vovo_death_right_00..05.png`**

```text
Crie uma derrota cartunesca e sem violência gráfica da Vovó canônica: surpresa, desequilíbrio, joelhos cedendo, queda suave de lado, acomodação e repouso. Seis poses, nessa ordem. Preservar dignidade e identidade, óculos e chapéu; nada de túmulo, fantasma, sangue ou texto. Corpo caído permanece dentro do mesmo canvas com a âncora do chão preservada; não adicionar uma sombra diferente por pose. Não repetir nem levantar no final.
```

Integração proposta: 6 quadros, 8 FPS, sem loop.

### CH-N — Netinho Ágil

Referência: #088 e `char_netinho.png`. Manter boné vermelho e roupa azul; não adicionar estilingue ao corpo, pois a arma inicial atual é o milho.

**CH-N-00 — pose canônica / `netinho_reference_right.png`**

```text
Reproduza o Netinho da referência pixelada: menino rural ágil, boné vermelho, roupa azul e mesmo rosto/acessórios do sprite aprovado. Corpo inteiro em três quartos para a direita, mãos livres, postura alerta e levemente inclinada para a frente. Densidade de pixels e contorno iguais aos do Fazendeiro, com silhueta infantil própria, sem tornar adulto. Canvas final previsto 128×128, pés em (64,112), altura aproximada 88–96 pixels incluindo boné. Sem estilingue, arma, cenário ou sombra. Uma única pose neutra.
```

**CH-N-01 — descanso / `netinho_idle_right_00..03.png`**

```text
Crie quatro poses de descanso atento do Netinho canônico: respiração sutil, pequeno piscar e leve ajuste dos ombros, mantendo pés e boné estáveis. Não saltar, agachar, atirar, sacar estilingue ou trocar de roupa. Energia juvenil comunicada pela postura, não por deslocamento do corpo no canvas. Loop limpo com quatro quadros separados, mesma âncora e escala.
```

Integração proposta: 4 quadros, 5 FPS, loop.

**CH-N-02 — caminhada / `netinho_walk_right_00..05.png`**

```text
Anime o Netinho canônico numa caminhada rápida para a direita no lugar, com seis poses alternadas de contato, descida e passagem dos pés. Passos leves e braços compactos; boné e rosto mantêm a identidade. Não fazer acrobacia, salto, dash ou disparo. Sem deslocamento horizontal no canvas e sem poeira. Seis quadros, mesma escala e linha de apoio em todos eles, loop contínuo.
```

Integração proposta: 6 quadros, 10 FPS, loop; a velocidade real continua vindo dos atributos.

**CH-N-03 — morte / `netinho_death_right_00..05.png`**

```text
Crie seis poses sequenciais da derrota sem sangue do Netinho canônico: susto, desequilíbrio, joelhos cedendo, queda lateral, acomodação, repouso imóvel. Expressão cartunesca leve, sem sofrimento gráfico. Boné permanece reconhecível junto ao corpo dentro do canvas. Não colocar fantasma, rótulo, contagem, moeda ou tela final. Mesma âncora no chão e mesmo canvas em todos os quadros. Não reviver nem repetir a ação.
```

Integração proposta: 6 quadros, 8 FPS, sem loop.

### CH-P — retratos dos personagens

Fazendeiro e Netinho já possuem recortes funcionais na interface; retratos novos são opcionais de acabamento. O da Vovó é prioritário.

Modelo, uma geração por personagem:

```text
Crie um retrato pixel art de [PERSONAGEM] usando a pose canônica anexada. Mesmo rosto, roupa e acessórios, expressão determinada e simpática. Enquadrar cabeça e parte superior do tronco, sem cortar chapéu ou boné. Vista em três quartos compatível com o sprite. Sem ferramenta, moldura, fundo, texto ou números. Canvas quadrado final 256×256 com margem mínima de 24 pixels. Leitura clara quando reduzido a 96 pixels; não converter o personagem em ilustração pintada nem adicionar detalhes ausentes no sprite.
```

Arquivos: `portrait_fazendeiro.png`, `portrait_vovo.png`, `portrait_netinho.png`.

## 6. Pragas e chefes ativos — sete famílias

Os únicos IDs ativos no banco atual são os sete abaixo. Mosca, Pulgão, Rainha e Gafanhoto Gigante ainda não têm `sprite_frames` próprios no banco; a aprovação da fonte antiga não significa que já estejam renderizados com ela. Não criar uma mosca com coroa para a mosca comum.

### 6.1 Prompt de pose canônica de cada criatura

Copiar Bloco de estilo + este modelo + uma linha da tabela:

```text
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.
```

| ID / prioridade | Complemento a copiar | Referência e arquivo |
|---|---|---|
| `pulgao` / Alta | Pulgão Corredor compacto verde, olhos vermelhos, patas pequenas e contorno escuro; borda clara pontual para não sumir na grama. Canvas 96×96, âncora (48,72). | #100 `pugao-corredor.jpg`; `pulgao_reference_right.png` |
| `lesma` / Alta | Lesma Tanque da referência, corpo violeta/cinza e casco de madeira, postura baixa e pesada. Conservar separação entre casco e corpo; sem canhão ou tiro. Canvas 96×96, âncora (48,72). | #109 `telsmatank-andando.jpg`; `lesma_reference_right.png` |
| `gafanhoto` / Alta | Gafanhoto Saltador comum, amarelo-esverdeado conforme referência, pernas traseiras dobradas e anatomia simplificada; distinto de grilo e do chefe gigante. Contorno mais robusto e patas claras no terreno. Canvas 96×96, âncora (48,72). | #064 `gafanhoto-correndo.png`; `gafanhoto_reference_right.png` |
| `mosca` / Alta | Mosca Atiradora de corpo azul, olhos alaranjados e asas claras, SEM coroa. Expressão hostil legível; voo baixo. Canvas 96×96, âncora de projeção (48,72). | #087 `mosta atiradora.jpg`; `mosca_reference_right.png` |
| `boss_lagarta` / Alta | Lagarta Titã verde da referência, corpo segmentado volumoso, cabeça reconhecível e postura pesada; sem canhão, espinhos novos ou aura cobrindo o corpo. Canvas 256×256, âncora (128,208). | #027 conforme auditoria; `boss_lagarta_reference_right.png` |
| `boss_rainha_moscas` / Alta | Rainha das Moscas da referência aprovada, coroa pequena muito legível, corpo azul/violeta, olhos fortes e asas claras. Silhueta mais imponente que mosca comum, sem número na testa. Canvas 256×256, âncora de projeção (128,208). | #085 `MOSCARAINHA-3FRAMES.jpg`; `boss_rainha_moscas_reference_right.png` |
| `boss_gafanhoto_gigante` / Alta | Gafanhoto Gigante da referência de três poses: grande massa amarela/esverdeada, pernas poderosas e expressão de chefe. Remover linha horizontal de chão e poeira. Canvas 256×256, âncora (128,208). | #065 `gafanhotogigante-3frames.jpg`; `boss_gafanhoto_gigante_reference_right.png` |

### 6.2 Prompts de movimento por comportamento

Em cada pedido abaixo, anexar **apenas a pose canônica da criatura da vez**. Onde há lista de IDs, gerar uma sequência independente por ID. Prefixo do arquivo = ID exato da tabela anterior.

**EN-IDLE — todos os sete / `<id>_idle_right_00..03.png`**

```text
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Voadora: asas alternam abertura em poses nítidas, corpo paira no máximo dois pixels sem sair da âncora. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.
```

4 quadros a 6 FPS para terrestres ou 10 FPS para voadoras, loop, a revisar. Para inimigos que nunca param, idle serve como pose-base, não obriga a criar pausas na IA.

**EN-WALK — `pulgao`, `lesma`, `boss_lagarta` / `<id>_walk_right_00..05.png`**

```text
Anime somente a criatura canônica anexada avançando para a direita no lugar em seis poses. Pulgão: patas alternadas e corrida compacta. Lesma: ondulação curta do corpo viscoso, casco quase estável, sem arrastar sombra. Lagarta: onda de compressão dos segmentos de trás para a frente, cabeça com oscilação mínima. Execute apenas a variante que corresponde à referência anexada. Sem deslocamento horizontal do canvas, ataque, arma ou efeito. Mesma escala e âncora em todos os quadros, loop contínuo.
```

6 quadros; Pulgão 10 FPS, Lesma 6 FPS, Lagarta 6 FPS, loop. Estes FPS não mudam `speed`.

**EN-FLY — `mosca`, `boss_rainha_moscas` / `<id>_fly_right_00..03.png`**

```text
Anime a criatura voadora canônica anexada avançando em voo para a direita no lugar em quatro poses de asas abertas, intermediárias, fechadas e intermediárias opostas. Corpo e cabeça estáveis, sem motion blur nas asas. Conservar a coroa somente se for a Rainha. Não inclinar a câmera, disparar ou adicionar trilhas. Mesmo canvas e ponto de projeção no chão; quatro quadros para loop.
```

4 quadros, 12 FPS, loop. Não juntar este loop ao disparo.

**EN-JUMP — `gafanhoto`, `boss_gafanhoto_gigante`**

```text
Crie poses separadas do salto da criatura canônica anexada, nesta ordem: preparação comprimindo pernas (duas poses), impulso estendendo as pernas (uma pose), corpo suspenso compacto (duas poses), pouso comprimindo pernas e retorno à postura base (duas poses). Sete poses no total, mesmo tamanho e orientação para a direita. A projeção horizontal do ponto de apoio permanece fixa; só o corpo sobe dentro do canvas. Sem chão, sombra, onda ou poeira; os efeitos de pouso serão separados. Não mudar a anatomia nem recortar pernas no alto do salto.
```

Entregar `<id>_jump_prepare_00..01.png`, `_jump_takeoff_00.png`, `_jump_air_00..01.png`, `_jump_land_00..01.png`. Preparação/pouso a ~10 FPS; sustentar/loopar ar conforme estado real. **Não alongar `jump_duration` para encaixar a animação** e não criar dano de pouso no gafanhoto comum. O chefe já tem impacto de área; o comum não.

**EN-SHOOT — `mosca`, `boss_rainha_moscas` / `<id>_shoot_right_00..03.png`**

```text
Anime em quatro poses a criatura voadora canônica se preparando e reagindo a um disparo: alerta discreto, tensão curta, soltura com pequeno recuo, retorno. Boca e corpo indicam direção para a direita. Manter voo, anatomia e coroa corretos. NÃO desenhar projétil, nuvem, raio, feixe ou explosão no quadro; o projétil é um asset separado. Não transformar disparo em mordida. Mesma âncora, quatro quadros, sem loop.
```

~12 FPS, sem loop; soltura visual no quadro02. O disparo real continua comandado pelos timers existentes; animação acompanha o evento, sem atrasar o tiro. Rajadas da Rainha não viram novos padrões de ataque por causa da arte.

**EN-DEATH — todos os sete / `<id>_death_right_00..03.png`**

```text
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.
```

4 quadros, 12 FPS, sem loop. **Integração obrigatória:** a entidade atualmente retorna ao pool ao morrer. Usar um ator visual de morte independente ou outro fluxo que desative alvo/colisão imediatamente; não manter inimigo ativo só para exibir a sequência. Resetar estado visual/FPS/frame/modulação no próximo spawn.

### 6.3 Dano recebido

Flash, pequena sacudida e tint de dano devem ser feitos no motor, sem gerar um conjunto inteiro de sprites brancos/vermelhos. Não deslocar colisão nem interromper salto/tiro para tocar uma animação nova de hit. Um efeito de impacto separado está em FX-01.

## 7. Companheiro — Bezerro, Novilha e Vaca Voadora

Backlog CH-05/IT-09. Os três ícones já estão preparados; faltam ciclos de gameplay e ligação visual do nível. O código atual do companheiro segue/persegue/ataca por contato e não tem vida própria ou morte independente. Não encomendar morte do bezerro como requisito atual.

Copiar Bloco de estilo + uma linha de identidade + um prompt de estado:

| Nível / ID de arma | Identidade obrigatória | Referência |
|---|---|---|
| 1 / `bezerro` | Bezerro creme/marrom compacto, focinho rosa, mesma distribuição de manchas e chifres da referência | `weapon_bezerro_1.png` |
| 2 / `bezerro` | Novilha mais robusta, conservar as marcas e acessórios da imagem aprovada, sem armadura inventada | `weapon_bezerro_2.png` |
| 3 / `bezerro` | Vaca Voadora da imagem aprovada: manter os traços que já existem; o nome não autoriza adicionar asas ou voo mecânico novo | `weapon_bezerro_3.png` |

**BE-IDLE / `bezerro_lv<n>_idle_right_00..03.png`:**

```text
Anime o bovino exato da referência e do nível indicado em quatro poses de descanso: respiração pequena, piscar e uma oscilação curta de orelha. Quatro patas na mesma base, focinho rosa e manchas invariáveis. Corpo inteiro orientado para a direita em canvas final 128×128, âncora (64,104). Sem mugido desenhado, sombra, arma ou efeito. Quatro quadros para loop a cerca de 4 FPS.
```

**BE-WALK / `bezerro_lv<n>_walk_right_00..05.png`:**

```text
Crie seis poses do bovino canônico caminhando para a direita no lugar. Alternância clara e coerente das quatro patas, corpo compacto e cabeça estável. Não criar patas extras, trocar manchas ou tornar o animal outro nível. Nenhum deslocamento horizontal no arquivo, poeira, sombra ou voo novo. Mesmo canvas 128×128 e âncora (64,104). Seis quadros para loop a cerca de 8 FPS.
```

**BE-ATTACK / `bezerro_lv<n>_attack_right_00..03.png`:**

```text
Crie quatro poses de ataque por contato do bovino canônico: cabeça abaixa discretamente, inclina o tronco para a direita, cabeçada curta, retorna à base. Sem deslocar o animal para fora do canvas e sem desenhar impacto ou inimigo. Mesma identidade e quatro patas coerentes. Não adicionar projétil, laser, investida longa ou habilidade de voo. Quatro quadros para reprodução única a cerca de 12 FPS; contato visual na terceira pose.
```

Não mudar alcance, dano, cooldown ou deslocamento do companheiro para acomodar a animação.

## 8. Ícones das oito famílias de armas

Todos os ícones finais: 128×128 RGBA, objeto isolado, orientação consistente entre níveis e margem mínima de 12 px. São ícones, não quadros de ataque. Não gravar “Lv”, números, estrelas ou textos. Nível aparece no motor. Variação de materiais reforça a evolução, sem inventar raridade.

### 8.1 Modelo de prompt para ícone

Copiar Bloco de estilo + este modelo + a linha específica da tabela:

```text
Crie um único ícone isolado da arma descrita abaixo, somente o objeto, sem personagem, mãos, cenário, ataque, projétil, trilha ou partículas. Mantenha a orientação, densidade de pixels e iluminação da referência aprovada da mesma família. Silhueta legível em 48 pixels, contorno castanho-escuro, margem livre. Canvas final 128×128. A evolução de nível é indicada pela construção e pelos materiais, sem número, texto ou moldura de raridade. O ícone não deve sugerir outro tipo de arma.
```

| Pedido | Complemento para copiar | Arquivo / situação |
|---|---|---|
| IT-01 / Foice 1 | Foice rural simples, cabo de madeira e uma lâmina curva de ferro; referência #052. | `weapon_foice_lv1.png` / Alta |
| IT-01 / Foice 2 | Mesma foice com cabo reforçado e lâmina mais robusta; sem corpo do Fazendeiro presente nas fontes antigas. | `weapon_foice_lv2.png` / Alta |
| IT-01 / Foice 3 | Evolução final da mesma foice, ferragem clara e detalhe dourado discreto, lâmina curva ampla mas isolada; nenhuma aura. | `weapon_foice_lv3.png` / Alta |
| IT-02 / Forquilha 1 | Forquilha agrícola de três dentes largos, cabo de madeira simples, referência #055. | `weapon_forquilha_lv1.png` / Alta |
| IT-02 / Forquilha 2 | Mesma forquilha de três dentes com junção metálica reforçada e cabo mais firme; não multiplicar dentes. | `weapon_forquilha_lv2.png` / Alta |
| IT-02 / Forquilha 3 | Mesma família, três dentes bem distintos e reforço final inspirado na ferramenta isolada de #057, sem personagem. | `weapon_forquilha_lv3.png` / Alta |
| IT-03 / Batata 1 | Canhão artesanal de batata, tubo simples de metal sobre estrutura curta de madeira, seguindo a silhueta de `weapon_batata_3.png` em versão básica. | `weapon_batata_lv1.png` / Alta |
| IT-03 / Batata 2 | Mesmo canhão, braçadeiras e reforços intermediários, mantendo uma única boca de saída e direção da versão 3. | `weapon_batata_lv2.png` / Alta |
| IT-04 / Milho 1 | Milho-metralhadora simples, sabugo amarelo e folhas verdes formando estrutura rural; seguir a direção de `weapon_milho_2.png`. Sem grãos disparados. | `weapon_milho_lv1.png` / Alta |
| IT-04 / Milho 3 | Evolução final de `weapon_milho_2.png`, estrutura reforçada e sabugo mais robusto, sem fumaça, fogo, grãos voando ou mãos. | `weapon_milho_lv3.png` / Alta |
| IT-05 / Mamona 1 | Estilingue de madeira em Y, elástico claramente visível e suporte pequeno para mamona; versão básica coerente com `weapon_mamona_2.png`. | `weapon_mamona_lv1.png` / Alta |
| IT-06 / Motosserra 1 | Motosserra rural enferrujada, corpo laranja e lâmina horizontal clara; menos reforçada que `weapon_motosserra_2.png`, mesma orientação. | `weapon_motosserra_lv1.png` / Alta |
| IT-07 / Cerca 1 | Um poste de madeira rural com pequeno isolador, fio curto legível sem faíscas incorporadas. | `weapon_cerca_lv1.png` / Alta |
| IT-07 / Cerca 2 | Dois postes da mesma família ligados por fio visível e bem separado do fundo; sem relâmpagos. | `weapon_cerca_lv2.png` / Alta |
| IT-07 / Cerca 3 | Três postes compactos da mesma família formando uma rede simples de fios, silhueta legível em miniatura, sem energia desenhada. | `weapon_cerca_lv3.png` / Alta |

**Já disponíveis, não gerar novamente:** Batata3, Milho2, Mamona2/3, Motosserra2/3 e Bezerro1/2/3. Os níveis do canhão são definidos aqui como pedidos explícitos do banco; não inferir nível da fonte antiga #030. Passivos e upgrades já têm oito recortes preparados. O ícone da cerca não altera o comportamento atual da armadilha para criar conexões físicas entre postes.

## 9. Armas em combate, projéteis e efeitos

Prioridade média, exceto sinais essenciais de dano/XP/ameaça. Os ícones anteriores podem orientar a arma de mundo, mas não devem carregar partículas permanentes. O motor posiciona, gira e escala a partir do alcance real.

### 9.1 Corpos de armas de mundo

**W-BODY / uma geração por arma e nível que precise de recorte próprio:**

```text
Extraia da referência aprovada somente o corpo da arma [ARMA, NÍVEL], preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.
```

Usar para foice, forquilha, milho, canhão, estilingue e motosserra quando o ícone não puder ser reaproveitado. Cerca: poste isolado com pivô na base, fios/energia separados. Bezerro usa seus próprios ciclos. Nome: `world_<id>_lv<n>.png`. A possibilidade de usar o mesmo recorte do inventário será avaliada antes de encomendar duplicatas.

### 9.2 Sequências de efeitos — modelo

Copiar Bloco de estilo + este modelo + **uma** linha de FX da tabela:

```text
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.
```

| ID / prioridade | Complemento do prompt: conteúdo, quadros, canvas | Arquivos / timing proposto |
|---|---|---|
| FX-01 / Alta / FB-05 | Impacto aliado: pequena estrela irregular creme/amarela com contorno escuro, expansão curta e dissipação, quatro quadros em 128×128; miolo transparente no final. | `fx_hit_00..03.png`; 16 FPS, único |
| FX-02 / Média / FB-06 | Trilha de giro de foice: arco curvo curto creme/cinza, quatro poses de dissipação em 256×256, centro vazio; não desenhar foice. | `fx_foice_trail_00..03.png`; 16 FPS, único; rotação no motor |
| FX-03 / Média / FB-06 | Trilha de estocada de forquilha: duas ou três linhas curtas horizontais para a direita, quatro poses em canvas256×128, origem em (32,64). Sem dentes ou arma desenhados. | `fx_forquilha_trail_00..03.png`; 16 FPS, único |
| FX-04 / Média / FB-06 | Fagulha/serragem curta de motosserra em quatro poses128×128, creme e madeira clara, sem corrente ou lâmina duplicada. | `fx_motosserra_hit_00..03.png`; 16 FPS, único |
| FX-05 / Média / FB-06 | Pulso elétrico ciano em segmentos curtos, quatro poses128×128, poucos pixels claros e contorno azul-escuro; sem postes, fundo ou área inteira preenchida. | `fx_cerca_zap_00..03.png`; 12 FPS, único por tick |
| FX-06 / Média / FB-06 | Explosão de batata: terra e casca em anel curto, creme/ocre de alto contraste, seis poses256×256; centro libera visibilidade rapidamente; sem fogo nuclear ou cogumelo gigante. | `fx_batata_explosion_00..05.png`; 16 FPS, único; escala pelo splash real |
| FX-07 / Média / FB-06 | Ricochete de mamona: estrela curta de contato e duas linhas direcionais, quatro poses128×128, bege claro e castanho; sem segunda semente. | `fx_mamona_bounce_00..03.png`; 16 FPS, único |
| FX-08 / Média / FB-07 | Dissipação genérica de praga: casca e poeira creme/castanha, quatro poses128×128, fragmentos diminuem até desaparecer. Sem broto, semente, ouro ou fragmento verde brilhante que pareça XP. | `fx_enemy_death_00..03.png`; 12 FPS, único |
| FX-09 / Alta / FB-08 | Coleta de XP: quatro poses128×128 de pequenos traços ciano/creme convergindo ao centro e sumindo; não desenhar novo pickup no final. | `fx_xp_collect_00..03.png`; 16 FPS, único |
| FX-10 / Alta / FB-08 | Level-up: broto estilizado com duas folhas e arco breve ciano/creme, seis poses256×256; começo e final vazios; sem painel, nome ou números. | `fx_level_up_00..05.png`; 12 FPS, único |
| FX-11 / Média / FB-09 | Onda de pouso: anel baixo de poeira ocre com borda clara, seis poses256×256 expandindo e dissipando, centro transparente; nenhuma criatura ou sombra. | `fx_boss_landing_00..05.png`; 12 FPS, único |
| FX-12 / Baixa / FB-10 | Brilho de recompensa: estrela pequena ouro/creme, quatro poses128×128, intensidade baixa, sem moeda ou números. | `fx_gold_confirmed_00..03.png`; 12 FPS, somente após save |

Faixas/aneis de FX são decorativos. A área perigosa é desenhada pelo motor e corresponde ao raio/alcance de dados. Morte de personagem e efeito de level-up não podem liberar gameplay quando outro modal está ativo.

### 9.3 Projéteis estáticos

Modelo, uma linha por geração:

```text
Crie um único projétil isolado de pixel art para o jogo rural, conforme descrição abaixo. Silhueta compacta e contorno escuro com pequeno recorte claro, legível sobre verde, marrom e ocre. Orientado para a direita, sem rastro, sombra, partículas, arma ou cenário. Canvas final64×64, objeto ocupando aproximadamente24–40 pixels conforme espécie; muito espaço livre ao redor. Não desenhar várias balas nem sequência. O motor controla trajetória, rotação, colisão e velocidade.
```

| ID / prioridade | Complemento | Nome |
|---|---|---|
| PR-01 / Média | Um grão de milho amarelo forte e creme, ponta/silhueta clara; referência #015, sem linhas divisórias. | `projectile_milho.png` |
| PR-02 / Média | Uma batata curta castanha com pequenas manchas discretas e borda creme; referência #014, contraste contra terra. | `projectile_batata.png` |
| PR-03 / Média | Uma semente de mamona marrom de alto contraste, borda clara discreta; referência #099, sem raios do ricochete. | `projectile_mamona.png` |
| PR-04 / Alta | Uma pequena gota de gosma hostil alaranjada/coral com contorno castanho; diferente do ciano de XP, do amarelo de milho e do verde dos inimigos. Usar a família de #061, sem teia ou ferrão. | `projectile_mosca.png` |
| PR-05 / Alta | Gota hostil da mesma família da Mosca, variante da Rainha com núcleo mais claro e borda marcada; não adicionar coroa, feixe ou ataque diferente. | `projectile_rainha_moscas.png` |

O projétil do código atual pode ser compartilhado; variantes de Mosca/Rainha exigem atribuição visual por origem. A fonte #061 já é aprovada para preparação: tentar extrair antes de gerar PR-04/05 novos. Trails curtos podem ser feitos no motor; não precisam de um vídeo por projétil.

### 9.4 XP e perigo

**XP-01 / Alta / `pickup_xp.png`:**

```text
Crie uma única semente de XP rural estilizada: núcleo creme em forma de semente com pequeno broto ciano/verde-azulado, contorno castanho escuro, silhueta diferente de moeda e de fragmentos de morte. Sem aura, brilho suave, chão ou números. Canvas final64×64, forma principal dentro de32×40. Deve continuar reconhecível quando exibida pequena sobre grama, madeira e folhas outonais. Asset estático; pulso e brilho serão feitos no motor.
```

**FB-04 / telegráficos:** não gerar círculos de raio fixo em imagem. Círculo de pouso do chefe, contorno de área e preenchimento translúcido serão feitos no motor com escala real. Cone/faixa só quando existir ataque correspondente. Não desenhar perigos para habilidades ainda não implementadas.

**FB-09 / poça opcional / `fx_puddle_base.png`:**

```text
Crie uma poça decorativa rural de lama em pixel art, vista superior, contorno irregular castanho com pequenas bordas ocres legíveis, interior de baixo contraste e centro parcialmente translúcido. Canvas final256×256, margem livre de24. Sem brilho tóxico, criaturas, texto ou animação incorporada. Deve parecer lama decorativa; um eventual estado perigoso será sinalizado separadamente no motor.
```

Prioridade baixa no estado atual: não há pedido para introduzir dano por poça. Gerar somente após os sinais ativos de combate.

## 10. Interface final — componentes, não telas achatadas

Não pedir ao Flow uma imagem única de lobby/HUD/pausa com texto. As telas já são montadas com Containers e dados reais. Precisamos de peças independentes, esticáveis quando apropriado, com centros livres para texto do Godot.

### UI-01 / UI-02 / UI-03 — barras e joystick

**UI-01 / Alta / `ui_health_frame.png`:**

```text
Crie somente uma moldura fina horizontal de barra de vida, vista frontal, madeira castanha e ferragens discretas iguais ao painel anexado. Canvas final288×64. Borda de até8 pixels, cantos simétricos dentro de regiões de12×12; centro vazado totalmente transparente e faixa interna livre. Nenhum preenchimento de vida, coração, valor, texto, prego no meio ou brilho. Laterais e miolo retos para permitir nove cortes sem deformar cantos. A aparência deve ser leve o bastante para não cobrir o combate.
```

Trilho escuro/fill vermelho serão feitos pelo motor; não gerar dez barras com percentuais diferentes.

**UI-02 / Alta / `ui_xp_frame.png`:**

```text
Crie moldura horizontal muito fina para XP da mesma família da barra de vida anexada, canvas final288×32, borda de4 pixels e cantos dentro de8×8. Centro vazado transparente, região central reta e limpa para esticar. Sem preenchimento fixo, rótulo, número ou símbolo. Deve ocupar menos altura visual que a vida; o fill ciano e o texto de nível serão feitos no jogo.
```

**UI-03A / Alta / `joystick_base.png`:**

```text
Crie somente a base circular de um joystick rural de madeira simplificada, vista frontal, canvas final192×192, círculo perfeitamente centrado em (96,96). Anel fino de madeira com contorno escuro, diâmetro externo176 e interior vazado transparente. Sem manopla, linhas cruzadas, divisórias, letras, setas ou sombra externa. Design discreto para enxergar ameaças pelo miolo; quatro lados simétricos e margem livre.
```

**UI-03B / Alta / `joystick_knob.png`:**

```text
Crie somente a manopla circular do joystick da referência de madeira, vista frontal, canvas final80×80, centro exato (40,40), disco de diâmetro64 com contorno escuro e relevo muito simples. Sem base, hastes, setas, texto ou sombra projetada. Mesma luz e materiais da base aprovada. Margem livre igual nos quatro lados; não deslocar o círculo para simular pressionamento.
```

Estado ativo muda por modulação/escala no motor. Não gerar um joystick inteiro com base e manopla inseparáveis.

### UI-04 — nove símbolos de navegação / Alta

Modelo por símbolo:

```text
Crie um único símbolo de interface para [FUNÇÃO]: [FORMA]. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.
```

| Função | Forma a inserir | Arquivo |
|---|---|---|
| Pausar | duas barras verticais grossas, paralelas, mesmo tamanho | `ui_pause.png` |
| Continuar | triângulo único sólido apontando para a direita | `ui_resume.png` |
| Voltar | seta curta virando para a esquerda, ponta larga | `ui_back.png` |
| Fechar | X de duas diagonais espessas e simétricas | `ui_close.png` |
| Confirmar | visto simples de dois segmentos largos | `ui_confirm.png` |
| Reiniciar | seta circular aberta com uma única ponta clara | `ui_restart.png` |
| Configurações | engrenagem simplificada de seis dentes e miolo vazado | `ui_settings.png` |
| Inventário | mochila rural simples com aba e alça, silhueta forte | `ui_inventory.png` |
| Volume | alto-falante inteiro com uma onda curta, sem recorte na borda | `ui_volume.png` |

Configurações/volume são arte de suporte futura, não autorização para exibir botões sem função. Os botões existentes mantêm rótulos.

### UI-05 / ouro / Alta

```text
Crie uma única moeda canônica do jogo rural: disco dourado quente, contorno castanho, aro simples e um pequeno sabugo de milho gravado no centro. Vista frontal levemente volumétrica, sem inclinação extrema. Canvas128×128, moeda dentro de96×96. Sem letras, números, saco, joias, segunda moeda, brilho intenso ou partículas. Leitura nítida em32,48 e64 pixels, com a mesma paleta em todas as escalas.
```

Arquivo `currency_gold.png`. Uma imagem-fonte, três tamanhos preparados depois. Ouro é saldo permanente; o ícone não introduz coleta física ou moeda premium.

### UI-06 / UI-07 — carta modular / Alta

**Base / `upgrade_card_normal.png`:**

```text
Crie um fundo de carta horizontal de melhoria em pixel art frontal, da mesma família do painel anexado: madeira fina castanha, quatro cantos simples e centro sólido de pergaminho creme quase uniforme. Canvas final384×128, borda até12 pixels, cantos restritos a20×20 e longas regiões retas para nove cortes. Interior limpo, sem desenho de arma, símbolo, coluna, faixa fixa, texto ou números. Sem aparência de raridade. Deve poder virar uma faixa de aproximadamente672×184 na interface, com ícone, nome e atributos desenhados pelo motor.
```

**Selecionada / `upgrade_card_selected.png`:**

```text
Edite somente a carta normal anexada. Conserve canvas, centro e geometria exatos. Indique seleção por borda interna dupla e quatro marcas curtas nos cantos em creme/dourado discreto, visíveis também sem distinguir cores. Não acrescentar estrelas, gemas, texto ou decoração no centro. Não transformar seleção em raridade. Não mudar escala nem espessura externa da carta.
```

**Indisponível:** modulação no motor, sem arquivo novo obrigatório. Não sugerir que cartas atuais têm um estado de bloqueio se o fluxo não o usa.

### UI-08 — slots / Alta

```text
Crie um slot vazio quadrado de equipamento, pixel art frontal, madeira fina e centro pergaminho levemente escurecido, família do painel anexado. Canvas128×128, borda8 pixels, cantos de16×16 para nove cortes, centro útil totalmente livre. Sem cadeado, item, número, letra, estrela ou símbolo de proibição. Slot vazio significa espaço disponível, não conteúdo bloqueado.
```

Arquivo `equipment_slot.png`. Ocupado usa o ícone; selecionado usa borda do motor ou a edição com cantos duplos de UI-07. Badge de nível e números vêm do motor. Não encomendar 24 slots desenhados com itens dentro.

### UI-11 — seis atributos / Média

Modelo: usar UI-04, substituindo cor de destaque somente quando útil e mantendo canvas64×64.

| Atributo | Complemento para a forma do prompt | Arquivo |
|---|---|---|
| Vida máxima | coração simples vermelho com contorno escuro, sem percentual | `stat_health.png` |
| Dano | pequena lâmina de ferramenta sobre um entalhe de impacto, sem sangue | `stat_damage.png` |
| Intervalo de ataque | relógio simples com pequeno movimento circular, sem algarismos nem sinal de mais/menos | `stat_interval.png` |
| Velocidade | bota rural inclinada e duas linhas curtas atrás, sem confundir com ícone de pausa | `stat_speed.png` |
| Defesa | escudo pequeno de tábuas com reforço metálico, sem runas | `stat_defense.png` |
| Coleta | ímã em ferradura envolvendo uma única semente pequena, distinto da moeda | `stat_collection.png` |

Ícone de intervalo não deve significar automaticamente “maior é melhor”; setas e texto vêm dos valores reais.

### UI-12 / UI-13 / UI-14 / UI-15 — peças secundárias

**UI-12 / Média / manopla de configurações / `settings_knob.png`:**

```text
Crie uma pequena manopla circular de madeira para slider de configurações, vista frontal, mesma família dos botões, canvas64×64 e disco central de40 pixels. Pouquíssimos detalhes, contorno firme, sem número, texto, trilho ou cenário. Deve parecer um controle de interface, não moeda. Fundo transparente e margem uniforme.
```

Trilho, preenchimento, toggle on/off, rótulos e persistência serão feitos no motor. Não criar tela de configurações achatada. Produção pode esperar a funcionalidade.

**UI-13 / Média:** abas ativas/inativas e scrollbar reaproveitam madeira/botões e formas do motor; sem geração obrigatória. Se faltarem thumbs próprios, usar `settings_knob.png` como referência e preparar retângulo simples no motor, não uma imagem de tela inteira.

**UI-14 / Alta / `save_seed.png`:**

```text
Crie um pequeno símbolo neutro de gravação: uma semente creme dentro de um aro aberto castanho, pixel art frontal, canvas64×64, desenho dentro de40×40. Não desenhar visto, cruz, texto, moeda ou promessa de sucesso. Centro e peso visual estáveis para rotação do aro no motor. Poucos detalhes e fundo transparente.
```

Spinner: rotação no motor; sucesso/erro usam visto/X e mensagem. Uma animação de save não pode indicar conclusão antes da gravação.

**UI-15 / Média / `cost_plate.png`:**

```text
Crie uma pequena placa horizontal vazia de pergaminho com duas presilhas de madeira discretas, canvas192×64, centro limpo e claro, cantos preserváveis por nove cortes. Sem moeda, valor, cadeado, estrelas ou texto. Mesma paleta do painel rural, sem sombra projetada. Será usada atrás de custo ou estado textual.
```

Cadeado já existe em `map_locked.png`; avaliar recorte/reuso antes de gerar outro. “Saldo insuficiente” e “Nível máximo” são texto, não pictogramas embutidos.

### UI-09 / UI-10 — tipografia e comparações

**Não gerar fonte por imagem no Flow.** Selecionar fonte com licença de uso no jogo, arquivo TTF/OTF e suporte a `á à â ã é ê í ó ô õ ú ü ç Á Ç 0123456789 , . % + − × →`. Título rústico moderado e corpo aberto/legível. Fonte continua sendo pendência de seleção/licença, não um prompt que produz um atlas confiável.

Setas, mais/menos, check e indicador de nível máximo serão texto/vetor/forma do motor. Não gerar imagens contendo “1 → 2”, dano ou cooldown.

## 11. Vitória, derrota e aviso de chefe

**FB-01 / Média / `result_victory_emblem.png`:**

```text
Crie um pequeno emblema de colheita concluída: broto vigoroso com duas folhas e um visto simples apoiados numa peça pequena de madeira, coerente com o emblema rural anexado. Pixel art frontal, canvas256×256, forma dentro de192×192, sem texto, moeda, coroa de raridade ou números. Expressão de conquista rural, sem pôster de fundo. Legível quando exibido a160 pixels.
```

**FB-02 / Média / `result_defeat_emblem.png`:**

```text
Crie um pequeno emblema de fim de tentativa: chapéu castanho do Fazendeiro apoiado ao lado de uma ferramenta rural simples, composição acolhedora e serena. Pixel art frontal, mesma família do emblema rural, canvas256×256, forma dentro de192×192. Sem corpo ferido, túmulo, sangue, moeda riscada, texto ou cenário. Não sugerir que o progresso permanente foi apagado. Fundo transparente.
```

**FB-03 / Alta / `boss_warning_icon.png`:**

```text
Crie um símbolo compacto de ameaça para entrada de chefe: rosto de praga genérica em um medalhão de madeira rústica, inspirado no medalhão hostil anexado, contorno firme e pequeno acento vermelho. Canvas128×128, margem12 pixels. Deve ser distinto de vitória e cadeado. Sem nome, barra, número, letras ou tela de aviso. Evitar caveira realista e gore.
```

O medalhão hostil já disponível pode atender FB-03 sem geração; revisar antes. Barra do chefe reutiliza UI-01 com nome no motor. Anúncio não atravessa cartas/modais. Créditos/recompensa são animados no código só após save; não pedir tela de vitória com “+50” desenhado.

## 12. Pisos, variações e decoração

### AM-01 — chão do Celeiro / Alta

```text
Crie uma textura de piso de celeiro rural em pixel art, vista superior ortogonal, tile quadrado repetível nas quatro direções. Tábuas castanhas dessaturadas com pouca palha, juntas finas e discretas, baixo contraste e iluminação uniforme. Paleta coerente com a madeira do jogo, porém mais apagada que a interface. Canvas final256×256. Bordas esquerda/direita e superior/inferior devem encaixar sem degrau; evitar linhas largas atravessando o tile, cruz de emenda, vinheta e manchas memoráveis. Sem objetos, paredes, texto, sombras de cenário ou moldura. Deve deixar pragas marrons e projéteis claros visíveis.
```

Arquivo `ground_celeiro_base.png`. Escolha desta encomenda: tábuas discretas, mantendo identidade de Celeiro. Se não passar no teste de repetição, corrigir a base antes de gerar variantes.

### AM-02 — chão do Pomar / Alta

```text
Crie textura de chão de pomar ao entardecer em pixel art, vista superior ortogonal, tile quadrado repetível nas quatro direções. Terra ocre dessaturada com poucas folhas outonais pequenas e distribuídas sem desenho repetitivo. Baixo contraste, iluminação uniforme, nenhuma mancha dominante, árvore, fruto grande ou sombra. Canvas final256×256, bordas perfeitamente contínuas. Tons quentes subordinados aos inimigos e projéteis; sem vinheta, faixas, moldura, caminho fixo ou texto. Estilo do mapa e props de Pomar anexados, com menos detalhe para o combate.
```

Arquivo `ground_pomar_base.png`.

### AM-03 — duas variantes por mapa / Média

Copiar para cada base aprovada, gerando `ground_<horta|celeiro|pomar>_var01.png` e `_var02.png`:

```text
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.
```

As variantes só entram se passarem tanto repetição própria quanto mistura com a base; manter borda idêntica é um pedido, não garantia da IA.

### AM-04 — props aprovados / preparar, não redesenhar

Kits #092/093/095 já aprovados. A primeira tarefa é separar objetos, preparar alpha, marcar pivô na base e uniformizar escala. Caso um recorte específico falhe, usar:

```text
Reproduza somente o objeto [OBJETO] do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.
```

| Mapa | Objetos a recortar primeiro | Canvas final de referência |
|---|---|---|
| Horta | cerca, canteiro, couve, espantalho | 128×128; espantalho128×192 |
| Celeiro | feno, barril, caixa, saco, roda | 128×128 |
| Pomar | árvore, cesto, folhas, escada | árvore256×256; demais128×128 ou128×192 |

Entregar um objeto por arquivo `prop_<mapa>_<objeto>.png`, pivô na base. Sem criar colisão automática em decoração; folhagem não deve esconder jogador/inimigo. Sombras, se desejadas depois, são camada separada, gerada no motor ou arquivo independente.

## 13. Marca, aplicativo e carregamento

**BR-01 — título:** nome do jogo composto com fonte licenciada sobre/ao lado do emblema existente. Não pedir à IA para escrever o título na textura. Emblema já aprovado, sem nova geração necessária.

**BR-02A / Média / `app_icon_foreground.png`:**

```text
Crie um ícone de aplicativo de jogo rural em pixel art usando exatamente o rosto e chapéu do Fazendeiro canônico anexado, expressão determinada e simpática. Busto compacto central, contorno escuro forte, cores da camisa azul e chapéu castanho; sem texto, letras, números, foice saindo do quadro ou detalhes minúsculos. Canvas quadrado final1024×1024; todo conteúdo essencial dentro do círculo central de diâmetro600, centro(512,512), com margem ampla para recortes variados. Fundo transparente para preparar camada adaptativa separada. Não arredondar os cantos do arquivo nem desenhar mockup de celular.
```

**BR-02B / fundo do ícone / `app_icon_background.png`:**

```text
Crie somente um fundo quadrado opaco de baixo detalhe para ícone rural: verde-oliva dessaturado com leve textura pixelada quase uniforme, sem vinheta, personagem, objeto, palavra, moldura ou cantos arredondados. Canvas final1024×1024. Deve contrastar com chapéu castanho e camisa azul do ícone anexado e funcionar sob máscaras variadas de launcher.
```

Esses canvases são arquivos de produção; a área segura final será conferida nas máscaras do exportador Android, sem presumir que a IA gera um pacote adaptativo pronto.

**BR-02C / splash:** reaproveitar emblema aprovado e título do motor; fundo sólido do tema. Barra/indicador animado no motor. Só pedir ilustração nova se houver decisão posterior de tela ilustrada; não bloquear integração por uma splash cinematográfica.

## 14. Conteúdo futuro — produzir somente depois do pacote ativo

Prioridade baixa. Arte existente de rato, barata e abelha não significa que esses inimigos estejam no `EnemyDB` atual. Aranha, Besouro, Formiga e Grilo também não estão ativos. Estes prompts preservam o backlog, mas não autorizam novas mecânicas.

Modelo de pose futura:

```text
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.
```

| Criatura | Complemento específico | Trabalho necessário |
|---|---|---|
| Aranha | Corpo escuro e olhos claros da fonte #003, patas simplificadas e legíveis. | Corrigir teia voltada para trás; teia só em pedido separado após definir ataque |
| Besouro | Carapaça azul-escura da fonte #019, patas curtas e postura baixa consistente. | Não misturar pose erguida com caminhada |
| Formiga | Corpo segmentado quente da fonte #054, antenas e seis patas estáveis. | Separar caminhada e morte da folha irregular |
| Grilo | Silhueta própria da fonte #070, distinta do Gafanhoto Saltador ativo. | Onda/poeira separadas; ataque ainda depende de design |
| Abelha | Corpo amarelo/preto e asas claras da fonte #002. | Preparar fonte já aprovada antes de gerar novo |
| Barata | Corpo achatado e antenas da fonte #016, sem pose de dash no idle. | Preparar fonte aprovada; dash só se mecânica aprovada |
| Rato | Corpo marrom, cauda longa e orelhas claras da fonte #103. | Preparar fonte aprovada e conferir contraste no Celeiro |

Se forem aprovados como conteúdo, usar EN-IDLE/EN-WALK/EN-DEATH com a pose própria; ataque só após especificação de comportamento. Não encomendar animações que prometam teia, dash ou ferrão enquanto não houver decisão de implementação.

**BR-03 / cosméticos:** sem prompt de produção agora. Não há lista aprovada de skins ou quarto personagem. Modelo para uso futuro, após definição de conteúdo:

```text
Crie uma variante cosmética do personagem canônico anexado alterando SOMENTE [ALTERAÇÃO APROVADA]. Preserve rosto, anatomia, perspectiva, escala, pivô, silhueta de leitura e todos os demais elementos. Não introduzir arma, habilidade ou outro personagem. Produza primeiro uma pose neutra isolada, sem texto, para aprovação antes de animar.
```

## 15. Matriz de cobertura do backlog original

Todos os 48 IDs têm encaminhamento abaixo. “Motor” e “Preparar” são soluções válidas para a pendência; não significam que cada ID exige uma nova imagem da IA.

| ID original | Encaminhamento neste documento | Situação de produção |
|---|---|---|
| UI-01 | §10 barra de vida | Gerar moldura; fill/trilho no motor |
| UI-02 | §10 barra de XP | Gerar moldura; fill no motor |
| UI-03 | §10 joystick A/B | Gerar duas peças separadas |
| UI-04 | §10 símbolos | Gerar/corrigir nove ícones |
| UI-05 | §10 ouro | Uma moeda canônica |
| UI-06 | §10 carta | Fundo modular horizontal |
| UI-07 | §10 estados da carta | Seleção opcional por imagem; estados no motor |
| UI-08 | §10 slots | Base vazia; conteúdo/nível no motor |
| UI-09 | §10 tipografia | Selecionar/licenciar fonte, sem IA raster |
| UI-10 | §10 comparações | Texto/vetor no motor |
| UI-11 | §10 atributos | Seis símbolos |
| UI-12 | §10 configurações | Manopla opcional, funcionalidade posterior |
| UI-13 | §10 scroll/abas | Reaproveitar estilos/motor |
| UI-14 | §10 gravação | Semente opcional; estado real no código |
| UI-15 | §10 custo/bloqueio | Placa opcional, cadeado existente e texto |
| IT-01 | §8 Foice | Três ícones isolados |
| IT-02 | §8 Forquilha | Três ícones isolados |
| IT-03 | §8 Canhão | Níveis1/2, nível3 existente |
| IT-04 | §8 Milho | Níveis1/3, nível2 existente |
| IT-05 | §8 Mamona | Nível1, níveis2/3 existentes |
| IT-06 | §8 Motosserra | Nível1, níveis2/3 existentes |
| IT-07 | §8 Cerca | Três ícones; energia separada em §9 |
| IT-08 | §1/§8 passivos/upgrades | Oito recortes já integrados; sem geração |
| IT-09 | §7 Bezerro | Três ícones existentes; ciclos novos |
| CH-01 | §5 retratos | Vovó prioritária; demais opcionais |
| CH-02 | §5 Fazendeiro | Pose, idle, walk e death |
| CH-03 | §5 Vovó | Pose canônica e três estados coerentes |
| CH-04 | §5 Netinho | Pose e três estados coerentes |
| CH-05 | §7 companheiro | Idle/walk/contato por nível |
| FB-01 | §11 vitória | Emblema opcional sem texto |
| FB-02 | §11 derrota | Emblema sem texto |
| FB-03 | §11 chefe | Reusar medalhão ou símbolo novo; barra modular |
| FB-04 | §9 perigo | Geometria no motor, conforme ataques ativos |
| FB-05 | §9 FX-01 | Impacto; flash/shake no motor |
| FB-06 | §9 armas/projéteis/FX | Corpos e partículas separados |
| FB-07 | §6 morte + §9 FX-08 | Estado visual independente do pool |
| FB-08 | §9 XP/FX-09/10 | Pickup + coleta + evolução |
| FB-09 | §9 FX-11/poça | Pouso ativo; poça decorativa opcional |
| FB-10 | §9 FX-12 | Motor ou brilho opcional após save |
| AM-01 | §12 Celeiro | Base repetível corrigida |
| AM-02 | §12 Pomar | Base repetível corrigida |
| AM-03 | §12 variantes | Duas por mapa, após bases aprovadas |
| AM-04 | §12 props | Preparar três kits aprovados |
| EN-01 | §6 pragas ativas | Corrigir e completar sete famílias reais |
| EN-02 | §14 criaturas futuras | Propostas, não integrar como inimigos ativos |
| BR-01 | §13 título | Composição tipográfica no motor |
| BR-02 | §13 app/splash | Ícone em camadas, splash reaproveitada |
| BR-03 | §14 cosméticos | Aguardar definição de conteúdo |

## 16. Ordem prática para gerar sem retrabalho

| Lote | Entrega | Critério antes do próximo lote |
|---|---|---|
| 1 | Três poses canônicas + retrato Vovó | Identidade, perspectiva e escala aprovadas lado a lado |
| 2 | Idle/walk/death dos três personagens | Pés estáveis e transição entre estados sem salto |
| 3 | Pulgão, Mosca, Rainha e Gafanhoto Gigante; depois correções Lesma/Lagarta/Gafanhoto | Todos os sete IDs ativos com corpo legível; estados conforme comportamento |
| 4 | Quinze ícones faltantes de armas | Famílias de três níveis completas e corretamente associadas |
| 5 | Projéteis hostis, XP, impacto e pouso de chefe | Leitura de ameaça e coleta sobre três terrenos |
| 6 | Pisos Celeiro/Pomar e cortes de props | Repetição2×2/4×4 e contraste em combate |
| 7 | Barras, joystick, navegação, moeda, carta e slots | Componentes se encaixam no layout existente sem ocupar conteúdo |
| 8 | Companheiros por nível, efeitos de armas e emblemas | Efeitos acompanham ações reais, sem duplicar corpos |
| 9 | Ícone de aplicativo e opcionais | Identidade final e recortes de launcher conferidos |

Não é necessário gerar tudo para começar a integrar. Entregas pequenas por lote permitem corrigir escala e identidade antes de gastar créditos em dezenas de sequências.

## 17. Como me entregar para implementação

Estrutura sugerida **fora de `art/` até aprovação**, para preservar originais:

```text
entrega_flow/
  lote_01_personagens/
    fazendeiro/
      originais/
      fazendeiro_reference_right.png
      fazendeiro_idle_right_00.png
      fazendeiro_idle_right_01.png
      ...
      asset.json
    vovo/
    netinho/
  lote_02_inimigos/
  lote_03_itens/
  lote_04_ui/
  lote_05_cenarios/
  lote_06_fx/
```

O número do lote da pasta é apenas organização de envio; relacionar os IDs no manifesto. Arquivos grandes originais, prompts usados e vídeos ficam preservados em `originais/`. Não colocar vídeos de referência dentro do runtime sem necessidade.

Exemplo de `asset.json` **para uma sequência já preparada em quatro PNGs de128×128**; adaptar aos arquivos reais, não declarar alpha/dimensões por suposição:

```json
{
  "backlog_id": "CH-02",
  "request_id": "CH-F-01",
  "entity_id": "fazendeiro",
  "state": "idle",
  "direction": "right",
  "source_type": "png_sequence",
  "canvas_px": [128, 128],
  "anchor_px": [64, 112],
  "fps_proposed": 4,
  "loop": true,
  "event_frame": null,
  "background": "alpha_verified",
  "frames": [
    "fazendeiro_idle_right_00.png",
    "fazendeiro_idle_right_01.png",
    "fazendeiro_idle_right_02.png",
    "fazendeiro_idle_right_03.png"
  ],
  "reference": "char_fazendeiro.png",
  "notes": "Corpo sem arma; sombra separada; valores visuais propostos."
}
```

Se vier vídeo, usar `source_type: video`, informar o nome do vídeo e fundo real nas notas; campos de canvas, frames, anchor e FPS final ficam pendentes de preparação. O JSON é um manifesto de produção, **não um formato já carregado pelo jogo**.

### Checklist antes de enviar

- [ ] ID, personagem/item, nível e estado informados.
- [ ] Uma imagem neutra aprovada usada como referência para a família inteira.
- [ ] Sem texto, números de quadro, watermark visível, xadrez ou cenário incorporado.
- [ ] Transparência real conferida ou cor do fundo opaco informada.
- [ ] Mesmo canvas, escala e âncora em todos os quadros; partes não cortadas.
- [ ] Ordem dos quadros, loop e FPS propostos informados; impacto/soltura identificados quando houver.
- [ ] Nada de arma incorporada ao corpo ou rastro fundido ao projétil.
- [ ] Ícones testados pequenos e criaturas sobre terreno claro/escuro.
- [ ] Pisos testados em mosaico2×2 e4×4, inclusive misturando variantes.
- [ ] Originais preservados; PNGs preparados separados das saídas do Flow.

## 18. Regras para a futura integração no Godot

1. Importar com filtro nearest para pixel art e preservar originais; recorte/alpha/normalização em cópias de produção. Não usar remoção de fundo que apague focinho, olhos, fio elétrico ou partícula.
2. Aplicar offset visual para mapear o ponto de apoio ao nó do mundo; não recentralizar cada frame por sua caixa opaca. A cena atual usa `Sprite2D` centralizado e exigirá ajuste de pivô/offset na ligação das animações.
3. Vincular personagem ao ID selecionado e armas/inventário ao nível real. Arquivo de nível2 não substitui nível1.
4. Animação e eventos visuais acompanham o estado/timer existente. Não mudar dano, alcance, cooldown, salto ou economia para encaixar vídeos. Deadlines de combate não dependem de sinal `animation_finished` de arte externa.
5. Congelar animações de gameplay com a pausa; transições de UI continuam apenas quando apropriado. Respeitar `PauseManager` e seus donos de modal.
6. Morte desativa colisão/alvo imediatamente; visuais podem continuar num efeito independente. Pool deve limpar frame, direção, tint, timers e referências antes da reutilização. Efeito visual não concede XP/moeda novamente.
7. Raio/forma de colisão vêm dos dados atuais, nunca do tamanho do PNG. Conferir correspondência visual sem redimensionar hitboxes compartilhadas.
8. Renderizar textos, níveis, preços, barras e comparações no motor. Aplicar nove cortes e revisar cantos em tamanhos reais; a IA não certifica a geometria.
9. Validar leitura nas quatro resoluções já usadas pela UI e depois em Android físico; inspecionar alpha, memória de texturas, quantidade de quadros e simultaneidade de efeitos.
10. Reexecutar as suítes de estabilidade/interface após ligar estados e testar runs consecutivas, pausa sobreposta, morte, vitória/endless e reutilização. Registrar cada asset integrado e o que precisou de correção.

Este documento não substitui o ZIP entregue anteriormente. As novas artes só entram no projeto depois de recebidas e revisadas; não foram geradas por este pedido.
