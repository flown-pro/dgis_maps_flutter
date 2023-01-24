import '../method_channel/method_channel.g.dart' as data;
import 'types.dart';

class Marker extends data.Marker {
  Marker({
    required data.MarkerId markerId,
    required data.LatLng position,
    String? infoText,
    data.MarkerBitmap? bitmap,
  }) : super(
          markerId: markerId,
          position: position,
          infoText: infoText,
          bitmap: bitmap,
        );

  Marker copyWith({
    LatLng? position,
    String? infoText,
    data.MarkerBitmap? bitmap,
  }) =>
      Marker(
        markerId: markerId,
        position: position ?? this.position,
        infoText: infoText ?? this.infoText,
        bitmap: bitmap ?? this.bitmap,
      );
}
