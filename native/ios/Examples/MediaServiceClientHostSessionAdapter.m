#import "MediaServiceClientHostSessionAdapter.h"
#import <CommonCrypto/CommonDigest.h>
#import <STCore/STLoginManager.h>
#import <STCore/STLoginInfoModel.h>
#import <STCore/STNotificationName.h>
#import <STCore/STSDKUtility.h>
#import <UIKit/UIKit.h>

static NSError *IMSDKHostAdapterError(NSString *code) {
  return [NSError errorWithDomain:@"IMSDKMediaServiceClientHostSession"
                            code:1 userInfo:@{@"code": code}];
}

static void IMSDKHostAdapterOnMain(dispatch_block_t work) {
  if (NSThread.isMainThread) work();
  else dispatch_async(dispatch_get_main_queue(), work);
}

static BOOL IMSDKHostSessionsEqual(NSDictionary *first, NSDictionary *second) {
  return first == second || (first != nil && [first isEqualToDictionary:second]);
}

@interface IMSDKMediaServiceClientHostSessionAdapter ()
@property (nonatomic) BOOL running;
@property (nonatomic, strong, nullable) NSTimer *samplingTimer;
@property (nonatomic, strong) NSMutableArray<id> *observerTokens;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *lastObservedSession;
@end

@implementation IMSDKMediaServiceClientHostSessionAdapter

- (instancetype)init {
  self = [super init];
  if (self) _observerTokens = [NSMutableArray array];
  return self;
}

- (void)dealloc {
  [_samplingTimer invalidate];
  for (id token in _observerTokens) [NSNotificationCenter.defaultCenter removeObserver:token];
}

/// Main-thread snapshot only. STLoginManager.isLogin excludes anonymous users.
- (nullable NSDictionary<NSString *, id> *)readSessionWithError:(NSError **)error {
  if (![STLoginManager isLogin]) return nil;
  STLoginInfoModel *model = [STLoginManager sharedLoginManager].infoModel;
  NSString *userId = [model.userId copy];
  NSString *package = [STSDKUtility requestHeaderPkgName];
  NSString *token = [model.token copy];
  NSString *refreshToken = [model.refreshToken copy] ?: @"";
  if (userId.length == 0 || package.length == 0 || token.length == 0) {
    if (error) *error = IMSDKHostAdapterError(@"HOST_SESSION_UNAVAILABLE");
    return nil;
  }
  // Length-framed JSON avoids separator collisions. Only the digest leaves
  // this method; neither the business token nor its refresh token is returned.
  NSData *input = [NSJSONSerialization dataWithJSONObject:@[package, userId, token, refreshToken]
                                                options:0 error:nil];
  if (!input || input.length > UINT32_MAX) {
    if (error) *error = IMSDKHostAdapterError(@"HOST_SESSION_UNAVAILABLE");
    return nil;
  }
  unsigned char digest[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256(input.bytes, (CC_LONG)input.length, digest);
  NSMutableString *sessionId = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
  for (NSUInteger index = 0; index < CC_SHA256_DIGEST_LENGTH; index++) {
    [sessionId appendFormat:@"%02x", digest[index]];
  }
  return @{@"hostUserId": [NSString stringWithFormat:@"%@|%@", package, userId],
           @"sessionId": sessionId};
}

- (void)imSdkReadHostSessionWithCompletion:(void (^)(NSDictionary<NSString *, id> *_Nullable,
                                                   NSError *_Nullable))completion {
  IMSDKHostAdapterOnMain(^{
    NSError *error = nil;
    NSDictionary *session = [self readSessionWithError:&error];
    completion(session, error);
  });
}

- (void)imSdkFetchCredentialsForHostSession:(NSDictionary<NSString *, id> *)hostSession
                              completion:(IMSDKHostCredentialsCompletion)completion {
  NSDictionary *expectedSession = [hostSession copy];
  IMSDKHostAdapterOnMain(^{
    NSError *readError = nil;
    NSDictionary *current = [self readSessionWithError:&readError];
    if (readError || !IMSDKHostSessionsEqual(current, expectedSession)) {
      completion(nil, IMSDKHostAdapterError(@"HOST_SESSION_CHANGED"));
      return;
    }
    IMSDKMediaServiceCredentialExchange exchange = self.credentialExchange;
    if (!exchange) {
      completion(nil, IMSDKHostAdapterError(@"HOST_CREDENTIALS_UNAVAILABLE"));
      return;
    }
    __weak typeof(self) weakSelf = self;
    __block BOOL completed = NO;
    exchange(expectedSession, ^(NSDictionary *credentials, NSError *error) {
      IMSDKHostAdapterOnMain(^{
        if (completed) return;
        completed = YES;
        typeof(self) owner = weakSelf;
        NSError *latestError = nil;
        NSDictionary *latest = [owner readSessionWithError:&latestError];
        if (!owner || latestError || !IMSDKHostSessionsEqual(latest, expectedSession)) {
          completion(nil, IMSDKHostAdapterError(@"HOST_SESSION_CHANGED"));
        } else if (error) {
          completion(nil, error);
        } else if (![credentials isKindOfClass:NSDictionary.class]) {
          completion(nil, IMSDKHostAdapterError(@"HOST_CREDENTIALS_UNAVAILABLE"));
        } else {
          // SDK independently validates the full IM credential fields and identity.
          completion(credentials, nil);
        }
      });
    });
  });
}

- (void)start {
  IMSDKHostAdapterOnMain(^{
    if (self.running) return;
    self.running = YES;
    __weak typeof(self) weakSelf = self;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    NSArray<NSNotificationName> *identityEvents = @[
      STLoginPreSuccessNotification, STLoginSuccessNotification,
      STAnonymousLoginSuccessNotification, STAuthRefreshSuccessNotification,
      STLogoutSuccessNotification
    ];
    for (NSNotificationName name in identityEvents) {
      id observer = [center addObserverForName:name object:nil queue:NSOperationQueue.mainQueue
                                   usingBlock:^(NSNotification *notification) {
        [weakSelf sampleAndNotify:NO];
      }];
      [self.observerTokens addObject:observer];
    }
    id active = [center addObserverForName:UIApplicationDidBecomeActiveNotification object:nil
                                    queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notification) {
      [weakSelf startForegroundSampling];
      [weakSelf sampleAndNotify:YES];
    }];
    id inactive = [center addObserverForName:UIApplicationWillResignActiveNotification object:nil
                                      queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notification) {
      [weakSelf stopForegroundSampling];
    }];
    id background = [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil
                                        queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notification) {
      [weakSelf stopForegroundSampling];
    }];
    [self.observerTokens addObjectsFromArray:@[active, inactive, background]];
    [self startForegroundSampling];
    [self sampleAndNotify:YES];
  });
}

