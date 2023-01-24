import 'package:dgis_maps_flutter/dgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Polyline extends DataPolyline {
  Polyline({
    required MapObjectId polylineId,
    required List<DataLatLng> points,
    double width = 1.0,
    Color color = Colors.black,
    double erasedPart = 0.0,
  }) : super(
            polylineId: polylineId,
            points: points,
            width: width,
            color: color.value,
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
