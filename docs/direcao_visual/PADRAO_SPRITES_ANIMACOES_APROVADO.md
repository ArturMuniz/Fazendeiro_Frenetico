# Padrão de criação e animação de sprites — Fazendeiro e Vovó

Registro de preferência do usuário em **21/10/2026**. Após a nova prévia da Vovó, o usuário disse: “Gostei muito! salve essa ideia, de como realizar as animações e criações de sprites, lembre de como voce fez com a vovo e com fazendeiro.”

**Atualização de integração:** após o pedido explícito posterior, o pacote remodelado foi integrado à versão 0.25.0. Veja [o relatório atual](../integracao_hd/README.md). As menções abaixo a “prévia não integrada” registram o estado no momento da aprovação original; os caminhos de autoria continuam úteis como referência.

Este documento é a referência de processo para futuras tarefas de arte deste jogo. Não solicita novas imagens, integração, commits, publicação ou alterações de gameplay. Pedidos posteriores do usuário podem mudar o método ou autorizar essas ações.

## Preferência visual e escolha do método

O personagem original é a referência de identidade: rosto, proporções, silhueta, roupas, acessórios, materiais, cores e acabamento em pixel art. O usuário permite gerar desenhos e poses complementares para conseguir movimento e continuidade, preservando esse desenho.

**Priorizar a geração de personagens inteiros por quadro**, como na Vovó aprovada. Usar Aseprite para recortar as células completas da folha, tratar a transparência, registrar as posições, montar os ciclos e exportar. Não voltar automaticamente à animação por pedaços para tentar preservar pixels: a experiência com a Vovó mostrou que preservar cores não evita cortes, membros incompletos ou uma silhueta ruim.

O método articulado do Fazendeiro continua documentado como uma alternativa específica para situações em que a arte e a continuidade dos membros se mantenham boas. Os dois personagens não foram produzidos pelo mesmo procedimento técnico.

## Referências corretas e estado das versões

Os caminhos abaixo são relativos à raiz deste **workspace local**, pasta que contém `fazendeiro-caotico/` e `sprite-tools/`. Os arquivos de prévia e ferramentas ficam fora do repositório Git do jogo; estes caminhos não garantem sua presença em outro computador.

| Caso | Pasta local | Como usar |
|---|---|---|
| Vovó, nova arte gerada | `sprite-tools/previews/vovo-gerada-v2/` | **Versão aprovada explicitamente pelo usuário.** Referência principal para novos sprites e animações. |
| Vovó, primeira tentativa articulada | `sprite-tools/previews/vovo-20261021/` | **Rejeitada pelo usuário:** arte cortada e partes faltando. Não selecionar como referência visual aprovada. |
| Fazendeiro, arte original sobre o movimento | `sprite-tools/previews/fazendeiro-corrida-v3/` | Referência de fidelidade à arte e de preservação do movimento corrigido. |
| Fazendeiro, construção do movimento | `sprite-tools/previews/fazendeiro-corrida-v2/` | Referência técnica de fases, curvas, deslocamento e viradas. A movimentação foi aprovada; o usuário pediu depois que os membros voltassem a parecer com os originais. |

As prévias citadas não foram integradas ao jogo. Manter essa distinção ao retomar o projeto.

## Receita da Vovó aprovada

### 1. Preparar as referências

- Inspecionar os arquivos originais antes de gerar ou recortar.
- Selecionar uma figura completa e legível para a identidade. Fontes permanentes desta revisão: `walk-original.png` e `run-original.png`, na pasta aprovada.
- Identificar quais imagens são referência de identidade, quais são poses e quais são alvos de edição. Uma referência de corrida não deve levar a geração da caminhada a copiar punhos erguidos e saltos.
- Preservar os originais. Não depender somente de anexos em pastas temporárias para retomar o processo.

### 2. Gerar os desenhos completos

Usar a ferramenta nativa de geração de imagens para criar poses e intermediários, mantendo o original como referência visual. Aplicar as instruções da habilidade de imagens disponível na sessão.

Na Vovó, manter chapéu de palha com faixa vermelha, cabelo branco, óculos redondos, rosto original, corpo robusto, roupa amarela/mostarda, avental verde florido, luvas marrons e botas verdes largas. Outros personagens precisam de sua própria lista de características, sem herdar o figurino da Vovó.

Especificar no prompt:

