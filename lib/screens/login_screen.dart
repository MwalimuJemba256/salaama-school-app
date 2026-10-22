import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'teacher_login_screen.dart';
import 'parent_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 180, height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                const Text("SALAAMA MUSLIM JUNIOR SCHOOL", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
                const SizedBox(height: 4),
                const Text("DESTINED TO SUCCEED", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600, letterSpacing: 1)),
                const SizedBox(height: 30),
                const Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
                const Text("Sign in to your account", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),

                // ADMIN BUTTON - NOW CLICKABLE
                SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1565C0), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.shield),
                    label: const Text("Admin Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // TEACHER BUTTON - NOW CLICKABLE
                SizedBox(
                  width: double.infinity, height: 55,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Color(0xFF2E7D32), side: BorderSide(color: Color(0xFF81C784)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.white),
                    icon: const Icon(Icons.person_search),
                    label: const Text("Teacher Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherLoginScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // PARENT BUTTON - NOW CLICKABLE
                SizedBox(
                  width: double.infinity, height: 55,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Color(0xFF1565C0), side: BorderSide(color: Color(0xFF90CAF9)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.white),
                    icon: const Icon(Icons.people),
                    label: const Text("Parent Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentLoginScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Need help? Contact school admin", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
