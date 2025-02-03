import 'package:http/http.dart' as http;

import 'base.dart';

class DevicesServices extends ServicesBase{

  // void writeToFirestore(String collection, Map<String, dynamic> data) async {
  //   // Firebase Firestore endpoint URL
  //   final String url = '$baseUrl$collection';
  //
  //   // The data to be sent as a request body
  //   final Map<String, dynamic> body = {
  //     'fields': data.map((key, value) {
  //       return MapEntry(key, {'stringValue': value.toString()});
  //     }),
  //   };
  //
  //   // Sending POST request to Firestore
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Optional if using service account credentials
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode(body),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Document successfully written!');
  //   } else {
  //     print('Failed to write document: ${response.body}');
  //   }
  // }


  // Working
  Future<bool> test() async {
    print("base = $baseUrl");
    try {
      final url = Uri.parse('$baseUrl/devices/hpAqEtLkFejGUA3tYBcT');
      print('URL = $url');
      final a = http.Request('GET', url);
      final response = await http.get(url);

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on http.ClientException catch (e) {
      print('HTTP client exception occurred: ${e.toString()}');
      return false;
    } catch (e) {
      print('Error! ${e.toString()}');
      return false;
    }
  }
}
