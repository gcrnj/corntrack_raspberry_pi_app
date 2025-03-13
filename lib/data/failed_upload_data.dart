import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';

class FailedUploadData {
  final DateTime dateTime;
  final String? image;
  final FailedUploadDataType dataType;
  final Pots? pot;
  final double? moisture;
  final double? temperature;
  final double? humidity;
  final bool? waterDistributed;

  FailedUploadData({
    required this.dateTime,
    required this.dataType,
    this.image,
    this.pot,
    this.moisture,
    this.temperature,
    this.humidity,
    this.waterDistributed,
  });

  Map<String, dynamic> toJson() => {
    'time': dateTime.toIso8601String(),
    'type': dataType.toString().split('.').last, // Ensure string format
    'file': image, // Only for photos
    'pot': pot?.getNumber().toString(),
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
      pot: Pots.values.firstWhere(
            (p) => p.getNumber().toString() == json['pot'].toString(),
      ),
      moisture: json['moisture']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      humidity: json['humidity']?.toDouble(),
      waterDistributed: json['water_distributed'],
    );
  }
}


enum FailedUploadDataType {
  photo,
  moisture,
  temperature,
  waterDistribution;

  String getDisplayName() {
    switch(this) {
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
