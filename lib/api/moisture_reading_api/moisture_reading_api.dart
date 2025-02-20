
import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';

import '../../data/api_data.dart';
import '../../data/hourly_temperature_data.dart';
import '../../data/moisture_reading_data.dart';

abstract class IMoistureReadingApi extends FlaskApi {
  Future<ApiData<List<MoistureReadingData>>> getAll();
  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(DateTime start, DateTime end);
  Future<ApiData<bool>> add(Map<dynamic, dynamic> body);

}

class MoistureReadingApi extends IMoistureReadingApi {
  @override
  Future<ApiData<bool>> add(Map<dynamic, dynamic> body) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<ApiData<List<MoistureReadingData>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiData<List<HourlyTemperatureData>>> getHourlyTemperature(DateTime start, DateTime end) {
    // TODO: implement getHourlyTemperature
    throw UnimplementedError();
  }

}