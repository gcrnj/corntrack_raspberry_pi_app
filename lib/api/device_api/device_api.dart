import 'dart:convert';
import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';
import '../../data/api_data.dart';
import 'package:http/http.dart' as http;

import '../../data/device_details.dart';

abstract class IDeviceApi extends FlaskApi {
  Future<ApiData<String>> registerDevice();

  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId);
}

class DevicesApi extends IDeviceApi {
  @override
  Future<ApiData<String>> registerDevice() async {
    // Sending POST request to Firestore
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json', // Important to specify content type
      },
    );

    final responseBody = response.body;
    if (responseBody.isNotEmpty) {
      final responseJson = json.decode(responseBody);
      String? deviceId = responseJson.get('deviceId')?.toString();
      String? error = responseJson.get('error')?.toString();
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
  Future<ApiData<DeviceDetails?>> getDeviceDetails(String deviceId) {
    // TODO: implement getDeviceDetails
    throw UnimplementedError();
  }
}
