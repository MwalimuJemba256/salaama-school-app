import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

// Import all screens
import 'students_screen.dart';
import 'teachers_screen.dart';
import 'classes_screen.dart';
import 'fees_screen.dart';
import 'tahfiizu_screen.dart';
import 'attendance_screen.dart';
import 'timetable_screen.dart';
import 'exams_screen.dart';
import 'chat_screen.dart';
import 'cashflow_screen.dart';
import 'settings_screen.dart';
import 'notices_screen.dart';
import '../login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: SalaamaAppBar(
        title: "Salaama Admin",
        backgroundColor: const Color(0xFF0D47A1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATS ROW
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snap) {
                final studentsCount = snap.data?.docs.length ?? 0;
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
                  builder: (context, snap2) {
                    final teachersCount = snap2.data?.docs.length ?? 0;
                    return Row(
                      children: [
                        _statCard("Students", "$studentsCount", Colors.blue, Icons.people),
                        const SizedBox(width: 10),
                        _statCard("Staff", "$teachersCount", Colors.green, Icons.badge),
                        const SizedBox(width: 10),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('cashflow').where('type', isEqualTo: 'Income').snapshots(),
                          builder: (context, cashSnap) {
                            double total = 0;
                            if (cashSnap.hasData) {
                              for (var d in cashSnap.data!.docs) total += (d['amount'] ?? 0);
                            }
                            return _statCard("Income", "UGX ${total.toInt()}", Colors.purple, Icons.wallet);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 18),

            const Text("ACADEMICS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
              children: [
                _buildCard(context, Icons.people_alt, "Students", "Manage All", const Color(0xFF1565C0), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentsScreen()))),
                _buildCard(context, Icons.badge_rounded, "Staff", "Teaching/Non\nSecular/Theo", const Color(0xFF2E7D32), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachersScreen()))),
                _buildCard(context, Icons.class_, "Classes", "Streams", const Color(0xFFEF6C00), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassesScreen()))),
                _buildCard(context, Icons.how_to_reg, "Attendance", "Daily", const Color(0xFF00838F), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()))),
                _buildCard(context, Icons.schedule, "Timetable", "Lessons", const Color(0xFF6A1B9A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen()))),
                _buildCard(context, Icons.grade, "Exams", "Results", const Color(0xFFC62828), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamsScreen()))),
              ],
            ),
            const SizedBox(height: 18),

            const Text("TAHFIIZU - QURAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
              children: [
                _buildCard(context, Icons.menu_book_rounded, "Tahfiizu", "Darsu\nDarsu Sitta\nMuraaji'a", const Color(0xFF00695C), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TahfiizuScreen()))),
                _buildCard(context, Icons.payments, "Fees", "Structure\nPayments", const Color(0xFF2E7D32), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeesScreen()))),
                _buildCard(context, Icons.account_balance_wallet, "Cashflow", "Income\nExpense", Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CashflowScreen()))),
              ],
            ),
            const SizedBox(height: 18),

            const Text("COMMUNICATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                _buildWideCard(context, Icons.chat_bubble_rounded, "Salaama Chat", "Staff • Parents • General", const Color(0xFF283593), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
                _buildWideCard(context, Icons.campaign_rounded, "Notices", "Announcements", const Color(0xFF0277BD), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NoticesScreen()))),
              ],
            ),
            const SizedBox(height: 18),

            _buildWideCard(context, Icons.settings, "Settings", "School Info", Colors.blueGrey, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())), isFull: true),

            const SizedBox(height: 30),
            const Center(child: Text("SALAAMA MUSLIM JUNIOR SCHOOL\nDESTINED TO SUCCEED", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 26)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _buildWideCard(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap, {bool isFull = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: isFull ? double.infinity : null,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ]),
      ),
    );
  }
}
