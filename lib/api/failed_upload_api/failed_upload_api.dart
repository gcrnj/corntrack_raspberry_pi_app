import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import '../flask_api.dart';

abstract class IFailedUploadApi extends FlaskApi {
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads();

  Future<ApiData<bool>> addFailedUpload(FailedUploadData data);
}

class FailedUploadApi extends IFailedUploadApi {
  @override
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads() async {
    // TODO: Implement API request to fetch failed uploads
    throw UnimplementedError();
  }

  @override
  Future<ApiData<bool>> addFailedUpload(FailedUploadData data) async {
    // TODO: Implement API request to add a failed upload
    throw UnimplementedError();
  }
}
