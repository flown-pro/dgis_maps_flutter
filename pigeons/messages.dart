// ignore_for_file: unused_element

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/method_channel/method_channel.g.dart',
  kotlinOptions: KotlinOptions(package: 'pro.flown.dgis_maps_flutter'),
  kotlinOut:
      'android/src/main/kotlin/pro/flown/dgis_maps_flutter/MethodChannel.kt',
  swiftOut: 'ios/Classes/MethodChannel.swift',
  withId: true,
))
class CreationParams {
  const CreationParams({
    required this.position,
    this.zoom = 0,
  });
  final LatLng position;
  final double zoom;
}

class LatLng {
  const LatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

@HostApi()
abstract class PluginHostApi {
  void _stub(CreationParams p1);
  @async
  LatLng asy(LatLng msg);
  LatLng sy(LatLng msg);
}

@FlutterApi()
abstract class PluginFlutterApi {
  @async
  LatLng asy(LatLng msg);
  LatLng sy(LatLng msg);
}

@FlutterApi()
abstract class _Stub {
  CreationParams c1();
}
