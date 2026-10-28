#import <UIKit/UIKit.h>
#import <IMSDKNative/IMSDKNative-Swift.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^IMHostCompletion)(id _Nullable value, NSError * _Nullable error);

// 宿主须以 strong 属性持有本对象；SDK 对 eventListener 的引用为 weak。
// 在主线程创建和调用；configuration 由宿主环境与真实隐私同意结果构造。
@interface ObjCIMIntegration : NSObject <IMSDKEventListener>
@property(nonatomic, copy, nullable) void (^onEvent)(NSDictionary<NSString *, id> *payload);
- (void)openMessengerFrom:(UIViewController *)presenter
           configuration:(NSDictionary<NSString *, id> *)configuration
              completion:(IMHostCompletion)completion;
- (void)authenticateAndOpenDirectFrom:(UIViewController *)presenter
                       configuration:(NSDictionary<NSString *, id> *)configuration
                         credentials:(NSDictionary<NSString *, id> *)credentials
                              target:(NSDictionary<NSString *, id> *)target
                          completion:(IMHostCompletion)completion;
- (void)openCustomerServiceFrom:(UIViewController *)presenter
                        target:(NSDictionary<NSString *, id> *)target
                    completion:(IMHostCompletion)completion;
- (void)logoutWithCompletion:(IMHostCompletion)completion;
- (void)shutdownWithCompletion:(IMHostCompletion)completion;
@end

@implementation ObjCIMIntegration

- (instancetype)init {
    self = [super init];
    if (self) {
        [IMSDK shared].eventListener = self;
        [IMSDK shared].presentationMode = IMSDKPresentationModeAutomatic;
    }
    return self;
}

// 推荐入口：由 SDK 页面完成账号密码登录，进入单聊 / 群聊会话列表。
- (void)openMessengerFrom:(UIViewController *)presenter
           configuration:(NSDictionary<NSString *, id> *)configuration
              completion:(IMHostCompletion)completion {
    [IMSDK shared].eventListener = self;
    [[IMSDK shared] initializeWithConfiguration:configuration completion:^(id value, NSError *error) {
        if (error != nil) { completion(nil, error); return; }
        [[IMSDK shared] openMessengerFromViewController:presenter completion:completion];
    }];
}

// 可选：仅接受可信后端的 IM 凭证及已授权的真实 conversationId。
- (void)authenticateAndOpenDirectFrom:(UIViewController *)presenter
                       configuration:(NSDictionary<NSString *, id> *)configuration
                         credentials:(NSDictionary<NSString *, id> *)credentials
                              target:(NSDictionary<NSString *, id> *)target
                          completion:(IMHostCompletion)completion {
    [IMSDK shared].eventListener = self;
    [[IMSDK shared] initializeWithConfiguration:configuration completion:^(id value, NSError *error) {
        if (error != nil) { completion(nil, error); return; }
        [[IMSDK shared] authenticateWithCredentials:credentials completion:^(id value, NSError *error) {
            if (error != nil) { completion(nil, error); return; }
            [[IMSDK shared] openDirectConversationFromViewController:presenter
                                                             target:target
                                                         completion:completion];
        }];
    }];
}

// 先 initialize 并认证。queued 是排队成功，不代表客服已接入。
// 当前企业 target: @{ @"entry": @"currentTenant" }；品牌入口需真实服务账号实体 ID。
- (void)openCustomerServiceFrom:(UIViewController *)presenter
                        target:(NSDictionary<NSString *, id> *)target
                    completion:(IMHostCompletion)completion {
    [IMSDK shared].eventListener = self;
    [[IMSDK shared] openCustomerServiceFromViewController:presenter target:target completion:completion];
}

// 宿主账号退出时协调调用；不会代替服务端 token 撤销。
- (void)logoutWithCompletion:(IMHostCompletion)completion {
    [[IMSDK shared] logoutWithCompletion:completion];
}

// 完成后如需再次使用，重新 initialize。
- (void)shutdownWithCompletion:(IMHostCompletion)completion {
    [[IMSDK shared] shutdownWithCompletion:completion];
}

- (void)imSdkDidReceiveEvent:(NSDictionary<NSString *, id> *)payload {
    // 主线程。按 type 处理；连接事件字段为 status。不要打印完整 payload / 凭证。
    // onEvent 闭包需避免强引用循环。
    if (self.onEvent != nil) { self.onEvent(payload); }
}

@end

NS_ASSUME_NONNULL_END

// 宿主控制器以 strong 属性持有 ObjCIMIntegration。
// 取得隐私同意后填入业务环境及 privacyConsentGranted=@YES，再从可见控制器打开。
