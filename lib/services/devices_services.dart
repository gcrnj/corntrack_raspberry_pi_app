import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base.dart';

class DevicesServices extends ServicesBase {
  final defaultDeviceName = 'Corn Track';
  late final devicesUrl = '$baseUrl/devices';

  /// Returns null if registration failed.
  /// /devices/register
  Future<String?> registerDevice() async {
    // Firebase Firestore endpoint URL
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

}
