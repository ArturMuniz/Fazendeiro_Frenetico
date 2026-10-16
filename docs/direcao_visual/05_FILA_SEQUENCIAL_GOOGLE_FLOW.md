# Fila sequencial de geração de sprites — Google Flow

O Fazendeiro Frenético · 16/10/2026.

Este arquivo transforma o [guia de prompts](04_PROMPTS_GOOGLE_FLOW.md) numa fila concreta: **198 pedidos numerados**, com 148 pedidos no pacote principal e 50 condicionais/reserva. Alguns pedidos pedem recorte/reutilização ou um conjunto de quadros; não são 198 imagens obrigatoriamente novas.

## Como entregar este arquivo à IA

Forneça este Markdown e as referências visuais. Use o comando-mestre abaixo. Se a interface aceitar somente texto, copie o comando-mestre e execute os pedidos em ordem, em lotes que caibam no contexto. Cada bloco de pedido já tem objeto, estado e nome preenchidos; não é necessário combinar tabelas do guia anterior.

Este arquivo é uma especificação para execução sequencial, não um script que adiciona geração em lote ao Flow. A quantidade de saídas por interação, formatos e uso de referências dependem da ferramenta disponível. Quando a interface exigir uma nova ação de gerar, use o pedido seguinte. O [guia técnico](04_PROMPTS_GOOGLE_FLOW.md) mantém os detalhes de exportação e integração.

## Comando-mestre — copiar com a fila

```text
Você é o artista de produção de sprites do jogo O Fazendeiro Frenético. Execute a fila numerada deste documento na ordem, produzindo os arquivos visuais solicitados com as ferramentas de imagem disponíveis. Comece no pedido001. Não substitua a tarefa por análise, resumo ou novos prompts.

Mantenha as regras de estilo abaixo e reutilize as referências fornecidas. Crie um único asset ou uma única animação por pedido; não junte diferentes personagens, níveis ou estados numa grande colagem. Animações podem ser entregues como PNGs sequenciais ou uma folha regular exclusiva daquele estado. Não gerar vídeo por padrão: priorize imagens com poses discretas. Vídeo só como fonte alternativa, identificado como tal.

Finalize e confira o pedido atual antes de avançar. Não solicite confirmação entre os pedidos rotineiros. Caso uma pose canônica apresente mudança de identidade, partes cortadas ou estilo diferente, corrija antes de animá-la. Não afirme ter validado alpha, dimensões ou grade se não conseguir inspecionar os arquivos.

Se uma referência indispensável estiver ausente, registre PENDENTE_REFERENCIA e prossiga apenas com os pedidos independentes. Não invente o personagem nem use uma fonte de outro nível. Se a ferramenta não permitir gerar ou exportar imagens, informe essa limitação; não simule arquivos, links ou conclusão.

Pedidos PREPARAR/REUTILIZAR usam as fontes existentes: extraia ou reutilize quando suas ferramentas permitirem. Gere substituição somente se a extração falhar. Não refaça assets prontos por padrão.

Execute o pacote principal até o final. Depois registre os condicionais e a reserva. Só execute um condicional se a condição descrita acontecer. Criaturas futuras ficam fora do lote ativo e da integração até decisão de conteúdo. Não alterar gameplay para justificar a arte.

Ao atingir limite de ferramenta/contexto, salve ou informe o último pedido concluído e o próximo número. Na próxima interação, retome dali com as mesmas referências, sem refazer o lote anterior. Nunca declare que produziu toda a fila se só concluiu uma parte.

Após cada pedido, mantenha um registro textual externo à imagem: número, nomes reais dos arquivos, estado GERADO/PREPARADO/REUTILIZADO/PENDENTE, referência usada e problemas. Nunca desenhe esse registro dentro do sprite. Ao final de cada lote, apresente as imagens/arquivos reais disponíveis e o ponto de retomada. Só crie ZIP se a ferramenta puder empacotar as saídas reais.
```

## Estilo obrigatório para toda a fila

```text
Crie um asset de produção para o jogo independente brasileiro “O Fazendeiro Frenético”, um jogo 2D de sobrevivência rural com combate automático. Use as imagens anexadas como referência obrigatória de identidade, proporções, perspectiva, materiais e acabamento.

Estilo: pixel art artesanal, simpático e expressivo, contornos castanho-escuros firmes, pixels nítidos e agrupados, silhuetas simples, detalhes suficientes para leitura em celular. Sombreamento em poucos tons, luz suave vinda do alto à esquerda. Preserve exatamente o rosto, a roupa, os acessórios e a escala da referência da família. Não invente outro personagem.

Para personagens e criaturas: vista de jogo 2D oblíqua rasa, compatível com a referência do Fazendeiro, rosto/corpo levemente voltados ao observador e direção principal para a direita. A arte é um recorte para um mundo visto de cima; não é uma cena de plataforma com horizonte. Para interface: vista frontal, sem perspectiva inclinada. Para pisos: vista superior ortogonal.

Materiais da interface: madeira castanha #704426, contorno #281D17, pergaminho creme #F1E2BF e texto futuro #2B2118. Vermelho #BC4036 para vida/ameaça, ciano #429DA6 para XP/energia aliada, ouro quente #E7B94C para a única moeda. São guias, preserve as relações tonais das referências anexadas.

Asset isolado, composição limpa, sem letras, números, logotipos, legendas, marca-d'água, grade ou borda de folha. Nenhum texto faz parte da imagem. Não desenhe xadrez de transparência. Não desenhe cenário, horizonte, chão ou sombra projetada junto ao sprite. Preserve margem livre em todos os lados. Não cortar pontas, chapéu, asas, antenas, ferramentas ou partículas.

Evitar: render 3D, fotografia, pintura com pinceladas, vetor liso, realismo, blur, anti-aliasing suave, bloom, glow intenso, microtexturas, partículas magenta, perspectiva variável, anatomia variável, membros duplicados, arma fundida no corpo e acabamento diferente entre quadros.
```

**Exceções necessárias:** pisos são imagens opacas, contínuas e sem sombra/vinheta; fundo do ícone de aplicativo também é opaco. As demais peças são isoladas. Transparência real quando suportada; caso contrário, cor plana ausente na paleta do asset e registrada no relatório. Nunca desenhar xadrez. Evitar chave verde em roupa/folhagem verde, azul em roupa azul e magenta junto a focinho rosa. A cor do fundo é escolhida por asset, não uma cor universal.

**Animações:** direção direita, sem deslocamento horizontal no canvas, câmera fixa, mesma escala/iluminação e ponto de apoio entre quadros. PNGs preferidos; folha alternativa com uma linha de células de tamanho idêntico, ordem esquerda→direita, sem divisórias ou números. Se a grade sair irregular, marcar para preparação. Os FPS abaixo são propostas de reprodução no Godot e não um pedido de vídeo com FPS exato. Em morte, preservar o último quadro; em salto, o tempo vem da mecânica existente.

**Referências:** nomes `art/ui_rural/...` referem-se ao projeto local. Fontes originais numeradas estão no inventário da auditoria e na pasta de sprites. Um caminho escrito não anexa a imagem ao Flow: Artur deve fornecer os arquivos correspondentes. Saídas anteriores viram referências apenas quando realmente geradas e conferidas.

## Assets prontos que devem ser reaproveitados

O manifesto `art/ui_rural/manifest.json` contém os29 PNGs preparados. Reaproveitar mapa, emblema, painel, três botões, quatro medalhões, cinco passivos, três upgrades, dois recortes de personagens e nove ícones de armas. Isso não cobre automaticamente os estados animados.

Ícones prontos: Bezerro1/2/3, Batata3, Mamona2/3, Milho2, Motosserra2/3. Textos, níveis, comparações, fill de barras, contador, foco, overlay, flash de dano, telegráficos geométricos e tipografia licenciada ficam no motor. Não produzir imagens com números ou nomes fixos.

## Índice de execução

| Faixa | Grupo | Pedidos |
|---|---|---|
| 001–015 | 01 — Personagens jogáveis | 15 |
| 016–051 | 02 — Sete inimigos ativos | 36 |
| 052–063 | 03 — Companheiros | 12 |
| 064–078 | 04 — Quinze ícones de armas faltantes | 15 |
| 079–084 | 05 — Projéteis e XP | 6 |
| 085–096 | 06 — Efeitos de combate | 12 |
| 097–125 | 07 — Interface | 29 |
| 126–146 | 08 — Cenários | 21 |
| 147–148 | 09 — Identidade do aplicativo | 2 |
| 149–169 | 10 — Condicionais: corpos de armas | 21 |
| 170–170 | 11 — Condicionais: decoração | 1 |
| 171–198 | 12 — Reserva: criaturas futuras | 28 |


### Pedido 001 — Fazendeiro Clássico — pose canônica

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/char_fazendeiro.png + fonte original #001 — 1.1 Idle — 2 a 4 frames.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fazendeiro_reference_right.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 001. Siga o estilo obrigatório e as referências desta fila.
Reproduza fielmente o Fazendeiro jovem da referência pixelada: mesmo rosto, chapéu castanho de aba larga, camisa xadrez azul, jeans e botas marrons. Corpo inteiro, levemente em três quartos voltado para a direita, postura atenta e simpática. Mãos livres e legíveis, sem foice, arma, sombra ou chão incorporado. Preserve o visual atual; não adicionar barba nem trocar a roupa. Canvas final previsto 128×128, pés alinhados a (64,112), aproximadamente 104 pixels de altura incluindo o chapéu. Uma única pose isolada.

