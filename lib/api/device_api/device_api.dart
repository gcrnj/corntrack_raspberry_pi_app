import 'dart:convert';
import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';
import '../../data/api_data.dart';
import 'package:http/http.dart' as http;

import '../../data/device_details.dart';

abstract class IDeviceApi extends FlaskApi {
  Future<ApiData<String>> registerDevice();

  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId);

  Future<ApiData<DeviceDetails?>> editDeviceName(
      String deviceId, String newDeviceName);
}

class DevicesApi extends IDeviceApi {
  @override
  Future<ApiData<String>> registerDevice() async {
    final url = '$baseUrl/devices/register';
    print('Registering device: $url');
    // Sending POST request to Firestore
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Important to specify content type
      },
    );

    final responseBody = response.body;
    if (responseBody.isNotEmpty) {
      final responseJson = json.decode(responseBody);
      String? deviceId = responseJson['device_id']?.toString();
      String? error = responseJson['error']?.toString();
      if (deviceId != null && deviceId.isNotEmpty) {
        return ApiData.success(data: deviceId);
      } else {
        return ApiData.error(error: error);
      }
    }

    return ApiData.error(error: 'Registration failed. Please try again.');
    // Result in json = json.decode(response.body);
  }

  @override
  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId) async {
    final url = '$baseUrl/devices/find/$deviceId';
    print('getDeviceDetails - $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        final deviceDetails = DeviceDetails.fromJson(responseJson);
        print(deviceDetails.deviceName);
        return ApiData.success(data: deviceDetails);
      } else {
        final error = json.decode(response.body)['error'];
        print(error);
        return ApiData.error(error: error ?? 'Failed to fetch device details.');
      }
    } catch (e) {
      print('getDeviceDetails - error - $e');
      return ApiData.error(error: e.toString());
    }
  }

  @override
  Future<ApiData<DeviceDetails?>> editDeviceName(
      String deviceId, String newDeviceName) async {
    final url = '$baseUrl/devices/edit/$deviceId';
    print('editDeviceName - $url');
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'deviceName': newDeviceName}),
    );

    try {
    if (response.statusCode == 200) {
      print('Device name updated successfully');
      return ApiData.success(data: null);
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return ApiData.error(error: error ?? 'Failed to update device name.');
    }
    } catch (e) {
      print('editDeviceName - $e');

      return ApiData.error(error: e.toString());
    }
  }
}
