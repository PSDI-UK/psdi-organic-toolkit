// Constants and globals
// =====================

// Constant DOM references
const VARIABILITY_LINK = document.getElementById("variability-link");
const GLORIUS_LINK = document.getElementById("glorius-link");

// Functions
// =========

/**
 * Logs an event where the user clicks on one of the links, if they've consented to analytics
 * @param {String} resource 
 */
function logLinkClick(resource) {
  if (window.CookieConsent.acceptedCategory('analytics')) {
    window.gtag("event", "link_click", { resource: resource });
  }
}

// Setup
// =====
VARIABILITY_LINK.addEventListener("click", () => logLinkClick("variability"));
GLORIUS_LINK.addEventListener("click", () => logLinkClick("glorius"));