#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// Resolves the add-to-app module's generated registry without requiring a host AppDelegate base class.
@interface IMSDKPluginRegistration : NSObject
+ (BOOL)registerGeneratedPluginsWithRegistry:(NSObject<FlutterPluginRegistry> *)registry
    NS_SWIFT_NAME(registerGeneratedPlugins(with:));
@end

NS_ASSUME_NONNULL_END
