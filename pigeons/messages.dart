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

class MarkerBitmap {
  const MarkerBitmap(
    this.bytes, {
    this.width,
    this.height,
  });

  /// Байты изображения
  final Uint8List bytes;

  /// Ширина изображения,
  /// если null, используется значение по умолчанию,
  /// которое зависит от нативной реализации
  final double? width;

  /// Высота изображения,
  /// если null, используется значение по умолчанию,
  /// которое зависит от нативной реализации
  final double? height;
}

class Marker {
  const Marker({
    required this.markerId,
    required this.position,
    this.infoText,
    this.bitmap,
  });

  /// Уникальный идентификатор маркера
  final MarkerId markerId;

  /// Изображение маркера
  /// Используется нативная реализация дефолтного маркера,
  /// если null
  final MarkerBitmap? bitmap;

  /// Позиция маркера
  final LatLng position;

  /// Текст под маркером
  final String? infoText;
}

class MarkerId {
  const MarkerId(this.value);
  final String value;
}

class MarkerUpdates {
  MarkerUpdates({
    this.toRemove = const {},
    this.toChange = const {},
    this.toAdd = const {},
  });
  final Set<Marker> toRemove;
  final Set<Marker> toChange;
  final Set<Marker> toAdd;
}

@HostApi()
abstract class PluginHostApi {
  void _stub(CreationParams p1);
  @async
  LatLng asy(LatLng msg);

  @async
  Marker m(Marker msg);
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
