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
  Future<CameraPosition> getCameraPosition() => _api.getCameraPosition();

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required CameraPosition cameraPosition,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) =>
      _api.moveCamera(cameraPosition, duration, cameraAnimationType);
}
