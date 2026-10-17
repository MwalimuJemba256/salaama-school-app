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
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
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
            Image.asset('assets/images/logo.png', width: 180, height: 180),
            SizedBox(height: 20),
            Text("SALAAMA MUSLIM\nJUNIOR SCHOOL",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              color: Color(0xFF8BC34A),
              child: Text("DESTINED TO SUCCEED", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Color(0xFF2196F3)),
          ],
        ),
      ),
    );
  }
}