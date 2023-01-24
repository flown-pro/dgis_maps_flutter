import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../types/types.dart';
import 'method_channel.g.dart' hide Marker, CameraPosition;

class DGisMapsFlutterMethodChannel {
  static const String kChannelName = 'pro.flown/dgis_maps';

  static Widget buildView(
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required CameraPosition initialPosition,
    Set<Marker> markers = const {},
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    final creationParams = CreationParams(
      position: initialPosition.target,
      zoom: initialPosition.zoom,
    ).encode();

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: kChannelName,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: const {},
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
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
