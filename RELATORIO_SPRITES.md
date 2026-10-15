# Relatório de Sprites — O Fazendeiro Frenético

Auditoria de todos os arquivos do zip `fazendeiro_caotico_sripites.zip`: o que já está pronto e integrado, o que precisa de correção, e o que ainda falta ser criado.

---

## 1. Já processados e integrados no jogo

Passaram por remoção de fundo, recorte e redimensionamento, e já estão em `/art` sendo usados pelo código:

| Arquivo original | Uso no jogo |
|---|---|
| `1.1 Idle — 2 a 4 frames.png` | Personagem parado (`player_idle_0/1.png`) |
| `fazendeiro andando.jpg` | Personagem andando (`player_walk_0/1.png`) |
| `telsmatank-andando.jpg` | Inimigo Lesma Tanque (2 frames) |
| `gafanhoto-correndo.png` | Inimigo Gafanhoto Saltador (2 frames) |
| `boss-largatagi.jpg` | Boss Lagarta Titã |
| `foice-arma.jpg` | Ícone da Foice (visível no personagem) |
| `serraele-arma.jpg` | Ícone da Motosserra |
| `forquilha-arma.jpg` | Ícone da Forquilha |
| `metralhadora-arma.jpg` | Ícone do Milho (referência, projétil usa outro arquivo) |
| `canhaobatata-arma.jpg` | Ícone do Canhão de Batata |
| `estilinguemamona-arma.jpg` | Ícone do Estilingue de Mamona |
| `bala-e-rastro-milho.jpg` | Projétil do Milho |
| `bala-e-rastro-batata.jpg` | Projétil do Canhão de Batata |
| `projetil-mamona.jpg` | Projétil do Estilingue de Mamona |
| `barra-de-vida.jpg` | Moldura da barra de vida (HUD) |
| `garafatermica-item.jpg` | Processado e disponível (ainda sem uso na UI) |

---

## 2. Prontos, mas ainda NÃO integrados no código

Passaram na remoção de fundo sem problema — só falta eu conectar no jogo quando formos tratar dessa parte:

| Arquivo | O que é | Observação |
|---|---|---|
| `bezerro-andando.jpg` | Bezerro Guarda-Costas andando (4 poses) | Substitui o círculo colorido do companheiro |
| `bezerro_ataque.jpg` | Bezerro atacando (4 poses) | — |
| `boss-praga-ataque.jpg` | Efeito de ataque genérico de boss (3 variações) | — |
| `cercaeletrica-ataque.jpg` | Cerca Elétrica com efeito ativado | — |
| `estilinguemamona-arma-lv2-lv3-projetil.jpg` | Variações de nível + projétil da Mamona | Precisa fatiar em frames individuais |
| `foice-arma-lv2.jpg` | Foice nível 2 (4 variações) | Precisa fatiar |
| `forquilha-ataque.jpg` | Forquilha em movimento (4 poses) | — |
| `forquilha-arna-lv2-lv3.jpg` | Forquilha nível 2/3 | Precisa fatiar |
| `ricochete-mamona.jpg` | Efeito de ricochete da Mamona | Imagem meio apagada, conferir visualmente antes de usar |
| `morte_fazendeiro.jpg` | Animação de morte do personagem | Ainda não temos tela/lógica de morte animada |
| `morte-inimigos-geral.jpg` | Efeito de morte genérico (3 variações) | Serve pra qualquer inimigo comum |
| `serraele-arma-lv2-lv3.jpg` | Motosserra nível 2/3 (4 variações) | Precisa fatiar |
| `serraele-ataque.jpg` | Motosserra em ação (2 poses) | — |
| `joias-item.jpg` | Saco de moedas/gemas | Precisa decidir: moeda de run, moeda permanente, ou item novo? |
| `MOEDAS.jpg` | 2 ícones de moeda | — |
| `carta-de-escolha.jpg` | Moldura da carta de level-up | Hoje as cartas são só texto em botão |
| `joystick.jpg` | Base do joystick virtual | Substitui os retângulos coloridos atuais |
| `barra-de-xp.jpg` | Moldura da barra de XP | Ainda não existe barra de XP visível no HUD |

---

## 3. Precisam de correção antes de usar

