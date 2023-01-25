import '../method_channel.g.dart';

class MapPadding extends DataPadding {
  static MapPadding zero = MapPadding();
  MapPadding({
    int left = 0,
    int top = 0,
    int right = 0,
    int bottom = 0,
  }) : super(left: left, top: top, right: right, bottom: bottom);
  MapPadding.all(int all) : super(left: all, top: all, right: all, bottom: all);
  MapPadding.fromLTRB(int left, int top, int right, int bottom)
      : super(left: left, top: top, right: right, bottom: bottom);
  MapPadding.symmetric({
    int vertical = 0,
    int horizontal = 0,
  }) : super(
          left: horizontal,
          top: vertical,
          right: horizontal,
          bottom: vertical,
        );
}
