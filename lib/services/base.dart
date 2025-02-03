// Everything in this file are the keys needed for .env


import 'package:flutter_dotenv/flutter_dotenv.dart';

const firebaseApiUrl = 'FIREBASE_API_URL';
const firebaseApiKey = 'FIREBASE_API_KEY';
const firebaseApiPass = 'FIREBASE_API_PASS';

abstract class ServicesBase {

  late final String baseUrl;


  ServicesBase() {
    baseUrl = dotenv.env[firebaseApiUrl] ?? ''; // Initialize baseUrl with the value from dotenv or an empty string
  }
}

