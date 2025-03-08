import 'package:intl/intl.dart';

class MoistureReadingData {
  final String moisture;
  final String pot;
  final DateTime dateTime;
  final String? temperature;

  MoistureReadingData({
    required this.moisture,
    required this.pot,
    required this.dateTime,
    this.temperature,
  });

  // Factory constructor for creating a new MoistureReadingData instance from a map.
  factory MoistureReadingData.fromJson(Map<String, dynamic> json) {
    return MoistureReadingData(
      moisture: json['moisture'] as String,
      pot: json['pot'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      temperature: json['temperature'] as String?,
    );
  }

  // Method to convert a MoistureReadingData instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'moisture': moisture,
      'pot': pot,
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
    };
  }

  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();
}
