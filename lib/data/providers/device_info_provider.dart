import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;

class DeviceInfoProvider {
  Future<Map<String, String>> deviceHeaders() async {
    return <String, String>{
      'deviceOS': Platform.operatingSystem,
      'deviceBrand': await getDeviceBrand(),
      'deviceModel': await getDeviceModel(),
    };
  }

  Future<dynamic> getCurrentDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        return await deviceInfo.androidInfo;
      }

      if (Platform.isIOS) {
        return await deviceInfo.iosInfo;
      }
    } catch (exception) {}

    return null;
  }

  Future<String> getDeviceModel() async {
    dynamic device = await getCurrentDevice();

    if (device != null) {
      return device.model as String;
    }

    return 'browser';
  }

  Future<String> getDeviceBrand() async {
    dynamic device = await getCurrentDevice();

    if (device is AndroidDeviceInfo) {
      return device.brand;
    }

    if (device is IosDeviceInfo) {
      return device.systemName;
    }

    return '';
  }
}
