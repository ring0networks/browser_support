// background.js
// This script runs in the background as a service worker for the Chrome extension.
// It is compatible with Firefox and Edge as well.

// Listen for network errors using the webRequest API.
// The onErrorOccurred event fires when any network request fails.
chrome.webRequest.onErrorOccurred.addListener(
  function(details) {
    // Log the error details for debugging purposes.
    console.log("Network error detected:", details);
    console.log("Error message:", details.error); // Log the actual error message

    // Check if the exact error message is one of the known connection reset errors.
    // Using explicit OR conditions for maximum clarity and direct comparison.
    if (details.error === "net::ERR_CONNECTION_RESET" || // Chromium-based browsers
        details.error === "PR_CONNECT_RESET_ERROR" ||    // Older/some Firefox displays on page
        details.error === "NS_ERROR_NET_RESET") {         // Actual error string in Firefox webRequest details

      // Only proceed if the error occurred for the main frame.
      // The 'type' property indicates the resource type ('main_frame', 'sub_frame', 'script', 'image', 'xhr', etc.).
      if (details.type === "main_frame") {
        // Get the ID of the tab where the error occurred.
        const tabId = details.tabId;

        // Ensure the tabId is valid (not -1 for internal requests or non-tab contexts).
        if (tabId !== -1) {
          // Construct the URL for the custom error page.
          const customErrorPageUrl = chrome.runtime.getURL("block_page.html");

          // Update the tab's URL to redirect to the custom error page.
          // This will replace the current page (which might be the default error page)
          // with our custom HTML content.
          chrome.tabs.update(tabId, { url: customErrorPageUrl }, function() {
            if (chrome.runtime.lastError) {
              // Log any errors that occur during the tab update (e.g., tab no longer exists).
              console.error("Error updating tab:", chrome.runtime.lastError);
            } else {
              console.log(`Redirected tab ${tabId} to custom error page for main frame connection reset error.`);
            }
          });
        }
      } else {
        console.log(`Error was for a non-main frame resource (${details.type}), not redirecting.`);
      }
    } else {
      console.log(`Error '${details.error}' did not match a known connection reset type.`);
    }
  },
  // Filter for URLs to listen to. "<all_urls>" means listen for errors on any URL.
  // The 'types' array specifies which request types to listen for.
  { urls: ["<all_urls>"], types: ["main_frame"] }
);