- (void)stop {
  IMSDKHostAdapterOnMain(^{
    self.running = NO;
    [self stopForegroundSampling];
    for (id token in self.observerTokens) [NSNotificationCenter.defaultCenter removeObserver:token];
    [self.observerTokens removeAllObjects];
    self.lastObservedSession = nil;
  });
}

- (void)startForegroundSampling {
  if (!self.running || self.samplingTimer ||
      UIApplication.sharedApplication.applicationState != UIApplicationStateActive) return;
  __weak typeof(self) weakSelf = self;
  self.samplingTimer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
    [weakSelf sampleAndNotify:NO];
  }];
  [NSRunLoop.mainRunLoop addTimer:self.samplingTimer forMode:NSRunLoopCommonModes];
}

- (void)stopForegroundSampling {
  [self.samplingTimer invalidate];
  self.samplingTimer = nil;
}

- (void)sampleAndNotify:(BOOL)force {
  if (!self.running) return;
  NSError *error = nil;
  NSDictionary *session = [self readSessionWithError:&error];
  if (error) {
    if (self.onSynchronizationError) self.onSynchronizationError(error);
    // Tell the SDK to re-read and apply its fail-closed provider-error policy.
  } else if (!force && IMSDKHostSessionsEqual(session, self.lastObservedSession)) {
    return;
  }
  self.lastObservedSession = session;
  __weak typeof(self) weakSelf = self;
  [[IMSDK shared] notifyHostSessionChangedWithCompletion:^(id value, NSError *failure) {
    typeof(self) owner = weakSelf;
    if (failure && owner.onSynchronizationError) owner.onSynchronizationError(failure);
  }];
}

@end
