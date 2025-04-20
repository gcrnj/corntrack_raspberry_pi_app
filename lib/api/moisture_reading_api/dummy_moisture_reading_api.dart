import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/hourly_temperature_data.dart';

import 'package:corntrack_raspberry_pi_app/data/moisture_reading_data.dart';

import '../../screens/dashboard/dashboard_screen.dart';
import 'moisture_reading_api.dart';

class DummyMoistureReadingApi extends IMoistureReadingApi {
  @override
  Future<ApiData<List<MoistureReadingData>>> getAll() async {
    return ApiData.success(data: [
      MoistureReadingData(
          moisture1: 30,
          humidity: 1,
          moisture2: 30,
          moisture3: 30,
          dateTime: DateTime(2025, 2, 27, 11, 0, 0),
          temperature: 322),
      MoistureReadingData(
          moisture1: 30,
          moisture2: 30,
          humidity: 1,
          moisture3: 30,
          dateTime: DateTime(2025, 2, 27, 10, 0, 0),
          temperature: 33),
      MoistureReadingData(
          moisture1: 30,
          moisture2: 30,
          moisture3: 30,
          humidity: 1,
          dateTime: DateTime(2025, 2, 27, 9, 0, 0),
          temperature: 315),
    ]);
  }

  @override
  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(
      DateTime start, DateTime end,
      {required String deviceId, required List<int> pots}) async {
    return ApiData.success(data: [
      HourlyTemperatureData(
          temperature: '281', dateTime: DateTime(2025, 2, 27, 10, 0, 0)),
      HourlyTemperatureData(
          temperature: '324', dateTime: DateTime(2025, 2, 27, 9, 0, 0)),
      HourlyTemperatureData(
          temperature: '290', dateTime: DateTime(2025, 2, 27, 8, 0, 0)),
      HourlyTemperatureData(
          temperature: '315', dateTime: DateTime(2025, 2, 27, 7, 0, 0)),
      HourlyTemperatureData(
          temperature: '325', dateTime: DateTime(2025, 2, 27, 6, 0, 0)),
      HourlyTemperatureData(
          temperature: '31.0', dateTime: DateTime(2025, 2, 27, 5, 0, 0)),
      HourlyTemperatureData(
          temperature: '293', dateTime: DateTime(2025, 2, 27, 4, 0, 0)),
    ]);
  }

  @override
  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(
    DateTime start,
    DateTime end, {
    required String deviceId,
    required List<int> pots,
    bool? waterDistributed,
  }) async {
    return ApiData.success(
        data: [
      MoistureReadingData(
        moisture1: 25,
        moisture2: 25,
        moisture3: 25,
        temperature: 25,
        dateTime: DateTime(2025, 2, 27, 9, 0, 0),
        humidity: 1,
      ),
      MoistureReadingData(
        moisture1: 25,
        moisture2: 25,
        moisture3: 25,
        temperature: 26,
        dateTime: DateTime(2025, 2, 27, 9, 0, 0),
        humidity: 1,
      ),
    ].toList());
  }
}
