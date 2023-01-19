import 'package:dgis_maps_flutter_platform_interface/src/method_channel/dgis_maps_flutter_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/types.dart';

abstract class DGisMapsFlutterPlatformInterface extends PlatformInterface {
  DGisMapsFlutterPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static DGisMapsFlutterPlatformInterface _instance =
      DGisMapsFlutterMethodChannel();

  /// Инстанс [DGisMapsFlutterPlatformInterface],
  /// по умолчанию [DGisMapsFlutterMethodChannel]
  static DGisMapsFlutterPlatformInterface get instance => _instance;

  static set instance(DGisMapsFlutterPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> init(int mapId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    required int mapId,
  }) {
    throw UnimplementedError('updateMarkers() has not been implemented.');
  }

  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) {
    throw UnimplementedError('animateCamera() has not been implemented.');
  }

  Future<void> moveCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) {
    throw UnimplementedError('moveCamera() has not been implemented.');
  }

  Widget buildView(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required CameraPosition initialPosition,
    MapObjects mapObjects = const MapObjects(),
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}
