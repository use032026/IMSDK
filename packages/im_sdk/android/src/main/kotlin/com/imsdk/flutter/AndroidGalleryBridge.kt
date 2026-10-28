package com.imsdk.flutter

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

internal class AndroidGalleryBridge(
    private val activity: Activity,
    messenger: BinaryMessenger
) {
    private data class PendingSave(
        val path: String,
        val fileName: String,
        val mimeType: String,
        val isVideo: Boolean,
        val result: MethodChannel.Result
    )

    private var pendingSave: PendingSave? = null

    private val channel = MethodChannel(messenger, CHANNEL)

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "saveMedia" -> saveOrRequestPermission(
                    PendingSave(
                        path = call.argument<String>("path").orEmpty(),
                        fileName = call.argument<String>("fileName").orEmpty(),
                        mimeType = call.argument<String>("mimeType").orEmpty(),
                        isVideo = call.argument<Boolean>("isVideo") ?: false,
                        result = result
                    )
                )
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        val pending = pendingSave
        pendingSave = null
        pending?.result?.error("ACTIVITY_DETACHED", "The SDK page was detached", null)
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray
    ): Boolean {
        if (requestCode != WRITE_MEDIA_PERMISSION_REQUEST) return false
        val pending = pendingSave ?: return true
        pendingSave = null
        if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
            performSave(pending)
        } else {
            pending.result.error(
                "MEDIA_PERMISSION_DENIED",
                "Storage permission is required to save media on Android 9 and below",
                null
            )
        }
        return true
    }

    private fun saveOrRequestPermission(pending: PendingSave) {
        if (requiresLegacyWritePermission() &&
            activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            if (pendingSave != null) {
                pending.result.error(
                    "MEDIA_PERMISSION_REQUEST_ACTIVE",
                    "A media permission request is already active",
                    null
                )
                return
            }
            pendingSave = pending
            activity.requestPermissions(
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                WRITE_MEDIA_PERMISSION_REQUEST
            )
            return
        }
        performSave(pending)
    }

    private fun requiresLegacyWritePermission(): Boolean =
        Build.VERSION.SDK_INT in Build.VERSION_CODES.M..Build.VERSION_CODES.P

    private fun performSave(pending: PendingSave) {
        try {
            saveMedia(
                pending.path,
                pending.fileName,
                pending.mimeType,
                pending.isVideo
            )
            pending.result.success(null)
        } catch (error: Exception) {
            pending.result.error("SAVE_MEDIA_FAILED", error.message, null)
        }
    }

    private fun saveMedia(
        path: String,
        fileName: String,
        mimeType: String,
        isVideo: Boolean
    ) {
        val source = File(path)
        require(source.exists() && source.length() > 0) { "source file missing" }

        val resolver = activity.applicationContext.contentResolver
        val collection = if (isVideo) {
            MediaStore.Video.Media.EXTERNAL_CONTENT_URI
        } else {
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        }
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName.ifBlank { source.name })
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType.ifBlank {
                if (isVideo) "video/mp4" else "image/jpeg"
            })
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val directory = if (isVideo) {
                    Environment.DIRECTORY_MOVIES
                } else {
                    Environment.DIRECTORY_PICTURES
                }
                put(MediaStore.MediaColumns.RELATIVE_PATH, "$directory/IMSDK")
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }
        }

        val uri = resolver.insert(collection, values)
            ?: throw IllegalStateException("failed to create media item")
        try {
            resolver.openOutputStream(uri)?.use { output ->
                FileInputStream(source).use { input -> input.copyTo(output) }
            } ?: throw IllegalStateException("failed to open media output")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.clear()
                values.put(MediaStore.MediaColumns.IS_PENDING, 0)
                resolver.update(uri, values, null, null)
            }
        } catch (error: Exception) {
            resolver.delete(uri, null, null)
            throw error
        }
    }

    private companion object {
        const val CHANNEL = "im_sdk/gallery"
        const val WRITE_MEDIA_PERMISSION_REQUEST = 8602
    }
}
