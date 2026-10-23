import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'admin/students_screen.dart';
import 'admin/teachers_screen.dart';
import 'admin/classes_screen.dart';
import 'admin/tahfiizu_screen.dart';
import 'admin/fees_screen.dart';
import 'admin/attendance_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;
  const DashboardScreen({super.key, this.role = "Admin"});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "Admin";
    Color appColor = const Color(0xFF0D47A1);
    if (role == "Teacher") appColor = const Color(0xFF2E7D32);
    if (role == "Parent") appColor = const Color(0xFF6A1B9A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Salaama $role", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Text("DESTINED TO SUCCEED", style: TextStyle(fontSize: 10))]),
        backgroundColor: appColor, foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { await FirebaseAuth.instance.signOut(); if (!context.mounted) return; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); })],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [appColor, appColor.withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Assalamu Alaikum!", style: TextStyle(color: Colors.white70)), Text(userEmail, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))])),
            const SizedBox(height: 20),
            Text("$role Management", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.25, children: _getCardsForRole(context)),
            const SizedBox(height: 20),
            const Center(child: Text("© 2026 Salaama Muslim Junior School", style: TextStyle(color: Colors.grey, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  List<Widget> _getCardsForRole(BuildContext context) {
    return [
      _buildCard(context, Icons.people, "Students", "450 Students", Colors.blue),
      _buildCard(context, Icons.school, "Teachers", "25 Teachers", Colors.green),
      _buildCard(context, Icons.class_, "Classes", "Baby to P7", Colors.orange),
      _buildCard(context, Icons.menu_book, "Tahfiizu", "Quran", const Color(0xFF00695C)),
      _buildCard(context, Icons.payments, "Fees", "Payments", Colors.purple),
      _buildCard(context, Icons.fact_check, "Attendance", "95%", Colors.teal),
      _buildCard(context, Icons.quiz, "Exams", "Results", Colors.red),
      _buildCard(context, Icons.campaign, "Notice", "News", Colors.indigo),
    ];
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == "Students") Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentsScreen()));
        else if (title == "Teachers") Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachersScreen()));
        else if (title == "Classes") Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassesScreen()));
        else if (title == "Tahfiizu") Navigator.push(context, MaterialPageRoute(builder: (_) => const TahfiizuScreen()));
        else if (title == "Fees") Navigator.push(context, MaterialPageRoute(builder: (_) => const FeesScreen()));
        else if (title == "Attendance") Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title Coming Soon!"), backgroundColor: color));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 28)), const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600))]),
      ),
    );
  }
}
