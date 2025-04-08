import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/data/photos_data.dart';

import '../../data/api_data.dart';
import '../flask_api.dart';
import 'package:http/http.dart' as http;

abstract class IPhotosApi extends FlaskApi {
  Future<ApiData<List<PhotosData>>> getAll(String deviceId);

  Future<void> postNewPhoto(String deviceId);
}

class PhotosApi extends IPhotosApi {
  @override
  Future<ApiData<List<PhotosData>>> getAll(String deviceId) async {
    try {
      // Construct the URL for the GET request.
      final url = Uri.parse('$baseUrl/photos/$deviceId/list-files');
      print("Getting $url");
      // Make the GET request.
      final response = await http.get(url);
      print("response = $response");

      // Check if the request was successful.
      if (response.statusCode == 200) {
        print("statusCode = ${response.statusCode}");

        final Map<String, dynamic> responseData = json.decode(response.body);

        final Map<String, dynamic> photosByDate = responseData['photos'];


        final List<PhotosData> photos = [];

        photosByDate.forEach((date, photosList) {
          for (var photoJson in photosList) {
            photos.add(PhotosData.fromJson(photoJson, date));
          }
        });
        // Return the list wrapped in ApiData.
        return ApiData.success(data: photos);
      } else {
        // Handle non-200 status codes.
        return ApiData.error(
            error: 'Failed to load photos: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request.
      return ApiData.error(error: 'An error occurred: $e');
    }
  }

  @override
  Future<void> postNewPhoto(String deviceId) async {
    try {
      // Construct the URL for the GET request.
      final url = Uri.parse('$baseUrl/photos/$deviceId/capture');
      print("Getting $url");
      // Make the GET request.
      final response = await http.get(url);
      print(
          'postNewPhoto - ${response.statusCode} - ${response.body} - ${response.reasonPhrase}');
    } catch (e) {
      // Handle any exceptions that occur during the request.
      print('postNewPhoto Error - $e');
    }
  }
}
