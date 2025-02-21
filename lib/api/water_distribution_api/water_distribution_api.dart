import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';
import '../../data/api_data.dart';
import '../../data/water_distribution_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';


abstract class IWaterDistributionApi extends FlaskApi {
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots);
}

class WaterDistributionApi extends IWaterDistributionApi {
  @override
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots) {
    // TODO: Implement actual API call
    throw UnimplementedError();
  }
}
