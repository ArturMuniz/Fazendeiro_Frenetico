# O Fazendeiro Frenético — Guia de contexto e criação de conteúdo

**Para:** parceiro responsável por vídeos, banners e redes sociais.  
**Responsável pelo jogo:** Artur Muniz.  
**Versão deste guia:** 17/10/2026.  
**Objetivo desta fase:** apresentar o jogo, descobrir quais ideias despertam interesse e formar uma comunidade que acompanhe o desenvolvimento.

Este documento reúne fatos do projeto, direção de marca e propostas criativas. Os roteiros, a frequência de postagem e o posicionamento são hipóteses de marketing para testar; as funcionalidades descritas como atuais foram conferidas no projeto. Antes de anunciar novidades, atualizar os fatos com Artur.

## 1. Comece por aqui

1. Leia o resumo e o estado do jogo abaixo.
2. Abra `referencias/referencias_jogo.png` para conhecer os personagens, chefes e armas reais.
3. Consulte as quatro artes em `artes/`. Elas são ilustrações promocionais, não screenshots.
4. Escolha um dos roteiros da seção 7 e grave os trechos necessários em uma partida normal.
5. Para criar arte com IA, anexe as referências e use os prompts das seções 9 e 10.
6. Adapte o enquadramento para cada rede e confira a prévia antes de postar.

Os caminhos deste guia são relativos à pasta do kit: ele pode ser compartilhado sem depender das pastas do computador de Artur. O kit não contém o executável do jogo nem filmagens de gameplay.

## 2. O jogo em poucas palavras

**Frase de apresentação:** Sobreviva às pragas da fazenda, transforme ferramentas em armas e monte sua combinação de melhorias em um roguelite rural de combate automático.

**Descrição curta para posts:**

> A fazenda virou campo de batalha! Em O Fazendeiro Frenético, você enfrenta hordas de pragas, combina armas rurais e encara chefes gigantes. Um roguelite de sobrevivência em pixel art, em desenvolvimento.

**Explicação para quem não conhece o gênero:** você controla o movimento; as armas atacam automaticamente. Durante a partida, ganha experiência e escolhe melhorias. O desafio está em se posicionar, sobreviver e construir uma combinação de armas que funcione.

**Proposta de posicionamento:** humor rural brasileiro, ferramentas improvisadas e combate que cresce em intensidade. O contraste entre uma fazenda acolhedora e uma invasão de pragas ajuda a reconhecer o jogo rapidamente.

**Públicos iniciais a testar:** pessoas que gostam de jogos de sobrevivência com hordas, builds e partidas repetíveis; fãs de pixel art; público que acompanha jogos independentes brasileiros. Não tratar essas hipóteses como dados de audiência já comprovados.

### Estado real em 17/10/2026

