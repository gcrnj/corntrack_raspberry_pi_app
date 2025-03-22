// Data model
import 'dart:convert';
import 'dart:typed_data';

class GraphData {
  final String conclusion;
  final String deviceId;
  final Uint8List graphImage;

  GraphData({
    required this.conclusion,
    required this.deviceId,
    required this.graphImage,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      conclusion: json['conclusion'],
      deviceId: json['device_id'],
      graphImage: base64Decode(json['graph_base64']),
    );
  }
}
