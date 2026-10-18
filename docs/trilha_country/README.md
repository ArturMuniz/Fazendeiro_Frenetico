# Direção musical country e sertaneja — Fazendeiro Frenético

Data: 18/10/2026. Entrega: pesquisa, análise técnica das referências e cinco novas composições instrumentais de demonstração.

As faixas foram compostas em MIDI e renderizadas com instrumentos sampleados. São propostas de melodia, harmonia e arranjo para escuta e refinamento. Não são gravações de músicos nem uma produção final aprovada. O agente não realizou escuta crítica dos arquivos: os resultados abaixo vêm de medições e inspeção da composição. Reconhecimento de instrumentos, vocais e qualidade artística das referências não foi realizado.

## 1. O que foi encontrado no projeto

| Arquivo | Duração medida | Pulso estimado | Loudness integrado | Pico verdadeiro |
|---|---:|---|---:|---:|
| Harvest_of_Thorns.mp3 | 180,976 s | aproximadamente 150 BPM; alternativa de 75 BPM em meio-tempo | -11,66 LUFS | +0,42 dBTP |
| Sunday_Morning_Porch_Swing__1_.mp3 | 179,357 s | aproximadamente 103 BPM | -11,70 LUFS | +0,15 dBTP |
| audio/music_gameplay.ogg | 178,944 s | perfil de pulso semelhante a Harvest | -18,19 LUFS | -2,87 dBTP |
| audio/music_map_celeiro.ogg | 177,306 s | perfil de pulso semelhante a Sunday | -18,09 LUFS | -2,53 dBTP |
| audio/music_hub.wav | 5,300 s | faixa curta demais para usar a estimativa como referência | -15,60 LUFS | -3,00 dBTP |

Métodos: decodificação com FFmpeg, fluxo espectral/autocorrelação para candidatos de andamento, energia por classe de altura para candidatos tonais e filtro loudnorm para medições de loudness. Não confundir estimativa de pulso com transcrição rítmica. A análise tonal sugere Sol maior para Harvest e Dó maior para Sunday, mas isso precisa ser confirmado por escuta/transcrição.

A comparação de 90 segundos de PCM, compensando até cinco segundos de deslocamento, encontrou correlação de **0,99590** entre Harvest e gameplay; **0,98357** entre Sunday e celeiro. Isso sustenta que os áudios do jogo são versões processadas das referências. Não são arquivos binariamente iguais e a comparação não afirma igualdade de todas as seções.

Os MP3s têm volume de master maior que os OGGs atuais. As propostas novas foram preparadas perto do nível dos OGGs, evitando saltos de volume ao comparar no mesmo volume de reprodução. Os arquivos originais e os três arquivos de música ativa permanecem íntegros, verificados por SHA-256.

Dados completos: [analise_referencias.json](analise_referencias.json).

## 2. Pesquisa e aplicação ao jogo

### Instrumentação e identidade

