import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'parent_dashboard_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            // REAL LOGO
            Image.asset(
              'assets/images/logo.png',
              width: 240,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Icon(Icons.school, size: 100, color: Color(0xFF0D47A1)),
            ),
            SizedBox(height: 10),
            Text("SALAAMA MUSLIM", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1))),
            Text("JUNIOR SCHOOL APP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            Container(
              margin: EdgeInsets.only(top: 6),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: Color(0xFF66BB6A), borderRadius: BorderRadius.circular(20)),
              child: Text("DESTINED TO SUCCEED", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            ),
            SizedBox(height: 30),
            Text("Select Your Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _roleCard(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: "Admin",
                      subtitle: "Dashboard • Fees • Reports • PDF Generator • Tahfiizu",
                      color: Color(0xFF0D47A1),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen())),
                    ),
                    SizedBox(height: 14),
                    _roleCard(
                      context,
                      icon: Icons.school,
                      title: "Teacher",
                      subtitle: "Secular: Nursery-P7 | Theology: Nursery-P7 | Tahfiizu: No Classes (Darsu/Sitta/Muraaji'a)",
                      color: Color(0xFF2E7D32),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherDashboardScreen())),
                    ),
                    SizedBox(height: 14),
                    _roleCard(
                      context,
                      icon: Icons.family_restroom,
                      title: "Parent",
                      subtitle: "My Child • Fees Balance • Results • Attendance • Chat • Media",
                      color: Color(0xFFEF6C00),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentDashboardScreen())),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text("Salaama Muslim Junior School © 2026\nFor Support: nassakalatiffah@gmail.com | +256 702 642 786", textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3), width: 1.5), boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 4))]),
        child: Row(
          children: [
            Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
            SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
              ]),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}