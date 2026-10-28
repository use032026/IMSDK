package com.imsdk.flutter

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale
import java.util.UUID
import java.util.concurrent.Executors

internal class AndroidChatAttachmentPickerBridge(
    private val activity: Activity,
    messenger: BinaryMessenger,
) {
    private val executor = Executors.newSingleThreadExecutor()
    private var pendingResult: MethodChannel.Result? = null
    private var pendingRequest: PickDocumentRequest? = null

    @Volatile private var disposed = false
    private val channel = MethodChannel(messenger, CHANNEL_NAME)

    init {
        channel.setMethodCallHandler { call, result ->
            if (call.method != "pickDocument") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            if (pendingResult != null) {
                result.error("PICKER_BUSY", "A document picker is already active", null)
                return@setMethodCallHandler
            }

            val allowedExtensions = call.argument<List<String>>("allowedExtensions")
                ?.map { it.trim().lowercase(Locale.ROOT) }
                ?.filter { it.isNotEmpty() }
                ?.toSet()
                .orEmpty()
            val blockedMimeTypes = call.argument<List<String>>("blockedMimeTypes")
                ?.map { it.trim().lowercase(Locale.ROOT) }
                ?.filter { it.isNotEmpty() }
                ?.toSet()
                .orEmpty()
            val maxSizeBytes = call.argument<Number>("maxSizeBytes")?.toLong() ?: 0L

            if (allowedExtensions.isEmpty() || maxSizeBytes <= 0L) {
                result.error("INVALID_PICKER_POLICY", "Document picker policy is invalid", null)
                return@setMethodCallHandler
            }

            pendingResult = result
            pendingRequest = PickDocumentRequest(
                allowedExtensions = allowedExtensions,
                blockedMimeTypes = blockedMimeTypes,
                maxSizeBytes = maxSizeBytes,
            )
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = "*/*"
                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false)
            }
            try {
                activity.startActivityForResult(intent, REQUEST_CODE_PICK_DOCUMENT)
            } catch (error: Exception) {
                clearPending()
                result.error("PICKER_UNAVAILABLE", error.message, null)
            }
        }
    }

    fun dispose() {
        disposed = true
        channel.setMethodCallHandler(null)
        val result = pendingResult
        clearPending()
        result?.error("ACTIVITY_DETACHED", "The SDK page was detached", null)
        executor.shutdownNow()
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE_PICK_DOCUMENT) return false
        val result = pendingResult ?: return true
        val request = pendingRequest ?: return true

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            clearPending()
            result.success(null)
            return true
        }

        val uri = data.data!!
        executor.execute {
            try {
                val picked = copySelectedDocument(uri, request)
                activity.runOnUiThread {
                    if (disposed || pendingResult !== result) {
                        val file = File(picked["path"] as String)
                        file.delete()
                        file.parentFile?.delete()
                    } else {
                        clearPending()
                        result.success(picked)
                    }
                }
            } catch (error: UnsupportedFileTypeException) {
                activity.runOnUiThread {
                    if (disposed || pendingResult !== result) return@runOnUiThread
                    clearPending()
                    result.error(
                        "UNSUPPORTED_FILE_TYPE",
                        error.message,
                        mapOf(
                            "reason" to error.reason,
                            "extension" to error.extension,
                        ),
                    )
                }
            } catch (error: FileTooLargeException) {
                activity.runOnUiThread {
                    if (disposed || pendingResult !== result) return@runOnUiThread
                    clearPending()
                    result.error("FILE_TOO_LARGE", error.message, null)
                }
            } catch (error: Exception) {
                activity.runOnUiThread {
                    if (disposed || pendingResult !== result) return@runOnUiThread
                    clearPending()
                    result.error("FILE_READ_FAILED", error.message, null)
                }
            }
        }
        return true
    }

    private fun copySelectedDocument(
        uri: Uri,
        request: PickDocumentRequest,
    ): Map<String, Any> {
        val resolver = activity.applicationContext.contentResolver
        val mimeType = resolver.getType(uri)?.trim()?.lowercase(Locale.ROOT)
        if (isMediaMimeType(mimeType)) {
            throw UnsupportedFileTypeException(
                message = "Media files are not document attachments",
                reason = "media_use_photos",
            )
        }

        val metadata = queryMetadata(uri)
        val selectedExtension = metadata.displayName
            ?.substringAfterLast('.', "")
            ?.lowercase(Locale.ROOT)
            .orEmpty()
        if (isMediaExtension(selectedExtension)) {
            throw UnsupportedFileTypeException(
                message = "Media files are not document attachments",
                reason = "media_use_photos",
                extension = selectedExtension,
            )
        }
        val fileName = resolveFileName(metadata.displayName, mimeType, request.allowedExtensions)
        val extension = fileName.substringAfterLast('.', "").lowercase(Locale.ROOT)
        if (!request.allowedExtensions.contains(extension)) {
            throw UnsupportedFileTypeException(
                message = "Selected file extension is not allowed",
                reason = "unsupported_type",
                extension = extension,
            )
        }
        if (mimeType != null && request.blockedMimeTypes.contains(mimeType)) {
            throw UnsupportedFileTypeException(
                message = "Selected file MIME conflicts with its extension",
                reason = "type_mismatch",
                extension = extension,
            )
        }
        if (metadata.sizeBytes != null && metadata.sizeBytes > request.maxSizeBytes) {
            throw FileTooLargeException("Selected file exceeds the size limit")
        }

        val targetDirectory = File(
            activity.cacheDir,
            "im_sdk/attachments/${UUID.randomUUID()}",
        )
        check(targetDirectory.mkdirs() || targetDirectory.isDirectory) {
            "Unable to create attachment cache directory"
        }
        val targetFile = File(targetDirectory, fileName)
        var copiedBytes = 0L
        try {
            resolver.openInputStream(uri)?.use { input ->
                FileOutputStream(targetFile).use { output ->
                    val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
                    while (true) {
                        check(!disposed && !Thread.currentThread().isInterrupted) { "Document import cancelled" }
                        val read = input.read(buffer)
                        if (read < 0) break
                        copiedBytes += read
                        if (copiedBytes > request.maxSizeBytes) {
                            throw FileTooLargeException("Selected file exceeds the size limit")
                        }
                        output.write(buffer, 0, read)
                    }
                    output.flush()
                }
            } ?: error("Unable to open selected file")
        } catch (error: Exception) {
            targetFile.delete()
            targetDirectory.delete()
            throw error
        }

        return mapOf(
            "path" to targetFile.absolutePath,
            "name" to fileName,
            "mimeType" to (mimeType ?: "application/octet-stream"),
            "sizeBytes" to copiedBytes,
        )
    }

    private fun queryMetadata(uri: Uri): DocumentMetadata {
        var displayName: String? = null
        var sizeBytes: Long? = null
        val cursor: Cursor? = activity.contentResolver.query(
            uri,
            arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE),
            null,
            null,
            null,
        )
        cursor?.use {
            if (it.moveToFirst()) {
                val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                val sizeIndex = it.getColumnIndex(OpenableColumns.SIZE)
                if (nameIndex >= 0 && !it.isNull(nameIndex)) {
                    displayName = it.getString(nameIndex)
                }
                if (sizeIndex >= 0 && !it.isNull(sizeIndex)) {
                    sizeBytes = it.getLong(sizeIndex)
                }
            }
        }
        return DocumentMetadata(displayName = displayName, sizeBytes = sizeBytes)
    }

    private fun resolveFileName(
        displayName: String?,
        mimeType: String?,
        allowedExtensions: Set<String>,
    ): String {
        var safeName = displayName
            ?.substringAfterLast('/')
            ?.substringAfterLast('\\')
            ?.replace("..", "_")
            ?.replace(Regex("[\\u0000-\\u001F]"), "_")
            ?.trim()
            .orEmpty()
        var extension = safeName.substringAfterLast('.', "").lowercase(Locale.ROOT)

        if (extension.isEmpty() && mimeType != null) {
            val inferred = MimeTypeMap.getSingleton()
                .getExtensionFromMimeType(mimeType)
                ?.lowercase(Locale.ROOT)
            if (inferred != null && allowedExtensions.contains(inferred)) {
                safeName = "${safeName.ifEmpty { "attachment" }}.$inferred"
                extension = inferred
            }
        }
        if (safeName.isEmpty() || extension.isEmpty()) {
            throw UnsupportedFileTypeException(
                message = "Selected file type cannot be recognized",
                reason = "unrecognized_type",
            )
        }
        return safeName
    }

    private fun clearPending() {
        pendingResult = null
        pendingRequest = null
    }

    private data class PickDocumentRequest(
        val allowedExtensions: Set<String>,
        val blockedMimeTypes: Set<String>,
        val maxSizeBytes: Long,
    )

    private data class DocumentMetadata(
        val displayName: String?,
        val sizeBytes: Long?,
    )

    private class UnsupportedFileTypeException(
        message: String,
        val reason: String,
        val extension: String = "",
    ) : Exception(message)

    private class FileTooLargeException(message: String) : Exception(message)

    private companion object {
        const val CHANNEL_NAME = "im_sdk/chat_attachment_picker"
        const val REQUEST_CODE_PICK_DOCUMENT = 0x4C50

        fun isMediaMimeType(mimeType: String?): Boolean {
            return mimeType?.startsWith("image/") == true ||
                mimeType?.startsWith("video/") == true
        }

        fun isMediaExtension(extension: String): Boolean {
            return extension in setOf(
                "jpg", "jpeg", "png", "webp", "gif", "heic", "heif",
                "mp4", "mov", "m4v", "webm", "avi", "mkv",
            )
        }
    }
}
