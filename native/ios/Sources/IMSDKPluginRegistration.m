#import "IMSDKPluginRegistration.h"
#import <objc/message.h>

@implementation IMSDKPluginRegistration
+ (BOOL)registerGeneratedPluginsWithRegistry:(NSObject<FlutterPluginRegistry> *)registry {
  Class registrant = NSClassFromString(@"GeneratedPluginRegistrant");
  SEL selector = NSSelectorFromString(@"registerWithRegistry:");
  if (registrant == Nil || ![registrant respondsToSelector:selector]) return NO;
  ((void (*)(id, SEL, id))objc_msgSend)(registrant, selector, registry);
  return YES;
}
@end
