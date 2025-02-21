import 'package:intl/intl.dart';


class HourlyTemperatureData {

  final String temperature;
  final DateTime dateTime;

  HourlyTemperatureData({
    required this.temperature,
    required this.dateTime,
  });

  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();

}