O programa American Roots da Berklee identifica banjo, fiddle, violão, mandolim e baixo como a formação tradicional de bluegrass. Essa família instrumental é uma base útil para o impulso rural desejado. Para o jogo, a proposta é dividir funções: baixo dá sustentação; violão marca o acompanhamento; banjo fornece movimento; fiddle ou gaita assume frases curtas, com pausas para o restante do arranjo. [Fonte: Berklee](https://www.berklee.edu/news/berklee-now/10-years-american-roots-music-program).

A pesquisa da UFMG sobre o registro da viola em Minas ressalta a relação entre instrumento, afinações, toques e práticas culturais. Country e música caipira não são sinônimos. Nossa aplicação criativa é aproximar o conjunto country do ponteio e de respostas em terças, colocando a viola caipira como identidade brasileira na etapa de produção com instrumentos adequados. [Fonte: pesquisa de Erika Caroline Damasceno Costa, UFMG](https://periodicos.ufmg.br/index.php/temporalidades/article/download/6205/9749/31689).

**Limite das demonstrações:** o banco General MIDI utilizado não oferece uma viola caipira específica. Violões de aço e nylon representam provisoriamente essa função de arranjo; isso não reproduz com fidelidade as cordas duplas, afinação e articulações da viola. A faixa “Catira do Celeiro” é uma fusão inspirada no ambiente de terreiro, não uma reprodução etnomusicológica da catira.

### Composição e produção

A formação de produção de demos da Berklee trata arranjo, instrumentação e forma como partes do desenvolvimento da canção na DAW. Nossa aplicação é compor primeiro frases reconhecíveis, definir acompanhamentos e respostas, alternar densidade e só depois trabalhar timbre e mix. Pedir apenas “country” a um gerador deixa essas decisões abertas demais. [Fonte: Berklee Online](https://online.berklee.edu/courses/music-demo-production-for-songwriters).

Receita adotada nesta entrega:

1. Escolher a função de cada faixa e uma faixa de energia compatível com as referências.
2. Escrever um motivo de oito compassos, com frases de pergunta/resposta e pausas.
3. Sustentar as melodias com acordes e baixo de tônica/quinta; pousar os tempos fortes em notas do acorde.
4. Alternar seções com outra voz principal ou menor densidade. Uma faixa de chefe ganha mais ataque e tensão harmônica.
5. Aplicar pequenas variações de tempo e intensidade às execuções MIDI, sem alterar o andamento global.
6. Renderizar, preparar o loop em número inteiro de compassos e conferir o arquivo codificado.
7. Ouvir várias repetições com os efeitos do jogo antes da aprovação artística.

### Como os jogos evitam repetição

Na entrevista sobre Hades, Darren Korb descreve o uso de stems que variam entre salas e de bateria que entra durante confrontos. Isso mostra uma possibilidade de variar a energia com o estado do combate. Nossa recomendação futura é separar acompanhamento, melodia e percussão, mantendo tempo, harmonia e duração comuns. [Fonte: entrevista com Darren Korb e Greg Kasavin](https://www.rpgsite.net/interview/20348-supergiant-games-interview-2026-greg-kasavin-darren-korb-hades-2-ending-music-future-coffee).

A documentação do Wwise distingue organização vertical e horizontal de música interativa. Aplicação proposta: vertical para adicionar/remover instrumentos sincronizados; horizontal para trocar seções em fronteiras musicais. O projeto usa atualmente um único AudioStreamPlayer para música, portanto esse sistema adaptativo ainda precisaria ser implementado. **Não há música adaptativa nova nesta entrega.** [Fonte: Audiokinetic](https://www.audiokinetic.com/en/public-library/2024.1.8_8893/?id=creating_interactive_music&source=Help).

## 3. Novas composições

| Tema | Uso proposto | BPM | Centro tonal de composição | Forma | Duração | Característica |
|---|---|---:|---|---|---:|---|
| [Varanda de Domingo](previas/01_varanda_de_domingo.mp3) | Lobby | 104 | Dó maior | A–A–B–A, 32 compassos | 73,846 s | Violão dedilhado, gaita, baixo suave e percussão discreta |
| [Mutirão na Horta](previas/02_mutirao_na_horta.mp3) | Horta | 150 | Sol maior | A–A–B–A–C–A, 48 compassos | 76,800 s | Banjo em movimento, fiddle e acompanhamento de combate |
| [Catira do Celeiro](previas/03_catira_do_celeiro.mp3) | Celeiro | 104 | Dó maior | A–A–B–A, 32 compassos | 73,846 s | Country com balanço, violões e respostas em terças |
| [Estrada do Pomar](previas/04_estrada_do_pomar.mp3) | Pomar | 124 | Ré maior / Si menor | A–A–B–A–C–A, 48 compassos | 92,903 s | Tema mais espaçoso, fiddle/gaita e cores de entardecer |
| [Colheita Bravia](previas/05_colheita_bravia.mp3) | Chefe | 156 | Mi menor | A–A–B–A–C–A, 48 compassos | 73,846 s | Banjo, baixo marcado e dominante maior para tensão |

As melodias foram escritas nesta entrega. Não foram extraídos trechos de áudio nem transcritas as melodias das referências. As referências orientaram andamento, função e contraste de energia; a instrumentação atende à direção country/sertaneja solicitada.

## 4. Arquivos e validação

- `previas/`: cinco MP3s para escuta, estéreo, 192 kbps.
- `loops/`: cinco OGGs Vorbis, estéreo, 44,1 kHz, duração de compassos completos; metadados LOOPSTART/LOOPEND documentam o intervalo. A reprodução deve ativar loop no player.
- `midi/`: composições editáveis, separáveis por canal em uma DAW. Os programas MIDI representam funções instrumentais, não timbres obrigatórios.
- `manifesto.json`: especificações, hashes dos arquivos e medições finais de cada composição.
- `validacao.json`: resultado independente da validação técnica.
- `PROMPTS.md`: instruções detalhadas para produzir versões com timbres mais realistas.
- `licencas/GeneralUser-GS.txt`: licença original do banco sampleado utilizado.

Os loops foram renderizados em três ciclos; o ciclo do meio preserva a continuidade das notas. Pequenos taps de ambiente circulares, filtro de graves e ajuste de largura estéreo são aplicados offline. Uma rampa de 5 ms nas bordas reduz descontinuidades sem encurtar o compasso. Isso não substitui a verificação auditiva do loop.

A validação independente passou em **60 verificações, com zero falhas**: notas MIDI encerradas, duração, hashes, decodificação MP3/OGG, canais, pico verdadeiro, compatibilidade mono, ausência de clipping e tamanho da descontinuidade na emenda. Os resultados estão em `validacao.json`. Não houve teste de audição no Android nem avaliação artística por escuta do agente.

Os masters WAV de 24 bits e o renderizador ficam fora dos arquivos de distribuição do jogo, em `../audio-tools/renders`. Esta pasta de documentação tem `.gdignore`, para que as propostas não sejam importadas ou incluídas automaticamente no jogo.

## 5. Próxima passagem de produção

1. Avaliar as cinco prévias e escolher os temas que representam melhor o jogo.
2. Substituir os timbres provisórios por viola caipira, violões, banjo e fiddle de melhor qualidade, com articulações e variações de execução.
3. Refinar transições, respostas, viradas e pontos em que a melodia deve dar espaço ao combate.
4. Conferir o loop por pelo menos cinco repetições em fones, caixas e celular.
5. Testar música junto de dano, coleta, ataque e avisos de chefe; ajustar mascaramento e volume dentro do jogo.
6. Só então mover os OGGs aprovados para `audio/` e associar as faixas ao lobby/mapa/chefe.

O serviço Runway foi encontrado como opção de geração de música, mas a conta não ficou conectada nesta sessão. Nenhuma faixa desta entrega foi gerada nesse serviço. Os prompts podem ser usados em um gerador conectado ou como briefing para produção em DAW.

## 6. Reprodução técnica

Ferramentas: Python 3.12; NumPy, SciPy, soundfile, mido, imageio-ffmpeg; FluidSynth 2.6.1 oficial; GeneralUser GS 2.0.3. O banco e os executáveis são ferramentas de autoria e não dependências do jogo.

Executar a partir da raiz do projeto, com as dependências locais em `../audio-tools/python`:

```powershell
python tools/analyze_music.py
python tools/compose_country.py
python tools/validate_country_music.py
```

`analyze_music.py` lê os caminhos originais fornecidos pelo usuário; eles podem ser ajustados em outra máquina. As outras ferramentas leem o banco em `../audio-tools/soundfonts` e procuram o executável oficial extraído em `../audio-tools/fluidsynth`.

Banco de instrumentos: [GeneralUser GS](https://github.com/mrbumpy409/GeneralUser-GS). Renderizador: [FluidSynth](https://github.com/FluidSynth/fluidsynth/releases/tag/v2.6.1). A licença original acompanha a entrega; não é uma licença criada para as referências do usuário.
