import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D6EFD), Color(0xFFFFF8E1), Color(0xFF7AC74F)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ", style: TextStyle(fontSize: 22, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Image.asset("assets/images/logo.png", height: 120), color: Color(0xFF0B3D91)),
            Text("SALAAMA MUSLIM\nJUNIOR SCHOOL", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0B3D91))),
            Text("DESTINED TO SUCCEED", style: TextStyle(letterSpacing: 3, color: Color(0xFF0B3D91))),
            SizedBox(height: 50),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("nassakalatiifah@gmail.com | 0702642786", style: TextStyle(fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}