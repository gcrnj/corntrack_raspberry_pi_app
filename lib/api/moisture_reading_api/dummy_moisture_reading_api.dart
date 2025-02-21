import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/hourly_temperature_data.dart';

import 'package:corntrack_raspberry_pi_app/data/moisture_reading_data.dart';

import 'moisture_reading_api.dart';

class DummyMoistureReadingApi extends IMoistureReadingApi {
  @override
  Future<ApiData<bool>> add(Map<dynamic, dynamic> body) async {
    return ApiData.success(data: true);
  }

  @override
  Future<ApiData<List<MoistureReadingData>>> getAll() async {
    return ApiData.success(data: [
      MoistureReadingData(
          moisture: '20.5', pot: '3', dateTime: DateTime.now(), temperature: '25'),
      MoistureReadingData(
          moisture: '40.5', pot: '3', dateTime: DateTime.now(), temperature: '25'),
      MoistureReadingData(
          moisture: '30', pot: '3', dateTime: DateTime.now(), temperature: '25'),
      MoistureReadingData(
          moisture: '25', pot: '3', dateTime: DateTime.now(), temperature: '25'),
      MoistureReadingData(
          moisture: '50', pot: '3', dateTime: DateTime.now(), temperature: '25'),
      MoistureReadingData(
          moisture: '32', pot: '3', dateTime: DateTime.now(), temperature: '25'),
    ]);
  }

  @override
  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(
      DateTime start, DateTime end) async {
    return ApiData.success(data: [
      HourlyTemperatureData(temperature: '25', dateTime: DateTime.now()),
      HourlyTemperatureData(temperature: '35', dateTime: DateTime.now()),
      HourlyTemperatureData(temperature: '30', dateTime: DateTime.now()),
    ]);
  }

  @override
  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(
      DateTime start, DateTime end) async {
    return ApiData.success(data: [
      MoistureReadingData(moisture: '25', pot: '2', temperature: '25', dateTime: DateTime.now()),
      MoistureReadingData(moisture: '36', pot: '2', temperature: '25', dateTime: DateTime.now()),
      MoistureReadingData(moisture: '35', pot: '2', temperature: '25', dateTime: DateTime.now()),
    ]);
  }
}