Entrega: Um PNG estático ou pose única. Nome de destino: fazendeiro_reference_right.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 002 — Fazendeiro Clássico — descanso

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: fazendeiro_reference_right.png.
- Dependências: 001.
- Saída: `fazendeiro_idle_right_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 4. Loop: sim.

```text
Pedido 002. Siga o estilo obrigatório e as referências desta fila.
Usando exatamente a pose canônica do Fazendeiro anexada, produza um ciclo de descanso atento com quatro poses: neutro, inspiração muito discreta, retorno ao neutro e expiração discreta com um piscar de olhos. Pés imóveis, chapéu quase imóvel, cabeça e tronco variam no máximo dois pixels na escala final. Sem acenar, cultivar ou empunhar arma. Mesmo canvas e apoio em todos os quadros; ciclo contínuo sem salto. Entrega preferida: quatro PNGs separados, ordem temporal 00 a 03. Não desenhar os números.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fazendeiro_idle_right_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 003 — Fazendeiro Clássico — caminhada

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: fazendeiro_reference_right.png.
- Dependências: 001.
- Saída: `fazendeiro_walk_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 8. Loop: sim.

```text
Pedido 003. Siga o estilo obrigatório e as referências desta fila.
Anime o Fazendeiro canônico caminhando para a direita no lugar, em seis poses sequenciais: contato pé direito à frente, descida, passagem, contato pé esquerdo à frente, descida oposta, passagem oposta. Braços livres alternam discretamente, sem trocar acessórios ou roupa. Pés continuam ligados à mesma linha de apoio; nenhum deslocamento horizontal do corpo no canvas. Movimento compacto e legível, sem escorregar, saltar ou correr exageradamente. Cabeça e chapéu conservam tamanho. Seis quadros separados com canvas idêntico, sem números, sem rastro ou poeira.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: fazendeiro_walk_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 004 — Fazendeiro Clássico — morte

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: fazendeiro_reference_right.png.
- Dependências: 001.
- Saída: `fazendeiro_death_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 8. Loop: não.

```text
Pedido 004. Siga o estilo obrigatório e as referências desta fila.
Crie a sequência não repetitiva de derrota do mesmo Fazendeiro, sem sangue: 00 surpresa breve, 01 perde o equilíbrio, 02 dobra os joelhos, 03 cai de lado para a direita, 04 acomoda o corpo, 05 repousa imóvel. Expressão cartunesca respeitosa. Manter rosto, roupa e chapéu reconhecíveis; chapéu permanece junto ao corpo, sem voar para fora do canvas. Não gerar fantasma, moeda, XP, texto, partículas ou tela de derrota. Preserve a âncora original no chão e deixe o corpo cair dentro do mesmo canvas, sem recentralização por quadro. Seis PNGs individuais.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: fazendeiro_death_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 005 — Fazendeiro Clássico — retrato

- Grupo: 01 — Personagens jogáveis.
- Ação: **REFINAMENTO OPCIONAL**.
- Referência a anexar: fazendeiro_reference_right.png.
- Dependências: 001.
- Saída: `portrait_fazendeiro.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 005. Siga o estilo obrigatório e as referências desta fila.
Crie um retrato pixel art de Fazendeiro Clássico usando a pose canônica anexada. Mesmo rosto, roupa e acessórios, expressão determinada e simpática. Enquadrar cabeça e parte superior do tronco, sem cortar chapéu ou boné. Vista em três quartos compatível com o sprite. Sem ferramenta, moldura, fundo, texto ou números. Canvas quadrado final 256×256 com margem mínima de 24 pixels. Leitura clara quando reduzido a 96 pixels; não converter o personagem em ilustração pintada nem adicionar detalhes ausentes no sprite.

Entrega: Um PNG estático ou pose única. Nome de destino: portrait_fazendeiro.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 006 — Vovó Resistente — pose canônica

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: fonte original #112 — vovoresistente-andando.jpg + art/ui_rural/char_fazendeiro.png para perspectiva.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `vovo_reference_right.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 006. Siga o estilo obrigatório e as referências desta fila.
Crie a Vovó Resistente a partir da referência anexada: senhora rural de óculos, chapéu e avental verde, mesma identidade facial e mesmos acessórios do sprite original. Adapte a perspectiva à do Fazendeiro anexado: corpo inteiro em três quartos levemente voltado para a direita, contorno e densidade de pixels equivalentes, proporção compacta e expressão determinada e acolhedora. Mãos livres, sem motosserra, plantio, sombra ou chão. Canvas final previsto 128×128, pés em (64,112), altura visual próxima de 96–104 pixels incluindo chapéu. Não transformar em jovem, bruxa ou caricatura frágil. Uma única pose neutra.

Entrega: Um PNG estático ou pose única. Nome de destino: vovo_reference_right.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 007 — Vovó Resistente — descanso

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: vovo_reference_right.png.
- Dependências: 006.
- Saída: `vovo_idle_right_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 4. Loop: sim.

```text
Pedido 007. Siga o estilo obrigatório e as referências desta fila.
Anime somente a Vovó canônica aprovada em quatro poses de descanso atento: respiração mínima no tronco, piscar breve e avental movendo no máximo dois pixels. Ambos os pés permanecem fixos; óculos, chapéu, rosto e comprimento do avental não mudam. Não plantar, regar, acenar ou usar arma. Mesmo enquadramento, mesma linha de apoio e mesma orientação para a direita. Quatro quadros separados para loop contínuo, sem texto.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: vovo_idle_right_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 008 — Vovó Resistente — caminhada

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: vovo_reference_right.png.
- Dependências: 006.
- Saída: `vovo_walk_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 8. Loop: sim.

```text
Pedido 008. Siga o estilo obrigatório e as referências desta fila.
Anime a Vovó canônica andando para a direita no lugar em seis poses de passos curtos e firmes, alternando contato, descida e passagem dos dois pés. O avental acompanha discretamente o movimento, sem mudar de forma ou comprimento. Manter anatomia, óculos e chapéu estáveis; braços livres, sem arma. Movimento confiante e compacto, sem tropeços durante o loop, sem chão ou sombra. Pés alinhados à linha de apoio; nenhum deslocamento horizontal no arquivo. Seis quadros separados.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: vovo_walk_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 009 — Vovó Resistente — morte

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: vovo_reference_right.png.
- Dependências: 006.
- Saída: `vovo_death_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 8. Loop: não.

```text
Pedido 009. Siga o estilo obrigatório e as referências desta fila.
Crie uma derrota cartunesca e sem violência gráfica da Vovó canônica: surpresa, desequilíbrio, joelhos cedendo, queda suave de lado, acomodação e repouso. Seis poses, nessa ordem. Preservar dignidade e identidade, óculos e chapéu; nada de túmulo, fantasma, sangue ou texto. Corpo caído permanece dentro do mesmo canvas com a âncora do chão preservada; não adicionar uma sombra diferente por pose. Não repetir nem levantar no final.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: vovo_death_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 010 — Vovó Resistente — retrato

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: vovo_reference_right.png.
- Dependências: 006.
- Saída: `portrait_vovo.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 010. Siga o estilo obrigatório e as referências desta fila.
Crie um retrato pixel art de Vovó Resistente usando a pose canônica anexada. Mesmo rosto, roupa e acessórios, expressão determinada e simpática. Enquadrar cabeça e parte superior do tronco, sem cortar chapéu ou boné. Vista em três quartos compatível com o sprite. Sem ferramenta, moldura, fundo, texto ou números. Canvas quadrado final 256×256 com margem mínima de 24 pixels. Leitura clara quando reduzido a 96 pixels; não converter o personagem em ilustração pintada nem adicionar detalhes ausentes no sprite.

Entrega: Um PNG estático ou pose única. Nome de destino: portrait_vovo.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 011 — Netinho Ágil — pose canônica

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/char_netinho.png + fonte original #088 — netinhoagil-andando.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `netinho_reference_right.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 011. Siga o estilo obrigatório e as referências desta fila.
Reproduza o Netinho da referência pixelada: menino rural ágil, boné vermelho, roupa azul e mesmo rosto/acessórios do sprite aprovado. Corpo inteiro em três quartos para a direita, mãos livres, postura alerta e levemente inclinada para a frente. Densidade de pixels e contorno iguais aos do Fazendeiro, com silhueta infantil própria, sem tornar adulto. Canvas final previsto 128×128, pés em (64,112), altura aproximada 88–96 pixels incluindo boné. Sem estilingue, arma, cenário ou sombra. Uma única pose neutra.