- Cada quadro contém uma personagem **inteira**, com chapéu, mãos, mangas, pernas e botas completos e conectados.
- Mesmo personagem, escala, câmera e direção em todas as células; margem ampla dentro de cada célula.
- Fundo realmente transparente; sem fundo branco, tabuleiro pintado, cenário, texto ou numeração incorporada.
- Poses em ordem cronológica e ciclo fechando naturalmente.
- Duas pernas alternando o apoio e braços acompanhando em oposição, com movimento de tronco coerente.
- Roupa e acessórios com movimento secundário discreto; rosto e proporções estáveis.
- Caminhada apoiada e relaxada; corrida com apoio, passagem e voo, quando apropriado à anatomia original.

**Quantidade de quadros e palavras como “fluido” não garantem uma animação correta.** Nas tentativas de geração houve poses repetidas, a mesma perna liderando e caminhada copiando a corrida. Examinar os desenhos; corrigir a falha específica antes de montar o resultado final. Se uma folha inteira falhar em uma pose importante, uma pose-chave individual pode ajudar a orientar a próxima geração.

Os prompts completos das duas folhas selecionadas estão em [PROMPTS_VOVO_APROVADOS.md](PROMPTS_VOVO_APROVADOS.md). Eles são exemplos reproduzíveis desta revisão, sujeitos à inspeção do resultado; não são uma garantia automática de qualidade.

### 3. Montar as células completas no Aseprite

- A geração fornece desenhos completos. A montagem só recorta a célula ou a figura inteira, redimensiona uniformemente e posiciona o conjunto.
- Não desmontar braços, pernas, vestido ou avental para esta receita.
- Medir os limites reais das figuras. As imagens recebidas nem sempre têm células bem centralizadas ou a mesma resolução solicitada; um corte por grade presumida pode amputar uma mão ou uma bota.
- Conferir o canal alfa. Um RGB colorido sob alfa zero não é um fundo visível. Não remover cores legítimas da personagem por causa da aparência dos pixels transparentes.
- Limpar resíduos de alfa com cuidado. Nesta revisão foi usado limiar 160; reavaliar esse valor para cada nova arte.
- Usar vizinho mais próximo para manter a leitura dos pixels.
- Aplicar uma escala uniforme por ciclo, preservando as proporções. Não redimensionar cada pose pela sua altura total individual: isso faz cabeça e corpo pulsarem quando a perna dobra.
- Registrar a figura por uma referência estável. Nesta revisão, o centro do maior componente vermelho da faixa do chapéu serviu como referência horizontal; pixels vermelhos isolados não devem determinar esse centro.
- Manter o apoio no chão. Nas poses de voo da corrida, preservar a elevação; alinhar todos os pés ao chão apagaria o salto.
- Deixar margem e verificar a caixa completa em **todos** os quadros e direções.

Parâmetros usados nesta versão aprovada, como exemplo e não como obrigação para outros personagens:

| Item | Configuração |
|---|---|
| Caminhada | 6 desenhos completos, 120 ms por desenho, ciclo de 720 ms |
| Corrida | 8 desenhos completos, 80 ms por desenho, ciclo de 640 ms |
| Normalização | Altura máxima da arte de 208 px por ciclo; canvas final de 288 × 272 px com margem |
| Direção esquerda | Espelho horizontal dos quadros completos da direita |
| Comparação conjunta | Loop de 5.760 ms; repete os quadros dos dois ciclos mantendo seus tempos próprios |

As 144 exposições do GIF conjunto não representam 144 desenhos novos. Não usar contagem de exposições para alegar que foram gerados mais intermediários. A esquerda espelhada também não constitui uma nova vista frontal, traseira ou animação de virada.

### 4. Inspecionar e apresentar

- Rever a folha de poses e o ciclo, incluindo a transição do último desenho para o primeiro.
- Procurar cortes, partes ausentes, articulações abertas, contornos quebrados, membros finos demais, mudanças de rosto, botas ou mãos e perda de volume.
- Conferir fundo transparente, margens, repetição de poses, fase das pernas, apoio e tempos de exposição.
- Comparar com o original lado a lado. Alfa e caixas válidas não demonstram por si só que a arte é fiel ou que o movimento ficou bom.
- Mostrar um GIF animado e oferecer a comparação com o original. Evitar declarar “perfeito” ou “idêntico pixel a pixel”. A geração pode mudar detalhes de desenho e distribuição das flores.
- Quando o pedido for somente prévia, manter os arquivos fora dos assets carregados pelo jogo. Quando o usuário solicitar integração, avançar nesse escopo; não transformar esta preferência em uma exigência de confirmação extra.

