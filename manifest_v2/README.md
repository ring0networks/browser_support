<!-- markdownlint-disable MD013 -->
<!--
Copyright (C) 2025 Ring Zero Desenvolvimento de Software LTDA.
All rights reserved.
-->
# Ring Zero Dome Block Page Extension (Manifest V2)

This extension detects connection resets in chromium browsers and shows a custom static page instead of a browser error.
It uses background scripts and is compatible with [Manifest V2](https://developer.chrome.com/docs/extensions/mv2/content-scripts).

## How to install and use the extension

The extension is designed to work on chromium-based browsers, including Google Chrome, Mozilla Firefox and Microsoft Edge.

### 1. Save the files

First, create a new directory on your computer (for example, connectionResEtextension) and copy all the files available to it.

### 2. Install the extension on your browser

The steps to load the extension are slightly different for each browser:

Google Chrome:

- Open Chrome.
- Enter `chrome://extensions` in the address bar and press `Enter`.
- In the upper right corner of the extensions page, activate the "developer mode".
- Click the "Load unpacked" button.
- Navigate to the `ConnectionResetExtension` directory you have created and select it.

The extension will appear on your list of installed extensions.

Mozilla Firefox:

- Open Firefox.
- Type `about:debugging#/runtime/this-firefox` in the address bar and press `Enter`.
- Click the "Load Temporary Add-on...".
- Navigate to the `ConnectionResetExtension` directory and select any file within it (for example, manifest.json).

The extension will be loaded.

> [!IMPORTANT]
> Keep in mind that temporary add-ons are removed when Firefox is closed.

Microsoft Edge:

- Open Edge.
- Enter `edge://extensions` in the address bar and press `Enter`.
- In the lower left corner of the page, activate the "developer mode".
- Click "Load unpacked".
- Browse to the `ConnectionResetExtension` directory and select it.

The extension will appear on your list of installed extensions.

> [!IMPORTANT]
> Edge will ask you from time to time if you want to remove developer extensions.

### 3. Test the extension

To test if the extension is working correctly:

- Activate Ring Zero Dome.
- From a station or device whose traffic is inspected by Ring Zero Dome, go to one of the browsers listed above, already with the extension installed ConnectionSetextension.
- In the chosen browser, try to access a URL relating to a domain contained in one of the Ring Zero Dome blocklists.
- The connection should be locked and the custom lock page should be displayed by the browser.