Entrega: Um PNG estático ou pose única. Nome de destino: netinho_reference_right.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 012 — Netinho Ágil — descanso

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: netinho_reference_right.png.
- Dependências: 011.
- Saída: `netinho_idle_right_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 5. Loop: sim.

```text
Pedido 012. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de descanso atento do Netinho canônico: respiração sutil, pequeno piscar e leve ajuste dos ombros, mantendo pés e boné estáveis. Não saltar, agachar, atirar, sacar estilingue ou trocar de roupa. Energia juvenil comunicada pela postura, não por deslocamento do corpo no canvas. Loop limpo com quatro quadros separados, mesma âncora e escala.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: netinho_idle_right_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 013 — Netinho Ágil — caminhada

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: netinho_reference_right.png.
- Dependências: 011.
- Saída: `netinho_walk_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 10. Loop: sim.

```text
Pedido 013. Siga o estilo obrigatório e as referências desta fila.
Anime o Netinho canônico numa caminhada rápida para a direita no lugar, com seis poses alternadas de contato, descida e passagem dos pés. Passos leves e braços compactos; boné e rosto mantêm a identidade. Não fazer acrobacia, salto, dash ou disparo. Sem deslocamento horizontal no canvas e sem poeira. Seis quadros, mesma escala e linha de apoio em todos eles, loop contínuo.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: netinho_walk_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 014 — Netinho Ágil — morte

- Grupo: 01 — Personagens jogáveis.
- Ação: **GERAR**.
- Referência a anexar: netinho_reference_right.png.
- Dependências: 011.
- Saída: `netinho_death_right_00..05.png`.
- Canvas final por quadro: 128×128. FPS proposto: 8. Loop: não.

```text
Pedido 014. Siga o estilo obrigatório e as referências desta fila.
Crie seis poses sequenciais da derrota sem sangue do Netinho canônico: susto, desequilíbrio, joelhos cedendo, queda lateral, acomodação, repouso imóvel. Expressão cartunesca leve, sem sofrimento gráfico. Boné permanece reconhecível junto ao corpo dentro do canvas. Não colocar fantasma, rótulo, contagem, moeda ou tela final. Mesma âncora no chão e mesmo canvas em todos os quadros. Não reviver nem repetir a ação.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: netinho_death_right_00..05.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 015 — Netinho Ágil — retrato

- Grupo: 01 — Personagens jogáveis.
- Ação: **REFINAMENTO OPCIONAL**.
- Referência a anexar: netinho_reference_right.png.
- Dependências: 011.
- Saída: `portrait_netinho.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 015. Siga o estilo obrigatório e as referências desta fila.
Crie um retrato pixel art de Netinho Ágil usando a pose canônica anexada. Mesmo rosto, roupa e acessórios, expressão determinada e simpática. Enquadrar cabeça e parte superior do tronco, sem cortar chapéu ou boné. Vista em três quartos compatível com o sprite. Sem ferramenta, moldura, fundo, texto ou números. Canvas quadrado final 256×256 com margem mínima de 24 pixels. Leitura clara quando reduzido a 96 pixels; não converter o personagem em ilustração pintada nem adicionar detalhes ausentes no sprite.

Entrega: Um PNG estático ou pose única. Nome de destino: portrait_netinho.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 016 — pulgao — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #100 — pugao-corredor.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `pulgao_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 016. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Pulgão Corredor compacto verde, olhos vermelhos, patas pequenas e contorno escuro; borda clara pontual para não sumir na grama. Canvas 96×96, âncora (48,72).

Entrega: Um PNG estático ou pose única. Nome de destino: pulgao_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 017 — pulgao — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: pulgao_reference_right.png.
- Dependências: 016.
- Saída: `pulgao_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 017. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: pulgao_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 018 — pulgao — locomoção

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: pulgao_reference_right.png.
- Dependências: 016.
- Saída: `pulgao_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 10. Loop: sim.

```text
Pedido 018. Siga o estilo obrigatório e as referências desta fila.
Anime a criatura canônica anexada avançando para a direita no lugar em seis poses. Patas alternadas e corrida compacta, sem salto. Sem deslocamento horizontal no canvas, ataque, arma ou efeito. Mesma escala e âncora em todos os quadros, loop contínuo.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: pulgao_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 019 — pulgao — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: pulgao_reference_right.png.
- Dependências: 016.
- Saída: `pulgao_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 019. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: pulgao_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 020 — lesma — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #109 — telsmatank-andando.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `lesma_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 020. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Lesma Tanque da referência, corpo violeta/cinza e casco de madeira, postura baixa e pesada. Conservar separação entre casco e corpo; sem canhão ou tiro. Canvas 96×96, âncora (48,72).

Entrega: Um PNG estático ou pose única. Nome de destino: lesma_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 021 — lesma — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: lesma_reference_right.png.
- Dependências: 020.
- Saída: `lesma_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 021. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: lesma_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 022 — lesma — locomoção

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: lesma_reference_right.png.
- Dependências: 020.
- Saída: `lesma_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 022. Siga o estilo obrigatório e as referências desta fila.
Anime a criatura canônica anexada avançando para a direita no lugar em seis poses. Ondulação curta do corpo viscoso; casco quase estável; não desenhar patas ou rastro de gosma. Sem deslocamento horizontal no canvas, ataque, arma ou efeito. Mesma escala e âncora em todos os quadros, loop contínuo.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: lesma_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 023 — lesma — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: lesma_reference_right.png.
- Dependências: 020.
- Saída: `lesma_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 023. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: lesma_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 024 — gafanhoto — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #064 — gafanhoto-correndo.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `gafanhoto_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 024. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Gafanhoto Saltador comum, amarelo-esverdeado conforme referência, pernas traseiras dobradas e anatomia simplificada; distinto de grilo e do chefe gigante. Contorno mais robusto e patas claras no terreno. Canvas 96×96, âncora (48,72).

Entrega: Um PNG estático ou pose única. Nome de destino: gafanhoto_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 025 — gafanhoto — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 025. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: gafanhoto_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 026 — gafanhoto — jump_prepare

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_jump_prepare_00..01.png`.
- Canvas final por quadro: 96×96. FPS proposto: 10. Loop: não.

```text
Pedido 026. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Comprima as pernas em duas poses de preparação do salto; corpo continua na base. Mesmo canvas 96×96, projeção do apoio em (48,72); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: gafanhoto_jump_prepare_00..01.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 027 — gafanhoto — jump_takeoff

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_jump_takeoff_00.png`.
- Canvas final por quadro: 96×96. FPS proposto: pose sustentada. Loop: não.

```text
Pedido 027. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Uma pose de impulso com pernas estendidas e corpo iniciando subida; sem partículas. Mesmo canvas 96×96, projeção do apoio em (48,72); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: Um PNG estático ou pose única. Nome de destino: gafanhoto_jump_takeoff_00.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 028 — gafanhoto — jump_air

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_jump_air_00..01.png`.
- Canvas final por quadro: 96×96. FPS proposto: 10. Loop: sim durante salto.

```text
Pedido 028. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Duas poses de corpo suspenso com pernas recolhidas; mantenha altura visual estável e margem para antenas. Mesmo canvas 96×96, projeção do apoio em (48,72); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: gafanhoto_jump_air_00..01.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 029 — gafanhoto — jump_land

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_jump_land_00..01.png`.
- Canvas final por quadro: 96×96. FPS proposto: 10. Loop: não.

```text
Pedido 029. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Duas poses de pouso: pernas absorvem impacto, depois retorna à postura canônica; sem onda ou poeira. Mesmo canvas 96×96, projeção do apoio em (48,72); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: gafanhoto_jump_land_00..01.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 030 — gafanhoto — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: gafanhoto_reference_right.png.
- Dependências: 024.
- Saída: `gafanhoto_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 030. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: gafanhoto_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 031 — mosca — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #087 — mosta atiradora.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `mosca_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 031. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Mosca Atiradora de corpo azul, olhos alaranjados e asas claras, SEM coroa. Expressão hostil legível; voo baixo. Canvas 96×96, âncora de projeção (48,72).

Entrega: Um PNG estático ou pose única. Nome de destino: mosca_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 032 — mosca — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: mosca_reference_right.png.
- Dependências: 031.
- Saída: `mosca_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 10. Loop: sim.

```text
Pedido 032. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Voadora: asas alternam abertura em poses nítidas, corpo paira no máximo dois pixels sem sair da âncora. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: mosca_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 033 — mosca — voo

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: mosca_reference_right.png.
- Dependências: 031.
- Saída: `mosca_fly_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: sim.

```text
Pedido 033. Siga o estilo obrigatório e as referências desta fila.
Anime a criatura voadora canônica anexada avançando em voo para a direita no lugar em quatro poses de asas abertas, intermediárias, fechadas e intermediárias opostas. Corpo e cabeça estáveis, sem motion blur nas asas. Conservar a coroa somente se for a Rainha. Não inclinar a câmera, disparar ou adicionar trilhas. Mesmo canvas e ponto de projeção no chão; quatro quadros para loop.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: mosca_fly_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 034 — mosca — disparo

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: mosca_reference_right.png.
- Dependências: 031.
- Saída: `mosca_shoot_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 034. Siga o estilo obrigatório e as referências desta fila.
Anime em quatro poses a criatura voadora canônica se preparando e reagindo a um disparo: alerta discreto, tensão curta, soltura com pequeno recuo, retorno. Boca e corpo indicam direção para a direita. Manter voo, anatomia e coroa corretos. NÃO desenhar projétil, nuvem, raio, feixe ou explosão no quadro; o projétil é um asset separado. Não transformar disparo em mordida. Mesma âncora, quatro quadros, sem loop.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: mosca_shoot_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 035 — mosca — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: mosca_reference_right.png.
- Dependências: 031.
- Saída: `mosca_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 035. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: mosca_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 036 — boss_lagarta — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #027 — boss-largatagi.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `boss_lagarta_reference_right.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 036. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Lagarta Titã verde da referência, corpo segmentado volumoso, cabeça reconhecível e postura pesada; sem canhão, espinhos novos ou aura cobrindo o corpo. Canvas 256×256, âncora (128,208).

