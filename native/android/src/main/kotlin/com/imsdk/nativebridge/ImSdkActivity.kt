package com.imsdk.nativebridge

import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

/** Closing this Activity retains the SDK engine and never terminates the host task. */
class ImSdkActivity : FlutterActivity() {
    private var retiredEngineId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        if (FlutterEngineCache.getInstance().get(ImSdk.ENGINE_CACHE_ID) == null) {
            // Android may restore this Activity after process death, or launch it after shutdown.
            // A cached, non-running placeholder lets FlutterActivity complete its lifecycle safely;
            // it never runs Dart, registers plugins, restores credentials or opens a new account.
            retiredEngineId = "${ImSdk.ENGINE_CACHE_ID}.retired.${System.identityHashCode(this)}"
            FlutterEngineCache.getInstance().put(
                retiredEngineId!!, FlutterEngine(applicationContext, null, false))
        }
        super.onCreate(savedInstanceState)
        if (retiredEngineId != null) {
            finish()
            return
        }
        ImSdk.pageAttached(this)
    }

    override fun getCachedEngineId(): String? = retiredEngineId ?: super.getCachedEngineId()

    override fun shouldDestroyEngineWithHost(): Boolean = retiredEngineId != null

    override fun shouldAttachEngineToActivity(): Boolean = retiredEngineId == null

    override fun onDestroy() {
        ImSdk.pageDetached(this, isChangingConfigurations)
        super.onDestroy()
    }

    companion object {
        internal fun intent(context: Context): Intent =
            CachedEngineIntentBuilder(ImSdkActivity::class.java, ImSdk.ENGINE_CACHE_ID)
                .destroyEngineWithActivity(false)
                .build(context)
    }
}
