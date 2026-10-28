import Flutter
import Foundation

/// Only registers SDK-owned channels; the host keeps its AppDelegate and notification delegate.
public final class ImSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    ImSdkGalleryBridge.register(messenger: registrar.messenger())
    let channel = FlutterMethodChannel(
      name: "im_sdk/diagnostics_storage", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "prepare" else {
        result(FlutterMethodNotImplemented)
        return
      }
      do {
        let support = try FileManager.default.url(
          for: .applicationSupportDirectory, in: .userDomainMask,
          appropriateFor: nil, create: true)
        var root = support.appendingPathComponent("im_sdk/diagnostics/v1", isDirectory: true)
        try FileManager.default.createDirectory(
          at: root, withIntermediateDirectories: true,
          attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try root.setResourceValues(values)
        result(root.path)
      } catch {
        result(FlutterError(code: "DIAGNOSTICS_STORAGE_UNAVAILABLE",
                            message: "Unable to prepare SDK diagnostics", details: nil))
      }
    }
  }
}
