/* Default connection to the service authorized for this delivery.
 * Accounts, passwords and tokens are entered or supplied at runtime only.
 * A host may override window.IMSDK_HOST_CONFIG (including null), or supply
 * its own window.IMSDK_HOST_CLIENT before this script loads.
 */
if (typeof window.IMSDK_HOST_CONFIG === 'undefined') window.IMSDK_HOST_CONFIG = {
  "apiBaseUrl": "https://chat.hearteasechat.com",
  "serviceRealmId": "im-sdk-personal-validation",
  "passwordLogin": {
    "space": "personal",
    "loginType": "lpp_id"
  },
  "privacyConsentGranted": true
};
