// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz0PDDPYMP5s7V_wtFWrw1Q13WOkqs-6I',
    appId: '1:607122083711:android:2de6703ce118630ba2144a',
    messagingSenderId: '607122083711',
    projectId: 'salaama-school-app',
    storageBucket: 'salaama-school-app.firebasestorage.app',
  );
}