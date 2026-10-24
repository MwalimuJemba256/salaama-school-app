import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/salaama_appbar.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SalaamaAppBar(
        title: 'Admin Dashboard - Salaama',
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            // 1. REGISTER CHILD - With Photo
            _card(context, Icons.child_care, 'Register Child', 'With Photo', const Color(0xFF0D5A2D), '/register_child', null),
            
            // 2. TEACHER LIST - Secular/Theology Filter
            _card(context, Icons.school, 'Teachers', 'Secular & Theology\nSecular: English, Math, Science, SST\nTheology: Quran Hifz/Tafsir/Tajwid, Fiqh, Tarbia Tauhid/Siirah/Hadith, Lugha', const Color(0xFF1E3A8A), '/teacher_list', null),
            
            // 3. OTHER STAFF - Cook, Guard, Cleaner, Driver, Matron, Secretary
            _card(context, Icons.work, 'OTHER Staff', 'Cook, Guard, Cleaner\nDriver, Matron, Secretary', Colors.brown, '/other_staff', null),
            
            // 4. TIMETABLE - Refillable Secular + Theology
            _card(context, Icons.schedule, 'Timetable', 'Refillable\nSecular + Theology\nQuran=Hifz/Tafsir/Tajwid\nTarbia=Tauhid/Siirah/Hadith', Colors.orange, '/timetable', null),
            
            // 5. STUDENTS LIST - To view detail + Generate PDF EN/AR
            _card(context, Icons.people, 'Students', '1,250 - Tap to view\nID Card PDF EN/عربي\nReport Quran, Fiqh, Tarbia, Lugha', Colors.blue, '/students_list', null),
            
            // 6. LEFT STUDENTS - Archive
            _card(context, Icons.person_off, 'Left Students', 'Graduated, Transferred\nWith Photo + Reason', Colors.red, '/left_students', null),
            
            // 7. DOCUMENTS - PDF + PNG EN/AR
            _card(context, Icons.picture_as_pdf, 'Documents', 'ID Card, Report\nHifz Certificate\nPDF + PNG + Share', Colors.purple, '/documents', null),
            
            // 8. FEES - Bursar
            _card(context, Icons.payments, 'Fees', 'UGX 45M', Colors.green, '/fees', null),
            
            // 9. SETTINGS
            _card(context, Icons.settings, 'Settings', '8 Roles\nAdmin, Head Teacher, DOS\nBursar, Teacher, Tahfiizu, Parent, OTHER', Colors.grey, '/settings', null),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, IconData icon, String title, String subtitle, Color color, String route, Map<String, dynamic>? args) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (route == '/students_list' || route == '/left_students' || route == '/documents' || route == '/fees' || route == '/settings') {
            // Coming soon - Show snackbar for now
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: color, content: Text('$title - Coming Soon! Use $route')),
            );
          } else {
            // Real navigation - Uses routes from main.dart
            if (args != null) {
              Navigator.pushNamed(context, route, arguments: args);
            } else {
              Navigator.pushNamed(context, route);
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 8),
                Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
                const SizedBox(height: 4),
                Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: Colors.black54), maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