Entrega: Um PNG estático ou pose única. Nome de destino: boss_lagarta_reference_right.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 037 — boss_lagarta — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_lagarta_reference_right.png.
- Dependências: 036.
- Saída: `boss_lagarta_idle_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 6. Loop: sim.

```text
Pedido 037. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_lagarta_idle_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 038 — boss_lagarta — locomoção

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_lagarta_reference_right.png.
- Dependências: 036.
- Saída: `boss_lagarta_walk_right_00..05.png`.
- Canvas final por quadro: 256×256. FPS proposto: 6. Loop: sim.

```text
Pedido 038. Siga o estilo obrigatório e as referências desta fila.
Anime a criatura canônica anexada avançando para a direita no lugar em seis poses. Onda de compressão dos segmentos de trás para a frente; cabeça com oscilação mínima. Sem deslocamento horizontal no canvas, ataque, arma ou efeito. Mesma escala e âncora em todos os quadros, loop contínuo.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: boss_lagarta_walk_right_00..05.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 039 — boss_lagarta — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_lagarta_reference_right.png.
- Dependências: 036.
- Saída: `boss_lagarta_death_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 039. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_lagarta_death_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 040 — boss_rainha_moscas — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #085 — MOSCARAINHA-3FRAMES.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `boss_rainha_moscas_reference_right.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 040. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Rainha das Moscas da referência aprovada, coroa pequena muito legível, corpo azul/violeta, olhos fortes e asas claras. Silhueta mais imponente que mosca comum, sem número na testa. Canvas 256×256, âncora de projeção (128,208).

Entrega: Um PNG estático ou pose única. Nome de destino: boss_rainha_moscas_reference_right.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 041 — boss_rainha_moscas — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_rainha_moscas_reference_right.png.
- Dependências: 040.
- Saída: `boss_rainha_moscas_idle_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 10. Loop: sim.

```text
Pedido 041. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Voadora: asas alternam abertura em poses nítidas, corpo paira no máximo dois pixels sem sair da âncora. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_rainha_moscas_idle_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 042 — boss_rainha_moscas — voo

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_rainha_moscas_reference_right.png.
- Dependências: 040.
- Saída: `boss_rainha_moscas_fly_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: sim.

```text
Pedido 042. Siga o estilo obrigatório e as referências desta fila.
Anime a criatura voadora canônica anexada avançando em voo para a direita no lugar em quatro poses de asas abertas, intermediárias, fechadas e intermediárias opostas. Corpo e cabeça estáveis, sem motion blur nas asas. Conservar a coroa somente se for a Rainha. Não inclinar a câmera, disparar ou adicionar trilhas. Mesmo canvas e ponto de projeção no chão; quatro quadros para loop.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_rainha_moscas_fly_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 043 — boss_rainha_moscas — disparo

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_rainha_moscas_reference_right.png.
- Dependências: 040.
- Saída: `boss_rainha_moscas_shoot_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 043. Siga o estilo obrigatório e as referências desta fila.
Anime em quatro poses a criatura voadora canônica se preparando e reagindo a um disparo: alerta discreto, tensão curta, soltura com pequeno recuo, retorno. Boca e corpo indicam direção para a direita. Manter voo, anatomia e coroa corretos. NÃO desenhar projétil, nuvem, raio, feixe ou explosão no quadro; o projétil é um asset separado. Não transformar disparo em mordida. Mesma âncora, quatro quadros, sem loop.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_rainha_moscas_shoot_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 044 — boss_rainha_moscas — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_rainha_moscas_reference_right.png.
- Dependências: 040.
- Saída: `boss_rainha_moscas_death_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 044. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_rainha_moscas_death_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 045 — boss_gafanhoto_gigante — pose canônica

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: fonte original #065 — gafanhotogigante-3frames.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `boss_gafanhoto_gigante_reference_right.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 045. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica isolada da criatura descrita abaixo, preservando a identidade da referência. Corpo inteiro voltado para a direita, perspectiva e contornos compatíveis com os sprites de jogo anexados. Priorize olhos, corpo e silhueta reconhecíveis em tamanho pequeno; patas, asas e antenas com espessura legível. Sem ataque, disparo, poeira, chão, sombra ou cenário incorporado. Não desenhar ferramenta ofensiva que sugira uma habilidade inexistente. O canvas e a âncora indicados são o alvo após preparação.

Gafanhoto Gigante da referência de três poses: grande massa amarela/esverdeada, pernas poderosas e expressão de chefe. Remover linha horizontal de chão e poeira. Canvas 256×256, âncora (128,208).

Entrega: Um PNG estático ou pose única. Nome de destino: boss_gafanhoto_gigante_reference_right.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 046 — boss_gafanhoto_gigante — descanso

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_idle_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 6. Loop: sim.

```text
Pedido 046. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de repouso atento da criatura canônica anexada. Terrestre: respiração mínima, patas e apoio fixos. Manter olhos, anatomia, coroa quando existir e número de membros estáveis. Sem atacar, cuspir, saltar ou gerar partículas. Loop de quatro quadros com canvas idêntico.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_gafanhoto_gigante_idle_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 047 — boss_gafanhoto_gigante — jump_prepare

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_jump_prepare_00..01.png`.
- Canvas final por quadro: 256×256. FPS proposto: 10. Loop: não.

```text
Pedido 047. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Comprima as pernas em duas poses de preparação do salto; corpo continua na base. Mesmo canvas 256×256, projeção do apoio em (128,208); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: boss_gafanhoto_gigante_jump_prepare_00..01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 048 — boss_gafanhoto_gigante — jump_takeoff

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_jump_takeoff_00.png`.
- Canvas final por quadro: 256×256. FPS proposto: pose sustentada. Loop: não.

```text
Pedido 048. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Uma pose de impulso com pernas estendidas e corpo iniciando subida; sem partículas. Mesmo canvas 256×256, projeção do apoio em (128,208); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: Um PNG estático ou pose única. Nome de destino: boss_gafanhoto_gigante_jump_takeoff_00.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 049 — boss_gafanhoto_gigante — jump_air

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_jump_air_00..01.png`.
- Canvas final por quadro: 256×256. FPS proposto: 10. Loop: sim durante salto.

```text
Pedido 049. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Duas poses de corpo suspenso com pernas recolhidas; mantenha altura visual estável e margem para antenas. Mesmo canvas 256×256, projeção do apoio em (128,208); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: boss_gafanhoto_gigante_jump_air_00..01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 050 — boss_gafanhoto_gigante — jump_land

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_jump_land_00..01.png`.
- Canvas final por quadro: 256×256. FPS proposto: 10. Loop: não.

```text
Pedido 050. Siga o estilo obrigatório e as referências desta fila.
Use a criatura canônica anexada, orientada para a direita. Duas poses de pouso: pernas absorvem impacto, depois retorna à postura canônica; sem onda ou poeira. Mesmo canvas 256×256, projeção do apoio em (128,208); apenas o corpo sobe dentro do canvas. Não recentralizar ou alterar anatomia.

Entrega: 2 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 2×1 células, uma única animação. Nome de destino: boss_gafanhoto_gigante_jump_land_00..01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 051 — boss_gafanhoto_gigante — morte

- Grupo: 02 — Sete inimigos ativos.
- Ação: **GERAR**.
- Referência a anexar: boss_gafanhoto_gigante_reference_right.png.
- Dependências: 045.
- Saída: `boss_gafanhoto_gigante_death_right_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 051. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: boss_gafanhoto_gigante_death_right_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


###  


### Pedido 085 — FX-01 / Alta / FB-05

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_hit_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 16. Loop: não.

```text
Pedido 085. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Impacto aliado: pequena estrela irregular creme/amarela com contorno escuro, expansão curta e dissipação, quatro quadros em 128×128; miolo transparente no final.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_hit_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 086 — FX-02 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_foice_trail_00..03.png`.
- Canvas final por quadro: 256×256. FPS proposto: 16. Loop: não.

```text
Pedido 086. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Trilha de giro de foice: arco curvo curto creme/cinza, quatro poses de dissipação em 256×256, centro vazio; não desenhar foice.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_foice_trail_00..03.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 087 — FX-03 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_forquilha_trail_00..03.png`.
- Canvas final por quadro: 256×128. FPS proposto: 16. Loop: não.

```text
Pedido 087. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Trilha de estocada de forquilha: duas ou três linhas curtas horizontais para a direita, quatro poses em canvas256×128, origem em (32,64). Sem dentes ou arma desenhados.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_forquilha_trail_00..03.png. Canvas final por quadro: 256×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 088 — FX-04 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_motosserra_hit_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 16. Loop: não.

```text
Pedido 088. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Fagulha/serragem curta de motosserra em quatro poses128×128, creme e madeira clara, sem corrente ou lâmina duplicada.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_motosserra_hit_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 089 — FX-05 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_cerca_zap_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 12. Loop: não.

