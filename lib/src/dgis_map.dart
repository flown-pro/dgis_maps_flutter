library dgis_maps_flutter;

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'controller.dart';
import 'method_channel.g.dart';
import 'types/types.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef CameraStateChangedCallback = void Function(DataCameraState cameraState);

const String _kChannelName = 'pro.flown/dgis_maps';

class DGisMap extends StatefulWidget {
  const DGisMap({
    Key? key,
    this.onMapCreated,
    this.markers = const {},
    this.polylines = const {},
    this.onCameraStateChanged,
    this.myLocationEnabled = true,
    required this.initialPosition,
    required this.onTapMarker,
    this.mapTheme = MapTheme.auto,
    this.onTapMap,
  }) : super(key: key);

  final CameraPosition initialPosition;
  final MapTheme mapTheme;

  final MapCreatedCallback? onMapCreated;
  final Function(Marker) onTapMarker;
  final Function()? onTapMap;

  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final bool myLocationEnabled;

  final CameraStateChangedCallback? onCameraStateChanged;

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> implements PluginFlutterApi {
  final _apiReady = Completer<void>();
  final _methodChannel = const MethodChannel("fgis");
  late final PluginHostApi api;

  Set<Marker> _markers = const {};
  Set<Polyline> _polylines = const {};
  bool _myLocationEnabled = false;

  @override
  void initState() {
    updateWidgetFields();

    _methodChannel.setMethodCallHandler((call) => _handleMethodCall(call));
    super.initState();
  }

  @override
  void didUpdateWidget(DGisMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateWidgetFields();
  }

  void updateWidgetFields() {
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
    if (_myLocationEnabled != widget.myLocationEnabled) {
      _apiReady.future.then((_) {
        api.changeMyLocationLayerState(widget.myLocationEnabled);
        _myLocationEnabled = widget.myLocationEnabled;
      });
    }
  }

  Future<void> _updateMarkers({
    required Set<Marker> toAdd,
    required Set<Marker> toRemove,
  }) async {
    await _apiReady.future;
    return api.updateMarkers(
      DataMarkerUpdates(
        toRemove: toRemove.toList(),
        toAdd: toAdd.toList(),
      ),
    );
  }

  Future<void> _updatePolylines({
    required Set<Polyline> toAdd,
    required Set<Polyline> toRemove,
  }) async {
    await _apiReady.future;
    return api.updatePolylines(
      DataPolylineUpdates(
        toRemove: toRemove.toList(),
        toAdd: toAdd.toList(),
      ),
    );
  }

  Future<void> onViewCreated(int id) async {
    api = PluginHostApi(id: id);
    final controller = DGisMapController(api, _apiReady, mapId: id);
    PluginFlutterApi.setup(this, id: id);
    await _apiReady.future;
    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final creationParams = DataCreationParams(
      position: widget.initialPosition.target,
      zoom: widget.initialPosition.zoom,
      mapTheme: widget.mapTheme,
    ).encode();

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _kChannelName,
        onPlatformViewCreated: (params) {
          onViewCreated(params);
        },
        gestureRecognizers: {},
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
      return PlatformViewLink(
        viewType: _kChannelName,
        surfaceFactory: (context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: {},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          onViewCreated(params.id);
          final AndroidViewController controller =
              PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: _kChannelName,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
          return controller;
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _kChannelName,
        onPlatformViewCreated: onViewCreated,
        gestureRecognizers: const {},
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
      '$defaultTargetPlatform is not yet supported by the maps plugin',
    );
  }

  @override
  Future<void> onCameraStateChanged(DataCameraStateValue cameraState) async {
    await _apiReady.future;
    widget.onCameraStateChanged?.call(cameraState.value);
  }

  @override
  void onNativeMapReady() {
    _apiReady.complete();
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'ontap_marker':
        String id = call.arguments['id'];
        final list = _markers;
        widget.onTapMarker(
            list.firstWhere((element) => element.markerId.value == id));
        break;
      case 'ontap_map':
        widget.onTapMap?.call();
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  void onMapObjectTapped(dynamic) {
    final list = _markers;
    if (dynamic is GeoPoint) {
      Marker? _selectedMarker = findNearestGeoPoint(dynamic, _markers);
      if (_selectedMarker != null) {
        widget.onTapMarker(_selectedMarker);
      }
    } else {
      widget.onTapMarker(list
          .firstWhere((element) => element.markerId.value == dynamic['id']));
    }
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  double calculateDistance(GeoPoint point1, GeoPoint point2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers

    final lat1Rad = degreesToRadians(point1.latitude);
    final lon1Rad = degreesToRadians(point1.longitude);
    final lat2Rad = degreesToRadians(point2.latitude);
    final lon2Rad = degreesToRadians(point2.longitude);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = earthRadius * c;
    return distance;
  }

  Marker? findNearestGeoPoint(GeoPoint targetPoint, Set<Marker> points) {
    if (points.isEmpty) {
      return null; // Return null if the list is empty
    }

    Marker? nearestPoint;
    double minDistance = double.infinity;

    for (final point in points) {
      final dist = calculateDistance(
        targetPoint,
        GeoPoint(
          latitude: point.position.latitude,
          longitude: point.position.longitude,
        ),
      );
      if (dist > 5) {
        return null;
      }
      if (dist < minDistance) {
        minDistance = dist;
        nearestPoint = point;
      }
    }

    return nearestPoint;
  }
}
