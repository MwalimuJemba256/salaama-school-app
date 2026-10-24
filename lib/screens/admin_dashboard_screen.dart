import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: Row(children: [
          Container(width: 38, height: 38, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: ClipRRect(borderRadius: BorderRadius.circular(19), child: Image.asset('assets/images/logo.png', errorBuilder: (c,e,s) => const Icon(Icons.school, color: Color(0xFF1E40AF))))),
          const SizedBox(width: 10),
          const Text('Admin Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async { await FirebaseAuth.instance.signOut(); if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r)=>false); })],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _card(context, Icons.people, const Color(0xFF2563EB), 'Students', 'Manage All', '/students_list'),
            _card(context, Icons.badge, const Color(0xFF15803D), 'Staff', 'Teaching/Non', '/staff_tab'),
            _card(context, Icons.menu_book, Colors.orange[700]!, 'Classes', 'Streams', '/classes'),
            _card(context, Icons.how_to_reg, const Color(0xFF0F766E), 'Attendance', 'Daily', '/attendance'),
            _card(context, Icons.schedule, Colors.purple[700]!, 'Timetable', 'Lessons', '/timetable'),
            _card(context, Icons.star, Colors.red[700]!, 'Exams', 'Results', '/exams'),
            _card(context, Icons.auto_stories, const Color(0xFF065F46), 'Tahfiizu', 'Qur\'an', '/tahfiizu'),
            _card(context, Icons.payments, const Color(0xFF15803D), 'Fees', 'Payments', '/fees'),
            _card(context, Icons.account_balance_wallet, Colors.purple[700]!, 'Cashflow', 'Income', '/cashflow'),
            _card(context, Icons.chat, const Color(0xFF1E40AF), 'Chat', 'Staff+Parent', '/chat'),
            _card(context, Icons.campaign, const Color(0xFF0284C7), 'Notices', 'News', '/notices'),
            _card(context, Icons.settings, Colors.grey[700]!, 'Settings', 'School Info', '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, IconData icon, Color color, String title, String subtitle, String route) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ]),
      ),
    );
  }
}
