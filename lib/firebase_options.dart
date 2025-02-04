import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for iOS.');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macOS.');
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Windows.');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Linux.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: ndotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: ndotenv.env['FIREBASE_APP_ID'] ?? '',
    messagingSenderId: ndotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
    projectId: ndotenv.env['FIREBASE_PROJECT_ID'] ?? '',
    storageBucket: ndotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
  );
}
