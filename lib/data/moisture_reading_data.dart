
class MoistureReadingData {
  MoistureReadingData({
    required this.moisture,
    required this.pot,
    required this.time,
    this.temperature,
  });

  final String moisture;
  final String pot; // Pot field as a String (or you can choose to keep it as int or double if needed)
  final DateTime time;
  final String? temperature;

}