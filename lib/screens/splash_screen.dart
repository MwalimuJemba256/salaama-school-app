import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoleSelectionScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // YOUR REAL LOGO - from assets/images/logo.png
            Image.asset(
              'assets/images/logo.png',
              width: 320,
              fit: BoxFit.contain,
              errorBuilder: (c,e,s) => Icon(Icons.school, size: 120, color: Color(0xFF0B6DB0)),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(true), SizedBox(width: 8),
                _dot(true), SizedBox(width: 8),
                _dot(false),
              ],
            ),
            SizedBox(height: 12),
            Text("Loading...", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFF0B6DB0),
        alignment: Alignment.center,
        child: Text(
          "Salaama Muslim Junior School App • Support: support@salaamaschool.com • Version 1.0.0",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 9.5),
        ),
      ),
    );
  }

  Widget _dot(bool active) => Container(
    width: 10, height: 10,
    decoration: BoxDecoration(color: active ? Color(0xFF0B6DB0) : Color(0xFFCFD8DC), shape: BoxShape.circle),
  );
}