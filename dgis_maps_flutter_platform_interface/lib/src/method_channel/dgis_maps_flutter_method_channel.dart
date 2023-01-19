import 'package:dgis_maps_flutter_platform_interface/src/platform_interface/dgis_maps_flutter_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../types/types.dart';
import '../types/utils/marker.dart';

class UnknownMapIDError extends Error {
  /// Creates an assertion error with the provided [mapId] and optional
  /// [message].
  UnknownMapIDError(this.mapId, [this.message]);

  /// The unknown ID.
  final int mapId;

  /// Message describing the assertion error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return 'Unknown map ID $mapId: ${Error.safeToString(message)}';
    }
    return 'Unknown map ID $mapId';
  }
}

class DGisMapsFlutterMethodChannel extends DGisMapsFlutterPlatformInterface {

  String kChannelName = 'pro.flown/dgis_maps';
  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final Map<int, MethodChannel> _channels = <int, MethodChannel>{};

  /// Accesses the MethodChannel associated to the passed mapId.
  MethodChannel channel(int mapId) {
    final MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      throw UnknownMapIDError(mapId);
    }
    return channel;
  }

  /// Returns the channel for [mapId], creating it if it doesn't already exist.
  @visibleForTesting
  MethodChannel ensureChannelInitialized(int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      channel = MethodChannel('${kChannelName}_$mapId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, mapId));
      _channels[mapId] = channel;
    }
    return channel;
  }

  @override
  Future<void> init(int mapId) {
    final MethodChannel channel = ensureChannelInitialized(mapId);
    return channel.invokeMethod<void>('map#waitForMap');
  }

  @override
  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    required int mapId,
  }) {
    return channel(mapId).invokeMethod<void>(
      'markers#update',
      markerUpdates.toJson(),
    );
  }

  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) {
    return channel(mapId).invokeMethod<void>('camera#animate', <String, Object>{
      'cameraUpdate': cameraUpdate.toJson(),
    });
  }

  @override
  Future<void> moveCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) {
    return channel(mapId).invokeMethod<void>('camera#move', <String, dynamic>{
      'cameraUpdate': cameraUpdate.toJson(),
    });
  }

  bool useAndroidViewSurface = false;
  @override
  Widget buildView(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required CameraPosition initialPosition,
    MapObjects mapObjects = const MapObjects(),
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialCameraPosition': initialPosition.toMap(),
      'options': mapOptions,
      'markersToAdd': serializeMarkerSet(mapObjects.markers),
      // 'polylinesToAdd': serializePolylineSet(mapObjects.polylines),
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (useAndroidViewSurface) {
        return PlatformViewLink(
          viewType: kChannelName,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              // TODO(kit): Добавить жесты
              gestureRecognizers: const {},
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final SurfaceAndroidViewController controller =
                PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: kChannelName,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            );
            controller.addOnPlatformViewCreatedListener(
              params.onPlatformViewCreated,
            );
            controller.addOnPlatformViewCreatedListener(
              onPlatformViewCreated,
            );

            controller.create();
            return controller;
          },
        );
      } else {
        return AndroidView(
          viewType: kChannelName,
          onPlatformViewCreated: onPlatformViewCreated,
          gestureRecognizers: const {},
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: kChannelName,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: const {},
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    switch (call.method) {
    }
  }
}
