class DeviceDetails {
  final String deviceId;
  final String deviceName;
  final List<String> ownerId;

  DeviceDetails({required this.deviceId, required this.deviceName, required this.ownerId});

  // Factory constructor for creating a new DeviceDetails instance from a map.
  factory DeviceDetails.fromJson(Map<String, dynamic> json) {
    return DeviceDetails(
      deviceId: json['device_id'] as String,
      deviceName: json['deviceName'] as String,
      ownerId: (json['ownerId'] as List<dynamic>?)
          ?.map((e) => e.toString()) // Ensure all elements are Strings
          .toList() ?? [],
    );
  }

  // Method to convert a DeviceDetails instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'deviceName': deviceName,
      'ownerId': ownerId,
    };
  }
}
