import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/method_channel/method_channel.g.dart',
  kotlinOptions: KotlinOptions(package: 'pro.flown.dgis_maps_flutter'),
  kotlinOut: 'android/src/main/kotlin/pro/flown/dgis_maps_flutter/MethodChannel.kt',
  swiftOut: 'ios/Classes/MethodChannel.swift',
  withId: true,
))
class LatLng {
  const LatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

@HostApi()
abstract class PluginHostApi {
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
