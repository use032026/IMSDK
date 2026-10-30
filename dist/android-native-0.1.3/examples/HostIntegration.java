package com.example.imsdkhost;

import android.app.Activity;
import com.imsdk.nativebridge.ImSdk;
import java.lang.ref.WeakReference;
import java.util.LinkedHashMap;
import java.util.Map;

/** Integration helper. Service configuration and IM credentials come from the host. */
public final class HostIntegration implements ImSdk.EventListener {
    /** Call only after the host has obtained the user's actual privacy consent. */
    public void openPersonalMessenger(
            Activity activity,
            String apiBaseUrl,
            String serviceRealmId,
            String storageNamespace,
            boolean privacyConsentGranted,
            ImSdk.Callback result) {
        if (!privacyConsentGranted) {
            // No SDK initialization occurs before consent.
            activity.runOnUiThread(() -> result.onError(
                    "CONSENT_REQUIRED", "Please complete the host privacy flow", null));
            return;
        }
        Map<String, Object> passwordLogin = new LinkedHashMap<>();
        passwordLogin.put("space", "personal");
        passwordLogin.put("loginType", "lpp_id");

        Map<String, Object> configuration = new LinkedHashMap<>();
        configuration.put("apiBaseUrl", apiBaseUrl);
        configuration.put("serviceRealmId", serviceRealmId);
        configuration.put("storageNamespace", storageNamespace);
        configuration.put("privacyConsentGranted", true);
        configuration.put("passwordLogin", passwordLogin);
        initializeAndOpen(activity, configuration, result);
    }

    /** Also supports a fixed enterprise passwordLogin configuration supplied by the host. */
    public void initializeAndOpen(
            Activity activity,
            Map<String, Object> consentedConfiguration,
            ImSdk.Callback result) {
        if (!Boolean.TRUE.equals(consentedConfiguration.get("privacyConsentGranted"))) {
            activity.runOnUiThread(() -> result.onError(
                    "CONSENT_REQUIRED", "Please complete the host privacy flow", null));
            return;
        }
        WeakReference<Activity> host = new WeakReference<>(activity);
        ImSdk.setEventListener(this);
        ImSdk.initialize(activity.getApplicationContext(), consentedConfiguration, new ImSdk.Callback() {
            @Override public void onSuccess(Object value) {
                Activity current = host.get();
                if (current == null || current.isFinishing() || current.isDestroyed()) {
                    result.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null);
                    return;
                }
                ImSdk.openMessenger(current, result);
            }

            @Override public void onError(String code, String message, Object details) {
                result.onError(code, message, details);
            }
        });
    }

    /** Optional: initialize first; obtain these IM credentials from a trusted host backend. */
    public void authenticateAndOpen(
            Activity activity,
            Map<String, Object> imCredentials,
            ImSdk.Callback result) {
        WeakReference<Activity> host = new WeakReference<>(activity);
        ImSdk.authenticate(imCredentials, new ImSdk.Callback() {
            @Override public void onSuccess(Object value) {
                Activity current = host.get();
                if (current == null || current.isFinishing() || current.isDestroyed()) {
                    result.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null);
                    return;
                }
                ImSdk.openMessenger(current, result);
            }

            @Override public void onError(String code, String message, Object details) {
                result.onError(code, message, details);
            }
        });
    }

    /** Optional: authenticate the matching account/space before opening an authorized conversation. */
    public void openAuthorizedConversation(Activity activity, String conversationId, ImSdk.Callback result) {
        Map<String, Object> target = new LinkedHashMap<>();
        target.put("conversationId", conversationId);
        ImSdk.openDirectConversation(activity, target, result);
    }

    /** Optional: authenticated enterprise entry; success may display a queued service request. */
    public void openCurrentTenantService(Activity activity, ImSdk.Callback result) {
        Map<String, Object> target = new LinkedHashMap<>();
        target.put("entry", "currentTenant");
        ImSdk.openCustomerService(activity, target, result);
    }

    @Override public void onEvent(Map<String, ? extends Object> event) {
        // Runs on Android's main thread. Observe only needed, sanitized fields.
        // A page-open callback is not a login or message-delivery receipt.
        // Do not retain an Activity or log complete event/credential/backend payloads here.
    }

    /** Synchronize the host's selected locale/theme after initialization. */
    public void updatePresentation(String locale, String themeMode, ImSdk.Callback result) {
        Map<String, Object> settings = new LinkedHashMap<>();
        settings.put("locale", locale);
        settings.put("themeMode", themeMode);
        ImSdk.updatePresentation(settings, result);
    }

    public void logout(ImSdk.Callback result) {
        ImSdk.logout(result);
    }

    /** Clear when this listener owner is released, even if the SDK runtime is retained. */
    public void detachListener() {
        ImSdk.setEventListener(null);
    }

    /** End the SDK usage cycle, not every Activity recreation. May initialize again afterwards. */
    public void shutdown(ImSdk.Callback result) {
        detachListener();
        ImSdk.shutdown(result);
    }
}
