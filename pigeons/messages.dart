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

/// Состояние камеры
/// https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraState
enum CameraState {
  /// Камера управляется пользователем.
  busy,

  /// Eсть активный перелёт.
  fly,

  /// Камера в режиме слежения за позицией.
  followPosition,

  /// Камера не управляется пользователем и нет активных перелётов.
  free
}

/// Тип анимации при перемещении камеры
/// https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraAnimationType
enum CameraAnimationType {
  /// Тип перелёта выбирается в зависимости от расстояния между начальной и конечной позициями
  def,

  /// Линейное изменение параметров позиции камеры
  linear,

  /// Zoom изменяется таким образом, чтобы постараться в какой-то момент перелёта отобразить начальную и конечную позиции.
  /// Позиции могут быть не отображены, если текущие ограничения (см. ICamera::zoom_restrictions()) не позволяют установить столь малый zoom.
  showBothPositions
}

/// Позиция камеры
class CameraPosition {
  const CameraPosition({
    required this.target,
    this.bearing = 0.0,
    this.tilt = 0.0,
    this.zoom = 0.0,
  });

  /// Азимут камеры в градусах
  final double bearing;

  /// Центр камеры
  final LatLng target;

  /// Угол наклона камеры (в градусах)
  final double tilt;

  /// Зум камеры
  final double zoom;
}

class MarkerId {
  const MarkerId(this.value);
  final String value;
}

class MarkerUpdates {
  MarkerUpdates({
    this.toRemove = const [],
    this.toChange = const [],
    this.toAdd = const [],
  });
  final List<Marker?> toRemove;
  final List<Marker?> toChange;
  final List<Marker?> toAdd;
}

@HostApi()
abstract class PluginHostApi {
  /// Получение текущей позиции камеры
  ///
  /// Возвращает [CameraPosition]
  /// Позицию камеры в текущий момент времени
  @async
  CameraPosition getCameraPosition();

  /// Перемещение камеры к заданной позиции [CameraPosition]
  /// [duration] - длительность анимации в миллисекундах,
  /// если не указана, используется нативное значение
  /// [cameraAnimationType] - тип анимации
  @async
  void moveCamera(
    CameraPosition cameraPosition,
    int? duration,
    CameraAnimationType cameraAnimationType,
  );

  /// Обновление маркеров
  ///
  /// [markerUpdates] - объект с информацией об обновлении маркеров
  void updateMarkers(MarkerUpdates markerUpdates);
}

@FlutterApi()
abstract class PluginFlutterApi {
  /// Коллбэк на изменение состояния камеры
  /// [cameraState] - индекс в перечислении [CameraState]
  /// TODO(kit): Изменить на enum после фикса
  /// https://github.com/flutter/flutter/issues/87307
  void onCameraStateChanged(CameraState cameraState);
}

/// Класс, используемый для генерации моделей,
/// которые не задекларированы в интерфейсе
@FlutterApi()
abstract class _Stub {
  CreationParams c1();
}
