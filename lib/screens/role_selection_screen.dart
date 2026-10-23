import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'teacher_login_screen.dart';
import 'parent_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(65),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "SALAAMA MUSLIM\nJUNIOR SCHOOL",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Select Your Role", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            _roleCard(context, "ADMIN", Icons.admin_panel_settings, const Color(0xFF1565C0), const AdminLoginScreen()),
            _roleCard(context, "TEACHER", Icons.school, const Color(0xFF2E7D32), const TeacherLoginScreen()),
            _roleCard(context, "PARENT", Icons.family_restroom, const Color(0xFFEF6C00), const ParentLoginScreen()),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color, width: 2),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(13), bottomLeft: Radius.circular(13))),
                child: Icon(icon, color: Colors.white, size: 35),
              ),
              const SizedBox(width: 20),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: color),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}