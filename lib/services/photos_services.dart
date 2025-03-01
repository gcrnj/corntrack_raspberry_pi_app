import 'dart:io';

import 'package:flutter/foundation.dart';

import '../api/photos_api/dummy_photos_api.dart';
import '../api/photos_api/photos_api.dart';
import '../data/photos_data.dart';

class PhotosServiceFactory {
  static PhotosServices create() {
    if (kIsWeb) {
      return PhotosServices(DummyPhotosApi());
    } else if (Platform.isLinux) {
      return PhotosServices(PhotosApi());
    } else {
      return PhotosServices(DummyPhotosApi());
    }
  }
}

class PhotosServices {
  final IPhotosApi photosApi;

  PhotosServices(this.photosApi);

  late final photosUrl = '${photosApi.baseUrl}/photos';

  Future<List<PhotosData>> getAll() async {
    final res = await photosApi.getAll();
    return res.data!;
  }
}
