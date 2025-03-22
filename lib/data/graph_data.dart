// Data model
import 'dart:convert';
import 'dart:typed_data';

class GraphData {
  final String conclusion;
  final String deviceId;
  final Uint8List graphImage;
  final String potMoistureNumber;

  GraphData({
    required this.conclusion,
    required this.deviceId,
    required this.graphImage,
    required this.potMoistureNumber,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      conclusion: json['conclusion'] ?? 'No conclusion available',
      deviceId: json['device_id'] ?? 'Unknown',
      graphImage: base64Decode(json['graph_base64'] ?? ''),
      potMoistureNumber: (json['moisture_id'] ?? '').toString().replaceAll('moisture', ''),
    );
  }
}

