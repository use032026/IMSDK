#import <Foundation/Foundation.h>
#import <IMSDKNative/IMSDKNative-Swift.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^IMSDKHostCredentialsCompletion)(NSDictionary<NSString *, id> *_Nullable credentials,
                                             NSError *_Nullable error);
typedef void (^IMSDKMediaServiceCredentialExchange)(NSDictionary<NSString *, id> *hostSession,
                                                    IMSDKHostCredentialsCompletion completion);

/// Optional host-side example. This file is not part of the SDK target and does
/// not install itself. Add it only to a host that links STCore and IMSDKNative.
@interface IMSDKMediaServiceClientHostSessionAdapter : NSObject <IMSDKHostSessionProvider>

/// Implement using an agreed, trusted backend contract. Never return STCore's
/// business token as an IM accessToken. nil deliberately disables credential exchange.
@property (nonatomic, copy, nullable) IMSDKMediaServiceCredentialExchange credentialExchange;

/// Main-thread result notification. Do not log raw session/credential dictionaries.
@property (nonatomic, copy, nullable) void (^onSynchronizationError)(NSError *error);

/// Start only after initialize succeeds with hostManagedAuth=true. Observes
/// existing notifications and samples state every second while the app is active.
- (void)start;

/// Removes observers and the timer. Unregister hostSessionProvider separately
/// when ending SDK use; stop does not change or log out the host account.
- (void)stop;

@end

NS_ASSUME_NONNULL_END
