import 'dart:convert';
import 'dart:io';

import 'package:corntrack_raspberry_pi_app/api/moisture_reading_api/moisture_reading_api.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:flutter/foundation.dart';

import '../api/moisture_reading_api/dummy_moisture_reading_api.dart';
import '../data/hourly_temperature_data.dart';
import '../data/moisture_reading_data.dart';

class MoistureReadingServiceFactory {
  static MoistureReadingService create() {
    if (kIsWeb) {
      return MoistureReadingService(DummyMoistureReadingApi());
    } else if (Platform.isLinux) {
      return MoistureReadingService(MoistureReadingApi());
    } else {
      return MoistureReadingService(DummyMoistureReadingApi());
    }
  }
}

class MoistureReadingService {
  final IMoistureReadingApi moistureReadingApi;

  MoistureReadingService(this.moistureReadingApi);

  Future<ApiData<List<MoistureReadingData>>> getAll() async {
    return moistureReadingApi.getAll();
  }

  Future<ApiData<bool>> add(Map<dynamic, dynamic> body) async {
    return moistureReadingApi.add(body);
  }

  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(DateTime start, DateTime end) async {
    return moistureReadingApi.getSoilMoistureData(start, end);
  }

  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(DateTime start, DateTime end) async {
    return moistureReadingApi.getHourlyTemperature(start, end);
  }
}
