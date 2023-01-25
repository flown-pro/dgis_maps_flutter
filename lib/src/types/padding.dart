import '../method_channel.g.dart';

class MapPadding extends DataPadding {
  static MapPadding zero = MapPadding();
  MapPadding({
    int left = 0,
    int top = 0,
    int right = 0,
    int bottom = 0,
  }) : super(left: left, top: top, right: right, bottom: bottom);
}
