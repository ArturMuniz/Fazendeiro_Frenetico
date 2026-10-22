# Preparação do fundo — geração nativa

A referência foi preservada em `referencia_mapa_original.png`. A saída usada pelo protótipo é `mapa_soja_plate.png`. A geração remove o personagem pintado no conceito; todo o HUD, atores e movimentos das capturas seguintes são renderizados pelo Godot.

```text
Use case: precise-object-edit. This attached farm arena overview will be used as a background texture in the actual Godot game. Remove ONLY the tiny farmer character at the exact center of the image and reconstruct the small patch of brown dirt immediately behind him, blending with adjacent dirt texture. Preserve every other part of the farm exactly: crop rows, fences, gate, barn, tractor, trees, irrigation tank, lighting, pixels, image boundaries, composition and 4:3 aspect ratio. Do not redesign, zoom or crop. No new characters, shadows, UI, text or objects. Keep the full opaque background. This is a background plate for real gameplay; the real player sprite will be drawn by the game engine.
```
