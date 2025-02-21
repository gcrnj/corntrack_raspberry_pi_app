import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import 'failed_upload_api.dart';

class DummyFailedUploadApi extends IFailedUploadApi {
  final List<FailedUploadData> _dummyData = [
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      image: 'image_2.png',
      dataType: null,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      dataType: FailedUploadDataType.moisture,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      image: 'image_1.png',
      dataType: FailedUploadDataType.moisture,
    ),
  ];

  @override
  Future<ApiData<List<FailedUploadData>>> getAllFailedUploads() async {
    return ApiData.success(data: _dummyData);
  }

  @override
  Future<ApiData<bool>> addFailedUpload(FailedUploadData data) async {
    _dummyData.add(data);
    return ApiData.success(data: true);
  }
}
