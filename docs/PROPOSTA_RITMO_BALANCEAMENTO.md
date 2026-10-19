# Proposta de ritmo, spawn e balanceamento

Data: 18/10/2026. Status: **proposta para discussão e experimentos; nenhum valor de gameplay alterado**.

Nota posterior: este diagnóstico registra a base anterior ao feedback no S24+. O [pacote 0.24.2](feedback_s24/README.md) implementa três armas por run, líderes e novos atributos. Os ciclos de pressão propostos neste documento ainda não foram ativados.

Direção escolhida pelo Artur: o jogo fica fácil/repetitivo depois de alguns minutos; manter **combate contínuo com ondas de pressão e respiros curtos**.

Objetivo: fazer o jogador perceber crescimento de poder e precisar mudar de decisão durante a partida. O motivo para tentar novamente deve ser uma build que quer experimentar, um encontro que aprendeu a vencer ou um objetivo claro.

## Diagnóstico do código atual

| Evidência | Consequência de design / hipótese |
|---|---|
| `enemy_spawner.gd` sorteia um arquétipo com chances iguais e cria um inimigo por timeout | A distribuição temporal e espacial tem pouca identidade; faltam encontros montados por função |
| As fases duram 100, 110 e 120 segundos | O ritmo estrutural muda em intervalos longos; dentro delas muda principalmente o multiplicador de HP/dano |
| Horta gera um inimigo a cada 1,8 / 1,4 / 1,1 s | Antes de caps e particularidades dos timers, cerca de 55,6 / 78,6 / 109,1 inimigos por fase; isso é vazão de geração, não contagem simultânea |
| HP e dano na Horta vão aproximadamente de ×1 a ×1,75 nas fases, e ×1,9 no chefe | As armas e o inventário podem crescer mais rápido que a pressão oferecida; confirmar com partidas medidas |
| Fazendeiro tem velocidade 120; Pulgão 110; Lesma 35; chefes perseguidores 50/60 | Fugir em trajetórias amplas tende a resolver muitas situações. O Gafanhoto tem avanço rápido intermitente, mas não equivale a perseguição constante |
| Horta não usa Mosca nas três fases nem nos adds do chefe | A primeira campanha pressiona sobretudo por aproximação; há pouca cobrança de prioridade contra atiradores |
| Spawn usa um círculo de raio 400 ao redor do jogador | Não acompanha a área visível da câmera. Em retrato, algumas origens podem estar dentro da tela |
| Limite de 100 inimigos simultâneos | É um limite técnico existente, não uma meta para manter 100 na tela |
| Dano permanente pode chegar a +6 por acerto | Milho nível 1 passa de 3 para 9 de dano antes das cartas da run: ganho de 200%. Precisamos separar testes sem meta e com meta |
| Adubo Turbinado dá +3 por acerto/tick | O mesmo investimento beneficia de formas diferentes armas rápidas, áreas, ricochetes e disparos lentos |
| Café tem piso de ×0,25 nas armas compatíveis; a oferta genérica continua disponível no piso | Uma escolha pode deixar de produzir efeito útil e ainda ocupar carta |
| Cartas começam num pool uniforme de 17 opções (4 atributos, 8 armas, 5 passivos) | A arma inicial tem 3/17, aproximadamente 17,6%, de chance de aparecer entre as primeiras três cartas. Sem pesos, construir uma intenção depende muito do sorteio |
| Aumento de velocidade de +15% pode ser escolhido repetidamente | O crescimento pode reduzir ainda mais a necessidade de interagir com ameaças de aproximação |

Essas observações são derivadas dos scripts. A relação com a sensação de facilidade é uma hipótese de design, reforçada pelo relato do jogador; não é resultado de telemetria em várias pessoas.

Fontes locais principais: `enemy_spawner.gd`, `enemy_db.gd`, `map_db.gd`, `weapon_db.gd`, `player.gd`, `level_up_ui.gd`, `farm_upgrade_db.gd`, scripts de armas e `projectile.gd`.

## O que aproveitar da referência Brotato

A wiki descreve ondas com progressão e encontros especiais, armas com classes/escalamentos diferentes e probabilidades de loja que favorecem em parte armas/classes já equipadas. A adaptação proposta é usar **encontros com função, sinergias compreensíveis e aleatoriedade que ajuda a construir uma intenção** dentro da nossa campanha contínua.

