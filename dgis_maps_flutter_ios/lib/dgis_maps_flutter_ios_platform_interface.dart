import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dgis_maps_flutter_ios_method_channel.dart';

abstract class DgisMapsFlutterIosPlatform extends PlatformInterface {
  /// Constructs a DgisMapsFlutterIosPlatform.
  DgisMapsFlutterIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static DgisMapsFlutterIosPlatform _instance = MethodChannelDgisMapsFlutterIos();

  /// The default instance of [DgisMapsFlutterIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelDgisMapsFlutterIos].
  static DgisMapsFlutterIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DgisMapsFlutterIosPlatform] when
  /// they register themselves.
  static set instance(DgisMapsFlutterIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
