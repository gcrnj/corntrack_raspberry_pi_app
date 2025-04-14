import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';

class FailedUploadData {
  final DateTime dateTime;
  final String? image;
  final FailedUploadDataType dataType;
  final double? moisture;
  final double? temperature;
  final double? humidity;
  final bool? waterDistributed;

  FailedUploadData({
    required this.dateTime,
    required this.dataType,
    this.image,
    this.moisture,
    this.temperature,
    this.humidity,
    this.waterDistributed,
  });

  Map<String, dynamic> toJson() => {
        'time': dateTime.toIso8601String(),
        'type': dataType.toString().split('.').last, // Ensure string format
        'file': image, // Only for photos
        'moisture': moisture,
        'temperature': temperature,
        'humidity': humidity,
        'water_distributed': waterDistributed,
      };

  factory FailedUploadData.photoFromJson(Map<String, dynamic> json) {
    return FailedUploadData(
      dateTime: DateTime.parse(json['time']),
      image: json['file']?.replaceAll('\\', '/').split('/').last,
      dataType: FailedUploadDataType.photo,
    );
  }

  factory FailedUploadData.soilMoistureFromJson(Map<String, dynamic> json) {
    return FailedUploadData(
      dateTime: DateTime.parse(json['time']),
      dataType: FailedUploadDataType.moisture,
      moisture: (json['moisture1'] ?? 0).toDouble(), // Adjusted to use moisture1
      temperature: json['temperature']?.toDouble(),
      humidity: ((json['humidity'] ?? json['humiidity'] ?? json['humidiity'])
                  as num?) // nullable cast
              ?.toDouble() ??
          0.0,
      // default value if still null
      waterDistributed: json['water_distributed'] ?? false,
    );
  }
}

enum FailedUploadDataType {
  photo,
  moisture,
  temperature,
  waterDistribution;

  String getDisplayName() {
    switch (this) {
      case FailedUploadDataType.photo:
        return 'Image';
      case FailedUploadDataType.moisture:
        return 'Soil Moisture';
      case FailedUploadDataType.temperature:
        return 'Temperature';
      case FailedUploadDataType.waterDistribution:
        return 'Water Distribution';
    }
  }
}
