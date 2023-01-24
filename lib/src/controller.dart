import 'method_channel/method_channel.g.dart';

/// Controller for a single DGis instance running on the host platform.
class DGisMapController {
  DGisMapController(
    this._api, {
    required this.mapId,
  });

  final int mapId;
  final PluginHostApi _api;

  /// Получение текущей позиции карты [CameraPosition]
  Future<DataCameraPosition> getCameraPosition() => _api.getCameraPosition();

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required DataCameraPosition cameraPosition,
    int? duration,
    DataCameraAnimationType cameraAnimationType = DataCameraAnimationType.def,
  }) =>
      _api.moveCamera(cameraPosition, duration, cameraAnimationType);
}
