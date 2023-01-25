import 'method_channel.g.dart';
import 'types/types.dart';

/// Controller for a single DGis instance running on the host platform.
class DGisMapController {
  DGisMapController(
    this._api, {
    required this.mapId,
  });

  final int mapId;
  final PluginHostApi _api;

  /// Получение текущей позиции карты [CameraPosition]
  Future<CameraPosition> getCameraPosition() async {
    final dataCameraPosition = await _api.getCameraPosition();
    return CameraPosition(
      target: LatLng(
        dataCameraPosition.target.latitude,
        dataCameraPosition.target.longitude,
      ),
      bearing: dataCameraPosition.bearing,
      tilt: dataCameraPosition.tilt,
      zoom: dataCameraPosition.zoom,
    );
  }

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required CameraPosition cameraPosition,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) =>
      _api.moveCamera(cameraPosition, duration, cameraAnimationType);

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCameraToBounds({
    required LatLngBounds cameraPosition,
    double padding = 0,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) =>
      _api.moveCameraToBounds(
        cameraPosition.northeast,
        cameraPosition.southwest,
        padding,
        duration,
        cameraAnimationType,
      );
}
