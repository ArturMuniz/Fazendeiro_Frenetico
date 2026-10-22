# Integração visual e Android HD — 0.25.0

Entrega de 21/10/2026. As prévias aprovadas agora são carregadas pelas cenas reais do jogo. Este relatório substitui, para o estado atual, as descrições anteriores de cenário infinito e dos pacotes antigos de atores.

## Conteúdo integrado

| Área | Implementação |
|---|---|
| Horta | Lavoura delimitada, fileiras de plantação e decoração nas bordas |
| Celeiro | Arena dentro do celeiro, piso central livre e armazenamento periférico |
| Pomar | Clareira cercada por árvores frutíferas e elementos rurais |
| Atores | 13 famílias, 51 animações, 368 PNGs de runtime |
| Personagens | Fazendeiro, Vovó Resistente e Netinho |
| Inimigos e acompanhantes | Pulgão, mosca, gafanhoto, lesma, três chefes e três bezerros |
| Interface | Novos retratos no lobby, pausa, seleção e resultados; prévia do mapa escolhido |

Os quadros finais aprovados foram copiados sem alteração de pixels. O [manifesto SHA-256](assets_manifest.json) registra os 371 PNGs, incluindo os três fundos. `integrated_actor_data.gd` contém quadros, duração, loop e offsets. `GameArt.actor()` centraliza a escolha da família atual; os catálogos antigos permanecem como histórico/fallback.

Foram preservados os tempos totais dos ciclos existentes, inclusive mortes, para não alterar a duração das ações de combate. A quantidade de desenhos aumentou onde o pacote remodelado contém intermediários. A Vovó usa a versão gerada aprovada, e não a primeira tentativa articulada rejeitada. Os [prompts dos atores](PROMPTS_ATORES.md) e dos mapas ([horta](PROMPT_SOJA.md), [celeiro](PROMPT_CELEIRO.md), [pomar](PROMPT_POMAR.md)) acompanham esta entrega.

## Arena, câmera e spawn

- Cada mapa usa uma composição única em PNG, apresentada num mundo de 2048 × 1536 unidades. Não há repetição procedural de casas ou cercas.
- Quatro limites físicos na camada 8 delimitam a área jogável. O centro permanece livre; o jogador não atravessa o perímetro decorativo.
- As áreas caminháveis são retângulos distintos por mapa, definidos em `arena_maps.gd`. A colisão não acompanha individualmente cada folha, caixa ou árvore desenhada no fundo.
- Câmera limitada à arte e zoom ajustado ao viewport impedem que proporções altas ou largas revelem espaço vazio fora do mapa.
- Spawn e escoltas ficam dentro da área útil, com margem das paredes. A busca possui limite de tentativas e fallback interno; não procura indefinidamente fora do cenário.
- Entidades reutilizadas recebem a posição antes de entrar na árvore física e depois são configuradas com a referência do jogador da run atual.

Os valores de armas, atributos, recompensas, fases e progressão não foram rebalanceados nesta entrega. A arena finita muda as possibilidades de posicionamento; dificuldade e pressão das hordas precisam de playtest com essa nova geometria.

## Resolução e controles Android

O viewport usa **720 × 1280 como base**, stretch `viewport` e aspecto `expand`. Em telas mais altas, o eixo vertical aumenta mantendo a largura base; em tablets, a largura se expande. O APK foi observado renderizando em **720 × 1600** no emulador 1080 × 2400. Isso é resolução interna HD em retrato, não renderização nativa QHD em todos os aparelhos.

O renderizador GL Compatibility reduz a exigência em relação ao caminho Vulkan. O preset de distribuição contém **ARM de 32 e 64 bits**, exige **Android 8.0/API 26 ou superior e OpenGL ES 3.0**, e usa SDK alvo 36. O limite configurado é 60 FPS; ele não garante 60 FPS em hardware de entrada. Texturas e sprites mantêm filtragem de pixel art, e o cenário estático dispensa a geração contínua de parcelas.

