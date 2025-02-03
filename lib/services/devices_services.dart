import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base.dart';

class DevicesServices extends ServicesBase {
  final defaultDeviceName = 'Corn Track';

  /// Returns null if registration failed.
  Future<String?> registerDevice() async {
    // Firebase Firestore endpoint URL
    final String url = '$baseUrl/devices';

    // The data to be sent as a request body
    final Map<String, dynamic> body = {
      'fields': {
        'deviceName': {
          'stringValue': defaultDeviceName,
          // assuming 'defaultDeviceName' is defined
        }
      },
    };

    // Sending POST request to Firestore
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Important to specify content type
      },
      body: json.encode(body),
    );

    String? deviceId;
    final responseBody = response.body;
    if(responseBody.isNotEmpty) {
      final responseJson = json.decode(responseBody);
      deviceId = responseJson['name'].toString().substring(responseJson['name'].lastIndexOf('/') + 1);
    }
    // Result in json = json.decode(response.body);

    return deviceId;
  }

  // Working
  Future<bool> test() async {
    print("base = $baseUrl");
    try {
      final url = Uri.parse('$baseUrl/devices/hpAqEtLkFejGUA3tYBcT');
      print('URL = $url');
      final a = http.Request('GET', url);
      final response = await http.get(url);

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on http.ClientException catch (e) {
      print('HTTP client exception occurred: ${e.toString()}');
      return false;
    } catch (e) {
      print('Error! ${e.toString()}');
      return false;
    }
  }
}
