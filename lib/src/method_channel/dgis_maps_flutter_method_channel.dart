import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../types/types.dart';
import 'method_channel.g.dart';

class DGisMapsFlutterMethodChannel {
  static bool useAndroidViewSurface = false;
  static const String kChannelName = 'pro.flown/dgis_maps';

  static Widget buildView(
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required CameraPosition initialPosition,
    MapObjects mapObjects = const MapObjects(),
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    final creationParams = CreationParams(
      position: initialPosition.target,
      zoom: initialPosition.zoom,
      // 'options': mapOptions,
      // 'markersToAdd': serializeMarkerSet(mapObjects.markers),
      // 'polylinesToAdd': serializePolylineSet(mapObjects.polylines),
    ).encode();

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
}
