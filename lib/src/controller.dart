import 'method_channel/method_channel.g.dart';

/// Controller for a single GoogleMap instance running on the host platform.
class DGisMapController {
  DGisMapController._(
      // this._googleMapState,
      {
    required this.mapId,
  });

  final int mapId;
  late final PluginHostApi api = PluginHostApi(id: mapId);

  static Future<DGisMapController> init(
    int id,
    // _GoogleMapState googleMapState,
  ) async {
    return DGisMapController._(
      mapId: id,
    );
  }
}
