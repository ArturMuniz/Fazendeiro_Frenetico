# Prompts de geração — fazendeiro baseado nos anexos

Ferramenta: geração/edição de imagem integrada do Codex (`image_gen.imagegen`), com `transparent_background=true`. Não foi usado provedor externo ou chave de API. As saídas brutas foram copiadas para `gerados/`; `gerados/manifest.json` registra os caminhos dos resultados originais. O tratamento posterior no Aseprite está descrito no [relatório](README.md).

Referências preservadas em `originais/`: `fazendeiro andando.jpg`, `morte_fazendeiro.jpg` e `1.1 Idle — 2 a 4 frames.png`.

## Caminhada

Referências, nesta ordem: caminhada original; idle original. Saída: `gerados/walk_sheet.png`.

```text
Edit the FIRST attached sprite sheet into a clean production sprite sheet on REAL TRANSPARENT ALPHA. Faithful restoration and extraction, NOT a redesign. The user wants precisely this farmer, not a simplified approximation. Preserve the exact young clean-shaven face, expressive brown eyes, dark brown hair, broad brown felt cowboy hat with dark band, blue-and-rust plaid rolled-sleeve shirt, blue jeans, brown boots, and small silver hand trowel held in his LEFT hand (on viewer's left as in first reference). Match the original pixel clusters, rich warm shading, proportions and near-black outlines; NOT vector art, NOT a generic tiny stick-figure pixel character. Remove ONLY the baked white/gray checkerboard and its JPEG fringe. Retain all SIX walking poses from the FIRST reference, laid out in exactly 3 columns and 2 rows, in the same reading order. Use a uniform six-cell grid with equal cells and generous fully transparent gutters. Keep every complete hat, boot, hand and trowel visible, consistent head and body size, feet aligned to a shared baseline inside every cell. No added shadows, no ground line, no background, no text, no cell borders, no watermark. The second attachment is additional identity confirmation, not a different style to invent. Keep the face, plaid details and original three-quarter right-facing view IDENTICAL in appearance to the references. Return a clean high-quality square PNG sprite sheet, true transparency, suitable for cropping into game animation frames.
```

## Morte

Referências, nesta ordem: morte original; caminhada original; idle original. Saída: `gerados/death_sheet.png`.

```text
Edit the FIRST attached DEATH sprite sheet into a clean sprite sheet with REAL TRANSPARENT ALPHA, faithfully reproducing its FOUR original poses in exactly a 2-column, 2-row uniform grid. This is an identity-preserving extraction/restoration, NOT a redesign. Preserve the same young clean-shaven rural farmer, his face and expressive brows, brown broad-brim hat, blue and rust-red plaid rolled-sleeve shirt, jeans, brown boots and small silver hand trowel. Retain precisely the pose progression: top-left frightened losing balance with hat on; top-right falling with detached airborne hat; bottom-left seated/slumping with detached hat; bottom-right fully collapsed face-up with eyes closed/X-like as reference, trowel near hand and hat settled separately beside body. Match reference rich warm pixel-art shading, near-black outlines and exact character proportions. Retain the character's clothing detail, never substitute flat geometric or simplified low-detail art. Remove the baked white/gray checkerboard and JPEG fringe completely. Preserve the entire character and ALL detached hats/tools in each cell, no cutting off edges. Every cell must have generous fully transparent gutters. Keep body size consistent without shrinking the prone figure. No ground line, shadows, labels, text, watermark, borders or background. The two other references only reinforce identity. Return a high quality square RGBA PNG sprite sheet ready to crop into four animation frames.
```

## Descanso

Referências, nesta ordem: idle original; caminhada original. Saída: `gerados/idle_sheet.png`.

```text
Create a clean polished pixel-art IDLE sprite sheet matching the attached farmer EXACTLY. The FIRST image is the canonical 2x2 idle sheet, the SECOND shows the character details more clearly. Preserve that exact young clean-shaven expressive face, brown broad-brim hat and dark band, dark brown hair, blue and rust-red plaid shirt with rolled sleeves, blue jeans, brown boots and small silver gardening hand trowel in the same left hand as the references. Faithful identity and style reproduction: rich warm pixel shading, crisp deliberate pixel clusters, near-black outlines, same head/body proportions and three-quarter right-facing view. Do NOT simplify into a generic geometric sprite, do NOT change the face, outfit, tool or hat, do NOT switch to vector, 3D or anime. Exactly FOUR full-body idle frames in a regular 2-column, 2-row grid: neutral relaxed stance, subtle breath in, soft blink during breath out, return toward neutral. Movement must be tiny; planted feet remain aligned; no pose or costume drift. Same character size and baseline in all cells. REAL fully transparent alpha background, absolutely no white, gray or checkerboard backdrop. Complete hats, feet, hands and trowels with generous transparent margin in each cell. No shadows, ground line, text, labels, borders or watermark. Deliver a high-quality square PNG sprite sheet consistent with the supplied walking and death sheets.
```

## Corrida e gestos

Os três prompts completos usados estão em [prompts_complementares.json](prompts_complementares.json), nos registros `run`, `idle_hat` e `idle_swat`. Referências: novo idle acima, caminhada original e idle original, nesta ordem. Saídas: `gerados/run_sheet.png`, `gerados/idle_hat_sheet.png` e `gerados/idle_swat_sheet.png`.

O retorno do gerador não garante transparência e movimento perfeitos. Os PNGs efetivamente utilizados pelo jogo são os exports revisados em `art/fazendeiro_fiel/`; as folhas brutas preservam a saída original para rastreabilidade.
