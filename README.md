<!-- markdownlint-disable MD013 -->
<!--
SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
SPDX-License-Identifier: MIT
-->
# Browser related utilities

## Browser extension

The browser extension shows a blocking page when connection are reset for any reason.
It should be used to keep the user informed when the Ring Zero Dome resets connections for requests destined to blocklisted domains.
Other errors will be handled by the browser itself.

The browser extension is chromium-based, so it should work across all browsers based on such stack.

### Available versions

> [!IMPORTANT]
> Currently, Firefox (version 139.0.1) does not support [Service Workers](https://developer.chrome.com/docs/workbox/service-worker-overview) (Manifest V3) on their *temporary add-ons*.
> Hence, a different version of the extension, which uses [background scripts](https://developer.chrome.com/docs/extensions/mv2/background-pages) (Manifest V2) is made available only for this case.

There are two versions of the extension:

- [*Manifest V3*](./manifest_v3/README.md): valid for most browsers;
- [*Manifest V2*](./manifest_v2/README.md), which should be used only as a *temporary add-on* on Firefox.
For all other options, prefer *Manifest V3*.

### Customizing the extension

In order to customize the extension, you may:

- Change the extension name at [`manifest.json`](./manifest_v3/manifest.json).
- Replace the blockin page altogether ([`block_page.html`](./manifest_v3/block_page.html) or customize it by changing its contents and logo.

## License

MIT
