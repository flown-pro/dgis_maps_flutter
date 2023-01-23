library dgis_maps_flutter;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'src/controller.dart';
import 'src/method_channel/dgis_maps_flutter_method_channel.dart';
import 'src/types/types.dart';

export 'src/types/types.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);

class DGisMap extends StatefulWidget {
  const DGisMap({
    Key? key,
    this.onMapCreated,
    required this.initialPosition,
  }) : super(key: key);

  final CameraPosition initialPosition;

  final MapCreatedCallback? onMapCreated;

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  final _controller = Completer<DGisMapController>();

  Future<void> onViewCreated(int id) async {
    final DGisMapController controller = await DGisMapController.init(
      id,
      // this,
    );
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DGisMapsFlutterMethodChannel.buildView(
      onViewCreated,
      initialPosition: widget.initialPosition,
    );
  }
}
