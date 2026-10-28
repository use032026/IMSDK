package com.example.imsdkhost

import android.app.Activity
import com.imsdk.nativebridge.ImSdk

/** Compile this in a host app and supply real, authorized values through your own backend. */
class HostIntegration {
    fun openDirect(activity: Activity, configuration: Map<String, Any?>,
                   credentials: Map<String, Any?>, target: Map<String, Any?>,
                   result: ImSdk.Callback) {
        ImSdk.initialize(activity, configuration, object : ImSdk.Callback {
            override fun onSuccess(value: Any?) {
                ImSdk.authenticate(credentials, object : ImSdk.Callback {
                    override fun onSuccess(value: Any?) = ImSdk.openDirectConversation(activity, target, result)
                    override fun onError(code: String, message: String?, details: Any?) = result.onError(code, message, details)
                })
            }
            override fun onError(code: String, message: String?, details: Any?) = result.onError(code, message, details)
        })
    }
}
