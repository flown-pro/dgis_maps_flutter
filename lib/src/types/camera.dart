import '../method_channel/method_channel.g.dart';

class CameraPosition extends DataCameraPosition {
  CameraPosition({
    required DataLatLng target,
    double bearing = 0.0,
    double tilt = 0.0,
    double zoom = 0.0,
  }) : super(bearing: bearing, target: target, tilt: tilt, zoom: zoom);
}
