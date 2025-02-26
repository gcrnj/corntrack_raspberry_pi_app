import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';

class FailedUploadData {
  final DateTime dateTime;
  final String? image;
  final FailedUploadDataType dataType;
  final Pots? pot;

  FailedUploadData({
    required this.dateTime,
    required this.dataType,
    this.image,
    this.pot,
  });

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'image': image,
        'dataType': dataType,
        'pot': pot?.getNumber().toString() ?? '',
      };



  factory FailedUploadData.fromJson(Map<String, dynamic> json) {
    return FailedUploadData(
      dateTime: DateTime.parse(json['dateTime']),
      image: json['image'],
      dataType: FailedUploadDataType.values
          .firstWhere((t) => t.toString() == json['dataType']),
      pot: Pots.values
          .firstWhere((p) => p.getNumber().toString() == json['pot']),
    );
  }
}

enum FailedUploadDataType {
  image,
  moisture,
  temperature,
  waterDistribution;

  String getDisplayName() {
    switch(this) {
      case FailedUploadDataType.image:
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
