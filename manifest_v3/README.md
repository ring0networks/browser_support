<!-- markdownlint-disable MD013 -->
<!--
SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
SPDX-License-Identifier: GPL-2.0-only
-->
# Ring Zero Dome Block Page Extension (Manifest V3)

This extension detects connection resets in chromium browsers and shows a custom static page instead of a browser error.
It uses service workers and is compatible with [Manifest V3](https://developer.chrome.com/docs/extensions/develop/migrate/what-is-mv3).

> [!NOTE]
> Extensions that use service workers cannot be loaded as temporay add-ons on Firefox.
> Hence, Firefox is not listed here.

## How to install and use the extension

The extension is designed to work on chromium-based browsers, including Google Chrome, Mozilla Firefox and Microsoft Edge.

### 1. Save the files

First, create directory `BlockPageExtension` on your computer and copy all the files from this directory to it.

### 2. Install the extension on your browser

The steps to load the extension are slightly different for each browser:

Google Chrome:

- Open Chrome.
- Enter `chrome://extensions` in the address bar and press `Enter`.
- In the upper right corner of the extensions page, activate the "developer mode".
- Click the "Load unpacked" button.
- Navigate to the `BlockPageExtension` directory you have created and select it.

The extension will appear on your list of installed extensions.

Microsoft Edge:

- Open Edge.
- Enter `edge://extensions` in the address bar and press `Enter`.
- In the lower left corner of the page, activate the "developer mode".
- Click "Load unpacked".
- Browse to the `BlockPageExtension` directory and select it.

The extension will appear on your list of installed extensions.

> [!IMPORTANT]
> Edge will ask you from time to time if you want to remove developer extensions.

### 3. Test the extension

To test if the extension is working correctly:

- Activate Ring Zero Dome.
- From a station or device whose traffic is inspected by Ring Zero Dome, install the Ring Zero Dome Block Page Extension in the browser of choice.
- In the chosen browser, clear navigation data and try to access a URL corresponding to one of the blocked Ring Zero Dome categories.
- The connection should be blocked and the custom lock page should be displayed by the browser.
