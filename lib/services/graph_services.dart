
import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';

import '../api/device_api/graphApi.dart';
import '../data/api_data.dart';

class GraphServiceFactory {
  static GraphService create() {
    return GraphService(GraphApi());
    // if (kIsWeb) {
    //   return PhotosServices(DummyPhotosApi());
    // } else if (Platform.isLinux) {
    //   return PhotosServices(PhotosApi());
    // } else {
    //   return PhotosServices(DummyPhotosApi());
    // }
  }
}


class GraphService {
  final IGraphApi graphApi;

  GraphService(this.graphApi);

  late final graphUrl = '${graphApi.baseUrl}/photos';

  Future<ApiData<GraphData>> getGraphData(String deviceId) async {
    return await graphApi.getGraphData(deviceId);
  }
}