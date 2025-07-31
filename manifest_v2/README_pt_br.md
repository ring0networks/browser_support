<!-- markdownlint-disable MD013 -->
<!--
Copyright (C) 2025 Ring Zero Desenvolvimento de Software LTDA.
All rights reserved.
-->
# Extensão para exibição de página de bloqueio do Ring Zero Dome (Manifest V2)

Esta extensão detecta *connection resets* em navegadores baseados no Chromium e apresenta uma página de bloqueio personalizada ao invés de uma mensagem de erro do navegador.
Ela usa *background scripts* e é compatível com o [Manifest V2](https://developer.chrome.com/docs/extensions/mv2/content-scripts).

## Como instalar e usar a extensão

A extensão é projetada para funcionar na maioria dos navegadores modernos baseados no padrão WebExtensions, incluindo Google Chrome, Mozilla Firefox e Microsoft Edge.

### 1. Salve os arquivos

Primeiro, crie um novo diretório em seu computador (por exemplo, `ConnectionResetExtension`) e para ele copie todos os arquivos contidos aqui.

### 2. Instale a extensão no navegador

As etapas para carregar a extensão são ligeiramente diferentes para cada navegador:

Google Chrome:

1. Abra o Chrome.
2. Digite `chrome://extensions` na barra de endereço e pressione `Enter`.
3. No canto superior direito da página de Extensões, ative o "Modo de desenvolvedor".
4. Clique no botão "Carregar sem compactação" (ou "Load unpacked").
5. Navegue até a pasta `ConnectionResetExtension` que você criou e selecione-a.

A extensão aparecerá na sua lista de extensões instaladas.

Mozilla Firefox:

1. Abra o Firefox.
2. Digite `about:debugging#/runtime/this-firefox` na barra de endereço e pressione `Enter`.
3. Clique no botão "Carregar Complemento Temporário..." (ou "Load Temporary Add-on...").
4. Navegue até a pasta `ConnectionResetExtension` e selecione qualquer arquivo dentro dela (por exemplo, `manifest.json`).

A extensão será carregada.

> [!IMPORTANT]
> Extensões temporárias são removidas quando o Firefox é fechado.

Microsoft Edge:

1. Abra o Edge.
2. Digite `edge://extensions` na barra de endereço e pressione `Enter`.
3. No canto inferior esquerdo da página, ative o "Modo de desenvolvedor".
4. Clique no botão "Carregar descompactada" (ou "Load unpacked").
5. Navegue até a pasta ConnectionResetExtension e selecione-a.

A extensão aparecerá na sua lista de extensões instaladas.

> [!IMPORTANT]
> De tempos em tempos, o Edge irá lhe perguntar se você deseja que extensões adicionadas no modo de desenvolvedor sejam removidas.

### 3. Teste a Extensão

Para testar se a extensão está funcionando corretamente:

1. Ative o Ring Zero Dome.
2. De uma estação ou dispositivo cujo tráfego é inspecionado pelo Ring Zero Dome, acesse um dos navegadores listados acima, já com a extensão `ConnectionResetExtension` instalada.
3. No navegador escolhido, tente acessar uma URL relativa a um domínio contido em uma das blocklists do Ring Zero Dome.

A conexão deverá ser bloqueada e a página de bloqueio personalizada deverá ser exibida pelo navegador.
