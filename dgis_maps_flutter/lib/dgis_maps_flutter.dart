library dgis_maps_flutter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DGisMap extends StatefulWidget {
  const DGisMap({Key? key}) : super(key: key);

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  @override
  Widget build(BuildContext context) {
    return const AndroidView(
      viewType: 'dgis_maps_flutter',
      // onPlatformViewCreated: onPlatformViewCreated,
      // gestureRecognizers: widgetConfiguration.gestureRecognizers,
      // creationParams: creationParams,
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
