
import 'dgis_maps_flutter_ios_platform_interface.dart';

class DgisMapsFlutterIos {
  Future<String?> getPlatformVersion() {
    return DgisMapsFlutterIosPlatform.instance.getPlatformVersion();
  }
}
