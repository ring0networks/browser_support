# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Chromium browser extension for **Ring Zero Dome**. When the Dome gateway resets a
connection to a blocklisted domain, the browser would otherwise show a generic network
error. This extension intercepts that reset and replaces the tab with a branded block
page (`block_page.html`, Portuguese: "Acesso Bloqueado") so the user knows the block was
intentional. All other network errors are left to the browser.

This is a **public, MIT-licensed** repository. There is **no compiler, no tests, no
lint, and no package manager** — the extension is plain JS/HTML/JSON loaded unpacked into
the browser. "Building" means loading a version directory via `chrome://extensions` →
developer mode → *Load unpacked* (per-browser steps are in each version's `README.md`).

The one script is [`customize.sh`](./customize.sh): it copies a chosen version
(`manifest_v3` and/or `manifest_v2`) into `build/<version>/` and applies customizations
(extension name, block page title/heading/message, logo) to the copy, leaving the tracked
source pristine. It is interactive by default with optional flags (`--version` (default `v3`), `--name`,
`--title`, `--heading`, `--message`, `--logo`, `--yes`). `build/` is git-ignored. The
`powered-by-ringzero.png` image and its link are intentionally never modified.

`customize.sh` follows the Ring Zero shell conventions: `#!/usr/bin/env bash`,
`set -eo pipefail`, and a self-contained BSD/GNU-safe `sed_i` helper (it does **not** source
`dome_admin`'s `setup-common.sh`). HTML/JSON escaping goes through `sed` rather than bash
`${//}` substitution, because bash 5.2's `patsub_replacement` makes `&` in a replacement
mean "the matched text" — which silently corrupts HTML entities.

## Two manifest versions

The same extension ships in two directories that must be kept in sync:

- `manifest_v3/` — **the default**, for all Chromium browsers (Chrome, Edge, and Firefox
  when not a temporary add-on). Uses a Manifest V3 service worker (`background.service_worker`).
- `manifest_v2/` — **Firefox temporary add-ons only**. Firefox (≥139) does not support
  Manifest V3 service workers on temporary add-ons, so this uses a Manifest V2 background
  script plus `webRequestBlocking` and inline `<all_urls>` permission.

`background.js`, `block_page.html`, and the two PNGs are **byte-identical across both
directories**. Only the two `manifest.json` files differ (manifest_version, permissions,
and `background` / `web_accessible_resources` shape). When you change behavior or the block
page, apply the edit to **both** directories.

## How the block works (`background.js`)

Registered on `chrome.webRequest.onErrorOccurred` filtered to `types: ["main_frame"]`.
On each error it:

1. Matches the reset error string against three known values:
   `net::ERR_CONNECTION_RESET` (Chromium), `PR_CONNECT_RESET_ERROR` and
   `NS_ERROR_NET_RESET` (Firefox variants).
2. Only acts on `details.type === "main_frame"` and a valid `tabId` (`!== -1`) — sub-frame,
   script, image, and XHR resets are deliberately ignored so only a full-page navigation
   reset triggers the block page (see commit `b1df84b`).
3. Redirects the tab to `chrome.runtime.getURL("block_page.html")` via `chrome.tabs.update`.

When adding a new reset condition, add its exact error string to the OR chain — matching is
by exact string equality, not substring.

## Customization

Two intended customization points (both READMEs document them):

- Extension display name → each `manifest.json` `name` field.
- Block page → `block_page.html` (text, `dome-logo.png`, `powered-by-ringzero.png`).

## Licensing and headers

The repo is MIT-licensed (`LICENSE`, `Copyright (c) 2026 Ring Zero Desenvolvimento de
Software LTDA`), following the same standard as the public `ringzero/luanftables` repo.

Every text source file carries a two-line SPDX header — and here, unlike the private Ring
Zero repos, it **includes** `SPDX-License-Identifier: MIT` because this repo is public:

```js
// SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
// SPDX-License-Identifier: MIT
```

Adapt the comment syntax to the file: `//` for `.js`, `<!-- … -->` for `.html` and `.md`.
`manifest.json` files carry **no** header (JSON has no comment syntax). Do not reintroduce
the old `Copyright … All rights reserved.` blocks — they contradict the MIT license.

## Conventions specific to this repo

- Every doc has an English `README.md` and a Portuguese `README_pt_br.md` — keep the pair in
  sync when editing docs.
- Markdown files start with `<!-- markdownlint-disable MD013 -->` (long lines are allowed),
  followed by the SPDX comment block.
