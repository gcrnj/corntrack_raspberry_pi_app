import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import 'failed_upload_api.dart';

class DummyFailedUploadApi extends IFailedUploadApi {
  final List<FailedUploadData> _dummyData = [
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      image: 'image_2.png',
      dataType: FailedUploadDataType.photo,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      dataType: FailedUploadDataType.moisture,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      dataType: FailedUploadDataType.moisture,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      dataType: FailedUploadDataType.temperature,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      dataType: FailedUploadDataType.moisture,
    ),
  ];

  @override
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads(String? deviceId) async {
    return ApiData.success(data: List.empty());
    return ApiData.success(data: _dummyData);
  }

  @override
  Future<ApiData<bool>> addFailedUpload(FailedUploadData data) async {
    _dummyData.add(data);
    return ApiData.success(data: true);
  }

  @override
  Future<ApiData<String>> manualUpload(String deviceId) async {
    return ApiData.success(data: 'success');
  }
}
