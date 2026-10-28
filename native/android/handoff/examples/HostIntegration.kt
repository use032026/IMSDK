package com.example.imsdkhost

import android.app.Activity
import com.imsdk.nativebridge.ImSdk
import java.lang.ref.WeakReference

/** Integration helper. Service configuration and IM credentials come from the host. */
class HostIntegration : ImSdk.EventListener {
    /** No SDK initialization occurs before the host has obtained actual consent. */
    fun openPersonalMessenger(
        activity: Activity,
        apiBaseUrl: String,
        serviceRealmId: String,
        storageNamespace: String,
        privacyConsentGranted: Boolean,
        result: ImSdk.Callback,
    ) {
        if (!privacyConsentGranted) {
            activity.runOnUiThread {
                result.onError("CONSENT_REQUIRED", "Please complete the host privacy flow", null)
            }
            return
        }
        val configuration = mapOf<String, Any?>(
            "apiBaseUrl" to apiBaseUrl,
            "serviceRealmId" to serviceRealmId,
            "storageNamespace" to storageNamespace,
            "privacyConsentGranted" to true,
            "passwordLogin" to mapOf("space" to "personal", "loginType" to "lpp_id"),
        )
        initializeAndOpen(activity, configuration, result)
    }

    /** Also accepts a fixed enterprise passwordLogin configuration supplied by the host. */
    fun initializeAndOpen(
        activity: Activity,
        consentedConfiguration: Map<String, Any?>,
        result: ImSdk.Callback,
    ) {
        if (consentedConfiguration["privacyConsentGranted"] != true) {
            activity.runOnUiThread {
                result.onError("CONSENT_REQUIRED", "Please complete the host privacy flow", null)
            }
            return
        }
        val host = WeakReference(activity)
        ImSdk.setEventListener(this)
        ImSdk.initialize(activity.applicationContext, consentedConfiguration, object : ImSdk.Callback {
            override fun onSuccess(value: Any?) {
                val current = host.get()
                if (current == null || current.isFinishing || current.isDestroyed) {
                    result.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null)
                    return
                }
                ImSdk.openMessenger(current, result)
            }

            override fun onError(code: String, message: String?, details: Any?) {
                result.onError(code, message, details)
            }
        })
    }

    /** Optional: initialize first; obtain these IM credentials from a trusted host backend. */
    fun authenticateAndOpen(
        activity: Activity,
        imCredentials: Map<String, Any?>,
        result: ImSdk.Callback,
    ) {
        val host = WeakReference(activity)
        ImSdk.authenticate(imCredentials, object : ImSdk.Callback {
            override fun onSuccess(value: Any?) {
                val current = host.get()
                if (current == null || current.isFinishing || current.isDestroyed) {
                    result.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null)
                    return
                }
                ImSdk.openMessenger(current, result)
            }

            override fun onError(code: String, message: String?, details: Any?) {
                result.onError(code, message, details)
            }
        })
    }

    /** Optional: authenticate the matching account/space before opening this target. */
    fun openAuthorizedConversation(activity: Activity, conversationId: String, result: ImSdk.Callback) {
        ImSdk.openDirectConversation(activity, mapOf("conversationId" to conversationId), result)
    }

    /** Optional: authenticated enterprise entry; success may display a queued service request. */
    fun openCurrentTenantService(activity: Activity, result: ImSdk.Callback) {
        ImSdk.openCustomerService(activity, mapOf("entry" to "currentTenant"), result)
    }

    override fun onEvent(event: Map<String, Any?>) {
        // Main thread. Observe only needed, sanitized fields and avoid retaining an Activity.
        // Page-open callbacks are not login/message-delivery receipts; do not log raw payloads.
    }

    fun logout(result: ImSdk.Callback) = ImSdk.logout(result)

    /** Clear when this owner is released, even if the SDK runtime remains active. */
    fun detachListener() = ImSdk.setEventListener(null)

    /** End the SDK usage cycle, not every Activity recreation. Can initialize again afterwards. */
    fun shutdown(result: ImSdk.Callback) {
        detachListener()
        ImSdk.shutdown(result)
    }
}
