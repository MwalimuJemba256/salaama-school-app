import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salaama $role", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text("DESTINED TO SUCCEED", style: TextStyle(fontSize: 10, letterSpacing: 1)),
          ],
        ),
        backgroundColor: appColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(userEmail.isNotEmpty ? userEmail[0].toUpperCase() : "A", style: TextStyle(color: appColor, fontWeight: FontWeight.bold)),
            ),
          ),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [appColor, appColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Assalamu Alaikum!", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(userEmail, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(role == "Admin" ? "SALAAMA MUSLIM JUNIOR SCHOOL" : role == "Teacher" ? "Teacher Portal" : "Parent Portal", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(_getWelcomeMessage(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("$role Management", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: _getCardsForRole(context),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check_circle, color: Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Logged in as $role", style: const TextStyle(fontWeight: FontWeight.bold)), const Text("Firebase Connected", style: TextStyle(fontSize: 12, color: Colors.grey))])),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("© 2026 Salaama Muslim Junior School\nDESTINED TO SUCCEED", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  String _getWelcomeMessage() {
    if (role == "Admin") return "Admin Dashboard - Manage Everything";
    if (role == "Teacher") return "Manage your classes, attendance & marks";
    return "View your children's progress, fees & results";
  }

  List<Widget> _getCardsForRole(BuildContext context) {
    if (role == "Admin") {
      return [
        _buildCard(context, Icons.people, "Students", "450 Students", Colors.blue, "Manage students"),
        _buildCard(context, Icons.school, "Teachers", "25 Teachers", Colors.green, "Staff management"),
        _buildCard(context, Icons.class_, "Classes", "P1 - P7", Colors.orange, "Class & sections"),
        _buildCard(context, Icons.payments, "Fees", "UGX Collected", Colors.purple, "Fees & payments"),
        _buildCard(context, Icons.fact_check, "Attendance", "Today: 95%", Colors.teal, "Daily attendance"),
        _buildCard(context, Icons.quiz, "Exams", "Term 2 Results", Colors.red, "Marks & reports"),
        _buildCard(context, Icons.campaign, "Notice", "Announcements", Colors.indigo, "School notices"),
        _buildCard(context, Icons.settings, "Settings", "App Settings", Colors.grey, "School settings"),
      ];
    } else if (role == "Teacher") {
      return [
        _buildCard(context, Icons.class_, "My Classes", "P5, P6", Colors.green, "Your classes"),
        _buildCard(context, Icons.fact_check, "Attendance", "Mark Today", Colors.teal, "Mark attendance"),
        _buildCard(context, Icons.quiz, "Enter Marks", "Exams", Colors.orange, "Enter exam marks"),
        _buildCard(context, Icons.people, "My Students", "120 Students", Colors.blue, "View students"),
        _buildCard(context, Icons.campaign, "Notice", "Announcements", Colors.indigo, "School notices"),
        _buildCard(context, Icons.chat, "Messages", "Parents", Colors.purple, "Chat with parents"),
      ];
    } else {
      return [
        _buildCard(context, Icons.child_care, "My Children", "View Profile", Colors.purple, "Children info"),
        _buildCard(context, Icons.receipt, "Fees Status", "Paid / Due", Colors.green, "Fees & payments"),
        _buildCard(context, Icons.grading, "Results", "Term 2", Colors.indigo, "Exam results"),
        _buildCard(context, Icons.calendar_today, "Timetable", "P5 Timetable", Colors.orange, "Class timetable"),
        _buildCard(context, Icons.fact_check, "Attendance", "95% Present", Colors.teal, "Attendance report"),
        _buildCard(context, Icons.campaign, "Notice", "School News", Colors.blue, "Announcements"),
      ];
    }
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String subtitle, Color color, String desc) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title - Coming Soon! InshaAllah"), backgroundColor: color)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 28)),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
