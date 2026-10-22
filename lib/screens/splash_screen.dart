import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF90CAF9)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 180, height: 180, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), padding: EdgeInsets.all(10), child: Image.asset('assets/images/logo.png')),
            SizedBox(height: 20),
            Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
        ),
      ),
    );
  }
}
