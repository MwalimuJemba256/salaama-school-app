import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_dashboard.dart';
import 'teacher_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? verificationId;
  bool codeSent = false;
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 100),
            SizedBox(height: 20),
            Text("Login with Job Application Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone e.g +256700000001", border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),
            if (codeSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: "Enter OTP", border: OutlineInputBorder()),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2196F3), minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                if (!codeSent) {
                  // For testing without Firebase, go directly
                  // In production, use auth.verifyPhone
                  try {
                    await auth.verifyPhone(phoneController.text, (vid) {
                      setState(() {
                        verificationId = vid;
                        codeSent = true;
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP Sent")));
                  } catch (e) {
                    // If Firebase not configured, allow demo login
                    _navigateByRole();
                  }
                } else {
                  // Verify OTP
                  try {
                    await auth.signInWithOTP(verificationId!, otpController.text);
                    _navigateByRole();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                }
              },
              child: Text(codeSent ? "Verify OTP" : "Send OTP", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () => _navigateByRole(isDemo: true),
              child: Text("Demo Login (No Firebase)"),
            )
          ],
        ),
      ),
    );
  }

  void _navigateByRole({bool isDemo = false}) async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) phone = "+256700000001";

    if (isDemo) {
      // Demo: If phone ends with 1 -> Admin, else Teacher
      if (phone.contains("000001")) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TeacherHome(teacherPhone: phone, teacherName: "Demo Teacher")));
      }
      return;
    }

    var result = await auth.getUserRole(phone);
    if (result == null) {
      // For new setup, default to admin if first user
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
    } else if (result['role'] == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TeacherHome(teacherPhone: phone, teacherName: result['data']['name'] ?? "Teacher")));
    }
  }
}