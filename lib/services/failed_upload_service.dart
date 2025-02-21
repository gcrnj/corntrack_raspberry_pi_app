import 'dart:io';
import 'package:flutter/foundation.dart';

import '../api/failed_upload_api/dummy_failed_upload_api.dart';
import '../api/failed_upload_api/failed_upload_api.dart';
import '../data/api_data.dart';
import '../data/failed_upload_data.dart';

class FailedUploadServiceFactory {
  static FailedUploadService create() {
    if (kIsWeb) {
      return FailedUploadService(DummyFailedUploadApi());
    } else if (Platform.isLinux) {
      return FailedUploadService(FailedUploadApi());
    } else {
      return FailedUploadService(DummyFailedUploadApi());
    }
  }
}

class FailedUploadService {
  final IFailedUploadApi failedUploadApi;

  FailedUploadService(this.failedUploadApi);

  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads() async {
    await Future.delayed(Duration(seconds: 3));
    return failedUploadApi.getAllFailedUploads();
  }

  Future<ApiData<bool>> addFailedUpload(FailedUploadData data) async {
    return failedUploadApi.addFailedUpload(data);
  }
}
