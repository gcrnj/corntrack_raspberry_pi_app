import 'dart:io';

import 'package:corntrack_raspberry_pi_app/api/device_api/device_api.dart';
import 'package:corntrack_raspberry_pi_app/api/device_api/dummy_device_api.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:flutter/foundation.dart';

import '../data/device_details.dart';

class DevicesServicesFactory {
   static DevicesServices create() {
     if (kIsWeb) {
       return DevicesServices(DevicesApi()); // Web should use DummyDeviceApi
     } else if (Platform.isLinux) {
       return DevicesServices(DevicesApi());
     } else {
       return DevicesServices(DevicesApi());
     }
  }
}

class DevicesServices {
  final defaultDeviceName = 'Corn Track';
  late final devicesUrl = '${deviceApi.baseUrl}/devices';

  final IDeviceApi deviceApi;

  DevicesServices(this.deviceApi);

  /// /devices/register
  Future<ApiData<String?>> registerDevice() async {
    // Firebase Firestore endpoint URL
    return await deviceApi.registerDevice();
  }

  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId) async {
    return await deviceApi.getDeviceDetails(deviceId);
  }
}
