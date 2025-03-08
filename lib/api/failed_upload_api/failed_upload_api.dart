import 'dart:convert';

import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import '../flask_api.dart';
import 'package:http/http.dart' as http;

abstract class IFailedUploadApi extends FlaskApi {
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads();

  Future<ApiData<bool>> addFailedUpload(FailedUploadData data);
}

class FailedUploadApi extends IFailedUploadApi {
  @override
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads() async {
    final response = await http.get(
      Uri.parse('$baseUrl/failed_uploads'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      final failedUploads = responseJson
          .map((json) => FailedUploadData.fromJson(json))
          .toList();
      return ApiData.success(data: failedUploads);
    } else {
      final error = json.decode(response.body)['error'];
      return ApiData.error(error: error ?? 'Failed to fetch failed uploads.');
    }
  }


  @override
  Future<ApiData<bool>> addFailedUpload(FailedUploadData data) async {
    // TODO: Implement API request to add a failed upload
    throw UnimplementedError();
  }
}
