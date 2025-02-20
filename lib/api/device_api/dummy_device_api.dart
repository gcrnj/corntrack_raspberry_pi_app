import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/device_details.dart';

import 'device_api.dart';

class DummyDeviceApi extends IDeviceApi {


  @override
  Future<ApiData<String>> registerDevice() async {
    return ApiData.success(data: '2bhE03Y9sc4rUHtj4hcy');
  }

  @override
  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId) async {
    return ApiData.success(data: DeviceDetails(deviceName: 'Device Name', ownerId: 'abc'));
  }

}
