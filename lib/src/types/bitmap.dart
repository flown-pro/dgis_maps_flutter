import 'dart:typed_data';

import '../method_channel.g.dart';

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
