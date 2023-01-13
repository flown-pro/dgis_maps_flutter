import 'package:flutter_test/flutter_test.dart';
import 'package:dgis_maps_flutter_ios/dgis_maps_flutter_ios.dart';
import 'package:dgis_maps_flutter_ios/dgis_maps_flutter_ios_platform_interface.dart';
import 'package:dgis_maps_flutter_ios/dgis_maps_flutter_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDgisMapsFlutterIosPlatform
    with MockPlatformInterfaceMixin
    implements DgisMapsFlutterIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DgisMapsFlutterIosPlatform initialPlatform = DgisMapsFlutterIosPlatform.instance;

  test('$MethodChannelDgisMapsFlutterIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDgisMapsFlutterIos>());
  });

  test('getPlatformVersion', () async {
    DgisMapsFlutterIos dgisMapsFlutterIosPlugin = DgisMapsFlutterIos();
    MockDgisMapsFlutterIosPlatform fakePlatform = MockDgisMapsFlutterIosPlatform();
    DgisMapsFlutterIosPlatform.instance = fakePlatform;

    expect(await dgisMapsFlutterIosPlugin.getPlatformVersion(), '42');
  });
}
