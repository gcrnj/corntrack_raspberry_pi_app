import 'dart:convert';
import 'dart:io';

import 'package:corntrack_raspberry_pi_app/api/moisture_reading_api/moisture_reading_api.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:flutter/foundation.dart';

import '../api/moisture_reading_api/dummy_moisture_reading_api.dart';
import '../data/hourly_temperature_data.dart';
import '../data/moisture_reading_data.dart';
import '../screens/dashboard/dashboard_screen.dart';

class MoistureReadingServiceFactory {
  static MoistureReadingService create() {
    if (kIsWeb) {
      return MoistureReadingService(MoistureReadingApi());
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

  Future<ApiData<List<MoistureReadingData>>> getSoilMoistureData(
      DateTime start, DateTime end,
      {required String deviceId, required List<Pots> pots}) async {
    return moistureReadingApi.getSoilMoistureData(
        start.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
        end.copyWith(
            hour: 23,
            minute: 59,
            second: 59,
            millisecond: 999,
            microsecond: 999),
        pots: pots.map((pot) => pot.getNumber()).toList(),
        deviceId: deviceId);
  }
}
