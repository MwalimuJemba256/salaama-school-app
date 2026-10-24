// File generated for Salaama School App
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz0PDDPYMP5s7V_wtFWrw1Q13WOkqs-6I',
    appId: '1:607122083711:android:f5e79d3b07407273a2144a',
    messagingSenderId: '607122083711',
    projectId: 'salaama-school-app',
    storageBucket: 'salaama-school-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBz0PDDPYMP5s7V_wtFWrw1Q13WOkqs-6I',
    appId: '1:607122083711:android:f5e79d3b07407273a2144a',
    messagingSenderId: '607122083711',
    projectId: 'salaama-school-app',
    storageBucket: 'salaama-school-app.firebasestorage.app',
    iosBundleId: 'com.salaama.schoolapp',
  );
}
