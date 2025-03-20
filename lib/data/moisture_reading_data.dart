import 'package:intl/intl.dart';

class MoistureReadingData {
  final double moisture1;
  final double moisture2;
  final double moisture3;
  final DateTime dateTime;
  final double temperature;

  MoistureReadingData({
    required this.moisture1,
    required this.moisture2,
    required this.moisture3,
    required this.dateTime,
    required this.temperature,
  });

  // Factory constructor for creating a new MoistureReadingData instance from a map.
  factory MoistureReadingData.fromJson(Map<String, dynamic> json) {
    return MoistureReadingData(
      moisture1: json['moisture1'] as double,
      moisture2: json['moisture2'] as double,
      moisture3: json['moisture3'] as double,
      dateTime: DateTime.parse(json['time'] as String).toLocal(), // Convert to UTC
      temperature: json['temperature'] as double,
    );
  }

  // Method to convert a MoistureReadingData instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'moisture1': moisture1,
      'moisture2': moisture2,
      'moisture3': moisture3,
      'time': dateTime.toIso8601String(),
      'temperature': temperature,
    };
  }

  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();
}
