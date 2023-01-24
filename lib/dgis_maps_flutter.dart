library dgis_maps_flutter;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'src/controller.dart';
import 'src/method_channel/dgis_maps_flutter_method_channel.dart';
import 'src/method_channel/method_channel.g.dart';
import 'src/types/types.dart';

export 'src/method_channel/method_channel.g.dart';
export 'src/types/types.dart';
export 'src/controller.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef CameraStateChangedCallback = void Function(DataCameraState cameraState);

class DGisMap extends StatefulWidget {
  const DGisMap({
    Key? key,
    this.onMapCreated,
    this.markers = const {},
    this.polylines = const {},
    this.onCameraStateChanged,
    required this.initialPosition,
  }) : super(key: key);

  final CameraPosition initialPosition;

  final MapCreatedCallback? onMapCreated;

  final Set<Marker> markers;
  final Set<Polyline> polylines;

  final CameraStateChangedCallback? onCameraStateChanged;

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> implements PluginFlutterApi {
  final _controller = Completer<DGisMapController>();
  late final PluginHostApi api;

  Set<Marker> _markers = const {};
  Set<Polyline> _polylines = const {};

  @override
  void initState() {
    _markers = widget.markers.toSet();
    _polylines = widget.polylines.toSet();
    super.initState();
  }

  @override
  void didUpdateWidget(DGisMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_markers != widget.markers) {
      _updateMarkers(
        toAdd: widget.markers.difference(_markers),
        toRemove: _markers.difference(widget.markers),
      );
      _markers = widget.markers.toSet();
    }
    if (_polylines != widget.polylines) {
      _updatePolylines(
        toAdd: widget.polylines.difference(_polylines),
        toRemove: _polylines.difference(widget.polylines),
      );
      _polylines = widget.polylines.toSet();
    }
  }

  void _updateMarkers({
    required Set<Marker> toAdd,
    required Set<Marker> toRemove,
  }) =>
      api.updateMarkers(
        DataMarkerUpdates(
          toRemove: toRemove.toList(),
          toAdd: toAdd.toList(),
        ),
      );

  void _updatePolylines({
    required Set<Polyline> toAdd,
    required Set<Polyline> toRemove,
  }) =>
      api.updatePolylines(
        DataPolylineUpdates(
          toRemove: toRemove.toList(),
          toAdd: toAdd.toList(),
        ),
      );

  Future<void> onViewCreated(int id) async {
    api = PluginHostApi(id: id);
    final controller = DGisMapController(api, mapId: id);
    PluginFlutterApi.setup(this, id: id);
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
  void onCameraStateChanged(DataCameraState cameraState) =>
      widget.onCameraStateChanged?.call(cameraState);
}