O joystick é flutuante: aparece no toque, começa neutro e desaparece ao soltar. A origem do gesto é independente do centro visual ajustado para não cortar o controle perto das bordas. O dedo proprietário continua recebendo seu evento de soltura mesmo sobre botões. Abrir pausa, perder foco ou redimensionar zera o movimento.

HUD e menus compartilham o cálculo de área segura. A barra superior compacta mostra vida, nível/XP, tempo e abates; o botão de menu tem 96 unidades na base HD. O rodapé mostra três armas com nível e seis slots de buffs. Conteúdo de menus continua rolável, com ações acessíveis nas proporções verificadas.

Referências técnicas: [múltiplas resoluções do Godot](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html), [exportação Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) e [requisitos de sistema](https://docs.godotengine.org/en/stable/about/system_requirements.html).

## Evidências e limites da validação

**640 verificações Godot aprovadas**, distribuídas em 11 suítes. Também passaram a conferência dos 371 hashes e a geração de 12 capturas das cenas de produção. O [registro de validação](validacao.json) contém contagens e resultados; as [capturas de produção](telas/render_report.json) registram suas dimensões.

Foram cobertos: reinício de runs, pausa composta, pooling, timers, recompensa, menus/rolagem, joystick e propriedade do toque, limites físicos, pontos de spawn, câmera, três mapas, três personagens, skins e animações. As capturas controladas adicionam equipamentos/inimigos e alteram o XP somente na fixture de teste; isso não muda os parâmetros do jogo entregue.

O APK x86_64 de QA foi instalado no emulador Android API 36.1 (1080 × 2400, 2 GB). Com GPU host acelerada foram conferidos lobby, combate na horta, seleção/confirmação de melhoria e pausa/inventário, sem erros GDScript ou crash do aplicativo no log observado. [Combate no APK](telas/android_combate.png), [lobby](telas/android_lobby.png) e [pausa](telas/android_pausa.png) são capturas do Android, não montagens.

O driver de software SwiftShader do emulador falhou ao compilar shaders internos do Godot por limite de uniforms; o problema é compatível com o [issue upstream #109550](https://github.com/godotengine/godot/issues/109550). A configuração de luzes 3D foi reduzida a quatro, mas isso não resolveu o shader Canvas desse driver. A validação funcional Android foi feita com GPU acelerada. Isso não demonstra desempenho ou compatibilidade em todos os celulares.

**Ainda falta teste físico desta versão no S24+ e em aparelhos de entrada**, incluindo sessões longas, temperatura, bateria, navegação por gestos/recortes e anúncios recompensados reais. O emulador não valida desempenho de ARM nem estabilidade térmica. AdMob continua com IDs de teste; não há ativação de monetização de produção nesta entrega.

## Reproduzir

Use Godot 4.7.2 e Python 3 para verificar o manifesto. As suítes rodam com `--headless --path . --script res://tests/NOME.gd --audio-driver Dummy`; `cosmetic_render_suite.gd` e `integration_hd_visual.gd` precisam de renderização com GPU. As suítes escrevem saves isolados em `tests/.tmp/`.

```powershell
python tools/verify_integrated_assets.py
Godot --headless --path . --script res://tests/map_landscape_suite.gd --audio-driver Dummy
Godot --headless --path . --script res://tests/mobile_hud_suite.gd --audio-driver Dummy
Godot --headless --path . --export-debug 'Android Teste' 'builds/Fazendeiro_Frenetico_HD_v0.25.0_Teste.apk' --quit
```

`tools/integrate_approved_assets.py` documenta a cópia a partir dos pacotes externos deste workspace. Ele é ferramenta de autoria; os arquivos externos não são necessários para abrir ou exportar o jogo já integrado. O preset `Android Emulador` é exclusivo para QA x86_64 e usa um identificador separado para não alterar o progresso da instalação de teste ARM.
