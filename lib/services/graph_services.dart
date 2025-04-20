
import 'package:corntrack_raspberry_pi_app/data/date_range.dart';
import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';

import '../api/device_api/graphApi.dart';
import '../data/api_data.dart';

class GraphServiceFactory {
  static GraphService create() {
    return GraphService(GraphApi());
  }
}

class GraphService {
  final IGraphApi graphApi;

  GraphService(this.graphApi);

  Future<ApiData<List<GraphData>>> getGraphData(String deviceId, List<String> moistureId, DateRange? dateRange) async {
    return await graphApi.getGraphData(deviceId, moistureId, dateRange);
  }
}