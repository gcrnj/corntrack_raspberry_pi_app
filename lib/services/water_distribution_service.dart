import 'dart:convert';
import 'dart:io';

import 'package:corntrack_raspberry_pi_app/api/water_distribution_api/water_distribution_api.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:flutter/foundation.dart';

import '../api/water_distribution_api/dummy_water_distribution_api.dart';
import '../data/water_distribution_data.dart';
import '../screens/dashboard/dashboard_screen.dart';

class WaterDistributionServiceFactory {
  static WaterDistributionService create() {
    if (kIsWeb) {
      return WaterDistributionService(DummyWaterDistributionApi());
    } else if (Platform.isLinux) {
      return WaterDistributionService(WaterDistributionApi());
    } else {
      return WaterDistributionService(DummyWaterDistributionApi());
    }
  }
}

class WaterDistributionService {
  final IWaterDistributionApi waterDistributionApi;

  WaterDistributionService(this.waterDistributionApi);

  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots) async {
    return waterDistributionApi.getWaterDistributionData(start, end, selectedCornPots);
  }
}
