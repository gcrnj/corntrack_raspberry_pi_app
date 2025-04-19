import 'package:intl/intl.dart';

class PhotosData {
  final String contentType;
  final String creationTime;
  final CustomMetadata metaData;
  final String downloadUrl;
  final String fileName;
  final String fileSize;
  final String fileUrl;
  final String lastUpdated;
  final DateTime date;

  PhotosData({
    required this.contentType,
    required this.creationTime,
    required this.metaData,
    required this.downloadUrl,
    required this.fileName,
    required this.fileSize,
    required this.fileUrl,
    required this.lastUpdated,
    required this.date,
  });

  // Factory constructor to create a PhotosData instance from JSON
  factory PhotosData.fromJson(Map<String, dynamic> json, String date) {
    String fileName = (json['file_name'] as String).split('.')[0];

    List<String> timeParts = '$fileName-$date'.split('-');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    int year = int.parse(timeParts[3]);
    int month = int.parse(timeParts[4]);
    int day = int.parse(timeParts[5]);

    DateTime dateTime = DateTime(year, month, day, hour, minute, second);

    return PhotosData(
      contentType: json['content_type'] as String,
      creationTime: json['creation_time'] as String,
      metaData: CustomMetadata.fromJson(json['custom_metadata']),
      downloadUrl: json['download_url'] as String,
      fileName: fileName,
      fileSize: json['file_size'] as String,
      fileUrl: json['file_url'] as String,
      lastUpdated: json['last_updated'] as String,
      date: dateTime,
    );
  }

  // Method to convert a PhotosData instance to a map
  Map<String, dynamic> toJson() {
    return {
      'content_type': contentType,
      'creation_time': creationTime,
      'custom_metadata': metaData.toJson(),
      'download_url': downloadUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'file_url': fileUrl,
      'last_updated': lastUpdated,
    };
  }

  String parseDateTime() => DateFormat("MMMM d, y\nhh:mma").format(date);

  String parseDateOnly() => DateFormat("MMMM d, y").format(date);

  String parseTimeOnly() => DateFormat("hh:mma").format(date);
}

class CustomMetadata {
  final String? deviceId;
  final String? growthStage;
  final String? healthStatus;
  final DateTime? timestamp;
  final int? camera;

  CustomMetadata({
    required this.deviceId,
    required this.growthStage,
    required this.healthStatus,
    required this.timestamp,
    required this.camera,
  });

  // Factory constructor to create a CustomMetadata instance from JSON
  factory CustomMetadata.fromJson(Map<String, dynamic> json) {
    String timestamp = json['timestamp'] ?? ''; // e.g. "2025-03-25T14:10:00.040433Z"
    DateTime? parsedTime = DateTime.tryParse(timestamp)?.toUtc();
    String? camera = json['camera'];
    return CustomMetadata(
      deviceId: json['device_id'] as String?,
      growthStage: json['growth_stage'] as String?,
      healthStatus: json['health_status'] as String?,
      timestamp: parsedTime,
      camera: camera == null ? null : int.parse(camera),
    );
  }

  // Method to convert a CustomMetadata instance to a map
  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'growth_stage': growthStage,
      'health_status': healthStatus,
      'timestamp': timestamp,
    };
  }
}
