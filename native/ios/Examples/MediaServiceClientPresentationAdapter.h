#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Optional host-side example, excluded from the SDK's Sources target. Link
/// STCore, DarkMode and the updated IMSDKNative only if adding it to a host.
/// All methods and property changes are main-thread operations.
@interface IMSDKMediaServiceClientPresentationAdapter : NSObject

/// Safe to merge into initialize configuration before SDK startup. Reads only
/// the host's theme preference and effective language; no account is required.
- (NSDictionary<NSString *, NSString *> *)currentPresentationSettings;

/// Call after SDK initialize succeeds. Does not initialize/inject the SDK,
/// authenticate, fetch credentials, or change the host's theme/language.
- (void)start;

/// Removes this adapter's observers/timer. A bridge update already submitted
/// may complete; its callback cannot restart this adapter.
- (void)stop;

/// Reports only the SDK's result. Do not log raw error details.
@property (nonatomic, copy, nullable) void (^onSynchronizationError)(NSError *error);

@end

NS_ASSUME_NONNULL_END
