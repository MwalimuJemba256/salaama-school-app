import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    
    // Different titles based on role
    String appBarTitle = "Salaama $role";
    Color appColor = const Color(0xFF0D47A1);
    if (role == "Teacher") appColor = const Color(0xFF2E7D32);
    if (role == "Parent") appColor = const Color(0xFF6A1B9A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(appBarTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: appColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome $role!", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(userEmail, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_getWelcomeMessage(), style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("$role Dashboard", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: _getCardsForRole(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getWelcomeMessage() {
    if (role == "Admin") return "SALAAMA MUSLIM JUNIOR SCHOOL - Full Control";
    if (role == "Teacher") return "Manage your classes, attendance & marks";
    return "View your children's progress, fees & results";
  }

  List<Widget> _getCardsForRole(BuildContext context) {
    if (role == "Admin") {
      return [
        _card(context, Icons.people, "Students", "450", Colors.blue),
        _card(context, Icons.school, "Teachers", "25", Colors.green),
        _card(context, Icons.payments, "Fees", "UGX", Colors.purple),
        _card(context, Icons.settings, "Settings", "App", Colors.grey),
      ];
    } else if (role == "Teacher") {
      return [
        _card(context, Icons.class_, "My Classes", "P5, P6", Colors.green),
        _card(context, Icons.fact_check, "Attendance", "Mark", Colors.teal),
        _card(context, Icons.quiz, "Enter Marks", "Exams", Colors.orange),
        _card(context, Icons.chat, "Messages", "Parents", Colors.blue),
      ];
    } else { // Parent
      return [
        _card(context, Icons.child_care, "My Children", "View", Colors.purple),
        _card(context, Icons.receipt, "Fees Status", "Paid", Colors.green),
        _card(context, Icons.grading, "Results", "Term 2", Colors.indigo),
        _card(context, Icons.calendar_today, "Timetable", "P5", Colors.orange),
      ];
    }
  }

  Widget _card(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title - Coming Soon"))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
