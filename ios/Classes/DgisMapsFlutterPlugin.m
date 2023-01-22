#import "DgisMapsFlutterPlugin.h"
#if __has_include(<dgis_maps_flutter/dgis_maps_flutter-Swift.h>)
#import <dgis_maps_flutter/dgis_maps_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dgis_maps_flutter-Swift.h"
#endif

@implementation DgisMapsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDgisMapsFlutterPlugin registerWithRegistrar:registrar];
}
@end
