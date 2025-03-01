
import 'package:corntrack_raspberry_pi_app/api/photos_api/photos_api.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/photos_data.dart';

class DummyPhotosApi extends IPhotosApi {
  @override
  Future<ApiData<List<PhotosData>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

}