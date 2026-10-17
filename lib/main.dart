import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() { runApp(MyApp()); }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salaama Muslim Junior School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF0D4DA1), fontFamily: 'Roboto'),
      home: SplashScreen(),
    );
  }
}

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFFE8F5E9), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160, height: 160,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0,8))]),
                child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover, errorBuilder: (c,e,s) => Icon(Icons.school, size: 80, color: Color(0xFF0D4DA1)))),
              ),
              SizedBox(height: 30),
              Text('SALAAMA MUSLIM\nJUNIOR SCHOOL', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0D2A54), height: 1.2)),
              SizedBox(height: 10),
              Text('DESTINED TO SUCCEED', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), letterSpacing: 1.5)),
              SizedBox(height: 50),
              CircularProgressIndicator(color: Color(0xFF0D4DA1)),
            ],
          ),
        ),
      ),
    );
  }
}
