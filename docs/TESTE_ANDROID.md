# Teste no Galaxy S24+

O preset `Android Teste` gera um APK de desenvolvimento ARM64 com o plugin AdMob nativo e IDs de anúncio de teste. Nome no aparelho: **Fazendeiro Frenético (Teste)**. Identificador: `com.arturmuniz.fazendeirofrenetico.teste`. Essa instalação tem seu próprio progresso local.

APK gerado em 18/10/2026, versão `0.24.1-teste` (código 24), com 103.865.892 bytes. Assinatura APK v2, integridade ZIP, ABI ARM64, orientação vertical, ícone de abertura e registros nativos de Rewarded/UMP conferidos. App ID no manifesto é o de teste do Google. O pacote não contém documentação, marketing ou suítes de teste. **A instalação e o gameplay no S24+ ainda precisam ser verificados no próprio aparelho.**

SHA-256: `b4c01e080990b42108f17b33c246b4d7946ffb8879ab47dc9691a45becb66ceb`.

## Instalar pelo arquivo

1. Transfira `Fazendeiro_Frenetico_S24_Teste.apk` para o celular usando cabo USB ou um serviço de arquivos.
2. Abra o APK no aplicativo **Meus Arquivos** do Samsung.
3. Se solicitado, permita que esse aplicativo instale aplicativos desta origem e confirme a instalação.
4. Abra **Fazendeiro Frenético (Teste)**. Use internet para testar a disponibilidade dos anúncios; o combate deve funcionar sem conexão.

Se o sistema apresentar outra mensagem, registre o texto exato. Não desinstale uma versão anterior para tentar atualizar sem antes considerar que a desinstalação apaga o progresso local. Builds futuras assinadas com a mesma chave e o mesmo identificador podem atualizar esta instalação.

## Teste dirigido

- Faça três partidas consecutivas, alternando personagens disponíveis.
- Confira joystick, pausa, retomada e se os botões ficam acessíveis com a navegação do Android.
- Minimize o jogo, bloqueie/desbloqueie a tela e confira que o combate não avançou indevidamente.
- Observe textos, chapéus e botões nas bordas da tela; registre qualquer corte com uma captura.
- Experimente uma partida longa para observar aquecimento e eventuais travamentos com muitos inimigos.
- Ao morrer, teste fechar um anúncio sem recompensa e concluir um anúncio de teste, quando disponível.
- Depois da metade, o retorno deve restaurar o checkpoint; antes da metade, deve manter o estado do momento da morte com vida restaurada.
- Confira dobra de moedas, compras de roupas e persistência após fechar e abrir.

As unidades são de teste e não geram receita. A entrega de anúncio depende da rede e da inicialização do provedor/consentimento; indisponibilidade não impede reiniciar ou sair da partida.

## Diagnóstico por USB

Ative **Opções do desenvolvedor → Depuração USB**, conecte o cabo e aceite no celular a autorização para este computador. O nome/localização dos menus pode variar conforme a versão da One UI.

No computador, com o Android SDK configurado:

```powershell
adb devices
adb install -r builds/Fazendeiro_Frenetico_S24_Teste.apk
```

Registre o momento e a ação que causaram um problema. Com o aparelho conectado, é possível coletar logs do processo sem depender apenas da captura de tela.

## Recompilar

Requer Godot 4.7.2, Java, SDK Android API 36/Build Tools 36.1.0 e template Android da mesma versão do Godot. A construção usa Gradle e depende de downloads na primeira execução. Não usa chave de publicação: a assinatura é de desenvolvimento, configurada localmente no Godot.

O diretório `android/` é gerado e não entra no Git. Instale o template Android pelo editor, ou extraia o `android_source.zip` oficial em `android/build`. O helper `tools/fetch_android_templates.py` baixa somente esse componente do pacote oficial via HTTP Range e verifica seu CRC. O arquivo `android/.build_version` deve conter `4.7.2.stable`.

```powershell
& 'CAMINHO/Godot_v4.7.2-stable_win64_console.exe' --headless --editor --path . --export-debug 'Android Teste' 'builds/Fazendeiro_Frenetico_S24_Teste.apk' --quit
```

Referências: [exportação Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html), [Gradle](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html) e [teste pelo aparelho](https://docs.godotengine.org/en/stable/tutorials/export/one-click_deploy.html).
