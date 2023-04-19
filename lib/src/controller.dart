import 'dart:async';

import 'method_channel.g.dart';
import 'types/types.dart';

/// Controller for a single DGis instance running on the host platform.
class DGisMapController {
  DGisMapController(
    this._api,
    this._completer, {
    required this.mapId,
  });

  final int mapId;
  final PluginHostApi _api;
  final Completer<void> _completer;

  /// Получение текущей позиции карты [CameraPosition]
  Future<CameraPosition> getCameraPosition() async {
    await _completer.future;
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

  /// Получение текущей позиции карты [CameraPosition]
  Future<void> createRoute(GeoPoint startPoint, GeoPoint endPoint) async {
    await _completer.future;
    await _api.createRoute(startPoint, endPoint);
  }

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCamera({
    required CameraPosition cameraPosition,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) async {
    await _completer.future;
    return _api.moveCamera(cameraPosition, duration, cameraAnimationType);
  }

  Future<LatLngBounds> getVisibleRegion() async {
    await _completer.future;
    final bounds = await _api.getVisibleArea();
    return LatLngBounds(
      southwest: LatLng(bounds.southwest.latitude, bounds.southwest.longitude),
      northeast: LatLng(bounds.northeast.latitude, bounds.northeast.longitude),
    );
  }

  /// Переход камеры к выбранной точке [CameraPosition]
  Future<void> moveCameraToBounds({
    required LatLngBounds cameraPosition,
    MapPadding? padding,
    int? duration,
    CameraAnimationType cameraAnimationType = CameraAnimationType.def,
  }) async {
    await _completer.future;
    return _api.moveCameraToBounds(
      cameraPosition.northeast,
      cameraPosition.southwest,
      padding ?? MapPadding.zero,
      duration,
      cameraAnimationType,
    );
  }
}
