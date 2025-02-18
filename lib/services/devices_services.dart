import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/device_details.dart';
import 'base.dart';

class DevicesServices extends ServicesBase {
  final defaultDeviceName = 'Corn Track';
  late final devicesUrl = '$baseUrl/devices';

  /// Returns null if registration failed.
  /// /devices/register
  Future<String?> registerDevice() async {
    // Firebase Firestore endpoint URL
    return '2bhE03Y9sc4rUHtj4hcy';
    final String url = '$devicesUrl/register';

    // Sending POST request to Firestore
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Important to specify content type
      },
    );

    String? deviceId;
    final responseBody = response.body;
    if(responseBody.isNotEmpty) {
      final responseJson = json.decode(responseBody);
      deviceId = responseJson['device_id'].toString();
    }
    // Result in json = json.decode(response.body);

    return deviceId;
  }

  Future<DeviceDetails?> getDeviceDetails() async {

    return DeviceDetails(deviceName: 'Abc', ownerId: 'abc');
    final String url = '$devicesUrl/details';
  }

}
