import 'dart:convert';
import 'package:corntrack_raspberry_pi_app/data/date_range.dart';
import 'package:http/http.dart' as http;

import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';

import '../../data/api_data.dart';
import '../flask_api.dart';

abstract class IGraphApi extends FlaskApi {
  Future<ApiData<List<GraphData>>>  getGraphData(
    String deviceId,
    List<String> moistureId,
    DateRange? dateRange,
  );
}

class GraphApi extends IGraphApi {
  @override
  Future<ApiData<List<GraphData>>> getGraphData(
      String deviceId, List<String> moistureId, DateRange? dateRange) async {
    try {
      var url = '';
      if (dateRange == null) {
        url =
            '$baseUrl/graphs/get-graph/$deviceId?moistureId=${moistureId.join(',')}';
      } else {
        url =
            '$baseUrl/graphs/get-graph/$deviceId?moistureId=${moistureId.join(',')}&start_date=${dateRange.start.toIso8601String()}&end_date=${dateRange.end.toIso8601String()}';
      }
      print('Fetching soil data: $url');
      final response = await http.get(Uri.parse(url));

      final jsonData = json.decode(response.body);
      final data = jsonData['data'];
      print('getGraphData - \n$data');
      return ApiData.success(
        data: data.map<GraphData>((json) => GraphData.fromJson(json)).toList(),
      );
    } catch (e) {
      return ApiData.error(error: e.toString());
    }
  }
}
