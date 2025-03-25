import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import '../api/photos_api/photos_api.dart';
import '../data/photos_data.dart';

class PhotosServiceFactory {
  static PhotosServices create() {
    return PhotosServices(PhotosApi());
    // if (kIsWeb) {
    //   return PhotosServices(DummyPhotosApi());
    // } else if (Platform.isLinux) {
    //   return PhotosServices(PhotosApi());
    // } else {
    //   return PhotosServices(DummyPhotosApi());
    // }
  }
}

class PhotosServices {
  final IPhotosApi photosApi;

  PhotosServices(this.photosApi);

  late final photosUrl = '${photosApi.baseUrl}/photos';

  Future<ApiData<List<PhotosData>>> getAll(String deviceId) async {
    return await photosApi.getAll(deviceId);
  }

  Future<void> postNewPhoto(String deviceId) async {
    return await photosApi.postNewPhoto(deviceId);
  }
}
