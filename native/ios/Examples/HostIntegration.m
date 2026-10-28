#import <UIKit/UIKit.h>
#import <IMSDKNative/IMSDKNative-Swift.h>

@interface IMSDKObjectiveCExample : NSObject
+ (void)openDirectFrom:(UIViewController *)presenter
        configuration:(NSDictionary<NSString *, id> *)configuration
          credentials:(NSDictionary<NSString *, id> *)credentials
               target:(NSDictionary<NSString *, id> *)target
           completion:(void (^)(id _Nullable, NSError * _Nullable))completion;
@end

@implementation IMSDKObjectiveCExample
+ (void)openDirectFrom:(UIViewController *)presenter
        configuration:(NSDictionary<NSString *, id> *)configuration
          credentials:(NSDictionary<NSString *, id> *)credentials
               target:(NSDictionary<NSString *, id> *)target
           completion:(void (^)(id _Nullable, NSError * _Nullable))completion {
  [[IMSDK shared] initializeWithConfiguration:configuration completion:^(id value, NSError *error) {
    if (error != nil) { completion(nil, error); return; }
    [[IMSDK shared] authenticateWithCredentials:credentials completion:^(id value, NSError *error) {
      if (error != nil) { completion(nil, error); return; }
      [[IMSDK shared] openDirectConversationFromViewController:presenter
                                                      target:target completion:completion];
    }];
  }];
}
@end
