<!-- markdownlint-disable MD013 -->
<!--
SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
SPDX-License-Identifier: GPL-2.0-only
-->
# Browser related utilities

## Browser extension

The extension shows a block page whenever a connection is reset, informing the user when the Ring Zero Dome blocks a request to a blocklisted domain.
Other errors are left to the browser.
It is Chromium-based, so it works across all Chromium browsers.

### Available versions

Two versions are available:

- [*Manifest V3*](./manifest_v3/README.md) — preferred; works on most browsers;
- [*Manifest V2*](./manifest_v2/README.md) — only for Firefox *temporary add-ons*.

> [!IMPORTANT]
> Firefox (as of 139.0.1) does not support [Service Workers](https://developer.chrome.com/docs/workbox/service-worker-overview) (Manifest V3) in *temporary add-ons*, so the [background-script](https://developer.chrome.com/docs/extensions/mv2/background-pages) Manifest V2 build exists only for that case.

### Customizing the extension

#### Quick way: `./customize.sh`

The [`customize.sh`](./customize.sh) script generates a customized, ready-to-load copy of
the extension under `build/`, leaving the tracked source untouched. Run it with no arguments
to be prompted for each field (it asks which manifest version to build — **Manifest V3 by
default**; an empty answer to any prompt keeps the current value):

```sh
./customize.sh
```

Or pass any subset of options (unspecified fields are still prompted, unless `--yes` is given):

```sh
./customize.sh --version both --name "My Filter" --heading "Access blocked" --logo my-logo.png --yes
```

It can set the extension name, the block page title / heading / message, the logo image
(`dome-logo.png`) and the favicon (`favicon.ico`); the "powered by" image and its link are
left untouched. Run `./customize.sh --help` for the full option list. Load the resulting `build/<version>/`
directory via *Load unpacked* (see each version's README).

To customize by hand instead, edit the files directly as described below.

All customizable assets live inside each version directory (`manifest_v3/` and
`manifest_v2/`). The two directories are kept identical except for their `manifest.json`,
so **apply every change to both directories** (or to the single one you intend to ship).
The steps below use `manifest_v3/`; repeat them under `manifest_v2/` if you also ship the
Firefox temporary add-on.

After editing any file, reload the extension in the browser (`chrome://extensions` →
*Reload*) to pick up the changes.

#### 1. Change the extension name

Edit the `name` field in [`manifest.json`](./manifest_v3/manifest.json):

```json
{
  "manifest_version": 3,
  "name": "Your custom extension name",
  ...
}
```

The name is what appears in the browser's extension list. The `description` field just
below it can be adjusted the same way.

#### 2. Change the block page text

The block page is [`block_page.html`](./manifest_v3/block_page.html). Its content is in
Brazilian Portuguese by default. To change the wording:

- Update the `<title>` (browser tab title).
- Update the `<h1>` heading (shown in red) and the `<p>` paragraph (the explanation).
- If you translate the page, also change the `lang` attribute on the `<html>` tag
  (e.g. `lang="en"`).

#### 3. Change the logo and branding

The block page references three images that sit next to it in the same directory:

- `dome-logo.png` — the large logo at the top of the page (`<img class="logo">`).
- `favicon.ico` — the browser-tab icon (`<link rel="icon">` in `<head>`).
- `powered-by-ringzero.png` — the "powered by" image near the bottom (`<img>` inside
  `.powered`).

Replace either file with your own image, keeping the **same file name** — or rename the
file and update the matching `src` attribute in `block_page.html`. Image sizes are
controlled by the `.logo` and `.powered img` CSS `width` rules in the `<style>` block; adjust
those if your images have different proportions. The "powered by" image links to
`https://ringzero.com.br/`; change that `href` to point elsewhere.

#### 4. Restyle or replace the page entirely

All styling is inline in the `<style>` block at the top of `block_page.html` (colors,
fonts, spacing, the card layout). Edit those rules to restyle the page, or replace the whole
file with your own HTML. If you rename `block_page.html`, update the reference in **two**
places so the redirect still works:

- `web_accessible_resources` in `manifest.json`.
- The `chrome.runtime.getURL("block_page.html")` call in `background.js`.

## License

GNU General Public License v2.0 only (GPL-2.0-only). See [`LICENSE`](./LICENSE).
