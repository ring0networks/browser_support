// background.js
// This script runs in the background as a service worker for the Chrome extension.

// Listen for network errors using the webRequest API.
// The onErrorOccurred event fires when a network request fails.
chrome.webRequest.onErrorOccurred.addListener(
  function(details) {
    // Log the error details for debugging purposes.
    console.log("Network error detected:", details);

    // Check if the specific error is net::ERR_CONNECTION_RESET.
    // This indicates a connection was forcibly closed by the remote server or an intermediary.
    if (details.error === "net::ERR_CONNECTION_RESET") {
      // Get the ID of the tab where the error occurred.
      const tabId = details.tabId;

      // Ensure the tabId is valid (not -1 for internal requests or non-tab contexts).
      if (tabId !== -1) {
        // Construct the URL for the custom error page.
        // chrome.runtime.getURL() provides the full URL to a resource within the extension.
        const customErrorPageUrl = chrome.runtime.getURL("block_page.html");

        // Update the tab's URL to redirect to the custom error page.
        // This will replace the current page (which might be the default error page)
        // with our custom HTML content.
        chrome.tabs.update(tabId, { url: customErrorPageUrl }, function() {
          if (chrome.runtime.lastError) {
            // Log any errors that occur during the tab update (e.g., tab no longer exists).
            console.error("Error updating tab:", chrome.runtime.lastError);
          } else {
            console.log(`Redirected tab ${tabId} to custom error page for ERR_CONNECTION_RESET.`);
          }
        });
      }
    }
  },
  // Filter for URLs to listen to. "<all_urls>" means listen for errors on any URL.
  { urls: ["<all_urls>"] }
);
