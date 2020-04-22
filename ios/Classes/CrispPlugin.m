#import "CrispPlugin.h"
#if __has_include(<crisp/crisp-Swift.h>)
#import <crisp/crisp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "crisp-Swift.h"
#endif

@implementation CrispPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCrispPlugin registerWithRegistrar:registrar];
}
@end
