import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';

import '../../data/api_data.dart';
import '../flask_api.dart';

abstract class IGraphApi extends FlaskApi {
  Future<ApiData<GraphData>> getGraphData(String deviceId);
}

class GraphApi extends IGraphApi {
  @override
  Future<ApiData<GraphData>> getGraphData(String deviceId) async {
    try {
      final url = '$baseUrl/graphs/get-graph/$deviceId';
      print('Fetching soil data from getGraphData - $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return ApiData.success(data: GraphData.fromJson(data));
      } else {
        print('Failed to load soil data');

        return ApiData.error(error: "Failed to load soil data");
      }
    } catch (e) {
      return ApiData.error(error: e.toString());
    }
  }
}
