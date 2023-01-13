
import 'dgis_maps_flutter_android_platform_interface.dart';

class DgisMapsFlutterAndroid {
  Future<String?> getPlatformVersion() {
    return DgisMapsFlutterAndroidPlatform.instance.getPlatformVersion();
  }
}
