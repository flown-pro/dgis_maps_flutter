import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dgis_maps_flutter_android_platform_interface.dart';

/// An implementation of [DgisMapsFlutterAndroidPlatform] that uses method channels.
class MethodChannelDgisMapsFlutterAndroid extends DgisMapsFlutterAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dgis_maps_flutter_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
