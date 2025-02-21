
import 'package:corntrack_raspberry_pi_app/api/water_distribution_api/water_distribution_api.dart';
import '../../data/api_data.dart';
import '../../data/water_distribution_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';

class DummyWaterDistributionApi extends IWaterDistributionApi {
  @override
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots) async {
    final potNumbers = selectedCornPots.map((e) => e.getNumber().toString()).toList();
    print('Pot numbers: ${potNumbers.join(' ')}');
    return ApiData.success(
        data: [
          WaterDistributionData(
              soilMoisture: '22.5',
              pot: '2',
              dateTime: DateTime.now(),
              temperature: '24'),
          WaterDistributionData(
              soilMoisture: '30.1',
              pot: '2',
              dateTime: DateTime.now(),
              temperature: '26'),
          WaterDistributionData(
              soilMoisture: '27.8',
              pot: '3',
              dateTime: DateTime.now(),
              temperature: '25'),
        ].where((element) => potNumbers.contains(element.pot)).toList());
  }
}