```text
Pedido 089. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Pulso elétrico ciano em segmentos curtos, quatro poses128×128, poucos pixels claros e contorno azul-escuro; sem postes, fundo ou área inteira preenchida.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_cerca_zap_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 090 — FX-06 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_batata_explosion_00..05.png`.
- Canvas final por quadro: 256×256. FPS proposto: 16. Loop: não.

```text
Pedido 090. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Explosão de batata: terra e casca em anel curto, creme/ocre de alto contraste, seis poses256×256; centro libera visibilidade rapidamente; sem fogo nuclear ou cogumelo gigante.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: fx_batata_explosion_00..05.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 091 — FX-07 / Média / FB-06

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_mamona_bounce_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 16. Loop: não.

```text
Pedido 091. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Ricochete de mamona: estrela curta de contato e duas linhas direcionais, quatro poses128×128, bege claro e castanho; sem segunda semente.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_mamona_bounce_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 092 — FX-08 / Média / FB-07

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_enemy_death_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 12. Loop: não.

```text
Pedido 092. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Dissipação genérica de praga: casca e poeira creme/castanha, quatro poses128×128, fragmentos diminuem até desaparecer. Sem broto, semente, ouro ou fragmento verde brilhante que pareça XP.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_enemy_death_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 093 — FX-09 / Alta / FB-08

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_xp_collect_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 16. Loop: não.

```text
Pedido 093. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Coleta de XP: quatro poses128×128 de pequenos traços ciano/creme convergindo ao centro e sumindo; não desenhar novo pickup no final.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_xp_collect_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 094 — FX-10 / Alta / FB-08

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_level_up_00..05.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 094. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Level-up: broto estilizado com duas folhas e arco breve ciano/creme, seis poses256×256; começo e final vazios; sem painel, nome ou números.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: fx_level_up_00..05.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 095 — FX-11 / Média / FB-09

- Grupo: 06 — Efeitos de combate.
- Ação: **GERAR/CORRIGIR**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_boss_landing_00..05.png`.
- Canvas final por quadro: 256×256. FPS proposto: 12. Loop: não.

```text
Pedido 095. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Onda de pouso: anel baixo de poeira ocre com borda clara, seis poses256×256 expandindo e dissipando, centro transparente; nenhuma criatura ou sombra.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: fx_boss_landing_00..05.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 096 — FX-12 / Baixa / FB-10

- Grupo: 06 — Efeitos de combate.
- Ação: **OPCIONAL**.
- Referência a anexar: Referência da família da arma ou criatura; fonte original #060 — fx_combat.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_gold_confirmed_00..03.png`.
- Canvas final por quadro: 128×128. FPS proposto: 12. Loop: não.

```text
Pedido 096. Siga o estilo obrigatório e as referências desta fila.
Crie somente o efeito 2D descrito, isolado, em poses discretas de pixel art, sem corpo de personagem, arma duplicada, cenário, chão ou texto. Mesmo canvas e âncora em todos os quadros. O efeito começa pequeno, atinge uma forma legível e dissipa sem cortar partículas na borda. Paleta curta, sem bloom, fumaça opaca cobrindo a ação ou blur. Não desenhar dano, número ou coleta. Entregar quadros separados na ordem temporal indicada; não misturar outros efeitos na sequência.

Brilho de recompensa: estrela pequena ouro/creme, quatro poses128×128, intensidade baixa, sem moeda ou números.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: fx_gold_confirmed_00..03.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 097 — Barra de vida — moldura

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_health_frame.png`.
- Canvas final por quadro: 288×64. FPS proposto: —. Loop: não.

```text
Pedido 097. Siga o estilo obrigatório e as referências desta fila.
Crie somente uma moldura fina horizontal de barra de vida, vista frontal, madeira castanha e ferragens discretas iguais ao painel anexado. Canvas final288×64. Borda de até8 pixels, cantos simétricos dentro de regiões de12×12; centro vazado totalmente transparente e faixa interna livre. Nenhum preenchimento de vida, coração, valor, texto, prego no meio ou brilho. Laterais e miolo retos para permitir nove cortes sem deformar cantos. A aparência deve ser leve o bastante para não cobrir o combate.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_health_frame.png. Canvas final por quadro: 288×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 098 — Barra de XP — moldura

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_xp_frame.png`.
- Canvas final por quadro: 288×32. FPS proposto: —. Loop: não.

```text
Pedido 098. Siga o estilo obrigatório e as referências desta fila.
Crie moldura horizontal muito fina para XP da mesma família da barra de vida anexada, canvas final288×32, borda de4 pixels e cantos dentro de8×8. Centro vazado transparente, região central reta e limpa para esticar. Sem preenchimento fixo, rótulo, número ou símbolo. Deve ocupar menos altura visual que a vida; o fill ciano e o texto de nível serão feitos no jogo.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_xp_frame.png. Canvas final por quadro: 288×32. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 099 — Joystick — base

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `joystick_base.png`.
- Canvas final por quadro: 192×192. FPS proposto: —. Loop: não.

```text
Pedido 099. Siga o estilo obrigatório e as referências desta fila.
Crie somente a base circular de um joystick rural de madeira simplificada, vista frontal, canvas final192×192, círculo perfeitamente centrado em (96,96). Anel fino de madeira com contorno escuro, diâmetro externo176 e interior vazado transparente. Sem manopla, linhas cruzadas, divisórias, letras, setas ou sombra externa. Design discreto para enxergar ameaças pelo miolo; quatro lados simétricos e margem livre.

Entrega: Um PNG estático ou pose única. Nome de destino: joystick_base.png. Canvas final por quadro: 192×192. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 100 — Joystick — manopla

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `joystick_knob.png`.
- Canvas final por quadro: 80×80. FPS proposto: —. Loop: não.

```text
Pedido 100. Siga o estilo obrigatório e as referências desta fila.
Crie somente a manopla circular do joystick da referência de madeira, vista frontal, canvas final80×80, centro exato (40,40), disco de diâmetro64 com contorno escuro e relevo muito simples. Sem base, hastes, setas, texto ou sombra projetada. Mesma luz e materiais da base aprovada. Margem livre igual nos quatro lados; não deslocar o círculo para simular pressionamento.

Entrega: Um PNG estático ou pose única. Nome de destino: joystick_knob.png. Canvas final por quadro: 80×80. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 101 — Pausar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_pause.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 101. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Pausar: duas barras verticais grossas, paralelas, mesmo tamanho. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_pause.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 102 — Continuar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_resume.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 102. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Continuar: triângulo único sólido apontando para a direita. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_resume.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 103 — Voltar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_back.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 103. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Voltar: seta curta virando para a esquerda, ponta larga. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_back.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 104 — Fechar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_close.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 104. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Fechar: X de duas diagonais espessas e simétricas. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_close.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 105 — Confirmar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_confirm.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 105. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Confirmar: visto simples de dois segmentos largos. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_confirm.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 106 — Reiniciar

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_restart.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 106. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Reiniciar: seta circular aberta com uma única ponta clara. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_restart.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 107 — Configurações

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_settings.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 107. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Configurações: engrenagem simplificada de seis dentes e miolo vazado. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_settings.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 108 — Inventário

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_inventory.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 108. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Inventário: mochila rural simples com aba e alça, silhueta forte. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_inventory.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 109 — Volume

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ui_volume.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 109. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Volume: alto-falante inteiro com uma onda curta, sem recorte na borda. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: ui_volume.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 110 — Vida máxima

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_health.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 110. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Vida máxima: coração simples vermelho com contorno escuro, sem percentual. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_health.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 111 — Dano

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_damage.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 111. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Dano: pequena lâmina de ferramenta sobre um entalhe de impacto, sem sangue. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_damage.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 112 — Intervalo de ataque

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_interval.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 112. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Intervalo de ataque: relógio simples com pequeno movimento circular, sem algarismos nem sinal de mais/menos. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_interval.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 113 — Velocidade

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_speed.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 113. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Velocidade: bota rural inclinada e duas linhas curtas atrás, sem confundir com ícone de pausa. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_speed.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 114 — Defesa

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_defense.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 114. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Defesa: escudo pequeno de tábuas com reforço metálico, sem runas. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_defense.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 115 — Coleta

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `stat_collection.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 115. Siga o estilo obrigatório e as referências desta fila.
Crie um único símbolo de interface para Coleta: ímã em ferradura envolvendo uma única semente pequena, distinto da moeda. Pixel art frontal com contorno castanho-escuro, preenchimento creme e pequeno detalhe madeira, compatível com os botões anexados. Sem placa ou moldura própria, sem palavras, números ou sombra. Canvas64×64, símbolo dentro de44×44, centralizado. Deve ser reconhecível em40 pixels e não depender apenas da cor. Um único ícone isolado.

