# Direção visual e entrega de arte

## Fluxo combinado com Artur

As novas imagens serão produzidas por Artur no Google Flow. Quando necessário, Artur também fornecerá animações. A integração ao jogo será feita a partir dos arquivos entregues, com revisão de legibilidade, escala, transparência e compatibilidade com os sistemas existentes.

Esta definição não substitui sprites automaticamente, não encomenda geração de imagens e não altera o balanceamento. Os documentos abaixo são planejamento; a auditoria não significa que a interface nova já esteja implementada.

Atualização de 16/10/2026: a implementação com os assets aprovados foi autorizada e concluída. O [relatório da interface](../../RELATORIO_INTERFACE_RURAL.md) distingue o que entrou no jogo das propostas que continuam pendentes.

## Documentos

- [Análise individual dos 120 arquivos](01_ANALISE_SPRITES.md).
- [Layouts e comportamento das telas](02_ARQUITETURA_UI.md).
- [Backlog de 48 itens, com prioridades e critérios de aceite](03_ASSETS_FALTANTES.md).
- [Prompts de produção para o Google Flow: personagens, animações, UI, itens, efeitos e cenários](04_PROMPTS_GOOGLE_FLOW.md).
- [Fila sequencial para geração: 198 pedidos preenchidos, com dependências e retomada](05_FILA_SEQUENCIAL_GOOGLE_FLOW.md).
- [Auditoria individual dos184 novos arquivos e decisões de integração](06_AUDITORIA_NOVOS_SPRITES.md).
- [Relatório de integração dos sprites polidos, testes e limitações](../../RELATORIO_SPRITES_POLIDOS.md).

As pranchas e o inventário acompanham a auditoria. `.gdignore` mantém estas imagens de referência fora da importação de recursos do jogo.

## Como identificar uma entrega

Ao entregar um arquivo, informar o ID do backlog, item/personagem, nível e estado representado. Exemplo: `IT-01 — Foice — nível 2 — ícone isolado`. Isso evita associar uma imagem ao nível errado apenas pelo nome do arquivo.

Preferir imagens sem texto, números de nível, marca-d'água ou xadrez desenhado. Manter a mesma direção, proporção e linguagem visual da família. Preservar o arquivo original entregue; a versão preparada para o jogo fica separada.

Se a exportação não tiver transparência real, informar o fundo utilizado. O arquivo precisará de preparação e revisão antes da integração; uma imagem com fundo quadriculado não equivale a PNG transparente. Esta é uma especificação de entrega, não uma afirmação sobre formatos ou recursos disponíveis no Flow.

## Quando uma animação é necessária

| Elemento | Entrega recomendada |
|---|---|
| Ícones de armas/passivos, painéis, cartas e botões | Imagem estática; estados e transições simples podem ser feitos no motor |
| Personagens e inimigos | Quadros separados ou folha documentada para idle, movimento, ataque e morte, somente nos estados necessários |
| Impactos, explosões e dissipação | Sequência curta com início/fim definidos; efeitos separados do corpo |
| Barras, números, seleção, foco e contadores | Animação no motor; não exige vídeo ou sprite sheet próprio |

Para sequências, informar ordem dos quadros, duração ou FPS pretendido, se repete e qual quadro representa o impacto. Manter tamanho de tela e ponto de apoio constantes. Se a entrega for vídeo, será necessário avaliar extração de quadros e separação do fundo; ele não se torna automaticamente um sprite animado pronto.

## Integração e validação

1. Relacionar arquivo ao item e estado corretos.
2. Verificar fundo, enquadramento, cores e legibilidade no tamanho real de uso.
3. Preparar recursos e conectar às cenas/dados sem mudar atributos de combate.
4. Testar animação, pivôs, alcance visual, pausa e reutilização quando aplicável.
5. Registrar o que foi integrado e o que ainda precisa de ajuste.

O ZIP do projeto foi autorizado e entregue em 16/10/2026. O guia de prompts é posterior ao empacotamento; novas artes serão revisadas e integradas quando fornecidas.
