import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try Firebase, but don't crash if fails - Fixes white screen!
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("⚠️ Firebase failed but app will continue: $e");
  }
  
  runApp(const SalaamaApp());
}

class SalaamaApp extends StatelessWidget {
  const SalaamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salaama Muslim Junior School',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D6FB7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D6FB7)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // Always show login, never white screen
      home: const LoginScreen(),
    );
  }
}