Entrega: Um PNG estático ou pose única. Nome de destino: stat_collection.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 116 — Moeda canônica

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `currency_gold.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 116. Siga o estilo obrigatório e as referências desta fila.
Crie uma única moeda canônica do jogo rural: disco dourado quente, contorno castanho, aro simples e um pequeno sabugo de milho gravado no centro. Vista frontal levemente volumétrica, sem inclinação extrema. Canvas128×128, moeda dentro de96×96. Sem letras, números, saco, joias, segunda moeda, brilho intenso ou partículas. Leitura nítida em32,48 e64 pixels, com a mesma paleta em todas as escalas.

Entrega: Um PNG estático ou pose única. Nome de destino: currency_gold.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 117 — Carta normal

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `upgrade_card_normal.png`.
- Canvas final por quadro: 384×128. FPS proposto: —. Loop: não.

```text
Pedido 117. Siga o estilo obrigatório e as referências desta fila.
Crie um fundo de carta horizontal de melhoria em pixel art frontal, da mesma família do painel anexado: madeira fina castanha, quatro cantos simples e centro sólido de pergaminho creme quase uniforme. Canvas final384×128, borda até12 pixels, cantos restritos a20×20 e longas regiões retas para nove cortes. Interior limpo, sem desenho de arma, símbolo, coluna, faixa fixa, texto ou números. Sem aparência de raridade. Deve poder virar uma faixa de aproximadamente672×184 na interface, com ícone, nome e atributos desenhados pelo motor.

Entrega: Um PNG estático ou pose única. Nome de destino: upgrade_card_normal.png. Canvas final por quadro: 384×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 118 — Carta selecionada

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: upgrade_card_normal.png.
- Dependências: 117.
- Saída: `upgrade_card_selected.png`.
- Canvas final por quadro: 384×128. FPS proposto: —. Loop: não.

```text
Pedido 118. Siga o estilo obrigatório e as referências desta fila.
Edite somente a carta normal anexada. Conserve canvas, centro e geometria exatos. Indique seleção por borda interna dupla e quatro marcas curtas nos cantos em creme/dourado discreto, visíveis também sem distinguir cores. Não acrescentar estrelas, gemas, texto ou decoração no centro. Não transformar seleção em raridade. Não mudar escala nem espessura externa da carta.

Entrega: Um PNG estático ou pose única. Nome de destino: upgrade_card_selected.png. Canvas final por quadro: 384×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 119 — Slot de equipamento

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `equipment_slot.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 119. Siga o estilo obrigatório e as referências desta fila.
Crie um slot vazio quadrado de equipamento, pixel art frontal, madeira fina e centro pergaminho levemente escurecido, família do painel anexado. Canvas128×128, borda8 pixels, cantos de16×16 para nove cortes, centro útil totalmente livre. Sem cadeado, item, número, letra, estrela ou símbolo de proibição. Slot vazio significa espaço disponível, não conteúdo bloqueado.

Entrega: Um PNG estático ou pose única. Nome de destino: equipment_slot.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 120 — Manopla de configurações

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `settings_knob.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 120. Siga o estilo obrigatório e as referências desta fila.
Crie uma pequena manopla circular de madeira para slider de configurações, vista frontal, mesma família dos botões, canvas64×64 e disco central de40 pixels. Pouquíssimos detalhes, contorno firme, sem número, texto, trilho ou cenário. Deve parecer um controle de interface, não moeda. Fundo transparente e margem uniforme.

Entrega: Um PNG estático ou pose única. Nome de destino: settings_knob.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 121 — Indicador de gravação

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `save_seed.png`.
- Canvas final por quadro: 64×64. FPS proposto: —. Loop: não.

```text
Pedido 121. Siga o estilo obrigatório e as referências desta fila.
Crie um pequeno símbolo neutro de gravação: uma semente creme dentro de um aro aberto castanho, pixel art frontal, canvas64×64, desenho dentro de40×40. Não desenhar visto, cruz, texto, moeda ou promessa de sucesso. Centro e peso visual estáveis para rotação do aro no motor. Poucos detalhes e fundo transparente.

Entrega: Um PNG estático ou pose única. Nome de destino: save_seed.png. Canvas final por quadro: 64×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 122 — Placa de custo

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `cost_plate.png`.
- Canvas final por quadro: 192×64. FPS proposto: —. Loop: não.

```text
Pedido 122. Siga o estilo obrigatório e as referências desta fila.
Crie uma pequena placa horizontal vazia de pergaminho com duas presilhas de madeira discretas, canvas192×64, centro limpo e claro, cantos preserváveis por nove cortes. Sem moeda, valor, cadeado, estrelas ou texto. Mesma paleta do painel rural, sem sombra projetada. Será usada atrás de custo ou estado textual.

Entrega: Um PNG estático ou pose única. Nome de destino: cost_plate.png. Canvas final por quadro: 192×64. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 123 — Emblema de vitória

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `result_victory_emblem.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 123. Siga o estilo obrigatório e as referências desta fila.
Crie um pequeno emblema de colheita concluída: broto vigoroso com duas folhas e um visto simples apoiados numa peça pequena de madeira, coerente com o emblema rural anexado. Pixel art frontal, canvas256×256, forma dentro de192×192, sem texto, moeda, coroa de raridade ou números. Expressão de conquista rural, sem pôster de fundo. Legível quando exibido a160 pixels.

Entrega: Um PNG estático ou pose única. Nome de destino: result_victory_emblem.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 124 — Emblema de derrota

- Grupo: 07 — Interface.
- Ação: **GERAR**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `result_defeat_emblem.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 124. Siga o estilo obrigatório e as referências desta fila.
Crie um pequeno emblema de fim de tentativa: chapéu castanho do Fazendeiro apoiado ao lado de uma ferramenta rural simples, composição acolhedora e serena. Pixel art frontal, mesma família do emblema rural, canvas256×256, forma dentro de192×192. Sem corpo ferido, túmulo, sangue, moeda riscada, texto ou cenário. Não sugerir que o progresso permanente foi apagado. Fundo transparente.

Entrega: Um PNG estático ou pose única. Nome de destino: result_defeat_emblem.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 125 — Aviso de chefe

- Grupo: 07 — Interface.
- Ação: **REUTILIZAR MEDALHÃO HOSTIL; GERAR SOMENTE SE NECESSÁRIO**.
- Referência a anexar: art/ui_rural/panel.png + art/ui_rural/button.png.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `boss_warning_icon.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 125. Siga o estilo obrigatório e as referências desta fila.
Crie um símbolo compacto de ameaça para entrada de chefe: rosto de praga genérica em um medalhão de madeira rústica, inspirado no medalhão hostil anexado, contorno firme e pequeno acento vermelho. Canvas128×128, margem12 pixels. Deve ser distinto de vitória e cadeado. Sem nome, barra, número, letras ou tela de aviso. Evitar caveira realista e gore.

Entrega: Um PNG estático ou pose única. Nome de destino: boss_warning_icon.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 126 — Piso base — celeiro

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: fonte original #115 — Wooden_barn_floor_planks_20261015080844.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ground_celeiro_base.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 126. Siga o estilo obrigatório e as referências desta fila.
Crie uma textura de piso de celeiro rural em pixel art, vista superior ortogonal, tile quadrado repetível nas quatro direções. Tábuas castanhas dessaturadas com pouca palha, juntas finas e discretas, baixo contraste e iluminação uniforme. Paleta coerente com a madeira do jogo, porém mais apagada que a interface. Canvas final256×256. Bordas esquerda/direita e superior/inferior devem encaixar sem degrau; evitar linhas largas atravessando o tile, cruz de emenda, vinheta e manchas memoráveis. Sem objetos, paredes, texto, sombras de cenário ou moldura. Deve deixar pragas marrons e projéteis claros visíveis.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_celeiro_base.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 127 — Piso base — pomar

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: fonte original #012 — Autumn_orchard_ground_pixel_art_20261015080932.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ground_pomar_base.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 127. Siga o estilo obrigatório e as referências desta fila.
Crie textura de chão de pomar ao entardecer em pixel art, vista superior ortogonal, tile quadrado repetível nas quatro direções. Terra ocre dessaturada com poucas folhas outonais pequenas e distribuídas sem desenho repetitivo. Baixo contraste, iluminação uniforme, nenhuma mancha dominante, árvore, fruto grande ou sombra. Canvas final256×256, bordas perfeitamente contínuas. Tons quentes subordinados aos inimigos e projéteis; sem vinheta, faixas, moldura, caminho fixo ou texto. Estilo do mapa e props de Pomar anexados, com menos detalhe para o combate.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_pomar_base.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 128 — horta — variação 1

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: fonte original #111 — Vegetable_garden_grass_texture_20261015081024.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ground_horta_var01.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 128. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_horta_var01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 129 — horta — variação 2

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: fonte original #111 — Vegetable_garden_grass_texture_20261015081024.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `ground_horta_var02.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 129. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_horta_var02.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 130 — celeiro — variação 1

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: ground_celeiro_base.png.
- Dependências: 126.
- Saída: `ground_celeiro_var01.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 130. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_celeiro_var01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 131 — celeiro — variação 2

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: ground_celeiro_base.png.
- Dependências: 126.
- Saída: `ground_celeiro_var02.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 131. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_celeiro_var02.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 132 — pomar — variação 1

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: ground_pomar_base.png.
- Dependências: 127.
- Saída: `ground_pomar_var01.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 132. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_pomar_var01.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 133 — pomar — variação 2

- Grupo: 08 — Cenários.
- Ação: **GERAR**.
- Referência a anexar: ground_pomar_base.png.
- Dependências: 127.
- Saída: `ground_pomar_var02.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 133. Siga o estilo obrigatório e as referências desta fila.
Crie uma variante discreta da textura de chão anexada, preservando exatamente sua paleta, valor tonal médio, densidade de pixels e encaixe das bordas. Mude apenas pequenos detalhes internos, mantendo uma faixa periférica de16 pixels idêntica à base para permitir mistura entre tiles. Sem novo objeto grande, sombra, caminho ou mancha dominante. Mesmo canvas256×256. Não aumentar contraste nem saturação. A variante deve se misturar à base sem produzir costuras ou parecer outro bioma.

