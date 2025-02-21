class WaterDistributionData {
  final String pot;
  final DateTime dateTime;
  final String soilMoisture;
  final String temperature;

  WaterDistributionData({
    required this.pot,
    required this.dateTime,
    required this.soilMoisture,
    required this.temperature,
  });

  factory WaterDistributionData.fromJson(Map<String, dynamic> json) {
    return WaterDistributionData(
      pot: json['pot'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      soilMoisture: json['soil_moisture'].toString(),
      temperature: json['temperature']?.toString() ?? '',
    );
  }

  String formattedDate() {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  String formattedTime() {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
