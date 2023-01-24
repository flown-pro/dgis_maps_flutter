import 'method_channel/method_channel.g.dart';

/// Controller for a single DGis instance running on the host platform.
class DGisMapController {
  DGisMapController({
    required this.mapId,
  });

  final int mapId;
  late final PluginHostApi api = PluginHostApi(id: mapId);

  /// Добавление маркеров [Marker] на карту
  Future<void> addMarkers(List<Marker> markers) => api.updateMarkers(
        MarkerUpdates(
          toRemove: [],
          toAdd: markers,
        ),
      );

  /// Удаление маркеров [Marker] с карты
  Future<void> removeMarkers(List<Marker> markers) => api.updateMarkers(
        MarkerUpdates(
          toRemove: markers,
          toAdd: [],
        ),
      );

  /// Получение текущей позиции карты [CameraPosition]
  Future<CameraPosition> getCameraPosition() => api.getCameraPosition();

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required CameraPosition cameraPosition,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) =>
      api.moveCamera(cameraPosition, duration, cameraAnimationType);
}
