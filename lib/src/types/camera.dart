import '../method_channel/method_channel.g.dart';
import 'types.dart';

class CameraPosition extends DataCameraPosition {
  CameraPosition({
    required LatLng target,
    double bearing = 0.0,
    double tilt = 0.0,
    double zoom = 0.0,
  }) : super(bearing: bearing, target: target, tilt: tilt, zoom: zoom);

  @override
  String toString() =>
      'CameraPosition(bearing: $bearing, target: $target, tilt: $tilt, zoom: $zoom)';
}
