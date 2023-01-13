#import "DgisMapsFlutterIosPlugin.h"
#if __has_include(<dgis_maps_flutter_ios/dgis_maps_flutter_ios-Swift.h>)
#import <dgis_maps_flutter_ios/dgis_maps_flutter_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dgis_maps_flutter_ios-Swift.h"
#endif

@implementation DgisMapsFlutterIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDgisMapsFlutterIosPlugin registerWithRegistrar:registrar];
}
@end
