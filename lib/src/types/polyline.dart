import 'package:dgis_maps_flutter/dgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class Polyline extends DataPolyline {
  Polyline(
      {required DataMapObjectId polylineId,
      required List<DataLatLng> points,
      required double width,
      required int color,
      required double erasedPart})
      : super(
            polylineId: polylineId,
            points: points,
            width: width,
            color: color,
            erasedPart: erasedPart);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Polyline &&
        polylineId == other.polylineId &&
        color == other.color &&
        width == other.width &&
        listEquals(points, other.points) &&
        erasedPart == other.erasedPart;
  }

  @override
  int get hashCode => polylineId.hashCode;
}
