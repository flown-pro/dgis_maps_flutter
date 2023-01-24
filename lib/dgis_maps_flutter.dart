library dgis_maps_flutter;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'src/controller.dart';
import 'src/method_channel/dgis_maps_flutter_method_channel.dart';
import 'src/method_channel/method_channel.g.dart' as data;
import 'src/types/types.dart';

export 'src/method_channel/method_channel.g.dart'
    hide CameraPosition, LatLng, Marker;
export 'src/types/types.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef CameraStateChangedCallback = void Function(
    data.CameraState cameraState);

class DGisMap extends StatefulWidget {
  const DGisMap({
    Key? key,
    this.onMapCreated,
    this.markers = const {},
    this.onCameraStateChanged,
    required this.initialPosition,
  }) : super(key: key);

  final CameraPosition initialPosition;

  final MapCreatedCallback? onMapCreated;

  final Set<Marker> markers;

  final CameraStateChangedCallback? onCameraStateChanged;

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> implements data.PluginFlutterApi {
  final _controller = Completer<DGisMapController>();
  late final data.PluginHostApi api;

  @override
  void didUpdateWidget(DGisMap oldWidget) {
    if (oldWidget.markers != widget.markers) {
      _updateMarkers(
        toAdd: oldWidget.markers.difference(widget.markers),
        toRemove: widget.markers.difference(oldWidget.markers),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateMarkers({
    required Set<Marker> toAdd,
    required Set<Marker> toRemove,
  }) =>
      api.updateMarkers(
        data.MarkerUpdates(
          toRemove: toRemove.toList(),
          toAdd: toAdd.toList(),
        ),
      );

  Future<void> onViewCreated(int id) async {
    api = data.PluginHostApi(id: id);
    final controller = DGisMapController(api, mapId: id);
    data.PluginFlutterApi.setup(this, id: id);
    if (!_controller.isCompleted) _controller.complete(controller);
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

  @override
  void onCameraStateChanged(data.CameraState cameraState) =>
      widget.onCameraStateChanged?.call(cameraState);
}
