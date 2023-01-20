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
  late MethodChannel channel;
  void onViewCreated(int id) {
    channel = MethodChannel('dgis_maps_flutter_$id');
    channel.setMethodCallHandler(onMethodCall);
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'blah':
        print(call.arguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'dgis_maps_flutter',
        onPlatformViewCreated: onViewCreated,
        // layoutDirection: TextDirection.ltr,
        // creationParams: {},
        // gestureRecognizers: widgetConfiguration.gestureRecognizers,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return AndroidView(
        viewType: 'dgis_maps_flutter',
        onPlatformViewCreated: onViewCreated,
        // layoutDirection: TextDirection.ltr,
        // creationParams: {},        // onPlatformViewCreated: onPlatformViewCreated,
        // gestureRecognizers: widgetConfiguration.gestureRecognizers,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
