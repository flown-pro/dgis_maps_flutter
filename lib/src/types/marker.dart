import '../method_channel/method_channel.g.dart';
import 'types.dart';

class Marker extends DataMarker {
  Marker({
    required DataMarkerId markerId,
    required DataLatLng position,
    String? infoText,
    DataMarkerBitmap? bitmap,
  }) : super(
          markerId: markerId,
          position: position,
          infoText: infoText,
          bitmap: bitmap,
        );

  Marker copyWith({
    LatLng? position,
    String? infoText,
    DataMarkerBitmap? bitmap,
  }) =>
      Marker(
        markerId: markerId,
        position: position ?? this.position,
        infoText: infoText ?? this.infoText,
        bitmap: bitmap ?? this.bitmap,
      );
}
