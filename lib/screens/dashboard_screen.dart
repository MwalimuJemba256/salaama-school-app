import 'package:flutter/material.dart';
import 'login_screen.dart';

// STUB WIDGETS - So build passes even if real screens missing
class _Stub extends StatelessWidget {
  final String name;
  const _Stub(this.name);
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(name)), body: Center(child: Text("$name - Coming Soon")));
  }
}

class DashboardScreen extends StatelessWidget {
  final String role;
  const DashboardScreen({super.key, this.role = "Admin"});

  Color _getColor() {
    switch(role) {
      case "Admin": return const Color(0xFF0D47A1);
      case "Head Teacher": return const Color(0xFF1B5E20);
      case "D.O.S": return const Color(0xFFE65100);
      case "Bursar": return const Color(0xFF4A148C);
      case "Teacher": return const Color(0xFF01579B);
      case "Tahfiizu Sheikh": return const Color(0xFF004D40);
      case "Parent": return const Color(0xFFBF360C);
      default: return const Color(0xFF0D47A1);
    }
  }

  void _go(BuildContext c, Widget s) => Navigator.push(c, MaterialPageRoute(builder: (_) => s));

  Widget _buildCard(BuildContext context, IconData icon, String title, String sub, Color color, VoidCallback onTap) {
    return Card(elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(padding: const EdgeInsets.all(14),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 10, color: Colors.grey[600]), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _buildWideCard(BuildContext context, IconData icon, String title, String sub, Color color, VoidCallback onTap, {bool isFull = false}) {
    return Card(elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(padding: const EdgeInsets.all(16), width: isFull ? double.infinity : null,
          child: Row(children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ]),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: Row(children: [
          Container(width: 36, height: 36, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(2),
            child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover, errorBuilder: (_,__,___)=> Icon(Icons.school, color: color, size: 20))),
          ),
          const SizedBox(width: 10),
          Text("$role Dashboard", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        actions: [
          IconButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false), icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
          children: [
            _buildCard(context, Icons.people_alt, "Students", "Manage All", const Color(0xFF1565C0), () => _go(context, const _Stub("Students"))),
            _buildCard(context, Icons.badge_rounded, "Staff", "Teaching/Non", const Color(0xFF2E7D32), () => _go(context, const _Stub("Staff"))),
            _buildCard(context, Icons.class_, "Classes", "Streams", const Color(0xFFEF6C00), () => _go(context, const _Stub("Classes"))),
            _buildCard(context, Icons.how_to_reg, "Attendance", "Daily", const Color(0xFF00838F), () => _go(context, const _Stub("Attendance"))),
            _buildCard(context, Icons.schedule, "Timetable", "Lessons", const Color(0xFF6A1B9A), () => _go(context, const _Stub("Timetable"))),
            _buildCard(context, Icons.grade, "Exams", "Results", const Color(0xFFC62828), () => _go(context, const _Stub("Exams"))),
            _buildCard(context, Icons.menu_book_rounded, "Tahfiizu", "Qur'an", const Color(0xFF00695C), () => _go(context, const _Stub("Tahfiizu"))),
            _buildCard(context, Icons.payments, "Fees", "Payments", const Color(0xFF2E7D32), () => _go(context, const _Stub("Fees"))),
            _buildCard(context, Icons.account_balance_wallet, "Cashflow", "Income", Colors.purple, () => _go(context, const _Stub("Cashflow"))),
            _buildCard(context, Icons.chat_bubble_rounded, "Chat", "Staff•Parent", const Color(0xFF283593), () => _go(context, const _Stub("Chat"))),
            _buildCard(context, Icons.campaign_rounded, "Notices", "News", const Color(0xFF0277BD), () => _go(context, const _Stub("Notices"))),
            _buildCard(context, Icons.settings, "Settings", "School Info", Colors.blueGrey, () => _go(context, const _Stub("Settings"))),
          ],
        ),
      ),
    );
  }
}
