import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SalaamaApp());
}

class SalaamaApp extends StatelessWidget {
  const SalaamaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salaama Muslim Junior School',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}