Fontes consultadas:

- [Waves](https://brotato.wiki.spellsandguns.com/Waves): organização das ondas, elites e hordas.
- [Weapons](https://brotato.wiki.spellsandguns.com/Weapons): classes, combinações e escalamento. A página informa patch 1.1.6.3; não se pressupõe que todos os números representem a última versão do jogo.
- [Shop](https://brotato.wiki.spellsandguns.com/Shop): sorteios com viés para equipamentos/classes presentes.
- [Enemies](https://brotato.wiki.spellsandguns.com/Enemies): inimigos com comportamentos diferentes e introdução progressiva.

A wiki é comunitária. O plano abaixo é uma proposta própria para o Fazendeiro, sem importar números de Brotato.

## Experimento 1: ritmo dentro da campanha atual

Começar somente pela Horta, preservando as três fases e os valores atuais das armas. Testar um ciclo interno de **40 segundos**:

| Trecho do ciclo | Intensidade relativa de geração | Sensação desejada |
|---|---:|---|
| 0–8 s: preparação | ×0,65 | Reposicionar e recolher XP; ainda existem inimigos |
| 8–24 s: crescimento | ×1,00 | Frente principal se forma |
| 24–32 s: pico | ×1,70 | Resolver uma situação curta e reconhecível |
| 32–40 s: respiro | ×0,65 | Limpar sobreviventes e preparar o próximo encontro |

A média desses multiplicadores num ciclo completo é exatamente ×1. Normalizar também no intervalo real de cada fase, pois 100/110/120 s não são múltiplos de 40. A primeira comparação deve manter aproximadamente a quantidade e o XP potencial do controle, redistribuindo o momento e a formação dos encontros. Isso permite descobrir se o ritmo melhora antes de aumentar a dificuldade total.

**Esses coeficientes são um ponto de partida experimental, não valores finais.** Intensidade de geração não mede sozinha a pressão: inimigos anteriores continuam vivos durante o respiro. Não limpar a arena ou deixar invulnerabilidade automática em cada ciclo.

Exemplos de encontros com os inimigos existentes:

- **Infestação de Pulgões:** grupos pequenos por uma frente; recompensa área e abertura de caminho.
- **Lesmas na frente:** poucas unidades resistentes desviam o percurso; inimigos leves aproveitam a abertura.
- **Salto do Milharal:** saltadores alternados pressionam reposicionamento, com espaço de saída visível.
- **Moscas no Celeiro:** atiradores com limite de quantidade exigem prioridade enquanto uma frente leve se aproxima.

O primeiro teste usa apenas os arquétipos já permitidos em cada fase. Introduzir Moscas na Horta, inimigos novos ou elites fica para uma comparação posterior, para não misturar causas.

## Spawn justo e controlável

O diretor deve montar encontros, não apenas aumentar a velocidade do Timer:

- Origem calculada a partir da câmera e da área visível; manter uma distância mínima segura do jogador.
- Formação e direção escolhidas por encontro, evitando cercos instantâneos por todos os lados.
- Aviso legível para entradas excepcionais e ataques especiais; começar avaliando avisos de 0,6–0,8 s.
- Uma rota de saída planejada e testada. Saída teoricamente aberta, mas já tomada por sobreviventes, não conta como rota segura.
- Limites separados para quantidade total, atiradores, saltadores e projéteis; preservar inicialmente o hard cap existente de 100 inimigos.
- Ritmo de chegada considerado por direção. Numa tela alta, surgir acima/abaixo pode implicar mais tempo de aproximação que surgir nas laterais.
- Orçamento não gasto não pode acumular indefinidamente e ser despejado após pausa, limite de entidades ou retorno de checkpoint.

Na segunda iteração, dar custos relativos aos arquétipos e um orçamento por encontro. Os custos precisam refletir ameaça e trabalho para matar; não basta contar um Pulgão e uma Lesma como unidades equivalentes. Ajustar também o XP potencial da composição, para não acelerar a build involuntariamente.

O diretor não deve aumentar secretamente HP/dano porque o jogador montou uma build forte. A progressão precisa continuar recompensando boas escolhas.

## Armas: função antes de ranking

As funções abaixo são alvos de design; algumas exigem melhorias de alvo ou efeitos e ainda não estão implementadas.

| Arma | Função desejada | Limitação que deve continuar perceptível |
|---|---|---|
| Foice | Limpar grupos em média distância e preparar áreas de dano | O giro fica no ponto arremessado; precisa de inimigos na região |
| Milho | Dano focalizado frequente e confiável | Deve ter custo de oportunidade frente a grandes multidões |
| Forquilha | Abater alvo resistente em curta distância | Exige aproximação; prioridade de alvo precisa apoiar essa função |
| Batata | Grandes grupos e explosões satisfatórias | Cadência baixa e eficiência dependente da densidade |
| Mamona | Dano distribuído entre inimigos próximos | Poucos alvos ou grande dispersão reduzem o valor dos ricochetes |
| Motosserra | Segurança de proximidade e limpeza ao redor | Exposição a dano e dificuldade contra ameaças distantes |
| Bezerro | Pressão auxiliar sobre um alvo e alcance indireto | Deslocamento e escolha de alvo influenciam o tempo realmente atacando |
| Cerca | Construir uma zona de dano e atrair inimigos por ela | Rendimento menor quando o jogador abandona a região |

### Evidências numéricas que merecem medição

Sem bônus, considerando apenas dano direto de um alvo continuamente disponível:

| Arma | Nível 1 | Nível 3 | DPS adicional de uma carta +3 no nível 3 |
|---|---:|---:|---:|
| Milho | 5,00 | 20,00 | +10,00 |
| Forquilha | 15,00 | 55,00 | +7,50 |
| Batata | 8,75 | 17,14 | +2,14 |
| Motosserra | 10,00 por alvo na área | 33,33 por alvo na área | +10,00 por alvo |

São contas de dano/intervalo sem bônus de velocidade, deslocamento, falta de alvo ou overkill. **Não constituem ranking de força.** A Batata também tem explosões e perfuração; a Motosserra pode atingir vários inimigos; a Forquilha depende do alcance; a Foice tem vários pulsos por arremesso. Essas diferenças precisam entrar no teste real.

No projétil atual da Batata, a explosão acontece em cada acerto; com perfuração, um único disparo pode causar várias explosões. Esse potencial cresce com a densidade, portanto um aumento de hordas pode fortalecê-la muito sem alterar sua tabela.

Possíveis soluções posteriores: coeficientes de bônus flat por arma, parte do ganho em porcentagem e/ou categorias simples de escalamento. Primeiro medir e escolher uma solução; evitar introduzir simultaneamente vários novos atributos.

A velocidade de ataque global afeta hoje Foice, Forquilha e projéteis. Aura, armadilha e companheiro mantêm seus próprios intervalos. Precisamos decidir se essa assimetria será identidade explícita das categorias ou se o atributo passará a ser universal.

## Construção de builds com intenção

Experimentar ofertas com três funções, quando houver candidatos válidos:

1. Uma oportunidade de melhorar algo já equipado.
2. Uma opção complementar ao estilo atual.
3. Uma surpresa para abrir outra direção.

Não significa oferecer sempre uma arma específica, garantir a melhor escolha ou repetir cartas inválidas. Quando uma categoria estiver esgotada, preencher com outra opção útil. Filtrar efeitos sem ganho efetivo, como redução de intervalo depois do piso.

Primeiras fantasias de build para discutir, sem bônus de conjunto ainda:

- **Roça Fechada:** Foice/Motosserra, sobrevivência próxima e domínio de espaço.
- **Pipocada:** Milho/Mamona, alcance e distribuição de tiros.
- **Terreiro Minado:** Cerca/Batata, preparação de terreno e explosões.

Só depois de validar funções vale avaliar pequenos bônus temáticos ou evoluções combinadas. Personagens devem incentivar rotas diferentes sem tornar uma única escolha obrigatória.

## Motivos para jogar outra partida

- Um encontro curto deixa uma história identificável: como escapou, qual inimigo precisava priorizar ou qual arma faltou.
- Melhorias dão mudanças percebidas no combate; não apenas números maiores na carta.
- Um objetivo opcional, como alcançar um cesto de colheita antes de desaparecer, oferece recompensa em troca de exposição. A arena continua atravessável.
- Resultado mostra contribuição da build e motivo da morte para apoiar aprendizado.
- Desbloqueios e desafios de personagem dão metas claras. Separar avaliação do jogador iniciante e de quem tem a fazenda evoluída.
- Anúncios continuam opcionais. A campanha deve ser justa e vencível sem retorno ou dobra por anúncio.

## Como calibrar com evidências

Registrar localmente por run/trecho: personagem, mapa, seed, meta-upgrades, build e níveis, inimigos gerados/vivos/abatidos por tipo, XP recebido, dano recebido por fonte, dano efetivo por arma, escolhas oferecidas/selecionadas, tempo até o chefe, tempo para matar o chefe e desempenho no aparelho.

Dano efetivo deve descontar overkill: causar 100 de dano num inimigo com 2 de vida conta como 2 para essa métrica. Dano de explosão deve ser atribuído à Batata e dano do companheiro à sua invocação. Medir também o tempo em que a arma consegue atacar; dano bruto total sozinho não mede utilidade.

Perguntas a responder:

- Quais trechos exigem mudar de direção ou prioridade?
- Quando uma build passa a eliminar tudo imediatamente?
- Alguma arma resolve simultaneamente hordas, chefes e sobrevivência sem contrapartida?
- O pico cria uma decisão ou só uma situação sem saída?
- O respiro é percebido mesmo com sobreviventes na tela?
- A progressão por XP acelera tanto que neutraliza a nova ameaça?
- O celular mantém a meta de 60 FPS nos picos? Observar também engasgos, não apenas média.

### Comparação inicial

1. Perfil controle: ritmo atual. Perfil experimental: ciclos e formações; mesmo dano/HP das tabelas e orçamento esperado semelhante de inimigos/XP.
2. Começar pela Horta com o Fazendeiro e o mesmo nível de meta-progressão. Depois testar Vovó e Netinho para identificar estratégias que escapam do desafio.
3. Usar streams de RNG separados para encontros e cartas; registrar seeds e decisões. Uma alteração no spawn não deve embaralhar inadvertidamente todas as cartas e impedir uma comparação útil.
4. Fazer uma triagem com cerca de dez runs por perfil, incluindo as três personagens e estados sem meta/com meta quando possível. É uma amostra exploratória para encontrar problemas grandes, não prova estatística de balanceamento.
5. Ajustar uma dimensão por vez: ritmo, depois composição, depois curva de atributos e armas. Não mudar todos os mapas e armas juntos.

## Dependências técnicas antes do protótipo

- Separar cronograma de campanha, orçamento de encontros e criação concreta via Pool. O diretor deve usar tempo de gameplay e respeitar todos os donos de pausa.
- O checkpoint precisa salvar posição no cronograma, orçamento acumulado/capado, encontros pendentes e estados dos RNGs. Restaurar somente o Timer antigo não é suficiente para o novo diretor.
- Há uma divergência já identificada: o spawner dá três intervalos de 4 s, inclusive antes do chefe, totalizando 342 s; o cálculo atual do checkpoint conta dois intervalos, usa 338 s e coloca a metade em 169 s. Centralizar a linha do tempo para que ambos usem a mesma definição. Pela regra de incluir os três respiros até o chefe, a metade seria 171 s. Não corrigido nesta análise.
- Animações e avisos não podem deslocar colliders nem ativar ataques durante a pausa.
- Manter contagem máxima de entidades, descartar dívida antiga de spawn e testar reset ao reiniciar e ao reviver.
- Adicionar atribuição de dano por fonte e agregação de telemetria sem dependência de um serviço externo.
- Preservar o APK atual como referência de comparação. O pacote experimental deve ser identificado e separado dos valores estáveis.

## Ordem recomendada

1. Medidas básicas e cronograma único, incluindo a correção de coerência do checkpoint.
2. Protótipo de ritmo/formações somente na Horta, com controle para comparação.
3. Qualidade das ofertas e filtros de escolhas sem efeito.
4. Balanceamento das armas a partir de contribuição e papel, incluindo a influência dos upgrades permanentes.
5. Expandir os encontros aprovados para Celeiro/Pomar e, por último, recalibrar o modo livre.
