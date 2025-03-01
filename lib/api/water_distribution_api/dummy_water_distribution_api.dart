import 'package:corntrack_raspberry_pi_app/api/water_distribution_api/water_distribution_api.dart';
import '../../data/api_data.dart';
import '../../data/water_distribution_data.dart';
import '../../screens/dashboard/dashboard_screen.dart';

class DummyWaterDistributionApi extends IWaterDistributionApi {
  @override
  Future<ApiData<List<WaterDistributionData>>> getWaterDistributionData(
      DateTime start, DateTime end, List<Pots> selectedCornPots) async {
    final potNumbers =
        selectedCornPots.map((e) => e.getNumber().toString()).toList();
    print('Pot numbers: ${potNumbers.join(' ')}');
    return ApiData.success(
        data: [
          WaterDistributionData(
              soilMoisture: '22.5',
              pot: '2',
              dateTime: DateTime(2025, 2, 27, 1, 5, 0),
              temperature: '24'
          ),
          WaterDistributionData(
              soilMoisture: '30.1',
              pot: '2',
              dateTime: DateTime(2025, 2, 27, 5, 57, 0),
              temperature: '26'
          ),
          WaterDistributionData(
              soilMoisture: '27.8',
              pot: '3',
              dateTime: DateTime(2025, 2, 27, 7, 30, 0),
              temperature: '25'
          ),
          WaterDistributionData(
              soilMoisture: '19.4',
              pot: '1',
              dateTime: DateTime(2025, 2, 27, 9, 15, 0),
              temperature: '23'
          ),
          WaterDistributionData(
              soilMoisture: '28.6',
              pot: '2',
              dateTime: DateTime(2025, 2, 27, 11, 0, 0),
              temperature: '27'
          ),
          WaterDistributionData(
              soilMoisture: '33.3',
              pot: '3',
              dateTime: DateTime(2025, 2, 27, 12, 6, 0),
              temperature: '28'
          )
        ].where((element) => potNumbers.contains(element.pot)).toList());
  }
}
