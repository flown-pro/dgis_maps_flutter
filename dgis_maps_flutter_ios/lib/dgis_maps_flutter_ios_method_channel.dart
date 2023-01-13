import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dgis_maps_flutter_ios_platform_interface.dart';

/// An implementation of [DgisMapsFlutterIosPlatform] that uses method channels.
class MethodChannelDgisMapsFlutterIos extends DgisMapsFlutterIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dgis_maps_flutter_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
