// Everything in this file are the keys needed for .env
const firebaseApiUrl = 'FIREBASE_API_URL';
const firebaseApiKey = 'FIREBASE_API_KEY';
const firebaseApiPass = 'FIREBASE_API_PASS';

abstract class ServicesBase {

  late final String baseUrl;


  ServicesBase() {
    baseUrl = 'https://firestore.googleapis.com/v1/projects/project-corntrack/databases/(default)/documents'; // Initialize baseUrl with the value from dotenv or an empty string
  }
}

