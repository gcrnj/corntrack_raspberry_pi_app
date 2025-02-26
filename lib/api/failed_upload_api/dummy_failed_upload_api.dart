import '../../data/api_data.dart';
import '../../data/failed_upload_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import 'failed_upload_api.dart';

class DummyFailedUploadApi extends IFailedUploadApi {
  final List<FailedUploadData> _dummyData = [
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      image: 'image_2.png',
      dataType: FailedUploadDataType.image,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      pot: Pots.pot1,
      dataType: FailedUploadDataType.moisture,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      pot: Pots.pot2,
      dataType: FailedUploadDataType.moisture,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      pot: Pots.pot1,
      dataType: FailedUploadDataType.temperature,
    ),
    FailedUploadData(
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      pot: Pots.pot1,
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