### Arquivos para retomar a Vovó

Na pasta `sprite-tools/previews/vovo-gerada-v2/`:

| Arquivo | Finalidade |
|---|---|
| `preview-vovo-nova.gif` | Prévia apresentada e aprovada pelo usuário |
| `comparacao-original.gif` | Originais à esquerda, nova arte à direita |
| `direita-e-esquerda.gif` | Apresentação dos dois sentidos |
| `walk-gerada.png`, `run-gerada.png` | Folhas selecionadas na resolução recebida da geração |
| `walk-original.png`, `run-original.png` | Referências completas preservadas |
| `PROMPTS.md` | Prompts das folhas selecionadas; cópia também arquivada nesta documentação |
| `anchors.lua` | Preparação das referências completas a partir dos anexos originais |
| `inspect_sheet.py`, `registration.json` | Medição dos quadros e da referência do chapéu; Python usado para inspeção e metadados |
| `assemble.lua` | Limpeza de alfa, escala e registro de figuras inteiras, PNGs e fontes Aseprite |
| `build_scene.py`, `scene.lua` | Montagem textual e renderização das prévias |
| `verify_preview.py`, `qa.json` | Verificações de limites, alfa, espelhamento e tempos dos GIFs |
| `walk-frames/`, `run-frames/` | Quadros PNG completos de cada direção |
| `walk-direita.aseprite`, `run-direita.aseprite` e equivalentes à esquerda | Fontes animadas da prévia |

## O que preservar do Fazendeiro

A correção do movimento resolveu a alternância das pernas, a coordenação do tronco e dos braços e a apresentação para os dois lados, com virada. O usuário aprovou a movimentação, mas rejeitou a aparência de membros que se afastava dos sprites originais.

Na revisão v3, foram usados recortes reais da imagem original para cabeça, tronco, mangas, antebraço, mão/pazinha, jeans e botas. Uma malha de triângulos leva a textura original da calça ao longo do movimento; os preenchimentos genéricos por cápsulas e recolorações da revisão anterior foram removidos. A pequena região de jeans escondida pela pazinha foi reconstruída com textura vizinha da própria arte.

Referências locais:

- `sprite-tools/previews/fazendeiro-corrida-v3/recortes/base-source.png`: fonte visual preservada.
- `sprite-tools/previews/fazendeiro-corrida-v3/cutout-rig.lua`: reconstrução com a arte original.
- `sprite-tools/previews/fazendeiro-corrida-v2/rig.lua` e `rig-metrics.json`: movimento-base, fases e curvas.
- `sprite-tools/previews/fazendeiro-corrida-v3/scene.lua`: apresentação do ciclo e deslocamento.
- `sprite-tools/previews/fazendeiro-corrida-v3/preview-fidelidade.gif` e `preview-movimento.gif`: comparação e movimento.

O ciclo desse caso tem 16 poses de 40 ms, com pernas em fases opostas e curvas periódicas. Não copiar os comprimentos dos membros do Fazendeiro para a Vovó ou para outros personagens. Preservar o volume próprio de cada anatomia. O movimento aprovado serve como referência de ritmo e coordenação, não como autorização para simplificar o desenho.

## Detalhes operacionais já descobertos

- As ferramentas desta sessão estavam disponíveis em `sprite-tools/aseprite-build/bin/aseprite.exe` e `sprite-tools/sprite-gen-preview/.venv/Scripts/python.exe`; verificar a existência antes de reutilizar em outro ambiente.
- Para Aseprite em batch no Windows, usar `Start-Process -WindowStyle Hidden -Wait` e respeitar as permissões do ambiente. A execução direta do `.exe` pode retornar antes da renderização terminar e fazer a inspeção ler arquivos incompletos ou antigos.
- Para scripts Python desse ambiente, `-X utf8` evita falhas de saída no console. Evitar chamar um script de `inspect.py`, pois isso pode ocultar o módulo padrão `inspect` e quebrar imports como NumPy.
- Python foi usado nesta receita para leitura, verificações, metadados e montagem de texto Lua; as operações raster foram feitas pela geração de imagens e pelo Aseprite.
- A detecção automática de escala de pixels do sprite-gen já produziu recortes e contatos indesejados nas referências anteriores. Verificar visualmente antes de usar `pixel_unfake`; ele não é necessário para a receita de quadros inteiros da Vovó.
