package com.imsdk.nativebridge

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.ArrayDeque

/** Native facade. All callbacks are delivered on Android's main thread. */
object ImSdk {
    interface Callback {
        fun onSuccess(value: Any?)
        fun onError(code: String, message: String?, details: Any?)
    }

    fun interface EventListener {
        fun onEvent(event: Map<String, Any?>)
    }

    internal const val ENGINE_CACHE_ID = "com.imsdk.nativebridge.engine.v1"
    private const val STARTUP_TIMEOUT_MS = 20_000L
    private const val OPERATION_TIMEOUT_MS = 60_000L
    private val main = Handler(Looper.getMainLooper())
    private var engine: FlutterEngine? = null
    private var channel: MethodChannel? = null
    private var ready = false
    private var initialized = false
    private var stopping = false
    private var listener: EventListener? = null
    private var page = WeakReference<ImSdkActivity>(null)
    private var openingPage = false
    private var generation = 0L
    private var startupTimeout: Runnable? = null
    private var operationTimeout: Runnable? = null
    private val queued = ArrayDeque<Operation>()
    private var active: Operation? = null

    private class Operation(
        val method: String,
        val arguments: Map<String, Any?>?,
        val callback: Callback,
        val didSucceed: (() -> Unit)? = null,
        val didFinish: (() -> Unit)? = null,
    ) {
        var completed = false
    }

    @JvmStatic
    fun setEventListener(eventListener: EventListener?) = onMain { listener = eventListener }

    @JvmStatic
    fun initialize(context: Context, configuration: Map<String, Any?>, callback: Callback) = onMain {
        if (configuration["privacyConsentGranted"] != true) {
            callback.onError("CONSENT_REQUIRED", "The host must obtain privacy consent before starting the SDK", null)
            return@onMain
        }
        if (stopping) {
            callback.onError("SDK_STOPPING", "SDK shutdown is in progress", null)
            return@onMain
        }
        try {
            if (engine == null) createEngine(context.applicationContext)
        } catch (_: Exception) {
            disposeEngine("SDK_START_FAILED")
            callback.onError("SDK_START_FAILED", "Unable to start the SDK engine", null)
            return@onMain
        }
        enqueue(Operation("initialize", configuration.toMap(), callback,
            didSucceed = { initialized = true }))
    }

    @JvmStatic
    fun authenticate(credentials: Map<String, Any?>, callback: Callback) = onMain {
        enqueueInitialized(Operation("authenticate", credentials.toMap(), callback))
    }

    /** Opens account/password login, or conversations for an active session. */
    @JvmStatic
    fun openMessenger(activity: Activity, callback: Callback) =
        open(activity, "openMessenger", emptyMap(), callback)

    @JvmStatic
    fun openDirectConversation(activity: Activity, target: Map<String, Any?>, callback: Callback) =
        open(activity, "openDirectConversation", target, callback)

    @JvmStatic
    fun openCustomerService(activity: Activity, target: Map<String, Any?>, callback: Callback) =
        open(activity, "openCustomerService", target, callback)

