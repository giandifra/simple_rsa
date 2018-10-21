#import "SimpleRsaPlugin.h"
#import <simple_rsa/simple_rsa-Swift.h>

@implementation SimpleRsaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleRsaPlugin registerWithRegistrar:registrar];
}
@end
