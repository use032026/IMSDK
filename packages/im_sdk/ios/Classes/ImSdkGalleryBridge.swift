import Flutter
import Photos

final class ImSdkGalleryBridge {
  private static let channelName = "im_sdk/gallery"

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "saveMedia" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.isEmpty,
        let isVideo = arguments["isVideo"] as? Bool
      else {
        result(FlutterError(
          code: "INVALID_MEDIA_ARGUMENTS",
          message: "A media path and type are required",
          details: nil
        ))
        return
      }
      requestAuthorizationAndSave(
        fileURL: URL(fileURLWithPath: path),
        isVideo: isVideo,
        result: result
      )
    }
  }

  private static func requestAuthorizationAndSave(
    fileURL: URL,
    isVideo: Bool,
    result: @escaping FlutterResult
  ) {
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      result(FlutterError(
        code: "MEDIA_FILE_MISSING",
        message: "The media file does not exist",
        details: nil
      ))
      return
    }

    let handleAuthorization: (PHAuthorizationStatus) -> Void = { status in
      switch status {
      case .authorized, .limited:
        save(fileURL: fileURL, isVideo: isVideo, result: result)
      case .denied, .restricted:
        complete(result, error: FlutterError(
          code: "MEDIA_PERMISSION_DENIED",
          message: "Photo library permission is required to save media",
          details: nil
        ))
      case .notDetermined:
        complete(result, error: FlutterError(
          code: "MEDIA_PERMISSION_UNDETERMINED",
          message: "Photo library authorization did not complete",
          details: nil
        ))
      @unknown default:
        complete(result, error: FlutterError(
          code: "MEDIA_PERMISSION_UNKNOWN",
          message: "Unknown photo library authorization status",
          details: nil
        ))
      }
    }

    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
      handleAuthorization(status)
    }
  }

  private static func save(
    fileURL: URL,
    isVideo: Bool,
    result: @escaping FlutterResult
  ) {
    PHPhotoLibrary.shared().performChanges({
      if isVideo {
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
      } else {
        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
      }
    }) { success, error in
      if success {
        complete(result, value: nil)
      } else {
        complete(result, error: FlutterError(
          code: "SAVE_MEDIA_FAILED",
          message: error?.localizedDescription ?? "Unable to save media",
          details: nil
        ))
      }
    }
  }

  private static func complete(
    _ result: @escaping FlutterResult,
    value: Any? = nil,
    error: FlutterError? = nil
  ) {
    DispatchQueue.main.async {
      result(error ?? value)
    }
  }
}