    private fun open(activity: Activity, method: String, target: Map<String, Any?>, callback: Callback) = onMain {
        if (activity.isFinishing || activity.isDestroyed) {
            callback.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null)
            return@onMain
        }
        val host = WeakReference(activity)
        val result = object : Callback {
            override fun onSuccess(value: Any?) {
                val currentHost = host.get()
                if (currentHost == null || currentHost.isFinishing || currentHost.isDestroyed) {
                    callback.onError("HOST_ACTIVITY_UNAVAILABLE", "The host Activity is unavailable", null)
                    return
                }
                try {
                    showPage(currentHost)
                } catch (_: Exception) {
                    openingPage = false
                    callback.onError("SDK_PAGE_OPEN_FAILED", "Unable to open the SDK page", null)
                    return
                }
                callback.onSuccess(value)
            }
            override fun onError(code: String, message: String?, details: Any?) =
                callback.onError(code, message, details)
        }
        enqueueInitialized(Operation(method, target.toMap(), result))
    }

    @JvmStatic
    fun logout(callback: Callback) = onMain {
        enqueueInitialized(Operation("logout", null, callback, didSucceed = { closePage() }))
    }

    /** Destroys the engine only after Dart has completed or failed its own shutdown. */
    @JvmStatic
    fun shutdown(callback: Callback) = onMain {
        if (engine == null) {
            callback.onSuccess(null)
            return@onMain
        }
        if (stopping) {
            callback.onError("SDK_STOPPING", "SDK shutdown is already in progress", null)
            return@onMain
        }
        stopping = true
        enqueue(Operation("shutdown", null, callback, didFinish = { disposeEngine("SDK_SHUTDOWN") }))
    }

    private fun createEngine(context: Context) {
        val currentGeneration = ++generation
        val created = FlutterEngine(context)
        engine = created
        ready = false
        initialized = false
        channel = MethodChannel(created.dartExecutor.binaryMessenger, "im_sdk/control").apply {
            setMethodCallHandler { call, result -> handleDartCall(call, result, currentGeneration) }
        }
        FlutterEngineCache.getInstance().put(ENGINE_CACHE_ID, created)
        startupTimeout = Runnable {
            if (generation == currentGeneration && !ready) disposeEngine("SDK_READY_TIMEOUT")
        }.also { main.postDelayed(it, STARTUP_TIMEOUT_MS) }
        created.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
    }

    private fun handleDartCall(call: MethodCall, result: MethodChannel.Result, expectedGeneration: Long) {
        if (generation != expectedGeneration) {
            result.error("SDK_RETIRED", "This SDK engine is retired", null)
            return
        }
        when (call.method) {
            "event" -> {
                val raw = call.arguments as? Map<*, *>
                val event = raw?.entries?.mapNotNull { (key, value) ->
                    (key as? String)?.let { it to value }
                }?.toMap().orEmpty()
                if (event["type"] == "ready") markReady()
                result.success(null)
                listener?.onEvent(event)
            }
            "ready" -> { markReady(); result.success(null) }
            "close" -> { result.success(null); closePage() }
            else -> result.notImplemented()
        }
    }

    private fun markReady() {
        if (ready) return
        ready = true
        startupTimeout?.let { main.removeCallbacks(it) }
        startupTimeout = null
        drain()
    }

    private fun enqueueInitialized(operation: Operation) {
        if (engine == null || (!initialized && active?.method != "initialize" &&
                queued.none { it.method == "initialize" })) {
            operation.callback.onError("SDK_NOT_INITIALIZED", "Initialize the SDK first", null)
            return
        }
        if (stopping) {
            operation.callback.onError("SDK_STOPPING", "SDK shutdown is in progress", null)
            return
        }
        enqueue(operation)
    }

    private fun enqueue(operation: Operation) {
        queued.addLast(operation)
        drain()
    }

    private fun drain() {
        if (!ready || active != null || engine == null || queued.isEmpty()) return
        val operation = queued.removeFirst()
        active = operation
        operationTimeout = Runnable {
            finish(operation, errorCode = "SDK_OPERATION_TIMEOUT", message = "SDK operation timed out",
                retireEngine = true)
        }.also { main.postDelayed(it, OPERATION_TIMEOUT_MS) }
        channel?.invokeMethod(operation.method, operation.arguments, object : MethodChannel.Result {
            override fun success(result: Any?) = onMain { finish(operation, value = result) }
            override fun error(code: String, message: String?, details: Any?) = onMain {
                finish(operation, errorCode = code, message = message, details = details)
            }
            override fun notImplemented() = onMain {
                finish(operation, errorCode = "SDK_METHOD_UNAVAILABLE", message = "SDK method is unavailable")
            }
        })
    }

    private fun finish(operation: Operation, value: Any? = null, errorCode: String? = null,
                       message: String? = null, details: Any? = null, retireEngine: Boolean = false) {
        if (operation.completed || active !== operation) return
        operation.completed = true
        operationTimeout?.let { main.removeCallbacks(it) }
        operationTimeout = null
        active = null
        if (errorCode == null) operation.didSucceed?.invoke()
        if (retireEngine) disposeEngine("SDK_OPERATION_TIMEOUT")
        operation.didFinish?.invoke()
        try {
            if (errorCode == null) operation.callback.onSuccess(value)
            else operation.callback.onError(errorCode, message, details)
        } finally {
            drain()
        }
    }

    private fun showPage(host: Activity) {
        val existing = page.get()
        if (existing != null && !existing.isFinishing && !existing.isDestroyed) {
            if (host !== existing) {
                host.startActivity(ImSdkActivity.intent(host).addFlags(android.content.Intent.FLAG_ACTIVITY_REORDER_TO_FRONT))
            }
            return
        }
        if (openingPage) return
        openingPage = true
        host.startActivity(ImSdkActivity.intent(host))
    }

    internal fun pageAttached(activity: ImSdkActivity) {
        openingPage = false
        page = WeakReference(activity)
    }

    internal fun pageDetached(activity: ImSdkActivity, changingConfigurations: Boolean) {
        if (page.get() !== activity) return
        page.clear()
        openingPage = false
        if (!changingConfigurations) listener?.onEvent(mapOf("type" to "pageClosed"))
    }

    private fun closePage() {
        page.get()?.finish()
        openingPage = false
    }

    private fun disposeEngine(reason: String) {
        generation++
        startupTimeout?.let { main.removeCallbacks(it) }
        operationTimeout?.let { main.removeCallbacks(it) }
        startupTimeout = null
        operationTimeout = null
        ready = false
        initialized = false
        // Disconnect the FlutterActivity before destroying an engine it may still reference.
        page.get()?.detachFromFlutterEngine()
        closePage()
        channel?.setMethodCallHandler(null)
        channel = null
        FlutterEngineCache.getInstance().remove(ENGINE_CACHE_ID)
        engine?.destroy()
        engine = null
        stopping = false
        val rejected = mutableListOf<Operation>()
        active?.let { rejected.add(it) }
        active = null
        while (queued.isNotEmpty()) rejected.add(queued.removeFirst())
        rejected.forEach { operation ->
            if (!operation.completed) {
                operation.completed = true
                operation.callback.onError(reason, "SDK engine stopped", null)
            }
        }
    }

    private fun onMain(action: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) action() else main.post { action() }
    }
}
