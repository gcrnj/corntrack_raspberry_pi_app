import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/services/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/prefsKeys.dart';

import 'package:http/http.dart' as http;

class MoistureReadingModel {
  MoistureReadingModel({
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

class MoistureReadingServices extends ServicesBase {

  Future<List<MoistureReadingModel>> getAll() async {
    return List.empty();
  }

  Future<bool> add(Map<dynamic, dynamic> body) async {
    return false;
  }


}
