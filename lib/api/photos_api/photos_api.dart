

import 'package:corntrack_raspberry_pi_app/data/photos_data.dart';

import '../../data/api_data.dart';
import '../flask_api.dart';

abstract class IPhotosApi extends FlaskApi {
  Future<ApiData<List<PhotosData>>> getAll();
}

class PhotosApi extends IPhotosApi {
  @override
  Future<ApiData<List<PhotosData>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

}