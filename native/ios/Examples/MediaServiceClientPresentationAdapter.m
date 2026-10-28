#import "MediaServiceClientPresentationAdapter.h"
#import <IMSDKNative/IMSDKNative-Swift.h>
#import <DarkMode/STDarkModeTool.h>
#import <STCore/STBundle.h>
#import <STCore/STCountryManager.h>
#import <STCore/STNotificationName.h>
#import <UIKit/UIKit.h>

static NSString *IMSDKPresentationLocale(NSString *languageCode) {
  NSString *tag = [[languageCode ?: @"" stringByTrimmingCharactersInSet:
      NSCharacterSet.whitespaceAndNewlineCharacterSet] stringByReplacingOccurrencesOfString:@"_" withString:@"-"].lowercaseString;
  NSArray<NSString *> *parts = [tag componentsSeparatedByString:@"-"];
  NSString *language = parts.firstObject;
  if ([language isEqualToString:@"zh"]) {
    if ([parts containsObject:@"hant"]) return @"zh-TW";
    if ([parts containsObject:@"hans"]) return @"zh-CN";
    return [parts containsObject:@"tw"] || [parts containsObject:@"hk"] ||
        [parts containsObject:@"mo"] ? @"zh-TW" : @"zh-CN";
  }
  if ([@[@"en", @"ja", @"ko", @"vi"] containsObject:language]) return language;
  // The host ships more languages than this SDK. English is the explicit
  // reference-adapter fallback; never pretend the missing resources exist.
  return @"en";
}

@interface IMSDKMediaServiceClientPresentationAdapter ()
@property (nonatomic) BOOL running;
@property (nonatomic) BOOL updating;
@property (nonatomic) NSUInteger lifecycleRevision;
@property (nonatomic, strong) NSMutableArray<id> *observerTokens;
@property (nonatomic, strong, nullable) NSTimer *samplingTimer;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *desiredSettings;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *appliedSettings;
@end

@implementation IMSDKMediaServiceClientPresentationAdapter

- (instancetype)init {
  self = [super init];
  if (self) _observerTokens = [NSMutableArray array];
  return self;
}

- (void)dealloc {
  [_samplingTimer invalidate];
  for (id token in _observerTokens) [NSNotificationCenter.defaultCenter removeObserver:token];
}

- (NSDictionary<NSString *, NSString *> *)currentPresentationSettings {
  NSAssert(NSThread.isMainThread, @"Read host presentation on the main thread");
  UIUserInterfaceStyle style = [STDarkModeTool getAppDarkMode];
  NSString *theme = style == UIUserInterfaceStyleLight ? @"light" :
      style == UIUserInterfaceStyleDark ? @"dark" : @"system";
  return @{@"themeMode": theme,
           @"locale": IMSDKPresentationLocale([STBundle sharedInstance].languageCode)};
}

- (void)start {
  NSAssert(NSThread.isMainThread, @"Start host presentation on the main thread");
  if (self.running) return;
  self.running = YES;
  self.lifecycleRevision++;
  self.appliedSettings = nil;
  __weak typeof(self) weakSelf = self;
  NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
  for (NSNotificationName name in @[STDarkModelDidChangedNotification,
      STLanguageDidChangedNotification, STCountryManagerLanguagesDidChangeNotification]) {
    id token = [center addObserverForName:name object:nil queue:NSOperationQueue.mainQueue
                              usingBlock:^(NSNotification *notification) {
      [weakSelf samplePresentation];
    }];
    [self.observerTokens addObject:token];
  }
  id active = [center addObserverForName:UIApplicationDidBecomeActiveNotification object:nil
                                  queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notification) {
    [weakSelf startForegroundSampling];
    [weakSelf samplePresentation];
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
  [self samplePresentation];
}

- (void)stop {
  NSAssert(NSThread.isMainThread, @"Stop host presentation on the main thread");
  self.running = NO;
  self.lifecycleRevision++;
  [self stopForegroundSampling];
  for (id token in self.observerTokens) [NSNotificationCenter.defaultCenter removeObserver:token];
  [self.observerTokens removeAllObjects];
  self.desiredSettings = nil;
  self.appliedSettings = nil;
  self.updating = NO;
}

- (void)startForegroundSampling {
  if (!self.running || self.samplingTimer ||
      UIApplication.sharedApplication.applicationState != UIApplicationStateActive) return;
  __weak typeof(self) weakSelf = self;
  self.samplingTimer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
    [weakSelf samplePresentation];
  }];
  [NSRunLoop.mainRunLoop addTimer:self.samplingTimer forMode:NSRunLoopCommonModes];
}

- (void)stopForegroundSampling {
  [self.samplingTimer invalidate];
  self.samplingTimer = nil;
}

- (void)samplePresentation {
  if (!self.running) return;
  self.desiredSettings = [self currentPresentationSettings];
  [self submitLatestPresentation];
}

- (void)submitLatestPresentation {
  if (!self.running || self.updating || !self.desiredSettings ||
      [self.desiredSettings isEqualToDictionary:self.appliedSettings]) return;
  NSDictionary<NSString *, NSString *> *submitted = self.desiredSettings;
  NSUInteger lifecycle = self.lifecycleRevision;
  self.updating = YES;
  __weak typeof(self) weakSelf = self;
  [[IMSDK shared] updatePresentationWithSettings:submitted completion:^(id value, NSError *error) {
    void (^finish)(void) = ^{
      typeof(self) owner = weakSelf;
      if (!owner.running || owner.lifecycleRevision != lifecycle) return;
      owner.updating = NO;
      if (!error) owner.appliedSettings = submitted;
      else if (owner.onSynchronizationError) owner.onSynchronizationError(error);
      // Coalesce samples taken while a bridge operation was pending. Retry a
      // failed unchanged snapshot on the next sample, never in a tight loop.
      if (!error || ![owner.desiredSettings isEqualToDictionary:submitted]) {
        [owner submitLatestPresentation];
      }
    };
    if (NSThread.isMainThread) finish();
    else dispatch_async(dispatch_get_main_queue(), finish);
  }];
}

@end
