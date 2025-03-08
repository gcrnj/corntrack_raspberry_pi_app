import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';
import '../../data/api_data.dart';
import '../../data/water_distribution_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import 'package:http/http.dart' as http;


abstract class IWaterDistributionApi extends FlaskApi {
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots);
}

class WaterDistributionApi extends IWaterDistributionApi {
  @override
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots) async {
    // Convert pot IDs to a comma-separated string
    final potIds = selectedCornPots.map((pot) => pot.getNumber()).join(',');

    // Construct query parameters
    final queryParameters = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'pots': potIds,
    };

    // Build the URI with query parameters
    final uri = Uri.parse('$baseUrl/water_distribution').replace(queryParameters: queryParameters);

    // Make the HTTP GET request
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    // Handle the response
    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      final waterDistributionData = responseJson
          .map((json) => WaterDistributionData.fromJson(json))
          .toList();
      return ApiData.success(data: waterDistributionData);
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(error: error ?? 'Failed to fetch water distribution data.');
    }
  }
}
