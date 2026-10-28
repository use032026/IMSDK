package com.imsdk.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File

/** Platform capabilities used by the SDK. Owns no host login, navigation or push state. */
class ImSdkPlugin : FlutterPlugin, ActivityAware {
    private var engineBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var gallery: AndroidGalleryBridge? = null
    private var attachments: AndroidChatAttachmentPickerBridge? = null
    private var diagnostics: MethodChannel? = null

    private val permissionListener = PluginRegistry.RequestPermissionsResultListener {
            requestCode, _, grantResults ->
        gallery?.onRequestPermissionsResult(requestCode, grantResults) ?: false
    }
    private val activityResultListener = PluginRegistry.ActivityResultListener {
            requestCode, resultCode, data ->
        attachments?.handleActivityResult(requestCode, resultCode, data) ?: false
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        engineBinding = binding
        diagnostics = MethodChannel(binding.binaryMessenger, "im_sdk/diagnostics_storage").apply {
            setMethodCallHandler { call, result ->
                if (call.method != "prepare") {
                    result.notImplemented()
                } else {
                    try {
                        val root = File(binding.applicationContext.noBackupFilesDir, "im_sdk/diagnostics/v1")
                        check(root.mkdirs() || root.isDirectory) { "SDK diagnostics directory unavailable" }
                        result.success(root.absolutePath)
                    } catch (_: Exception) {
                        result.error("DIAGNOSTICS_STORAGE_UNAVAILABLE", "Unable to prepare SDK diagnostics", null)
                    }
                }
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val engine = checkNotNull(engineBinding)
        activityBinding = binding
        gallery = AndroidGalleryBridge(binding.activity, engine.binaryMessenger)
        attachments = AndroidChatAttachmentPickerBridge(binding.activity, engine.binaryMessenger)
        binding.addRequestPermissionsResultListener(permissionListener)
        binding.addActivityResultListener(activityResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() = detachActivity()
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)
    override fun onDetachedFromActivity() = detachActivity()

    private fun detachActivity() {
        activityBinding?.removeRequestPermissionsResultListener(permissionListener)
        activityBinding?.removeActivityResultListener(activityResultListener)
        activityBinding = null
        gallery?.dispose()
        attachments?.dispose()
        gallery = null
        attachments = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        detachActivity()
        diagnostics?.setMethodCallHandler(null)
        diagnostics = null
        engineBinding = null
    }
}
