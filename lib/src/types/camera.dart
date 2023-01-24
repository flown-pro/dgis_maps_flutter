import '../method_channel/method_channel.g.dart' as data;

class CameraPosition extends data.CameraPosition {
  CameraPosition({
    required data.LatLng target,
    double bearing = 0.0,
    double tilt = 0.0,
    double zoom = 0.0,
  }) : super(bearing: bearing, target: target, tilt: tilt, zoom: zoom);
}
