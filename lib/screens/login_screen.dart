import 'package:flutter/material.dart';

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
            colors: [Color(0xFF90BFEF), Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 170, height: 170,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)),
                ),
                const SizedBox(height: 20),
                const Text("SALAAMA MUSLIM\nJUNIOR SCHOOL", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0D2A54))),
                const SizedBox(height: 6),
                const Text("DESTINED TO SUCCEED", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF4CAF50), letterSpacing: 1.5)),
                const SizedBox(height: 26),
                const Text("Welcome Back", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
                const Text("Sign in to your account", style: TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 26),

                // ADMIN
                SizedBox(width: double.infinity, height: 54,
                  child: ElevatedButton.icon(icon: const Icon(Icons.shield, color: Colors.white), label: const Text("Admin Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1565C0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    onPressed: () => Navigator.pushNamed(context, '/admin_login'))),
                const SizedBox(height: 14),
                // TEACHER
                SizedBox(width: double.infinity, height: 54,
                  child: OutlinedButton.icon(icon: const Icon(Icons.co_present, color: Color(0xFF2E7D32)), label: const Text("Teacher Login", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 16)),
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFF81C784), width: 1.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    onPressed: () => Navigator.pushNamed(context, '/teacher_login'))),
                const SizedBox(height: 14),
                // PARENT - 3rd BUTTON
                SizedBox(width: double.infinity, height: 54,
                  child: OutlinedButton.icon(icon: const Icon(Icons.family_restroom, color: Color(0xFF1565C0)), label: const Text("Parent Login", style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 16)),
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFF64B5F6), width: 1.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    onPressed: () => Navigator.pushNamed(context, '/parent_login'))),
                const SizedBox(height: 20),
                const Text("Need help? Contact school admin", style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
