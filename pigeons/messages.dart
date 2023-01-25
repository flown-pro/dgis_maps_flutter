
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/method_channel.g.dart',
  kotlinOptions: KotlinOptions(package: 'pro.flown.dgis_maps_flutter'),
  kotlinOut:
      'android/src/main/kotlin/pro/flown/dgis_maps_flutter/MethodChannel.kt',
  swiftOut: 'ios/Classes/MethodChannel.swift',
  withId: true,
))
class DataCreationParams {
  const DataCreationParams({
    required this.position,
    this.zoom = 0,
  });
  final DataLatLng position;
  final double zoom;
}

// TODO(kit): Documentation
class DataLatLng {
  const DataLatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

// TODO(kit): Documentation
class DataMarkerBitmap {
  const DataMarkerBitmap(
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

// TODO(kit): Documentation
class DataMarker {
  const DataMarker({
    required this.markerId,
    required this.position,
    this.infoText,
    this.bitmap,
  });

  /// Уникальный идентификатор маркера
  final DataMapObjectId markerId;

  /// Изображение маркера
  /// Используется нативная реализация дефолтного маркера,
  /// если null
  final DataMarkerBitmap? bitmap;

  /// Позиция маркера
  final DataLatLng position;

  /// Текст под маркером
  final String? infoText;
}

class DataCameraStateValue {
  DataCameraStateValue(this.value);
  DataCameraState value;
}

/// Состояние камеры
/// https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraState
enum DataCameraState {
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
enum DataCameraAnimationType {
  /// Тип перелёта выбирается в зависимости от расстояния между начальной и конечной позициями
  def,

  /// Линейное изменение параметров позиции камеры
  linear,

  /// Zoom изменяется таким образом, чтобы постараться в какой-то момент перелёта отобразить начальную и конечную позиции.
  /// Позиции могут быть не отображены, если текущие ограничения (см. ICamera::zoom_restrictions()) не позволяют установить столь малый zoom.
  showBothPositions
}

/// Позиция камеры
class DataCameraPosition {
  const DataCameraPosition({
    required this.target,
    this.bearing = 0.0,
    this.tilt = 0.0,
    this.zoom = 0.0,
  });

  /// Азимут камеры в градусах
  final double bearing;

  /// Центр камеры
  final DataLatLng target;

  /// Угол наклона камеры (в градусах)
  final double tilt;

  /// Зум камеры
  final double zoom;
}

// TODO(kit): Documentation
class DataMapObjectId {
  const DataMapObjectId(this.value);
  final String value;
}

// TODO(kit): Documentation
class DataMarkerUpdates {
  DataMarkerUpdates({
    this.toRemove = const [],
    this.toAdd = const [],
  });
  final List<DataMarker?> toRemove;
  final List<DataMarker?> toAdd;
}

// TODO(kit): Documentation
class DataPolylineUpdates {
  DataPolylineUpdates({
    this.toRemove = const [],
    this.toAdd = const [],
  });
  final List<DataPolyline?> toRemove;
  final List<DataPolyline?> toAdd;
}

// TODO(kit): Documentation
class DataPolyline {
  DataPolyline(
      this.points, this.width, this.color, this.erasedPart, this.polylineId);

  /// Уникальный идентификатор маркера
  final DataMapObjectId polylineId;
  final List<DataLatLng?> points;
  final double width;
  final int color;
  final double erasedPart;
}

@HostApi()
abstract class PluginHostApi {
  /// Получение текущей позиции камеры
  ///
  /// Возвращает [DataCameraPosition]
  /// Позицию камеры в текущий момент времени
  DataCameraPosition getCameraPosition();

  /// Перемещение камеры к заданной позиции [CameraPosition]
  /// [duration] - длительность анимации в миллисекундах,
  /// если не указана, используется нативное значение
  /// [cameraAnimationType] - тип анимации
  @async
  void moveCamera(
    DataCameraPosition cameraPosition,
    int? duration,
    DataCameraAnimationType cameraAnimationType,
  );
  /// Перемещение камеры к области из двух точек
  @async
  void moveCameraToBounds(
    DataLatLng firstPoint,
    DataLatLng fsecondPoint,
    double padding,
    int? duration,
    DataCameraAnimationType cameraAnimationType,
  );
  /// Обновление маркеров
  ///
  /// [markerUpdates] - объект с информацией об обновлении маркеров
  void updateMarkers(DataMarkerUpdates markerUpdates);

  /// Обновление полилайнов
  ///
  /// [polylineUpdates] - объект с информацией об обновлении полилайнов
  void updatePolylines(DataPolylineUpdates polylineUpdates);

  /// Изменение слоя с маркером своего местоположения
  ///
  /// [isVisible] - true, добавляет слой со своей локацией, если его еще нет на карте
  /// false - убирает слой с карты, если он етсь на карте
  void changeMyLocationLayerState(bool isVisible);
}

@FlutterApi()
abstract class PluginFlutterApi {
  /// Коллбэк на изменение состояния камеры
  /// [cameraState] - индекс в перечислении [CameraState]
  void onCameraStateChanged(DataCameraStateValue cameraState);
}

/// Класс, используемый для генерации моделей,
/// которые не задекларированы в интерфейсе
@FlutterApi()
abstract class _Stub {
  DataCreationParams c1();
}
