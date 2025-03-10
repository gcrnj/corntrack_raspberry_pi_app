import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';

import '../../data/api_data.dart';
import '../../data/hourly_temperature_data.dart';
import '../../data/moisture_reading_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import 'package:http/http.dart' as http;

abstract class IMoistureReadingApi extends FlaskApi {
  Future<ApiData<List<MoistureReadingData>>> getAll();

  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(
      DateTime start,
      DateTime end, {
        required String deviceId,
        required List<int> pots,
      });

  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(DateTime start,
      DateTime end, {
        required String deviceId,
        required List<int> pots,
        bool? waterDistributed
      });
}

class MoistureReadingApi extends IMoistureReadingApi {
  @override
  Future<ApiData<List<MoistureReadingData>>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/moisture_readings'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      final readings = responseJson
          .map((json) => MoistureReadingData.fromJson(json))
          .toList();
      return ApiData.success(data: readings);
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(
          error: error ?? 'Failed to fetch moisture readings.');
    }
  }

  @override
  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(
      DateTime start,
      DateTime end, {
        required String deviceId,
        required List<int> pots,
      }) async {
    final potsQuery = pots.map((pot) => 'pots=$pot').join('&');

    final response = await http.get(
      Uri.parse(
          '$baseUrl/devices/$deviceId/hourly?start=${start
              .toIso8601String()}&end=${end.toIso8601String()}&$potsQuery'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      final temperatures = responseJson
          .map((json) => HourlyTemperatureData.fromJson(json))
          .toList();
      return ApiData.success(data: temperatures);
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(error: error ?? 'Failed to fetch temperature data.');
    }
  }

  @override
  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(DateTime start,
      DateTime end, {
        required String deviceId,
        required List<int> pots,
        bool? waterDistributed,
      }) async {
    // Convert pots list into query parameters
    final potsQuery = pots.map((pot) => 'pots=$pot').join('&');
    String url = '$baseUrl/devices/$deviceId/soil_moisture?start=${start
        .toIso8601String()}&end=${end.toIso8601String()}&$potsQuery';
    if (waterDistributed != null) {
      url += '&water_distributed=$waterDistributed';
    }

    print("[GET] - getSoilMoistureData - $url");

    final response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200)
    {
      final List<dynamic> responseJson = json.decode(response.body);
      final moistureData = responseJson
          .map((json) => MoistureReadingData.fromJson(json))
          .toList();
      print(moistureData.first.dateTime);
      return ApiData.success(data: moistureData);
    } else {
    final error = json.decode(response.body)['error'];
    return ApiData.error(
    error: error ?? 'Failed to fetch soil moisture data.');
    }
  }

}