### 3.1 Fundo não saiu limpo (fundo xadrez muito fino/ruidoso ou de cor diferente)

Minha remoção automática de fundo não consegue separar esses do quadriculado. **Melhor solução: reexportar como PNG com transparência real (canal alfa), sem desenhar o xadrez na imagem.**

| Arquivo | O que é |
|---|---|
| `bezerro-base.jpg` | Ícone/pose base do Bezerro |
| `bezerro-lv2-lv3.jpg` | Bezerro nível 2/3 |
| `cercaeletrica-arma.jpg` | Ícone da Cerca Elétrica |
| `cercaeletrica-arma-lv2-lv3.jpg` | Cerca Elétrica nível 2/3 |
| `pulgao-correndo.jpg` | Inimigo Pulgão Corredor |
| `pulgao-morte.jpg` | Morte do Pulgão |
| `espantalho-item.jpg` | Item passivo Espantalho de Bolso |
| `galocha-item.jpg` | Item passivo Galochas |
| `boss-rainha-das-moscas.jpg` | Boss Rainha das Moscas |
| `boss-gafanhoto.jpg` | Boss Gafanhoto Gigante |
| `foice-arma-lv3.jpg` | Foice nível 3 (parcialmente falhou) |
| `foice-ataque.jpg` | Efeito de ataque da Foice (parcialmente falhou) |

### 3.2 Têm texto/legenda desenhado dentro da imagem

Essas vieram com textos tipo "ORIGINAL", "NÍVEL 2", "COLEÇÃO DE SPRITES" escritos na própria arte — precisam ser recortadas manualmente (eu não consigo separar automaticamente o texto do resto) ou reexportadas sem o texto.

| Arquivo | O que é |
|---|---|
| `metralhadora-arma-lv2-lv3.jpg` | Milho-Metralhadora nível 2/3 |
| `canhaobatata-arma-lv1-lv2-projetil.jpg` | Canhão de Batata todos os níveis + projétil |

### 3.3 Conteúdo não bate com o nome do arquivo

| Arquivo | Esperado pelo nome | O que realmente é |
|---|---|---|
| `imageladeira-item.jpg` | Item passivo Ímã de Geladeira | Uma cena de celeiro com vaca — parece arte de mapa/decoração, não o item passivo |

Preciso que você confirme: era pra ser o ícone do Ímã, ou é decoração do mapa Celeiro que entrou com nome errado?

---

## 4. Sprites que ainda faltam ser criados

Não existe nenhum arquivo pra esses no zip — precisam ser gerados do zero:

- **Mosca Atiradora** (inimigo comum à distância — hoje só existe a versão boss, "Rainha das Moscas")
- **Vovó Resistente** (2º personagem jogável)
- **Netinho Ágil** (3º personagem jogável)
- **Ícones dos upgrades permanentes da fazenda** (pro Hub): Celeiro Reforçado, Adubo Premium, Botas do Vovô
- **Orbe de XP** (a "Semente de Girassol Brilhante" descrita no GDD — hoje é um círculo verde)
- **Armas restantes em nível 2/3 com legenda limpa**: Milho-Metralhadora e Canhão de Batata (ver seção 3.2)

---

## 5. Texturas de mapa (prontas, sem processamento necessário)

Essas são opacas e tileáveis — não precisam de remoção de fundo, só integração:

- `grama-mapa.jpg` — já é a referência do mapa Horta
- `terra-caminho-mapa.jpg`
- `horta-assentes-mapa.jpg`, `celeiro-assentes-mapa.jpg`, `pomar-assentes-mapa.jpg`
- `cerca-mapa.jpg`, `feno-decorativo-mapa.jpg`, `espantalho-decorativo-mapa.jpg`, `caixa-decorativo-mapa.jpg`

---

## Resumo rápido

| Situação | Quantidade |
|---|---|
| ✅ Integrados no jogo | 16 |
| 🟡 Prontos, faltando integrar | 17 |
| 🔴 Precisam reexportação (fundo) | 12 |
| 🔴 Precisam remoção de texto | 2 |
| ⚠️ Conteúdo não bate com o nome | 1 |
| ❌ Não existem ainda | 6 itens/categorias |
