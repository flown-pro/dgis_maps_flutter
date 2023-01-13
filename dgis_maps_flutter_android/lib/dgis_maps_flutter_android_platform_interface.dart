import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dgis_maps_flutter_android_method_channel.dart';

abstract class DgisMapsFlutterAndroidPlatform extends PlatformInterface {
  /// Constructs a DgisMapsFlutterAndroidPlatform.
  DgisMapsFlutterAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static DgisMapsFlutterAndroidPlatform _instance = MethodChannelDgisMapsFlutterAndroid();

  /// The default instance of [DgisMapsFlutterAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelDgisMapsFlutterAndroid].
  static DgisMapsFlutterAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DgisMapsFlutterAndroidPlatform] when
  /// they register themselves.
  static set instance(DgisMapsFlutterAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
