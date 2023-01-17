library dgis_maps_flutter;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DGisMap extends StatefulWidget {
  const DGisMap({Key? key}) : super(key: key);

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const UiKitView(
        viewType: 'dgis_maps_flutter',
        // layoutDirection: TextDirection.ltr,
        // creationParams: {},
        // gestureRecognizers: widgetConfiguration.gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return const AndroidView(
        viewType: 'dgis_maps_flutter',
        // layoutDirection: TextDirection.ltr,
        // creationParams: {},        // onPlatformViewCreated: onPlatformViewCreated,
        // gestureRecognizers: widgetConfiguration.gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
      );
    }
  }
}
