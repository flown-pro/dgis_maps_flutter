import 'dart:typed_data';

import 'package:dgis_maps_flutter/dgis_maps_flutter.dart';

class MarkerBitmap extends DataMarkerBitmap {
  MarkerBitmap({
    required Uint8List bytes,
    double? width,
    double? height,
  }) : super(
          bytes: bytes,
          width: width,
          height: height,
        );
}
