

import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/data/photos_data.dart';

import '../../data/api_data.dart';
import '../flask_api.dart';
import 'package:http/http.dart' as http;

abstract class IPhotosApi extends FlaskApi {
  Future<ApiData<List<PhotosData>>> getAll(String deviceId);
}

class PhotosApi extends IPhotosApi {
  @override
  Future<ApiData<List<PhotosData>>> getAll(String deviceId)  async {
    try {
      // Construct the URL for the GET request.
      final client = http.Client();
      final url = Uri.parse('$baseUrl/photos/$deviceId');
      print("Getting $url");
      // Make the GET request.
      final response = await client.get(url);
      print("response = $response");

      // Check if the request was successful.
      if (response.statusCode == 200) {
        print("statusCode = ${response.statusCode}");
        // Decode the JSON response.
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the list of photos from the response data.
        final List<dynamic> photosJson = responseData['photos'];

        // Map the JSON data to a list of PhotosData objects.
        final List<PhotosData> photos = photosJson
            .map((json) => PhotosData.fromJson(json))
            .toList();

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

}