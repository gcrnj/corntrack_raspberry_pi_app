import 'package:intl/intl.dart';

class HourlyTemperatureData {
  final String temperature;
  final DateTime dateTime;

  HourlyTemperatureData({
    required this.temperature,
    required this.dateTime,
  });

  // Factory constructor for creating a new HourlyTemperatureData instance from a map.
  factory HourlyTemperatureData.fromJson(Map<String, dynamic> json) {
    return HourlyTemperatureData(
      temperature: json['temperature'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  // Method to convert an HourlyTemperatureData instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();
}
