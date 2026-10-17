import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/theme_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase not configured yet: $e");
  }
  runApp(SalaamaApp());
}

class SalaamaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SALAAMA MUSLIM JUNIOR SCHOOL',
      theme: ThemeData(
        primaryColor: Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}