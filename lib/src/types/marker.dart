import '../method_channel.g.dart';
import 'types.dart';

class Marker extends DataMarker {
  Marker({
    required MapObjectId markerId,
    required LatLng position,
    String? infoText,
    MarkerBitmap? bitmap,
  }) : super(
          markerId: markerId,
          position: position,
          infoText: infoText,
          bitmap: bitmap,
        );

  Marker copyWith({
    LatLng? position,
    String? infoText,
    MarkerBitmap? bitmap,
  }) =>
      Marker(
        markerId: MapObjectId(markerId.value),
        position:
            position ?? LatLng(this.position.latitude, this.position.longitude),
        infoText: infoText ?? this.infoText,
        bitmap: bitmap ??
            MarkerBitmap(
              bytes: this.bitmap!.bytes,
              width: this.bitmap?.width,
              height: this.bitmap?.height,
            ),
      );
}
