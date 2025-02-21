
import 'package:intl/intl.dart';

class MoistureReadingData {
  MoistureReadingData({
    required this.moisture,
    required this.pot,
    required this.dateTime,
    this.temperature,
  });

  final String moisture;
  final String pot; // Pot field as a String (or you can choose to keep it as int or double if needed)
  final DateTime dateTime;
  final String? temperature;


  String formattedDate() => DateFormat('MMMM dd, yyyy').format(dateTime);
  String formattedTime() => DateFormat('hh:mma').format(dateTime).toLowerCase();


}