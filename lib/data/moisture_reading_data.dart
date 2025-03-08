import 'package:intl/intl.dart';

class MoistureReadingData {
  final double moisture;
  final int pot;
  final DateTime dateTime;
  final double temperature;

  MoistureReadingData({
    required this.moisture,
    required this.pot,
    required this.dateTime,
    required this.temperature,
  });

  // Factory constructor for creating a new MoistureReadingData instance from a map.
  factory MoistureReadingData.fromJson(Map<String, dynamic> json) {
    return MoistureReadingData(
      moisture: json['moisture'] as double,
      pot: json['pot'] as int,
      dateTime: DateTime.parse(json['time'] as String).toLocal(), // Convert to UTC
      temperature: json['temperature'] as double,
    );
  }

  // Method to convert a MoistureReadingData instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'moisture': moisture,
      'pot': pot,
      'time': dateTime.toIso8601String(),
      'temperature': temperature,
    };
  }

  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();
}
