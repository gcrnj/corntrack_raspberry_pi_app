// Everything in this file are the keys needed for .env
import 'package:flutter/cupertino.dart';

const firebaseApiUrl = 'FIREBASE_API_URL';
const firebaseApiKey = 'FIREBASE_API_KEY';
const firebaseApiPass = 'FIREBASE_API_PASS';

abstract class ServicesBase {

  @protected
  late final String baseUrl;


  ServicesBase() {
    baseUrl = 'http://192.168.254.104:5000'; // Initialize baseUrl with the value from dotenv or an empty string
  }

  bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 || statusCode <= 299;
  }
}

