import 'method_channel/method_channel.g.dart';

/// Controller for a single DGis instance running on the host platform.
class DGisMapController {
  DGisMapController({
    required this.mapId,
  });

  final int mapId;
  late final PluginHostApi api = PluginHostApi(id: mapId);

  /// Добавление маркеров [Marker] на карту
  Future<void> addMarkers(List<DataMarker> markers) => api.updateMarkers(
        DataMarkerUpdates(
          toRemove: [],
          toAdd: markers,
        ),
      );

  /// Удаление маркеров [Marker] с карты
  Future<void> removeMarkers(List<DataMarker> markers) => api.updateMarkers(
        DataMarkerUpdates(
          toRemove: markers,
          toAdd: [],
        ),
      );

  /// Получение текущей позиции карты [CameraPosition]
  Future<DataCameraPosition> getCameraPosition() => api.getCameraPosition();

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required DataCameraPosition cameraPosition,
    int? duration,
    DataCameraAnimationType cameraAnimationType = DataCameraAnimationType.def,
  }) =>
      api.moveCamera(cameraPosition, duration, cameraAnimationType);
}
