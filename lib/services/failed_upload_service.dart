import 'dart:io';
import 'package:flutter/foundation.dart';

import '../api/failed_upload_api/dummy_failed_upload_api.dart';
import '../api/failed_upload_api/failed_upload_api.dart';
import '../data/api_data.dart';
import '../data/failed_upload_data.dart';

class FailedUploadServiceFactory {
  static FailedUploadService create() {
    if (kIsWeb) {
      return FailedUploadService(FailedUploadApi());
    } else if (Platform.isLinux) {
      return FailedUploadService(FailedUploadApi());
    } else {
      return FailedUploadService(FailedUploadApi());
    }
  }
}

class FailedUploadService {
  final IFailedUploadApi failedUploadApi;

  FailedUploadService(this.failedUploadApi);

  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads(
    String? deviceId,
  ) async {
    try {
      print("trying getAllFailedUploads");
      return failedUploadApi.getAllFailedUploads(deviceId);
    } catch (e) {
      print("error in getAllFailedUploads");
      return ApiData.error(error: e.toString());
    }
  }

  Future<ApiData<String>> manualUpload(String deviceId) async {
    try {
      return await failedUploadApi.manualUpload(deviceId);
    } catch (e) {
      return ApiData.error(error: e.toString());
    }
  }
}
