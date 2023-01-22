import Flutter
import UIKit

public class SwiftDgisMapsFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "dgis_maps_flutter")
    }
}
