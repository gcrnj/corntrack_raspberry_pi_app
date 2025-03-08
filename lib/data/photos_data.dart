class PhotosData {
  final String refId;
  final String path;
  final DateTime dateTime;

  PhotosData(this.refId, {required this.path, required this.dateTime});

  // Factory constructor for creating a new PhotosData instance from a map.
  factory PhotosData.fromJson(Map<String, dynamic> json) {
    return PhotosData(
      json['refId'] as String,
      path: (json['path'] as String).replaceAll('%', '/'),
      dateTime: DateTime.parse(json['time'] as String),
    );
  }

  // Method to convert a PhotosData instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'refId': refId,
      'path': path,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