Entrega: Um PNG estático ou pose única. Nome de destino: ground_pomar_var02.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 134 — horta — cerca

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #095 — Pixel_art_garden_props_grid_20261015081152.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_horta_cerca.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 134. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto cerca do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_horta_cerca.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 135 — horta — canteiro

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #095 — Pixel_art_garden_props_grid_20261015081152.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_horta_canteiro.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 135. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto canteiro do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_horta_canteiro.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 136 — horta — couve

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #095 — Pixel_art_garden_props_grid_20261015081152.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_horta_couve.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 136. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto couve do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_horta_couve.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 137 — horta — espantalho

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #095 — Pixel_art_garden_props_grid_20261015081152.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_horta_espantalho.png`.
- Canvas final por quadro: 128×192. FPS proposto: —. Loop: não.

```text
Pedido 137. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto espantalho do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_horta_espantalho.png. Canvas final por quadro: 128×192. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 138 — celeiro — feno

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #093 — Pixel_art_barn_props_layout_20261015081208.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_celeiro_feno.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 138. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto feno do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_celeiro_feno.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 139 — celeiro — barril

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #093 — Pixel_art_barn_props_layout_20261015081208.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_celeiro_barril.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 139. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto barril do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_celeiro_barril.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 140 — celeiro — caixa

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #093 — Pixel_art_barn_props_layout_20261015081208.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_celeiro_caixa.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 140. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto caixa do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_celeiro_caixa.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 141 — celeiro — saco

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #093 — Pixel_art_barn_props_layout_20261015081208.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_celeiro_saco.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 141. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto saco do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_celeiro_saco.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 142 — celeiro — roda

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #093 — Pixel_art_barn_props_layout_20261015081208.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_celeiro_roda.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 142. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto roda do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_celeiro_roda.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 143 — pomar — arvore

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #092 — Orchard_props_in_pixel_art_20261015081131.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_pomar_arvore.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 143. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto arvore do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_pomar_arvore.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 144 — pomar — cesto

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #092 — Orchard_props_in_pixel_art_20261015081131.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_pomar_cesto.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 144. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto cesto do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_pomar_cesto.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 145 — pomar — folhas

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #092 — Orchard_props_in_pixel_art_20261015081131.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_pomar_folhas.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 145. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto folhas do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_pomar_folhas.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 146 — pomar — escada

- Grupo: 08 — Cenários.
- Ação: **RECORTAR FONTE APROVADA; GERAR SOMENTE SE O RECORTE FALHAR**.
- Referência a anexar: fonte original #092 — Orchard_props_in_pixel_art_20261015081131.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `prop_pomar_escada.png`.
- Canvas final por quadro: 128×192. FPS proposto: —. Loop: não.

```text
Pedido 146. Siga o estilo obrigatório e as referências desta fila.
Reproduza somente o objeto escada do kit rural anexado, fiel à identidade e paleta da fonte, isolado em pixel art na mesma perspectiva. Sem outros objetos, cenário, chão, sombra projetada, texto ou moldura. Corpo inteiro e margem livre, base visível para marcar pivô. Não adicionar porta aberta, baú brilhando ou contorno que sugira interação nova. Conservar o papel decorativo.

Entrega: Um PNG estático ou pose única. Nome de destino: prop_pomar_escada.png. Canvas final por quadro: 128×192. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 147 — Ícone de aplicativo — primeiro plano

- Grupo: 09 — Identidade do aplicativo.
- Ação: **GERAR**.
- Referência a anexar: fazendeiro_reference_right.png + art/ui_rural/emblem.png.
- Dependências: 001.
- Saída: `app_icon_foreground.png`.
- Canvas final por quadro: 1024×1024. FPS proposto: —. Loop: não.

```text
Pedido 147. Siga o estilo obrigatório e as referências desta fila.
Crie um ícone de aplicativo de jogo rural em pixel art usando exatamente o rosto e chapéu do Fazendeiro canônico anexado, expressão determinada e simpática. Busto compacto central, contorno escuro forte, cores da camisa azul e chapéu castanho; sem texto, letras, números, foice saindo do quadro ou detalhes minúsculos. Canvas quadrado final1024×1024; todo conteúdo essencial dentro do círculo central de diâmetro600, centro(512,512), com margem ampla para recortes variados. Fundo transparente para preparar camada adaptativa separada. Não arredondar os cantos do arquivo nem desenhar mockup de celular.

Entrega: Um PNG estático ou pose única. Nome de destino: app_icon_foreground.png. Canvas final por quadro: 1024×1024. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 148 — Ícone de aplicativo — fundo

- Grupo: 09 — Identidade do aplicativo.
- Ação: **GERAR**.
- Referência a anexar: fazendeiro_reference_right.png + art/ui_rural/emblem.png.
- Dependências: 001.
- Saída: `app_icon_background.png`.
- Canvas final por quadro: 1024×1024. FPS proposto: —. Loop: não.

```text
Pedido 148. Siga o estilo obrigatório e as referências desta fila.
Crie somente um fundo quadrado opaco de baixo detalhe para ícone rural: verde-oliva dessaturado com leve textura pixelada quase uniforme, sem vinheta, personagem, objeto, palavra, moldura ou cantos arredondados. Canvas final1024×1024. Deve contrastar com chapéu castanho e camisa azul do ícone anexado e funcionar sob máscaras variadas de launcher.

Entrega: Um PNG estático ou pose única. Nome de destino: app_icon_background.png. Canvas final por quadro: 1024×1024. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 149 — foice nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de foice nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_foice_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 149. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma foice, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_foice_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 150 — foice nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de foice nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_foice_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 150. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma foice, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_foice_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 151 — foice nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de foice nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_foice_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 151. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma foice, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_foice_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 152 — forquilha nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de forquilha nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_forquilha_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 152. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma forquilha, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_forquilha_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 153 — forquilha nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de forquilha nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_forquilha_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 153. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma forquilha, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_forquilha_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 154 — forquilha nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de forquilha nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_forquilha_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 154. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma forquilha, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_forquilha_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 155 — milho nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de milho nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_milho_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 155. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma milho, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_milho_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 156 — milho nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de milho nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_milho_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 156. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma milho, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_milho_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 157 — milho nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de milho nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_milho_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 157. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma milho, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_milho_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 158 — batata nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de batata nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_batata_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 158. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma batata, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_batata_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 159 — batata nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de batata nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_batata_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 159. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma batata, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_batata_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 160 — batata nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de batata nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_batata_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 160. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma batata, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_batata_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 161 — mamona nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de mamona nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_mamona_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 161. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma mamona, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_mamona_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 162 — mamona nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de mamona nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_mamona_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 162. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma mamona, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_mamona_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 163 — mamona nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de mamona nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_mamona_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 163. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma mamona, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_mamona_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 164 — motosserra nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de motosserra nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_motosserra_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 164. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma motosserra, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_motosserra_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 165 — motosserra nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de motosserra nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_motosserra_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 165. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma motosserra, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_motosserra_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 166 — motosserra nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de motosserra nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_motosserra_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 166. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma motosserra, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_motosserra_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 167 — cerca nível 1 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de cerca nível 1; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_cerca_lv1.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 167. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma cerca, nível 1, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_cerca_lv1.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 168 — cerca nível 2 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de cerca nível 2; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_cerca_lv2.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 168. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma cerca, nível 2, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_cerca_lv2.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 169 — cerca nível 3 — corpo de mundo

- Grupo: 10 — Condicionais: corpos de armas.
- Ação: **REUTILIZAR ÍCONE PREPARADO; GERAR APENAS SE A SILHUETA DE MUNDO EXIGIR OUTRO RECORTE**.
- Referência a anexar: Ícone correto de cerca nível 3; usar arquivo existente ou o gerado na etapa04.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `world_cerca_lv3.png`.
- Canvas final por quadro: 128×128. FPS proposto: —. Loop: não.

