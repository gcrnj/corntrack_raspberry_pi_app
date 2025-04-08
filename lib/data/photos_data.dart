class PhotosData {
  final String contentType;
  final String creationTime;
  final CustomMetadata metaData;
  final String downloadUrl;
  final String fileName;
  final String fileSize;
  final String fileUrl;
  final String lastUpdated;
  final String date;

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
    return PhotosData(
      contentType: json['content_type'] as String,
      creationTime: json['creation_time'] as String,
      metaData: CustomMetadata.fromJson(json['custom_metadata']),
      downloadUrl: json['download_url'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as String,
      fileUrl: json['file_url'] as String,
      lastUpdated: json['last_updated'] as String,
      date: date,
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
}

class CustomMetadata {
  final String? deviceId;
  final String? growthStage;
  final String? healthStatus;
  final String? timestamp;

  CustomMetadata({
    required this.deviceId,
    required this.growthStage,
    required this.healthStatus,
    required this.timestamp,
  });

  // Factory constructor to create a CustomMetadata instance from JSON
  factory CustomMetadata.fromJson(Map<String, dynamic> json) {
    return CustomMetadata(
      deviceId: json['device_id'] as String?,
      growthStage: json['growth_stage'] as String?,
      healthStatus: json['health_status'] as String?,
      timestamp: json['timestamp'] as String?,
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
