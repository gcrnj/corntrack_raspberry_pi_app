import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/services/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/prefsKeys.dart';

import 'package:http/http.dart' as http;

class MoistureReadingModel {
  MoistureReadingModel({
    required this.moisture,
    required this.pot,
    required this.time,
  });

  final String moisture;
  final String pot; // Pot field as a String (or you can choose to keep it as int or double if needed)
  final DateTime time;

  // Updated factory constructor to handle moisture and pot fields dynamically
  factory MoistureReadingModel.fromMap(Map<String, dynamic> map) {
    return MoistureReadingModel(
      moisture: _getValue(map['moisture']),
      pot: _getValue(map['pot']),
      time: DateTime.parse(map['time']),
    );
  }

  // Helper function to handle different value types (moisture, pot)
  static String _getValue(Map<String, dynamic> valueMap) {
    if (valueMap.isNotEmpty) {
      var key = valueMap.keys.first;
      var value = valueMap[key];

      // Return the value as a String based on its type
      if (value is int) {
        return value.toString();
      } else if (value is double) {
        return value.toString();
      } else if (value is String) {
        return value;
      }
    }
    return ''; // Fallback if the value is not found or not valid
  }
}

class MoistureReadingServices extends ServicesBase {

  Future<List<MoistureReadingModel>> getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? deviceId = prefs.getString(PrefKeys.deviceId.name);

    try {
      final url = Uri.parse('$baseUrl/devices/$deviceId');
      final response = await http.get(url);

      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        final responseJson = json.decode(responseBody);

        // Assuming 'moisture_readings' is the key in the response
        final List<dynamic> moistureReadingsJson = responseJson['fields']['moisture_readings']['arrayValue']['values'];

        // Map the responseJson to a List of MoistureReadingModel
        List<MoistureReadingModel> moistureReadings = moistureReadingsJson.map((item) {
          final Map<String, dynamic> fields = item['mapValue']['fields'];
          return MoistureReadingModel.fromMap({
            'moisture': fields['moisture'],
            'pot': fields['pot'],
            'time': fields['time']['timestampValue'],
          });
        }).toList();

        print(moistureReadings.length);
        return moistureReadings;
      }
      return List.empty();
    } catch (e) {
      print('Error! ${e.toString()}');
      return List.empty();
    }
  }

  Future<bool> add(Map<dynamic, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(PrefKeys.deviceId.name);

    if (deviceId == null) {
      print('Error: Device ID not found in preferences.');
      return false;
    }

    final String url = '$baseUrl/devices/$deviceId/moisture_readings';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'fields': body}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add moisture reading: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding moisture reading: ${e.toString()}');
      return false;
    }
  }

}