```text
Pedido 169. Siga o estilo obrigatório e as referências desta fila.
Extraia da referência aprovada somente o corpo da arma cerca, nível 3, preservando materiais, silhueta e proporções. Sprite de mundo isolado, sem personagem, mão, ícone de slot, texto, brilho, rastro ou ataque. Orientar a parte que atinge/dispara para a direita quando aplicável. Canvas final 128×128, margem de 12 pixels. Não inventar outra evolução. O ponto de empunhadura deve ficar claramente identificável para ser marcado na preparação.

Entrega: Um PNG estático ou pose única. Nome de destino: world_cerca_lv3.png. Canvas final por quadro: 128×128. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 170 — Poça decorativa

- Grupo: 11 — Condicionais: decoração.
- Ação: **OPCIONAL; SEM DANO OU MECÂNICA NOVA**.
- Referência a anexar: fonte original #063 — fx_puddle_and_shockwave.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `fx_puddle_base.png`.
- Canvas final por quadro: 256×256. FPS proposto: —. Loop: não.

```text
Pedido 170. Siga o estilo obrigatório e as referências desta fila.
Crie uma poça decorativa rural de lama em pixel art, vista superior, contorno irregular castanho com pequenas bordas ocres legíveis, interior de baixo contraste e centro parcialmente translúcido. Canvas final256×256, margem livre de24. Sem brilho tóxico, criaturas, texto ou animação incorporada. Deve parecer lama decorativa; um eventual estado perigoso será sinalizado separadamente no motor.

Entrega: Um PNG estático ou pose única. Nome de destino: fx_puddle_base.png. Canvas final por quadro: 256×256. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 171 — aranha — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #003 — aranha-celeiro.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `aranha_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 171. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Corpo escuro, olhos claros e patas legíveis; sem teia anexada.

Entrega: Um PNG estático ou pose única. Nome de destino: aranha_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 172 — aranha — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: aranha_reference_right.png.
- Dependências: 171.
- Saída: `aranha_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 172. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: aranha_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 173 — aranha — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: aranha_reference_right.png.
- Dependências: 171.
- Saída: `aranha_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 173. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: aranha_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 174 — aranha — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: aranha_reference_right.png.
- Dependências: 171.
- Saída: `aranha_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 174. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: aranha_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 175 — besouro — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #019 — besouroblindado-pomar.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `besouro_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 175. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Carapaça azul-escura e postura baixa; não misturar ataque erguido ao idle.

Entrega: Um PNG estático ou pose única. Nome de destino: besouro_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 176 — besouro — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: besouro_reference_right.png.
- Dependências: 175.
- Saída: `besouro_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 176. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: besouro_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 177 — besouro — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: besouro_reference_right.png.
- Dependências: 175.
- Saída: `besouro_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 177. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: besouro_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 178 — besouro — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: besouro_reference_right.png.
- Dependências: 175.
- Saída: `besouro_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 178. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: besouro_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 179 — formiga — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #054 — formiga-exame.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `formiga_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 179. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Corpo segmentado quente, antenas estáveis e seis patas; sem confundir com Pulgão.

Entrega: Um PNG estático ou pose única. Nome de destino: formiga_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 180 — formiga — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: formiga_reference_right.png.
- Dependências: 179.
- Saída: `formiga_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 180. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: formiga_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 181 — formiga — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: formiga_reference_right.png.
- Dependências: 179.
- Saída: `formiga_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 181. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: formiga_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 182 — formiga — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: formiga_reference_right.png.
- Dependências: 179.
- Saída: `formiga_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 182. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: formiga_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 183 — grilo — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #070 — griloestondoso-pomar.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `grilo_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 183. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Silhueta própria da referência, distinta do Gafanhoto Saltador; sem onda incorporada.

Entrega: Um PNG estático ou pose única. Nome de destino: grilo_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 184 — grilo — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: grilo_reference_right.png.
- Dependências: 183.
- Saída: `grilo_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 184. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: grilo_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 185 — grilo — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: grilo_reference_right.png.
- Dependências: 183.
- Saída: `grilo_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 185. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: grilo_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 186 — grilo — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: grilo_reference_right.png.
- Dependências: 183.
- Saída: `grilo_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 186. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: grilo_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 187 — abelha — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #002 — abelha-pomar.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `abelha_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 187. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Amarelo/preto e asas claras; sem ferrão usado como ataque nesta pose.

Entrega: Um PNG estático ou pose única. Nome de destino: abelha_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 188 — abelha — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: abelha_reference_right.png.
- Dependências: 187.
- Saída: `abelha_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 188. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: asas alternam sem blur, corpo quase estável. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: abelha_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 189 — abelha — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: abelha_reference_right.png.
- Dependências: 187.
- Saída: `abelha_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 189. Siga o estilo obrigatório e as referências desta fila.
Seis poses de voo no lugar com asas alternadas, sem borrão. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: abelha_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 190 — abelha — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: abelha_reference_right.png.
- Dependências: 187.
- Saída: `abelha_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 190. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: abelha_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 191 — barata — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #016 — barata-celeiro.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `barata_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 191. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Corpo achatado e antenas; sem dash na pose neutra.

Entrega: Um PNG estático ou pose única. Nome de destino: barata_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 192 — barata — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: barata_reference_right.png.
- Dependências: 191.
- Saída: `barata_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 192. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: barata_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 193 — barata — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: barata_reference_right.png.
- Dependências: 191.
- Saída: `barata_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 193. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: barata_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 194 — barata — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: barata_reference_right.png.
- Dependências: 191.
- Saída: `barata_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 194. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: barata_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 195 — rato — pose

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: fonte original #103 — rato-celeiro.jpg.
- Dependências: Nenhum pedido anterior obrigatório; fornecer referências externas..
- Saída: `rato_reference_right.png`.
- Canvas final por quadro: 96×96. FPS proposto: —. Loop: não.

```text
Pedido 195. Siga o estilo obrigatório e as referências desta fila.
Crie uma única pose canônica da criatura rural descrita abaixo, baseada na referência fornecida, com contornos e densidade de pixels compatíveis com Pulgão e Mosca aprovados. Corpo inteiro voltado para a direita, canvas final96×96 e apoio(48,72). Sem ataque, projétil, sombra, chão, número ou efeito. Silhueta legível em tamanho pequeno. Não inventar habilidade ou equipamento. Esta é uma proposta de conteúdo futuro.

Corpo marrom, cauda longa e orelhas claras; contorno legível sobre tábuas.

Entrega: Um PNG estático ou pose única. Nome de destino: rato_reference_right.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 196 — rato — idle

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: rato_reference_right.png.
- Dependências: 195.
- Saída: `rato_idle_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 6. Loop: sim.

```text
Pedido 196. Siga o estilo obrigatório e as referências desta fila.
Quatro poses de repouso discreto: respiração mínima, patas fixas. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: rato_idle_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 197 — rato — walk

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: rato_reference_right.png.
- Dependências: 195.
- Saída: `rato_walk_right_00..05.png`.
- Canvas final por quadro: 96×96. FPS proposto: 8. Loop: sim.

```text
Pedido 197. Siga o estilo obrigatório e as referências desta fila.
Seis poses de locomoção para a direita no lugar, alternando patas de forma coerente. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 6 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 6×1 células, uma única animação. Nome de destino: rato_walk_right_00..05.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


### Pedido 198 — rato — death

- Grupo: 12 — Reserva: criaturas futuras.
- Ação: **RESERVA; FORA DO PACOTE ATIVO**.
- Referência a anexar: rato_reference_right.png.
- Dependências: 195.
- Saída: `rato_death_right_00..03.png`.
- Canvas final por quadro: 96×96. FPS proposto: 12. Loop: não.

```text
Pedido 198. Siga o estilo obrigatório e as referências desta fila.
Crie quatro poses de derrota sem sangue da criatura canônica: reação curta, perda de sustentação, corpo recolhendo ou tombando, repouso final. Terrestres caem no chão sem linha desenhada; voadoras dobram as asas e descem dentro do canvas. Conservar identidade, escala e âncora. Sem ovos, filhotes, XP, moeda, explosão, partículas verdes ou nova criatura. Quatro quadros separados, sem repetição. A dissolução genérica será um efeito separado. Mesmo canvas96×96 e apoio(48,72); sem ataque, projétil, sombra, chão ou texto. Não criar mecânica nova.

Entrega: 4 quadros; PNGs individuais com os nomes indicados. Alternativa: folha de 4×1 células, uma única animação. Nome de destino: rato_death_right_00..03.png. Canvas final por quadro: 96×96. Esses nomes são instruções de arquivo e não devem aparecer desenhados. Preserve as dimensões/âncora entre quadros. Se a saída não respeitar o contrato, informe a dimensão real e mantenha o original para preparação.
```


## Fechamento e retomada

```text
Último pedido concluído: número e nome.
Próximo pedido: número e nome.
Referências canônicas já estabelecidas: listar os arquivos reais.
Gerados/preparados/reutilizados: listar separadamente.
Pendências técnicas: alpha, recorte, grade, inconsistência, arquivo ausente.
Condicionais dispensados: listar a condição que não ocorreu.
Reserva: listar como futura, sem declarar integrada.
```

Para continuar: “Retome esta fila a partir do pedido informado como próximo. Reutilize as poses canônicas já fornecidas e não refaça os pedidos concluídos.”

As artes recebidas serão revisadas e conectadas a personagens, níveis e estados no Godot. Não substituir colisões pelo tamanho do PNG, nem alterar dano/cooldown para caber na animação. Morte visual não mantém inimigo ativo no pool; efeito não paga XP/ouro. O ZIP entregue antes deste documento permanece a versão já empacotada.
