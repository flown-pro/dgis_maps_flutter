import Flutter
import UIKit

public class SwiftDgisMapsFlutterIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = DGisNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "dgis_maps_flutter")
  }
}
