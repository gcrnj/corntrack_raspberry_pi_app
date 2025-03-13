import 'dart:convert';

import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import '../flask_api.dart';
import 'package:http/http.dart' as http;

abstract class IFailedUploadApi extends FlaskApi {
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads(
    String? deviceId,
  );

  Future<ApiData<String>> manualUpload(String deviceId);
}

class FailedUploadApi extends IFailedUploadApi {
  @override
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads(
    String? deviceId,
  ) async {
    print("deviceid = $deviceId");
    deviceId = deviceId ?? '';
    final url = '$baseUrl/failed-uploads/$deviceId/failed_upload';
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> responseJson = json.decode(response.body)[deviceId];
      final failedUploads = responseJson
          .map((json) {
            if (json['type'] != null && json['type'] == 'photo') {
              return FailedUploadData.photoFromJson(json);
            } else if (json['type'] != null &&
                json['type'] == 'soil_moisture') {
              return FailedUploadData.soilMoistureFromJson(json);
            } else {
              return null;
            }
          })
          .whereType<FailedUploadData>()
          .toList();
      print("object");
      print(failedUploads.toString());
      return ApiData.success(data: failedUploads);
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(error: error ?? 'Failed to fetch failed uploads.');
    }
  }

  @override
  Future<ApiData<String>> manualUpload(String deviceId) async {
    final url = '$baseUrl/failed-uploads/$deviceId/upload';
    print("Uploading failed uploads for device: $deviceId");
    print("url: $url");

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ApiData.success(data: 'Upload successful');
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(error: error ?? 'Failed to upload failed uploads.');
    }
  }
}
