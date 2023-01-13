import Flutter
import UIKit

public class SwiftDgisMapsFlutterIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dgis_maps_flutter_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftDgisMapsFlutterIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
