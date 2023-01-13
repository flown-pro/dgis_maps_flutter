import 'package:flutter_test/flutter_test.dart';
import 'package:dgis_maps_flutter_android/dgis_maps_flutter_android.dart';
import 'package:dgis_maps_flutter_android/dgis_maps_flutter_android_platform_interface.dart';
import 'package:dgis_maps_flutter_android/dgis_maps_flutter_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDgisMapsFlutterAndroidPlatform
    with MockPlatformInterfaceMixin
    implements DgisMapsFlutterAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DgisMapsFlutterAndroidPlatform initialPlatform = DgisMapsFlutterAndroidPlatform.instance;

  test('$MethodChannelDgisMapsFlutterAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDgisMapsFlutterAndroid>());
  });

  test('getPlatformVersion', () async {
    DgisMapsFlutterAndroid dgisMapsFlutterAndroidPlugin = DgisMapsFlutterAndroid();
    MockDgisMapsFlutterAndroidPlatform fakePlatform = MockDgisMapsFlutterAndroidPlatform();
    DgisMapsFlutterAndroidPlatform.instance = fakePlatform;

    expect(await dgisMapsFlutterAndroidPlugin.getPlatformVersion(), '42');
  });
}
