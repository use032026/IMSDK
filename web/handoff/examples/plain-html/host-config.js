/* Host-owned integration configuration. No account, password or token belongs here.
 * Set window.IMSDK_HOST_CONFIG before this page loads, or call
 * window.IMSDK_HOST.configure(config) after the host obtains its configuration
 * and required privacy consent. An existing initialized/authenticated client
 * may be supplied as window.IMSDK_HOST_CLIENT and remains owned by the host.
 */
if (typeof window.IMSDK_HOST_CONFIG === 'undefined') window.IMSDK_HOST_CONFIG = null;