| Assunto | O que podemos comunicar |
|---|---|
| Desenvolvimento | Jogo em desenvolvimento, com gameplay, interface rural e sprites animados integrados. |
| Plataforma | Projeto voltado a Android; a versão atual foi validada em Windows. Testes em aparelho Android físico ainda estão pendentes. |
| Distribuição | Não há APK público, página de loja ou link de playtest confirmado neste guia. |
| Lançamento e preço | Ainda não anunciados. Não prometer data, gratuidade ou modelo de monetização. |
| Código | [Repositório do projeto](https://github.com/ArturMuniz/Fazendeiro_Frenetico). É código-fonte Godot, não instalador para o público. |
| Chamada atual | “Acompanhe o desenvolvimento”, “Qual personagem você escolheria?” ou outra pergunta ligada ao vídeo. |

Não usar “baixe agora”, “já disponível”, “adicione à wishlist” ou selo de loja sem existir uma página correspondente. A ambição visual não equivale a afirmar que o jogo já está finalizado.

## 3. O que existe no gameplay

### Ciclo da partida

**Escolher personagem → entrar no mapa → mover e sobreviver → ganhar XP → escolher melhorias → enfrentar o chefe → decidir como continuar.**

A campanha segue **Horta → Celeiro → Pomar ao Entardecer**. Cada mapa tem três fases regulares e um chefe. Após a vitória, é possível avançar para o próximo mapa com a build reiniciada, continuar no modo livre preservando a build com dificuldade crescente ou encerrar e ver o resultado. Também há ouro, desbloqueio de personagens e melhorias permanentes da fazenda.

### Personagens

| Personagem | Identidade visual a preservar | Gameplay atual | Gancho de conteúdo |
|---|---|---|---|
| Fazendeiro Clássico | Homem jovem sem barba; chapéu marrom de aba larga, camisa xadrez azul, jeans e botas marrons. | Equilibrado; começa com Foice Giratória. | “O básico da roça resolve?” |
| Vovó Resistente | Cabelos grisalhos, óculos redondos, chapéu de palha, blusa floral e avental verde. | Mais vida, menos velocidade; começa com Motosserra Enferrujada. | “A Vovó veio resolver o problema.” |
| Netinho Ágil | Boné vermelho para trás, camiseta listrada verde e branca, shorts jeans, mochila e botas. | Mais velocidade, menos vida; começa com Milho-Metralhadora. | “Velocidade salva essa partida?” |

Os três aparecem juntos em algumas ilustrações. Isso representa o elenco: **o jogo atual é para um jogador**, sem modo cooperativo implementado. Um acessório desenhado no sprite não determina sua arma inicial.

### Armas e possibilidades de vídeo

| Arma | Funcionamento atual, em linguagem simples | O que mostrar |
|---|---|---|
| Foice Giratória | É lançada contra um inimigo próximo e gira. | Trajetória e inimigos atingidos. |
| Milho-Metralhadora | Dispara rapidamente contra o inimigo mais próximo. | Cadência de tiros de milho. |
| Forquilha / Tridente de Feno | Estocada de curto alcance em um alvo. | Posicionamento e alcance curto. |
| Canhão de Batata | Tiro forte e lento com dano em área; níveis superiores podem atravessar alvos. | Explosão em um grupo. |
| Estilingue de Mamona | Projétil que ricocheteia. | Um disparo passando entre inimigos. |
| Motosserra Enferrujada | Dano contínuo nos inimigos próximos; evolução visual até Motosserra de Ouro. | Inimigos entrando na área de dano. |
| Bezerro Guarda-Costas | Companheiro com ataque de contato e evolução visual. | O companheiro durante o combate. |
| Cerca Elétrica | Armadilha temporária estacionária. | Uma área de passagem dos inimigos. |

As armas têm três níveis. Existem cinco passivos que complementam a build. Não inventar raridades, habilidades ou números: quando o vídeo comparar níveis, copiar os valores da versão gravada e registrar qual arma e nível foram usados.

“Vaca Voadora” é uma evolução visual do companheiro; não prometer uma mecânica de voo. A Cerca Elétrica não é um sistema de construção livre de cercas.

### Inimigos e chefes

| Grupo | Identidade atual |
|---|---|
| Pragas comuns | Pulgão Corredor, Lesma Tanque, Gafanhoto Saltador e Mosca Atiradora. |
| Chefe da Horta | **Lagarta Titã:** lagarta verde gigante e segmentada. |
| Chefe do Celeiro | **Rainha das Moscas:** mosca azul/violeta, olhos alaranjados, asas claras e coroa dourada. |
| Chefe do Pomar | **Gafanhoto Gigante:** tons ocres/oliva, corpo grande e pernas traseiras fortes. |

A Mosca Atiradora comum não usa coroa. Outros bichos presentes em arquivos de arte podem ser reservas para o futuro; não anunciá-los como inimigos implementados.

### Limites para manter a comunicação fiel

O jogo atual não possui multiplayer, tiro manual, dash ativo, cultivo/colheita como simulador agrícola ou sistema de raridade de cartas. “Defender a colheita” funciona como tema narrativo da divulgação. Não apresentar uma dessas ideias como funcionalidade só porque a IA conseguiu ilustrá-la.

## 4. Identidade visual e tom

**Direção:** fazenda artesanal sob ataque, em pixel art. Contornos escuros, silhuetas legíveis, poucos tons por material, luz quente e ferramentas reconhecíveis. A ação pode ser exagerada, mas os personagens devem continuar iguais às referências.

| Uso | Cor de referência |
|---|---|
| Madeira | `#704426` |
| Contorno escuro | `#281D17` |
| Pergaminho | `#F1E2BF` |
| Texto escuro | `#2B2118` |
| Vida / ameaça | `#BC4036` |
| XP / destaque ciano | `#429DA6` |
| Ouro | `#E7B94C` |

**Voz:** brasileira, direta, bem-humorada e acolhedora. Os personagens são competentes e carismáticos. Evitar sotaque escrito forçado, piadas que ridicularizem pessoas do campo e tratar a Vovó apenas como frágil.

**Vocabulário útil:** pragas, fazenda, ferramentas, sobrevivência, melhorias, combinação de armas, build, chefes, cada partida.

**Títulos aprovados como direção de texto:**

- “A colheita está ameaçada!”
- “A Vovó veio resolver.”
- “Isso era só uma batata…”
- “Qual ferramenta você levaria?”
- “As pragas cresceram.”

Escrever sempre **O Fazendeiro Frenético**, com acento. “Fazendeiro Caótico” aparece em nomes internos antigos e não deve virar o nome público. “Frenético” não é uma promessa de quantidade específica de inimigos ou desempenho.

### Três tipos de material

| Material | Como produzir e apresentar |
|---|---|
| Gameplay real | Captura da versão do jogo identificada na ficha de produção. Pode receber cortes e legendas, preservando o que realmente aconteceu. |
| Arte promocional | Ilustração baseada nos sprites. Identificar como arte promocional na legenda ou contexto do post. |
| Devlog | Mostrar uma mudança real de desenvolvimento. Identificar antes/depois e versões; não fabricar um “antes ruim” com IA. |

Uma ilustração animada por IA continua sendo uma ilustração. Não montar HUD falso, números de dano ou controles para apresentá-la como gameplay.

## 5. Materiais deste kit

| Arquivo | Uso sugerido | Observação |
|---|---|---|
| [01_defenda_sua_colheita.png](artes/01_defenda_sua_colheita.png) | Apresentação do universo e capa. | 1092 × 1440 px. |
| [02_escolha_seu_personagem.png](artes/02_escolha_seu_personagem.png) | Apresentação do elenco e pergunta ao público. | 1122 × 1402 px. |
| [03_enfrente_os_chefes.png](artes/03_enfrente_os_chefes.png) | Revelação das pragas gigantes. | 1122 × 1402 px. |
| [04_combine_e_evolua.png](artes/04_combine_e_evolua.png) | Armas, melhorias e variedade. | 1122 × 1402 px. |
| [referencias_jogo.png](referencias/referencias_jogo.png) | Anexar à IA para preservar identidade. | Prancha com designs reais do jogo; não é screenshot. |
| [PROMPTS_ORIGINAIS.md](PROMPTS_ORIGINAIS.md) | Consultar os prompts usados nas quatro artes. | Histórico criativo, sem exigir reprodução idêntica. |

As quatro peças foram geradas com IA a partir de referências do projeto. São imagens opacas com títulos incorporados. Não presumir que possuem camadas editáveis, transparência ou proporção exata de uma rede social. Para novos layouts, preferir uma arte sem texto e compor a tipografia no editor.

## 6. Formatos e edição para redes

A orientação oficial do TikTok para peças publicitárias recomenda vídeo vertical 9:16, resolução de pelo menos 1080 × 1920, ação cedo e atenção às áreas cobertas pela interface. Vamos adaptar essa orientação como ponto de partida para conteúdo orgânico, sem promessa de alcance. [Fonte: TikTok for Business](https://ads.tiktok.com/business/en/guides/video-advertising-guide?redirected=1), consultada em 17/10/2026.

Os formatos abaixo são **padrões de produção escolhidos para este projeto**, não uma lista de limites obrigatórios de cada plataforma.

| Entrega | Tamanho de trabalho | Aplicação |
|---|---|---|
| Vídeo vertical principal | 1080 × 1920, 9:16 | TikTok, Reels e Shorts; adaptar capa e legenda por rede. |
| Story vertical | 1080 × 1920, 9:16 | Bastidores, enquete e chamada para novo conteúdo. |
| Post de feed vertical | 1080 × 1350, 4:5 | Personagens, cartazes e carrosséis. |
| Post quadrado | 1080 × 1080, 1:1 | Versão alternativa de cards e anúncios da comunidade. |
| Arte horizontal | 1920 × 1080, 16:9 | Capa de vídeo horizontal e divulgação em tela ampla. |
| Banner de perfil | Definir após escolher a rede | Fazer layout próprio e testar recortes de celular e computador. |

O YouTube aceita Shorts quadrados ou verticais de até três minutos nas condições descritas em sua documentação. Os roteiros curtos deste guia são uma escolha editorial, não o limite do formato. [Fonte: Ajuda do YouTube](https://support.google.com/youtube/answer/15424877?hl=pt-BR).

### Regras práticas de montagem

- Abrir com uma situação ou personagem reconhecível; colocar o título do jogo depois que a ideia já começou.
- Usar uma ideia principal por vídeo. Começar testando durações entre 15 e 25 segundos.
- Manter rostos, ação importante e legendas longe da borda direita e das áreas superior/inferior ocupadas pela interface. A margem final depende da prévia de cada aplicativo.
- Uma ou duas linhas curtas de legenda por vez, com contraste. O vídeo precisa continuar compreensível sem áudio.
- Preservar a proporção original. Para adaptar as artes existentes, usar fundo derivado da própria composição ou reorganizar a cena; não esticar personagens nem cortar os títulos.
- Como teste inicial de leitura, deixar a ideia principal na faixa central e conferir a peça no tamanho de um celular. Não transformar essa faixa em uma “zona segura universal”.
- Exportar vídeo em MP4, H.264 com áudio AAC. Manter o FPS coerente com a captura; não anunciar “60 FPS” sem medição da versão mostrada.
- Para pixel art, evitar suavização que apague contornos. Nas ilustrações mais detalhadas, conferir se a redução mantém olhos, mãos e ferramentas legíveis.
- Guardar o projeto editável, arte limpa, legendas e áudio separados. Exportar um arquivo limpo para cada rede, sem marca d’água de outro aplicativo.

Escolher música, efeitos e vozes com permissão para o uso pretendido e para a rede de destino. Não presumir que uma trilha disponível em um aplicativo pode ser reutilizada em todos os outros. Conferir também as opções de identificação de conteúdo gerado por IA na plataforma ao publicar.

## 7. Roteiros prontos para produzir

Os tempos são guias de edição. Cada roteiro pede gravação real onde indicado. Se o trecho necessário não estiver disponível, adaptar o texto ao que foi capturado.

### Vídeo A — “Isso era só uma batata…” — 18 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–2 s | Gameplay: projétil do Canhão de Batata perto de um grupo. | “Isso era só uma batata…” |
| 2–7 s | Mostrar o impacto real e a reação dos inimigos. | “…até as pragas invadirem a fazenda.” |
| 7–12 s | Dois cortes de combate com a mesma arma. | “Canhão de Batata. Problema rural, solução improvisada.” |
| 12–15 s | Nome do jogo sobre um trecho legível. | “O Fazendeiro Frenético — em desenvolvimento.” |
| 15–18 s | Encerrar com outra ação curta. | “Qual ferramenta vira arma depois?” |

**Legenda:** “A solução estava na horta. 🥔 O Fazendeiro Frenético está em desenvolvimento. Qual arma você quer ver no próximo vídeo?”  
**Material necessário:** captura normal com o canhão; áudio do disparo ou efeito autorizado. Não inventar a quantidade de dano ou inimigos atingidos.

### Vídeo B — “A Vovó veio resolver” — 20 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–3 s | Retrato da Vovó, corte rápido para gameplay dela. | “Chamaram reforço para a fazenda.” |
| 3–9 s | Vovó com Motosserra Enferrujada em combate real. | “A Vovó veio resolver.” |
| 9–14 s | Movimento entre inimigos; mostrar uma situação clara. | “Mais vida. Menos velocidade. Como você jogaria?” |
| 14–17 s | Retrato e nome. | “Vovó Resistente.” |
| 17–20 s | Nome do jogo e CTA. | “Vovó, Fazendeiro ou Netinho? Escolha nos comentários.” |

**Legenda:** “A Vovó não veio passear. Qual personagem você quer conhecer melhor?”  
**Material necessário:** Vovó desbloqueada na versão de captura; retrato real. Não acelerar apenas essa personagem em uma comparação de velocidade.

### Vídeo C — “A praga cresceu” — 22 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–3 s | Entrada real da Lagarta Titã ou detalhe da arte, identificado como ilustração. | “Era para ser só uma lagarta…” |
| 3–8 s | Gameplay real da luta na Horta. | “Conheça a Lagarta Titã.” |
| 8–15 s | Esquiva por movimento, ataque e situação de pressão que realmente ocorreram. | “O ataque é automático. Sobreviver depende de você.” |
| 15–19 s | Melhor trecho da luta, sem antecipar vitória inexistente. | “Você passaria dessa?” |
| 19–22 s | Identidade do jogo. | “Acompanhe O Fazendeiro Frenético.” |

**Legenda:** “A Horta ganhou um problema gigante. Esse é um dos chefes do jogo em desenvolvimento.”  
**Material necessário:** encontro normal com o chefe. Não usar a cena de testes com os três chefes reunidos como se fosse uma batalha normal da campanha.

### Vídeo D — “Três ferramentas, uma escolha” — 18 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–3 s | Três ícones reais: foice, milho e motosserra. | “Qual você levaria para a fazenda?” |
| 3–6 s | Gameplay com a foice. | “Foice Giratória.” |
| 6–9 s | Gameplay com milho. | “Milho-Metralhadora.” |
| 9–12 s | Gameplay com motosserra. | “Motosserra Enferrujada.” |
| 12–15 s | Tela real de melhoria ou montagem dos ícones. | “Escolhas mudam sua partida.” |
| 15–18 s | Opções numeradas e título. | “1, 2 ou 3? Conta sua escolha.” |

**Legenda:** “Cada ferramenta tem um jeito de enfrentar as pragas. Hoje, qual seria sua primeira escolha?”  
**Material necessário:** três capturas e ícones reais. Comparação de preferência, sem afirmar qual arma é matematicamente melhor.

### Vídeo E — Teaser ilustrado — 15 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–4 s | Arte 01 com movimento suave. | “A colheita está ameaçada.” |
| 4–8 s | Arte 02 com aproximação leve. | “A fazenda tem quem a defenda.” |
| 8–12 s | Arte 03 com destaque para os chefes. | “Mas as pragas cresceram.” |
| 12–15 s | Marca sobre composição limpa. | “O Fazendeiro Frenético. Acompanhe o desenvolvimento.” |

**Legenda:** “Um pouco do universo de O Fazendeiro Frenético. Teaser com artes promocionais; jogo em desenvolvimento.”  
**Material necessário:** artes deste kit. Pode ser produzido sem gravação, mantendo a identificação de ilustração promocional.

### Vídeo F — Devlog visual — 20 s

| Tempo | Imagem | Texto / fala |
|---|---|---|
| 0–3 s | Resultado atual em movimento. | “Olha como ficou o movimento do Fazendeiro.” |
| 3–8 s | Captura antiga real, se disponível. | “Antes — [versão/data].” |
| 8–14 s | Captura atual equivalente. | “Agora — [versão/data].” |
| 14–17 s | Detalhe da animação ou interface realmente alterada. | “Pequenos detalhes mudam a leitura da ação.” |
| 17–20 s | Fechar no gameplay atual. | “Qual detalhe você percebeu primeiro?” |

**Legenda:** “Bastidores do polimento. Comparação de duas versões reais do jogo.”  
**Material necessário:** duas versões comparáveis. Sem uma versão anterior disponível, transformar em apresentação da animação atual e retirar a comparação.

## 8. Plano inicial de duas semanas

Proposta orgânica para começar com **oito posts**, reaproveitando uma gravação em vários cortes. Ajustar à disponibilidade do criador; frequência não garante distribuição.

| Dia | Peça | Objetivo | CTA |
|---|---|---|---|
| 1 | Vídeo A: batata | Apresentar o diferencial rural em ação. | Qual ferramenta vira arma? |
| 3 | Carrossel do elenco | Tornar os três personagens reconhecíveis. | Escolha um personagem. |
| 5 | Vídeo B: Vovó | Criar vínculo com o elenco. | Quem quer ver depois? |
| 7 | Vídeo C: chefe | Mostrar o desafio real. | Você passaria dessa? |
| 9 | Vídeo D: armas | Explicar escolhas e estimular preferência. | 1, 2 ou 3? |
| 11 | Vídeo F: devlog | Mostrar progresso concreto. | Qual detalhe percebeu? |
| 13 | Vídeo E: teaser | Reforçar universo e identidade. | Acompanhe o desenvolvimento. |
| 14 | Resposta em vídeo a uma pergunta real | Aproximar a comunidade. | Nova pergunta ligada à resposta. |

**Adaptação por rede:** TikTok com gancho direto e pergunta; Reels com capa legível e legenda curta; Shorts com título descritivo; feed com carrossel de personagem/arma; Stories com bastidores e enquete. Não copiar uma pergunta que dependa de comentário ou enquete indisponível naquele formato.

Para o primeiro carrossel: capa “Quem vai defender a fazenda?” → um slide por personagem com uma característica → último slide “Qual você escolheria?”. Não colocar o texto pequeno das fichas técnicas em uma imagem de celular.

**Hashtags iniciais para testar:** `#FazendeiroFrenetico #GameIndie #Roguelite #PixelArt #GameDevBR`. Selecionar as relacionadas à peça; não usar tags de disponibilidade, lojas ou jogos concorrentes para sugerir associação.

## 9. Contexto mestre para usar com IA

Copie o bloco abaixo e **anexe as referências visuais reais**. O texto sozinho não fornece acesso aos arquivos do kit. Depois acrescente a tarefa específica, como “crie três composições de cartaz sem texto”.

```text
Você está criando material promocional para O Fazendeiro Frenético,
um jogo brasileiro 2D em pixel art, de sobrevivência roguelite rural.
O jogador controla o movimento e as armas atacam automaticamente.
Há três personagens jogáveis individualmente, ferramentas rurais usadas
como armas e pragas gigantes como chefes. O jogo está em desenvolvimento.

Use os anexos como referência obrigatória de design. Preserve silhuetas,
roupas, cores e ferramentas. Fazendeiro: jovem sem barba, chapéu marrom,
camisa xadrez azul, jeans, botas. Vovó: cabelo grisalho, óculos redondos,
chapéu de palha, blusa floral e avental verde. Netinho: boné vermelho
para trás, camiseta listrada verde/branca, shorts jeans e mochila.

Direção: pixel art rural calorosa, contornos marrom-escuros, luz dourada,
madeira, terra, vegetação e pergaminho. Silhuetas claras, ação legível,
humor nas ferramentas, personagens heroicos e carismáticos.
Paleta-base: #704426, #281D17, #F1E2BF, #BC4036, #429DA6, #E7B94C.

Não criar fotorrealismo, anime, estética 3D ou cenários urbanos modernos.
Não mudar rostos/roupas, duplicar membros ou misturar personagens.
Não inventar multiplayer, cultivo jogável, novas armas ou mecânicas.
Se os três personagens aparecerem juntos, é uma composição ilustrativa
do elenco, não uma captura de partida cooperativa.

Entregar arte promocional sem texto, sem HUD e sem marcas d'água.
Reservar espaço para título e chamada adicionados posteriormente no editor.
Priorizar integridade de mãos, olhos, chapéus e armas; nada cortado por acidente.
Não apresentar a imagem como screenshot do jogo.
```

### Pedido de cartaz vertical — personagem

```text
Com base no contexto e nas referências anexadas, criar uma ilustração
promocional vertical com a Vovó Resistente como foco principal.
Ela segura a Motosserra Enferrujada com postura firme, cercada por poucas
pragas da referência, em um celeiro rural com luz quente.
Preservar o modelo da personagem e o desenho da arma. Composição legível
em celular, personagem inteira, contraste entre figura e fundo.
Reservar o topo para título e uma pequena área inferior para a marca.
Sem texto, sem interface e sem supor novas funcionalidades.
Enquadramento de trabalho 4:5; confirmar as dimensões do resultado.
```

**Texto a inserir no editor:** “A Vovó veio resolver.” / “O Fazendeiro Frenético” / “Em desenvolvimento”.

### Pedido de banner horizontal — universo

```text
Criar arte promocional horizontal 16:9 para O Fazendeiro Frenético,
usando as referências anexadas e o contexto mestre.
Fazendeiro Clássico com Foice Giratória no terço direito; a Horta e
uma silhueta reconhecível da Lagarta Titã ao fundo. Luz de fim de tarde,
terra, madeira e vegetação em pixel art coesa com os anexos.
Manter a área esquerda visualmente simples para título e chamada no editor.
Não cortar cabeça, chapéu, mãos ou a ferramenta. Sem texto e sem HUD.
É uma ilustração promocional, sem simular screenshot ou interface jogável.
```

**Texto a inserir no editor:** “Defenda sua colheita!” / “Sobrevivência rural em pixel art” / marca do jogo.

## 10. Animar as artes no Google Flow ou outra IA de vídeo

Use a arte como referência de entrada quando o modo escolhido permitir. Estes prompts descrevem o resultado desejado, não garantem duração, resolução, transparência ou controles disponíveis em uma ferramenta. Confira cada saída. Uma alternativa simples é fazer aproximação e deslocamento no editor usando a imagem estática; isso preserva melhor títulos já incorporados.

### Instrução comum de consistência

```text
Animar discretamente a ilustração de referência, preservando composição,
pixel art, identidade, número de personagens, anatomia e desenho das armas.
Movimento de câmera lento, sem cortes bruscos e sem distorção de perspectiva.
Não redesenhar rostos, olhos, mãos, roupas ou títulos. Não adicionar personagens,
projéteis, golpes, HUD, efeitos de dano ou funcionalidades de gameplay.
Se houver letras incorporadas, mantê-las totalmente imóveis e idênticas.
Produzir uma vinheta ilustrativa, não uma simulação de partida.
```

| Arte de entrada | Complemento de prompt | Rejeitar a saída se… |
|---|---|---|
| 01 — Defenda sua colheita | “Aproximação muito suave em direção ao grupo; poeira leve ao fundo e vegetação com movimento discreto. Corpos e ferramentas permanecem estáveis.” | Houver troca de rosto, chapéu ou arma; título oscilar. |
| 02 — Personagens | “Pequeno deslocamento lateral de câmera para apresentar o elenco; brilho ambiente suave. Não trocar poses nem criar caminhada.” | O elenco fundir, ganhar membros ou mudar proporção. |
| 03 — Chefes | “Aproximação lenta para valorizar a escala das pragas; leve mudança de luz no cenário. Chefes preservados, sem inventar ataques.” | A coroa migrar para outra mosca ou espécies se misturarem. |
| 04 — Combine e evolua | “Profundidade sutil entre fundo e elementos já existentes. Armas, ícones e textos conservam desenho e posição relativa.” | Ícones se transformarem, texto deformar ou surgir carta falsa. |

Começar com trechos curtos de aproximadamente 4–6 segundos, conforme os controles disponíveis, e montar o vídeo no editor. Não chamar essas vinhetas de animações implementadas dentro do jogo. Para gerar novas bases, preferir arte sem títulos e inserir todo texto depois.

### Modelo de pedido de roteiro à IA

```text
Usando somente os fatos do contexto fornecido, proponha três versões de um
vídeo vertical de 20 segundos sobre [PERSONAGEM/ARMA/CHEFE].
Entregue tabela com tempo, captura real necessária, legenda na tela,
narração opcional e uma chamada final. O gancho deve aparecer nos primeiros
segundos. Não invente resultados, números, recursos ou disponibilidade.
Indique quais cenas são gameplay real e quais são arte promocional.
Use português brasileiro simples e humor rural respeitoso.
```

## 11. Como captar gameplay útil

1. Registrar a versão/data e escolher uma partida normal com HUD real.
2. Gravar por personagem/arma, com alguns segundos de folga antes e depois da ação.
3. Captar movimento, ataques, seleção de melhoria, chefe e resultado como trechos separados.
4. Para comparação de armas ou personagens, manter condições semelhantes e informar os níveis quando forem relevantes.
5. Gravar sem mensagens do editor, ponteiro cobrindo a ação ou notificações pessoais. Manter legível a orientação da tela do jogo.
6. Se a captura não preencher 9:16, compor um layout com fundo e texto; não deformar o gameplay para preencher a tela.

**Atenção aos arquivos de teste do projeto:** algumas capturas de revisão mostram os três chefes juntos ou estados preparados para verificar arte. Elas não representam encontros normais da campanha. Usá-las apenas em conteúdo de bastidores com essa explicação. Para trailers de gameplay, gravar uma partida normal.

**Lista de captação inicial:** 3 personagens em movimento; 3 armas em ação; 1 escolha de melhoria; 1 chefe em sua arena; tela de vitória/derrota de uma run real. Não é necessário mostrar todos os sistemas no mesmo vídeo.

## 12. Como avaliar o que funcionou

Comparar conteúdo com objetivo e duração semelhantes. Avaliar os dados após uma janela consistente — por exemplo, 48 horas e sete dias — sem descartar um vídeo apenas pela primeira hora.

| Sinal | O que observar | Decisão possível |
|---|---|---|
| Retenção inicial, se disponível | As pessoas passam da abertura? | Trocar o primeiro plano ou encurtar o texto. |
| Tempo médio / conclusão | A ideia mantém interesse até o fim? | Reduzir espera, melhorar clareza ou testar outra duração. |
| Compartilhamentos e salvamentos | O conteúdo desperta vontade de repassar ou guardar? | Repetir o tema com outra situação real. |
| Comentários relevantes | Há perguntas sobre armas, personagens ou como jogar? | Transformar dúvidas em novos vídeos. |
| Visitas ao perfil e seguidores | O vídeo desperta interesse no projeto? | Tornar a identidade e a chamada mais claras. |

As definições e a disponibilidade das métricas variam por rede. Comparar taxas usando o mesmo denominador dentro da mesma plataforma; conclusão de um vídeo de 10 segundos não é equivalente à de um vídeo de 40 segundos. Não estabelecer meta de “viralização” ou porcentagem ideal sem dados próprios.

**Teste simples:** produzir duas aberturas para o mesmo tema, mudando apenas o gancho. Registrar também dia, duração e tipo de conteúdo. O resultado orienta a próxima peça; não prova sozinho uma regra do algoritmo.

### Ficha de produção e resultado

```text
Peça / arquivo:
Rede e URL publicada:
Data de publicação:
Versão do jogo capturada:
Tema e objetivo:
Gancho utilizado:
Duração / formato:
Material: gameplay real / ilustração / devlog
Origem e permissão de áudio/imagens:
Chamada final:
Resultados após 48 h e 7 dias:
O que testar na próxima peça:
```

## 13. Informações a completar com Artur

| Campo | Preencher antes de usar em peças públicas |
|---|---|
| Perfil oficial do TikTok | [PREENCHER] |
| Instagram / YouTube / outras redes | [PREENCHER] |
| Link oficial da bio | [PREENCHER; enquanto não existir, usar CTA de acompanhamento na própria rede] |
| Como receber notícias do projeto | [PREENCHER; não inventar Discord, formulário ou mailing] |
| Crédito do criador de conteúdo | [PREENCHER] |
| Data de lançamento | Não anunciada; atualizar somente com decisão confirmada. |
| Preço / monetização | Não anunciados. |
| Playtest ou APK público | Não confirmado. |
| Verba para mídia paga | Plano atual proposto: orgânico; orçamento a definir se houver campanha paga. |

Artur mantém as informações de funcionalidades, versões e disponibilidade. O parceiro transforma esse contexto em peças, registra as fontes e devolve dúvidas recorrentes do público para orientar novos conteúdos. Novidades ainda não confirmadas devem aparecer como ideia ou bastidor, nunca como promessa de lançamento.

## 14. Conferência final de cada peça

- Nome do jogo e acentos corretos; personagem e ferramenta fiéis às referências.
- Texto legível em celular, sem cortes por interface, sem mãos/rostos deformados ou fundo branco acidental.
- Gameplay real distinguido de arte promocional; nenhum recurso ou resultado inventado.
- Uma mensagem principal e uma chamada final que o público consegue cumprir.
- Áudio e imagens com uso verificado; classificação de IA conferida na rede de destino.
- Arquivo final e projeto editável guardados; versão capturada e data registradas.

**Primeira entrega sugerida ao parceiro:** vídeo da batata, carrossel dos personagens e vídeo da Vovó. Esse conjunto apresenta o conceito, o elenco e o combate sem depender de anúncio de lançamento.
