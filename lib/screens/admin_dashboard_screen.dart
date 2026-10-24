import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      {'title': 'Students', 'icon': Icons.school, 'color': const Color(0xFF0D5A2D), 'route': '/students_list', 'count': '1,250'},
      {'title': 'Staff', 'icon': Icons.people, 'color': const Color(0xFF1E40AF), 'route': '/staff_tab', 'count': '45'},
      {'title': 'Classes', 'icon': Icons.class_, 'color': Colors.orange, 'route': '/classes', 'count': '12'},
      {'title': 'Attendance', 'icon': Icons.fact_check, 'color': const Color(0xFF0F766E), 'route': '/attendance', 'count': 'Daily'},
      {'title': 'Timetable', 'icon': Icons.calendar_month, 'color': const Color(0xFF7C3AED), 'route': '/timetable', 'count': 'Live'},
      {'title': 'Exams', 'icon': Icons.quiz, 'color': Colors.red, 'route': '/exams', 'count': 'Results'},
      {'title': 'Tahfiizu', 'icon': Icons.auto_stories, 'color': const Color(0xFF065F46), 'route': '/tahfiizu', 'count': 'Juz 1-30'},
      {'title': 'Fees', 'icon': Icons.payments, 'color': Colors.green, 'route': '/fees', 'count': 'UGX 45M'},
      {'title': 'Cashflow', 'icon': Icons.account_balance_wallet, 'color': Colors.purple, 'route': '/cashflow', 'count': 'Income'},
      {'title': 'Chat', 'icon': Icons.chat, 'color': const Color(0xFF1E40AF), 'route': '/chat', 'count': 'Live'},
      {'title': 'Media Center', 'icon': Icons.video_library, 'color': Colors.redAccent, 'route': '/school_media', 'count': 'Video+Audio'},
      {'title': 'Notices', 'icon': Icons.notifications, 'color': Colors.amber, 'route': '/notices', 'count': 'All'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: const Text('Salaama - Admin Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if(context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r)=>false);
              }
            },
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
        itemCount: cards.length,
        itemBuilder: (c,i) {
          final card = cards[i];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, card['route'] as String),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: (card['color'] as Color).withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: (card['color'] as Color).withOpacity(0.12), shape: BoxShape.circle), child: Icon(card['icon'] as IconData, color: card['color'] as Color, size: 28)),
                const SizedBox(height: 10),
                Text(card['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(card['count'] as String, style: TextStyle(fontSize: 11, color: card['color'] as Color, fontWeight: FontWeight.bold)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
